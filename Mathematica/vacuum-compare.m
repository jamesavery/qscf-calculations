Get[Environment["OPV"]<>"/../Mathematica/results.m"];
Needs["ComputerArithmetic`"];

Delta[t_] := Table[{t[[i+1,1]],t[[i+1,2]] - t[[i,2]]}, {i, Length[t] - 1}];
Hartrees = 27.21138386;

vacuumData[molecule_,dE_]:= Module[{M,cqe},
  M = getData[molecule, dE, "vacuum", "Exp1"];

  cqe = zip[M["converged"],zip[M["q"],M["energy"]]];

  Return[ #[[2]]& /@ Select[cqe,#[[1]] == True&] ];
];

vzeroData[molecule_,dE_]:= Module[{M,cqe,qs,Vgs,Vsds,v0},
  M = getData[molecule, dE, "Vzero", "SET"];

  {qs,Vgs,Vsds} = M["params"];
  v0 = findindex[Vgs,0];

  cqe = Table[{M["convergedtable"][[i,v0,1]],{qs[[i]],M["energytable"][[i,v0,1]]}},{i,Length[qs]}];

  Return[ #[[2]]& /@ Select[cqe,#[[1]] == True&] ];
];

vzeroData[molecule_] := Module[{dEs},
  dEs = getRefinements[molecule,"Vzero-SET"];
  
  Return[ vzeroData[molecule,#] &/@ dEs ];
];



vacuumData[molecule_] := Module[{dEs},
  dEs = getRefinements[molecule,"vacuum-Exp1"];
  
  Return[ vacuumData[molecule,#] &/@ dEs ];
];

vacuumCheck[program_,molecule_] := Module[{olist,M,Ms,functional,basis},
  olist = getCheckList[program,molecule]; 
  Ms = Table[
    Module[{functional,basis},
      {functional,basis} = olist[[i]];
      getCheck[program,molecule,functional,basis]
    ], {i,Length[olist]}
  ];
  Return[{olist,Ms}];
];



checkPlot[tecs_,list_,plotlabel_] := Module[{fits0,g1,g2},

  fits0 = Fit[fromzero[#],{1,q,q^2},q] & /@ tecs;

  g1 = ListPlot[Delta /@ tecs, Joined -> True, 
  PlotStyle -> PointSize -> 0.01, PlotMarkers -> Automatic, 
  ImageSize -> 500, AxesLabel -> {q, "\!\(\*
  StyleBox[SuperscriptBox[\"E\", 
  RowBox[{\"q\", \"+\", \"1\"}]],\nFontSlant->\"Italic\"]\)\!\(\*
  StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
  StyleBox[SuperscriptBox[\"E\", \"q\"],\nFontSlant->\"Italic\"]\) in \
  eV"}, PlotLabel -> plotlabel, 
  PlotLegend -> FileNameJoin /@ list, LegendSize -> {.7, .4}, 
  LegendPosition -> {-1, .2}];

  g2 = Show[
  Plot[fits0, {q, -3, 3}],
  ListPlot[fromzero /@ tecs, Joined -> False, 
  PlotStyle -> PointSize -> 0.01, PlotMarkers -> Automatic],
  ImageSize -> 500, AxesLabel -> {q, "\!\(\*
  StyleBox[SuperscriptBox[\"E\", \"q\"],\n\
  FontSlant->\"Italic\"]\)\!\(\*
  StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
  StyleBox[SuperscriptBox[\"E\", \"0\"],\nFontSlant->\"Italic\"]\) in \
  eV"}, PlotLabel -> plotlabel
  ];

  Return[{g1,g2}];
];

compareNumbers[qes_] := Module[{allqs,square},
  allqs = Union @@ (First /@ #& /@ qes);

  square = Table[
    Module[{match},
        match = Select[qes[[i]],#[[1]] == allqs[[j]]&];
        If[match == {},NaN,match[[1,2]]]
    ],{i,Length[qes]},{j,Length[allqs]}];

  Return[{allqs,square}];
];
