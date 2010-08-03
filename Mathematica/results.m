getData[molecule_,dE_,exp1_,exp2_] := Module[{info,tidx,tE,dims,order,data,params,energy},
  rootdir = Environment["OPV"];
  Get[rootdir<>"/results/"<>molecule<>"/"<>ToString[dE]<>"/"<>exp1<>"-"<>exp2<>".m"];

  Which[
  {exp1,exp2}=={"vacuum","Exp1"}, 
      Print["vacuum"];
      info["order"] = {"q"}; 
      info["data"] = Sort[propertylist];
      info["q"] = #[[1]]&/@ info["data"];
      ,
  {exp1,exp2}=={"large","SET"} || 
  {exp1,exp2}=={"Vzero","SET"} || 
  {exp1,exp2}=={"Vzero","SET-2"},
      Print["SET"];
      info["order"] = {"q","Vg","Vsd"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["Vsd"]    = #[[1,3]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp1"},
      info["order"] = {"q","Vg","oxideH"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["oxideH"] = #[[1,3]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp2"},
      info["order"] = {"q","Vg","dist_y"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["dist_y"] = #[[1,3]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp3"},
      info["order"] = {"q","Vg","Vsd","dist_x"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["Vsd"]    = #[[1,3]]&/@ info["data"];
      info["dist_x"] = #[[1,4]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp4"},
      info["order"] = {"q","Vsd","dist_x"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vsd"]     = #[[1,2]]&/@ info["data"];
      info["dist_x"] = #[[1,3]]&/@ info["data"];
  ];

  info["energy"] = #[[2]]&/@ info["data"];
  info["HLN"]    = #[[3]]&/@ info["data"];
					     
  If[Length[info["order"]]>1,
      order  = info["order"];
      data   = info["data"];
      params = Union[info[#]]& /@ order;
      dims   = Length /@ params;
      
      info["params"]      = params;
      info["dims"]        = dims;
      info["indextable"]  = reshape[#[[1]]&/@data,dims];
      info["energytable"] = reshape[#[[2]]&/@data,dims];
      info["HOMOtable"]   = reshape[#[[3,1]]&/@data,dims];
      info["LUMOtable"]   = reshape[#[[3,2]]&/@data,dims];
      info["Ntable"]      = reshape[#[[3,3]]&/@data,dims];
      ,
      order  = info["order"];
      data   = info["data"];

      info["params"]      = Union[info[#]]& /@ order;
      info["dims"]        = {1};
      info["indextable"]  = #[[1]]&/@data;
      info["energytable"] = #[[2]]&/@data;
      info["HOMOtable"]   = #[[3,1]]&/@data;
      info["LUMOtable"]   = #[[3,2]]&/@data;
      info["Ntable"]      = #[[3,3]]&/@data;
  ];
  Return[info];
];

reshape[t_,dims_] := Module[{n = Length[dims],tE},
  muls   = Table[Product[dims[[i]],{i,j,Length[dims]}],{j,2,Length[dims]}];

  Switch[n,
        2,
          tE = Table[t[[(i-1)*muls[[1]]+j]],{i,dims[[1]]},{j,dims[[2]]}];
        3,
          tE   = Table[t[[(i-1)*muls[[1]]+(j-1)*muls[[2]]+k]],
                {i,dims[[1]]},{j,dims[[2]]},{k,dims[[3]]}];
        4,
          tE   = Table[t[[(i-1)*muls[[1]]+(j-1)*muls[[2]]+(k-1)*muls[[3]]+l]],
                {i,dims[[1]]},{j,dims[[2]]},
                {k,dims[[3]]},{l,dims[[4]]}];
      ];

  Return[tE];
];