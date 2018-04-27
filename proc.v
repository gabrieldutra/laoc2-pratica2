module proc (DIN, Resetn, Clock, Run, Done, BusWires, State);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output reg Done = 0;
	output [15:0] BusWires;
	output [1:0] State;
	
	wire [15:0] IR;
	wire [15:0] R [0:7];
	wire RX, RY;
	wire Xreg, Yreg;
	wire [1:0] Tstep_Q;
	
	// regs
	wire [15:0] G;
	wire [15:0] A;
	wire [15:0] GinData;
	
	regn regI (DIN, IRin, Clock, IR);
	
	assign I = IR[8:6];
	assign RX = IR[5:3];
	assign RY = IR[2:0];
	
	reg IRin = 0;	
	reg Rin[0:7];
	reg Rout[0:7];
	reg Ain;
	reg Gin;
	reg Aout;
	reg Gout;
	reg DINout;
	reg sub = 0;
	
	wire Clear = Resetn;
	upcount Tstep (1'b0, Clock, Tstep_Q);
	dec3to8 decX (RX, 1'b1, Xreg);
	dec3to8 decY (RY, 1'b1, Yreg);
	
	always @(Tstep_Q or I or Xreg or Yreg)
	begin
		case(Tstep_Q)
			2'b00: // time step 0 - store DIN in IR on step 0
			begin
				IRin = 1'b1; // 
				Done = 0;
				Rin[0] = 0;
				Rin[1] = 0;
				Rin[2] = 0;
				Rin[3] = 0;
				Rin[4] = 0;
				Rin[5] = 0;
				Rin[6] = 0;
				Rin[7] = 0;
				Ain = 0;
				Gin = 0;
				Rout[0] = 0;
				Rout[1] = 0;
				Rout[2] = 0;
				Rout[3] = 0;
				Rout[4] = 0;
				Rout[5] = 0;
				Rout[6] = 0;
				Rout[7] = 0;
				DINout = 0;
			end		
			2'b01: // time step 1 - (mv: RYout, RXin and Done; mvi: DINout and RXin; add: RXout, Ain; sub: RXout, Ain)
			begin
				IRin = 0;
				Done = 0;
				Rin[0] = 0;
				Rin[1] = 0;
				Rin[2] = 0;
				Rin[3] = 0;
				Rin[4] = 0;
				Rin[5] = 0;
				Rin[6] = 0;
				Rin[7] = 0;
				Ain = 0;
				Gin = 0;
				Rout[0] = 0;
				Rout[1] = 0;
				Rout[2] = 0;
				Rout[3] = 0;
				Rout[4] = 0;
				Rout[5] = 0;
				Rout[6] = 0;
				Rout[7] = 0;
				DINout = 0;
				case(I)
					3'b000: // mv: RYout, RXin and Done
					begin
						Rout[RY] = 1;
						Rin[RX] = 1;
						Done = 1;
					end
					3'b001: // mvi: DINout and RXin
					begin
						DINout = 1;
						Rin[RX] = 1;
						Done = 1;
					end
					3'b010: // add: RXout, Ain
					begin
						Rout[RX] = 1;
						Ain = 1;
						Done = 0;
						sub = 0;
					end
					3'b011: // sub: RXout, Ain
					begin
						Rout[RX] = 1;
						Ain = 1;
						Done = 0;
						sub = 1;
					end
				endcase
			end		
			2'b10: // time step 2
			begin				
				Done = 0;
				Rin[0] = 0;
				Rin[1] = 0;
				Rin[2] = 0;
				Rin[3] = 0;
				Rin[4] = 0;
				Rin[5] = 0;
				Rin[6] = 0;
				Rin[7] = 0;
				Ain = 0;
				Gin = 0;
				Rout[0] = 0;
				Rout[1] = 0;
				Rout[2] = 0;
				Rout[3] = 0;
				Rout[4] = 0;
				Rout[5] = 0;
				Rout[6] = 0;
				Rout[7] = 0;
				DINout = 0;
			end		
			2'b11: // time step 3
			begin				
				Done = 0;
				Rin[0] = 0;
				Rin[1] = 0;
				Rin[2] = 0;
				Rin[3] = 0;
				Rin[4] = 0;
				Rin[5] = 0;
				Rin[6] = 0;
				Rin[7] = 0;
				Ain = 0;
				Gin = 0;
				Rout[0] = 0;
				Rout[1] = 0;
				Rout[2] = 0;
				Rout[3] = 0;
				Rout[4] = 0;
				Rout[5] = 0;
				Rout[6] = 0;
				Rout[7] = 0;
				DINout = 0;
			end
		endcase
	end
	
	// regs
	regn reg0 (BusWires, Rin[0], Clock, R[0]);
	regn reg1 (BusWires, Rin[1], Clock, R[1]);
	regn reg2 (BusWires, Rin[2], Clock, R[2]);
	regn reg3 (BusWires, Rin[3], Clock, R[3]);
	regn reg4 (BusWires, Rin[4], Clock, R[4]);
	regn reg5 (BusWires, Rin[5], Clock, R[5]);
	regn reg6 (BusWires, Rin[6], Clock, R[6]);
	regn reg7 (BusWires, Rin[7], Clock, R[7]);	
	regn regA (BusWires, Ain, Clock, A);
	regn regG (GinData, Gin, Clock, G);
	
	// somador
	assign GinData = ({16{~sub}} & (A[15:0] + BusWires));
	
	assign BusWires = ({16{Rout[0]}} & R[0]) | ({16{Rout[1]}} & R[1]) | ({16{Rout[2]}} & R[2]) | ({16{Rout[3]}} & R[3])
	 | ({16{Rout[4]}} & R[4]) | ({16{Rout[5]}} & R[5]) | ({16{Rout[6]}} & R[6]) | ({16{Rout[7]}} & R[7]) | ({16{DINout}} & DIN) 
	 | ({16{Gout}} & G) | ({16{Aout}} & A);
	assign State = Tstep_Q;
endmodule