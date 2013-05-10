`timescale 1ns/1ns

`include "simdrv_defs.svh"
`include "if_wb_master.svh"

module main;

   reg clk = 0;
   reg rst_n = 0;

   reg [15:0] x;
   wire [15:0] y;
   wire               x_req;
   reg                x_valid =0;
   reg                y_req = 1;

   int                x_data [$];
   int                out_data[$];
   
   

   initial #10ns rst_n = 1;
   always #1ns clk <= ~clk;


   initial begin
      int i;
      
      for (i=0;i<10000;i+=100) begin
        x_data.push_back(10000);
        x_data.push_back(50000);

      end
      
      
   end

   const real kp = 0.002;
   const real ki = 0.000001;

   const int  kp_q = kp * 65536.0;
   const int  ki_q = ki * 65536.0 * 1024.0;


   task automatic sim_pi(real kp, real ki, int x[$], ref int y[$]);
      int i;
      real acc = 0.0;
      
      for (i = 0; i < x.size(); i++)
        begin
           acc += x[i];
           y.push_back(int'(acc * ki + real'(x[i]) * kp));
        end
      
      
   endtask // sim_pi


   reg [15:0] c_kp;
   
   
   
   IWishboneMaster #(32,32)
   U_WB (
         .clk_i(clk),
         .rst_n_i(rst_n)
        );
   
   pi_control DUT (
             .clk_i(clk),
             .rst_n_i(rst_n),

             .d_valid_i(x_valid),
             .d_i(x),

             .q_valid_o(y_valid),
             .q_o(y),

             .ki_i(ki_q),
             .kp_i(kp_q)
   );

   int                in_index = 0;

   
   always@(posedge clk)
       begin
          x_valid <= 1;
          x <= x_data[in_index ++];
          if(in_index >= x_data.size())
            in_index =0;
       end
   
  
   always@(posedge clk)
     if(y_valid)
       $display("%d", y);
   
   
   
endmodule // main

