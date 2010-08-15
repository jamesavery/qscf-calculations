VEtable[M_] := Module[{Vect,qs,Vgs,Hs},
  (* Exp1: Parameter order: {"charge", "Vg", "oxideH"} *)
  (* Exp2: Parameter order: {"charge", "Vg", "dist_y"} *)
  (* Exp3: Parameter order: {"charge", "Vg", "dist_x"} *)
  {qs,Vgs,P} = M["params"];

  Vect  = Table[{Vgs[[k]],M["energytable"][[i,k,j]],M["convergedtable"][[i,k,j]]},
                {i,Length[qs]},{j,Length[P]},{k,Length[Vgs]}];

  VE = Table[{#[[1]],#[[2]]}& /@ Select[Vect[[i,j]], #[[3]] == True&],{i,Length[qs]},{j,Length[P]}];

  Return[VE];
];

VElines[M_] := Module[{VE,qs,Vgs,P,lines},
  {qs,Vgs,P} = M["params"];
  VE = VEtable[M];

  lines = Table[Fit[VE[[i,j]],{1,Vg},Vg],{i,Length[qs]},{j,Length[P]}];

  Return[lines];
];