#!/usr/bin/python

import math

class MDsp:


    def __init__(self, code_size = 256, state_size = 256):
        self.pc = 0
        self.code_size = code_size
        self.state_size = state_size
        self.sidx = 0
        self.code = []

    def nop(self, _finish = False):
        self._insn(self.MAC, 0, 0)

    def finish(self):
        self._insn(self.FINISH, 0, 0);

    INPUT_FLAG = (1<<16)
    COEF_SHIFT = (1<<30)

    MUL = 0
    MAC = 1
    CLAMPH = 2
    CLAMPL = 3
    FINISH = 7

    def input(self, id):
        return id | self.INPUT_FLAG;
    

    def _insn(self, opcode, coefficient, src, dest = None, move = None, output = None):
        opc = (1<<63) if (opcode&(1<<2)) else 0
        opc |= (1<<62) if (opcode&(1<<1)) else 0
        opc |= (1<<35) if (opcode&(1<<0)) else 0

        opc |= int(float(coefficient) * float(self.COEF_SHIFT)) & ((1<<35) - 1);
#        opc |= (1<<62) if finish else 0
        opc |= (1<<61) if dest != None or move != None else 0
        opc |= (1<<60) if output != None else 0
        opc |= (1<<59) if src & self.INPUT_FLAG else 0
        opc |= (1<<58) if dest != None else 0


        print("insn",opcode,"coef",coefficient,"src",src,"dest",dest,"move",move,"out",output)
  
        if(output != None):
            opc |= output << 56

        opc |= (src & 0x1ff) << 46
        
        if(move != None):
            opc |= move << 36

        if(dest != None):
            opc |= dest << 36
        
        self.code.append(opc)
        self.pc += 1

        pass

    def save(self,filename):
        f=open(filename,"w")
        for opc in self.code:
            f.write("0x%016x\n" % opc)
        f.close()

    def dump_sv(self,filename):
        f=open(filename,"w")
        i=0
        f.write("uint64_t code[] = '{\n");
        for opc in self.code:
            f.write("64'h%016x%s\n" % (opc, '};' if i == len(self.code)-1 else ', '))
            i += 1
        f.close()
        

    def state(self):
        self.sidx += 1
        return self.sidx

    def clear(self):
        self.pc = 0
        self.sidx = 0

    def fir(self, coefs, source, _dest= None, _output = None):
        states = []
    
        for c in coefs:
            states.append(self.state())

#        print(states)

        self._insn(self.MUL, coefs[0], source, move = states[0])
        
        for i in range(1, len(coefs) - 1):
#            print("tap %d" % i);
            self._insn(self.MAC, coefs[i], states[i - 1], move = states[i])

        self._insn(self.MAC, coefs[-1], states[len(coefs)-2], dest = _dest, output = _output)

    def fir_test(self, coefs, samples):
        coefs_int = []
        for c in coefs:
            coefs_int.append(int(c * self.COEF_SHIFT))

        delay = [0]*len(coefs)
        
        output = []
        
        for x in samples:
            acc = 0
            for i in range(len(coefs)-1, 0, -1):
                delay[i] = delay[i-1];

            delay[0] = x;
            
#            print(delay)

            for i in range(0, len(coefs)):
                acc += delay[i] * coefs_int[i];
        
            
            y = acc >> 30;
            output.append(y) 
        return output
        

    def biquad_lp(self, Q, f0, fs, source, _dest = None, _output = None):
        w0 = 2*math.pi*f0/fs;
        alpha = math.sin(w0)/(2*Q);

        a0 = 1 + alpha;
        a1 = (-2*math.cos(w0))/a0;
        a2 = (1 - alpha)/a0;
        b0 = ((1 - math.cos(w0))/2)/a0;
        b1 = (1 - math.cos(w0))/a0;
        b2 = ((1 - math.cos(w0))/2)/a0;

        s=[ self.state() for i in range(1,5) ]

