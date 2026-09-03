`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 01:45:42 PM
// Design Name: 
// Module Name: switch_fabric
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

module switch_fabric (
    // Input Data
    input  wire [9:0] ip0_data,
    input  wire [9:0] ip1_data,
    input  wire [9:0] ip2_data,
    input  wire [9:0] ip3_data,

    // Grants for OP0
    input  wire grant_ip0_to_op0,
    input  wire grant_ip1_to_op0,
    input  wire grant_ip2_to_op0,
    input  wire grant_ip3_to_op0,

    // Grants for OP1
    input  wire grant_ip0_to_op1,
    input  wire grant_ip1_to_op1,
    input  wire grant_ip2_to_op1,
    input  wire grant_ip3_to_op1,

    // Grants for OP2
    input  wire grant_ip0_to_op2,
    input  wire grant_ip1_to_op2,
    input  wire grant_ip2_to_op2,
    input  wire grant_ip3_to_op2,

    // Grants for OP3
    input  wire grant_ip0_to_op3,
    input  wire grant_ip1_to_op3,
    input  wire grant_ip2_to_op3,
    input  wire grant_ip3_to_op3,

    // Output Data & Valid
    output reg  [9:0] op0_data,
    output wire       op0_valid,
    output reg  [9:0] op1_data,
    output wire       op1_valid,
    output reg  [9:0] op2_data,
    output wire       op2_valid,
    output reg  [9:0] op3_data,
    output wire       op3_valid
);

    // Output Valid Generation (Logical OR of all grants for a specific output)
    assign op0_valid = grant_ip0_to_op0 | grant_ip1_to_op0 | grant_ip2_to_op0 | grant_ip3_to_op0;
    assign op1_valid = grant_ip0_to_op1 | grant_ip1_to_op1 | grant_ip2_to_op1 | grant_ip3_to_op1;
    assign op2_valid = grant_ip0_to_op2 | grant_ip1_to_op2 | grant_ip2_to_op2 | grant_ip3_to_op2;
    assign op3_valid = grant_ip0_to_op3 | grant_ip1_to_op3 | grant_ip2_to_op3 | grant_ip3_to_op3;

    // 4:1 MUX for OP0
    always @(*) begin
        case ({grant_ip0_to_op0, grant_ip1_to_op0, grant_ip2_to_op0, grant_ip3_to_op0})
            4'b1000: op0_data = ip0_data;
            4'b0100: op0_data = ip1_data;
            4'b0010: op0_data = ip2_data;
            4'b0001: op0_data = ip3_data;
            default: op0_data = 10'b0; // Fail-safe for no grant or invalid multi-grant
        endcase
    end

    // 4:1 MUX for OP1
    always @(*) begin
        case ({grant_ip0_to_op1, grant_ip1_to_op1, grant_ip2_to_op1, grant_ip3_to_op1})
            4'b1000: op1_data = ip0_data;
            4'b0100: op1_data = ip1_data;
            4'b0010: op1_data = ip2_data;
            4'b0001: op1_data = ip3_data;
            default: op1_data = 10'b0;
        endcase
    end

    // 4:1 MUX for OP2
    always @(*) begin
        case ({grant_ip0_to_op2, grant_ip1_to_op2, grant_ip2_to_op2, grant_ip3_to_op2})
            4'b1000: op2_data = ip0_data;
            4'b0100: op2_data = ip1_data;
            4'b0010: op2_data = ip2_data;
            4'b0001: op2_data = ip3_data;
            default: op2_data = 10'b0;
        endcase
    end

    // 4:1 MUX for OP3
    always @(*) begin
        case ({grant_ip0_to_op3, grant_ip1_to_op3, grant_ip2_to_op3, grant_ip3_to_op3})
            4'b1000: op3_data = ip0_data;
            4'b0100: op3_data = ip1_data;
            4'b0010: op3_data = ip2_data;
            4'b0001: op3_data = ip3_data;
            default: op3_data = 10'b0;
        endcase
    end

endmodule