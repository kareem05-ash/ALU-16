`timescale 1ns/1ps
module tb_alu;
  // DUT Inputs
    reg [15:0]   A;           // First Operand
    reg [15:0]   B;           // Second Operand
    reg [4:0]    F;           // OpCode
    reg          Cin;         // Carry Input
  // DUT Outputs
    wire [15:0]  Result;      // ALU Result
    wire [5:0]   Status;      // FLAGS Reg {CF, ZF, NF, VF, PF, AF}
  // TB Internal Signals
    reg [15:0] a, b;
    reg [4:0] f;
    reg cin;
  // DUT Instntiation
    alu DUT(
      .A(A),
      .B(B), 
      .F(F), 
      .Cin(Cin), 
      .Result(Result), 
      .Status(Status)
    );
  // TASKs
    // Assign Data Task
      task assign_data(input[15:0] a, b, input[4:0] f, input cin); begin 
          A = a;
          B = b;
          F = f;
          Cin = cin;
          #10;
        end
      endtask
    // Log Task
      task log;
        input [15:0] a, b;
        input [4:0] f;
        input cin;
        begin 
          assign_data(a, b, f, cin);
          $display("%h|%h|%b|%b|%b|%h", a, b, cin, f, Status, Result);
        end
      endtask
  // Stimulus
    initial begin 
        repeat(1000) begin 
          a = $random;  b = $random;  cin = $random;  f = $random;
          log(a, b, f, cin);
        end
        #10;
        $stop;
    end
endmodule