// Arthur DORADOUX - Projet ASCON
// permutation.sv
// Ce module représente la permutation SANS les XORs.
// 27/03/2025


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps.

module permutation import ascon_pack::*;( // On importe ascon_pack qui contient le type type_state.

	input type_state 	state_i,	// État d'entrée

	input logic [3:0] 	round_i,	// Compteur de ronde
	input logic 		clock_i,	// Horloge
	input logic 		reset_i,	// Reset
	input logic 		enable_i,	// Signal d'activation de l'écriture dans le registre
	input logic 		sel_mux_i,	// Sélecteur du multiplexeur

	output type_state 	state_o		// État de sortie
);


// ------------------ Déclaration des signaux internes ------------------

	// État de sortie du multiplexeur
	type_state state_mux_s;

	// États internes liant l'addition de constante et la substitution ainsi que la substitution et la diffusion linéaire ainsi que la diffusion linéaire et le registre
	type_state state_add_sub_s, state_sub_dif_s, state_dif_reg_s;

	// On choisit l'entrée grâce au multiplexeur
	assign state_mux_s = (sel_mux_i) ? state_o : state_i;


// Instanciation des modules utilisés correspondant aux 3 couches p_c, p_s et p_l ainsi que le registre


// ------------------ Addition de constante --------------------------

	addition_constante addition_constante_u (
		.state_i(state_mux_s),
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
		.diffusion_o(state_dif_reg_s)
	);


// ----------------- Registre stockant l'état ------------------------

	registre registre_u (
		.clock_i(clock_i),
		.resetb_i(reset_i),
		.enable_i(enable_i),
		.registre_i(state_dif_reg_s),
		.registre_o(state_o)
	);

endmodule : permutation
