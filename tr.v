/*数据暂存器,处理双字节指令时使用，用来存储第八位的地址或数值*/
module tr(din, clk,rst, trload, dout);
    input[7:0] din;
    input clk, rst, trload;
    output reg[7:0] dout;

    always@(posedge clk or negedge rst)
        begin
			if( rst == 0 )
				dout <= 8'b0;
			else if( trload )
				dout <= din;
		end
endmodule