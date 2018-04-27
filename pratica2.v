module pratica2 (SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR);
	input [17:0] SW;
	output [0:6] HEX0;
	output [0:6] HEX1;
	output [0:6] HEX2;
	output [0:6] HEX3;
	output [0:6] HEX4;
	output [0:6] HEX5;
	output [0:6] HEX6;
	output [0:6] HEX7;
	output [2:0] LEDR;
	
	// Displays
	wire [0:6] display1;
	wire [0:6] display2;
	wire [0:6] display3;
	wire [0:6] display4;
	wire [0:6] display5;
	wire [0:6] display6;
	wire [0:6] display7;
	wire [0:6] display8;
	
	// wires
	wire Done;
	wire Clock;
	wire [15:0] BusWires;
	wire [15:0] DIN;
	wire [1:0] State;
	
	// Assign for displays
	assign HEX0 = display1;
	assign HEX1 = display2;
	assign HEX2 = display3;
	assign HEX3 = display4;
	assign HEX4 = display5;
	assign HEX5 = display6;
	assign HEX6 = display7;
	assign HEX7 = display8;
	
	assign LEDR[0:0] = Done;	
	assign Clock = SW[17];
	assign DIN = SW[15:0];
	assign LEDR[2:1] = State[1:0];
	
	proc process (DIN, 1'b0, Clock, 1'b1, Done, BusWires, State);
	bcd_7seg bcd1 (BusWires[3:0], display1[0:6]);
	bcd_7seg bcd2 (BusWires[7:4], display2[0:6]);
	bcd_7seg bcd3 (BusWires[11:8], display3[0:6]);
	bcd_7seg bcd4 (BusWires[15:12], display4[0:6]);
	
	bcd_7seg bcd5 (DIN[3:0], display5[0:6]);
	bcd_7seg bcd6 (DIN[7:4], display6[0:6]);
	bcd_7seg bcd7 (DIN[11:8], display7[0:6]);
	bcd_7seg bcd8 (DIN[15:12], display8[0:6]);

endmodule