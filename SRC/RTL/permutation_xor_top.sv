// Arthur DORADOUX - Projet ASCON
// permutation_xor_modified.sv
// Ce module représente la permutation AVEC les XORs modifiée légèrement pour pouvoir l'utiliser dans le module "ascon_top".
// 01/04/2025


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps.

module permutation_xor_top import ascon_pack::*;( // On importe ascon_pack qui contient le type type_state.
	input type_state 		state_i,		// État d'entrée

	input logic [3:0] 		round_i,		// Compteur de ronde
	input logic 			clock_i,		// Horloge
	input logic 			reset_i,		// Reset
	input logic [127:0]		key_i,			// Clé utilisée pour le XOR down
	input logic 			enable_i,		// Signal d'activation de l'écriture dans le registre
	input logic 			sel_mux_i,		// Sélecteur du multiplexeur
	input logic [127:0]	 	data_i,			// Donnée utilisée dans le XOR up

	input logic 			ena_cipher_i,	// Signal d'activation du registre stockant le cipher
	input logic 			ena_tag_i,		// Signal d'activation du registre stockant le tag

	input logic 			ena_xor_up_i,	// Signal d'activation du XOR up
	input logic 			ena_xor_down_i,	// Signal d'activation du XOR down
	input logic [1:0] 		sel_xor_down_i,	// Sélecteur de la valeur à utiliser dans le XOR down

	output logic [127:0]	cipher_o,		// Cipher des textes 
	output logic [127:0]	tag_o,			// Tag à récupérer à la fin du chiffrement
	output type_state 		state_o			// État de sortie
);
	
		
// Déclaration des signaux internes

	// État de sortie du multiplexeur
	type_state state_mux_s;

	// États internes liant les différents modules xor_up, addtition_constante, couche_substitution, diffusion_lineaire, mux_xor_down, registre
	type_state state_xu_add_s, state_add_sub_s, state_sub_dif_s, state_dif_xd_s, state_xd_reg_s;


	// On choisit l'entrée grâce au multiplexeur
	assign state_mux_s = (sel_mux_i) ? state_o : state_i;


// Instanciation des modules utilisés correspondant au xor up, aux 3 couches p_c, p_s et p_l ainsi qu'au xor down et au registre


// -------------------------- xor up ---------------------------------

	xor_up xor_up_u (
		.data_xor_up_i(data_i[127:0]),
		.ena_xor_up_i(ena_xor_up_i),
		.state_i(state_mux_s),
		.state_o(state_xu_add_s)
	);


// --------------- Registre stockant le cipher -----------------------

	registre_cipher_tag registre_cipher(
		.clock_i(clock_i),
		.resetb_i(reset_i),
		.enable_ct_i(ena_cipher_i),
		.data_i({state_xu_add_s[1],state_xu_add_s[0]}),
		.data_o(cipher_o)
	);


// ------------------ Addition de constante --------------------------

	addition_constante addition_constante_u (
		.state_i(state_xu_add_s),
		.round_i(round_i),
		.state_o(state_add_sub_s)
	);


// ----------------- Couche de substitution --------------------------

	couche_substitution couche_substitution_u ( 
		.substitution_i(state_add_sub_s),
		.substitution_o(state_sub_dif_s)
	);


// -------------------- Diffusion linéaire ---------------------------

	diffusion_lineaire diffusion_lineaire_u ( 
		.diffusion_i(state_sub_dif_s),
		.diffusion_o(state_dif_xd_s)
	);


// --------------- Multiplexeur pour le xor_down ---------------------

	mux_xor_down mux_xor_down_u (
		.state_i(state_dif_xd_s),
		.sel_xor_down_i(sel_xor_down_i),
		.key_i(key_i),
		.ena_xor_down_i(ena_xor_down_i),
		.state_o(state_xd_reg_s)
	);


// ----------------- Registre stockant l'état ------------------------

	registre registre_u (
		.clock_i(clock_i),
		.resetb_i(reset_i),
		.enable_i(enable_i),
		.registre_i(state_xd_reg_s),
		.registre_o(state_o)
	);


// ----------------- Registre stockant le tag ------------------------

	registre_cipher_tag registre_tag(
		.clock_i(clock_i),
		.resetb_i(reset_i),
		.enable_ct_i(ena_tag_i),
		.data_i({state_o[4],state_o[3]}),
		.data_o(tag_o)
	);

endmodule : permutation_xor_top
