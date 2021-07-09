`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2019 02:43:44 AM
// Design Name: 
// Module Name: debouncer
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

module debouncer(
    input   clk,
    input   reset,
    input   button_in,
    output reg button_out
);
   parameter LIMIT=40000000; 
   reg [31:0] counter;
   

   always @(posedge clk) begin
      if (reset) begin 
      counter <=0;
      button_out=0;
      end else  
      if (button_in == 1 && counter != LIMIT) begin
      button_out <= 1'b0;
      counter <=counter+1;
      end else 
      if (button_in == 1 && counter == LIMIT) begin
      button_out <=1'b1;
      counter <= 32'b0;
      end else 
      counter <= counter;
  end
endmodule
