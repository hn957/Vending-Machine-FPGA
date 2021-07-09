`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2019 02:36:36 AM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input button_0,
    input button_1,
    input button_2,
    input confirm,
    input reset,
    output [6:0] SSD,
    output [7:0] AN
    );
    
    
wire input_0,input_1,input_2,clk_1kHz;



parameter WAIT_FOR_CODE =0;
parameter WAIT_FOR_CODE_CONFIRMED =1;
parameter WAIT_FOR_USD =2;
parameter CHECK_RESULTS =3;
parameter PRICE_DISPLAY=4;
parameter PRICE_DISPLAY_CONFIRMED=5;
reg [2:0] state = WAIT_FOR_CODE;

reg [3:0] no0,no1,no2;
wire [11:0] ssdNumber;
    
debouncer d0(
.clk    (clk),
.reset  (reset),
.button_in  (button_0),
.button_out (input_0)  
);

debouncer d1(
.clk        (clk),
.reset      (reset),
.button_in  (button_1),
.button_out (input_1)  
);

debouncer d2(
.clk        (clk),
.reset      (reset),
.button_in  (button_2),
.button_out (input_2)  
);

reg [7:0] code;
reg [11:0]usd;
reg code_ready,usd_ready;
wire [11:0]usd_refund;
wire [11:0] product;
wire code_valid,code_invalid,usd_enough,usd_invalid;

controller c1(
.reset          (reset),
.clk            (clk),
.code           (code),
.code_ready     (code_ready),
.usd            (usd),
.usd_ready      (usd_ready),

.code_valid     (code_valid),
.code_invalid   (code_invalid),
.usd_invalid    (usd_invalid),
.usd_enough     (usd_enough),
.usd_refund     (usd_refund),
.product         (product)
);

clock_divider_1kHz clock_1kHz (
.clk            (clk),
.reset          (reset),
.slow_clock     (clk_1kHz)
);

seg7decimal sevenSeg (
.x              (ssdNumber[11:0]), 
.clk            (clk_1kHz),
.code_invalid   (code_invalid),
.usd_invalid    (usd_invalid),
.state          (state),
.seg            (SSD[6:0]), 
.an             (AN[7:0])	
);




assign ssdNumber [11:0] = {no2,no1,no0};

parameter LIMIT = 4'd9;
parameter MAX   = 4'd12;
always @(posedge clk) begin
     if (reset) begin
    no0 <=0;
    no1 <=0;
    no2 <=0;
    end
     else begin
        case (state)   
            WAIT_FOR_CODE: begin
                if (input_0) begin
                    if (no0==LIMIT)
                        no0<=0;
                    else 
                        no0<=no0+1;
                    end                 
                if (input_1) begin
                    if (no1==MAX)
                        no1<=0;
                    else 
                        no1<=no1+1;
                    end
                 end
           WAIT_FOR_USD: begin
                if (input_0) begin
                    if (no0==LIMIT)
                        no0<=0;
                    else 
                        no0<=no0+1;
                    end                 
                if (input_1) begin
                    if (no1==LIMIT)
                        no1<=0;
                    else 
                        no1<=no1+1;
                    end
                if (input_2) begin
                    if (no2==LIMIT)
                        no2<=0;
                    else 
                        no2<=no2+1;
                    end    
                 end
           PRICE_DISPLAY: begin
                if (code_valid == 1) begin

                    no2<=(product/100)%10;
			        no1<=(product/10) %10;
			        no0<= product%10;
			    end
          end       
           CHECK_RESULTS: begin
                if (code_valid == 1 && usd_enough ==1) begin
//                  if (usd_enough !=0) begin
                    no2<=(usd_refund/100)%10;
			        no1<=(usd_refund/10) %10;
			        no0<= usd_refund%10;
			    end
          end      
        endcase
    end 
 
 if (reset) begin
     code        <= 0;
     code_ready  <=0;
     usd         <=0;
     usd_ready   <=0;
     state       <= WAIT_FOR_CODE;
     end else 
     begin
        case(state)
            WAIT_FOR_CODE: 
            begin
                if (confirm) 
                    begin
                    code        <={no1,no0};
                    code_ready  <=1;
                    state       <=WAIT_FOR_CODE_CONFIRMED;
                    no0         <=0;
                    no1         <=0;
                    no2         <=0;
                    end
           end
           WAIT_FOR_CODE_CONFIRMED:
               if (confirm==0)
                   state        <=PRICE_DISPLAY;
           PRICE_DISPLAY:
               if (confirm==1) begin
                   state        <=PRICE_DISPLAY_CONFIRMED;
                   no0         <=0;
                   no1         <=0;
                   no2         <=0;
                   end 
           PRICE_DISPLAY_CONFIRMED: 
                if (confirm==0)
                   state        <=WAIT_FOR_USD;        
           WAIT_FOR_USD:
           begin
               if (confirm) 
                  begin
                  usd           <= no2*100+no1*10+no0;
                  usd_ready     <=1;
                  state         <=CHECK_RESULTS;
                  end
           end
         endcase
       end
         
end

//always @(posedge clk) begin
//    if (reset) begin
//     code        <= 0;
//     code_ready  <=0;
//     usd         <=0;
//     usd_ready   <=0;
//     state       <= WAIT_FOR_CODE;
//     end else 
//     begin
//        case(state)
//            WAIT_FOR_CODE: 
//            begin
//                if (confirm) 
//                    begin
//                    code        <={no1,no0};
//                    code_ready  <=1;
//                    state       <=WAIT_FOR_CODE_CONFIRMED;
//                    no0         <=0;
//                    no1         <=0;
//                    no2         <=0;
//                    end
//           end
//           WAIT_FOR_CODE_CONFIRMED:
//               if (confirm==0)
//                   state        <=WAIT_FOR_USD;
//           WAIT_FOR_USD:
//           begin
//               if (confirm) 
//                  begin
//                  usd           <= no2*100+no1*10+no0;
//                  usd_ready     <=1;
//                  state         <=CHECK_RESULTS;
//                  end
//           end
//         endcase
//       end
//end
endmodule
//begin
//if (input_0)
//        if (no0==LIMIT)
//            no0<=0;
//        else
//            no0 <= no0+1;
//     if (input_1==1 && state== WAIT_FOR_USD) begin
//        if (no1==LIMIT)
//            no1<=0;
//        else 
//            no1<=no1+1;
//     end else 
//        if (input_1 ==1 && state !=WAIT_FOR_USD) begin
//            if (no1==MAX)
//                no1<=0;
//            else     
//            no1<=no1+1;
//        end    
//     if (input_2==1) begin
//        if (no2==LIMIT)
//        no2<=0;
//        else
//        no2 <= no2+1;
//     end
//end