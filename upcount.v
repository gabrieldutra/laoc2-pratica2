module upcount(
	Clear,
	Clock, 
	Q
	);
	input Clear, Clock;
	output reg [1:0] Q = 2'b00;
	always @(posedge Clock)
	if (Clear)
	Q <= 2'b0;
	else
	Q <= Q + 1'b1;
endmodule