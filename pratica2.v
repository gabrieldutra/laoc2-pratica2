module pratica2 (Clock, Done);
	input Clock;
	output Done;
	wire [15:0] BusWires;
	proc (16'b0000000000000000, 1'b0, Clock, 1'b1, Done, BusWires);

endmodule