`timescale 1ns/1ps

module dds_stage
  (
   clk_i,  
   rst_n_i,
   acc_i, 
   dreq_i,
   y_o,
   lut_addr_o,
   lut_data_i
   );
   
   parameter integer g_acc_frac_bits     = 32;
   parameter integer g_dither_init_value = 32'h00000001;
   
   parameter integer g_output_bits    = 12;
   parameter integer g_lut_sample_bits= 18;
   parameter integer g_lut_slope_bits = 18;
   parameter integer g_interp_shift   = 7;
   parameter integer g_lut_size_log2  = 12;

   parameter integer g_dither_taps = 32'hD0000001;
   parameter integer g_dither_length = 32;
   
   
   localparam c_dither_bits = (g_lut_sample_bits - g_output_bits - 1);
   localparam c_acc_bits = g_acc_frac_bits + g_lut_size_log2 + 1;
   localparam c_output_shift = g_lut_sample_bits - g_output_bits;


   wire signed [c_dither_bits :0 ] dither_in;
   
   input             clk_i;
   input             rst_n_i;
   input [g_acc_frac_bits + g_lut_size_log2  : 0] acc_i;
   input                                             dreq_i;
   output reg [g_output_bits-1:0]                    y_o;
   output reg [g_lut_size_log2-1:0]                  lut_addr_o;
   input [g_lut_sample_bits + g_lut_slope_bits - 1:0] lut_data_i;

   
   reg [c_acc_bits-1:0]                               acc0, acc1, tune;
   wire [g_lut_size_log2 : 0]                         phase;
   wire [g_lut_slope_bits-1 : 0]                      frac;
   reg [g_lut_slope_bits-1 : 0]                       frac_d0, frac_d1, frac_d2, frac_d3;
   wire                                               half;
   reg [g_lut_size_log2-1:0]                          addr0, addr1,tmp,tmp2,tmp3;
   reg [8:0]                                          sign;
   reg [g_lut_sample_bits + g_lut_slope_bits-1:0]     lut_in;
   wire signed [g_lut_slope_bits-1:0] lut_slope;
   reg signed [g_lut_slope_bits-1:0] slope_d0;
   wire signed [g_lut_sample_bits-1:0]       lut_sample;
   reg signed [g_lut_sample_bits-1:0]       sample_d0;
   reg signed [g_lut_sample_bits-1:0] interp, interp_d0;
   reg signed [g_lut_sample_bits-1:0] qv;
   reg signed [g_output_bits:0]       yt;
   
   wire signed [2*g_lut_slope_bits-1:0] interp_mul;

   reg [g_dither_length-1:0]                         lfsr=g_dither_init_value;
   
   assign lut_slope = lut_in[g_lut_sample_bits + g_lut_slope_bits - 1 : g_lut_sample_bits ];
   assign lut_sample = lut_in[g_lut_sample_bits - 1 : 0];

   assign phase = acc_i [ g_acc_frac_bits + g_lut_size_log2 - 1 : g_acc_frac_bits - 1];
   assign half = acc_i [g_acc_frac_bits + g_lut_size_log2];
   assign frac = acc_i [g_acc_frac_bits - 1 : g_acc_frac_bits-g_lut_slope_bits];

   always@(posedge clk_i)
     begin
        if (!rst_n_i) begin
           lfsr <= g_dither_init_value;
        end else if (dreq_i) begin
           if(lfsr[0])
             lfsr <= {1'b0, lfsr[g_dither_length-1:1]} ^ g_dither_taps;
           else
             lfsr <= {1'b0, lfsr[g_dither_length-1:1]};
        end
     end

   wire signed [g_lut_slope_bits:0] interp_frac;

   assign interp_frac = {1'b0, frac_d3};
   
   
   assign  dither_in = { lfsr[c_dither_bits+4:5], 1'b0 };
   assign interp_mul = lut_slope * interp_frac;
   
   always@(posedge clk_i)
     begin
        if (!rst_n_i) begin

           
        end else if(dreq_i) begin

              addr0 <= acc_i[g_acc_frac_bits + g_lut_size_log2-1 : g_acc_frac_bits];
              sign <= {sign[7:0], half };

              lut_addr_o <= addr0;
              lut_in <= lut_data_i;

              frac_d0 <= frac;
              frac_d1 <= frac_d0;
              frac_d2 <= frac_d1;
              frac_d3 <= frac_d2;
              
              interp <= interp_mul >>> (g_lut_slope_bits + g_interp_shift);

              sample_d0 <= lut_sample;
              
              qv <= (sample_d0) + (interp) + (dither_in) + 1;
              
              if(sign[5])
                yt <= qv >>> (c_output_shift-1);
              else
                yt <= (-qv) >>> (c_output_shift-1);

              if(yt[0])
                y_o <= (yt[g_output_bits:1] +  (1<<(g_output_bits - 1)) + 1);
              else
                y_o <= (yt[g_output_bits:1] +  (1<<(g_output_bits - 1)));
              
        end // if (dreq_i)
     end // always@ (posedge clk_i)

endmodule // dds_single_channel
