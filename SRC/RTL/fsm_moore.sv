// Arthur DORADOUX - Projet ASCON
// fsm_moore.sv
// Ce module représente la machine d'état de Moore de notre algorithme de chiffrement
// 01/04/2025


`timescale  1ns/1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps.

module fsm_moore import ascon_pack::*;( // On importe ascon_pack pour récupérer a = 12

	input logic			clock_i,		// Horloge
	input logic			resetb_i,		// Reset
	input logic			start_i,		// Signal donnant le début de l'algorithme
	input logic			data_valid_i,	// Permet de savoir si la data est correcte
	input logic [3:0]	round_i,		// Compteur de rondes

	output logic		ena_reg_state_o,// Signal d'activation de l'écriture dans le registre
	output logic		cipher_valid_o,	// Permet de savoir si le cipher est correct
	output logic		init_state_o,	// Signal du multiplexeur permettant de choisir l'état en entrée de la "permutation_xor_top"	
	output logic		ena_cpt_o,		// Signal d'activation du compteur de rondes
	output logic		init_a_o,		// Initialisation du compteur de rondes à 0
	output logic		init_b_o,		// Initialisation du compteur de rondes à 4
	
	output logic		ena_xor_up_o,	// Signal d'activation du XOR up
	output logic		ena_xor_down_o,	// Signal d'activation du XOR down
	output logic [1:0]	conf_xor_down_o,// Sélecteur de la valeur utilisée dans le XOR down

	output logic 		ena_cipher_o,	// Signal d'activation du registre stockant le cipher
	output logic 		ena_tag_o,		// Signal d'activation du registre stockant le tag

	output logic		end_o			// Indique si le chiffrement est terminé
);
	

// Déclaration des états de la machine d'état

	typedef enum {
			// Initialisation 
		idle, set_cpt, init_0, init_1_10, end_init,
			// Donnée associée
		wait_data_a1, xor_data_a1, data_a1_0, data_a1_1_6, end_data_a1,
			// Text clair
		wait_text_p1, xor_text_p1, text_p1_0, text_p1_1_6, end_text_p1,
		wait_text_p2, xor_text_p2, text_p2_0, text_p2_1_6, end_text_p2,
			// Finalisation
		wait_fin, xor_fin, fin_0, fin_1_10, end_fin, tag, fin
	} fsm_state;

		
// Création d'un état courant et de l'état suivant afin de parcourir la machine d'état
		
	fsm_state current_state_s, next_state_s;


// Mémorisation de l'état courant

	always_ff @(posedge clock_i, negedge resetb_i) begin : current_state_seq
		if (resetb_i == 1'b0) begin 		// Si le reset est activé :
			current_state_s <= idle;		// Retour à l'état idle
		end
		else begin							// Sinon : 
			current_state_s <= next_state_s;// L'état courant devient l'ancien état suivant
		end
	end



// === Processus combinatoire pour les changements d'états ====


	always_comb begin : output_state_comb
		case(current_state_s)


// --------------------- Initialisation -----------------------


			idle: begin				// Attente du démarrage du chiffrement
			    if (start_i == 1'b1) begin
			        next_state_s = set_cpt;
			    end
			    else begin
			        next_state_s = idle;
			    end
			end

			set_cpt: begin 			// Initialisation du compteur de rondes
				next_state_s = init_0;
		    end

			init_0: begin 			// Première ronde
		        next_state_s = init_1_10;
		    end

			init_1_10: begin 		// Rondes suivantes sauf la dernière 
				if (round_i == a - 2) begin
					next_state_s = end_init;
		        end
		        else begin
		            next_state_s = init_1_10;
		        end
		    end

		    end_init: begin 		// Dernière ronde avec le XOR
		        if (data_valid_i == 1'b1) begin
		            next_state_s = xor_data_a1;
		        end
		        else begin
		            next_state_s = wait_data_a1;
				end 
		    end

			
// ------------------- A1 - Donnée associée ---------------------


			wait_data_a1: begin 	// Etat qui attend que la valeur de "data" soit correcte
				if (data_valid_i == 1'b1) begin
		            next_state_s = xor_data_a1;
		        end
		        else begin
		            next_state_s = wait_data_a1;
				end 
			end

			xor_data_a1: begin 		// XOR up A1
				next_state_s = data_a1_0;
		    end

			data_a1_0: begin		// Première ronde
		        next_state_s = data_a1_1_6;
		    end

			data_a1_1_6: begin 		// Rondes suivantes sauf la dernière
				if (round_i == a - 2) begin
					next_state_s = end_data_a1;
		        end
		        else begin
		            next_state_s = data_a1_1_6;
		        end
		    end

		    end_data_a1: begin		// Dernière ronde avec le XOR
		        if (data_valid_i == 1'b1) begin
		            next_state_s = xor_text_p1;
		        end
		        else begin
		            next_state_s = wait_text_p1;
				end 
		    end


// ------------------- P1 - text clair 1 ---------------------

			
			wait_text_p1: begin		// Etat qui attend que la valeur de "data" soit correcte
				if (data_valid_i == 1'b1) begin
		            next_state_s = xor_text_p1;
		        end
		        else begin
		            next_state_s = wait_text_p1;
				end 
			end

			xor_text_p1: begin 		// XOR up P1
				next_state_s = text_p1_0;
		    end

			text_p1_0: begin	 	// Première ronde
		        next_state_s = text_p1_1_6;
		    end

			text_p1_1_6: begin 		// Rondes suivantes sauf la dernière
				if (round_i == a - 2) begin
					next_state_s = end_text_p1;
		        end
		        else begin
		            next_state_s = text_p1_1_6;
		        end
		    end

		    end_text_p1: begin		// Dernière ronde
				if (data_valid_i == 1'b1) begin
		            next_state_s = xor_text_p2;
		        end
		        else begin
		            next_state_s = wait_text_p2;
				end 
		    end


// ------------------- P2 - text clair 2 ---------------------

			
			wait_text_p2: begin		// Etat qui attend que la valeur de "data" soit correcte
				if (data_valid_i == 1'b1) begin
		            next_state_s = xor_text_p2;
		        end
		        else begin
		            next_state_s = wait_text_p2;
				end 
			end

			xor_text_p2: begin 		// XOR up P2
				next_state_s = text_p2_0;
		    end

			text_p2_0: begin		// Première ronde 
		        next_state_s = text_p2_1_6;
		    end

			text_p2_1_6: begin 		// Rondes suivantes sauf la dernière
				if (round_i == a - 2) begin
					next_state_s = end_text_p2;
		        end
		        else begin
		            next_state_s = text_p2_1_6;
		        end
		    end

		    end_text_p2: begin		// Dernière ronde avec le XOR
				if (data_valid_i == 1'b1) begin
		            next_state_s = xor_fin;
		        end
		        else begin
		            next_state_s = wait_fin;
				end 
		    end


// -------------- P3 - text clair 3 et fin du chiffrement -----------------

			
			wait_fin: begin			// Etat qui attend que la valeur de "data" soit correcte
				if (data_valid_i == 1'b1) begin
		            next_state_s = xor_fin;
		        end
		        else begin
		            next_state_s = wait_fin;
				end 
			end

			xor_fin: begin 			// XOR up P3
				next_state_s = fin_0;
		    end

			fin_0: begin			// Première ronde
		        next_state_s = fin_1_10;
		    end

			fin_1_10: begin			// Rondes suivantes sauf la dernière
				if (round_i == a - 2) begin
					next_state_s = end_fin;
		        end
		        else begin
		            next_state_s = fin_1_10;
		        end
		    end

		    end_fin: begin			// Dernière ronde avec le XOR
		        next_state_s = tag;
		    end

			tag : begin 			// Lecture du tag 
				next_state_s = fin;
			end 
			
			fin : begin 			// Fin de l'algorithme
				next_state_s = idle;
			end

		endcase // Fin du case current_state_s

	end : output_state_comb



// ==== Processsus Combinatoire pour les valeurs de sortie ====


	always_comb begin : output_logic_comb

	    // Initialisation des valeurs par défaut des sorties 
	    cipher_valid_o  = 1'b0;
	    end_o           = 1'b0;
	    init_state_o    = 1'b1; 
	    ena_cpt_o       = 1'b1;
	    init_a_o        = 1'b0;
	    init_b_o        = 1'b0;
	    ena_xor_up_o    = 1'b0;
	    ena_xor_down_o  = 1'b0;
	    conf_xor_down_o = 2'b00;
	    ena_reg_state_o = 1'b1;
		ena_cipher_o 	= 1'b0;
		ena_tag_o 		= 1'b0; 
	
	    case(current_state_s)


// --------------------- Initialisation -----------------------


	        idle: begin
	            // Les valeurs par défaut sont appliquées
				ena_reg_state_o = 1'b0;
				ena_cpt_o       = 1'b0;
	        end

	        set_cpt: begin
	            init_a_o       	= 1'b1;
				init_state_o   	= 1'b0;
				ena_cpt_o       = 1'b0;
	        end

	        init_0: begin
	            init_state_o   	= 1'b0;
	        end

	        init_1_10: begin
	        end

	        end_init: begin 
	            ena_xor_down_o 	= 1'b1;
				conf_xor_down_o = 2'b00; // déjà le cas par l'initialisation
				init_b_o       	= 1'b1; 
	        end


// ------------------- A1 - Donnée associée ---------------------


	        wait_data_a1: begin
				ena_cpt_o      	= 1'b0;
				ena_reg_state_o = 1'b0;
			end
	
	        xor_data_a1: begin 
	            init_b_o       	= 1'b1;
				ena_xor_up_o 	= 1'b1;
	        end

	        data_a1_0: begin
				ena_reg_state_o = 1'b0;
	        end

	        data_a1_1_6: begin
	        end			

			end_data_a1: begin 
	            ena_xor_down_o 	= 1'b1;
				conf_xor_down_o = 2'b01;
				init_b_o       	= 1'b1;
	        end

			
// ------------------- P1 - text clair 1 ---------------------			
			

	        wait_text_p1: begin 
				ena_cpt_o      	= 1'b0;
				ena_reg_state_o = 1'b0;
			end
	
	        xor_text_p1: begin
	            ena_xor_up_o 	= 1'b1;
				ena_cipher_o 	= 1'b1;
				cipher_valid_o  = 1'b1;
				ena_cpt_o      	= 1'b0;
	        end

	        text_p1_0: begin
				ena_reg_state_o = 1'b0;
	        end

	        text_p1_1_6: begin
	        end			

			end_text_p1: begin
				init_b_o       	= 1'b1;
	        end

			
// ------------------- P2 - text clair 2 ---------------------
			

	        wait_text_p2: begin 
				ena_cpt_o      	= 1'b0;
				ena_reg_state_o = 1'b0;
			end
	
	        xor_text_p2: begin
				ena_xor_up_o 	= 1'b1;
				ena_cipher_o 	= 1'b1;
				cipher_valid_o  = 1'b1;
	            ena_cpt_o      	= 1'b0;
	        end

	        text_p2_0: begin
		    	ena_reg_state_o = 1'b0;
	        end

	        text_p2_1_6: begin
	        end			

			end_text_p2: begin 
	            ena_xor_down_o 	= 1'b1;
				conf_xor_down_o = 2'b10;
				init_a_o       	= 1'b1;
	        end

			
// -------------- P3 - text clair 3 et fin du chiffrement -----------------
			

	        wait_fin: begin 
				ena_cpt_o      	= 1'b0;
				ena_reg_state_o = 1'b0;
			end
	
	        xor_fin: begin
	            ena_xor_up_o 	= 1'b1;
				ena_cipher_o 	= 1'b1;
				cipher_valid_o  = 1'b1;
	            ena_cpt_o      	= 1'b0;
	        end

	        fin_0: begin	
				ena_reg_state_o = 1'b0;	    	
	        end

	        fin_1_10: begin
	        end			

			end_fin: begin 
	            ena_xor_down_o 	= 1'b1;
				conf_xor_down_o = 2'b11;
				init_a_o       	= 1'b1;
	        end

			tag : begin 
				ena_tag_o 		= 1'b1;
				ena_cpt_o       = 1'b0;
				ena_reg_state_o = 1'b0;
			end

			fin : begin
				end_o 			= 1'b1;
				ena_cpt_o       = 1'b0;
				ena_reg_state_o = 1'b0;
			end 
	    endcase // case (current_state_s)
	end // block: OUTPUT_LOGIC
	
endmodule : fsm_moore
