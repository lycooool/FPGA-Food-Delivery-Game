`timescale 1ns / 1ps

module final(ps2_clk, ps2_data, clk, rst, go_u, go_d, go_l, go_r, hsync, vsync, vga_r, vga_g, vga_b, led, get_meal, start,seven_seg,seven_seg2,enable1,enable2,level); 
    input ps2_clk; 
    input ps2_data; 
    input start;
    input clk;
    input rst;
    input go_u, go_d, go_l, go_r;
    input get_meal;
    input level;
    
    output reg[15:0] led;
    output hsync, vsync;
    output [3:0] vga_r, vga_g, vga_b;
    output reg [7:0]seven_seg;
    output reg [7:0]seven_seg2;
    wire kb_signal_u;
    wire kb_signal_l;
    wire kb_signal_r;
    wire kb_signal_d;
    wire kb_signal_get;
    kb kb(.ps2_clk(ps2_clk), .rst(rst), .clk(clk), .ps2_data(ps2_data), .kbsignal_u(kb_signal_u), .kbsignal_l(kb_signal_l), .kbsignal_get(kb_signal_get), .kbsignal_d(kb_signal_d), .kbsignal_r(kb_signal_r));  
     
    wire            pclk;
    wire            valid;
    wire [9:0]      h_cnt,v_cnt;
    
    reg [11:0]      vga_data;  
    
    reg [12:0]      rom_addr;
    
    wire [11:0]     rom_dout1;  
    wire [11:0]     rom_dout2;  
    wire [11:0]     rom_dout3;  
    wire [11:0]     rom_dout4;
    wire [11:0]     rom_dout5;
    wire [11:0]     rom_dout6;
    wire [11:0]     rom_dout7;
    wire [11:0]     rom_dout8;
    wire [11:0]     rom_dout9;
    wire [11:0]     rom_dout10;
    wire [11:0]     rom_dout11;
    wire [11:0]     rom_dout12;
    wire [11:0]     rom_dout13;
    wire [11:0]     rom_dout14;
    wire [11:0]     rom_dout15;
    wire [11:0]     rom_dout16;
    wire [11:0]     rom_dout17;
    
    reg [7:0] block_position;
    reg [7:0] boss_position_tmp;
    reg [7:0] boss_position;
    reg [7:0] boss_bound_position_tmp;
    reg [7:0] boss_bound_position;
    
    reg [19:0] sw_de_counter_r;
    reg [19:0] sw_de_counter_l;
    reg [19:0] sw_de_counter_u;
    reg [19:0] sw_de_counter_d;
    reg go_r_ok, go_l_ok, go_d_ok, go_u_ok;
    
    reg [2:0]meal_1; //1:french 2:cola 3:ice 4:ham
    reg [2:0]meal_2;
    reg [2:0]meal_3;
    reg [2:0]meal_4;
    reg [11:0] meal_rom_out;
    reg [11:0] meal_bound_rom_out;
    
    reg[8:0]number_rom_dout;
    
    reg [19:0] sw_de_counter_get_meal;
    reg [2:0]meal_got;
     
    reg [2:0]client_1; //1:sponge 2:squid 3:patrick 4:plankton
    reg [2:0]client_2;
    reg [2:0]client_3;
    reg [2:0]client_4; 
    reg [11:0] client_rom_out;
    
    reg[19:0]score;
    
  
    assign {vga_r,vga_g,vga_b} = vga_data;
    
    dcm_25M u0 (.clk_in1(clk), .clk_out1(pclk), .resetn(rst));
    SyncGeneration u1( .pclk(pclk), .reset(rst),  .hSync(hsync),  .vSync(vsync),   .dataValid(valid),  .hDataCnt(h_cnt),  .vDataCnt(v_cnt));
    
    french_fries P1 (.clka(clk), .addra(rom_addr), .douta(rom_dout1));
    cola P2(.clka(clk), .addra(rom_addr), .douta(rom_dout2));
    ice_cream P3(.clka(clk), .addra(rom_addr), .douta(rom_dout3));
    hamburger P4(.clka(clk), .addra(rom_addr), .douta(rom_dout4));
    
    sponge_bob P5(.clka(clk), .addra(rom_addr), .douta(rom_dout5));
    squidward P6(.clka(clk), .addra(rom_addr), .douta(rom_dout6));
    patrick_star P7(.clka(clk), .addra(rom_addr), .douta(rom_dout7));
    plankton P8(.clka(clk), .addra(rom_addr), .douta(rom_dout8));
    boss p9(.clka(clk), .addra(rom_addr), .douta(rom_dout9));
    number1 p10(.clka(clk), .addra(rom_addr), .douta(rom_dout17));
    number2 p11(.clka(clk), .addra(rom_addr), .douta(rom_dout16)); 
    number3 p12(.clka(clk), .addra(rom_addr), .douta(rom_dout15));
    number4 p13(.clka(clk), .addra(rom_addr), .douta(rom_dout14));
    number5 p14(.clka(clk), .addra(rom_addr), .douta(rom_dout13)); 
    number6 p15(.clka(clk), .addra(rom_addr), .douta(rom_dout12));  
    number7 p16(.clka(clk), .addra(rom_addr), .douta(rom_dout11));
    number8 p17(.clka(clk), .addra(rom_addr), .douta(rom_dout10));       
    
    parameter orange = 12'hfc0;
    parameter red = 12'hf66;
    parameter blue = 12'h9de;
    parameter green = 12'h2b4;
    parameter white = 12'hfff;
    parameter black = 12'h000;
    
    assign boss_00 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd3) & (h_cnt <= 10'd78))? 1'b1 :1'b0;     
    assign boss_01 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd83) & (h_cnt <= 10'd158))? 1'b1 :1'b0;    
    assign boss_02 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd163) & (h_cnt <= 10'd238))? 1'b1 :1'b0;   
    assign boss_03 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd243) & (h_cnt <= 10'd318))? 1'b1 :1'b0;    
    assign boss_04 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd323) & (h_cnt <= 10'd398))? 1'b1 :1'b0;    
    assign boss_05 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd403) & (h_cnt <= 10'd478))? 1'b1 :1'b0;     
    assign boss_06 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd483) & (h_cnt <= 10'd558))? 1'b1 :1'b0;     
    assign boss_07 = ((v_cnt >= 10'd211) & (v_cnt <= 10'd274) & (h_cnt >= 10'd563) & (h_cnt <= 10'd638))? 1'b1 :1'b0;
    assign boss_10 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd3) & (h_cnt <= 10'd78))? 1'b1 :1'b0;     
    assign boss_11 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd83) & (h_cnt <= 10'd158))? 1'b1 :1'b0;    
    assign boss_12 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd163) & (h_cnt <= 10'd238))? 1'b1 :1'b0;   
    assign boss_13 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd243) & (h_cnt <= 10'd318))? 1'b1 :1'b0;    
    assign boss_14 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd323) & (h_cnt <= 10'd398))? 1'b1 :1'b0;    
    assign boss_15 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd403) & (h_cnt <= 10'd478))? 1'b1 :1'b0;     
    assign boss_16 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd483) & (h_cnt <= 10'd558))? 1'b1 :1'b0;     
    assign boss_17 = ((v_cnt >= 10'd279) & (v_cnt <= 10'd342) & (h_cnt >= 10'd563) & (h_cnt <= 10'd638))? 1'b1 :1'b0; 
    
    assign boss_00_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd1) & (h_cnt <= 10'd80))? 1'b1 :1'b0; 
    assign boss_01_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd81) & (h_cnt <= 10'd160))? 1'b1 :1'b0; 
    assign boss_02_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd161) & (h_cnt <= 10'd240))? 1'b1 :1'b0; 
    assign boss_03_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd241) & (h_cnt <= 10'd320))? 1'b1 :1'b0; 
    assign boss_04_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd321) & (h_cnt <= 10'd400))? 1'b1 :1'b0; 
    assign boss_05_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd401) & (h_cnt <= 10'd480))? 1'b1 :1'b0; 
    assign boss_06_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd481) & (h_cnt <= 10'd560))? 1'b1 :1'b0; 
    assign boss_07_bound = ((v_cnt >= 10'd209) & (v_cnt <= 10'd276) & (h_cnt >= 10'd561) & (h_cnt <= 10'd640))? 1'b1 :1'b0; 
    assign boss_10_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd1) & (h_cnt <= 10'd80))? 1'b1 :1'b0; 
    assign boss_11_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd81) & (h_cnt <= 10'd160))? 1'b1 :1'b0; 
    assign boss_12_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd161) & (h_cnt <= 10'd240))? 1'b1 :1'b0; 
    assign boss_13_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd241) & (h_cnt <= 10'd320))? 1'b1 :1'b0; 
    assign boss_14_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd321) & (h_cnt <= 10'd400))? 1'b1 :1'b0; 
    assign boss_15_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd401) & (h_cnt <= 10'd480))? 1'b1 :1'b0; 
    assign boss_16_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd481) & (h_cnt <= 10'd560))? 1'b1 :1'b0; 
    assign boss_17_bound = ((v_cnt >= 10'd277) & (v_cnt <= 10'd344) & (h_cnt >= 10'd561) & (h_cnt <= 10'd640))? 1'b1 :1'b0;
        
    assign client_backline = ((v_cnt >= 10'd1) & (v_cnt <= 10'd140) & (h_cnt >= 10'd1) & (h_cnt <= 10'd640))? 1'b1 :1'b0; 
    assign client_back_1 = ((v_cnt >= 10'd2) & (v_cnt <= 10'd139) & (h_cnt >= 10'd2) & (h_cnt <= 10'd159))? 1'b1 :1'b0; 
    assign client_back_2 = ((v_cnt >= 10'd2) & (v_cnt <= 10'd139) & (h_cnt >= 10'd162) & (h_cnt <= 10'd319))? 1'b1 :1'b0; 
    assign client_back_3 = ((v_cnt >= 10'd2) & (v_cnt <= 10'd139) & (h_cnt >= 10'd322) & (h_cnt <= 10'd479))? 1'b1 :1'b0; 
    assign client_back_4 = ((v_cnt >= 10'd2) & (v_cnt <= 10'd139) & (h_cnt >= 10'd482) & (h_cnt <= 10'd639))? 1'b1 :1'b0; 
    assign client_1_position = ((v_cnt >= 10'd31) & (v_cnt <= 10'd110) & (h_cnt >= 10'd41) & (h_cnt <= 10'd120))? 1'b1 :1'b0; 
    assign client_2_position = ((v_cnt >= 10'd31) & (v_cnt <= 10'd110) & (h_cnt >= 10'd201) & (h_cnt <= 10'd280))? 1'b1 :1'b0; 
    assign client_3_position = ((v_cnt >= 10'd31) & (v_cnt <= 10'd110) & (h_cnt >= 10'd361) & (h_cnt <= 10'd440))? 1'b1 :1'b0; 
    assign client_4_position = ((v_cnt >= 10'd31) & (v_cnt <= 10'd110) & (h_cnt >= 10'd521) & (h_cnt <= 10'd600))? 1'b1 :1'b0;  
    assign number_1_position = ((v_cnt >= 10'd11) & (v_cnt <= 10'd30) & (h_cnt >= 10'd341) & (h_cnt <= 10'd360))? 1'b1 :1'b0;
    assign number_2_position = ((v_cnt >= 10'd11) & (v_cnt <= 10'd30) & (h_cnt >= 10'd501) & (h_cnt <= 10'd520))? 1'b1 :1'b0;  
    assign dish_1_bound = ((v_cnt >= 10'd345) & (v_cnt <= 10'd480) & (h_cnt >= 10'd1) & (h_cnt <= 10'd160))? 1'b1 :1'b0;                    
    assign dish_1_white = ((v_cnt >= 10'd349) & (v_cnt <= 10'd476) & (h_cnt >= 10'd5) & (h_cnt <= 10'd156))? 1'b1 :1'b0;
    assign dish_1_food = ((v_cnt >= 10'd373) & (v_cnt <= 10'd452) & (h_cnt >= 10'd41) & (h_cnt <= 10'd120))? 1'b1 :1'b0;
    assign dish_2_bound = ((v_cnt >= 10'd345) & (v_cnt <= 10'd480) & (h_cnt >= 10'd161) & (h_cnt <= 10'd320))? 1'b1 :1'b0;                    
    assign dish_2_white = ((v_cnt >= 10'd349) & (v_cnt <= 10'd476) & (h_cnt >= 10'd165) & (h_cnt <= 10'd316))? 1'b1 :1'b0;
    assign dish_2_food = ((v_cnt >= 10'd373) & (v_cnt <= 10'd452) & (h_cnt >= 10'd201) & (h_cnt <= 10'd280))? 1'b1 :1'b0;
    assign dish_3_bound = ((v_cnt >= 10'd345) & (v_cnt <= 10'd480) & (h_cnt >= 10'd321) & (h_cnt <= 10'd480))? 1'b1 :1'b0;                    
    assign dish_3_white = ((v_cnt >= 10'd349) & (v_cnt <= 10'd476) & (h_cnt >= 10'd325) & (h_cnt <= 10'd476))? 1'b1 :1'b0;
    assign dish_3_food = ((v_cnt >= 10'd373) & (v_cnt <= 10'd452) & (h_cnt >= 10'd361) & (h_cnt <= 10'd440))? 1'b1 :1'b0;
    assign dish_4_bound = ((v_cnt >= 10'd345) & (v_cnt <= 10'd480) & (h_cnt >= 10'd481) & (h_cnt <= 10'd640))? 1'b1 :1'b0;                    
    assign dish_4_white = ((v_cnt >= 10'd349) & (v_cnt <= 10'd476) & (h_cnt >= 10'd485) & (h_cnt <= 10'd636))? 1'b1 :1'b0;
    assign dish_4_food = ((v_cnt >= 10'd373) & (v_cnt <= 10'd452) & (h_cnt >= 10'd521) & (h_cnt <= 10'd600))? 1'b1 :1'b0;
    
    parameter stateRST = 1, stateNotget = 2, stateGet = 3, stateChange = 4;
    
    reg [3:0]CS;
    reg [3:0]NS;
                     
    always @(posedge pclk or negedge rst) begin
        if (!rst)begin
            vga_data <= 12'b0;
            end
        else begin            
            if((v_cnt >= 10'd1) & (v_cnt <= 10'd480) & (h_cnt >= 10'd1) & (h_cnt <= 10'd640))begin
                if (dish_1_food || dish_2_food || dish_3_food || dish_4_food) vga_data <= meal_rom_out;               
                else if (dish_1_white || dish_2_white || dish_3_white || dish_4_white) vga_data <= white;            
                else if( dish_1_bound || dish_2_bound || dish_3_bound || dish_4_bound) vga_data <= meal_bound_rom_out; 
                else if(number_1_position||number_2_position)begin if(!level) vga_data <= white; else   vga_data <= number_rom_dout;  end                                   
                else if( client_1_position ||  client_2_position ||  client_3_position ||  client_4_position)vga_data <= client_rom_out;
                else if (client_back_1 || client_back_2 || client_back_3 || client_back_4)vga_data <= white; 
                else if( client_backline) vga_data <= black;                 
                else if (boss_00 || boss_01 || boss_02 || boss_03 || boss_04 || boss_05 || boss_06 || boss_07 || 
                         boss_10 || boss_11 || boss_12 || boss_13 || boss_14 || boss_15 || boss_16 || boss_17 ) begin
                    if(block_position == boss_position)
                        vga_data <= rom_dout9; 
                    else vga_data <= white;
                    end
                else if (boss_00_bound || boss_01_bound || boss_02_bound || boss_03_bound || boss_04_bound || boss_05_bound || boss_06_bound || boss_07_bound || 
                         boss_10_bound || boss_11_bound || boss_12_bound || boss_13_bound || boss_14_bound || boss_15_bound || boss_16_bound || boss_17_bound ) begin
                    if(block_position == boss_bound_position)begin
                        if(!level)vga_data <= black; //level1
                        else begin
                            if(CS==stateGet)begin
                                if(meal_got==1)vga_data <= green;
                                if(meal_got==3)vga_data <= red;
                                if(meal_got==2)vga_data <= orange;
                                if(meal_got==4)vga_data <= blue;
                                end
                            else vga_data <= black;
                        end
                       end
                    else vga_data <= black;
                    end
                   
                
                else vga_data <=12'h000;
                end                
            else begin
                vga_data <= 12'h000;
                boss_position<= boss_position_tmp;
                boss_bound_position <= boss_bound_position_tmp;
                end 
            end
        end
        
     reg [2:0]ncount;
     reg [2:0]ncount1;
     reg nc;
     reg nc1;
    always @*begin
        if(client_1_position)begin case(client_1) 1: client_rom_out = rom_dout5; 2: client_rom_out = rom_dout6; 3: client_rom_out = rom_dout7; 4: client_rom_out = rom_dout8; default: client_rom_out = white; endcase end 
        else if(client_2_position)begin case(client_2) 1: client_rom_out = rom_dout5; 2: client_rom_out = rom_dout6; 3: client_rom_out = rom_dout7; 4: client_rom_out = rom_dout8; default: client_rom_out = white; endcase end 
        else if(client_3_position)begin case(client_3) 1: client_rom_out = rom_dout5; 2: client_rom_out = rom_dout6; 3: client_rom_out = rom_dout7; 4: client_rom_out = rom_dout8; default: client_rom_out = white; endcase end 
        else if(client_4_position)begin case(client_4) 1: client_rom_out = rom_dout5; 2: client_rom_out = rom_dout6; 3: client_rom_out = rom_dout7; 4: client_rom_out = rom_dout8; default: client_rom_out = white; endcase end        
        end  
        
    always@*begin
            if(number_1_position)begin case(ncount) 0:number_rom_dout = rom_dout10; 1:number_rom_dout=rom_dout11;2:number_rom_dout=rom_dout12;3:number_rom_dout=rom_dout13;4:number_rom_dout=rom_dout14;5:number_rom_dout=rom_dout15;6:number_rom_dout=rom_dout16;7:number_rom_dout=rom_dout17; endcase end
           else if(number_2_position)begin case(ncount) 0:number_rom_dout=rom_dout10; 1:number_rom_dout=rom_dout11;2:number_rom_dout=rom_dout12;3:number_rom_dout=rom_dout13;4:number_rom_dout=rom_dout14;5:number_rom_dout=rom_dout15;6:number_rom_dout=rom_dout16;7:number_rom_dout=rom_dout17;endcase end
    end    
        
    reg[27:0]tmp;
    reg[27:0]tmp2;
    reg count1hz;
    reg [1:0]counter1hz;
    always@(posedge clk or negedge rst)
            begin
                if(!rst)
                   begin
                        ncount<=0;
                        ncount1<=0;
                        tmp<=0;
                        tmp2<=0;
                        count1hz<=0;
                   end
                else 
                    begin
                        if(tmp>=28'd100000000)
                            begin
                                tmp<=28'd0;
                                count1hz<=~count1hz;
                             end
                         else    tmp<=tmp+1;
                         if( tmp2>=28'd100000000)
                            begin
                                tmp2<=28'd0;
                                if(level)begin
                                
                                
                                if(nc==0)ncount<=ncount+1;
                                else  ncount<=0;
                                if(nc1==0)ncount1<=ncount1+1;
                                else  ncount1<=0;
                                end
                                else begin ncount<=ncount; ncount1<=ncount1; end
                             end
                        else tmp2<=tmp2+1;
                            
                            
                    end
            end
            
    always@(posedge count1hz or negedge rst)
        begin
            if(!rst) counter1hz<=0;
            else counter1hz<=counter1hz+1;
        end
            
    always @* begin  //////////////////////////////choose meal
        if (!rst)begin
            meal_1 = 3'd0;
            meal_2 = 3'd0;
            meal_3 = 3'd0;
            meal_4 = 3'd0;
            end   
        else begin
            if(!level)begin
            meal_1 = 3'd1;
            meal_2 = 3'd3;
            meal_3 = 3'd2;
            meal_4 = 3'd4; 
            end 
            else begin
                case(counter1hz)
                  2'd0:begin  meal_1 = 3'd1; meal_2 = 3'd3; meal_3 = 3'd2; meal_4 = 3'd4;end
                  2'd1:begin  meal_1 = 3'd4; meal_2 = 3'd1; meal_3 = 3'd3; meal_4 = 3'd2;end
                  2'd2:begin  meal_1 = 3'd2; meal_2 = 3'd4; meal_3 = 3'd1; meal_4 = 3'd3;end
                  2'd3:begin  meal_1 = 3'd3; meal_2 = 3'd2; meal_3 = 3'd4; meal_4 = 3'd1;end
                    endcase 
                 end
            end 
        end 
    always @*begin
        if(dish_1_food)begin case(meal_1) 1:meal_rom_out = rom_dout1; 2:meal_rom_out = rom_dout2; 3:meal_rom_out = rom_dout3; 4:meal_rom_out = rom_dout4; default: meal_rom_out = white;  endcase end
        else if(dish_2_food)begin case(meal_2) 1:meal_rom_out = rom_dout1; 2:meal_rom_out = rom_dout2; 3:meal_rom_out = rom_dout3; 4:meal_rom_out = rom_dout4; default: meal_rom_out = white;  endcase end
        else if(dish_3_food)begin case(meal_3) 1:meal_rom_out = rom_dout1; 2:meal_rom_out = rom_dout2; 3:meal_rom_out = rom_dout3; 4:meal_rom_out = rom_dout4; default: meal_rom_out = white;  endcase end
        else if(dish_4_food)begin case(meal_4) 1:meal_rom_out = rom_dout1; 2:meal_rom_out = rom_dout2; 3:meal_rom_out = rom_dout3; 4:meal_rom_out = rom_dout4; default: meal_rom_out = white;  endcase end
        if(dish_1_bound)begin case(meal_1) 1: meal_bound_rom_out = green; 2: meal_bound_rom_out = orange; 3: meal_bound_rom_out = red; 4: meal_bound_rom_out = blue; default: meal_bound_rom_out = white; endcase end 
        else if(dish_2_bound)begin case(meal_2) 1: meal_bound_rom_out = green; 2: meal_bound_rom_out = orange; 3: meal_bound_rom_out = red; 4: meal_bound_rom_out = blue; default: meal_bound_rom_out = white; endcase end
        else if(dish_3_bound)begin case(meal_3) 1: meal_bound_rom_out = green; 2: meal_bound_rom_out = orange; 3: meal_bound_rom_out = red; 4: meal_bound_rom_out = blue; default: meal_bound_rom_out = white; endcase end 
        else if(dish_4_bound)begin case(meal_4) 1: meal_bound_rom_out = green; 2: meal_bound_rom_out = orange; 3: meal_bound_rom_out = red; 4: meal_bound_rom_out = blue; default: meal_bound_rom_out = white; endcase end  
        end 
        
    //////////////////////////////////////set rom_addr/////////////////////////////////////////////////////////
    always @* begin
        if (!rst) begin
            rom_addr = 1'b0;
            end
        else begin            
            if((v_cnt >= 10'd1) & (v_cnt <= 10'd480) & (h_cnt >= 10'd1) & (h_cnt <= 10'd640))begin
                if(dish_1_food) rom_addr = ((v_cnt - 10'd373) * 80) + (h_cnt - 10'd41);
                else if(dish_2_food) rom_addr = ((v_cnt - 10'd373) * 80) + (h_cnt - 10'd201);
                else if(dish_3_food) rom_addr = ((v_cnt - 10'd373) * 80) + (h_cnt - 10'd361);
                else if(dish_4_food) rom_addr = ((v_cnt - 10'd373) * 80) + (h_cnt - 10'd521);
                else if( client_1_position) rom_addr = ((v_cnt - 10'd31) * 80) + (h_cnt - 10'd41);
                else if( client_2_position) rom_addr = ((v_cnt - 10'd31) * 80) + (h_cnt - 10'd201);
                else if( client_3_position) rom_addr = ((v_cnt - 10'd31) * 80) + (h_cnt - 10'd361);
                else if( client_4_position) rom_addr = ((v_cnt - 10'd31) * 80) + (h_cnt - 10'd521);
                
                else if(number_1_position)  rom_addr = ((v_cnt - 10'd11) * 20) + (h_cnt - 10'd341);
                else if(number_2_position)  rom_addr = ((v_cnt - 10'd11) * 20) + (h_cnt - 10'd501);
                
                else if( boss_00_bound) begin if( boss_00) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd3); else rom_addr = rom_addr; block_position = 7'd00; end
                else if( boss_01_bound) begin if( boss_01) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd83); else rom_addr = rom_addr; block_position = 7'd01; end
                else if( boss_02_bound) begin if( boss_02) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd163); else rom_addr = rom_addr; block_position = 7'd02; end
                else if( boss_03_bound) begin if( boss_03) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd243); else rom_addr = rom_addr; block_position = 7'd03; end
                else if( boss_04_bound) begin if( boss_04) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd323); else rom_addr = rom_addr; block_position = 7'd04; end
                else if( boss_05_bound) begin if( boss_05) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd403); else rom_addr = rom_addr; block_position = 7'd05; end
                else if( boss_06_bound) begin if( boss_06) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd483); else rom_addr = rom_addr; block_position = 7'd06; end
                else if( boss_07_bound) begin if( boss_07) rom_addr = ((v_cnt - 10'd211) * 76) + (h_cnt - 10'd563); else rom_addr = rom_addr; block_position = 7'd07; end
                else if( boss_10_bound) begin if( boss_10) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd3); else rom_addr = rom_addr; block_position = 7'd10; end
                else if( boss_11_bound) begin if( boss_11) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd83); else rom_addr = rom_addr; block_position = 7'd11; end
                else if( boss_12_bound) begin if( boss_12) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd163); else rom_addr = rom_addr; block_position = 7'd12; end
                else if( boss_13_bound) begin if( boss_13) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd243); else rom_addr = rom_addr; block_position = 7'd13; end
                else if( boss_14_bound) begin if( boss_14) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd323); else rom_addr = rom_addr; block_position = 7'd14; end
                else if( boss_15_bound) begin if( boss_15) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd403); else rom_addr = rom_addr; block_position = 7'd15; end
                else if( boss_16_bound) begin if( boss_16) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd483); else rom_addr = rom_addr; block_position = 7'd16; end
                else if( boss_17_bound) begin if( boss_17) rom_addr = ((v_cnt - 10'd279) * 76) + (h_cnt - 10'd563); else rom_addr = rom_addr; block_position = 7'd17; end
                else  rom_addr = rom_addr;
       
                end
            else begin
                rom_addr = rom_addr;
                end
            end
        end
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    always @* begin
        case(boss_position_tmp)
            10'd00:begin go_r_ok = 1'd1; go_l_ok = 1'd0; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd01:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd02:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd03:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd04:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd05:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd06:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd07:begin go_r_ok = 1'd0; go_l_ok = 1'd1; go_d_ok = 1'd1; go_u_ok = 1'd0; end
            10'd10:begin go_r_ok = 1'd1; go_l_ok = 1'd0; go_d_ok = 1'd0; go_u_ok = 1'd1; end
            10'd11:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd0; go_u_ok = 1'd1; end
            10'd12:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd0; go_u_ok = 1'd1; end
            10'd13:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd0; go_u_ok = 1'd1; end
            10'd14:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd0; go_u_ok = 1'd1; end
            10'd15:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd0; go_u_ok = 1'd1; end
            10'd16:begin go_r_ok = 1'd1; go_l_ok = 1'd1; go_d_ok = 1'd0; go_u_ok = 1'd1; end
            10'd17:begin go_r_ok = 1'd0; go_l_ok = 1'd1; go_d_ok = 1'd0; go_u_ok = 1'd1; end               
            endcase     
        end
    parameter w = 4'b1111, a = 4'b1110, s = 4'b1100, d = 4'b1000, f = 4'b0010, none = 4'b0000;
    reg [29:0]kb_counter_r;
    reg [29:0]kb_counter_l;
    reg [29:0]kb_counter_u;
    reg [29:0]kb_counter_d;
    
    parameter kb_de = 30000000;
    always @(posedge clk or posedge rst) begin
        if (!rst)begin          
            sw_de_counter_r <= 1'd0;   
            sw_de_counter_l <= 1'd0; 
            sw_de_counter_u <= 1'd0; 
            sw_de_counter_d <= 1'd0;  
            kb_counter_r <= 1'd0;   
            kb_counter_l <= 1'd0; 
            kb_counter_u <= 1'd0; 
            kb_counter_d <= 1'd0; 
            end      
        else begin
        ///
            if(CS != stateRST)begin
                if(!level )begin
                    if(go_r == 1 && sw_de_counter_r <= 40'd400000) sw_de_counter_r <=  sw_de_counter_r + 1'b1;
                    else if (go_r == 0 && sw_de_counter_r > 40'd400000 )begin
                        if(go_r_ok==1)begin
                            boss_position_tmp <= boss_position_tmp + 10'd1;
                            boss_bound_position_tmp <= boss_bound_position_tmp + 10'd1;
                            end
                        else begin
                            boss_position_tmp <= boss_position_tmp;
                            boss_bound_position_tmp <= boss_bound_position_tmp;                  
                            end
                        sw_de_counter_r <=  1'b0;
                        end 
                    if(go_l == 1 && sw_de_counter_l <= 40'd400000) sw_de_counter_l <=  sw_de_counter_l + 1'b1;
                    else if (go_l == 0 && sw_de_counter_l > 40'd400000 )begin
                        if(go_l_ok==1)begin
                            boss_position_tmp <= boss_position_tmp - 10'd1;
                            boss_bound_position_tmp <= boss_bound_position_tmp - 10'd1;
                            end
                        else begin
                            boss_position_tmp <= boss_position_tmp;
                            boss_bound_position_tmp <= boss_bound_position_tmp;                    
                            end
                        sw_de_counter_l <=  1'b0;
                        end   
                    if(go_u == 1 && sw_de_counter_u <= 40'd400000) sw_de_counter_u <=  sw_de_counter_u + 1'b1;
                    else if (go_u == 0 && sw_de_counter_u > 40'd400000)begin
                        if(go_u_ok==1)begin
                            boss_position_tmp <= boss_position_tmp - 10'd10;
                            boss_bound_position_tmp <= boss_bound_position_tmp - 10'd10;
                            end
                        else begin
                            boss_position_tmp <= boss_position_tmp;
                            boss_bound_position_tmp <= boss_bound_position_tmp;                   
                            end
                        sw_de_counter_u <=  1'b0;
                        end   
                    if(go_d == 1 && sw_de_counter_d <= 40'd400000) sw_de_counter_d <=  sw_de_counter_d + 1'b1;
                    else if (go_d == 0 && sw_de_counter_d > 40'd400000)begin
                        if(go_d_ok==1)begin
                            boss_position_tmp <= boss_position_tmp + 10'd10;
                            boss_bound_position_tmp <= boss_bound_position_tmp + 10'd10;
                            end
                        else begin
                            boss_position_tmp <= boss_position_tmp;
                            boss_bound_position_tmp <= boss_bound_position_tmp;                   
                            end
                        sw_de_counter_d <=  1'b0;
                        end
                    end 
                else begin
                    if(kb_signal_r == 1&& kb_counter_r == 0 && go_r_ok ==1)begin boss_position_tmp <= boss_position_tmp + 10'd1;boss_bound_position_tmp <= boss_bound_position_tmp + 10'd1;kb_counter_r <= kb_counter_r+1;end 
                    else if(kb_counter_r> 0 && kb_counter_r<=kb_de)kb_counter_r <= kb_counter_r+1;
                    else if (kb_counter_r>kb_de)kb_counter_r <= 0;
                    
                    else if(kb_signal_l == 1&& kb_counter_l == 0 && go_l_ok ==1)begin boss_position_tmp <= boss_position_tmp - 10'd1;boss_bound_position_tmp <= boss_bound_position_tmp - 10'd1;kb_counter_l <= kb_counter_l+1;end 
                    else if(kb_counter_l> 0 && kb_counter_l<=kb_de)kb_counter_l <= kb_counter_l+1;
                    else if (kb_counter_l>kb_de)kb_counter_l <= 0;
                    
                    else if(kb_signal_u == 1&& kb_counter_u == 0 && go_u_ok ==1)begin boss_position_tmp <= boss_position_tmp - 10'd10;boss_bound_position_tmp <= boss_bound_position_tmp - 10'd10;kb_counter_u <= kb_counter_u+1;end 
                    else if(kb_counter_u> 0 && kb_counter_u<=kb_de)kb_counter_u <= kb_counter_u+1;
                    else if (kb_counter_u>kb_de)kb_counter_u <= 0;
                    
                    else if(kb_signal_d == 1&& kb_counter_d == 0 && go_d_ok ==1)begin boss_position_tmp <= boss_position_tmp + 10'd10;boss_bound_position_tmp <= boss_bound_position_tmp + 10'd10;kb_counter_d <= kb_counter_d+1;end 
                    else if(kb_counter_d> 0 && kb_counter_d<=kb_de)kb_counter_d <= kb_counter_d+1;
                    else if (kb_counter_d>kb_de)kb_counter_d <= 0;
                    else boss_bound_position_tmp <= boss_bound_position_tmp;

                    
                    
                    end 
                end 
            else begin
                boss_position_tmp <= 10'd00; 
                boss_bound_position_tmp <= 10'd00;                                      
                end
            end           
        end
        
   
    reg client_3_got;
    reg client_4_got; 
    
    
    reg sponge_send;
    reg squid_send;
    reg patrick_send;
    reg plankton_send;
    reg [4:0]client_num;
    
    reg [20:0]kb_get_counter;
    reg[29:0]sec_counter;
    reg sec;
    reg change_ok;
    reg wrong_meal;
    
    reg[29:0]kb_counter_get;
    always @(posedge clk or posedge rst) begin
        if (!rst)begin          
            sw_de_counter_get_meal <= 0;  
            kb_get_counter <= 0;
            meal_got <= 0; 
            client_num <= 4;
            sponge_send <= 0;
            squid_send <= 0;
            patrick_send <= 0;
            plankton_send <= 0;
            score<=0;
            wrong_meal<=0;
            end      
        else begin
        

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////   
            if(CS == stateNotget)begin
            if(!level )begin
                if(get_meal == 1 && sw_de_counter_get_meal <= 400000) sw_de_counter_get_meal <=  sw_de_counter_get_meal + 1'b1;
                else if (get_meal == 0 && sw_de_counter_get_meal  > 400000 )begin
                        if(boss_position == 10 || boss_position == 11 || boss_position == 12 || boss_position == 13 || boss_position == 14 || boss_position == 15 || boss_position == 16 || boss_position == 17 )begin                        
                            if(boss_position == 10 || boss_position == 11) meal_got <= 1;
                            else if (boss_position == 12 || boss_position == 13) meal_got <= 3;
                            else if (boss_position == 14 || boss_position == 15) meal_got <= 2;
                            else if (boss_position == 16 || boss_position == 17) meal_got <= 4;                      
                            else   meal_got <= 0; 
                            end 
                            sw_de_counter_get_meal <=  0;
                            
                    end 
                wrong_meal<=0;      
                end


            else begin

             if(kb_signal_get == 1)begin 
                case(counter1hz)
                                         2'd0:begin        if(boss_position == 10 || boss_position == 11) meal_got <= 1; 
                                                         else if (boss_position == 12 || boss_position == 13) meal_got <= 3;
                                                         else if (boss_position == 14 || boss_position == 15) meal_got <= 2;
                                                         else if (boss_position == 16 || boss_position == 17) meal_got <= 4; 
                                                         else meal_got <= 0;end
                                         2'd1:begin if(boss_position == 10 || boss_position == 11) meal_got <= 4;
                                                         else if (boss_position == 12 || boss_position == 13) meal_got <= 1;
                                                         else if (boss_position == 14 || boss_position == 15) meal_got <= 3;
                                                         else if (boss_position == 16 || boss_position == 17) meal_got <= 2; 
                                                         else meal_got <= 0;end
                                          2'd2:begin  if(boss_position == 10 || boss_position == 11) meal_got <= 2;
                                                         else if (boss_position == 12 || boss_position == 13) meal_got <= 4;
                                                         else if (boss_position == 14 || boss_position == 15) meal_got <= 1;
                                                         else if (boss_position == 16 || boss_position == 17) meal_got <= 3; 
                                                         else meal_got <= 0;end
                                          2'd3:begin  if(boss_position == 10 || boss_position == 11) meal_got <= 3;
                                                         else if (boss_position == 12 || boss_position == 13) meal_got <= 2;
                                                         else if (boss_position == 14 || boss_position == 15) meal_got <= 4;
                                                         else if (boss_position == 16 || boss_position == 17) meal_got <= 1; 
                                                         else meal_got <= 0;end
                                          endcase 
                          
                end                              
            end
                 
                 ///////////////
                    
                    end

                else if(CS == stateGet)begin
                //////////////////////////////
                    if(!level)begin
                        if(get_meal == 1 && sw_de_counter_get_meal <= 40'd400000) sw_de_counter_get_meal <=  sw_de_counter_get_meal + 1'b1;
                        else if (get_meal == 0 && sw_de_counter_get_meal  > 40'd400000 )begin
                            if(boss_position == 04 || boss_position == 05 || boss_position == 06 || boss_position == 07 )begin
                                if(boss_position == 04 || boss_position == 05) begin
                                    if (client_3 == meal_got)begin
                                        score<=score+20'd200;
                                        if(client_3 == 1)  sponge_send <= 1;                                
                                        else if (client_3 == 2)  squid_send <= 1; 
                                        else if (client_3 == 3)  patrick_send <= 1; 
                                        else if (client_3 == 4)  plankton_send <= 1;   
                                        if(client_num > 0)client_num <= client_num - 1; 
                                        else   client_num <= 0;                                 
                                        end
                                     else begin if(score>0)score<=score-20'd100; wrong_meal<=1;end
                                    meal_got <= 0;
                                    end   
                                else if(boss_position == 06 || boss_position == 07) begin
                                    if (client_4 == meal_got)begin
                                        score<=score+20'd200;
                                        if(client_4 == 1)  sponge_send <= 1;                                
                                        else if (client_4 == 2)  squid_send <= 1; 
                                        else if (client_4 == 3)  patrick_send <= 1; 
                                        else if (client_4 == 4)  plankton_send <= 1;  
                                        if(client_num > 0)client_num <= client_num - 1;
                                        else client_num <= 0;   
                                        end
                                    else begin if(score>0)score<=score-20'd100; wrong_meal<=1;end
                                    meal_got <= 0;
                                    end
                                else  begin meal_got <= meal_got; client_num  <= client_num;wrong_meal <=0;end
                                end               
                                sw_de_counter_get_meal <=  1'b0;
                            end
                        end

                    //////////////////////////
                    if(level)begin
                        if(kb_signal_get == 1)begin 
                            if(boss_position == 04 || boss_position == 05 || boss_position == 06 || boss_position == 07 )begin
                                if(boss_position == 04 || boss_position == 05) begin
                                    if (client_3 == meal_got)begin
                                        score<=score+20'd250;
                                        wrong_meal <=0;
                                        if(client_3 == 1)  sponge_send <= 1;                                
                                        else if (client_3 == 2)  squid_send <= 1; 
                                        else if (client_3 == 3)  patrick_send <= 1; 
                                        else if (client_3 == 4)  plankton_send <= 1;   
                                        if(client_num > 0)client_num <= client_num - 1; 
                                        else   client_num <= client_num;                                 
                                        end
                                     else begin if(score>0)score<=score-20'd50; wrong_meal<=1;end
                                    meal_got <= 0;
                                    end   
                                else if(boss_position == 06 || boss_position == 07) begin
                                    if (client_4 == meal_got)begin
                                        score<=score+20'd250;
                                        wrong_meal <=0;
                                        if(client_4 == 1)  sponge_send <= 1;                                
                                        else if (client_4 == 2)  squid_send <= 1; 
                                        else if (client_4 == 3)  patrick_send <= 1; 
                                        else if (client_4 == 4)  plankton_send <= 1;  
                                        if(client_num > 0)client_num <= client_num - 1;
                                        else client_num <= client_num;   
                                        end
                                    else begin if(score>0)score<=score-20'd50; wrong_meal<=1;end
                                    meal_got <= 0;
                                    end
                                else  begin meal_got <= meal_got; client_num  <= client_num;wrong_meal <=0;end
                                end 
                                end 
    
                            end


                    /*if(level)begin
                        if(kb_signal_get == 1 && kb_counter_get == 0)begin 
                            kb_counter_get <=  kb_counter_get + 1'b1;
                            if(boss_position == 04 || boss_position == 05 || boss_position == 06 || boss_position == 07 )begin
                                if(boss_position == 04 || boss_position == 05) begin
                                    if (client_3 == meal_got)begin
                                        score<=score+20'd200;
                                        if(client_3 == 1)  sponge_send <= 1;                                
                                        else if (client_3 == 2)  squid_send <= 1; 
                                        else if (client_3 == 3)  patrick_send <= 1; 
                                        else if (client_3 == 4)  plankton_send <= 1;   
                                        if(client_num > 0)client_num <= client_num - 1; 
                                        else   client_num <= client_num;                                 
                                        end
                                     else begin if(score>0)score<=score-20'd100; wrong_meal<=1;end
                                    meal_got <= 0;
                                    end   
                                else if(boss_position == 06 || boss_position == 07) begin
                                    if (client_4 == meal_got)begin
                                        score<=score+20'd200;
                                        if(client_4 == 1)  sponge_send <= 1;                                
                                        else if (client_4 == 2)  squid_send <= 1; 
                                        else if (client_4 == 3)  patrick_send <= 1; 
                                        else if (client_4 == 4)  plankton_send <= 1;  
                                        if(client_num > 0)client_num <= client_num - 1;
                                        else client_num <= client_num;   
                                        end
                                    else begin if(score>0)score<=score-20'd100; wrong_meal<=1;end
                                    meal_got <= 0;
                                    end
                                else  meal_got <= meal_got; 
                                end 
                                end  
                            end
                        else if(kb_counter_get> 0 && kb_counter_get<=kb_de)kb_counter_get <= kb_counter_get+1;
                        else if (kb_counter_get>kb_de)kb_counter_get <= 0;*/
                    ///////test level 2 send /////////////////////////////
                    end
                end
            
            end             
           
    
    //1:sponge 2:squid 3:patrick 4:plankton
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            client_1 = 0;
            client_2 = 0;
            client_3 = 0;
            client_4 = 0;
            change_ok <= 0;
            sec_counter <= 0;
            sec <= 0;
            end
        else begin
            ///////////////////////////////////////////////////////////////////
            if(CS ==stateRST)begin
                if(!level||level)begin
                    client_1 = 0;
                    client_2 = 0;
                    client_3 = 0;
                    client_4 = 0;
                    end
                end
            ///////////////////////////////////////////////////////////////////
            else if (CS == stateNotget)begin
                if(!level||level)begin
                client_1 = 0;
                client_2 = 0;
                change_ok <= 0;
                if(client_num == 4)begin
                           
                                client_3 = 1;
                                client_4 = 2;
                                nc=0;
                                nc1=0;
                               
                           
                    end
                else if (client_num == 3)begin
                                
                                if (sponge_send == 1 && squid_send == 0 && patrick_send == 0 && plankton_send == 0)begin
                                    client_3 = 2;
                                    client_4 = 3;
                                    nc=0;
                                        nc1=0;
                                    end
                                else if (sponge_send == 0 && squid_send == 1 && patrick_send == 0 && plankton_send == 0)begin
                                    client_3 = 1;
                                    client_4 = 3;
                                    nc=0;
                                        nc1=0;
                                    end
                             
                       end
                else if (client_num == 2)begin
                                 
                                    if (sponge_send == 1 && squid_send == 1 && patrick_send == 0 && plankton_send == 0)begin
                                        client_3 = 3;
                                        client_4 = 4;
                                        nc=0;
                                        nc1=0;
                                        end
                                    else if (sponge_send == 1 && squid_send == 0 && patrick_send == 1 && plankton_send == 0)begin
                                        client_3 = 2;
                                        client_4 = 4;
                                        nc=0;
                                        nc1=0;
                                        end
                                    else if (sponge_send == 0 && squid_send == 1 && patrick_send == 1 && plankton_send == 0)begin
                                        client_3 = 1;
                                        client_4 = 4;
                                        nc=0;
                                        nc1=0;
                                        end
                                   
                             end
                else if (client_num == 1)begin
                       
                            if (sponge_send == 0 && squid_send == 1 && patrick_send == 1 && plankton_send == 1)begin
                                client_3 = 1;
                                client_4 = 0;
                                nc=0;
                                end
                            else if (sponge_send == 1 && squid_send == 0 && patrick_send == 1 && plankton_send == 1)begin
                                client_3 = 2;
                                client_4 = 0;
                                nc=0;
                                end
                            else if (sponge_send == 1 && squid_send == 1 && patrick_send == 0 && plankton_send == 1)begin
                                client_3 = 3;
                                client_4 = 0;
                                nc=0;
                                end
                            else if (sponge_send == 1 && squid_send == 1 && patrick_send == 1 && plankton_send == 0)begin
                                client_3 = 4;
                                client_4 = 0;
                                nc=0;
                                end
                       
                    end
                else if (client_num == 0)begin
                    client_3 = 0;
                    client_4 = 0;
                    end

                    end
                
                end
            ///////////////////////////////////////////////////////////////////
            else if(CS == stateChange)begin
            
                if(sec_counter < 200000000) sec_counter <= sec_counter +1;
                else begin sec_counter <= 0;change_ok <= 1;end
                
                if(sec_counter < 100000000) sec <= 0;
                else if(sec_counter < 200000000)sec <= 1;
                                
                                if (client_num == 3)begin
                                    if(sec == 1)begin                
                                        if(sponge_send == 1 && squid_send == 0 && patrick_send == 0 && plankton_send == 0)begin client_3 = 0; client_4 = 2;end
                                        else if(sponge_send == 0 && squid_send == 1 && patrick_send == 0 && plankton_send == 0)begin client_3 = 1; client_4 = 0;end
                                        end
                                    end
                                else if (client_num == 2)begin
                                    if(sec == 1)begin                
                                        if (sponge_send == 1 && squid_send == 1 && patrick_send == 0 && plankton_send == 0)begin client_3 = 0; client_4 = 3; end
                                        else if (sponge_send == 1 && squid_send == 0 && patrick_send == 1 && plankton_send == 0)begin client_3 = 2; client_4 = 0;end
                                        else if (sponge_send == 0 && squid_send == 1 && patrick_send == 1 && plankton_send == 0)begin client_3 = 1; client_4 = 0;end
                                        end
                                    end
                                else if (client_num == 1)begin
                                    if(sec == 1)begin                
                                        if (sponge_send == 0 && squid_send == 1 && patrick_send == 1 && plankton_send == 1)begin client_3 = 1; client_4 = 0; end
                                        else if (sponge_send == 1 && squid_send == 0 && patrick_send == 1 && plankton_send == 1)begin client_3 = 2; client_4 = 0;end
                                        else if (sponge_send == 1 && squid_send == 1 && patrick_send == 0 && plankton_send == 1)begin client_3 = 3; client_4 = 0;end
                                        else if (sponge_send == 1 && squid_send == 1 && patrick_send == 1 && plankton_send == 0)begin client_3 = 0; client_4 = 4;end///////
                                        end
                                    end                                                                                               
                end
            ///////////////////////////////////////////////////////////////////
            end       
        end
   
                
    always @(posedge clk or negedge rst) begin
        if(!rst) CS <= stateRST;
        else CS <= NS;

        end
        
reg over;    
   always @*begin
    case(client_num)
    0:over=1;
    default:over = 0;
    endcase
   end


    
    always @* begin
        case(CS)
            stateRST:begin
                if(start)NS = stateNotget;
                else NS = CS;
            end
            stateNotget:begin
                if(meal_got != 0)NS = stateGet;
                else NS = CS;
                end
            stateGet:begin
                if(meal_got == 0 && wrong_meal == 0)NS = stateChange;
                else if(meal_got == 0 && wrong_meal == 1)NS = stateNotget;
                else NS = CS;
                end
            stateChange:begin
                if(change_ok == 1)NS = stateNotget;
                else NS = CS;
                end
            endcase
            
    end
   //////////////////////////////////led/////////////////////////////
   reg clk3;
   reg [39:0]counterf;
   reg [19:0]counter20;
   reg[40:0] count5;
   reg [4:0]ledcount;
   reg ledcount2;
   reg [3:0]ledcount3;
   wire clkseg;
 always@(posedge clk or negedge rst)//
begin
      if(!rst)
        begin
        clk3=1'b0;
        counterf<=40'b0;
        counter20<=20'b0;
        end
    else begin
            counter20<=counter20+1;
            if(client_num!=0)begin
            if(counterf>=99999999)
            begin
               clk3<=~clk3;
               counterf<=40'b0;
               end
            else
            begin
               counterf<=counterf+1'b1;
               clk3<=clk3;
               end
               end
            else begin
            if(counterf>=24999999)
            begin
               clk3<=~clk3;
               counterf<=40'b0;
               end
            else
            begin
               counterf<=counterf+1'b1;
               clk3<=clk3;
               end
               end
          end
end
assign clkseg=counter20[16];
/*always@*begin
        if(!over)
        count5=99999999;//0.5hz
        else
        count5=24999999;//2HZ
    end*/
always@(posedge clk3 or negedge rst)begin
if(!rst) begin ledcount<=0; ledcount2<=0; ledcount3<=0; end
else begin 
    ledcount<=ledcount+1; ledcount2<=~ledcount2; ledcount3<=ledcount3+1; 
    end
end
always@*
begin
if(!rst) begin led<=0; end
else begin
        if(!level)begin
                    if(client_num!=0)begin
                            case(ledcount)
                            5'd0:led<=16'b0000000000000001;
                            5'd1:led<=16'b0000000000000010;
                            5'd2:led<=16'b0000000000000100;
                            5'd3:led<=16'b0000000000001000;
                            5'd4:led<=16'b0000000000010000;
                            5'd5:led<=16'b0000000000100000;
                            5'd6:led<=16'b0000000001000000;
                            5'd7:led<=16'b0000000010000000;
                            5'd8:led<=16'b0000000100000000;
                            5'd9:led<=16'b0000001000000000;
                            5'd10:led<=16'b0000100000000000;
                            5'd11:led<=16'b0001000000000000;
                            5'd12:led<=16'b0010000000000000;
                            5'd13:led<=16'b0100000000000000;
                            5'd14:led<=16'b1000000000000000;
                            5'd15:led<=16'b0100000000000000;
                            5'd16:led<=16'b0010000000000000;
                            5'd17:led<=16'b0001000000000000;
                            5'd18:led<=16'b0000100000000000;
                            5'd19:led<=16'b0000010000000000;
                            5'd20:led<=16'b0000001000000000;
                            5'd21:led<=16'b0000000100000000;
                            5'd22:led<=16'b0000000010000000;
                            5'd23:led<=16'b0000000001000000;
                            5'd24:led<=16'b0000000000100000;
                            5'd25:led<=16'b0000000000010000;
                            5'd26:led<=16'b0000000000001000;
                            5'd27:led<=16'b0000000000000100;
                            5'd28,5'd30:led<=16'b0000000000000010;
                            5'd29,5'd31:led<=16'b0000000000000001;
                            endcase
                            end
                        else   begin
                                     case(ledcount2)
                                     1'd0:led<=16'b1111111111111111;
                                     1'd1:led<=16'b0000000000000000;
                                     endcase   
                               end    
                     end
          
         else 
                begin
                    if(client_num!=0)begin
                                case(client_num)
                                        5'd1:begin case(ledcount2)
                                                     1'd0:led<=16'b0000000000000001;
                                                     1'd1:led<=16'b1111111111111110;
                                                     endcase   
                                                     end
                                        5'd2:begin case(ledcount2)
                                                     1'd0:led<=16'b0000000000000010;
                                                     1'd1:led<=16'b1111111111111101;
                                                     endcase end
                                        5'd3:begin case(ledcount2)
                                                     1'd0:led<=16'b0000000000000100;
                                                     1'd1:led<=16'b1111111111111011;
                                                     endcase end
                                        5'd4:begin case(ledcount2)
                                                     1'd0:led<=16'b0000000000001000;
                                                     1'd1:led<=16'b1111111111110111;
                                                     endcase end
                                        endcase
                             end
                    else    begin
                                  case(ledcount3)
                            4'd0,4'd14:led<=16'b1000000000000001;
                            4'd1,4'd15:led<=16'b1100000000000011;
                            4'd2:led<=16'b1110000000000111;
                            4'd3:led<=16'b1111000000001111;
                            4'd4:led<=16'b1111100000011111;
                            4'd5:led<=16'b1111110000111111;
                            4'd6:led<=16'b1111111001111111;
                            4'd7:led<=16'b1111111111111111;
                            4'd8:led<=16'b1111111001111111;
                            4'd9:led<=16'b1111110000111111;
                            4'd10:led<=16'b1111100000011111;
                            4'd11:led<=16'b1111000000001111;
                            4'd12:led<=16'b1110000000000111;
                            4'd13:led<=16'b1100000000000011;
                            endcase
                            end
                 end
    end
end  
output reg [3:0]enable1;
output reg [3:0]enable2;
reg [1:0]countseg;
always@(posedge clkseg or negedge rst)
begin
    if(!rst)begin
            countseg<=0;
            enable1<=0;
            enable2<=0;
          end  
    else begin
            countseg<=countseg+1;
            case(countseg)
            2'd0:begin enable1<=4'b1000; enable2<=4'b1000; end 
            2'd1:begin enable1<=4'b0100; enable2<=4'b0100; end 
            2'd2:begin enable1<=4'b0010; enable2<=4'b0010; end
            2'd3:begin enable1<=4'b0001; enable2<=4'b0001; end
            endcase  
    end
end
    parameter SegPattern0 = 8'b11111100;
    parameter SegPattern1 = 8'b01100000;
    parameter SegPattern2 = 8'b11011010;
    parameter SegPattern3 = 8'b11110010;
    parameter SegPattern4 = 8'b01100110; 
    parameter SegPattern5 = 8'b10110110;
    parameter SegPattern6 = 8'b10111110;
    parameter SegPattern7 = 8'b11100000; 
    parameter SegPattern8 = 8'b11111110;
    parameter SegPattern9 = 8'b11110110; 
    parameter SegPatternNone = 8'b00000000;
    reg [8:0] customer1;
    reg [8:0] customer2;
    reg [8:0] seg2num1;
    reg [8:0] seg2num2;
    reg [8:0] seg2num3;
    reg [8:0] seg2num4;
    reg[8:0]seglevel;
    
    
always@* begin
case(enable1)
4'b1000:seven_seg=seglevel;
4'b0100:seven_seg=SegPatternNone;
4'b0010:seven_seg=customer1;
4'b0001:seven_seg=customer2;
endcase
if(level)seglevel=SegPattern2 ;
else seglevel=SegPattern1;
case(client_num)
5'd0:begin customer1=SegPatternNone;customer2=SegPattern0; end
5'd1:begin customer1=SegPatternNone;customer2=SegPattern1; end
5'd2:begin customer1=SegPatternNone;customer2=SegPattern2; end
5'd3:begin customer1=SegPatternNone;customer2=SegPattern3; end
5'd4:begin customer1=SegPatternNone;customer2=SegPattern4; end
5'd5:begin customer1=SegPatternNone;customer2=SegPattern5; end
5'd6:begin customer1=SegPatternNone;customer2=SegPattern6; end
5'd7:begin customer1=SegPatternNone;customer2=SegPattern7; end
5'd8:begin customer1=SegPatternNone;customer2=SegPattern8; end
5'd9:begin customer1=SegPatternNone;customer2=SegPattern9; end
5'd10:begin customer1=SegPattern1;customer2=SegPattern0; end
5'd11:begin customer1=SegPattern1;customer2=SegPattern1; end
5'd12:begin customer1=SegPattern1;customer2=SegPattern2; end
5'd13:begin customer1=SegPattern1;customer2=SegPattern3; end
5'd14:begin customer1=SegPattern1;customer2=SegPattern4; end
5'd15:begin customer1=SegPattern1;customer2=SegPattern5; end
5'd16:begin customer1=SegPattern1;customer2=SegPattern6; end
5'd17:begin customer1=SegPattern1;customer2=SegPattern7; end
5'd18:begin customer1=SegPattern1;customer2=SegPattern8; end
5'd19:begin customer1=SegPattern1;customer2=SegPattern9; end
5'd20:begin customer1=SegPattern2;customer2=SegPattern0; end
5'd21:begin customer1=SegPattern2;customer2=SegPattern1; end
default: ;
endcase
case(enable2)
4'b1000:seven_seg2=seg2num1;
4'b0100:seven_seg2=seg2num2;
4'b0010:seven_seg2=seg2num3;
4'b0001:seven_seg2=seg2num4;
endcase
case(score)
20'd0:begin seg2num1=SegPatternNone;seg2num2=SegPatternNone; seg2num3=SegPatternNone; seg2num4=SegPattern0; end
20'd100:begin seg2num1=SegPatternNone;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd200:begin seg2num1=SegPatternNone;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd300:begin seg2num1=SegPatternNone;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd400:begin seg2num1=SegPatternNone;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd500:begin seg2num1=SegPatternNone;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd600:begin seg2num1=SegPatternNone;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd700:begin seg2num1=SegPatternNone;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd800:begin seg2num1=SegPatternNone;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd900:begin seg2num1=SegPatternNone;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1000:begin seg2num1=SegPattern1;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1100:begin seg2num1=SegPattern1;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1200:begin seg2num1=SegPattern1;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1300:begin seg2num1=SegPattern1;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1400:begin seg2num1=SegPattern1;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1500:begin seg2num1=SegPattern1;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1600:begin seg2num1=SegPattern1;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1700:begin seg2num1=SegPattern1;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1800:begin seg2num1=SegPattern1;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd1900:begin seg2num1=SegPattern1;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2000:begin seg2num1=SegPattern2;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2100:begin seg2num1=SegPattern2;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2200:begin seg2num1=SegPattern2;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2300:begin seg2num1=SegPattern2;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2400:begin seg2num1=SegPattern2;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2500:begin seg2num1=SegPattern2;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2600:begin seg2num1=SegPattern2;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2700:begin seg2num1=SegPattern2;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2800:begin seg2num1=SegPattern2;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd2900:begin seg2num1=SegPattern2;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3000:begin seg2num1=SegPattern3;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3100:begin seg2num1=SegPattern3;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3200:begin seg2num1=SegPattern3;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3300:begin seg2num1=SegPattern3;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3400:begin seg2num1=SegPattern3;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3500:begin seg2num1=SegPattern3;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3600:begin seg2num1=SegPattern3;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3700:begin seg2num1=SegPattern3;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3800:begin seg2num1=SegPattern3;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd3900:begin seg2num1=SegPattern3;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4000:begin seg2num1=SegPattern4;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4100:begin seg2num1=SegPattern4;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4200:begin seg2num1=SegPattern4;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4300:begin seg2num1=SegPattern4;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4400:begin seg2num1=SegPattern4;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4500:begin seg2num1=SegPattern4;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4600:begin seg2num1=SegPattern4;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4700:begin seg2num1=SegPattern4;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4800:begin seg2num1=SegPattern4;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd4900:begin seg2num1=SegPattern4;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5000:begin seg2num1=SegPattern5;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5100:begin seg2num1=SegPattern5;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5200:begin seg2num1=SegPattern5;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5300:begin seg2num1=SegPattern5;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5400:begin seg2num1=SegPattern5;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5500:begin seg2num1=SegPattern5;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5600:begin seg2num1=SegPattern5;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5700:begin seg2num1=SegPattern5;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5800:begin seg2num1=SegPattern5;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd5900:begin seg2num1=SegPattern5;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6000:begin seg2num1=SegPattern6;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6100:begin seg2num1=SegPattern6;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6200:begin seg2num1=SegPattern6;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6300:begin seg2num1=SegPattern6;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6400:begin seg2num1=SegPattern6;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6500:begin seg2num1=SegPattern6;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6600:begin seg2num1=SegPattern6;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6700:begin seg2num1=SegPattern6;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6800:begin seg2num1=SegPattern6;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd6900:begin seg2num1=SegPattern6;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7000:begin seg2num1=SegPattern7;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7100:begin seg2num1=SegPattern7;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7200:begin seg2num1=SegPattern7;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7300:begin seg2num1=SegPattern7;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7400:begin seg2num1=SegPattern7;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7500:begin seg2num1=SegPattern7;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7600:begin seg2num1=SegPattern7;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7700:begin seg2num1=SegPattern7;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7800:begin seg2num1=SegPattern7;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd7900:begin seg2num1=SegPattern7;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8000:begin seg2num1=SegPattern8;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8100:begin seg2num1=SegPattern8;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8200:begin seg2num1=SegPattern8;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8300:begin seg2num1=SegPattern8;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8400:begin seg2num1=SegPattern8;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8500:begin seg2num1=SegPattern8;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8600:begin seg2num1=SegPattern8;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8700:begin seg2num1=SegPattern8;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8800:begin seg2num1=SegPattern8;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd8900:begin seg2num1=SegPattern8;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9000:begin seg2num1=SegPattern9;seg2num2=SegPattern0; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9100:begin seg2num1=SegPattern9;seg2num2=SegPattern1; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9200:begin seg2num1=SegPattern9;seg2num2=SegPattern2; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9300:begin seg2num1=SegPattern9;seg2num2=SegPattern3; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9400:begin seg2num1=SegPattern9;seg2num2=SegPattern4; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9500:begin seg2num1=SegPattern9;seg2num2=SegPattern5; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9600:begin seg2num1=SegPattern9;seg2num2=SegPattern6; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9700:begin seg2num1=SegPattern9;seg2num2=SegPattern7; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9800:begin seg2num1=SegPattern9;seg2num2=SegPattern8; seg2num3=SegPattern0; seg2num4=SegPattern0; end
20'd9900:begin seg2num1=SegPattern9;seg2num2=SegPattern9; seg2num3=SegPattern0; seg2num4=SegPattern0; end
default:begin seg2num1=SegPatternNone;seg2num2=SegPatternNone; seg2num3=SegPatternNone; seg2num4=SegPattern0;end

endcase
end    
endmodule
