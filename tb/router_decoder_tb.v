`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 12:08:48 PM
// Design Name: 
// Module Name: router_decoder_tb
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

module router_decoder_tb;

    // Inputs
    reg [9:0] packet;
    reg       valid;

    // Outputs
    wire req_op0;
    wire req_op1;
    wire req_op2;
    wire req_op3;

    // Test variables
    integer test_count = 0;
    integer fail_count = 0;
    reg [3:0] expected_req;
    wire [3:0] actual_req;

    assign actual_req = {req_op3, req_op2, req_op1, req_op0};

    // Instantiate the DUT
    router_decoder dut (
        .packet (packet),
        .valid  (valid),
        .req_op0(req_op0),
        .req_op1(req_op1),
        .req_op2(req_op2),
        .req_op3(req_op3)
    );

    // Verification Task
    task check_output;
        input [3:0] exp;
        input [80*8:1] test_name;
        begin
            #5; // Wait for combinational logic to settle
            test_count = test_count + 1;
            if (actual_req !== exp) begin
                $display("FAIL: %s | Expected: %b, Got: %b", test_name, exp, actual_req);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: %s", test_name);
            end
            #5;
        end
    endtask

    initial begin
        $display("Starting Destination Decoder Testbench...");

        // TEST A: valid = 0
        valid = 0; 
        packet = 10'b00_00000000;
        check_output(4'b0000, "Invalid packet (zeros)");

        valid = 0; 
        packet = 10'b11_11111111;
        check_output(4'b0000, "Invalid packet (ones)");

        // TESTS B-E: valid = 1, fixed payload 10101010
        valid = 1; 
        packet = 10'b00_10101010;
        check_output(4'b0001, "Destination 00 routed to OP0");

        valid = 1; 
        packet = 10'b01_10101010;
        check_output(4'b0010, "Destination 01 routed to OP1");

        valid = 1; 
        packet = 10'b10_10101010;
        check_output(4'b0100, "Destination 10 routed to OP2");

        valid = 1; 
        packet = 10'b11_10101010;
        check_output(4'b1000, "Destination 11 routed to OP3");

        // TEST F: Payload variation tests (proving payload independence)
        valid = 1;
        
        packet = 10'b00_00000000;
        check_output(4'b0001, "Dest 00 with payload 00000000");
        
        packet = 10'b00_11111111;
        check_output(4'b0001, "Dest 00 with payload 11111111");

        packet = 10'b01_01010101;
        check_output(4'b0010, "Dest 01 with payload 01010101");

        packet = 10'b10_10101010;
        check_output(4'b0100, "Dest 10 with payload 10101010");

        packet = 10'b11_11001100;
        check_output(4'b1000, "Dest 11 with payload 11001100");

        // Return to invalid
        valid = 0;
        packet = 10'b11_11001100;
        check_output(4'b0000, "Return to invalid state");

        // Final Result
        $display("----------------------------------------");
        $display("Total Tests: %0d | Failures: %0d", test_count, fail_count);
        if (fail_count == 0) begin
            $display("TEST PASSED");
        end else begin
            $display("TEST FAILED");
        end
        $display("----------------------------------------");
        $finish;
    end

endmodule