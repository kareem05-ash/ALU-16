// 16-bit ALU module
// Name: Kareem Ashraf
// Email: kareem.ash05@gmail.com
// GitHub: https://github.com/kareem05-ash/

module alu
(
  // Inputs
    input wire [15:0]   A,        // First Operand
    input wire [15:0]   B,        // Second Operand
    input wire [4:0]    F,        // OpCode
    input wire          Cin,      // Carry Input
  // Outputs
    output reg [15:0]  Result,    // ALU Result
    output wire [5:0]   Status    // FLAGS Reg {CF, ZF, NF, VF, PF, AF}
);
  // Internal Signals
    wire CF;                      // Cary Flag
    wire ZF;                      // Zero Flag
    wire NF;                      // Negative Flag
    reg VF;                       // Overflow Flag
    wire PF;                      // Parity Flag
    wire AF;                      // Auxiliary Flag
    wire CF_sh;                   // Shift Carry Flag
    reg CF_ar;                    // Artithmetic Carry Flag

  // FLAGS Register Assignment
    assign Status = {CF, ZF, NF, VF, PF, AF};
    assign CF_sh = F[0]? A[0] : A[15];
    assign CF = F[4]? CF_sh : CF_ar;
    assign ZF = (Result == 16'h0000);
    assign NF = Result[15];
    assign PF = ~^Result;
    assign AF = F[1]? (A[3:0] < B[3:0]) : (A[3:0] + B[3:0] > 4'hF);

  // Comb. Block for Results, CF_ar, VF
    always@(*) begin 
      case(F)
        // Arithmetic Block
          5'b00_001: begin  // INC
            {CF_ar, Result} = A + 1;          // CF_ar, Result
            VF = (!A[15] && Result[15]);      // VF
          end
          5'b00_011: begin  // DEC
            {CF_ar, Result} = A - 1;          // CF_ar, Result
            VF = A[15] && !Result[15];        // VF
          end
          5'b00_100: begin  // ADD
            {CF_ar, Result} = A + B;          // CF_ar, Result
            VF = (A[15] == B[15] && A[15] != Result[15]); // VF
          end
          5'b00_101: begin  // ADD_CARRY
            {CF_ar, Result} = A + B + Cin;    // CF_ar, Result
            VF = (A[15] == B[15] && A[15] != Result[15]); // VF
          end
          5'b00_110: begin  // SUB
            {CF_ar, Result} = A - B;         // CF_ar, Result
            VF = (A[15] != B[15] && Result[15] != A[15]);
          end
          5'b00_111: begin  // SUB_BORROW
            {CF_ar, Result} = A - B - Cin;    // CF_ar, Result
            VF = (A[15] != B[15] && Result[15] != A[15]);
          end

        // Logic Block
          5'b01_000: Result = A & B;          // AND
          5'b01_001: Result = A | B;          // OR
          5'b01_010: Result = A ^ B;          // XOR
          5'b01_011: Result = ~A;             // NOT

        // Shift Block
          5'b10_000: Result = A << 1;               // SHL
          5'b10_001: Result = A >> 1;               // SHR
          5'b10_010: Result = A <<< 1;              // SAL
          5'b10_011: Result = A >>> 1;              // SAR
          5'b10_100: Result = {A[14:0], A[15]};     // ROL
          5'b10_101: Result = {A[0], A[15:1]};      // ROR
          5'b10_110: Result = {A[14:0], Cin};     // RCL
          5'b10_111: Result = {Cin, A[15:1]};     // RCR

        // Default
          default: begin 
            Result = 16'h0000;
            CF_ar = 1'b0;
            VF = 1'b0;
          end
      endcase
    end
endmodule