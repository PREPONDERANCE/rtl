/*r2通用寄存器*/
module r2(din, clk, rst,r2load, dout);
	input[7:0] din;
	input clk, rst, r2load;
	output reg[7:0] dout;
	
	always@(posedge clk or negedge rst)
		begin
			if( rst == 0 )
				dout <= 8'b0;
			else if( r2load )
				dout <= din;
		end
endmodule