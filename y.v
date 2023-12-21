/*暂存器Y，存放ALU的运算结果*/
module y(din, clk, rst,yload, dout);
	input[7:0] din;
	input clk, rst,yload;
	output reg[7:0] dout;
	
	always@(posedge clk or negedge rst)
		begin
			if( rst == 0 )
				dout <= 8'b0;
			else if( yload )
				dout <= din;
		end
endmodule