// Arthur DORADOUX - Projet ASCON
// registre_cipher_tag.sv
// Module définissant un registre de 128 bits que l'on va utiliser pour stocker le cipher et le tag. C'est une version modifiée du module "registre"
// 27/03/2025


`timescale  1ns/1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module registre_cipher_tag import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state.
	input logic	   			clock_i,		// Horloge
	input logic	   			resetb_i,		// Reset
	input logic				enable_ct_i,	// Signal d'activation de l'écriture
	input logic [127:0]		data_i,			// Donnée d'entrée du registre
	output logic [127:0] 	data_o			// Donnée de sortie du registre
	);


// Fonctionnement du registre

	// J'utilise une logique séquentielle avec "always_ff" pour le registre
	always_ff @ (posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin 	// Si le reset est activé, on remet la valeur du registre à 0
			data_o <= {64'h0, 64'h0};
		end
		else if (enable_ct_i) begin		// Sinon, si on autorise l'écriture, on stocke la valeur donnée en entrée
			data_o <= data_i;
		end								// Sinon, on ne fait rien 
	end

endmodule : registre_cipher_tag
