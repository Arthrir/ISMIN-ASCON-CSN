// Arthur DORADOUX - Projet ASCON
// ascon_top.sv
// Ce module représente le top level
// 01/04/2025


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps.

module ascon_top import ascon_pack::*;( // On importe le package ascon_pack

	input logic 		clock_i,		// Horloge
	input logic 		resetb_i,		// Reset
	input logic 		start_i,		// Signal donnant le début de l'algorithme
	input logic [127:0]	data_i,			// Contient les données
	input logic 		data_valid_i,	// Permet de savoir si la data est correcte
	input logic [127:0] key_i, 			// Clé utilisée pour le XOR down et l'initialisation
	input logic [127:0] nonce_i,		// Nonce utilisé pour initialiser l'état d'entrée

	output logic [127:0]cipher_o,		// Signal contenant les textes après le XOR
	output logic 		cipher_valid_o, // Permet d'indiquer si le cipher est correct
	output logic [127:0]tag_o,			// Tag
	output logic 		end_o			// Indique si le chiffrement est terminé
);


// Déclaration de tous les signaux internes

	logic [3:0] round_s; 			// Compteur de rondes interne
	logic 		init_a_s;			// Initialisation du compteur de rondes à 0
	logic 		init_b_s;			// Initialisation du compteur de rondes à 4
	logic 		ena_cpt_s;			// Activation du compteur de rondes
	logic 		ena_xor_up_s; 		// Activation XOR up 
	logic 		ena_xor_down_s; 	// Activation XOR down
	logic [1:0] conf_xor_down_s;	// Sélecteur de la valeur à XOR down
	logic 		init_state_s;		// Signal de sélection du multiplexeur de la permutation
	logic 		ena_reg_state_s;	// Activation de l'écriture dans le registre de l'état 
	logic 		ena_cipher_s;		// Activation de l'écriture dans le registre du cipher 
	logic 		ena_tag_s;			// Activation de l'écriture dans le registre du tag




	logic [63:0] vect_init_s = 64'h00001000808c0001; // IV - Vecteur d'initialisation pour S_0

	type_state state_i_s; // Etat permettant d'initialiser la permutation


		// On lui donne sa valeur initiale :
	assign state_i_s = {vect_init_s, key_i[63:0], key_i[127:64],nonce_i[63:0], nonce_i[127:64]};


	type_state state_o_s; // Etat de la sortie de la permutation



// Instanciation des modules utilisés


// ------------------------ Machine d'état -------------------------

	fsm_moore fsm_u (
		.start_i(start_i),
		.data_valid_i(data_valid_i),
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.round_i(round_s),

		.end_o(end_o),
		.cipher_valid_o(cipher_valid_o),
		.init_a_o(init_a_s),
		.init_b_o(init_b_s),
		.ena_cpt_o(ena_cpt_s), 
		.ena_xor_up_o(ena_xor_up_s),
		.ena_xor_down_o(ena_xor_down_s),
		.conf_xor_down_o(conf_xor_down_s),
		.init_state_o(init_state_s), 
		.ena_reg_state_o(ena_reg_state_s),
		.ena_cipher_o(ena_cipher_s),
		.ena_tag_o(ena_tag_s)
		
	);


// ----------------- Permutation avec XOR finale ---------------------

	permutation_xor_top permutation_xor_u (
		.state_i(state_i_s),
		.round_i(round_s),
		.clock_i(clock_i),
		.reset_i(resetb_i),
		.sel_mux_i(init_state_s),
		.data_i(data_i),
		.ena_xor_up_i(ena_xor_up_s),
		.enable_i(ena_reg_state_s),
		.ena_xor_down_i(ena_xor_down_s),
		.sel_xor_down_i(conf_xor_down_s),
		.key_i(key_i),

		.state_o(state_o_s),
		.cipher_o(cipher_o),
		.tag_o(tag_o),
		.ena_cipher_i(ena_cipher_s),
		.ena_tag_i(ena_tag_s)	
	);


// --------------------- Compteur de rondes --------------------------

	counter_double_init compteur_double_init_u (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.ena_i(ena_cpt_s),
		.init_a_i(init_a_s),
		.init_b_i(init_b_s),
		.count_o(round_s)
	); 

endmodule : ascon_top
