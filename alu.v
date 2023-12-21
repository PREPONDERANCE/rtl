/*算术逻辑单元，x来自于Rs，bus来自于Rd*/
module alu(alus, x, bus, dout);
	input[2:0] alus;
	input[7:0] x;
	input[7:0] bus;
	output reg[7:0] dout;
	
	parameter
		ADD = 3'b000,
		INC = 3'b001,
		SUB = 3'b010,
		DEC = 3'b011,
		AND = 3'b100,
		OR  = 3'b101,
		NOT = 3'b110,
		SHL = 3'b111;
	
	always@(x or bus or alus)
		case(alus)
			ADD: dout = x + bus;
			SUB: dout = x - bus;
			AND: dout = x & bus;
			OR : dout = x | bus;
			INC: dout = x + 8'b00000001;
			DEC: dout = x - 8'b00000001;
			NOT: dout = ~x;
			SHL: dout = x << 1;
			default: dout = 8'b00000000;
		endcase

endmodule
