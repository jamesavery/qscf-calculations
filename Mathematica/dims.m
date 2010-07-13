name = Environment["molecule"];
basis    = Environment["basis"];
hosts    = Environment["hosts"];
		      
If[basis == $Failed,basis = "OPV5basis"];
If[hosts == $Failed,hosts = "all"];

SetDirectory[Environment["OPV"]];

Get["./Mathematica/"<>name<>".m"];

coords = #[[3]]&/@molecule;
centerofmass = 
 Sum[molecule[[i, 2]]*molecule[[i, 3]], {i, Length[molecule]}]/
  Total[#[[2]] & /@ molecule];
  
{xs, ys, zs} = {#[[1]] & /@ coords, #[[2]] & /@ coords, #[[3]] & /@ coords};

WriteString[Streams[][[1]],"\n'"<>name<>"' => {\n\t"
    <>"hosts => '"<>hosts<>"',\n\t"
    <>"basis => '"<>basis<>".in',\n\t"
    <>"xmin =>", Min[xs], ", xmax => ", Max[xs], ",\n\t"
    <>"ymin =>", Min[ys], ", ymax => ", Max[ys], ",\n\t"
    <>"zmin =>", Min[zs], ", zmax => ", Max[zs], ",\n\t"
    <>"'center of mass' => {'x'=>", CForm[centerofmass[[1]]], "," <> "'y'=>", CForm[centerofmass[[2]]], ", 'z'=>", CForm[centerofmass[[3]]], "}\n}"
     ];

