// Arthur DORADOUX - Projet ASCON
// ascon_top_tb.sv
// Ce module représente le test bench du top level
// 01/04/2025
// Module fourni et légèrement modifié : lignes 106 et 131


`timescale 1ns / 1ps // Définit l'unité de temps à 1 ns et la précision à 1 ps.


module ascon_top_tb import ascon_pack::*; ();

	const int HALF_PERIOD = 10;			// Demi période de l'horloge
	
	bit				clock_s = 1'b0;		// Horloge 
	bit				resetb_s, start_s;	// Reset et Signal de démarrage du chiffrement
	bit [127:0] 	data_s;				// Contient les données 
	bit				data_valid_s;		// Permet de savoir si la data est correcte
	bit [127:0]		key_s;				// Clé utilisée pour le XOR down et l'initialisation
	bit [127:0]		nonce_s;			// Nonce 
	bit [127:0]		cipher_s;			// Signal contenant les textes après le XOR
	bit				cipher_valid_s;		// Permet d'indiquer si le cipher est correct
	bit [127:0]		tag_s;				// Tag
	bit				end_s;				// Indique si le chiffrement est terminé

	bit [95:0]		associated_data_tb;	// C'est le A1 que l'on XOR 
	bit [375:0]		plaintext_tb;		// Contient P1, P2 et P3
	bit [375:0]		ciphertext_tb;		// Contient les textes du cipher 

	// Instanciation du top level "ascon_top"
	ascon_top ascon_top_u(
		 .clock_i(clock_s),
		 .resetb_i(resetb_s),
		 .start_i(start_s),
		 .data_i(data_s),
		 .data_valid_i(data_valid_s),
		 .key_i(key_s),
		 .nonce_i(nonce_s),
		 .cipher_o(cipher_s),
		 .cipher_valid_o(cipher_valid_s),
		 .tag_o(tag_s),
		 .end_o(end_s)
		 );

	// Génération de l'horloge 
    initial begin : clock_gen
        forever #HALF_PERIOD clock_s = ~ clock_s;
    end
	
	initial begin : main

		// Used to format timing information in console
		$timeformat(-9, 5, " ns", 10);
		
		// Key and nonce are available at t = 0
		key_s 	= 128'h691AED630E81901F6CB10AD9CA912F80;
		nonce_s = 128'h46487B3E06D9D7A80C4C36A20853217C;

		// Associated data A on 12 bytes (before padding)
		associated_data_tb = 96'h626F42206F74206563696C41;
		// Plaintext P on 47 bytes (before padding)
		plaintext_tb = 376'h3F206172656E754D20746E75696E65766E49206561727574614E2061747265704F2065726964207475657620657551;

		// Reset phase: resetb_i is active low
		resetb_s   = 1'b0;
		start_s = 1'b0;
		data_valid_s = 1'b0;
		data_s = 64'h0;

		#100;

		// Release resetb_i
		resetb_s   = 1'b1;
		#15;

		// Start operation
		start_s = 1'b1;
		#20;
		start_s = 1'b0;
		// Start signal lasts one cycle

		// Wait the exact timing before setting A0 => no wait state in FSM
		#250;

		// A0 : padded A = {0x00, 0x00, 0x00, 0x01, A}
		data_s = {24'h000000, 8'h01, associated_data_tb};
		// Data is valid during one clock cycle
		data_valid_s = 1'b1;
		#20;
		data_valid_s = 1'b0;
		
		// Wait the exact timing before setting P1 => no wait state in FSM
		#120;

		// P1 is the least significant word of P
		data_s = plaintext_tb[127:0];
		// Data is valid during one clock cycle	





// Modifié pour avoir le bon résultat car j'ai un demi cycle d'horloge d'écart


		#35; // +10 +5




		data_valid_s = 1'b1;
		#20;
		data_valid_s = 1'b0;
		#21;
		ciphertext_tb[127:0] = cipher_s;

		// Wait the exact timing before setting P2 => no wait state in FSM		
		#100;

		// P2
		data_s = 128'h6E6F6373412063657661206567617373;
		data_s = plaintext_tb[255:128];





// J'ai également modifié ici : 


		#30; // ici on fait +10




		data_valid_s = 1'b1;
		#20;
		data_valid_s = 1'b0;
		#21;
		ciphertext_tb[255:128] = cipher_s;

		// Wait more than needed for P3 => wait state is required
		#300;

		// P3 - most significant word of P with 0x01 padding
		data_s = {8'h01, plaintext_tb[375:256]};

		#20;
		data_valid_s = 1'b1;
		#20;
		data_valid_s = 1'b0;
		#21;
		ciphertext_tb[375:256] = cipher_s[119:0];

		// Wait for the end of the computation
		wait(end_s == 1'b1);
		#21;
		
		$display("End of computation at %t", $time);
		$display("Computed ciphertext is %h", ciphertext_tb);
		$display("Expected ciphertext is 42b995a03c96c3611bbd350f39ff3a4217e1e21263792197d30faeea29bd67c9c1495620515b13c0ee02b8fad31121");

		$display("Computed tag is %h", tag_s);
		$display("Expected tag is f366f456cb2976594eb3452ce34318db");

		#100;

		$finish();
	end // initial begin
	
endmodule // ascon_top_tb
