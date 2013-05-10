module mac_test(
                input         clk_i,
                input         rst_n_i,

                input signed [63:0]  acc_i,
                input [1:0]   op_i,

                input signed [31:0]  a_i,
                input signed [31:0]  b_i,

                output signed [63:0] q_o);

   reg signed [63:0]                 acc0, acc1, acc2, m0, d0;

`define op_mul 2'b00
`define op_mac 2'b01
`define op_load 2'b10
`define op_trunc 2'b11

   reg                               [1:0] s2_op, s3_op, s4_op;
   
   always@(posedge clk_i)
     begin
        
        case(op_i)
          `op_mac: m0 <= a_i * b_i;
          `op_mul: m0 <= a_i * b_i;
          `op_load: d0 <= acc_i;
          default: m0 <= a_i * b_i;
        endcase // case (op_i)

        s2_op <= op_i;
        
     end // always@ (posedge clk_i)
   
   always@(posedge clk_i)
     begin
        s3_op <= s2_op;
        case(s2_op)
          `op_mac: acc0 <= acc0 + m0;
          `op_load: acc0 <= d0;
          default: acc0 <= m0;
        endcase // case (s2_op)

     end
   
   always@(posedge clk_i)
     begin
        s4_op <= s3_op;
        acc1 <=acc0;
     end
   
   always@(posedge clk_i)
     if(s4_op == `op_trunc)
       acc2 <= acc1 >> 30;
     else
       acc2 <= acc1;

   
   assign q_o = acc2;

endmodule // mac_test

                
               