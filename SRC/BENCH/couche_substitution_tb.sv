// Arthur DORADOUX - Projet ASCON
// couche_substitution_tb.sv
// Test bench de la couche de substitution p_s
// 17/03/2025


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module couche_substitution_tb import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state
);
	
// Déclaration des signaux internes

	type_state substitution_i_s;	// État d'entrée interne
	type_state substitution_o_s;	// État de sortie interne 


// Instanciation du module "couche_substitution"

	couche_substitution DUT (		
		.substitution_i(substitution_i_s),
		.substitution_o(substitution_o_s)
	);

	initial begin
		// On met l'état d'entrée à la valeur qu'il a après la première addition de constante "c_0"
		substitution_i_s = {64'h00001000808c0001, // S_0
							64'h6cb10ad9ca912f80, // S_1
							64'h691aed630e8190ef, // S_2
							64'h0c4c36a20853217c, // S_3
							64'h46487b3e06d9d7a8};// S_4

		// On patiente 10 ns
		#10;
	end 

endmodule : couche_substitution_tb
