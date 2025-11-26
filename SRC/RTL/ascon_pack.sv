// Arthur DORADOUX - Projet ASCON
// ascon_pack.sv
// Package fourni par le professeur M. REYMOND contenant le type représentant l'état, les constantes "c_r" et les constantes pour le compteur de rondes
// 10/03/2025


package ascon_pack;

	// type représentant l'état "S" de 320 bits en 5 registres de 64 bits
	typedef logic[0:4][63:0] type_state;

	// Constantes "c_r" pour l'addition de constante
	logic [7:0]	 round_constant [0:11] = {8'hF0, 8'hE1, 8'hD2, 8'hC3, 8'hB4, 8'hA5, 8'h96, 8'h87, 8'h78, 8'h69, 8'h5A, 8'h4B};

	// Nombre de rondes pour p^12 et p^8 servant pour le module "fsm_moore" représentant la machine d'état
	logic[3:0]	a = 12;
	logic[3:0]	b = 8;

endpackage : ascon_pack
	
