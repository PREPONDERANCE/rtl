
//`timescale 1ns / 1ps

module CPU_Controller(SW1,SW2,CPU_state);

input SW1,SW2;
output [1:0] CPU_state;

assign CPU_state = {SW2,SW1};

endmodule
