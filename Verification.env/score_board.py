# This file compares the calculated values vs expected ones

from golden_model import alu_golden_model as gm

# clean logs
ls = []
with open('.\\logs.log', 'r+') as f:
  lines = f.readlines()
  # Uncomment all logs
  for line in lines:
    line = line[2:] if line.startswith('# ') else line
    if '|' in line:
      if len(line.split('|')) == 6:
        ls.append(line)
        
with open('.\\logs.log', 'w') as f:
  f.writelines(ls)

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
    print(f"[PASS] | A = {'0x' + str(hex(A))[2:].zfill(4).upper()}, B = {'0x' + str(hex(B))[2:].zfill(4).upper()}", end=', ')
    print(f"Cin = {Cin}, OpCode = {'0b\'' + str(bin(F))[2:].zfill(5)}", end=', ')
    print(f"Status = {'0b\'' + str(bin(status))[2:].zfill(6)}, Expected = {'0b\'' + str(bin(exp_Status))[2:].zfill(6)}", end=' | ')
    print(f"Result = {'0x' + str(hex(Result))[2:].zfill(4).upper()}, Expected = {'0x' + str(hex(exp_Result))[2:].zfill(4).upper()}")
  else:
    print(f"[FAIL] | A = {'0x' + str(hex(A))[2:].zfill(4).upper()}, B = {'0x' + str(hex(B))[2:].zfill(4).upper()}", end=', ')
    print(f"Cin = {Cin}, OpCode = {'0b\'' + str(bin(F))[2:].zfill(5)}", end=', ')
    print(f"Status = {'0b\'' + str(bin(status))[2:].zfill(6)}, Expected = {'0b\'' + str(bin(exp_Status))[2:].zfill(6)}", end=' | ')
    print(f"Result = {'0x' + str(hex(Result))[2:].zfill(4).upper()}, Expected = {'0x' + str(hex(exp_Result))[2:].zfill(4).upper()}")
    
# Calculate
for a, b, cin, f, status, res in zip(Alst, Blst, Cinlst, Flst, Statuslst, Resultlst):
  exp_res, CF, ZF, NF, VF, PF, AF = gm(a, b, cin, f)
  exp_status = int(str(CF)+ str(ZF)+ str(NF)+ str(VF)+ str(PF) + str(AF), 2)
  # compare
  comp(a, b, cin, f, status, exp_status, res, exp_res)

# Report
print()
print(f"{str(30 * '=').center(140)}")
print(f"{('Report'.center(30)).center(140)}")
print(f"{str(30 * '=').center(140)}")
print(f"{' ' * 55}All Test Cases  -> {All}")
print(f"{' ' * 55}PASSed          -> {PASSed}")
print(f"{' ' * 55}FAILed          -> {All - PASSed}")
print(f"{' ' * 55}Successful      -> {(PASSed/All) * 100}%\n")