#        print(s)

        self._insn(self.MUL, b0, source, move = s[0])
        self._insn(self.MAC, b1, s[0], move = s[1])
        self._insn(self.MAC, b2, s[1])
        self._insn(self.MAC, -a1, s[2], move = s[3])
        self._insn(self.MAC, -a2, s[3], dest = s[2], output = _output)
        if(_dest != None):
            self._insn(self.MAC, 0, s[0], dest = _dest)

 
    def biquad_test(self, Q, f0, fs, samples):

        w0 = 2*math.pi*f0/fs;
        alpha = math.sin(w0)/(2*Q);

        a0 = (1 + alpha);
        a1 = int(((-2*math.cos(w0))/a0) * float(self.COEF_SHIFT))
        a2 = int(((1 - alpha)/a0) * float(self.COEF_SHIFT))
        b0 = int(((1 - math.cos(w0))/2/a0) * float(self.COEF_SHIFT))
        b1 = int(((1 - math.cos(w0))/a0) * float(self.COEF_SHIFT))
        b2 = int(((1 - math.cos(w0))/2/a0) * float(self.COEF_SHIFT))

        x0 = 0;
        x1 = 0;
        y0 = 0;
        y1 = 0;

        output = []

        for x in samples:
            acc = x * b0;
            acc += x0 * b1
            acc += x1 * b2
            acc += y0 * (-a1)
            acc += y1 * (-a2);

            x1 = x0;
            x0 = x;
            
            y = acc >> 30;
            output.append(y)
            y1 = y0
            y0 = y
        return output
	
    def pi_loop(self, kp, ki, source, _dest= None, _output = None):
        integr=self.state()
        tmp=self.state()
        self._insn(self.MUL, ki, source, move = tmp)
        self.nop()
        self.nop()
        self.nop()
        self.nop()
        self._insn(self.MAC, 1.0, integr, dest=integr )
        self._insn(self.MAC, kp, tmp, dest = _dest, output = _output)

    def pi_test(self, kp, ki, samples):
        kp_q = int(kp * float(self.COEF_SHIFT))
        ki_q = int(ki * 256.0 * float(self.COEF_SHIFT))
        integr = 0
        output = []
        acc = 0
        for x in samples:
            acc += x >> 8
            tmp = (ki_q * acc) >> self.COEF_SHIFT
            
            acc = (tmp + x * kp_q) 

            y = acc >> 30
            output.append(y)
        return output

def load_coeffs(filename):
    coeffs = []
    l = open(filename,"r").readlines()[0]
    for cs in l.split(" "):
        coeffs.append(float(cs))
    return coeffs

def main():
    mdsp = MDsp(256, 256)
		
    mdsp.pi_loop(0.2, 0.01, mdsp.input(0), _output=0)
    mdsp.nop()
    mdsp.nop()
    mdsp.nop()
    mdsp.nop()
		
#    st = mdsp.state();

 #   mdsp.biquad_lp(0.7, 1.5e3, 125e6/1024, source = mdsp.input(0), _dest = st )
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.fir(load_coeffs("fir_compensator.dat"), st, _output = 0)

#    mdsp.fir([1,1,1], mdsp.input(0), _output = 0)
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()
    mdsp.finish()
    mdsp.nop()
    mdsp.nop()
    mdsp.nop()
    mdsp.nop()
    mdsp.nop()
    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()
#    mdsp.nop()

    mdsp.dump_sv("dsp_microcode.sv")

    mdsp.save("microcode.dat");
    
    samples = range(0, 10000, 100)

    y = mdsp.pi_test(0.2, 0.01, samples)
    #y = mdsp.biquad_test(0.7, 1.5e3, 125e6/1024, samples)
    #y = mdsp.fir_test(load_coeffs("fir_compensator.dat"), y)


    print(samples)
    print(y)
#    print(mdsp.fir_test([ 1, 1, 1 ], samples ))
#    print(mdsp.biquad_test(0.7, 1e3, 48e3, samples))

if __name__ == "__main__":
    main()
