for op in ops:
  for l in op:
    A, B, Cin, OpCode, Status, Result = line(l)
    CF, VF = CF_VF_calc(A, B, Cin, OpCode, Result)
    ZF = ZF_calc(Result)
    PF = PF_calc(Result)
    AF = AF_calc(OpCode[3], A, B)
    NF = NF_calc(Result)
    if Status == CF + ZF + NF + VF + PF + AF:
      PASSed += 1
    else:
      FAILed += 1
