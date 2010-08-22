zip[a_,b_]     := Table[{a[[i]],b[[i]]},{i,Length[a]}];
unzip[pairs_]  := {#[[1]]&/@pairs,#[[2]]&/@pairs};

getCheck[program_,molecule_,functional_,basis_] := Module[{rootdir,result,k,v,q,e,Hartrees},
  Hartrees = 27.21138386;
  rootdir = Environment["OPV"];
  result = Get[rootdir<>"/results/"<>molecule<>"/"<>program<>"/vacuum.m"];

  {{k,v}} = Select[result,#[[1]] == functional&];
  {{k,v}} = Select[v,#[[1]] == basis&];
  {{k,q}} = Select[v,#[[1]] == "q"&];
  {{k,e}} = Select[v,#[[1]] == "energy"&];
  {{k,converged}} = Select[v,#[[1]] == "converged"&];

  Return[ {q,e,converged} ];
];

getCheckList[program_,molecule_] := Module[{rootdir,result},
  rootdir = Environment["OPV"];
  result = Get[rootdir<>"/results/"<>molecule<>"/"<>program<>"/vacuum.m"];
  Return[ Flatten[Table[{result[[i,1]],result[[i,2,j,1]]},
  {i,Length[result]},{j,Length[result[[i,2]]]}],1] ];
];


getData[molecule_,dE_,exp1_,exp2_] := Module[{info,tidx,tE,dims,order,data,params,energy},
  rootdir = Environment["OPV"];
  Get[rootdir<>"/results/"<>molecule<>"/"<>ToString[dE]<>"/"<>exp1<>"-"<>exp2<>".m"];

  Which[
  {exp1,exp2}=={"vacuum","Exp1"}, 
      (* Print["vacuum"];*)
      info["order"] = {"q"}; 
      info["data"] = Sort[propertylist];
      info["q"] = #[[1]]&/@ info["data"];
      ,
  {exp1,exp2}=={"large","SET"} || 
  {exp1,exp2}=={"Vzero","SET"} || 
  {exp1,exp2}=={"Vzero","SET-2"},
      (* Print["SET"];*)
      info["order"] = {"q","Vg","Vsd"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["Vsd"]    = #[[1,3]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp1"},
      (*Print["SET-lengths/1"];*)
      info["order"] = {"q","Vg","oxideH"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["oxideH"] = #[[1,3]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp2"},
      (* Print["SET-lengths/2"];*)
      info["order"] = {"q","Vg","dist_y"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["dist_y"] = #[[1,3]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp3"},
      (* Print["SET-lengths/3"]; *)
      info["order"] = {"q","Vg","dist_x"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vg"]     = #[[1,2]]&/@ info["data"];
      info["dist_x"] = #[[1,3]]&/@ info["data"];
      ,
  {exp1,exp2}=={"SET-lengths","Exp4"},
      (* Print["SET-lengths/4"]; *)
      info["order"] = {"q","Vsd","dist_x"}; 
      info["data"] = Sort[propertylist];
      info["q"]      = #[[1,1]]&/@ info["data"];
      info["Vsd"]     = #[[1,2]]&/@ info["data"];
      info["dist_x"] = #[[1,3]]&/@ info["data"];
  ];

  info["energy"] = #[[2]]&/@ info["data"];
  info["HLN"]    = #[[3]]&/@ info["data"];
  info["converged"] = #[[4]]& /@ info["data"];

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
      info["convergedtable"] = reshape[#[[4]]&/@data,dims];
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
      info["convergedtable"] = info["converged"];
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

getList[] := Module[{results,molecules,dEs,expts,LM},
  results = Drop[#,1]& /@ (FileNameSplit /@ FileNames["*",{"results"},Infinity]);
  results = {#[[1]],#[[2]],StringDrop[#[[3]],-2]} & /@ Select[results,Length[#] == 3&];

  molecules = Union[#[[1]]& /@ results];
  dEs       = Union[#[[2]]& /@ results];
  expts     = Union[#[[3]]& /@ results];

  LM["Molecule"] = molecules;
  LM["dE"]  = ToExpression/@dEs;
  LM["Exp"] = expts;
  Do[
    LM[molecules[[i]]] = {#[[2]],#[[3]]}&/@Select[results,#[[1]]==molecules[[i]]&];,
    {i,Length[molecules]}
  ];
  Do[
    LM[ToExpression[dEs[[i]]]] = {#[[1]],#[[3]]}&/@Select[results,#[[2]]==dEs[[i]]&];,
    {i,Length[dEs]}
  ];
  Do[
    LM[expts[[i]]] = {#[[1]],#[[2]]}&/@Select[results,#[[3]]==expts[[i]]&];,
    {i,Length[expts]}
  ];
  Return[LM];
];

getRefinements[molecule_,expt_] := First /@ Select[getList[][molecule], #[[2]] == expt&];

convergedpairs[{qs_,es_,cs_}] := Module[{t},
  t = Table[If[cs[[i]],{qs[[i]],es[[i]]},Null],{i,Length[cs]}];
  {#[[1]],#[[2]]}&/@ Select[t, # =!= Null&]
];

findindex[l_,x_] := Do[If[l[[i]] == x, Return[i]],{i,Length[l]}];

fromzero[qes_]:=Module[{i0,qs,es},
  {qs,es} = unzip[qes];
  i0 = findindex[qs,0];
  zip[qs,es-es[[i0]]]
];

