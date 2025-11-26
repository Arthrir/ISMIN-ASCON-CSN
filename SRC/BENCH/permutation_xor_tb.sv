// Arthur DORADOUX - Projet ASCON
// permutation_xor_tb.sv
// Test bench du module de permutation AVEC les XORs.
// 27/03/2025


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module permutation_xor_tb import ascon_pack::*;( // On importe ascon_pack qui contient le type type_state.
);

// Déclaration des signaux internes 

	type_state 	state_i_s;					// État d'entrée interne

	logic[3:0] 		round_s;				// Compteur de ronde
	logic 			clock_s = 1'b0;			// Horloge initialisée à 0
	logic 			reset_s = 1'b0;			// Reset initialisé à 0, c'est à dire activé
	logic [127:0] 	key_s;					// Clé utilisée pour le XOR down
	logic 			enable_s;				// Signal d'activation de l'écriture dans le registre
	logic 			sel_mux_s = 1'b0;		// Sélecteur du multiplexeur initialisé à 0
	logic [127:0] 	data_s;					// Donnée utilisée dans le XOR up

	logic 			ena_xor_up_s = 0;		// Signal d'activation du XOR up
	logic 			ena_xor_down_s = 0;		// Signal d'activation du XOR down
	logic [1:0]		sel_xor_down_s = 2'b0;	// Sélecteur de la valeur à utiliser dans le XOR down

	type_state state_o_s;					// État de sortie interne


// Instanciation du module "permutation_xor"

	permutation_xor DUT (
		.state_i(state_i_s),
		.round_i(round_s),
		.clock_i(clock_s),
		.reset_i(reset_s),
		.key_i(key_s),
		.enable_i(enable_s),
		.sel_mux_i(sel_mux_s),
		.data_i(data_s),
		.ena_xor_up_i(ena_xor_up_s),
		.ena_xor_down_i(ena_xor_down_s),
		.sel_xor_down_i(sel_xor_down_s),
		.state_o(state_o_s)
	);



// On crée l'horloge 
	initial begin
		forever #5 clock_s = ~clock_s; // forever crée une boucle infinie et inverse "clock_s" toutes les 5ns faisant passer le signal de 0 à 1 et inversement
	end 


	initial begin

			// On initialise tout à 0 
		round_s = 4'h0;			// Compteur de rondes initialisé à 0
		reset_s = 1'b0;			// Activation du reset | déjà fait lors de la déclaration
		sel_mux_s = 1'b0; 		// Choix de l'état d'entrée
		enable_s = 1'b1;		// Activation de l'écriture dans le registre
		ena_xor_up_s = 1'b0; 	// Désactivation du XOR up | déjà fait lors de la déclaration
		ena_xor_down_s = 1'b0;	// Désactivation du XOR down | déjà fait lors de la déclaration

			// Initialisation de l'état d'entrée à sa valeur initiale
		state_i_s = {64'h00001000808c0001,	// S_0
					64'h6cb10ad9ca912f80, 	// S_1
					64'h691AED630E81901F, 	// S_2
					64'h0c4c36a20853217c, 	// S_3
					64'h46487b3e06d9d7a8};	// S_4

			// Initialisation de la clé pour le XOR down 
		key_s = 128'h691aed630e81901f6cb10ad9ca912f80;

		#5 
		reset_s = 1'b1;		// Désactivation du reset

		#15
		sel_mux_s = 1'b1;	// Choix de l'état de sortie
		round_s = 4'h1;
		#10
		for (int i=1; i<10; i++) begin // On simule les 9 rondes suivantes (ici on a choisi de tester p^12)
			round_s ++; 		// Incrémentation du compteur de rondes
			#10;
		end

			// Dernière ronde avec le XOR
		round_s++;
		sel_xor_down_s = 2'b0;	// Le XOR se fera avec la première valeur du multiplexeur du XOR down
		ena_xor_down_s = 1'b1;	// Activation du XOR
		#10;
		enable_s = 1'b0;		// Désactivation de l'écriture dans le registre
	end 

endmodule : permutation_xor_tb
