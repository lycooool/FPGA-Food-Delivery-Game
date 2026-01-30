`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/19 20:20:29
// Design Name: 
// Module Name: kb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module kb(ps2_clk,rst,clk,ps2_data,kbsignal_u,kbsignal_l,kbsignal_r,kbsignal_d,kbsignal_get);
input ps2_clk;
input rst,clk;
input ps2_data;

output reg kbsignal_u;
output reg kbsignal_l;
output reg kbsignal_r;
output reg kbsignal_d;
output reg kbsignal_get;
reg[29:0]counter;

reg[3:0]num;
reg [7:0]temp_data;

always@(negedge ps2_clk or negedge rst)
begin
    if(!rst)begin
             temp_data<=8'b0;
             num<=4'b0;
             end
   else begin
            if(num <= 4'd9) begin
                num <= num + 1'b1;
                case(num)
                4'd0:   ;
                4'd1:   temp_data[0] <= ps2_data;
                4'd2:   temp_data[1] <= ps2_data;
                4'd3:   temp_data[2] <= ps2_data; 
                4'd4:   temp_data[3] <= ps2_data;
                4'd5:   temp_data[4] <= ps2_data;
                4'd6:   temp_data[5] <= ps2_data;
                4'd7:   temp_data[6] <= ps2_data;
                4'd8:   temp_data[7] <= ps2_data;
                4'd9:   ;
                4'd10:  ;
            endcase
            end
            else begin
                num <= 1'b0;
                temp_data <=0;
            end
                
            
        end
 end
 always@*begin

            case(temp_data)
                8'h1d:begin //wasdf
                     kbsignal_get<=0;
                     kbsignal_u<=1;
                     kbsignal_l<=0;
                     kbsignal_r<=0;
                     kbsignal_d<=0;    
                     end
                8'h1c:begin 
                     kbsignal_get<=0;
                     kbsignal_u<=0;
                     kbsignal_l<=1;
                     kbsignal_r<=0;
                     kbsignal_d<=0;   
                     end
                8'h1b:begin 
                     kbsignal_get<=0;
                     kbsignal_u<=0;
                     kbsignal_l<=0;
                     kbsignal_r<=0;
                     kbsignal_d<=1;   
                     end
                8'h23:begin 
                     kbsignal_get<=0;
                     kbsignal_u<=0;
                     kbsignal_l<=0;
                     kbsignal_r<=1;
                     kbsignal_d<=0;     
                     end
                8'h2b:begin 
                     kbsignal_get<=1;
                     kbsignal_u<=0;
                     kbsignal_l<=0;
                     kbsignal_r<=0;
                     kbsignal_d<=0;   
                     end
                default:begin 
                     kbsignal_get<=0;
                     kbsignal_u<=0;
                     kbsignal_l<=0;
                     kbsignal_r<=0;
                     kbsignal_d<=0;   
                     end
                endcase
      end
              

endmodule







