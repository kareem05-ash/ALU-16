# This file compares the calculated values vs expected ones

from golden_model import alu_golden_model as gm

# read logs
with open(".\\logs.log", 'r') as f:
  lines = f.readlines()

# storing logs in lists
Alst, Blst, Cinlst, Flst, Statuslst, Resultlst = [], [], [], [], [], []

for l in lines:
  lst = l.split('|')
  Alst.append(int(lst[0], 16))
  Blst.append(int(lst[1], 16))
  Cinlst.append(int(lst[2], 2))
  Flst.append(int(lst[3], 2))
  Statuslst.append(int(lst[4], 2))
  Resultlst.append(int(lst[5], 16))

All, PASSed = 0, 0

# Compare Calucalted vs. Expected
def comp(A, B, Cin, F, Status, exp_Status, Result, exp_Result):
  global All, PASSed
  All += 1
  if Status == exp_Status and Result == exp_Result:
    PASSed += 1
    # print(f"[PASS] | A = {hex(A)}, B = {hex(B)}, Cin = {Cin}, OpCode = {hex(F)} | Status = {hex(Status)}, Expected = {hex(exp_Status)} | Result = {hex(Result)}, Expected = {hex(exp_Result)}")
  else:
    print(f"[FAIL] | A = {hex(A)}, B = {hex(B)}, Cin = {Cin}, OpCode = {bin(F)} | Status = {bin(Status)}, Expected = {bin(exp_Status)} | Result = {hex(Result)}, Expected = {hex(exp_Result)}")
    
# Calculate

for a, b, cin, f, status, res in zip(Alst, Blst, Cinlst, Flst, Statuslst, Resultlst):
  exp_res, CF, ZF, NF, VF, PF, AF = gm(a, b, cin, f)
  exp_status = int(str(CF)+ str(ZF)+ str(NF)+ str(VF)+ str(PF) + str(AF), 2)
  # compare
  comp(a, b, cin, f, status, exp_status, res, exp_res)

print(f"\nAll Test Cases = {All}\nPASSed Test Cases = {PASSed}\nFAILed = {All - PASSed}")