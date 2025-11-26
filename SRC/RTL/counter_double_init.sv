// Arthur DORADOUX - Projet ASCON
// permutation.sv
// Ce module permet d'initialiser le compteur de rondes à 0 ou 4 en fonction de si on souhaite faire 12 ou 8 rondes.
// 27/03/2025
// Ce module a été donné. J'ai uniquement commenté le code.


`timescale  1ns/1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps.

module counter_double_init import ascon_pack::*;( // On importe ascon_pack qui contient le type type_state et les valeurs de a (12) et b (8).
	input logic			clock_i,	// Horloge
	input logic			resetb_i,	// Reset
	input logic			ena_i,		// Signal d'activation du compteur
	input logic			init_a_i,	// Initialisation du compteur à 0
	input logic			init_b_i,	// Initialisation du compteur à 4
	output logic [3:0]	count_o		// Compteur retourné initialisé
);


	// Compteur interne 
	logic [3:0]	count_s;

	always @(posedge clock_i, negedge resetb_i) begin // Lorsque le reset s'active ou au fronts montants de l'horloge, on réalise les actions suivantes :
		if (resetb_i == 1'b0) begin			// Si le reset est activé, on met le compteur à 0
			count_s <= 0;
		end
		else begin							// Sinon :
			if (ena_i == 1'b1) begin		// Si on veut initialiser le compteur
				if (init_a_i == 1'b1)		// Si on veut l'initialiser à 0 :
					count_s <= 0;			// On l'initialise à 0
				else if (init_b_i == 1'b1)	// Sinon, si on veut l'initialiser à 4 :
					count_s <= a-b;			// a - b = 12 - 8 = 4 donc on initialise bien le compteur à 4
				else
					count_s <= count_s + 1;	// Sinon, on incrémente le compteur
			end
		end
	end // always @ (posedge clock_i, negedge resetb_i)

	assign count_o = count_s; // Le compteur de sortie prend la valeur du compteur interne 
	
endmodule // counter_double_init
