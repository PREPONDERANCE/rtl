/*地址寄存器，输出要执行的下一指令地址*/
module ar(din, clk, rst,arload, arinc, dout);
input[15:0] din;
input clk,rst,arload, arinc;
output [15:0]dout;
reg [15:0]dout;
always@(posedge clk or negedge rst)
if(!rst)
	dout<=0;
else
	if(arload)
		dout<=din;
	else if(arinc)
		dout<=dout+16'd1;
endmodule