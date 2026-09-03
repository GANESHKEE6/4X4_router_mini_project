`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 04:22:52 PM
// Design Name: 
// Module Name: router1_4x4_tb
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


module router1_4x4_tb;

    reg clk, rst; // Present for interface consistency, currently unused
    
    // DUT Inputs
    reg [9:0] ip0_data, ip1_data, ip2_data, ip3_data;
    reg ip0_valid, ip1_valid, ip2_valid, ip3_valid;

    // DUT Outputs
    wire [9:0] op0_data, op1_data, op2_data, op3_data;
    wire op0_valid, op1_valid, op2_valid, op3_valid;

    // Verification Tracking
    integer test_count = 0;
    integer fail_count = 0;
    integer i;

    // Expected Output Variables (Reference Model)
    reg [9:0] exp_op0_data, exp_op1_data, exp_op2_data, exp_op3_data;
    reg exp_op0_valid, exp_op1_valid, exp_op2_valid, exp_op3_valid;

    // DUT Instantiation
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

    // REFERENCE MODEL & SCOREBOARD
    // Independently calculates expected outputs based on fixed priority (IP0 > IP1 > IP2 > IP3)
    task evaluate_and_check;
        input [80*8:1] test_name;
        begin
            #5; // Allow combinational logic to settle
            
            // Calculate Expected OP0
            if      (ip0_valid && ip0_data[9:8] == 2'b00) begin exp_op0_data = ip0_data; exp_op0_valid = 1; end
            else if (ip1_valid && ip1_data[9:8] == 2'b00) begin exp_op0_data = ip1_data; exp_op0_valid = 1; end
            else if (ip2_valid && ip2_data[9:8] == 2'b00) begin exp_op0_data = ip2_data; exp_op0_valid = 1; end
            else if (ip3_valid && ip3_data[9:8] == 2'b00) begin exp_op0_data = ip3_data; exp_op0_valid = 1; end
            else                                          begin exp_op0_data = 10'b0;    exp_op0_valid = 0; end

            // Calculate Expected OP1
            if      (ip0_valid && ip0_data[9:8] == 2'b01) begin exp_op1_data = ip0_data; exp_op1_valid = 1; end
            else if (ip1_valid && ip1_data[9:8] == 2'b01) begin exp_op1_data = ip1_data; exp_op1_valid = 1; end
            else if (ip2_valid && ip2_data[9:8] == 2'b01) begin exp_op1_data = ip2_data; exp_op1_valid = 1; end
            else if (ip3_valid && ip3_data[9:8] == 2'b01) begin exp_op1_data = ip3_data; exp_op1_valid = 1; end
            else                                          begin exp_op1_data = 10'b0;    exp_op1_valid = 0; end

            // Calculate Expected OP2
            if      (ip0_valid && ip0_data[9:8] == 2'b10) begin exp_op2_data = ip0_data; exp_op2_valid = 1; end
            else if (ip1_valid && ip1_data[9:8] == 2'b10) begin exp_op2_data = ip1_data; exp_op2_valid = 1; end
            else if (ip2_valid && ip2_data[9:8] == 2'b10) begin exp_op2_data = ip2_data; exp_op2_valid = 1; end
            else if (ip3_valid && ip3_data[9:8] == 2'b10) begin exp_op2_data = ip3_data; exp_op2_valid = 1; end
            else                                          begin exp_op2_data = 10'b0;    exp_op2_valid = 0; end

            // Calculate Expected OP3
            if      (ip0_valid && ip0_data[9:8] == 2'b11) begin exp_op3_data = ip0_data; exp_op3_valid = 1; end
            else if (ip1_valid && ip1_data[9:8] == 2'b11) begin exp_op3_data = ip1_data; exp_op3_valid = 1; end
            else if (ip2_valid && ip2_data[9:8] == 2'b11) begin exp_op3_data = ip2_data; exp_op3_valid = 1; end
            else if (ip3_valid && ip3_data[9:8] == 2'b11) begin exp_op3_data = ip3_data; exp_op3_valid = 1; end
            else                                          begin exp_op3_data = 10'b0;    exp_op3_valid = 0; end

            test_count = test_count + 1;

            // Scoreboard Comparison
            if (op0_data !== exp_op0_data || op0_valid !== exp_op0_valid ||
                op1_data !== exp_op1_data || op1_valid !== exp_op1_valid ||
                op2_data !== exp_op2_data || op2_valid !== exp_op2_valid ||
                op3_data !== exp_op3_data || op3_valid !== exp_op3_valid) begin
                $display("FAIL: %s", test_name);
                fail_count = fail_count + 1;
            end else begin
                // Uncomment to see every pass, kept quiet for exhaustive run
                // $display("PASS: %s", test_name);
            end
            #5;
        end
    endtask

    initial begin
        clk = 0; rst = 0;
        $display("====================================");
        $display("STARTING COMPLETE ROUTER VERIFICATION");
        $display("====================================");

        // -----------------------------------------------------------
        // PHASE 1: DIRECTED INTERFACE TESTS
        // -----------------------------------------------------------
        ip0_valid=0; ip1_valid=0; ip2_valid=0; ip3_valid=0;
        ip0_data=0; ip1_data=0; ip2_data=0; ip3_data=0;
        evaluate_and_check("Reset/All Invalid");

        ip0_data = {2'b10, 8'hAA}; ip0_valid = 0; // Payload present, but invalid
        evaluate_and_check("Data present but Valid=0");

        // -----------------------------------------------------------
        // PHASE 2: EXHAUSTIVE 256 DESTINATION COMBINATION LOOP
        // -----------------------------------------------------------
        $display("Running Exhaustive 256 Contention & Cross-Routing Tests...");
        ip0_valid = 1; ip1_valid = 1; ip2_valid = 1; ip3_valid = 1;
        
        // Loop through all 256 possible destination bit combinations
        for (i = 0; i < 256; i = i + 1) begin
            // Unique payloads to trace exactly who won
            ip0_data = {i[1:0], 8'hA0}; 
            ip1_data = {i[3:2], 8'hB1};
            ip2_data = {i[5:4], 8'hC2};
            ip3_data = {i[7:6], 8'hD3};
            evaluate_and_check("Exhaustive Matrix Routing");
        end
        ip0_valid = 0; ip1_valid = 0; ip2_valid = 0; ip3_valid = 0;

        // -----------------------------------------------------------
        // PHASE 3: PAYLOAD CORNER CASES (Randomized approximation)
        // -----------------------------------------------------------
        $display("Running Payload Integrity Corner Cases...");
        ip0_valid=1; ip0_data={2'b00, 8'h00}; evaluate_and_check("Payload All Zeros");
        ip0_valid=1; ip0_data={2'b00, 8'hFF}; evaluate_and_check("Payload All Ones");
        ip0_valid=1; ip0_data={2'b00, 8'h55}; evaluate_and_check("Payload Alternating 0101");
        ip0_valid=1; ip0_data={2'b00, 8'hAA}; evaluate_and_check("Payload Alternating 1010");

        // Final Summary
        $display("\n====================================");
        $display("ROUTER VERIFICATION SUMMARY");
        $display("====================================");
        $display("Tests Run : %0d", test_count);
        $display("Failures  : %0d", fail_count);
        if (fail_count == 0) $display("Result    : PASS - ALL TESTS SUCCESSFUL");
        else                 $display("Result    : FAIL - BUGS DETECTED");
        $display("====================================");
        $finish;
    end
endmodule