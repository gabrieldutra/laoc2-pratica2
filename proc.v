module proc (DIN, Resetn, Clock, Run, Done, BusWires);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output reg Done;
	output [15:0] BusWires;
	
	wire [15:0] IR;
	wire [15:0] R [0:7];
	wire RX, RY;
	wire Xreg, Yreg;
	
	regn regI (DIN, IRin, Clock, IR);
	
	assign I = IR[8:6];
	assign RX = IR[5:3];
	assign RY = IR[2:0];
	
	reg IRin = 0;	
	reg Rin[0:7];
	reg Rout[0:7];
	reg Ain;
	reg Gin;
	reg DINout;
	
	wire Clear = Resetn;
	upcount Tstep (Clear, Clock, Tstep_Q);
	dec3to8 decX (RX, 1'b1, Xreg);
	dec3to8 decY (RY, 1'b1, Yreg);
	
	always @(Tstep_Q or I or Xreg or Yreg)
	begin
		case(Tstep_Q)
			2'b00: // time step 0 - store DIN in IR on step 0
			begin
				IRin = 1'b1; // 
			end		
			2'b01: // time step 1 - (mv: RYout, RXin and Done; mvi: DINout and RXin; add: RXout, Ain; sub: RXout, Ain)
			begin
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
						Rout[RY] = 1;
						Rin[RX] = 1;
						Done = 1;
					end
					3'b011: // sub: RXout, Ain
					begin
						Rout[RY] = 1;
						Rin[RX] = 1;
						Done = 1;
					end
				endcase
			end		
			2'b10: // time step 2
			begin
			end		
			2'b11: // time step 3
			begin	
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
	
	assign BusWires = ({8{Rout[0]}} & R[0]) | ({8{Rout[1]}} & R[1]) | ({8{Rout[2]}} & R[2]) | ({8{Rout[3]}} & R[3])
	 | ({8{Rout[4]}} & R[4]) | ({8{Rout[5]}} & R[5]) | ({8{Rout[6]}} & R[6]) | ({8{Rout[7]}} & R[7]);
endmodule