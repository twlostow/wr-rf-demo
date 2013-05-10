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
   
       
   
  
endclass // CDDSCore


module main;
   reg clk_wr_ref = 0;
   reg clk_20m_vcxo = 0;
   reg tdc_start = 0;
   
   always #4ns clk_wr_ref <= ~clk_wr_ref;
   always #20ns clk_20m_vcxo <= ~clk_20m_vcxo;
   
   IGN4124PCIMaster I_Gennum ();

   wire [13:0] dac_p;
   
`include "../mdsp/dsp_microcode.sv"

   spec_top
     #(
       .g_simulation(1)
       )
     DUT
 (
  .clk_20m_vcxo_i(clk_20m_vcxo),

  .dds_wr_ref_clk_p_i(clk_wr_ref),
  .dds_wr_ref_clk_n_i(~clk_wr_ref),

  .dds_adc_sdo_i(1'b0),
  
  .dds_dac_p_o(dac_p),
  
  `GENNUM_WIRE_SPEC_PINS(I_Gennum)
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

       
      CBusAccessor acc ;
      CDDSCore dds;
       
      acc = I_Gennum.get_accessor();
      @(posedge I_Gennum.ready);


      acc.read(0, rval);
      $display("Startup: SDB signature = 0x%08x", rval);
       acc.write(BASE_DDS + `ADDR_DDS_RSTR, `DDS_RSTR_SW_RST);
       acc.write(BASE_DDS + `ADDR_DDS_RSTR, 0);
       dds = new(acc, BASE_DDS);


       dds.set_center_frequency(10e6, 250e6);

       //dds.boot_mdsp(code);

       acc.write(BASE_DDS + `ADDR_DDS_PIR, (ki_q << 16) | (kp_q));

       dds.writel(`ADDR_DDS_CR, `DDS_CR_MASTER);
       
       
/*       for(i=0;i<30;i++)
         dds.tune_write(-10000);
       for(i=0;i<30;i++)
         dds.tune_write(10000);
       for(i=0;i<30;i++)
         dds.tune_write(0);*/
       
       
      
   end
   
   int                                                    s_count = 0, l_count = 0;
   integer                                                    f_out;
   

   initial begin
      f_out = $fopen("/tmp/dds-hw.dat","w");
      $display("File opened, handle %d", f_out);
      
   end
   
   always@(posedge DUT.clk_ref)
     begin
        
        s_count <= s_count + 1;

        if(s_count > 10000)
          begin
             string s;
             
             l_count <= l_count + 1;
             
             $sformat(s, "%d\n", dac_p);
             $fwrite(f_out, s);
             
             
             if(l_count == 262144)
               begin
                  $fclose(f_out);
                  $stop;
               end
             
             
             
          end
        
        
     end
   
   
endmodule // main

