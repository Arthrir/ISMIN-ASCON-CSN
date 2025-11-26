// Arthur DORADOUX - Projet ASCON
// diffusion_lineaire.sv
// Ce module représente la couche de diffusion linéaire p_l
// 17/03/2025


module diffusion_lineaire import ascon_pack::*;(// On importe ascon_pack qui contient le type type_state 
	input type_state diffusion_i,	// État d'entrée	
	output type_state diffusion_o	// État de sortie après effectué la diffusion linéaire
);

// Chaque "diffusion[j]" (_i[j] ou _o[j]) représente "S_j" (pour j allant de 0 à 4) les 5 registres de notre état "S"

	// Pour S_0, on le XOR avec des décalages arithmétiques à droite de lui même de 19 et 28 bits
	assign diffusion_o[0] = diffusion_i[0]^{diffusion_i[0][18:0], diffusion_i[0][63:19]}^{diffusion_i[0][27:0], diffusion_i[0][63:28]};

	// Pour S_1, on le XOR avec des décalages arithmétiques à droite de lui même de 61 et 39 bits
	assign diffusion_o[1] = diffusion_i[1]^{diffusion_i[1][60:0], diffusion_i[1][63:61]}^{diffusion_i[1][38:0], diffusion_i[1][63:39]};

	// Pour S_2, on le XOR avec des décalages arithmétiques à droite de lui même de 1 et 6 bits
	assign diffusion_o[2] = diffusion_i[2]^{diffusion_i[2][0], diffusion_i[2][63:1]}^{diffusion_i[2][5:0], diffusion_i[2][63:6]};

	// Pour S_3, on le XOR avec des décalages arithmétiques à droite de lui même de 10 et 17 bits
	assign diffusion_o[3] = diffusion_i[3]^{diffusion_i[3][9:0], diffusion_i[3][63:10]}^{diffusion_i[3][16:0], diffusion_i[3][63:17]};

	// Pour S_4, on le XOR avec des décalages arithmétiques à droite de lui même de 7 et 41 bits
	assign diffusion_o[4] = diffusion_i[4]^{diffusion_i[4][6:0], diffusion_i[4][63:7]}^{diffusion_i[4][40:0], diffusion_i[4][63:41]};

endmodule : diffusion_lineaire
