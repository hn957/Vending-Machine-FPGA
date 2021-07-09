`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2019 02:13:53 AM
// Design Name: 
// Module Name: seg7decimal
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


module seg7decimal(

	input [11:0] x,
    input clk,
    input usd_invalid,
    input code_invalid,
    input [2:0] state,
    output reg [6:0] seg,
    output reg [7:0] an
   
	 );
	 
	 
reg     [3:0] s=0;	 
reg     [3:0] digit;
wire    [7:0] aen;
parameter WAIT_FOR_CODE_CONFIRMED =1;
parameter WAIT_FOR_USD =2;
parameter CHECK_RESULTS =3;
parameter PRICE_DISPLAY=4;
parameter PRICE_DISPLAY_CONFIRMED=5;

assign aen = 8'b11111111; 



	always @(posedge clk)
	if (code_invalid ==1 && state == WAIT_FOR_CODE_CONFIRMED)   
	begin
	   case(s)
		  0:digit = 4'h3; 
		  1:digit = 4'h3; 
		  2:digit = 4'he;
		  3:digit = 4'he; 
		  4:digit = 4'hd;
		  5:digit = 4'hf;
		  6:digit = 4'hc;
		  7:digit = 4'h0;
	   endcase
	end
	else 
	if (code_invalid ==1 && state == PRICE_DISPLAY)   
	begin
	   case(s)
		  0:digit = 4'h3; 
		  1:digit = 4'h3; 
		  2:digit = 4'he;
		  3:digit = 4'he; 
		  4:digit = 4'hd;
		  5:digit = 4'hf;
		  6:digit = 4'hc;
		  7:digit = 4'h0;
	   endcase
	end
	else 
	if (code_invalid ==1 && state == WAIT_FOR_USD)   
	begin
	   case(s)
		  0:digit = 4'h3; 
		  1:digit = 4'h3; 
		  2:digit = 4'he;
		  3:digit = 4'he; 
		  4:digit = 4'hd;
		  5:digit = 4'hf;
		  6:digit = 4'hc;
		  7:digit = 4'h0;
	   endcase
	end
	else
	if (usd_invalid ==1 && state == CHECK_RESULTS) 
	begin
	   case(s)
		  0:digit = 4'h3; 
		  1:digit = 4'h3; 
		  2:digit = 4'he;
		  3:digit = 4'h0; 
		  4:digit = 4'hd;
		  5:digit = 4'h2;
		  6:digit = 4'h1;
		  7:digit = 4'h0;
	   endcase
	end
	else
	if (code_invalid ==0 && state ==PRICE_DISPLAY)
	begin 
	   case(s)
		7:digit = x[3:0]; 
		0:digit = x[7:4]; 
		1:digit = 4'hd;
		2:digit = x[11:8]; 
		3:digit = 0;
		4:digit = 0;
		5:digit = 0;
		6:digit = 0;
	   endcase
	end
	else 
	begin
	case(s)
		7:digit = x[3:0]; 
		0:digit = x[7:4]; 
		1:begin
		  if (state ==CHECK_RESULTS || state == WAIT_FOR_USD)
		  digit = 4'hd;
		  else 
		  digit = 0;
		  end
		2:digit = x[11:8]; 
		3:digit = 0;
		4:digit = 0;
		5:digit = 0;
		6:digit = 0;
	endcase
end
	
	
	always @(*) begin
	if (code_invalid ==1 && state == WAIT_FOR_CODE_CONFIRMED) begin
	    case(digit)
			  4'h0: seg = 7'b0000001;
			  4'h3: seg = 7'b1111010;
              4'hc: seg = 7'b0110001;
              4'hf: seg = 7'b1100010;
              4'he: seg = 7'b0110000;
			  4'hd: seg = 7'b1000010;
		endcase
    end
    else
    if (code_invalid ==1 && state == PRICE_DISPLAY)   
    begin
	    case(digit)
			  4'h0: seg = 7'b0000001;
			  4'h3: seg = 7'b1111010;
              4'hc: seg = 7'b0110001;
              4'hf: seg = 7'b1100010;
              4'he: seg = 7'b0110000;
			  4'hd: seg = 7'b1000010;
		endcase
    end
    else
    if (code_invalid ==1 && state == WAIT_FOR_USD)   
    begin
	    case(digit)
			  4'h0: seg = 7'b0000001;
			  4'h3: seg = 7'b1111010;
              4'hc: seg = 7'b0110001;
              4'hf: seg = 7'b1100010;
              4'he: seg = 7'b0110000;
			  4'hd: seg = 7'b1000010;
		endcase
    end
    else 
    if (usd_invalid ==1 && state == CHECK_RESULTS) 
    begin
		case(digit)
			  4'h0: seg = 7'b0000001;
              4'h1: seg = 7'b1000001;	
              4'h2: seg = 7'b0100100; 
              4'h3: seg = 7'b1111010;           
              4'hd: seg = 7'b1000010;
              4'he: seg = 7'b0110000;
              
		endcase
	end    
    else begin
        case(digit)
			  4'h0: seg = 7'b0000001;
              4'h1: seg = 7'b1001111;	
              4'h2: seg = 7'b0010010; 	
              4'h3: seg = 7'b0000110; 	
              4'h4: seg = 7'b1001100; 	
              4'h5: seg = 7'b0100100; 	
              4'h6: seg = 7'b0100000; 	
              4'h7: seg = 7'b0001111; 	
              4'h8: seg = 7'b0000000; 	
              4'h9: seg = 7'b0000100; 
              4'ha: seg = 7'b0001000;
              4'hb: seg = 7'b1100000;
              4'hc: seg = 7'b0110001;
              4'hd: seg = 7'b1100010; //decimal point, not a real d
              4'he: seg = 7'b0110000;
			default:seg = 7'b0000000; 
		endcase
	end
end
	
	always @(*)begin
		an=8'b11111111;
		if(aen[s] == 1)
			an[s] = 0;
	end

	always @(posedge clk) begin
		s<=s+1;
	end


//assign aen = 8'b11111111; 



//	always @(posedge clk)
//	if (code_invalid ==1 && state == WAIT_FOR_CODE_CONFIRMED)   
//	digit = 4'he;
//	else 
//	if (code_invalid ==1 && state == WAIT_FOR_USD)   
//	digit = 4'he;
//	else
//	if (usd_invalid ==1 && state == CHECK_RESULTS) 
//	digit = 4'he;
//	else 
//	begin
//	case(s)
//		0:digit = x[3:0]; 
//		1:digit = x[7:4]; 
//		2:begin
//		  if (state ==CHECK_RESULTS || state == WAIT_FOR_USD)
//		  digit = 4'hd;
//		  else 
//		  digit = 0;
//		  end
//		3:digit = x[11:8]; 
//		4:digit = 0;
//		5:digit = 0;
//		6:digit = 0;
//		7:digit = 0;
////		default:digit = x[3:0];
//	endcase
//end
	
	
//	always @(*)
//		case(digit)
//			  4'h0: seg = 7'b0000001;
//              4'h1: seg = 7'b1001111;	
//              4'h2: seg = 7'b0010010; 	
//              4'h3: seg = 7'b0000110; 	
//              4'h4: seg = 7'b1001100; 	
//              4'h5: seg = 7'b0100100; 	
//              4'h6: seg = 7'b0100000; 	
//              4'h7: seg = 7'b0001111; 	
//              4'h8: seg = 7'b0000000; 	
//              4'h9: seg = 7'b0000100; 
//              4'ha: seg = 7'b0001000;
//              4'hb: seg = 7'b1100000;
//              4'hc: seg = 7'b0110001;
//              4'hd: seg = 7'b1100010;
//              4'he: seg = 7'b0110000;
//			default:seg = 7'b0000000; 
//		endcase


//	always @(*)begin
//		an=8'b11111111;
//		if(aen[s] == 1)
//			an[s] = 0;
//	end

//	always @(posedge clk) begin
//		s<=s+1;
//	end


endmodule
