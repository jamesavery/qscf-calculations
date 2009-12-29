(* B3LYP-optimized OPV5 molecule (without tertbutyl endings);
Reference calculations done with Firefly. *)

eV = 0.0367493254;                              (* 1eV in Hartrees *)

qscfold = {-7214.1756eV,-7210.7773eV,-7206.9821eV,-7200.9957eV,-7194.7354eV};
qscfnew = {-7172.2785eV,-7173.0885eV,-7171.6652eV,-7166.2560eV,-7158.7107eV};

(* LDA exchange/correlation-functional, cc-pVDZ basis set *)
ldad   = {-2227.3485633665, -2227.4149059933, -2227.3930891472, -2227.2261710943, -2222.9970992099};
(* LSDA exchange/correlation-functional, cc-pVDZ basis set - why is this identical to LDA results? *)
lsdad  = {-2227.3485633665, -2227.4149059933, -2227.3930891472, -2227.2261710943, -2222.9970992099};
(* PBE96 exchange/correlation-functional, cc-pVDZ basis set *)
pbe96d = {-2260.4073336304, -2260.4346968200, -2260.3737870935, -2260.1658030828, -2256.0534807774};
(* PW91 exchange/correlation-functional, cc-pVDZ basis set *)
pw91d  = {-2262.0307492102, -2262.0567652743, -2261.9944778331, -2261.7851198581, -2257.6523270973};
(* B3LYP exchange/correlation-functional, cc-pVDZ basis set *)
b3lypd = {-2262.6417846645, -2262.6802904387, -2262.6292713858, -2262.4110833312, -2262.1072689077};


