`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 03:30:01 PM
// Design Name: 
// Module Name: router_4x4
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

module router_4x4 (
    input  wire       clk,
    input  wire       rst,

    input  wire [9:0] ip0_data,
    input  wire       ip0_valid,
    input  wire [9:0] ip1_data,
    input  wire       ip1_valid,
    input  wire [9:0] ip2_data,
    input  wire       ip2_valid,
    input  wire [9:0] ip3_data,
    input  wire       ip3_valid,

    output wire [9:0] op0_data,
    output wire       op0_valid,
    output wire [9:0] op1_data,
    output wire       op1_valid,
    output wire [9:0] op2_data,
    output wire       op2_valid,
    output wire [9:0] op3_data,
    output wire       op3_valid
);

    // 16 Internal Request Signals (req_IP_to_OP)
    wire req_ip0_to_op0, req_ip0_to_op1, req_ip0_to_op2, req_ip0_to_op3;
    wire req_ip1_to_op0, req_ip1_to_op1, req_ip1_to_op2, req_ip1_to_op3;
    wire req_ip2_to_op0, req_ip2_to_op1, req_ip2_to_op2, req_ip2_to_op3;
    wire req_ip3_to_op0, req_ip3_to_op1, req_ip3_to_op2, req_ip3_to_op3;

    // 16 Internal Grant Signals (grant_IP_to_OP)
    wire grant_ip0_to_op0, grant_ip1_to_op0, grant_ip2_to_op0, grant_ip3_to_op0;
    wire grant_ip0_to_op1, grant_ip1_to_op1, grant_ip2_to_op1, grant_ip3_to_op1;
    wire grant_ip0_to_op2, grant_ip1_to_op2, grant_ip2_to_op2, grant_ip3_to_op2;
    wire grant_ip0_to_op3, grant_ip1_to_op3, grant_ip2_to_op3, grant_ip3_to_op3;

    // ---------------------------------------------------------
    // CONTROL PATH: Decoders (1 per Input)
    // ---------------------------------------------------------
    router_decoder dec_ip0 (
        .packet(ip0_data), .valid(ip0_valid),
        .req_op0(req_ip0_to_op0), .req_op1(req_ip0_to_op1), .req_op2(req_ip0_to_op2), .req_op3(req_ip0_to_op3)
    );

    router_decoder dec_ip1 (
        .packet(ip1_data), .valid(ip1_valid),
        .req_op0(req_ip1_to_op0), .req_op1(req_ip1_to_op1), .req_op2(req_ip1_to_op2), .req_op3(req_ip1_to_op3)
    );

    router_decoder dec_ip2 (
        .packet(ip2_data), .valid(ip2_valid),
        .req_op0(req_ip2_to_op0), .req_op1(req_ip2_to_op1), .req_op2(req_ip2_to_op2), .req_op3(req_ip2_to_op3)
    );

    router_decoder dec_ip3 (
        .packet(ip3_data), .valid(ip3_valid),
        .req_op0(req_ip3_to_op0), .req_op1(req_ip3_to_op1), .req_op2(req_ip3_to_op2), .req_op3(req_ip3_to_op3)
    );

    // ---------------------------------------------------------
    // CONTROL PATH: Arbiters (1 per Output)
    // ---------------------------------------------------------
    arbiter arb_op0 (
        .req_ip0(req_ip0_to_op0), .req_ip1(req_ip1_to_op0), .req_ip2(req_ip2_to_op0), .req_ip3(req_ip3_to_op0),
        .grant_ip0(grant_ip0_to_op0), .grant_ip1(grant_ip1_to_op0), .grant_ip2(grant_ip2_to_op0), .grant_ip3(grant_ip3_to_op0)
    );

    arbiter arb_op1 (
        .req_ip0(req_ip0_to_op1), .req_ip1(req_ip1_to_op1), .req_ip2(req_ip2_to_op1), .req_ip3(req_ip3_to_op1),
        .grant_ip0(grant_ip0_to_op1), .grant_ip1(grant_ip1_to_op1), .grant_ip2(grant_ip2_to_op1), .grant_ip3(grant_ip3_to_op1)
    );

    arbiter arb_op2 (
        .req_ip0(req_ip0_to_op2), .req_ip1(req_ip1_to_op2), .req_ip2(req_ip2_to_op2), .req_ip3(req_ip3_to_op2),
        .grant_ip0(grant_ip0_to_op2), .grant_ip1(grant_ip1_to_op2), .grant_ip2(grant_ip2_to_op2), .grant_ip3(grant_ip3_to_op2)
    );

    arbiter arb_op3 (
        .req_ip0(req_ip0_to_op3), .req_ip1(req_ip1_to_op3), .req_ip2(req_ip2_to_op3), .req_ip3(req_ip3_to_op3),
        .grant_ip0(grant_ip0_to_op3), .grant_ip1(grant_ip1_to_op3), .grant_ip2(grant_ip2_to_op3), .grant_ip3(grant_ip3_to_op3)
    );

    // ---------------------------------------------------------
    // DATA PATH: Switch Fabric
    // ---------------------------------------------------------
    switch_fabric sw_fab (
        .ip0_data(ip0_data), .ip1_data(ip1_data), .ip2_data(ip2_data), .ip3_data(ip3_data),
        
        .grant_ip0_to_op0(grant_ip0_to_op0), .grant_ip1_to_op0(grant_ip1_to_op0), .grant_ip2_to_op0(grant_ip2_to_op0), .grant_ip3_to_op0(grant_ip3_to_op0),
        .grant_ip0_to_op1(grant_ip0_to_op1), .grant_ip1_to_op1(grant_ip1_to_op1), .grant_ip2_to_op1(grant_ip2_to_op1), .grant_ip3_to_op1(grant_ip3_to_op1),
        .grant_ip0_to_op2(grant_ip0_to_op2), .grant_ip1_to_op2(grant_ip1_to_op2), .grant_ip2_to_op2(grant_ip2_to_op2), .grant_ip3_to_op2(grant_ip3_to_op2),
        .grant_ip0_to_op3(grant_ip0_to_op3), .grant_ip1_to_op3(grant_ip1_to_op3), .grant_ip2_to_op3(grant_ip2_to_op3), .grant_ip3_to_op3(grant_ip3_to_op3),
        
        .op0_data(op0_data), .op0_valid(op0_valid),
        .op1_data(op1_data), .op1_valid(op1_valid),
        .op2_data(op2_data), .op2_valid(op2_valid),
        .op3_data(op3_data), .op3_valid(op3_valid)
    );

endmodule