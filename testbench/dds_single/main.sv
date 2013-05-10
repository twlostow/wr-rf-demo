
module main;

   parameter g_lut_size_log2 = 10;
   parameter g_lut_sample_bits = 18;
   parameter g_lut_slope_bits = 18;
   
   
   reg clk = 0;
   reg rst_n = 0;

   wire [13:0]                                y0, y1, y2 ,y3;

   reg [43:0]                                        tune;
   
   
   dds_quad_channel #(
                       .g_lut_sample_bits   (g_lut_sample_bits),
                       .g_lut_slope_bits   (g_lut_slope_bits),
                       .g_lut_size_log2 (g_lut_size_log2),
                       .g_acc_frac_bits (32),
                       .g_output_bits(14)
    ) DUT (
           .clk_i   (clk),
           .rst_n_i (rst_n),

           .acc_i   (44'h0),
           .tune_i  (tune),

           .acc_load_i (1'b0),
           .tune_load_i(1'b1),
           .dreq_i(1'b1),
//           #y_o    : out std_logic_vector(g_sample_bits-1 downto 0);

     
           .y0_o(y0),
           .y1_o(y1),
           .y2_o(y2),
           .y3_o(y3)
    );


   initial #10ns rst_n = 1;
   always #1ns clk <= ~clk;

   initial begin
      real fs=500e6;
      real fout=10.079e6;
      int  i, lut_size;

      lut_size = 2**g_lut_size_log2;

    //  tune = int'(real'(2**32) * real'(2**g_lut_size_log2) / fout / fs * 2.0);
      tune = 44'd1000000000000;
      
      
      for (i=0;i<lut_size;i++)
        begin
           real y0,y1,ampl;
           reg [g_lut_sample_bits + g_lut_slope_bits-1:0] lv;

           ampl = real'((2**(g_lut_sample_bits-1)) - (2 ** 12));

           //$display("Amplitude: %.3f\n",ampl);
           
           
           y0 = ampl * $sin (3.14159265358979323846 / real'(lut_size) * i);
           y1 = ampl * $sin (3.14159265358979323846 / real'(lut_size) * (i+1));

           lv [g_lut_sample_bits-1:0] = int'(y0);
           lv [g_lut_sample_bits+g_lut_slope_bits-1:g_lut_sample_bits] = int' ((y1-y0) * 128.0);
           
           
         //  DUT.lut01[i] = lv;
         //  DUT.lut23[i] = lv;

        end
      
   end // initial begin


/*   initial begin
`include "lut.v"
   end*/
   
   
   int                                                    s_count = 0, l_count = 0;
   integer                                                    f_out;
   

   initial begin
      f_out = $fopen("/tmp/dds-hw.dat","w");
      $display("File opened, handle %d", f_out);
      
   end
   
   
   always@(posedge clk)
     begin
        
        s_count <= s_count + 1;

        if(s_count > 128)
          begin
             string s;
             
             l_count <= l_count + 1;
             
             $sformat(s, "%d\n%d\n%d\n%d\n", int'(y0),int'(y1),int'(y2),int'(y3));
             $fwrite(f_out, s);
             
             
             if(l_count == 262144)
               begin
                  $fclose(f_out);
                  $stop;
               end
             
             
             
          end
        
        
     end
   
   
   
endmodule // main

