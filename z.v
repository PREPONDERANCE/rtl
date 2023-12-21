/*标志寄存器*/
module z(din,clk,rst,zload,dout);
    input[7:0] din;
    input clk, rst, zload;
    output reg dout;

    always@(posedge clk or negedge rst)
        begin
			if( rst == 0 )
				dout <= 1'b0;
			else if( zload )
				dout <= (din == 0);
		end
	
endmodule