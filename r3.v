/*r3通用寄存器*/
module r3(din, clk, rst,r3load, dout);
	input[7:0] din;
	input clk, rst, r3load;
	output reg[7:0] dout;
	
	always@(posedge clk or negedge rst)
		begin
			if( rst == 0 )
				dout <= 8'b0;
			else if( r3load )
				dout <= din;
		end
endmodule