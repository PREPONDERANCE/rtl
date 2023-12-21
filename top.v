//the relatively complex cpu 
//design by cgy,2020.11
//modify by zhy,2023.11
//实例化，将分频模块，cpu模块,存储器模块,显示模块连接到一起。
module top(clk,rst,A1,SW_choose,SW1,SW2,D,addr,rambus,data,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,r0dbus,r1dbus,r2dbus,r3dbus,cpustate_led,
				check_out,quick_low_led,read_led,write_led,arload_led,arinc_led,pcinc_led,pcload_led,drload_led,trload_led,irload_led,
				r1load_led,r0load_led,zload_led,pcbus_led,drhbus_led,drlbus_led,trbus_led,r1bus_led,r0bus_led,membus_led,busmem_led,
				clr_led);
				
	input clk, rst;
	input A1;
	input SW_choose,SW1,SW2;
	input [7:0] D;
	output[15:0]addr;
	output [7:0]rambus;
	output [7:0] data;
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	output [7:0] r0dbus;//r0通用寄存器的输出
	output [7:0] r1dbus;//r1通用寄存器的输出
	output [7:0] r2dbus;//r2通用寄存器的输出
	output [7:0] r3dbus;//r3通用寄存器的输出
	output [1:0] cpustate_led;
	output [7:0] check_out;
	output quick_low_led;
	output read_led,write_led,arload_led,arinc_led,pcinc_led,pcload_led,drload_led,trload_led,irload_led,r1load_led,r0load_led,zload_led,pcbus_led,drhbus_led,drlbus_led,trbus_led,r1bus_led,r0bus_led,membus_led,busmem_led,clr_led;
	wire Z;
	wire read,write,arload,arinc,pcinc,pcload,drload,trload,irload,r1load,r0load,r2load,r3load,xload,yload,zload,pcbus,drhbus,drlbus,trbus,r1bus,r0bus,r2bus,r3bus,ybus,membus,busmem,clr;
	wire clk_quick,clk_slow,clk_delay,clk_mem,clk_light;
	wire [1:0] cpustate;
	wire [7:0] irout;
	wire [7:0] rs,rd;//rs和rd在数码管上的输出
	/*----------分频程序---------------*/
	//综合用
	/*clk_div quick(.clk(clk),.reset(rst),.symbol(32'd16384000),.div_clk(clk_quick));
	clk_div slow(.clk(clk),.reset(rst),.symbol(32'd49152000),.div_clk(clk_slow));
	clk_div delay(.clk(clk),.reset(rst),.symbol(32'd2048000),.div_clk(clk_delay));
	clk_div mem(.clk(clk),.reset(rst),.symbol(32'd2048000),.div_clk(clk_mem));
	clk_div light(.clk(clk),.reset(rst),.symbol(32'd2048000),.div_clk(clk_light));*/
	//仿真用
	clk_div quick(.clk(clk),.reset(rst),.symbol(32'd3),.div_clk(clk_quick));
	clk_div slow(.clk(clk),.reset(rst),.symbol(32'd6),.div_clk(clk_slow));
	clk_div delay(.clk(clk),.reset(rst),.symbol(32'd1),.div_clk(clk_delay));
	clk_div mem(.clk(clk),.reset(rst),.symbol(32'd3),.div_clk(clk_mem));
	clk_div light(.clk(clk),.reset(rst),.symbol(32'd3),.div_clk(clk_light));
	/*-------------------------------*/

	/*CPU_Controller(SW1,SW2,CPU_state);*/
	CPU_Controller controller(.SW1(SW1),.SW2(SW2),.CPU_state(cpustate));

	//补充cpu实例化的语句
	cpu mcpu(.data_in(data), .clk_quick(clk_quick), .clk_slow(clk_slow), .clk_delay(clk_delay), .rst(rst), .SW_choose(SW_choose), .A1(A1), .cpustate(cpustate), .addr(addr), .data_out(rambus), .r0dbus(r0dbus), .r1dbus(r1dbus), .r2dbus(r2dbus), .r3dbus(r3dbus), .read(read), .write(write), .membus(membus), .busmem(busmem), .arload(arload), .arinc(arinc), .pcload(pcload), .pcinc(pcinc), .pcbus(pcbus), .drload(drload), .drlbus(drlbus), .drhbus(drhbus), .irload(irload), .trload(trload), .trbus(trbus), .clr(clr), .irout(irout), .r0load(r0load), .r0bus(r0bus), .r1load(r1load), .r1bus(r1bus), .r2load(r2load), .r2bus(r2bus), .r3load(r3bus), .xload(xload), .yload(yload), .zload(zload), .ybus(ybus));

	/*ram(clk,data_in,addr,A1,reset,read,write,cpustate,D,data_out,check_out);*/
	ram mm(.clk(clk_mem),.data_in(data),.addr(addr),.A1(A1),.reset(rst),.read(read),.write(write),.cpustate(cpustate),.D(D),.data_out(rambus),.check_out(check_out));

	//根据irout的高4位对应的指令，再通过irout的第3位和第2位的值给rd赋值，请补充
	/*例如指令设计了add和sub，irout的高四位分别是0001和0010，则rd可如下赋值，需根据自行设计的指令补充rd的赋值
	assign rd=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[3:2]==2'b00)?r0dbus:8'bzzzzzzzz):8'bzzzzzzzz;
	assign rd=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[3:2]==2'b01)?r1dbus:8'bzzzzzzzz):8'bzzzzzzzz;
	assign rd=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[3:2]==2'b10)?r2dbus:8'bzzzzzzzz):8'bzzzzzzzz;
	assign rd=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[3:2]==2'b11)?r3dbus:8'bzzzzzzzz):8'bzzzzzzzz;*/
	assign rd = ( (irout[7:4]==4'b0001) || (irout[7:4]==4'b0010) || (irout[7:4]==4'b0011 || (irout[7:4]==4'b0100) || (irout[7:4]==4'b0101) || (irout[7:4]==4'b0110) || (irout[7:4]==4'b0111) || (irout[7:4]==4'b1000) || (irout[7:4]==4'b1001) || ())) ? 



	//根据irout的高4位对应的指令，再通过irout的第1位和第0位的值给rs赋值，请补充
	/*例如指令设计了add和sub，irout的高四位分别是0001和0010，则rs可如下赋值，需根据自行设计的指令补充rs的赋值
	assign rs=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[1:0]==2'b00)?r0dbus:8'bzzzzzzzz):8'bzzzzzzzz;
	assign rs=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[1:0]==2'b01)?r1dbus:8'bzzzzzzzz):8'bzzzzzzzz;
	assign rs=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[1:0]==2'b10)?r2dbus:8'bzzzzzzzz):8'bzzzzzzzz;
	assign rs=((irout[7:4]==4'b0001) || (irout[7:4]==4'b0010))?((irout[1:0]==2'b11)?r3dbus:8'bzzzzzzzz):8'bzzzzzzzz;*/




	light_show show(.light_clk(clk_light),.SW_choose(SW_choose),.check_in(check_out),.read(read),.write(write),.arload(arload),.arinc(arinc),.pcinc(pcinc),.pcload(pcload),.drload(drload),
						.trload(trload),.irload(irload),.r1load(r1load),.r0load(r0load),.zload(zload),.pcbus(pcbus),.drhbus(drhbus),.drlbus(drlbus),.trbus(trbus),.r1bus(r1bus),.r0bus(r0bus),
						.membus(membus),.busmem(busmem),.clr(clr),.State(cpustate),.MAR(addr[7:0]),.rd(rd),.rs(rs),.Z(Z),.HEX0(HEX0),
						.HEX1(HEX1),.HEX2(HEX2),.HEX3(HEX3),.HEX4(HEX4),.HEX5(HEX5),.HEX6(HEX6),.HEX7(HEX7),.State_LED(cpustate_led),
						.quick_low_led(quick_low_led),.read_led(read_led),.write_led(write_led),.arload_led(arload_led),.arinc_led(arinc_led),
						.pcinc_led(pcinc_led),.pcload_led(pcload_led),.drload_led(drload_led),.trload_led(trload_led),.irload_led(irload_led),.r1load_led(r1load_led),.r0load_led(r0load_led),
						.zload_led(zload_led),.pcbus_led(pcbus_led),.drhbus_led(drhbus_led),.drlbus_led(drlbus_led),.trbus_led(trbus_led),.r1bus_led(r1bus_led),.r0bus_led(r0bus_led),.membus_led(membus_led),
						.busmem_led(busmem_led),.clr_led(clr_led));
endmodule

