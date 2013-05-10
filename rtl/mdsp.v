`timescale 1ns/1ns

module mdsp (
             input         clk_i,
             input         rst_n_i,

             output        x_req_o,
             input         x_valid_i,
             input signed [23:0]  x_i,

             output reg       y_valid_o,
             input         y_req_i,
             output reg signed [23:0] y_o,


             input         wb_cyc_i,
             input         wb_stb_i,
             input         wb_we_i,
             input [31:0] wb_adr_i,
             input [31:0]  wb_dat_i,
             output [31:0] wb_dat_o,
             output reg       wb_stall_o,
             output reg       wb_ack_o
             );

   
/* 
 opcode format
 [mac/mul/write] : 2 bits
 [coef] : 32 bits
 [src] : 7 bits
 [dst] : 7 bits
*/

   parameter g_data_bits = 32;
   parameter g_coef_bits = 18;
   parameter g_acc_shift = 17;
   parameter g_state_bits = 7;
   parameter g_microcode_size = 128;
   

   
   localparam c_acc_width = 2 + g_coef_bits + g_data_bits;
   localparam c_microcode_addr_bits = 7;
//$clogb2(g_microcode_size);
   
   // stage 1 control (fetch)
   reg [g_state_bits-1:0] f_didx, f_sidx;
   reg signed [g_coef_bits-1:0]  f_coef;
   reg                            f_mul_only, f_write_dest, f_write_out, f_store_acc, f_use_in;
   reg [3:0]                      f_oidx;
   reg [2:0]                      f_opcode;
   

   // stage 1a control (fetch)
   reg [g_state_bits-1:0] pd_didx, pd_sidx;
   reg signed [g_coef_bits-1:0]  pd_coef;
   reg                            pd_mul_only, pd_write_dest, pd_write_out, pd_store_acc, pd_finish, pd_use_in;
   reg [3:0]                      pd_oidx;
   reg signed [g_data_bits  -1 :0 ] pd_state;
   reg [2:0]                        pd_opcode;
   

   // stage 2 control (decode / fetch source)
   reg [g_state_bits-1:0] d_didx;

   reg signed [g_coef_bits-1:0]  d_coef;


   reg                    d_mul_only, d_write_dest, d_write_out, d_store_acc,d_use_in;
   reg [3:0]              d_oidx;
   reg signed [g_data_bits  -1 :0 ] d_state;
   reg [2:0]                        d_opcode;
   
   

   // stage 3 control (execute 1)
   reg [g_state_bits-1:0]         e1_didx;
   reg                            e1_write_dest, e1_write_out, e1_store_acc;
   reg [3:0]                      e1_oidx;
   reg signed [g_data_bits  -1 :0 ] e1_state;
   reg [2:0]                        e1_opcode;
   

   // stage 4 control (execute 2)
   reg [g_state_bits-1:0]         e2_didx;
   reg                            e2_write_dest, e2_write_out, e2_store_acc;
   reg [3:0]                      e2_oidx;   
   reg signed [g_data_bits  -1 :0 ] e2_state;
   reg [2:0]                        e2_opcode;

   
   // stage 4 control (execute 2)
   reg [g_state_bits-1:0]         e3_didx;
   reg                            e3_write_dest, e3_write_out, e3_store_acc;
   reg [3:0]                      e3_oidx;   
   reg signed [g_data_bits  -1 :0 ] e3_state;
   reg [2:0]                        e3_opcode;
   
   
   reg signed [c_acc_width-1:0]   acc0, acc1, acc2, m0;
   reg signed [g_data_bits-1:0]   acc_trunc;
   reg signed [g_data_bits-1:0]   state_mem[0: 2**g_state_bits-1];

   reg [c_microcode_addr_bits-1:0] pc,pc_d0;

   reg [63:0]                     microcode[0:2**c_microcode_addr_bits-1];
   reg [31:0]                     mc_in_hi, mc_in_lo;
   
   reg                           stall;
   reg                           reset_wb = 0;

   wire                          rst_n = rst_n_i & ~reset_wb;

`define opc_mul 3'b000
`define opc_mac 3'b001
`define opc_clamph 3'b010
`define opc_clampl 3'b011
`define opc_finish 3'b111

   reg [31:0]                    ram_tmp;
   
   
