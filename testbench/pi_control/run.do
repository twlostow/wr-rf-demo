
#make
vlog -sv main.sv +incdir+../../sim +incdir+./gn4124_bfm

vsim -L unisim work.main -voptargs="+acc" -suppress 8684,8683

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do wave.do
run 1000ns
wave zoomfull
radix -hex

