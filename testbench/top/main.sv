`timescale 1ns/1ps

`include "simdrv_defs.svh"
`include "gn4124_bfm.svh"

`include "../../dds_regs.vh"


const uint64_t BASE_WRPC = 'h00c0000;
const uint64_t BASE_DDS = 'h0080000;


class CDDSCore;

   protected CBusAccessor m_acc;
   protected uint64_t m_base;
   
   task writel(uint64_t addr, uint64_t val);
      m_acc.write(m_base + addr, val);
   endtask

   task readl(uint64_t addr, ref uint64_t val);
      m_acc.read(m_base + addr, val);
   endtask
   
   function new(CBusAccessor acc, uint64_t base);
      m_acc = acc;
      m_base = base;
   endfunction // new

   task set_center_frequency( real freq, real fs );
      real tune;
      
      tune = (real'(1<<16) * real'(1<<16) * real'(1<<10) * (freq / fs) * 4.0);

      $display("CDDSCore: center frequnecy %.3f MHz [tune = %.3f, 0x%x]", freq/1e6, tune, uint64_t'(tune));
      
      
      writel(`ADDR_DDS_FREQ_HI, uint64_t'(tune) >> 32);
      writel(`ADDR_DDS_FREQ_LO, uint64_t'(tune));
      
      
      writel(`ADDR_DDS_GAIN, 50000);
      
   endtask // set_center_frequency

   task tune_write(int value);
      writel(`ADDR_DDS_TUNE_FIFO_R0, value);
   endtask // tune_write

   task boot_mdsp(uint64_t code[]);
      int i;
      writel('h4000, 1); // reset 

    for(i=0;i<code.size();i++)
        begin
//           $display("%16x", code[i]);

           writel('h4000+(i*8 + 4) | (1<<11), (code[i]>>32));
           writel('h4000+(i*8)  | (1<<11), (code[i]>>0));
           
             
        end
      writel('h4000, 0); // un-reset 

   endtask // boot_mdsp


   task enable_master(int bcid);
      int ki_q = 100;
      int kp_q = 1000;

      writel(`ADDR_DDS_MACH, 'hffff);
      writel(`ADDR_DDS_MACL, 'hffffffff);
      
      
      writel(`ADDR_DDS_PIR, (ki_q << 16) | (kp_q));
      writel(`ADDR_DDS_CR, `DDS_CR_MASTER |( bcid << `DDS_CR_CLK_ID_OFFSET));
   endtask // master
   

   task enable_slave(int bcid);
      writel(`ADDR_DDS_MACH, 'hffff);
      writel(`ADDR_DDS_MACL, 'hffffffff);

      writel(`ADDR_DDS_CR, `DDS_CR_SLAVE |( bcid << `DDS_CR_CLK_ID_OFFSET));
      writel(`ADDR_DDS_DLYR, 1000);
   endtask // master
   
      
       
   
  
endclass // CDDSCore


module main;
   reg clk_wr_ref = 0;
   reg clk_20m_vcxo = 0;
   reg tdc_start = 0;
   
   always #4ns clk_wr_ref <= ~clk_wr_ref;
   always #20ns clk_20m_vcxo <= ~clk_20m_vcxo;
   
   IGN4124PCIMaster I_GennumA ();
   IGN4124PCIMaster I_GennumB ();

   wire [13:0] dac_p;
   
`include "../mdsp/dsp_microcode.sv"

   wire        a2b_p, a2b_n, b2a_p, b2a_n;
   
   
   spec_top
     #(
       .g_simulation(1),
       .g_bypass_wrcore(0)
       )
     DUT_A
 (
  .clk_20m_vcxo_i(clk_20m_vcxo),

  .dds_wr_ref_clk_p_i(clk_wr_ref),
  .dds_wr_ref_clk_n_i(~clk_wr_ref),

  .dds_adc_sdo_i(1'b0),
  .dds_dac_p_o(dac_p),

  .sfp_txp_o(a2b_p),
  .sfp_txn_o(a2b_n),

  .sfp_rxp_i(b2a_p),
  .sfp_rxn_i(b2a_n),
  
  `GENNUM_WIRE_SPEC_PINS(I_GennumA)
  );

   spec_top
     #(
       .g_simulation(1),
       .g_bypass_wrcore(0)
       )
     DUT_B
 (
  .clk_20m_vcxo_i(clk_20m_vcxo),

  .dds_wr_ref_clk_p_i(clk_wr_ref),
  .dds_wr_ref_clk_n_i(~clk_wr_ref),

  .dds_adc_sdo_i(1'b0),
  .dds_dac_p_o(dac_p),

  .sfp_txp_o(b2a_p),
  .sfp_txn_o(b2a_n),

  .sfp_rxp_i(a2b_p),
  .sfp_rxn_i(a2b_n),
  
  
  `GENNUM_WIRE_SPEC_PINS(I_GennumB)
  );

   const real kp = 0.002;
   const real ki = 0.000001;

   const int  kp_q = 100;
// kp * 65536.0;
              const int  ki_q =10000;
// ki * 65536.0 * 1024.0;

    initial begin
      uint64_t rval;
       int i;

       
      CBusAccessor acc_a, acc_b ;
      CDDSCore dds_a;
      CDDSCore dds_b;
       
      acc_a = I_GennumA.get_accessor();
      acc_b = I_GennumB.get_accessor();
      @(posedge I_GennumA.ready);


       acc_a.read(0, rval);
       $display("Startup: A SDB signature = 0x%08x", rval);
       acc_b.read(0, rval);
       $display("Startup: B SDB signature = 0x%08x", rval);
       acc_a.write(BASE_DDS + `ADDR_DDS_RSTR, `DDS_RSTR_SW_RST);
       acc_a.write(BASE_DDS + `ADDR_DDS_RSTR, 0);
       acc_b.write(BASE_DDS + `ADDR_DDS_RSTR, `DDS_RSTR_SW_RST);
       acc_b.write(BASE_DDS + `ADDR_DDS_RSTR, 0);

       dds_a = new(acc_a, BASE_DDS);
       dds_b = new(acc_b, BASE_DDS);

       dds_a.set_center_frequency(10e6, 250e6);
       dds_b.set_center_frequency(10e6, 250e6);

       dds_a.enable_master(11);
       dds_b.enable_slave(11);
       
      
    end // initial begin

/*   assign DUT_B.wrc_src_out_cyc =  DUT_A.wrc_snk_in_cyc;
   assign DUT_B.wrc_src_out_stb =  DUT_A.wrc_snk_in_stb;
   assign DUT_B.wrc_src_out_we =  DUT_A.wrc_snk_in_we;
   assign DUT_B.wrc_src_out_adr = DUT_A.wrc_snk_in_adr;
   assign DUT_B.wrc_src_out_dat = DUT_A.wrc_snk_in_dat;
   assign DUT_B.wrc_src_out_sel = DUT_A.wrc_snk_in_sel;

   assign DUT_A.wrc_snk_out_ack =  DUT_B.wrc_src_in_ack;
   assign DUT_A.wrc_snk_out_stall = DUT_B.wrc_src_in_stall;
   assign DUT_A.wrc_snk_out_err =  DUT_B.wrc_src_in_err;
   assign DUT_A.wrc_snk_out_rty =  DUT_B.wrc_src_in_rty;
  */ 
   
 
endmodule // main