/*
   generic_dpram
     #(
       .g_data_width(32),
       .g_size                     (g_microcode_size),
       .g_dual_clock  (0)
       ) U_MC_Ram_HI (
                      .rst_n_i (rst_n_i),
                      .clka_i  (clk_i),
                      .wea_i   (wb_we_i && wb_adr_i[11] && wb_adr_i[2]),
                      .aa_i    (wb_adr_i [9:3]),
                      .da_i (wb_dat_i),
                      
                      .ab_i    (pc[6:0]),
                      .qb_o    (mc_in_hi));

      generic_dpram
     #(
       .g_data_width(32),
       .g_size                     (g_microcode_size),
       .g_dual_clock  (0)
       ) U_MC_Ram_LO (
                      .rst_n_i (rst_n_i),
                      .clka_i  (clk_i),
                      .wea_i   (wb_we_i && wb_adr_i[11] && !wb_adr_i[2]),
                      .aa_i    (wb_adr_i [9:3]),
                      .da_i (wb_dat_i),
                      
                      .ab_i    (pc[6:0]),
                      .qb_o    (mc_in_lo));


*/
   
   always@(posedge clk_i)
     if(!rst_n_i) begin
        wb_stall_o <= 0;
        wb_ack_o <= 0;
        reset_wb <= 1;
     end else if(wb_cyc_i && wb_stb_i)
       begin
          if(wb_we_i && wb_adr_i[11] && wb_adr_i[2])
            ram_tmp <= wb_dat_i;
          
//            microcode_hi[wb_adr_i [10:3]] <= wb_dat_i;
          else if(wb_we_i && wb_adr_i[11] && !wb_adr_i[2])
            microcode[wb_adr_i [10:3]] <= {ram_tmp, wb_dat_i};
          else if (wb_we_i && !wb_adr_i[11])
            reset_wb <= wb_dat_i[0];
          wb_ack_o <= 1;
          
       end else 
         wb_ack_o <= 0;
   
   
   
   // pipeline stall control
   always @(*)
     if(!x_valid_i && pd_use_in)
       stall <= 1;
     else if(!y_req_i && e2_write_out)
       stall <= 1;
     else
       stall <= 0;
           
   //  synthesis attribute ram_style of microcode is "block";

   always@(microcode, pc_d0)
       { mc_in_hi, mc_in_lo } <= microcode[pc_d0];
   
   reg rst_n_d0 = 0;
   
   always@(posedge clk_i)
     rst_n_d0 <= rst_n;
   
   always@(posedge clk_i)
     if(!rst_n || !rst_n_d0 || (!stall && d_opcode == `opc_finish))
       pc <= 1;
     else if (!stall)
       pc <= pc + 1;

   always@(posedge clk_i)
     if(!rst_n || !rst_n_d0 || (!stall && d_opcode == `opc_finish))
       pc_d0 <= 0;
     else if(!stall)
       pc_d0 <= pc;
   
   

   // synthesis translate_off
   initial begin : init_sram
      integer i;
      for(i=0;i< (1<<g_state_bits) ;i=i+1)
        state_mem[i]=0;
   end
   // synthesis translate_on

   // stage 0: fetch next instruction word, increase PC   
   always@(mc_in_hi, mc_in_lo)
       begin
          f_opcode[2] <= mc_in_hi[31];
          f_opcode[1] <= mc_in_hi[30];
          f_opcode[0] <= mc_in_hi[35-32];
          f_write_dest <= mc_in_hi[61-32];
          f_write_out <= mc_in_hi[60-32];
          f_use_in <= mc_in_hi[59-32];
          f_store_acc <= mc_in_hi[58-32];
          f_oidx <= mc_in_hi[57-32:56-32];
          f_sidx <= mc_in_hi[55-32:46-32];
          f_didx <= mc_in_hi[45-32:36-32];
          
          f_coef <= {mc_in_hi[1:0] , mc_in_lo };
       end
        
   assign x_req_o = (pd_use_in & rst_n) & ~x_valid_i;

   always@(posedge clk_i)
     if(!rst_n) begin
        pd_write_dest <= 0;
        pd_write_out <= 0;
        pd_store_acc <= 0;
        pd_use_in <= 0;
        pd_opcode <= 0;
     end else if(!stall) 
       begin
          pd_opcode <= f_opcode;
          pd_coef <= f_coef;
          pd_write_dest <= f_write_dest;
          pd_write_out <= f_write_out;
          pd_store_acc <= f_store_acc;
          pd_oidx <= f_oidx;
          pd_didx <= f_didx;
          pd_sidx <= f_sidx;
          pd_state <= x_i;
          pd_use_in <= f_use_in;
          
       end
   
   always@(posedge clk_i)
     if(!rst_n) begin
        d_write_dest <= 0;
        d_write_out <= 0;
        d_store_acc <= 0;
        d_opcode <=0;
        d_use_in <= 0;
        
        
     end else

       if(!stall)
             begin
          d_opcode <= pd_opcode;
          d_use_in <= pd_use_in;
          d_coef <= pd_coef;
          d_write_dest <= pd_write_dest;
          d_write_out <= pd_write_out;
          d_store_acc <= pd_store_acc;
          d_oidx <= pd_oidx;
          d_didx <= pd_didx;
   
          if(pd_use_in)
            d_state <= x_i;
          else
            d_state <= state_mem[pd_sidx];
       end
   
   always@(posedge clk_i)
     if(!rst_n)
       begin
          acc0 <= 0;
          e1_write_dest <= 0;
          e1_write_out <= 0;
          e1_store_acc <= 0;
          e1_opcode <= 0;
          
       end else if(!stall)
         begin
            e1_write_dest <= d_write_dest;
            e1_write_out <= d_write_out;
            e1_store_acc <= d_store_acc;
            e1_oidx <= d_oidx;
            e1_didx <= d_didx;
            e1_state <= d_state;
            e1_opcode <= d_opcode;

            m0 <= d_state * d_coef;
            
            
          //  case(d_opcode)
