`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2019 02:10:44 AM
// Design Name: 
// Module Name: clk_divider_1kHz
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


module clock_divider_1kHz(
    input   clk,
    input   reset,
    output  reg slow_clock
);
    parameter LIMIT=50000; 
    reg [32:0] counter=0;
    
    always@(posedge clk, posedge reset)begin
      if (reset) begin
        counter <=0;
        slow_clock <=0;
      end else begin  
        if(counter==LIMIT)begin
            counter         <= 0;
            slow_clock      <= ~slow_clock;    
        end
        else begin
            counter         <= counter + 1;
            end
         end   
    end
endmodule
