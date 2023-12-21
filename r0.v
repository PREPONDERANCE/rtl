/*r0通用寄存器*/
module r0(din, clk, rst,r0load, dout);
	input[7:0] din;
	input clk, rst, r0load;
	output reg[7:0] dout;
	
	always@(posedge clk or negedge rst)
		begin
			if( rst == 0 )
				dout <= 8'b0;
			else if( r0load )
				dout <= din;
		end

endmodule
