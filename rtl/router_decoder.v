`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 12:06:26 PM
// Design Name: 
// Module Name: router_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module router_decoder (
    input  wire [9:0] packet,
    input  wire       valid,
    output wire       req_op0,
    output wire       req_op1,
    output wire       req_op2,
    output wire       req_op3
);

    // Continuous assignments for combinational decoding
    // Requests are asserted only if the packet is valid AND destination matches
    assign req_op0 = valid & (packet[9:8] == 2'b00);
    assign req_op1 = valid & (packet[9:8] == 2'b01);
    assign req_op2 = valid & (packet[9:8] == 2'b10);
    assign req_op3 = valid & (packet[9:8] == 2'b11);

endmodule
