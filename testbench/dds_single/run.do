
make
vlog -sv main.sv +incdir+../../sim

vsim -L unisim work.main -voptargs="+acc" -suppress 8684,8683

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do wave.do
run 100ns
wave zoomfull
radix -hex

