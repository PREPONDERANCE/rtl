/*数据暂存器x，存放ALU的一个输入，另外一个输入来自于总线*/
module x(din, clk, rst,xload, dout);
	input[7:0] din;
	input clk, rst, xload;
	output reg[7:0] dout;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			dout <= 0;
		end else begin
			if (xload) begin
				dout <= din;
			end
		end
	end
	
endmodule

