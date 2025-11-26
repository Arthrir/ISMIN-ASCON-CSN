// Arthur DORADOUX - Projet ASCON
// xor_up.sv
// Module réalisant le XOR up sur S_0 et S_1
// 27/03/2025
// Module fourni par M. REYMOND


`timescale  1ns/1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module xor_up import ascon_pack::*;( // On importe ascon_pack qui contient le type type_state.
	input logic [127:0] data_xor_up_i,	// Donnée à utiliser pour le XOR
	input logic 		ena_xor_up_i,	// Signal d'activation du XOR
	input type_state 	state_i,		// État d'entrée
	output type_state 	state_o			// État de sortie
	);


// Modifications de l'état par les XORs

	assign state_o[0] = (ena_xor_up_i) ? state_i[0] ^ data_xor_up_i[63:0] : state_i[0];
	assign state_o[1] = (ena_xor_up_i) ? state_i[1] ^ data_xor_up_i[127:64] : state_i[1];
	assign state_o[2] = state_i[2];
	assign state_o[3] = state_i[3];
	assign state_o[4] = state_i[4];

endmodule : xor_up
