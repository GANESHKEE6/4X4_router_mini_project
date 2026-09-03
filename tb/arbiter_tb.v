`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 12:58:55 PM
// Design Name: 
// Module Name: arbiter_tb
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

module arbiter_tb;

    // Inputs
    reg req_ip0, req_ip1, req_ip2, req_ip3;
    
    // Outputs
    wire grant_ip0, grant_ip1, grant_ip2, grant_ip3;

    // Test variables
    integer i;
    integer test_count = 0;
    integer fail_count = 0;
    
    // Aggregated buses for easy comparison. MSB is IP0, LSB is IP3.
    wire [3:0] req_bus   = {req_ip0, req_ip1, req_ip2, req_ip3};
    wire [3:0] grant_bus = {grant_ip0, grant_ip1, grant_ip2, grant_ip3};
    reg  [3:0] expected_grant;

    // DUT Instantiation
    arbiter dut (
        .req_ip0(req_ip0), .req_ip1(req_ip1), .req_ip2(req_ip2), .req_ip3(req_ip3),
        .grant_ip0(grant_ip0), .grant_ip1(grant_ip1), .grant_ip2(grant_ip2), .grant_ip3(grant_ip3)
    );

    // Task to calculate expected grant based on fixed priority
    task calc_expected;
        input  [3:0] req;
        output [3:0] exp;
        begin
            if      (req[3]) exp = 4'b1000; // IP0
            else if (req[2]) exp = 4'b0100; // IP1
            else if (req[1]) exp = 4'b0010; // IP2
            else if (req[0]) exp = 4'b0001; // IP3
            else             exp = 4'b0000; // None
        end
    endtask

    // Task to verify architectural properties
    task check_properties;
        begin
            // Property 1: No false grants (grant must imply request)
            if ((grant_bus & req_bus) !== grant_bus) begin
                $display("PROPERTY FAIL: Grant asserted without request! Req: %b, Grant: %b", req_bus, grant_bus);
                fail_count = fail_count + 1;
            end
            
            // Property 2: At most one grant (One-hot or zero)
            if (grant_bus !== 4'b0000 && 
                grant_bus !== 4'b0001 && 
                grant_bus !== 4'b0010 && 
                grant_bus !== 4'b0100 && 
                grant_bus !== 4'b1000) begin
                $display("PROPERTY FAIL: Multiple grants asserted! Grant: %b", grant_bus);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $display("Starting Arbiter Testbench...");
        
        // Loop through all 16 possible request combinations
        for (i = 0; i < 16; i = i + 1) begin
            {req_ip0, req_ip1, req_ip2, req_ip3} = i[3:0];
            #5; // Wait for combinational logic
            
            calc_expected(req_bus, expected_grant);
            check_properties();
            
            test_count = test_count + 1;
            
            if (grant_bus !== expected_grant) begin
                $display("FAIL: req=%b | expected=%b | actual=%b", req_bus, expected_grant, grant_bus);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: req=%b grant=%b", req_bus, grant_bus);
            end
            #5;
        end

        $display("\n=================================");
        $display("Total Tests : %0d", test_count);
        $display("Failures    : %0d", fail_count);
        if (fail_count == 0)
            $display("Result      : TEST PASSED");
        else
            $display("Result      : TEST FAILED");
        $display("=================================");
        $finish;
    end

endmodule