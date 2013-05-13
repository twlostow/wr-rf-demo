`timescale 1ns/1ns
module pll_init
  (
   input clk_i,
   input rst_n_i,

   output reg done_o,

   output reg cs_n_o,
   output reg mosi_o,
   output reg sck_o
   );

   reg [2:0]  pll_init_seq[0:8191];
   
   initial begin : initialize_lut
      integer i;

      for(i=0;i<2048;i=i+1)
        begin
           pll_init_seq[4*i] = 3'h7;
           pll_init_seq[4*i+1] = 3'h7;
           pll_init_seq[4*i+2] = 3'h7;
           pll_init_seq[4*i+3] = 3'h7;
        end
      
`include "pll_init_data.v"
   end // block: initialize_lut
   
   parameter g_simulation = 0;
   localparam g_bit_time = g_simulation ? 1: 300;
   localparam g_done_delay = g_simulation ? 300: 300000;

   reg [23:0] cnt;
   reg [12:0] addr;

   reg [1:0]  state;
   
`define ST_IDLE 0
`define ST_BOOT_PLL 1
`define ST_INIT_DELAY 2
`define ST_DONE 3

   wire [2:0] ram_in;

   assign ram_in = pll_init_seq[addr];

   
   always@(posedge clk_i or negedge rst_n_i)
     if(!rst_n_i)
       begin
          state <= `ST_IDLE;
          addr <= 0;
          cnt <= 0;
          done_o <= 0;
          
       end else begin
          case (state)
            
            `ST_IDLE: begin
               state <= `ST_BOOT_PLL;
               
               addr <= 0;
               cnt <= 0;
            end
            
            `ST_BOOT_PLL: begin
               cs_n_o <= ram_in[0];
               sck_o <= ram_in[1];
               mosi_o <= ram_in[2];
               
               cnt <= cnt + 1;
               if(cnt == g_bit_time)begin
                 addr <= addr + 1;
                  cnt <= 0;
                  if(addr == 8191)
                       state <= `ST_INIT_DELAY;
                  end
               else 
                 cnt <= cnt + 1;
            end // case: `ST_BOOT_PLL
            
            `ST_INIT_DELAY: begin
               cnt <= cnt + 1;

               if(cnt == g_done_delay)
                 state <= `ST_DONE;
            end
            `ST_DONE:
              done_o <= 1;
          endcase // case (state)
       end // else: !if(!rst_n_i)


endmodule // pll_init



