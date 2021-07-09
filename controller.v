`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2019 03:35:04 AM
// Design Name: 
// Module Name: controller
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


module controller(

	input 		reset,
	input 		clk,
	
	input [7:0]	code, 			
	input  		code_ready,		
	
	input [11:0] usd,			
	input 		usd_ready,		
	
	output 	reg	code_valid,
	output  reg code_invalid,
	output  reg usd_invalid,  	
	output	reg	usd_enough,		
	output  reg [11:0] usd_refund,
	output	reg [11:0] product		
	
	
);
	
	localparam Lays 	= 8'd100;
	localparam KChips 	= 8'd100;
	localparam PopCorn 	= 8'd75;
	localparam KitKat 	= 8'd125;
	localparam Twix 	= 8'd100;
	localparam Snickers	= 8'd125;
	localparam Peanuts	= 8'd75;
	localparam Crackers	= 8'd75;
	
	

	always@(posedge clk)begin
		if(reset)begin
			code_valid	<= 0;
			usd_enough 	<= 0;
			usd_refund 	<= 8'd0;
			product	   	<= 0;
		end
		else begin
			if(code_ready)begin
				case(code)
					8'hA1:begin					
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	Lays;
					end
					8'hA2:begin
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	KChips;
					end					
					8'hA3:begin
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	PopCorn;
					end		
					8'hB1:begin
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	KitKat;
					end		
					8'hB2:begin
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	Twix;
					end		
					8'hB3:begin
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	Snickers;
					end		
					8'hC1:begin
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	Peanuts;
					end		
					8'hC2:begin
						code_valid 	<= 	1;
						code_invalid<=  0;
						product		<= 	Crackers;
					end	
					default:begin
						code_valid 	<= 	0;
						code_invalid<=  1;
						product		<= 	0;					
					end
				endcase
			
			end
		end
//	end

//	always@(*)begin
		if(code_valid==1 && usd_ready==1)begin
			if(usd>=product)begin  
				usd_enough      <= 1;
				usd_invalid     <=0;
				usd_refund      <= usd - product;
			end
			else begin
				usd_enough      <= 0;
				usd_invalid     <=1;
				usd_refund      <= 8'd0;
			end
		end
		else begin
				usd_enough      <= 0;
				usd_invalid     <=1;
				usd_refund      <= 8'd0;			
		end	
	end 

endmodule
