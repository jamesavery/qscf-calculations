
VEtable[M_] := Module[{Vect,qs,Vgs,Hs},
  (* Exp1: Parameter order: {"charge", "Vg", "oxideH"} *)
  (* Exp2: Parameter order: {"charge", "Vg", "dist_y"} *)
  (* Exp3: Parameter order: {"charge", "Vg", "dist_x"} *)
  {qs,Vgs,P} = M["params"];

  Vect  = Table[{Vgs[[k]],M["energytable"][[i,k,j]],M["convergedtable"][[i,k,j]]},
                {i,Length[qs]},{j,Length[P]},{k,Length[Vgs]}];

  VE = Table[{#[[1]],#[[2]]}& /@ Select[Vect[[i,j]], #[[3]] == True&],{i,Length[qs]},{j,Length[P]}];

  Return[Select[#,#!={}&]&/@VE];
];

VElines[M_] := Module[{VE,qs,Vgs,P,lines},
  {qs,Vgs,P} = M["params"];
  VE = VEtable[M];

  lines = Table[Fit[VE[[i,j]],{1,Vg},Vg],{i,Length[qs]},{j,Length[P]}];

  Return[lines];
];

DEtable[M_,qa_,qb_] := linearCombination[M,{1,-1},{qa,qb}];

Needs["ComputerArithmetic`"];
linearCombination[M_,cs_,lqs_] := Module[{qs,Vgs,P,Es,et,ct,DE},
  {qs,Vgs,P} = M["params"];

  is = findindex[qs,#] &/@ lqs;
  Print[is];
  
  {et,ct} = {M["energytable"],M["convergedtable"]};

  Es = Table[If[ct[[is[[i]],k,j]], cs[[i]]*et[[is[[i]],k,j]], NaN], 
             {j,Length[P]},{k,Length[Vgs]},{i,Length[is]}];

  (* Remove NaN *)
  DE = Table[{Vgs[[k]],Total[Es[[j,k]]]},{j,Length[P]},{k,Length[Vgs]}];

  Return[DE];
];

