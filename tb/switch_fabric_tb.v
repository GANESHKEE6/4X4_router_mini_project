`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 01:48:29 PM
// Design Name: 
// Module Name: switch_fabric_tb
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

module switch_fabric_tb;

    // Data Inputs
    reg [9:0] ip0_data, ip1_data, ip2_data, ip3_data;
    
    // Grant Inputs (Grouped for testbench convenience, MSB=IP0, LSB=IP3)
    reg [3:0] g_op0, g_op1, g_op2, g_op3;

    // Outputs
    wire [9:0] op0_data, op1_data, op2_data, op3_data;
    wire       op0_valid, op1_valid, op2_valid, op3_valid;

    // Tracking
    integer test_count = 0;
    integer fail_count = 0;

    // DUT Instantiation
    switch_fabric dut (
        .ip0_data(ip0_data), .ip1_data(ip1_data), .ip2_data(ip2_data), .ip3_data(ip3_data),
        
        .grant_ip0_to_op0(g_op0[3]), .grant_ip1_to_op0(g_op0[2]), .grant_ip2_to_op0(g_op0[1]), .grant_ip3_to_op0(g_op0[0]),
        .grant_ip0_to_op1(g_op1[3]), .grant_ip1_to_op1(g_op1[2]), .grant_ip2_to_op1(g_op1[1]), .grant_ip3_to_op1(g_op1[0]),
        .grant_ip0_to_op2(g_op2[3]), .grant_ip1_to_op2(g_op2[2]), .grant_ip2_to_op2(g_op2[1]), .grant_ip3_to_op2(g_op2[0]),
        .grant_ip0_to_op3(g_op3[3]), .grant_ip1_to_op3(g_op3[2]), .grant_ip2_to_op3(g_op3[1]), .grant_ip3_to_op3(g_op3[0]),
        
        .op0_data(op0_data), .op0_valid(op0_valid),
        .op1_data(op1_data), .op1_valid(op1_valid),
        .op2_data(op2_data), .op2_valid(op2_valid),
        .op3_data(op3_data), .op3_valid(op3_valid)
    );

    // Verification Task
    task check_outputs;
        input [9:0] exp_d0, exp_d1, exp_d2, exp_d3;
        input       exp_v0, exp_v1, exp_v2, exp_v3;
        input [80*8:1] test_name;
        begin
            #5;
            test_count = test_count + 1;
            if (op0_data !== exp_d0 || op0_valid !== exp_v0 ||
                op1_data !== exp_d1 || op1_valid !== exp_v1 ||
                op2_data !== exp_d2 || op2_valid !== exp_v2 ||
                op3_data !== exp_d3 || op3_valid !== exp_v3) begin
                $display("FAIL: %s", test_name);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: %s", test_name);
            end
            #5;
        end
    endtask

    initial begin
        $display("Starting Switch Fabric Testbench...");
        
        // Setup distinct packet signatures
        ip0_data = 10'h0AA; // IP0 distinct data
        ip1_data = 10'h1BB; // IP1 distinct data
        ip2_data = 10'h2CC; // IP2 distinct data
        ip3_data = 10'h3DD; // IP3 distinct data

        // TEST 1: No Grants
        g_op0 = 4'b0000; g_op1 = 4'b0000; g_op2 = 4'b0000; g_op3 = 4'b0000;
        check_outputs(0,0,0,0,  0,0,0,0, "No Grants Active");

        // TESTS 2-5: All IPs to OP0
        g_op0 = 4'b1000; check_outputs(ip0_data,0,0,0, 1,0,0,0, "IP0 -> OP0");
        g_op0 = 4'b0100; check_outputs(ip1_data,0,0,0, 1,0,0,0, "IP1 -> OP0");
        g_op0 = 4'b0010; check_outputs(ip2_data,0,0,0, 1,0,0,0, "IP2 -> OP0");
        g_op0 = 4'b0001; check_outputs(ip3_data,0,0,0, 1,0,0,0, "IP3 -> OP0");
        g_op0 = 4'b0000;

        // TESTS 6-9: All IPs to OP1
        g_op1 = 4'b1000; check_outputs(0,ip0_data,0,0, 0,1,0,0, "IP0 -> OP1");
        g_op1 = 4'b0100; check_outputs(0,ip1_data,0,0, 0,1,0,0, "IP1 -> OP1");
        g_op1 = 4'b0010; check_outputs(0,ip2_data,0,0, 0,1,0,0, "IP2 -> OP1");
        g_op1 = 4'b0001; check_outputs(0,ip3_data,0,0, 0,1,0,0, "IP3 -> OP1");
        g_op1 = 4'b0000;

        // TESTS 10-13: All IPs to OP2
        g_op2 = 4'b1000; check_outputs(0,0,ip0_data,0, 0,0,1,0, "IP0 -> OP2");
        g_op2 = 4'b0100; check_outputs(0,0,ip1_data,0, 0,0,1,0, "IP1 -> OP2");
        g_op2 = 4'b0010; check_outputs(0,0,ip2_data,0, 0,0,1,0, "IP2 -> OP2");
        g_op2 = 4'b0001; check_outputs(0,0,ip3_data,0, 0,0,1,0, "IP3 -> OP2");
        g_op2 = 4'b0000;

        // TESTS 14-17: All IPs to OP3
        g_op3 = 4'b1000; check_outputs(0,0,0,ip0_data, 0,0,0,1, "IP0 -> OP3");
        g_op3 = 4'b0100; check_outputs(0,0,0,ip1_data, 0,0,0,1, "IP1 -> OP3");
        g_op3 = 4'b0010; check_outputs(0,0,0,ip2_data, 0,0,0,1, "IP2 -> OP3");
        g_op3 = 4'b0001; check_outputs(0,0,0,ip3_data, 0,0,0,1, "IP3 -> OP3");
        g_op3 = 4'b0000;

        // TEST 18: Simultaneous Independent Routing
        g_op0 = 4'b1000; // IP0 -> OP0
        g_op1 = 4'b0100; // IP1 -> OP1
        g_op2 = 4'b0010; // IP2 -> OP2
        g_op3 = 4'b0001; // IP3 -> OP3
        check_outputs(ip0_data, ip1_data, ip2_data, ip3_data, 1, 1, 1, 1, "Simultaneous 4x4 Routing");

        // TEST 19: Contention/Grant Switching (IP0 vs IP1 on OP2)
        g_op0 = 0; g_op1 = 0; g_op3 = 0;
        
        g_op2 = 4'b1000; // IP0 wins OP2
        check_outputs(0, 0, ip0_data, 0, 0, 0, 1, 0, "Contention Switch: IP0 wins OP2");
        
        g_op2 = 4'b0100; // IP1 wins OP2
        check_outputs(0, 0, ip1_data, 0, 0, 0, 1, 0, "Contention Switch: IP1 wins OP2");

        // Summary
        $display("\n=================================");
        $display("Total Tests : %0d", test_count);
        $display("Failures    : %0d", fail_count);
        if (fail_count == 0) $display("Result      : TEST PASSED");
        else                 $display("Result      : TEST FAILED");
        $display("=================================");
        $finish;
    end
endmodule