Get[Environment["OPV"]<>"/../Mathematica/results.m"];
Needs["ComputerArithmetic`"];

Delta[t_] := Module[{q1,e1,q0,e0,D},
  D = Table[0,{Length[t]-1}];
  Do[
    {q0,e0} = t[[i]];
    {q1,e1} = t[[i+1]];
    D[[i]] = If[q1-q0==1,{q0,e1-e0},
                {q1-1,delta[q1-q0,e1,e0,D[[i-1,2]]]}
             ],
    {i,Length[D]}
  ];
  Return[D];
];

delta[n_,En_,E1_,DE0_] := Module[{a},
  a = 2/(n+1)*((En-E1)/n-DE0);
  Return[DE0+a*n];
]

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



Get["../Mathematica/makelegend.m"];

checkPlotB[tecs_,list_,plotlabel_] := Module[{funs0,legend,g1,g2,llength,flimits,ftable},
  funs0 = Interpolation[fromzero[#],InterpolationOrder->2] & /@ tecs;
  flimits = #[[1,1]]&/@funs0;

  llength = Max[StringLength /@ FileNameJoin /@ list];
  legend = makeLegend[FileNameJoin/@list,
                      {LegendSize->{.2+llength*.05,.08*Length[list]},
                       LegendPosition->{-1.2,0}}];
  ftable = Table[{q,funs0[[i]][q]},{i,Length[funs0]},{q,flimits[[i,1]],flimits[[i,2]],.1}];

  ShowLegend[
    Show[
        ListPlot[ftable, Joined->True,
        PlotStyle->Thick, PlotLabel->plotlabel,
        AxesLabel->{q,"\!\(\*SuperscriptBox[\"E\",q]-\*SuperscriptBox[\"E\",0]\)"}],
        ListPlot[fromzero/@tecs,PlotStyle->PointSize[.018]]
    ],
    legend
  ]
];

checkPlotC[tecs_,list_,plotlabel_] := Module[{fits0,legend,g1,g2},
  llength = Max[StringLength /@ FileNameJoin /@ list];
  legend = makeLegend[FileNameJoin/@list,
                      {LegendSize->{.2+llength*.05,.08*Length[list]},
                       LegendPosition->{-1.2,0}}];

  ShowLegend[
    Show[
        ListPlot[Delta/@tecs,Joined->True,
        PlotStyle->Thick,PlotLabel->plotlabel,
        AxesLabel->{q,"\!\(\*SuperscriptBox[\"E\",\"q+1\"]-\*SuperscriptBox[\"E\",\"q\"]\)"}],
        ListPlot[Delta/@tecs,PlotStyle->PointSize[.018]]
    ],
    legend
  ]
];

checkPlot[tecs_,list_,plotlabel_] := {checkPlotB[tecs,list,plotlabel],checkPlotC[tecs,list,plotlabel]}

compareNumbers[qes_] := Module[{allqs,square},
  allqs = Union @@ (First /@ #& /@ qes);

  square = Table[
    Module[{match},
        match = Select[qes[[i]],#[[1]] == allqs[[j]]&];
        If[match == {},NaN,match[[1,2]]]
    ],{i,Length[qes]},{j,Length[allqs]}];

  Return[{allqs,square}];
];
