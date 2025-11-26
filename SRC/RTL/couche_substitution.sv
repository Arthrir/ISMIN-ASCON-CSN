// Arthur DORADOUX - Projet ASCON
// couche_substitution.sv
// Ce module décrit la couche de substitution p_s de notre algorithme de chiffrement.
// 17/03/2025


module couche_substitution import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state
	input type_state substitution_i,	// État d'entrée
	output type_state substitution_o	// État de sortie
);

	genvar i; // On va utiliser un index pour parcourir toutes les colonnes de 5 bits de l'état d'entrée 

	generate // Permet de créer un bloc répétitif et donc de gagner du temps en n'ayant pas à recopier du code presque identique plusieurs fois.
// Ici, on va répéter 64 fois l'action d'instancier la S-box avec les valeurs de chaque colonne de l'entrée pour en récupérer la valeur substituée. Pour ce faire, on va incrémenter l'index "i" à chaque fois.
		for (i=0; i<64; i++) begin : generate_sbox

			sbox sbox_u( // On instancie la S-box 
			.x_i({substitution_i[0][i],
					substitution_i[1][i],
					substitution_i[2][i],
					substitution_i[3][i],
					substitution_i[4][i]}),
			.sbox_o({substitution_o[0][i],
					substitution_o[1][i],
					substitution_o[2][i],
					substitution_o[3][i],
					substitution_o[4][i]})
			);
		
		end : generate_sbox
	endgenerate

endmodule : couche_substitution
