// Arthur DORADOUX - Projet ASCON
// addition_constante_tb.sv
// Test bench du module d'addition de constante p_c
// 10/03/2025


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps

module addition_constante_tb import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state ainsi que les constantes de ronde 
);

// Déclaration des signaux internes

	type_state state_i_s;	// État interne pour l'entrée 
	logic[3:0] round_s;		// Compteur de rondes interne sur 4 bits 
	type_state state_o_s;	// État interne pour la sortie


// Instanciation du module "addition_constante" avec nos signaux internes

	addition_constante DUT (
		.state_i(state_i_s),
		.round_i(round_s),
		.state_o(state_o_s)
	);


	initial begin
		// On initialise le compteur de rondes à 0
		round_s = 4'd0;

		// On initialise l'état d'entrée à la valeur fournie par le sujet au tout début du chiffrement	
		state_i_s = {64'h00001000808C0001,	// S_0
					64'h6CB10AD9CA912F80,	// S_1
					64'h691AED630E81901F, 	// S_2
					64'h0C4C36A20853217C, 	// S_3
					64'h46487B3E06D9D7A8}; 	// S_4 
		// On n'initalise pas seulement S2 bien que ce soit le seul que l'on modifie. Cela nous permet de vérifier qu'il n'y a pas de comportement non voulu sur les autres bits


		repeat (11) begin 	
		// Pour être certain du fonctionnement du module "addition_constante", on vérifie l'addition de toutes les différentes valeurs de la constante c_r en répétant 12 fois l'action pour tester chaque valeur de ronde

			// On patiente 10 ns
			#10;
			// On incrémente le compteur de ronde
			round_s += 4'd1;
		end
	end

endmodule : addition_constante_tb
