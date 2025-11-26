// Arthur DORADOUX - Projet ASCON
// registre.sv
// Module définissant un registre 
// 27/03/2025
// Module fourni par M. REYMOND dont j'ai modifié les notations et rajouté le signal d'activation


`timescale  1ns/1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module registre import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state.
	input logic	   		clock_i,	// Horloge
	input logic	   		resetb_i,	// Reset
	input logic			enable_i,	// Signal d'activation de l'écriture
	input type_state 	registre_i,	// État d'entrée du registre
	output type_state 	registre_o	// État de sortie du registre
	);


// Fonctionnement du registre

	// J'utilise une logique séquentielle avec "always_ff" pour le registre
	always_ff @ (posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin 	// Si le reset est activé, on remet la valeur du registre à 0
			registre_o <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
		end
		else if (enable_i) begin		// Sinon, si on autorise l'écriture, on stocke la valeur donnée en entrée
			registre_o <= registre_i;
		end								// Sinon, on ne fait rien 
	end

endmodule : registre
