from numpy import array;

class Volume:

    def __init__(self,lowerleft,dims,name=""):
        ll = array(lowerleft);
        self.points = [ll+[0,0,0], ll+[0,0,dims[2]],ll+[dims[0],0,dims[2]],ll+[dims[0],0,0],
                       ll+[0,dims[1],0],ll+[0,dims[1],dims[2]],ll+[dims[0],dims[1],dims[2]],ll+[dims[0],dims[1],0]];
        self.ll = ll;
        self.dims = array(dims);
        self.name = name;
                       

class Space:

    def __init__(self,dims):
        self.dims  = array(dims);
        self.volumes = [Volume([0,0,0],dims)];
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