/*               `opc_mul:
                acc0 <= d_state * d_coef;
               `opc_mac:
                acc0 <= acc0 + d_state * d_coef;
               `opc_mul:
                acc0 <= d_state * d_coef;*/
//              default:
          /*     `opc_clamph:
                if((acc0 >> g_acc_shift) > d_coef)
                  acc0 <= d_coef << g_acc_shift;
              `opc_clampl:
                if((acc0 >> g_acc_shift) < d_coef)
                  acc0 <= d_coef << g_acc_shift;*/

           // endcase // case (d_opcode)
            
         end

   always@(posedge clk_i)
     if(!rst_n)
       begin
          e2_write_dest <= 0;
          e2_write_out <= 0;
          e2_store_acc <= 0;
          e2_opcode <= 0;
          
       end else begin
          if(!stall)
            begin

               case (e1_opcode)
                 `opc_mul:
                   acc1 <= m0;
                 `opc_mac:
                   acc1 <= acc1 + m0;
                 default:
                   acc1 <= m0;
               endcase // case (e1_opcode)
               
               e2_opcode <= e1_opcode;
               
               e2_write_dest <= e1_write_dest;
               e2_write_out <= e1_write_out;
               e2_store_acc <= e1_store_acc;
               e2_oidx <= e1_oidx;
               e2_didx <= e1_didx;
               e2_state <= e1_state;
               
               //acc1 <= acc0;
               
            end
       end // else: !if(!rst_)n

 always@(posedge clk_i)
     if(!rst_n)
       begin
          e3_write_dest <= 0;
          e3_write_out <= 0;
          e3_store_acc <= 0;
          
       end else begin
          if(!stall)
            begin

               acc2<=acc1;
               
               e3_write_dest <= e2_write_dest;
               e3_write_out <= e2_write_out;
               e3_store_acc <= e2_store_acc;
               e3_oidx <= e2_oidx;
               e3_didx <= e2_didx;
               e3_state <= e2_state;
               
               //acc1 <= acc0;
               
            end
       end // else: !if(!rst_n)
   
   always@(acc2)
     if(acc2[g_acc_shift-1])
       acc_trunc <= (acc2 >> g_acc_shift);
     else
       acc_trunc <= (acc2 >> g_acc_shift);
   
   always@(posedge clk_i)
     if(!stall) begin
        if(e3_store_acc)
          state_mem[e3_didx] <= acc_trunc;
        else if(e2_write_dest)
          state_mem[e3_didx] <= e3_state;

        if(e3_write_out) begin
           y_o <= acc_trunc;
           y_valid_o <= 1;
        end else begin
           y_valid_o <= 0;
        end
     end // if (!stall)
   
endmodule // mdsp
