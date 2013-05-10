action= "simulation"
target= "xilinx"
fetchto="../../ip_cores"

modules = { "local" : [ "../../rtl" ] }
					  
files = ["main.sv"]

vlog_opt="+incdir+../../sim"

