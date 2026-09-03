`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 03:32:50 PM
// Design Name: 
// Module Name: router_4x4_tb
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

module router_4x4_tb;

    reg clk, rst;
    reg [9:0] ip0_data, ip1_data, ip2_data, ip3_data;
    reg ip0_valid, ip1_valid, ip2_valid, ip3_valid;

    wire [9:0] op0_data, op1_data, op2_data, op3_data;
    wire op0_valid, op1_valid, op2_valid, op3_valid;

    integer test_count = 0;
    integer fail_count = 0;

    router_4x4 dut (
        .clk(clk), .rst(rst),
        .ip0_data(ip0_data), .ip0_valid(ip0_valid),
        .ip1_data(ip1_data), .ip1_valid(ip1_valid),
        .ip2_data(ip2_data), .ip2_valid(ip2_valid),
        .ip3_data(ip3_data), .ip3_valid(ip3_valid),
        .op0_data(op0_data), .op0_valid(op0_valid),
        .op1_data(op1_data), .op1_valid(op1_valid),
        .op2_data(op2_data), .op2_valid(op2_valid),
        .op3_data(op3_data), .op3_valid(op3_valid)
    );

    task check_outputs;
        input [9:0] e_d0, e_d1, e_d2, e_d3;
        input       e_v0, e_v1, e_v2, e_v3;
        input [80*8:1] test_name;
        begin
            #5;
            test_count = test_count + 1;
            if (op0_data !== e_d0 || op0_valid !== e_v0 ||
                op1_data !== e_d1 || op1_valid !== e_v1 ||
                op2_data !== e_d2 || op2_valid !== e_v2 ||
                op3_data !== e_d3 || op3_valid !== e_v3) begin
                $display("FAIL: %s", test_name);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: %s", test_name);
            end
            #5;
        end
    endtask

    initial begin
        clk = 0; rst = 0; // Unused but initialized
        $display("Starting Complete Router Integration Tests...");

        // TEST 18: No Input
        ip0_valid=0; ip1_valid=0; ip2_valid=0; ip3_valid=0;
        check_outputs(0,0,0,0, 0,0,0,0, "No Input Condition");

        // TEST 1-4: Single IP Routing
        ip0_data=10'b00_10101010; ip0_valid=1; check_outputs(10'b00_10101010,0,0,0, 1,0,0,0, "IP0 -> OP0"); ip0_valid=0;
        ip1_data=10'b01_10101010; ip1_valid=1; check_outputs(0,10'b01_10101010,0,0, 0,1,0,0, "IP1 -> OP1"); ip1_valid=0;
        ip2_data=10'b10_10101010; ip2_valid=1; check_outputs(0,0,10'b10_10101010,0, 0,0,1,0, "IP2 -> OP2"); ip2_valid=0;
        ip3_data=10'b11_10101010; ip3_valid=1; check_outputs(0,0,0,10'b11_10101010, 0,0,0,1, "IP3 -> OP3"); ip3_valid=0;

        // TEST 17 & 22: Cross Routing & Payload Integrity
        ip0_data = {2'b11, 8'hA5}; ip0_valid=1; // IP0 -> OP3
        ip1_data = {2'b00, 8'h3C}; ip1_valid=1; // IP1 -> OP0
        ip2_data = {2'b01, 8'hF0}; ip2_valid=1; // IP2 -> OP1
        ip3_data = {2'b10, 8'h69}; ip3_valid=1; // IP3 -> OP2
        check_outputs(ip1_data, ip2_data, ip3_data, ip0_data, 1, 1, 1, 1, "Cross Routing / Payload Integrity");
        ip0_valid=0; ip1_valid=0; ip2_valid=0; ip3_valid=0;
        
        // TEST 19: Contention
        ip0_data = 10'b10_11111111; ip0_valid=1; // IP0 -> OP2
        ip1_data = 10'b10_00000000; ip1_valid=1; // IP1 -> OP2
        check_outputs(0, 0, ip0_data, 0, 0, 0, 1, 0, "Contention IP0 wins over IP1 on OP2");
        
        // TEST 20: Max Contention
        ip2_data = 10'b10_10101010; ip2_valid=1;
        ip3_data = 10'b10_01010101; ip3_valid=1;
        check_outputs(0, 0, ip0_data, 0, 0, 0, 1, 0, "Max Contention IP0 wins OP2");
        ip0_valid=0; ip1_valid=0; ip2_valid=0; ip3_valid=0;


        // TEST 21: Four-way independent
        ip0_data = {2'b00, 8'h11}; ip0_valid=1;
        ip1_data = {2'b01, 8'h22}; ip1_valid=1;
        ip2_data = {2'b10, 8'h33}; ip2_valid=1;
        ip3_data = {2'b11, 8'h44}; ip3_valid=1;
        check_outputs(ip0_data, ip1_data, ip2_data, ip3_data, 1, 1, 1, 1, "Four-way Independent Routing");
        
        // Summary
        $display("\n=================================");
        if (fail_count == 0) $display("Result      : TEST PASSED");
        else                 $display("Result      : TEST FAILED");
        $display("=================================");
        $finish;
    end
endmodule