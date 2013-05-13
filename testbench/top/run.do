
#make
vlog -sv main.sv +incdir+../../sim +incdir+gn4124_bfm

vsim -t 10fs -L unisim work.main -voptargs="+acc" -suppress 8684,8683 -novopt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do wave.do
run 50000ns
wave zoomfull
radix -hex

