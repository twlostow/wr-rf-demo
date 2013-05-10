module pi_control(
                  input             clk_i,
                  input             rst_n_i,
                  
                  input             d_valid_i,
                  input [15:0]      d_i,

                  output reg        q_valid_o,
                  output reg signed [15:0] q_o,

                  input signed [15:0]      ki_i,
                  input signed [15:0]      kp_i
                  );

   parameter                     g_goal = 32768;
   parameter                   g_acc_shift = 6;
   
   
   reg signed [39:0]                acc;


   reg signed [15:0]                err,d0,d1;

   reg [4:0]                        stage;

   reg                              clip_plus;
   reg                              clip_minus;
   

   wire signed [17:0]               ds;
   assign ds = {3'b0, d_i} - g_goal;
   
   always@(posedge clk_i)
     if(!rst_n_i) begin
        stage[0] <= 0;
        acc <= 0;
     end else begin
       stage[0] <= d_valid_i;
        if(d_valid_i) begin

           $display("%d %d", ds <0, !clip_minus);

           
           if(clip_plus && ds<0)
             acc <= acc + ds;
           else if(clip_minus && ds>0)
             acc <= acc + ds;
           else if (!clip_plus && !clip_minus)
             acc <= acc + ds;

           d0 <= ds;
           
        end
     end
   

   reg signed [39 - g_acc_shift : 0] acc0;

   always@(posedge clk_i)
     if(!rst_n_i) begin
        stage[1] <= 0;
     end  else begin
        acc0 <= acc >> g_acc_shift;
        d1<=d0;
        
        stage[1] <= stage[0];
     end
   


   reg signed [23:0]                 term_p, term_i, sum;

   wire signed [24 + 30 - 1 : 0]     mul_p, mul_i;

   assign mul_i = acc0 * ki_i;
   assign mul_p = d1 * kp_i;
   
   
   
   always@(posedge clk_i)
     if(!rst_n_i) begin
        stage[2] <= 0;
     end  else begin
        stage[2]<=stage[1];
        
        term_i <= mul_i >> 16;
        term_p <= mul_p >> 16;
     end

  
   


   always@(posedge clk_i)
     if(!rst_n_i) begin
        stage[3] <= 0;
     end else begin
        sum <= term_p + term_i;
        
        stage[3] <= stage[2];
     end



   always@(posedge clk_i)
     if(!rst_n_i) begin
        q_valid_o <= 0;
        clip_plus <=0;
        clip_minus <= 0;
        
     end else begin
        if(stage[3])
          begin
             if(sum < -32767) begin
                clip_minus <= 1;
                clip_plus<= 0;
                
                q_o <= -32767;
             end else if(sum > 32767) begin
                clip_minus <= 0;
                clip_plus<= 1;

                q_o <=  32767;
             end  else begin
                clip_minus <= 0;
                clip_plus<= 0;

                q_o <= sum;
             end
             
          end
        
        q_valid_o <= stage[3];
     end
   
     
          
     
   
   
   
   
endmodule
     

 
                        