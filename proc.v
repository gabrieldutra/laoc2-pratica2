module proc (DIN, Resetn, Clock, Run, Done, BusWires);
	input [15:0] DIN;
	input Resettn, Clock, Run;
	output Done;
	output [15:0] BusWires;
	
	wire [15:0] IR;
	reg IRin = 0;
	reg Xreg = 0;
	reg Yreg = 0;
	
	regn regI (DIN, IRin, Clock, IR);
	
	assign I = IR[1:3];
	
	wire Clear = Resetn;
	upcount Tstep (Clear, Clock, Tstep_Q);
	dec3to8 decX (IR[4:6], 1'b1, Xreg);
	dec3to8 decY (IR[7:9], 1'b1, Yreg);
	
	always @(Tstep_Q or Xreg or Yreg)
	begin
		case(Tstep_Q)
		2'b00: // time step 0
		begin
			IRin = 1'b1;
		end		
		2'b01: // time step 1
		begin
		end		
		2'b10: // time step 2
		begin
		end		
		2'b11: // time step 3
		begin
		end
		
	end
endmodule