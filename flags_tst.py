# -----------------------------------------------------------------
# This file analyzes the logs from QuestaSim to check on FLAG Reg
# -----------------------------------------------------------------

# =================================================================
# FLAG Register = {CF, ZF, NF, VF, PF, AF}
# =================================================================

# -------------------------------
# FLAGS Calculation
# -------------------------------

# (CF, VF) Test
def CF_VF_calc(a:str, b:str, cin:str, opcode:str, result:str) -> tuple:
  '''a(hex), b(hex), opcode(bin), result(hex)'''
  '''returns (CF:bool, VF:bool)'''
  # CF_sh -> Carry from Shift block
  if int(opcode[-1]) == 1:    # Subtraction Operation
    if a[-1] == '1':
      CF_sh = True  
    else:
      CF_sh = False
  else:                       # Addition Operation
    if a[0] == '1':
      CF_sh = True
    else:
      CF_sh = False
  # Convert a, b, cin, result to its decimel equivalent
  a, b, cin, result = int(a, 16), int(b, 16), int(cin, 2), int(result, 16)
  # CF_ar -> Carry from Arithmetic block
  if opcode[2:] == '001':   # INC
    CF_ar = a + 1 > int('ffff', 16)
    Vflag = hex(a)[0] == 0 and hex(result)[0] == 1
  if opcode[2:] == '011':   # DEC
    CF_ar = a < 1
    Vflag = hex(a)[0] == 1 and hex(result)[0] == 0
  if opcode[2:] == '100':   # ADD
    CF_ar = a + b > int('ffff', 16)
    Vflag = hex(a)[0] == hex(b)[0] and hex(a)[0] != hex(result)[0]
  if opcode[2:] == '101':   # ADC
    CF_ar = a + b + cin > int('ffff', 16)
    Vflag = hex(a)[0] == hex(b)[0] and hex(a)[0] != hex(result)[0]
  if opcode[2:] == '110':   # SUB
    CF_ar = a < b
    Vflag = hex(a)[0] != hex(b)[0] and hex(a)[0] != hex(result)[0]
  if opcode[2:] == '111':   # SBB
    CF_ar = a < b
    Vflag = hex(a)[0] != hex(b)[0] and hex(a)[0] != hex(result)[0]
  else:
    CF_ar = False
    Vflag = False
  # CF (CF_sh, CF_ar combination)
  if opcode[0] == '1':
    Cflag = CF_sh  
  else:
    Cflag = CF_ar
  if Cflag:
    Cflag = '1'
  else:
    Cflag = '0'
  if Vflag:
    Vflag = '1'
  else:
    Vflag = '0'
  return (Cflag, Vflag)

# ZF Test
def ZF_calc(res: str) -> str:
  if int(res, 16) == 0:
    return '1'
  else:
    return '0'

# NF Test
def NF_calc(res: str) -> str:
  return str(bin(int(res, 16)))[0]

# PF Test
def PF_calc(res: str) -> str:
  res = str(bin(int(res, 16)))   # result in its binary equivalent
  all_ones = 0
  for num in res:
    if num == '1':
      all_ones += 1
  if all_ones % 2 == 0:
    return '1'
  else:
    return '0'

# AF Test
def AF_calc(k1:str, a:str, b:str) -> str:
  '''a(hex), b(hex)'''
  a, b = int(a[-1], 16), int(b[-1], 16)
  if int(k1):   # Subtraction Operation
    if a < b:
      return '1'
    else:
      return '0'
  else:         # Addition Operation
    if a + b > int('f', 16):
      return '1'
    else:
      return '0'
  
# -------------------------------------
# Reading Transcript Logs
# -------------------------------------

