// Arthur DORADOUX - Projet ASCON
// mux_xor_down.sv
// Multiplexeur permettant de choisir la valeur utilisée dans le module xor_down
// 27/03/2025


`timescale  1ns/1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module mux_xor_down import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state.
	input type_state 		state_i,		// État d'entrée

	input logic [1:0] 		sel_xor_down_i,	// Sélecteur de la valeur à utiliser pour le XOR
	input logic [127:0] 	key_i,			// Clé utilisée pour le XOR
	input logic		 		ena_xor_down_i,	// Signal d'activation du XOR

	output type_state 		state_o			// État de sortie
);
// Déclaration du signal interne traitant la donnée utilisée dans le XOR
	logic [191:0] data_xor_down_s;

// Sélection des données à XOR en fonction du signal de sélection
	always_comb begin
		case(sel_xor_down_i)
		    2'b00: data_xor_down_s = {64'b0, key_i[63:0], key_i[127:64]};
		    2'b01: data_xor_down_s = {128'b0, 1'b1, 63'b0};
		    2'b10: data_xor_down_s = {key_i[63:0], key_i[127:64], 64'b0};
			2'b11: data_xor_down_s = {64'b0, key_i[63:0], key_i[127:64]};
		    default: data_xor_down_s = 192'b0; 	// Cas par défaut
		endcase
	end

// Instanciation du module "xor_down"
	xor_down xor_down_u (
		.data_xor_down_i(data_xor_down_s),  // Utilisation de la valeur interne pour réaliser le XOR
		.ena_xor_down_i(ena_xor_down_i),
		.state_i(state_i),
		.state_o(state_o)
	);


endmodule : mux_xor_down
