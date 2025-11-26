// Arthur DORADOUX - Projet ASCON
// addition_constante.sv
// Module décrivant l'addition de constante p_c
// 10/03/2025


module addition_constante import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state ainsi que les constantes de ronde 
	input 				type_state state_i,     // État d'entrée de 320 bits
    input logic [3:0] 	round_i,    			// Numéro de la ronde (de 0 à 11)
    output 				type_state state_o      // État de sortie (state_i après l'addition de la  constante "c_r")
);

// On fait pour chaque état S :

	// Pour S_0 on ne change rien
	assign state_o[0] = state_i[0];

	// Pour S_1 on ne change rien
	assign state_o[1] = state_i[1];

	// Pour S_2 on fait un XOR entre les bits de 7 à 0 et la constante de ronde correspondant au bon numéro de ronde
	assign state_o[2][63:8] = state_i[2][63:8]; // Permet de remplir tous les bits de state_o avec ceux de state_i avant de modifier les derniers
	assign state_o[2][7:0] = state_i[2][7:0] ^ round_constant[round_i]; // On réalise le XOR

	// Pour S_3 on ne change rien
	assign state_o[3] = state_i[3];

	// Pour S_4 on ne change rien
	assign state_o[4] = state_i[4];

endmodule : addition_constante
