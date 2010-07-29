from numpy import array;

class Volume:

    def __init__(self,lowerleft,dims,name=""):
        ll = array(lowerleft);
        self.points = [ll+[0,0,0], ll+[0,0,dims[2]],ll+[dims[0],0,dims[2]],ll+[dims[0],0,0],
                       ll+[0,dims[1],0],ll+[0,dims[1],dims[2]],ll+[dims[0],dims[1],dims[2]],ll+[dims[0],dims[1],0]];
        self.ll = ll;
        self.dims = array(dims);
        self.name = name;

    def pointInside(self,x):
        return ((x >= self.ll).all() and (x <= self.ll+self.dims).all());

    def containedIn(self,V):
        return ((V.ll >= self.ll).all() and (V.ll+V.dims <= self.ll+self.dims).all());            
        
    def __repr__(self):
        return repr((self.name,self.ll,self.dims));

class Space:

    def __init__(self,dims):
        self.dims  = array(dims);
        self.volumes = [Volume([0,0,0],dims,"World")];
        self.xs = [];
        self.ys = [];
        self.zs = [];

    def addVolume(self,B):
        self.volumes.append(B);

    def buildBoxes(self):
        xs = sorted(list(set([x for V in self.volumes for (x,y,z) in V.points])));
        ys = sorted(list(set([y for V in self.volumes for (x,y,z) in V.points])));
        zs = sorted(list(set([z for V in self.volumes for (x,y,z) in V.points])));

        lowerlefts = [(x,y,z) for x in xs[:-1] for y in ys[:-1] for z in zs[:-1]];
        lengths    = [(xs[i+1]-xs[i],ys[j+1]-ys[j],zs[k+1]-zs[k])
                      for i in range(len(xs)-1)
                      for j in range(len(ys)-1)
                      for k in range(len(zs)-1)];

        self.xs = xs;
        self.ys = ys;
        self.zs = zs;
        self.lowerlefts = lowerlefts;
        self.lengths = lengths;

        return zip(lowerlefts,lengths);

    def identifyBox(self,B):
        return [V.name for V in self.volumes[1:] if V.containedIn(B)];

    def gmshBoxes(self):
        box_volumes  = [Volume(self.lowerlefts[i],self.lengths[i],i) for i in range(len(self.lengths))];
        volume_names = [self.identifyBox(V) for V in box_volumes];

        script = "";
        for i in range(len(box_volumes)):
            V = box_volumes[i];
            script += "// Box %d, contained in %s\n" % (i+1 ,volume_names[i]);
            script += "lowerleft[] = {%g,%g,%g};\n" % (V.ll[0],V.ll[1],V.ll[2]);
            script += "w = %g;\nh = %g;\nd = %g;\nCall BOX;\n\n" % (V.dims[0],V.dims[1],V.dims[2]);

        return script;

    
