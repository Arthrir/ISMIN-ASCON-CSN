// Arthur DORADOUX - Projet ASCON
// xor_down.sv
// Module réalisant le XOR down sur S_2, S_3 et S_4
// 27/03/2025
// Module fourni par M. REYMOND


`timescale  1ns/1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module xor_down import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state.
	input logic [191:0] data_xor_down_i,// Donnée à utiliser pour le XOR
	input logic		 	ena_xor_down_i,	// Signal d'activation du XOR
	input type_state 	state_i,		// État d'entrée
	output type_state 	state_o			// État de sortie
	);


// Modifications de l'état par les XORs

	assign state_o[0] = state_i[0];
	assign state_o[1] = state_i[1];
	assign state_o[2] = (ena_xor_down_i) ? state_i[2] ^ data_xor_down_i[191:128] : state_i[2];
	assign state_o[3] = (ena_xor_down_i) ? state_i[3] ^ data_xor_down_i[127: 64] : state_i[3];
	assign state_o[4] = (ena_xor_down_i) ? state_i[4] ^ data_xor_down_i[ 63:  0] : state_i[4];

endmodule : xor_down
