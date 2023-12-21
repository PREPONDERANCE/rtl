/*存储器，完成IN状态的输入，CHECK状态的检查，RUN状态的写入*/
/*输入clk：时钟信号，进行时序控制；1位，来自分频程序clk_div的输出；只在IN和CHECK状态时，其上升沿有效；
   输入data_in：数据输入；8位，来自于cpu模块的data_out，即cpu写入存储器的数据；
   输入addr：地址；16位，来源于地址寄存器ar模块的输出；
   输入A1：为按钮key1，按下时（置0）有效，在IN状态下进行存储操作，在CHECK状态下进行检查操作；
   输入reset：为清零信号，1位，为零时有效，将内部计数器清零，将内部延时信号置1；
   输入read：为控制信号，1位，1为有效，读出存储器ram[addr2]或memory[addr1]的值；
   输入write：为控制信号，1位，1为有效，将data_in写入ram[addr2]；
   输入cpustate：cpu的状态，2位，01表示输入（IN状态），10表示检查（CHECK状态），11表示运行（RUN状态）
   输入D：由FPGA开发板上SW7-SW0拨动开关的值组成，IN状态下按下A1按钮时进行存储操作，将指令存在内部寄存器memory中；
   输出data_out：8位，只在RUN状态下有效，其余状态时为高阻态，有效时如果addr[15:5]=0（即当前地址在0-31）则输出memeory[addr1]的内容，如果addr[15:5]!=0，则输出ram[addr2] 的内容；
   输出check_out：8位，只在CHECK状态下有效，其余状态为高阻态，有效时输出当前地址cnt在memory存储的指令。
*/
module ram(clk,data_in,addr,A1,reset,read,write,cpustate,D,data_out,check_out);

input clk;
input [7:0] data_in;
input [15:0] addr;
input A1;
input reset;
input read,write;
input [1:0] cpustate;
input [7:0] D;//用于IN模式的开关输入
output [7:0] data_out;
output [7:0] check_out;//CHECK状态下的输出

/****in和check状态使用*****/
reg [7:0] memory [31:0];
//reg [31:0] cnt;
reg A_d1,A_d2;
reg [127:0] cnt;
wire A_Neg;
/*******run状态使用********/
reg [7:0] data_rom;
wire [4:0] addr1;
wire [10:0] addr2;
wire [7:0] data_ram;
reg [7:0] ram [127:0];
/*********/

assign addr1 = addr[4:0];
assign addr2 = addr[15:5];
assign data_ram=(read)? ram[addr2]:8'bzzzzzzzz;
assign data_out=(cpustate != 2'b11)?8'hzz:((|addr[15:5])?data_ram:data_rom);

always @(write or data_in)
	if(write) ram[addr2]<=data_in;

always @(read or addr1)
begin
	if(read)
		data_rom=memory[addr1];
end

/*-------------IN模式下的指令存储和CHECK模式下的指令检查--------------*/

always @(posedge clk or negedge reset) //将A1按钮延时1个时钟
begin
	if(!reset) A_d1 <= 1;
	else A_d1 <= A1;
end
always @(posedge clk or negedge reset) //将A1按钮延时2个时钟
begin
	if(!reset) A_d2 <= 1;
	else A_d2 <= A_d1;
end
assign A_Neg = (~A_d1)&A_d2; //若A1按钮按下，则将其变为延时1个时钟的脉冲信号
 
assign check_out = (cpustate==2'b10)?memory[cnt]:8'hzz; //check输出

always @(posedge clk or negedge reset)
begin
	if(!reset) cnt=0;
	else 
	begin
		if(cpustate == 2'b01 && A_Neg==1)//IN
		begin
			memory[cnt] = D;
			cnt = cnt+1024'd1;
		end	
		else if(cpustate == 2'b10 && A_Neg==1) cnt = cnt+1024'd1;//CHECK		
		else cnt = cnt;//保持
	end
end
/*--------------------------------指令设定-----------------------------------------*/
/*initial
	begin 	
			memory[0]=8'b10100000;//mvrd r0,1;	r0=1
			memory[1]=8'b00000001;
			memory[2]=8'b10100100;//mvrd r1,2;	r1=2
			memory[3]=8'b00000010;
			memory[4]=8'b10101000;//mvrd r2,2;	r2=2
			memory[5]=8'b00000010;
			memory[6]=8'b10101100;//mvrd r3,5;	r3=5
			memory[7]=8'b00000101;
			memory[8]=8'b00010001;//add r0,r1;	r0=3
			memory[9]=8'b00100010;//sub r0,r2;	r0=2
			memory[10]=8'b00111000;//inc r2; 	r2=3
			memory[11]=8'b01111000;//not r2; 	r2=11111100B
			memory[12]=8'b01001100;//dec r3;		r3=4
			memory[13]=8'b10001110;//shr r3;		r3=2
			memory[14]=8'b01010010;//and r0,r2;	r0=2
			memory[15]=8'b01100011;//or r0,r3;	r0=6
			memory[16]=8'b10010100;//mvr r1,r0;	r1=6
//			memory[16]=8'b00000010;//stac T4=32 in ram
//			memory[17]=8'b00100000;
//			memory[18]=8'b00000000;	
//			memory[19]=8'b00000100;//movr
//			memory[20]=8'b00000110;//jmpz here z=0,not jump
//			memory[21]=8'b00001000;
//			memory[22]=8'b01001000;
//			memory[23]=8'b00000001;//ldac T5=32;load ram
//			memory[24]=8'b00100000;
//			memory[25]=8'b00000000;
//			memory[26]=8'b00001111;//not
//			memory[27]=8'b00001100;//and
//			memory[28]=8'b00001011;//clac clear aluout put z=1
//			memory[29]=8'b00000110;//jmpz here z=1,jump to T6=0;
//			memory[30]=8'b00000000;
//			memory[31]=8'b00000000;			
	end	*/
	
endmodule
