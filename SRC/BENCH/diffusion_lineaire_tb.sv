// Arthur DORADOUX - Projet ASCON
// diffusion_lineaire_tb.sv
// Test bench du module de diffusion linéaire représentant la couche p_l
// 17/03/2025


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module diffusion_lineaire_tb import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state
);

// Déclaration des signaux internes

	type_state diffusion_i_s;		// État interne pour l'entrée
	type_state diffusion_o_s;		// État interne pour la sortie


// Instanciation du module "diffusion_lineaire" avec nos signaux internes

	diffusion_lineaire DUT (
		.diffusion_i(diffusion_i_s),
		.diffusion_o(diffusion_o_s)
	);

	initial begin
		// On initialise l'état d'entrée à la valeur de l'état après la avoir ajouté la constante "c_0" et être passé dans la S-box
		diffusion_i_s = {64'h25f7c341c45f9912, 	// S_0
						64'h23b794c540876856, 	// S_1
						64'hb85451593d679610, 	// S_2
						64'h4fafba264a9e49ba, 	// S_3
						64'h62b54d5d460aded4};	// S_4

		// On patiente 10 ns
		#10; 
	end 

endmodule : diffusion_lineaire_tb
