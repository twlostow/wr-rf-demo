`timescale 1ns/1ns

`include "simdrv_defs.svh"
`include "if_wb_master.svh"

module main;

   reg clk = 0;
   reg rst_n = 0;

   reg signed [23:0] x;
   wire signed [23:0] y;
   wire               x_req;
   reg                x_valid =0;
   reg                y_req = 1;

   int                x_data [$];
   int                out_data[$];
   
   

   initial #10ns rst_n = 1;
   always #1ns clk <= ~clk;

   `include "dsp_microcode.sv"

   initial begin
      int i;
      
      for (i=0;i<10000;i+=100)
        x_data.push_back(-100);
      
   end
   
   
   IWishboneMaster #(32,32)
   U_WB (
         .clk_i(clk),
         .rst_n_i(rst_n)
        );
   
   mdsp #(
          .g_acc_shift(30)
     ) DUT (
             .clk_i(clk),
             .rst_n_i(rst_n),

             .x_req_o(x_req),
             .x_valid_i(x_valid),
             .x_i(x),

             .y_valid_o(y_valid),
             .y_req_i(y_req),
             .y_o(y),


             .wb_cyc_i(U_WB.master.cyc),
             .wb_stb_i(U_WB.master.stb),
             .wb_we_i(U_WB.master.we),
             .wb_adr_i(U_WB.master.adr),
             .wb_dat_i(U_WB.master.dat_o),
             .wb_ack_o(U_WB.master.ack),
             .wb_stall_o(U_WB.master.stall)
             );

   int                in_index = 0;

   reg [7:0]          count =0;

   always@(posedge clk)
     count <= count + 1;
   
   
   
   always@(posedge clk)
     if(x_req)// && count < 100)
       begin
          x_valid <= 1;
          x <= x_data[in_index ++];
          if(in_index >= x_data.size())
            in_index =0;
          
       end else
         x_valid <= 0;
   
  
   always@(posedge clk)
     if(y_valid)
       $display("%d", y);
   
           
   initial begin
      int i;
      CWishboneAccessor acc;
      
      #100ns;

      acc = U_WB.get_accessor();
      U_WB.settings.addr_gran = BYTE;
      
      
      for(i=0;i<code.size();i++)
        begin
//           $display("%16x", code[i]);

           acc.write((i*8 + 4) | (1<<11), (code[i]>>32));
           acc.write((i*8)  | (1<<11), (code[i]>>0));
           
             
        end

      #100ns;
      
      acc.write(0, 0); // un-reset 
      
      

        
   end // initial begin

   
   
   
endmodule // main

