//This module contains all fixedpoint instruction execution code.
`timescale 1ns/10ps
`include "opcode.h"
// `include "cla32.v"
module fixedpoint_unit(/*output*/	fix_output, addr_rt_even, fix_out_availible,
		       /*inputs*/ 	clk,reset,unit_reset,
		
		      /*inputs from even pipe out*/
    		        inst_in_even, op_11_even, op_8_even, fix_unit_sel,

		      /*inputs from register file out (address datas)*/
			ra_data_even, rb_data_even);
			
//----------INPUTS------------------------------
input clk, reset,unit_reset;
input op_11_even, op_8_even, fix_unit_sel;
input [0:31] inst_in_even;
input [0:127] ra_data_even, rb_data_even;

//----------OUTPUTS------------------------------
output reg [0:127] fix_output;
output reg [0:6] addr_rt_even;
output reg fix_out_availible;

//------reg declarations.---------
reg [0:127] ra_data_even_d, rb_data_even_d;
reg [0:31] inst_in_even_d;

reg [0:127] out_128;
reg [0:15] array_8 [0:7];
reg [0:31] array_4 [0:3];
reg [0:7]  array_16[0:15];
reg [0:6] addr_rt_even_0,addr_rt_even_1,addr_rt_even_2,addr_rt_even_3,addr_rt_even_4,addr_rt_even_5,addr_rt_even_6;
reg unit_op_0,unit_op_1,unit_op_2,unit_op_3,unit_op_4,unit_op_5,unit_op_6;
reg [0:127] fix_output_0,fix_output_1,fix_output_2,fix_output_3,fix_output_4;

reg fix_unit_sel_d,op_11_even_d,op_8_even_d;

//-----------------------------------COMBINATIONAL BLOCK-----------------------------------------------
always @ (posedge clk or posedge reset or posedge unit_reset) 
begin //A

    if(reset) 
        begin//B
        inst_in_even_d <=0;
        {ra_data_even_d, rb_data_even_d}<=0;
        fix_output_0 <=128'd0;
        fix_output_1 <=128'd0;
        fix_output_2 <= 128'd0;
        fix_output_3 <= 128'd0;
        fix_output_4 <= 128'd0;
        fix_unit_sel_d <=0;
        op_11_even_d <= 0;
        op_8_even_d <= 0;
        fix_output <= 0;
        addr_rt_even <= 0;
//         {array_4[3],array_4[2],array_4[1],array_4[0]} <= 0;
//         {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]} <=0;
//         {array_16[15],array_16[14],array_16[13],array_16[12],
//         array_16[11],array_16[10],array_16[9],array_16[8],
//         array_16[7],array_16[6],array_16[5],array_16[4],
//         array_16[3],array_16[2],array_16[1],array_16[0]} <= 0;
        
        addr_rt_even_0 <= 32'd0;
        addr_rt_even_1 <= 32'd0;
        addr_rt_even_2 <= 32'd0;
        addr_rt_even_3 <= 32'd0;
        addr_rt_even_4 <= 32'd0;
//         addr_rt_even_5 <= 32'd0;
//         addr_rt_even_6 <= 32'd0;
        
        fix_out_availible <= 1'b0;
        unit_op_0 <=1'b0;
        unit_op_1 <=1'b0;
        unit_op_2 <=1'b0;
        unit_op_3 <=1'b0;
        unit_op_4 <=1'b0;
//         unit_op_5 <=1'b0;
//         unit_op_6 <=1'b0;
        end//B
        
        else if(unit_reset)
        begin
        inst_in_even_d <=0;
        {ra_data_even_d, rb_data_even_d}<=0;
        fix_output_0 <= 128'd0;
        fix_output_1 <= 128'd0;
        fix_output_2 <= 128'd0;
        fix_output_3 <= 128'd0;
        fix_output_4 <= 128'd0;
        fix_unit_sel_d <=0;
        op_11_even_d <= 0;
        op_8_even_d <= 0;
        fix_output <= 0;
        addr_rt_even <= 0;
