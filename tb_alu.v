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
    integer all_tsts = 0;
    integer PASSed_tsts = 0;
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
        input [15:0] exp_res;
        begin 
          assign_data(a, b, f, cin);
          all_tsts = all_tsts + 1;
          if(Result == exp_res) begin 
            PASSed_tsts = PASSed_tsts + 1;
            $display("[PASS] | A = %h, B = %h, Cin = %b, OpCode = %b | Status = %b | Result = %h, expected = %h", a, b, cin, f, Status, Result, exp_res);
          end else begin 
            $display("[FAIL] | A = %h, B = %h, Cin = %b, OpCode = %b | Status = %b | Result = %h, expected = %h", a, b, cin, f, Status, Result, exp_res);
          end
        end
      endtask
  
  // Stimulus
    initial begin 
      // 1st Scenario (Reset Behaviour)
        $display("\n========================================= 1st Scenario: (Reset Behaviour) =========================================");
        assign_data(0, 0, 0, 0);
        if(Result == 16'h0000 && Status == 6'b010_010) begin
          all_tsts = all_tsts + 1;
          PASSed_tsts = PASSed_tsts + 1;
          $display("[PASS] | Results = %h, expected = %h | Status = %b, expected = %b", Result, 16'h0000, Status, 6'b010_010);
        end else                                            
          $display("[FAIL] | Results = %h, expected = %h | Status = %b, expected = %b", Result, 16'h0000, Status, 6'b010_010);

      // 2nd Scenario (INC Operation)
        $display("\n========================================= 2nd Scenario (INC Operation) =========================================");
        a = 16'h0000;  b = 16'h0000;  f = 5'b00_001;  cin = $random;
        log(a, b, f, cin, (a + 1));
        a = 16'hFFFF;  b = 16'hFFFF;  f = 5'b00_001;  cin = $random;
        log(a, b, f, cin, (a + 1));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b00_001;  cin = $random;
          log(a, b, f, cin, (a + 1));
        end
        
      // 3rd Scenario (DEC Operation)
        $display("\n========================================= 3rd Scenario (DEC Operation) =========================================");
        a = 16'h0000;  b = 16'h0000;  f = 5'b00_011;  cin = $random;
        log(a, b, f, cin, (a - 1));
        a = 16'hFFFF;  b = 16'hFFFF;  f = 5'b00_011;  cin = $random;
        log(a, b, f, cin, (a - 1));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b00_011;  cin = $random;
          log(a, b, f, cin, (a - 1));
        end

      // 4th Scenario (ADD Operation)
        $display("\n========================================= 4th Scenario (ADD Operation) =========================================");
        a = 16'h0000;  b = 16'h0000;  f = 5'b00_100;  cin = $random;
        log(a, b, f, cin, (a + b));
        a = 16'hFFFF;  b = 16'hFFFF;  f = 5'b00_100;  cin = $random;
        log(a, b, f, cin, (a + b));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b00_100;  cin = $random;
          log(a, b, f, cin, (a + b));
        end

      // 5th Scenario (ADC Operation)
        $display("\n========================================= 5th Scenario (ADC Operation) =========================================");
        a = 16'h0000;  b = 16'h0000;  f = 5'b00_101;  cin = $random;
        log(a, b, f, cin, (a + b + cin));
        a = 16'hFFFF;  b = 16'hFFFF;  f = 5'b00_101;  cin = $random;
        log(a, b, f, cin, (a + b + cin));
        repeat(5) begin
          a = $random;  b = $random;  f = 5'b00_101;  cin = $random;
          log(a, b, f, cin, (a + b + cin));
        end

      // 6th Scenario (SUB Operation)
        $display("\n========================================= 6th Scenario (SUB Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b00_110; cin = $random;
        log(a, b, f, cin, (a - b));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b00_110; cin = $random;
        log(a, b, f, cin, (a - b));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b00_110;  cin = $random;
          log(a, b, f, cin, (a - b));
        end

      // 7th Scenario (SBB Operation)
        $display("\n========================================= 7th Scenario (SBB Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b00_111; cin = $random;
        log(a, b, f, cin, (a - b - cin));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b00_111; cin = $random;
        log(a, b, f, cin, (a - b - cin));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b00_111;  cin = $random;
          log(a, b, f, cin, (a - b - cin));
        end

      // 8th Scenario (AND Operation)
        $display("\n========================================= 8th Scenario (AND Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b01_000; cin = $random;
        log(a, b, f, cin, (a & b));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b01_000; cin = $random;
        log(a, b, f, cin, (a & b));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b01_000;  cin = $random;
          log(a, b, f, cin, (a & b));
        end

      // 9th Scenario (OR Operation)
        $display("\n========================================= 9th Scenario (OR Operation) ==========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b01_001; cin = $random;
        log(a, b, f, cin, (a | b));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b01_001; cin = $random;
        log(a, b, f, cin, (a | b));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b01_001;  cin = $random;
          log(a, b, f, cin, (a | b));
        end

      // 10th Scenario (XOR Operation)
        $display("\n========================================= 10th Scenario (XOR Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b01_010; cin = $random;
        log(a, b, f, cin, (a ^ b));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b01_010; cin = $random;
        log(a, b, f, cin, (a ^ b));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b01_010;  cin = $random;
          log(a, b, f, cin, (a ^ b));
        end

      // 11th Scenario (NOT Operation)
        $display("\n========================================= 11th Scenario (NOT Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b01_011; cin = $random;
        log(a, b, f, cin, (~a));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b01_011; cin = $random;
        log(a, b, f, cin, (~a));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b01_011;  cin = $random;
          log(a, b, f, cin, (~a));
        end

      // 12th Scenario (SHL Operation)
        $display("\n========================================= 12th Scenario (SHL Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_000; cin = $random;
        log(a, b, f, cin, ({a[14:0], 1'b0}));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_000; cin = $random;
        log(a, b, f, cin, ({a[14:0], 1'b0}));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_000;  cin = $random;
          log(a, b, f, cin, ({a[14:0], 1'b0}));
        end

      // 13th Scenario (SHR Operation)
        $display("\n========================================= 13th Scenario (SHR Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_001; cin = $random;
        log(a, b, f, cin, ({1'b0, a[15:1]}));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_001; cin = $random;
        log(a, b, f, cin, ({1'b0, a[15:1]}));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_001;  cin = $random;
          log(a, b, f, cin, ({1'b0, a[15:1]}));
        end

      // 14th Scenario (SAL Operation)
        $display("\n========================================= 14th Scenario (SAL Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_010; cin = $random;
        log(a, b, f, cin, ({a[14:0], 1'b0}));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_010; cin = $random;
        log(a, b, f, cin, ({a[14:0], 1'b0}));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_010;  cin = $random;
          log(a, b, f, cin, ({a[14:0], 1'b0}));
        end

      // 15th Scenario (SAR Operation)
        $display("\n========================================= 15th Scenario (SAR Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_011; cin = $random;
        log(a, b, f, cin, {a[15], a[15:1]});
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_011; cin = $random;
        log(a, b, f, cin, {a[15], a[15:1]});
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_011;  cin = $random;
          log(a, b, f, cin, {a[15], a[15:1]});
        end

      // 16th Scenario (ROL Operation)
        $display("\n========================================= 16th Scenario (ROL Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_100; cin = $random;
        log(a, b, f, cin, ({a[14:0], a[15]}));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_100; cin = $random;
        log(a, b, f, cin, ({a[14:0], a[15]}));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_100;  cin = $random;
          log(a, b, f, cin, ({a[14:0], a[15]}));
        end

      // 17th Scenario (ROR Operation)
        $display("\n========================================= 17th Scenario (ROR Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_101; cin = $random;
        log(a, b, f, cin, ({a[0], a[15:1]}));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_101; cin = $random;
        log(a, b, f, cin, ({a[0], a[15:1]}));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_101;  cin = $random;
          log(a, b, f, cin, ({a[0], a[15:1]}));
        end

      // 18th Scenario (RCL Operation)
        $display("\n========================================= 18th Scenario (RCL Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_110; cin = $random;
        log(a, b, f, cin, ({a[14:0], cin}));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_110; cin = $random;
        log(a, b, f, cin, ({a[14:0], cin}));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_110;  cin = $random;
          log(a, b, f, cin, ({a[14:0], cin}));
        end

      // 19th Scenario (RCR Operation)
        $display("\n========================================= 19th Scenario (RCR Operation) =========================================");
        a = 16'h0000;   b = 16'h0000;   f = 5'b10_111; cin = $random;
        log(a, b, f, cin, ({cin, a[15:1]}));
        a = 16'hFFFF;   b = 16'hFFFF;   f = 5'b10_111; cin = $random;
        log(a, b, f, cin, ({cin, a[15:1]}));
        repeat(5) begin 
          a = $random;  b = $random;  f = 5'b10_111;  cin = $random;
          log(a, b, f, cin, ({cin, a[15:1]}));
        end

      // Stop Simulation
        #10;
        $display("\n=========================\n          Report\n=========================");
        $display("All Tests : %d", all_tsts);
        $display("PASSed    : %d", PASSed_tsts);
        $display("FAILed    : %d", all_tsts - PASSed_tsts);
        $stop;
    end
endmodule