`include "router_defines.vh"

module router_top (
    input  wire clk,
    input  wire rst_n, // Active low reset

    // Input Ports (10-bit Data + 1-bit Valid)
    input  wire [`PKT_WIDTH-1:0] ip0_data,
    input  wire                  ip0_valid,
    input  wire [`PKT_WIDTH-1:0] ip1_data,
    input  wire                  ip1_valid,
    input  wire [`PKT_WIDTH-1:0] ip2_data,
    input  wire                  ip2_valid,
    input  wire [`PKT_WIDTH-1:0] ip3_data,
    input  wire                  ip3_valid,

    // Output Ports (10-bit Data + 1-bit Valid)
    output wire [`PKT_WIDTH-1:0] op0_data,
    output wire                  op0_valid,
    output wire [`PKT_WIDTH-1:0] op1_data,
    output wire                  op1_valid,
    output wire [`PKT_WIDTH-1:0] op2_data,
    output wire                  op2_valid,
    output wire [`PKT_WIDTH-1:0] op3_data,
    output wire                  op3_valid
);

    // Internal routing, arbiters, and switch fabric logic will go here

endmodule