//         {array_4[3],array_4[2],array_4[1],array_4[0]} <= 0;
//         {array_16[15],array_16[14],array_16[13],array_16[12],
//         array_16[11],array_16[10],array_16[9],array_16[8],
//         array_16[7],array_16[6],array_16[5],array_16[4],
//         array_16[3],array_16[2],array_16[1],array_16[0]} <= 0;
//         {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]} <=0;
    
        addr_rt_even_0 <= 32'd0;
        addr_rt_even_1 <= 32'd0;
        addr_rt_even_2 <= 32'd0;
        addr_rt_even_3 <= 32'd0;
        addr_rt_even_4 <= 32'd0;
//         addr_rt_even_5 <= 32'd0;
//         addr_rt_even_6 <= 32'd0;
        
        fix_out_availible <= 1'b0;
        unit_op_0 <=1'b0;
        unit_op_1 <=1'b0;
        unit_op_2 <=1'b0;
        unit_op_3 <=1'b0;
        unit_op_4 <=1'b0;
/*        unit_op_5 <=1'b0;
        unit_op_6 <=1'b0;   */     
        end
  
        else
        begin //C
        
        fix_unit_sel_d <= fix_unit_sel;
        
        if (fix_unit_sel) begin
        {ra_data_even_d, rb_data_even_d}<={ra_data_even, rb_data_even};
        inst_in_even_d <=inst_in_even;

        op_11_even_d <= op_11_even;
        op_8_even_d <= op_8_even;
        end
        
        else begin
        {ra_data_even_d, rb_data_even_d}<=0;
        inst_in_even_d <=0;
        op_11_even_d <= 0;
        op_8_even_d <= 0;
        end
        
        
        fix_output <=out_128;         //----- FIXEDPOINT UNIT OUTPUT PIPELINED
//         fix_output_1 <=fix_output_0;
//         fix_output_2 <=fix_output_1;
//         fix_output_3 <=fix_output_2;
//         fix_output_4 <=fix_output_3;
//         fix_output <=fix_output_4;
        
        if (fix_unit_sel_d)addr_rt_even <=inst_in_even_d[25:31];    //----- RT ADDRESS OUTPUT PIPELINED
        else addr_rt_even <= 0;
//         addr_rt_even_1 <=addr_rt_even_0;
//         addr_rt_even_2 <=addr_rt_even_1;
//         addr_rt_even_3 <=addr_rt_even_2;
//         addr_rt_even_4 <=addr_rt_even_3;
//         addr_rt_even <=addr_rt_even_4;
//         addr_rt_even_6 <=addr_rt_even_5;
//         addr_rt_even <=addr_rt_even_6;
        
        if(fix_unit_sel_d)
        fix_out_availible <= 1'b1;
        
        else
        fix_out_availible <= 1'b0;
        
//         unit_op_1 <=unit_op_0;    //----- FIXEDPOINT UNIT OUTPUT AVAILIBLE BIT PIPELINED
//         unit_op_2 <=unit_op_1;
//         unit_op_3 <=unit_op_2;
//         unit_op_4 <=unit_op_3;
//         fix_out_availible <=unit_op_4;
//         unit_op_6 <=unit_op_5;
//         fix_out_availible <=unit_op_6;
  
  

end //A
end


always @ (*)
begin
if(reset | unit_reset) begin 
out_128 = 0; 

{array_4[3],array_4[2],array_4[1],array_4[0]} = 0;
        {array_16[15],array_16[14],array_16[13],array_16[12],
        array_16[11],array_16[10],array_16[9],array_16[8],
        array_16[7],array_16[6],array_16[5],array_16[4],
        array_16[3],array_16[2],array_16[1],array_16[0]} = 0;
        {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]} =0;




