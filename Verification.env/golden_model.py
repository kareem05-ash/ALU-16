# -------------------------------------------
# This file is a golden model for the ALU
# -------------------------------------------

# Parity Flag Caluculator
def PF_calc(Result):
  set_bits = bin(Result & 0xFFFF).count('1')
  return 1 if set_bits%2 == 0 else 0
  
# Zero Flag Calucluator
def ZF_calc(Result):
  return 1 if Result == 0 else 0

# Negative Flag Caluculator
def NF_calc(Result):
  return (Result & 0xffff) >> 15

# Golden Model
def alu_golden_model(A, B, Cin, F) -> tuple:
  '''This golden model returns the desired values of the Result, Status as: 
      {Result, CF, ZF, NF, VF, PF, AF}'''
  WIDTH = 16
  MASK = 0xFFFF
  Result, CF, ZF, NF, VF, PF, AF = 0, 0, 0, 0, 0, 0, 0
  opcode = F & 0b11_111
  A, B, Cin, F = A & MASK, B & MASK, Cin & 1, F & 0b11_111

  # Case Statement
  
  # ----------------
  # Arithmetic Block
  # ----------------
  # INC Operation
  if opcode == 0b00_001:      
    Result = (A + 1) & MASK
    CF = 1 if A == MASK else 0
    AF = 1 if (A & 0xF) == 0xF else 0
    A_msb, Result_msb = (A >> WIDTH - 1) & 1, (Result >> WIDTH - 1) & 1
    VF = 1 if A_msb == 0 and Result_msb == 1 else 0

  # DEC Operation
  elif opcode == 0b00_011:    
    Result = (A - 1) & MASK
    CF = 1 if A == 0x0000 else 0
    AF = 1 if (A & 0xF) == 0x0 else 0
    A_msb, Result_msb = (A >> WIDTH - 1) & 1, (Result >> WIDTH - 1) & 1
    VF = 1 if A_msb == 1 and Result_msb == 0 else 0

  # ADD Operation
  elif opcode == 0b00_100:    
    Result = (A + B) & MASK
    CF = 1 if (A + B) > MASK else 0
    AF = 1 if ((A & 0xF) + (B & 0xF)) > 0xF else 0
    A_msb, B_msb, Result_msb = (A >> WIDTH - 1) & 1, (B >> WIDTH - 1) & 1, (Result >> WIDTH - 1) & 1
    VF = 1 if A_msb == B_msb and Result_msb != A_msb else 0

  # ADC Operation
  elif opcode == 0b00_101:    
    Result = (A + B + Cin) & MASK
    CF = 1 if (A + B + Cin) > MASK else 0
    AF = 1 if ((A & 0xF) + (B & 0xF) + Cin) > 0xF else 0
    A_msb, B_msb, Result_msb = (A >> WIDTH - 1) & 1, (B >> WIDTH - 1) & 1, (Result >> WIDTH - 1) & 1
    VF = 1 if A_msb == B_msb and Result_msb != A_msb else 0

  # SUB Operation
  elif opcode == 0b00_110:    
    Result = (A - B) & MASK
    CF = 1 if A < B else 0
    AF = 1 if (A & 0xF) < (B & 0xF) else 0
    A_msb, B_msb, Result_msb = (A >> WIDTH - 1) & 1, (B >> WIDTH - 1) & 1, (Result >> WIDTH - 1) & 1
    VF = 1 if A_msb != B_msb and Result_msb != A_msb else 0

  # SBB Operation
  elif opcode == 0b00_111:    
    Result = (A - B - Cin) & MASK
    CF = 1 if (A - Cin < B) else 0
    AF = 1 if (A & 0xF) < ((B & 0xF) + Cin) else 0
    A_msb, B_msb, Result_msb = (A >> WIDTH - 1) & 1, (B >> WIDTH - 1) & 1, (Result >> WIDTH - 1) & 1
    VF = 1 if A_msb != B_msb and Result_msb != A_msb else 0

  # ---------------
  # Logic Block
  # ---------------
  # AND Operation
  elif opcode == 0b01_000:    
    Result = A & B & MASK
    CF, AF, VF = 0, 0, 0

  # OR Operation
  elif opcode == 0b01_001:    
    Result = A | B | 0x0000
    CF, AF, VF = 0, 0, 0

  # XOR Operation
  elif opcode == 0b01_010:    
    Result = A ^ B
    CF, AF, VF = 0, 0, 0

  # NOT Operation
  elif opcode == 0b01_011:    
    Result = A ^ MASK
    CF, AF, VF = 0, 0, 0
  
  # ---------------
  # Shift Block
  # ---------------
  # SHL Operation
  elif opcode == 0b10_000:    
    Result = (A << 1) & MASK
    CF = (A >> WIDTH - 1) & 1
    AF, VF = 0, 0

  # SHR Operation
  elif opcode == 0b10_001:    
    Result = (A >> 1) & MASK
    CF = A & 1
    AF, VF = 0, 0

  # SAL Operation
  elif opcode == 0b10_010:    
    Result = (A << 1) & MASK
    CF = (A >> WIDTH - 1) & 1
    AF, VF = 0, 0

  # SAR Operation
  elif opcode == 0b10_011:    
    sign_bit = (A >> WIDTH - 1) & 1
    Result = (A >> 1) | (sign_bit << WIDTH - 1) & MASK
    CF = A & 1
    AF, VF = 0, 0

  # ROL Operation
  elif opcode == 0b10_100:    
    CF = (A >> WIDTH - 1) & 1
    Result = ((A << 1) & MASK) | (CF & MASK)
    AF, VF = 0, 0

  # ROR Operation
  elif opcode == 0b10_101:    
    CF = A & 1
    Result = ((A >> 1) & MASK) | ((CF << WIDTH - 1) & MASK)
    AF, VF = 0, 0

  # RCL Operation
  elif opcode == 0b10_110:    
    Result = ((A << 1) & MASK) | (Cin & MASK)
    CF = (A >> WIDTH - 1) & 1
    AF, VF = 0, 0

  # RCR Operation
  elif opcode == 0b10_111:    
    Result = ((A >> 1) & MASK) | ((Cin << WIDTH - 1) & MASK)
    CF = A & 1
    AF, VF = 0, 0

  # Default Case 
  else:
    Result = 0 & MASK
    CF, AF, VF = 0, 0, 0

  ZF = ZF_calc(Result)
  NF = NF_calc(Result)
  PF = PF_calc(Result)
  return Result, CF, ZF, NF, VF, PF, AF