def read_logs():
  global INC, DEC, ADD, ADC, SUB, SBB, AND, OR, XOR, NOT, SHL, SHR, SAL, SAR, ROL, ROR, RCL, RCR
  with open('.\\Transcript.log', 'r') as file:
    for _ in range(3):
      file.readline()
    # INC
    INC = []
    file.readline()
    for _ in range(7):
      INC.append(file.readline())
    # DEC
    DEC = []
    file.readline()
    file.readline()
    for _ in range(7):
      DEC.append(file.readline())
    # ADD
    ADD = []
    file.readline()
    file.readline()
    for _ in range(7):
      ADD.append(file.readline())
    # ADC
    ADC = []
    file.readline()
    file.readline()
    for _ in range(7):
      ADC.append(file.readline())
    # SUB
    SUB = []
    file.readline()
    file.readline()
    for _ in range(7):
      SUB.append(file.readline())
    # SBB
    SBB = []
    file.readline()
    file.readline()
    for _ in range(7):
      SBB.append(file.readline())
    # AND
    AND = []
    file.readline()
    file.readline()
    for _ in range(7):
      AND.append(file.readline())
    # OR
    OR = []
    file.readline()
    file.readline()
    for _ in range(7):
      OR.append(file.readline())
    # XOR
    XOR = []
    file.readline()
    file.readline()
    for _ in range(7):
      XOR.append(file.readline())
    # NOT
    NOT = []
    file.readline()
    file.readline()
    for _ in range(7):
      NOT.append(file.readline())
    # SHL
    SHL = []
    file.readline()
    file.readline()
    for _ in range(7):
      SHL.append(file.readline())
    # SHR
    SHR = []
    file.readline()
    file.readline()
    for _ in range(7):
      SHR.append(file.readline())
    # SAL
    SAL = []
    file.readline()
    file.readline()
    for _ in range(7):
      SAL.append(file.readline())
    # SAR
    SAR = []
    file.readline()
    file.readline()
    for _ in range(7):
      SAR.append(file.readline())
    # ROL
    ROL = []
    file.readline()
    file.readline()
    for _ in range(7):
      ROL.append(file.readline())
    # ROR
    ROR = []
    file.readline()
    file.readline()
    for _ in range(7):
      ROR.append(file.readline())
    # RCL
    RCL = []
    file.readline()
    file.readline()
    for _ in range(7):
      RCL.append(file.readline())
    # RCR
    RCR = []
    file.readline()
    file.readline()
    for _ in range(7):
      RCR.append(file.readline())

def line(l:str):
  '''This function yields A(hex), B(hex), Cin(bin), OpCode(bin), Status(hex), Result(hex)'''
  main = l.split('|')
  # A, B, Cin, OpCode
  inputs = main[1].strip().split(',')
  A = inputs[0].split('=')[1].strip()
  B = inputs[1].split('=')[1].strip()
  Cin = inputs[2].split('=')[1].strip()
  OpCode = inputs[3].split('=')[1].strip()
  # Status
  Status = main[2].strip().split('=')[1].strip()
  # Result
  Result = main[3].strip().split('=')[1].strip().split(',')[0].strip()
  # Returning all values
  return A, B, Cin, OpCode, Status, Result

PASSed, FAILed = 0, 0

read_logs()
lst = [INC, DEC, ADD, ADC, SUB, SBB, AND, OR, XOR, NOT, SHL, SHR, SAL, SAR, ROL, ROR, RCL, RCR]
for op in lst:
  for l in op:
    A, B, Cin, OpCode, Status, Result = line(l)
    CF, VF = CF_VF_calc(A, B, Cin, OpCode, Result)
    ZF = ZF_calc(Result)
    PF = PF_calc(Result)
    AF = AF_calc(OpCode[3], A, B)
    NF = NF_calc(Result)
    if Status == CF + ZF + NF + VF + PF + AF:
      PASSed += 1
      # print(f"[PASS] | Status = {Status}, Expected = {CF + ZF + NF + VF + PF + AF}")
    else:
      FAILed += 1
      print(f"[FAIL] | Status = {Status}, Expected = {CF + ZF + NF + VF + PF + AF}")

print(f"PASSed: {PASSed}\nFAILed: {FAILed}")