
module main;

   reg clk = 0;
   reg rst_n = 0;

   reg [1:0] en=0;
   
   
   lfsr_gen #(
              .g_length   (16),
              .g_taps     (16'hb400),
              .g_recurse(1),
              .g_init_value(16'hace1)
    
    ) DUT (
           .clk_i   (clk),
           .rst_n_i (rst_n),

           .enable_i   (1'b1)
    );

   lfsr_gen #(
              .g_length   (16),
              .g_taps     (16'hb400),
              .g_recurse(4),
              .g_init_value(16'hace1)
    
    ) DUT2 (
           .clk_i   (clk),
           .rst_n_i (rst_n),

           .enable_i   (!en?1'b1:1'b0)
    );


   
   
   initial #100 rst_n = 1;
   always #10 clk <= ~clk;

   always@(posedge clk)
     en<=en+1;
   
   
   
endmodule // main

