`timescale 1ns/10ps

module fetch(/*OUTPUT*/   PC,   // goes to ILB instruction number
		   	  
	     /*INPUTS*/   clk, reset,fetch_reset,
			  is_struct_hazard, //Signal used to indicate structural hazard. comes from main module
			  is_raw_hazard,active,struct_hazard_0);    //Signal used to indicate RAW data hazard. comes from main module

input clk, reset, fetch_reset, is_struct_hazard;
input [0:1] is_raw_hazard; //Includes both forwarding and nonforwarding cases
output struct_hazard_0;
output [0:4] PC;
reg struct_hazard_0;
input active;
reg struct_hazard_1;
reg [0:4] temp,temp_1;
// // reg is_struct_hazard_d;
assign PC = temp;

always @ (posedge clk or posedge reset or posedge fetch_reset ) 
begin
  if (reset) 
  begin
  temp <= 6'd0;
  struct_hazard_0 <= 0;
  struct_hazard_1<=0;
  end

  else if (fetch_reset) 
  begin
  temp <= 6'd0;
  struct_hazard_0 <= 0;
  struct_hazard_1<=0;
  end
  
  
  else 
  begin
//   is_struct_hazard_d <= is_struct_hazard;
  if (active)
  begin 
  
        if (is_struct_hazard) 
        begin 
	temp <= temp-1;
	struct_hazard_0 <= is_struct_hazard;
        end
 
        else if (is_raw_hazard == 2'b01) 
        begin
	temp <= temp-1;
        struct_hazard_0 <= 1'b1;
        end

        else if (is_raw_hazard == 2'b10) 
        begin
	temp <= temp -1;
        struct_hazard_0 <= 1'b1;
        end

        else 
        begin
            if(struct_hazard_0) 
            begin
            temp <= temp+1;
            struct_hazard_1 <= 1'b1;
            struct_hazard_0 <= 1'b0;
            end

            else 
            begin
                if(struct_hazard_1) 
                begin
                temp <= temp+2;
                struct_hazard_1 <= 1'b0;
                end

                else 
                begin
                temp <= temp+2;
                end
            end
        end
  end
  else begin
  temp <= 6'd0;
  end
  
  end 
end 

endmodule