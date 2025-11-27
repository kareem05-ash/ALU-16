// 16-bit ALU module
// Name: Kareem Ashraf
// Email: kareem.ash05@gmail.com
// GitHub: https://github.com/kareem05-ash/
module alu
(
    input wire [15:0]   A,        // First Operand
    input wire [15:0]   B,        // Second Operand
    input wire [4:0]    F,        // OpCode
    input wire          Cin,      // Carry Input
    output reg [15:0]   Result,   // ALU Result
    output wire [5:0]   Status    // FLAGS Reg {CF, ZF, NF, VF, PF, AF}
);
  // Internal Signals
    reg [4:0] res;
    reg CF;                       // Cary Flag
    wire ZF;                      // Zero Flag
    wire NF;                      // Negative Flag
    reg VF;                       // Overflow Flag
    wire PF;                      // Parity Flag
    reg AF;                       // Auxiliary Flag

  // FLAGS Register Assignment
    assign Status = {CF, ZF, NF, VF, PF, AF};
    assign ZF = (Result == 16'h0000);
    assign NF = Result[15];
    assign PF = ~^Result;

  // Comb. Block for Result, CF_ar, VF, AF
    always@(*) begin 
      // Initial Values for Result, CF, VF, AF
        Result = 16'h0000;
        CF = 1'b0;
        VF = 1'b0;
        AF = 1'b0;
      case(F)
        // Arithmetic Block
          5'b00_001: begin  // INC
            {CF, Result} = A + 1;                                 // CF, Result
            VF = (!A[15] && Result[15]);                          // VF
            AF = A[3:0] == 4'hF;                                  // AF
          end
          5'b00_011: begin  // DEC
            Result = A - 1;                                       // Result
            CF = A == 16'h0000;                                   // CF
            VF = A[15] && !Result[15];                            // VF
            AF = A[3:0] == 4'h0;                                  // AF
          end
          5'b00_100: begin  // ADD
            {CF, Result} = A + B;                                 // CF, Result
            VF = (A[15] == B[15] && A[15] != Result[15]);         // VF
            res = A[3:0] + B[3:0];
            AF = res > 4'hF;                                      // AF
          end
          5'b00_101: begin  // ADD_CARRY
            {CF, Result} = A + B + Cin;                           // CF, Result
            VF = (A[15] == B[15] && A[15] != Result[15]);         // VF
            res = A[3:0] + B[3:0] + Cin;
            AF = res > 4'hF;                                      // AF
          end
          5'b00_110: begin  // SUB
            Result = A - B;                                       // Result
            CF = A < B;                                           // CF
            VF = (A[15] != B[15] && Result[15] != A[15]);         // VF
            AF = A[3:0] < B[3:0];                                 // AF
          end
          5'b00_111: begin  // SUB_BORROW
            Result = A - B - Cin;                                 // Result
            CF = A - Cin < B;                                     // CF
            VF = (A[15] != B[15] && Result[15] != A[15]);         // VF
            res = B[3:0] + Cin;
            AF = A[3:0] < res;                                    // AF
          end
        // Logic Block
          5'b01_000: Result = A & B;                              // AND
          5'b01_001: Result = A | B;                              // OR
          5'b01_010: Result = A ^ B;                              // XOR
          5'b01_011: Result = ~A;                                 // NOT

        // Shift Block
          5'b10_000: {CF, Result} = {A[15], A << 1};              // SHL
          5'b10_001: {CF, Result} = {A[0], A >> 1};               // SHR
          5'b10_010: {CF, Result} = {A[15], A <<< 1};             // SAL
          5'b10_011: {CF, Result} = {A[0], {A[15], A[15:1]}};     // SAR
          5'b10_100: {CF, Result} = {A[15], {A[14:0], A[15]}};    // ROL
          5'b10_101: {CF, Result} = {A[0], {A[0], A[15:1]}};      // ROR
          5'b10_110: {CF, Result} = {A[15], {A[14:0], Cin}};      // RCL
          5'b10_111: {CF, Result} = {A[0], {Cin, A[15:1]}};       // RCR
        // Default
          default: begin 
            Result = 16'h0000;
            CF = 1'b0;
            VF = 1'b0;
          end
      endcase
    end
endmodule