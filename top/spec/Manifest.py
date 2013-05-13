
files = ["spec_top.vhd", "spec_top.ucf", "spec_serial_dac.vhd", "spec_serial_dac_arb.vhd", "spec_reset_gen.vhd"]

modules = { "local" : [ "../../rtl" ], 
						"git" : [ "git://ohwr.org/hdl-core-lib/wr-cores.git" ],
            "svn" : [ "http://svn.ohwr.org/gn4124-core/trunk/hdl/gn4124core/rtl" ] }
