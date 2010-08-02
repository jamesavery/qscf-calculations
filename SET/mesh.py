#!/usr/bin/env python

from numpy import array;
from sys import stderr;

class Volume:

    def __init__(self,lowerleft,dims,name=""):
        ll = array(lowerleft);
        self.points = [ll+[0,0,0], ll+[0,0,dims[2]],ll+[dims[0],0,dims[2]],ll+[dims[0],0,0],
                       ll+[0,dims[1],0],ll+[0,dims[1],dims[2]],ll+[dims[0],dims[1],dims[2]],ll+[dims[0],dims[1],0]];
        self.points = [(round(x,5),round(y,5),round(z,5)) for (x,y,z) in self.points];
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

        self.xs = [round(x,5) for x in xs];
        self.ys = [round(x,5) for x in ys];
        self.zs = [round(x,5) for x in zs];

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

    
    def gmshBoxesAllpoints(self):
        (xs,ys,zs)   = (self.xs,self.ys,self.zs);
        box_volumes  = [Volume(self.lowerlefts[i],self.lengths[i],i)
                        for i in range(len(self.lengths))];
        volume_names = [self.identifyBox(V) for V in box_volumes];
        
        all_points = [(x,y,z) for x in xs for y in ys for z in zs];
        pointmap   = {};
        linemap    = {};
        surfacemap = {};
        
        script = "// All points\n";
        for i in range(len(all_points)):
            (x,y,z) = all_points[i];
            pointmap[(x,y,z)] = i+1;
            script += "Point(%d) = {%g,%g,%g};\n" % (i+1,x,y,z);

        xlines = [(pointmap[(xs[i], y,z)], pointmap[(xs[i+1],y,z)])
                  for i in range(len(xs)-1) for y in ys for z in zs];
        ylines = [(pointmap[(x,ys[i],z)], pointmap[(x,ys[i+1],z)])
                  for i in range(len(ys)-1) for x in xs for z in zs];
        zlines = [(pointmap[(x,y,zs[i])], pointmap[(x,y,zs[i+1])])
                  for i in range(len(zs)-1) for x in xs for y in ys];

        all_lines = xlines;
        all_lines.extend(ylines);
        all_lines.extend(zlines);

        script += "\n\n// All lines\n";
        script += "// X-lines\n";
        for i in range(len(xlines)):
            (p0,p1) = xlines[i];
            ID = i+1;
            linemap[(p0,p1)] = str(ID);
            linemap[(p1,p0)] = "-"+str(ID);
            script += "Line(%d) = {%d,%d};\n" % (ID,p0,p1);

        script += "// Y-lines\n";
        for i in range(len(ylines)):
            (p0,p1) = ylines[i];
            ID = i+1+len(xlines);
            linemap[(p0,p1)] = str(ID);
            linemap[(p1,p0)] = "-"+str(ID);
            script += "Line(%d) = {%d,%d};\n" % (ID,p0,p1);

        script += "// Z-lines\n";
        for i in range(len(zlines)):
            (p0,p1) = zlines[i];
            ID = i+1+len(xlines)+len(ylines)
            linemap[(p0,p1)] = str(ID);
            linemap[(p1,p0)] = "-"+str(ID);
            script += "Line(%d) = {%d,%d};\n" % (ID,p0,p1);

        script += "Transfinite Line{%s} = 1;\n" % ",".join([str(i) for i in
                                                            range(1,len(all_lines)+1)]);

        boxloops = [(0,1,2,3),
                    (0,1,5,4),
                    (0,3,7,4),
                    (1,2,6,5),
                    (2,3,7,6),
                    (4,5,6,7)];

        script += "\n\n// All loops\n"
        for i in range(len(box_volumes)):
            P = [pointmap[tuple(p)] for p in box_volumes[i].points];
            for j in range(len(boxloops)):
                loop     = boxloops[j];
                loop_id  = i*6+j+1;
                
                line_ids = [linemap[(P[loop[k]],P[loop[(k+1)%4]])] for k in range(4)];
                script += "Line Loop(%d) = {%s,%s,%s,%s};\n" % (loop_id,line_ids[0],line_ids[1],
                                                                line_ids[2],line_ids[3]);
                script += "Ruled Surface(%d) = {%d};\n" % (loop_id,loop_id);

            script += "Surface Loop(%d) = {%d,%d,%d,%d,%d,%d};\n"  % (
                i+1, i*6+1,i*6+2,i*6+3,i*6+4,i*6+5,i*6+6 );

        script += "Transfinite Surface{%s};\n" % ",".join([str(i) for i in
                                                           range(1,6*len(box_volumes)+1)]);
        script += "Recombine Surface{%s};\n" % ",".join([str(i) for i in
                                                         range(1,6*len(box_volumes)+1)]);

        script += "\n\n// All volumes\n"
        for i in range(len(box_volumes)):
            script += "Volume(%d) = {%d};\n" % (i+1,i+1);
            script += "Transfinite Volume{%d};\n" % (i+1);
            
        return script;
