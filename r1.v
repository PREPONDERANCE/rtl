/*r1通用寄存器*/
module r1(din, clk, rst,r1load, dout);
	input[7:0] din;
	input clk, rst, r1load;
	output reg[7:0] dout;
	
	always@(posedge clk or negedge rst)
		begin
			if( rst == 0 )
				dout <= 8'b0;
			else if( r1load )
				dout <= din;
		end
endmodule
