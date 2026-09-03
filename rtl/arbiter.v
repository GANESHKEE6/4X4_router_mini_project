`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 12:57:13 PM
// Design Name: 
// Module Name: arbiter
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

module arbiter (
    input  wire req_ip0,
    input  wire req_ip1,
    input  wire req_ip2,
    input  wire req_ip3,
    output wire grant_ip0,
    output wire grant_ip1,
    output wire grant_ip2,
    output wire grant_ip3
);

    // Fixed priority: IP0 > IP1 > IP2 > IP3
    assign grant_ip0 = req_ip0;
    assign grant_ip1 = ~req_ip0 & req_ip1;
    assign grant_ip2 = ~req_ip0 & ~req_ip1 & req_ip2;
    assign grant_ip3 = ~req_ip0 & ~req_ip1 & ~req_ip2 & req_ip3;

endmodule