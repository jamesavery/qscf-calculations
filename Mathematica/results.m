getData[molecule_,dE_,exp1_,exp2_] := Module[{info,tidx,tE,dims,order,data,params,energy},
  rootdir = Environment["OPV"];
  Get[rootdir<>"/results/"<>molecule<>"/"<>ToString[dE]<>"/"<>exp1<>"-"<>exp2<>".m"];

  Which[
  {exp1,exp2}=={"vacuum","Exp1"}, 
      Print["vacuum"];
      info["order"] = {"q"}; 
      info["data"] = Sort[propertylist];
      info["q"] = #[[1]]&/@ info["data"];
      info["energy"] = #[[2]]&/@ info["data"];
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
      info["energy"] = #[[2]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp1"},
      info["order"] = {"q","Vg","oxideH"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["oxideH"] = #[[1,3]]&/@ info["data"];
      info["energy"] = #[[2]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp2"},
      info["order"] = {"q","Vg","dist_y"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["dist_y"] = #[[1,3]]&/@ info["data"];
      info["energy"] = #[[2]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp3"},
      info["order"] = {"q","Vg","dist_x"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["dist_x"] = #[[1,3]]&/@ info["data"];
      info["energy"] = #[[2]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp4"},
      info["order"] = {"q","Vsd","dist_x"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["dist_x"] = #[[1,3]]&/@ info["data"];
      info["energy"] = #[[2]]&/@ info["data"];
  ];
					     
  If[Length[info["order"]]>1,
      order  = info["order"];
      data   = info["data"];
      energy = #[[2]]& /@ data;
      params = Union[info[#]]& /@ order;
      dims   = Length /@ params;
      muls   = Table[Product[dims[[i]],{i,j,Length[dims]}],{j,2,Length[dims]}];
      
      Switch[Length[order],
        2,
          tidx = Outer[{#1,#2}&,params[[1]],params[[2]]];
          tE   = Table[energy[[(i-1)*muls[[1]]+j]],{i,Length[params[[1]]]},{j,Length[params[[2]]]}];
        3,
          tidx = Outer[{#1,#2,#3}&,params[[1]],params[[2]],params[[3]]];
          tE   = Table[energy[[(i-1)*muls[[1]]+(j-1)*muls[[2]]+k]],
                {i,Length[params[[1]]]},{j,Length[params[[2]]]},{k,Length[params[[3]]]}];
        4,
          tidx = Outer[{#1,#2,#3,#4}&,params[[1]],params[[2]],params[[3]],params[[4]]];
          tE   = Table[energy[[(i-1)*muls[[1]]+(j-1)*muls[[2]]+(k-1)*muls[[3]]+l]],
                {i,Length[params[[1]]]},{j,Length[params[[2]]]},
                {k,Length[params[[3]]]},{l,Length[params[[4]]]}];
      ];
      info["params"]      = params;
      info["dims"]        = dims;
      info["indextable"]  = tidx;
      info["energytable"] = tE;
  ];
  Return[info];
];