action= "simulation"
target= "xilinx"
fetchto="../../ip_cores"

modules = { "local" : [ "../../top", "gn4124_bfm" ]	}
					  
files = ["main.sv"]

vlog_opt="+incdir+../../sim +incdir+gn4124_bfm"