end
else begin
{array_4[3],array_4[2],array_4[1],array_4[0]} = 0;
        {array_16[15],array_16[14],array_16[13],array_16[12],
        array_16[11],array_16[10],array_16[9],array_16[8],
        array_16[7],array_16[6],array_16[5],array_16[4],
        array_16[3],array_16[2],array_16[1],array_16[0]} = 0;
        {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]} =0;

        if(fix_unit_sel_d) 
        begin //D
            if(op_11_even_d)     //--------------------------11 BIT OPCODE INSTRUCTION EXECUTION
            begin  //E
            case (inst_in_even_d[0:10])
//-------------------------------------
            `AH:begin
                array_8[0] =ra_data_even_d[112:127] + rb_data_even_d[112:127];
                array_8[1] =ra_data_even_d[96:111] + rb_data_even_d[96:111] ;
                array_8[2] =ra_data_even_d[80:95] + rb_data_even_d[80:95];
                array_8[3] =ra_data_even_d[64:79] + rb_data_even_d[64:79];
                array_8[4] =ra_data_even_d[48:63] + rb_data_even_d[48:63];
                array_8[5] =ra_data_even_d[32:47] + rb_data_even_d[32:47];
                array_8[6] =ra_data_even_d[16:31] + rb_data_even_d[16:31];
                array_8[7] =ra_data_even_d[0:15]  + rb_data_even_d[0:15];
                end

            `SFH:begin
                array_8[0] =ra_data_even_d[112:127] + rb_data_even_d[112:127] + 1'b1;
                array_8[1] =ra_data_even_d[96:111] + rb_data_even_d[96:111] + 1'b1;
                array_8[2] =ra_data_even_d[80:95] + rb_data_even_d[80:95] + 1'b1;
                array_8[3] =ra_data_even_d[64:79] + rb_data_even_d[64:79] + 1'b1;
                array_8[4] =ra_data_even_d[48:63] + rb_data_even_d[48:63] + 1'b1;
                array_8[5] =ra_data_even_d[32:47] + rb_data_even_d[32:47] + 1'b1;
                array_8[6] =ra_data_even_d[16:31] + rb_data_even_d[16:31] + 1'b1;
                array_8[7] =ra_data_even_d[0:15]  + rb_data_even_d[0:15] + 1'b1;
                end
            
            `MPY:begin
                array_8[0] =ra_data_even_d[112:127] * rb_data_even_d[112:127];
                array_8[1] =ra_data_even_d[96:111] * rb_data_even_d[96:111] ;
                array_8[2] =ra_data_even_d[80:95] * rb_data_even_d[80:95];
                array_8[3] =ra_data_even_d[64:79] * rb_data_even_d[64:79];
                array_8[4] =ra_data_even_d[48:63] * rb_data_even_d[48:63];
                array_8[5] =ra_data_even_d[32:47] * rb_data_even_d[32:47];
                array_8[6] =ra_data_even_d[16:31] * rb_data_even_d[16:31];
                array_8[7] =ra_data_even_d[0:15]  * rb_data_even_d[0:15]; 
                end
         
            `MPYU:begin
                array_8[0] =ra_data_even_d[112:127] * rb_data_even_d[112:127];
                array_8[1] =ra_data_even_d[96:111] * rb_data_even_d[96:111] ;
                array_8[2] =ra_data_even_d[80:95] * rb_data_even_d[80:95];
                array_8[3] =ra_data_even_d[64:79] * rb_data_even_d[64:79];
                array_8[4] =ra_data_even_d[48:63] * rb_data_even_d[48:63];
                array_8[5] =ra_data_even_d[32:47] * rb_data_even_d[32:47];
                array_8[6] =ra_data_even_d[16:31] * rb_data_even_d[16:31];
                array_8[7] =ra_data_even_d[0:15]  * rb_data_even_d[0:15];    
                end
    
            `CEQB:begin
                
                    if(ra_data_even_d[120:127] == rb_data_even_d[120:127]) array_16[0] =8'hFF;
                    else array_16[0] =8'd0;
                    
                    if(ra_data_even_d[112:119] == rb_data_even_d[112:119]) array_16[1] =8'hFF;
                    else array_16[1] =8'd0;

                    if(ra_data_even_d[104:111] == rb_data_even_d[104:111]) array_16[2] =8'hFF;
                    else array_16[2] =8'd0;
                    
                    if(ra_data_even_d[96:103] == rb_data_even_d[96:103]) array_16[3] =8'hFF;
                    else array_16[3] =8'd0;
                    
                    if(ra_data_even_d[88:95] == rb_data_even_d[88:95]) array_16[4] =8'hFF;
                    else array_16[4] =8'd0;

                    if(ra_data_even_d[80:87] == rb_data_even_d[80:87]) array_16[5] =8'hFF;
                    else array_16[5] =8'd0;
                    
                    if(ra_data_even_d[72:79] == rb_data_even_d[72:79]) array_16[6] =8'hFF;
                    else array_16[6] =8'd0;
                    
                    if(ra_data_even_d[64:71] == rb_data_even_d[64:71]) array_16[7] =8'hFF;
                    else array_16[7] =8'd0;

                    if(ra_data_even_d[56:63] == rb_data_even_d[56:63]) array_16[8] =8'hFF;
                    else array_16[8] =8'd0;
                    
                    if(ra_data_even_d[48:55] == rb_data_even_d[48:55]) array_16[9] =8'hFF;
                    else array_16[9] =8'd0;
                    
                    if(ra_data_even_d[40:47] == rb_data_even_d[40:47]) array_16[10] =8'hFF;
                    else array_16[10] =8'd0;

                    if(ra_data_even_d[32:39] == rb_data_even_d[32:39]) array_16[11] =8'hFF;
                    else array_16[11] =8'd0;
                    
                    if(ra_data_even_d[24:31] == rb_data_even_d[24:31]) array_16[12] =8'hFF;
                    else array_16[12] =8'd0;
                    
                    if(ra_data_even_d[16:23] == rb_data_even_d[16:23]) array_16[13] =8'hFF;
                    else array_16[13] =8'd0;

                    if(ra_data_even_d[8:15] == rb_data_even_d[8:15]) array_16[14] =8'hFF;
                    else array_16[14] =8'd0;
                    
                    if(ra_data_even_d[0:7] == rb_data_even_d[0:7]) array_16[15] =8'hFF;
                    else array_16[15] =8'd0;

                end
    
            `CEQH:begin
                    if(ra_data_even_d[112:127] == rb_data_even_d[120:127]) array_8[0] =16'hFFFF;
                    else array_8[0] =16'd0;
                    
                    if(ra_data_even_d[96:111] == rb_data_even_d[96:111]) array_8[1] =16'hFFFF;
                    else array_8[1] =16'd0;
                    
                    if(ra_data_even_d[80:95] == rb_data_even_d[80:95]) array_8[2] =16'hFFFF;
                    else array_8[2] =16'd0;

                    if(ra_data_even_d[64:79] == rb_data_even_d[64:79]) array_8[3] =16'hFFFF;
                    else array_8[3] =16'd0;
                    
                    if(ra_data_even_d[48:63] == rb_data_even_d[48:63]) array_8[4] =16'hFFFF;
                    else array_8[4] =16'd0;
                    
                    if(ra_data_even_d[32:47] == rb_data_even_d[32:47]) array_8[5] =16'hFFFF;
                    else array_8[5] =16'd0;

                    if(ra_data_even_d[16:31] == rb_data_even_d[16:31]) array_8[6] =16'hFFFF;
                    else array_8[6] =16'd0;
                    
                    if(ra_data_even_d[0:15] == rb_data_even_d[0:15]) array_8[7] =16'hFFFF;
                    else array_8[7] =16'd0; 
                end
                
            `CGTB:begin
                    if(ra_data_even_d[120:127] > rb_data_even_d[120:127]) array_16[0] =8'hFF;
                    else array_16[0] =8'd0;
                    
                    if(ra_data_even_d[112:119] > rb_data_even_d[112:119]) array_16[1] =8'hFF;
                    else array_16[1] =8'd0;

                    if(ra_data_even_d[104:111] > rb_data_even_d[104:111]) array_16[2] =8'hFF;
                    else array_16[2] =8'd0;
                    
                    if(ra_data_even_d[96:103] > rb_data_even_d[96:103]) array_16[3] =8'hFF;
                    else array_16[3] =8'd0;
                    
                    if(ra_data_even_d[88:95] > rb_data_even_d[88:95]) array_16[4] =8'hFF;
                    else array_16[4] =8'd0;

                    if(ra_data_even_d[80:87] > rb_data_even_d[80:87]) array_16[5] =8'hFF;
                    else array_16[5] =8'd0;
                    
                    if(ra_data_even_d[72:79] > rb_data_even_d[72:79]) array_16[6] =8'hFF;
                    else array_16[6] =8'd0;
                    
                    if(ra_data_even_d[64:71] > rb_data_even_d[64:71]) array_16[7] =8'hFF;
                    else array_16[7] =8'd0;

                    if(ra_data_even_d[56:63] > rb_data_even_d[56:63]) array_16[8] =8'hFF;
                    else array_16[8] =8'd0;
                    
                    if(ra_data_even_d[48:55] > rb_data_even_d[48:55]) array_16[9] =8'hFF;
                    else array_16[9] =8'd0;
                    
                    if(ra_data_even_d[40:47] > rb_data_even_d[40:47]) array_16[10] =8'hFF;
                    else array_16[10] =8'd0;

                    if(ra_data_even_d[32:39] > rb_data_even_d[32:39]) array_16[11] =8'hFF;
                    else array_16[11] =8'd0;
                    
                    if(ra_data_even_d[24:31] > rb_data_even_d[24:31]) array_16[12] =8'hFF;
                    else array_16[12] =8'd0;
                    
                    if(ra_data_even_d[16:23] > rb_data_even_d[16:23]) array_16[13] =8'hFF;
                    else array_16[13] =8'd0;

                    if(ra_data_even_d[8:15] > rb_data_even_d[8:15]) array_16[14] =8'hFF;
                    else array_16[14] =8'd0;
                    
                    if(ra_data_even_d[0:7] > rb_data_even_d[0:7]) array_16[15] =8'hFF;
                    else array_16[15] =8'd0;
                end
            
            `CGT:begin

                    if(ra_data_even_d[96:127] > rb_data_even_d[96:127]) array_4[0] =32'hFFFFFFFF;
                    else array_4[0] =32'd0;
                    
                    if(ra_data_even_d[64:95] > rb_data_even_d[64:95]) array_4[1] =32'hFFFFFFFF;
                    else array_4[1] =32'd0;
                    
                    if(ra_data_even_d[32:63] > rb_data_even_d[32:63]) array_4[2] =32'hFFFFFFFF;
                    else array_4[2] =32'd0;
                    
                    if(ra_data_even_d[0:31] > rb_data_even_d[0:31]) array_4[3] =32'hFFFFFFFF;
                    else array_4[3] =32'd0;
                end
            endcase
            end //E
    
            else if (op_8_even_d)  //--------------------------8 BIT OPCODE INSTRUCTION EXECUTION
            begin //F
       
            case(inst_in_even_d[0:7])
            `AHI:begin
                array_8[0] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[112:127];
                array_8[1] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[96:111];
                array_8[2] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[80:95];
                array_8[3] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[64:79];
                array_8[4] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[48:63];
                array_8[5] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[32:47];
                array_8[6] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[16:31];
                array_8[7] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} + ra_data_even_d[0:15];
                end
            
            `MPYI:begin
                    array_8[0] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[112:127];
                    array_8[1] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[96:111];
                    array_8[2] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[80:95];
                    array_8[3] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[64:79];
                    array_8[4] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[48:63];
                    array_8[5] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[32:47];
                    array_8[6] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[16:31];
                    array_8[7] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} * ra_data_even_d[0:15];
                    end
                    
            `ANDHI:begin
                    array_8[0] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[112:127];
                    array_8[1] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[96:111];
                    array_8[2] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[80:95];
                    array_8[3] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[64:79];
                    array_8[4] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[48:63];
                    array_8[5] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[32:47];
                    array_8[6] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[16:31];
                    array_8[7] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} & ra_data_even_d[0:15];
                    end
                
            `ORHI:begin
                    array_8[0] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[112:127];
                    array_8[1] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[96:111];
                    array_8[2] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[80:95];
                    array_8[3] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[64:79];
                    array_8[4] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[48:63];
                    array_8[5] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[32:47];
                    array_8[6] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[16:31];
                    array_8[7] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} | ra_data_even_d[0:15];
                    end
            
            `XORHI:begin
                    array_8[0] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[112:127];
                    array_8[1] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[96:111];
                    array_8[2] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[80:95];
                    array_8[3] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[64:79];
                    array_8[4] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[48:63];
                    array_8[5] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[32:47];
                    array_8[6] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[16:31];
                    array_8[7] ={{6{inst_in_even_d[8]}},inst_in_even_d[8:17]} ^ ra_data_even_d[0:15];
                    end
                    
            `CEQBI:begin
                        if(ra_data_even_d[120:127] == inst_in_even_d[10:17]) array_16[0] =8'hFF;
                    else array_16[0] =8'd0;
                    
                    if(ra_data_even_d[112:119] == inst_in_even_d[10:17]) array_16[1] =8'hFF;
                    else array_16[1] =8'd0;

                    if(ra_data_even_d[104:111]  == inst_in_even_d[10:17]) array_16[2] =8'hFF;
                    else array_16[2] =8'd0;
                    
                    if(ra_data_even_d[96:103] == inst_in_even_d[10:17]) array_16[3] =8'hFF;
                    else array_16[3] =8'd0;
                    
                    if(ra_data_even_d[88:95] == inst_in_even_d[10:17]) array_16[4] =8'hFF;
                    else array_16[4] =8'd0;

                    if(ra_data_even_d[80:87] == inst_in_even_d[10:17]) array_16[5] =8'hFF;
                    else array_16[5] =8'd0;
                    
                    if(ra_data_even_d[72:79] == inst_in_even_d[10:17]) array_16[6] =8'hFF;
                    else array_16[6] =8'd0;
                    
                    if(ra_data_even_d[64:71] == inst_in_even_d[10:17]) array_16[7] =8'hFF;
                    else array_16[7] =8'd0;

                    if(ra_data_even_d[56:63] == inst_in_even_d[10:17]) array_16[8] =8'hFF;
                    else array_16[8] =8'd0;
                    
                    if(ra_data_even_d[48:55] == inst_in_even_d[10:17]) array_16[9] =8'hFF;
                    else array_16[9] =8'd0;
                    
                    if(ra_data_even_d[40:47] == inst_in_even_d[10:17]) array_16[10] =8'hFF;
                    else array_16[10] =8'd0;

                    if(ra_data_even_d[32:39] == inst_in_even_d[10:17]) array_16[11] =8'hFF;
                    else array_16[11] = 8'd0;
                    
                    if(ra_data_even_d[24:31] == inst_in_even_d[10:17]) array_16[12] =8'hFF;
                    else array_16[12] = 8'd0;
                    
                    if(ra_data_even_d[16:23] == inst_in_even_d[10:17]) array_16[13] =8'hFF;
                    else array_16[13] = 8'd0;

                    if(ra_data_even_d[8:15] == inst_in_even_d[10:17]) array_16[14] =8'hFF;
                    else array_16[14] = 8'd0;
                    
                    if(ra_data_even_d[0:7] == inst_in_even_d[10:17]) array_16[15] = 8'hFF;
                    else array_16[15] = 8'd0;
                    end
            
            `CGTI:begin

                    if(ra_data_even_d[96:127] > {{22{inst_in_even_d[8]}},inst_in_even_d[8:17]}) array_4[0] = 32'hFFFFFFFF;
                    else array_4[0] = 32'd0;
                    
                    if(ra_data_even_d[64:95] > {{22{inst_in_even_d[8]}},inst_in_even_d[8:17]}) array_4[1] = 32'hFFFFFFFF;
                    else array_4[1] = 32'd0;
                    
                    if(ra_data_even_d[32:63] > {{22{inst_in_even_d[8]}},inst_in_even_d[8:17]}) array_4[2] = 32'hFFFFFFFF;
                    else array_4[2] = 32'd0;
                    
                    if(ra_data_even_d[0:31] > {{22{inst_in_even_d[8]}},inst_in_even_d[8:17]}) array_4[3] = 32'hFFFFFFFF;
                    else array_4[3] = 32'd0;
                    end
            endcase
            end //F

            else begin
                    {array_4[3],array_4[2],array_4[1],array_4[0]} = 0;
                    {array_16[15],array_16[14],array_16[13],array_16[12],
                    array_16[11],array_16[10],array_16[9],array_16[8],
                    array_16[7],array_16[6],array_16[5],array_16[4],
                    array_16[3],array_16[2],array_16[1],array_16[0]} = 0;
                    {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]} =0;
                end
end
        else begin 
        {array_4[3],array_4[2],array_4[1],array_4[0]} = 0;
        {array_16[15],array_16[14],array_16[13],array_16[12],
        array_16[11],array_16[10],array_16[9],array_16[8],
	array_16[7],array_16[6],array_16[5],array_16[4],
	array_16[3],array_16[2],array_16[1],array_16[0]} = 0;
        {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]} =0;
        end












    out_128 = 0;
    if(op_11_even_d)     
    begin  
    case (inst_in_even_d[0:10])
    `AH: out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]};
    `SFH:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]};
    `MPY:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]};
    `MPYU:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]};
    `CEQH:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]};
    `BG:begin
          if(ra_data_even_d>rb_data_even_d) out_128 = 128'd0;
          else out_128 = 128'd1;
        end
    `AND: out_128 = ra_data_even_d & rb_data_even_d;
    
    `OR:  out_128 = ra_data_even_d | rb_data_even_d;

    `XOR: out_128 = ra_data_even_d ^ rb_data_even_d;
    
    `NAND:out_128 = ~(ra_data_even_d & rb_data_even_d);
    
    `NOR: out_128 = ~(ra_data_even_d | rb_data_even_d);
    
    `EQV:begin
         if (ra_data_even_d==rb_data_even_d)
            out_128 = {127'b00, 1'b1};
         else
            out_128 = 0;
         end
    `CEQB: out_128 = {array_16[15],array_16[14],array_16[13],array_16[12],
	       array_16[11],array_16[10],array_16[9],array_16[8],
	       array_16[7],array_16[6],array_16[5],array_16[4],
	       array_16[3],array_16[2],array_16[1],array_16[0]};
    `CGTB:out_128 = {array_16[15],array_16[14],array_16[13],array_16[12],
	       array_16[11],array_16[10],array_16[9],array_16[8],
	       array_16[7],array_16[6],array_16[5],array_16[4],
	       array_16[3],array_16[2],array_16[1],array_16[0]};
	       
    `CGT:out_128 = {array_4[3],array_4[2],array_4[1],array_4[0]};
    endcase
    end
    else if (op_8_even_d)
       begin
       case(inst_in_even_d[0:7])
       `AHI:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]}; 
       `MPYI:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]}; 
       `ANDHI:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]};   
       `ORHI:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]}; 
       `XORHI:out_128 = {array_8[7],array_8[6],array_8[5],array_8[4],array_8[3],array_8[2],array_8[1],array_8[0]};
        
       `CEQBI:out_128 = {array_16[15],array_16[14],array_16[13],array_16[12],
                                    array_16[11],array_16[10],array_16[9],array_16[8],
                                    array_16[7],array_16[6],array_16[5],array_16[4],
                                    array_16[3],array_16[2],array_16[1],array_16[0]};
       `CGTI  :out_128 = {array_4[3],array_4[2],array_4[1],array_4[0]};  
       endcase
       
       end
       
    else out_128 = 0;
end
end
endmodule