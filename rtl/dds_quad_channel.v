`timescale 1ns/1ps

module dds_quad_channel 
(
 clk_i,  
 rst_n_i,
 acc_i,
 acc_o,
 dreq_i,
 tune_i,
 tune_load_i,
 acc_load_i,
 y0_o,
 y1_o,
 y2_o,
 y3_o);

   parameter integer g_acc_frac_bits     = 32;
   
   parameter integer g_output_bits    = 14;
   parameter integer g_lut_sample_bits= 18;
   parameter integer g_lut_slope_bits = 18;
   parameter integer g_interp_shift   = 7;
   parameter integer g_lut_size_log2  = 10;

   parameter integer g_dither_taps = 32'hD0000001;
   parameter integer g_dither_length = 32;
   
   localparam c_acc_bits = g_acc_frac_bits + g_lut_size_log2 + 1;
   localparam c_lut_cell_size = g_lut_sample_bits + g_lut_slope_bits;

   input             clk_i;
   input             rst_n_i;
   input             acc_load_i;
   input             tune_load_i;
   input [g_acc_frac_bits + g_lut_size_log2  : 0] acc_i;
   output reg [g_acc_frac_bits + g_lut_size_log2  : 0] acc_o;
   input [g_acc_frac_bits + g_lut_size_log2  : 0] tune_i;
   input                                          dreq_i;
   output wire [g_output_bits-1:0]                 y0_o, y1_o, y2_o, y3_o;
   
   wire [g_lut_size_log2-1:0] lut_addr[0:3];
   reg [c_lut_cell_size-1:0] lut_data[0:3];
   
   reg [c_acc_bits-1:0]       acc, acc_d0, acc_f[0:3], tune;

   wire [g_output_bits-1:0]    y[0:3];
   
   
   always@(posedge clk_i)
     begin
        if(!rst_n_i)begin
           tune <= 0;
           acc <= 0;
        end else begin
           if(tune_load_i)
             tune <= tune_i;
           
           if(acc_load_i)
             acc <= acc_i;
           else if(dreq_i) begin
             acc <= acc + tune;
           
              acc_d0 <= acc;
              acc_o <= acc;
              
              acc_f[0] <= acc_d0;
              acc_f[1] <= acc_d0 + (tune >> 2);
              acc_f[2] <= acc_d0 + (tune >> 1);
              acc_f[3] <= acc_d0 + (tune >> 2) + (tune >> 1);
           end
           
        end // else: !if(!rst_n_i)
     end // always@ (posedge clk_i)

   generate
      genvar i;
      
      for(i=0;i<4;i=i+1)
        begin
           dds_stage 
            #(
              .g_acc_frac_bits(g_acc_frac_bits),
              .g_output_bits(g_output_bits),
              .g_lut_size_log2(g_lut_size_log2),
              .g_dither_init_value(i*1234567)
              )
           U_Stage_X 
            (
             .clk_i(clk_i),
             .rst_n_i(rst_n_i),
             .acc_i(acc_f[i]),
             .y_o(y[i]),
             .dreq_i(dreq_i),
             .lut_addr_o(lut_addr[i]),
             .lut_data_i(lut_data[i])
             );
        end // for (i=0;i<4;i++)
   endgenerate


   reg [g_lut_sample_bits + g_lut_slope_bits-1:0]    lut01[0:2**g_lut_size_log2-1];
   reg [g_lut_sample_bits + g_lut_slope_bits-1:0]    lut23[0:2**g_lut_size_log2-1];

`include "lut_init.v"
   
   initial begin
      `INIT_LUT(01)
      `INIT_LUT(23)
   end
   

   always@(posedge clk_i)
     lut_data[0] <= lut01[lut_addr[0]];
   always@(posedge clk_i)
     lut_data[1] <= lut01[lut_addr[1]];
   always@(posedge clk_i)
     lut_data[2] <= lut23[lut_addr[2]];
   always@(posedge clk_i)
     lut_data[3] <= lut23[lut_addr[3]];

   assign y0_o = y[0];
   assign y1_o = y[1];
   assign y2_o = y[2];
   assign y3_o = y[3];

endmodule // dds_quad_channel

                         