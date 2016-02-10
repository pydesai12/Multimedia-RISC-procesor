`timescale 1ns/10ps
`include "opcode.h"


module permute_unit( /*OUTPUTS to ODD output select pipe*/
		   permute_output, premute_out_availible, permute_addr_rt,

                    /*INPUTS*/ clk,reset,unit_reset,

                    /*INPUTS from Decode Unit*/    
		   op_11_odd, permute_unit_sel, inst_odd,

		   /*INPUTS from Register File*/
		   ra_data_odd, rb_data_odd);

//---------------------------
input clk,reset,unit_reset;

//--------------INPUTS from Decode Unit
input permute_unit_sel, op_11_odd;
input [0:31] inst_odd;
reg [0:31] inst_odd_d;
//--------------INPUTS from Register File
input [0:127] ra_data_odd, rb_data_odd;
reg [0:127] ra_data_odd_d, rb_data_odd_d;
//-------------- OUTPUTS to ODD output select pipe
output reg [0:127] permute_output; 
output reg premute_out_availible; 
output reg [0:6] permute_addr_rt;

reg[0:255] temp_255;
reg [0:127] temp_0,temp_1,temp_2,temp_3,temp_4,temp_5;
reg [0:7]array_16[0:15];
reg [0:2] temp_b,temp,tempp;
reg [0:127] temp_a,result;
reg [0:7] temp_aa,temp_aaa,te4;
reg unit_op_0, unit_op_1, unit_op_2, unit_op_3, unit_op_4, unit_op_5, unit_op_6, unit_op_7; 
reg [0:6] addr_rt_0,addr_rt_1,addr_rt_2,addr_rt_3,addr_rt_4,addr_rt_5,addr_rt_6;
reg [0:4] temp_bb;
reg [0:3] temp_bbb;
integer i,j;
reg op_11_odd_d,permute_unit_sel_d;
//----------------------------

always @ (*) 
begin
    unit_op_0 = 1'b0;
    result = 0;
    {temp,temp_b,temp_a,temp_255,temp_aa,tempp,temp_aaa,te4,temp_bb,temp_bbb} = 0;
    if(permute_unit_sel_d) 
    begin
        unit_op_0 = 1'b1;
        if (op_11_odd_d) 
        begin
        case (inst_odd_d[0:10])
        `SHLQBI:begin
                temp_b = rb_data_odd_d[125:127];
                temp_a = ra_data_odd_d;
                result = temp_a>>temp_b;
                end
                
        `SHLQBY:begin
                temp_bb = rb_data_odd_d[123:127];
                temp_a = ra_data_odd_d;
                
                if (temp_bb==0) result = temp_a;
                else if (temp_bb>15) result = 0;
                else result = temp_a>>temp_bb;
                
                end
                
        `ROTQBI:begin
                temp_b = rb_data_odd_d[125:127];
                temp_a = ra_data_odd_d;
                
                if (temp_b==0) result = temp_a;
                else if (temp_b>7) result = 0;
                else result = temp_a>>temp_b;
                
                end
                
        `ROTQBY:begin
                temp_bbb = rb_data_odd_d[124:127];
                temp_a = ra_data_odd_d;
                
                if (temp_bbb==0) result = temp_a;
                else if (temp_bbb>15) result = 0;
                else result = temp_a>>temp_bbb;
                
                end 
                
        `ROTQMBY:begin
                 temp_bb = rb_data_odd_d[120:127] & 8'h1f;
                 temp_a = ra_data_odd_d;
                 
                if (temp_bb>16) result = 0;
                else result = temp_a>>temp_bb;
                
                end
        endcase 
        end 

        else begin
        result = 0;
        unit_op_0 = 1'b0;
        end
end   
end
always @(posedge clk or posedge reset or posedge unit_reset) 
begin
    if(reset)
	begin
	permute_unit_sel_d <= 0;
        op_11_odd_d <= 0;
	inst_odd_d <= 0;
        addr_rt_0 <= 0;
        unit_op_1 <= 0;
        {ra_data_odd_d, rb_data_odd_d} <= 0;

        temp_1 <= 0;
        temp_2 <= 0;
        temp_3 <= 0;
        temp_4 <= 0;
        temp_5 <= 0;
        permute_output <= 0;

        addr_rt_0 <= 0;
        addr_rt_1 <= 0;
        addr_rt_2 <= 0;
        addr_rt_3 <= 0;
        addr_rt_4 <= 0;
        addr_rt_5 <= 0;
        addr_rt_6 <= 0;
        permute_addr_rt <= 0;

        unit_op_1 <= 0;	
        unit_op_2 <= 0;	
        unit_op_3 <= 0;	
        unit_op_4 <= 0;	
        unit_op_5 <= 0;	
        unit_op_6 <= 0;	
        premute_out_availible <= 0;
	end

	else if (unit_reset)
	begin
	permute_unit_sel_d <= 0;
        op_11_odd_d <= 0;
	inst_odd_d <= 0;
        addr_rt_0 <= 0;
        unit_op_1 <= 0;
        {ra_data_odd_d, rb_data_odd_d} <= 0;

        temp_1 <= 0;
        temp_2 <= 0;
        temp_3 <= 0;
        temp_4 <= 0;
        temp_5 <= 0;
        permute_output <= 0;

        addr_rt_0 <= 0;
        addr_rt_1 <= 0;
        addr_rt_2 <= 0;
        addr_rt_3 <= 0;
        addr_rt_4 <= 0;
        addr_rt_5 <= 0;
        addr_rt_6 <= 0;
        permute_addr_rt <= 0;

        unit_op_1 <= 0;	
        unit_op_2 <= 0;	
        unit_op_3 <= 0;	
        unit_op_4 <= 0;	
        unit_op_5 <= 0;	
        unit_op_6 <= 0;	
        unit_op_7 <= 0;	
        premute_out_availible <= 0;
	end
    
    
	else
	begin
	permute_unit_sel_d <= permute_unit_sel;
	
	if (permute_unit_sel) begin
        op_11_odd_d <= op_11_odd;
	inst_odd_d <= inst_odd;
        addr_rt_0 <= inst_odd_d[25:31];
        unit_op_1 <= unit_op_0;
        {ra_data_odd_d, rb_data_odd_d} <= {ra_data_odd, rb_data_odd};
        end
        
        
        else begin
        op_11_odd_d <= 0;
	inst_odd_d <= 0;
        addr_rt_0 <= 0;
        unit_op_1 <= 0;
        {ra_data_odd_d, rb_data_odd_d} <= 0;        
        end
        
        permute_output <= result;
//         temp_2 <= temp_1;
//         temp_3 <= temp_2;
//         temp_4 <= temp_3;
//         temp_5 <= temp_4;
//         permute_output <= temp_5;

        permute_addr_rt <= inst_odd_d[25:31];
//         addr_rt_1 <= addr_rt_0;
//         addr_rt_2 <= addr_rt_1;
//         addr_rt_3 <= addr_rt_2;
//         addr_rt_4 <= addr_rt_3;
//         permute_addr_rt <= addr_rt_4;

        premute_out_availible <= unit_op_0;	
//         unit_op_2 <= unit_op_1;	
//         unit_op_3 <= unit_op_2;	
//         unit_op_4 <= unit_op_3;	
//         unit_op_5 <= unit_op_4;	
//         premute_out_availible <= unit_op_5;
        end
end
endmodule 
