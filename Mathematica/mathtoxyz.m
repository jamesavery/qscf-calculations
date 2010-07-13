writexyz[filename_,molecule_]:=Module[{f,name,Nel,x,y,z},
  f = OpenWrite[filename];
  WriteString[f,Length[molecule],"\n"];
  Do[
    {name,Nel,{x,y,z}} = molecule[[i]];
    WriteString[f," ",name," \t",x," \t",y," \t",z,"\n"],
    {i,Length[molecule]}
  ];
  Close[f];
];
  