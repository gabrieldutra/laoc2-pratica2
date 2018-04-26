module proc (DIN, Resetn, Clock, Run, Done, BusWires);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output Done;
	output [15:0] BusWires;
	
	wire [15:0] IR;
	reg IRin = 0;
	wire Xreg, Yreg;
	
	regn regI (DIN, IRin, Clock, IR);
	
	assign I = IR[8:6];
	
	wire Clear = Resetn;
	upcount Tstep (Clear, Clock, Tstep_Q);
	dec3to8 decX (IR[5:3], 1'b1, Xreg);
	dec3to8 decY (IR[2:0], 1'b1, Yreg);
	
	always @(Tstep_Q or I or Xreg or Yreg)
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
		endcase
	end
endmodule