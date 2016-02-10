
`timescale 1ns/10ps
`include "opcode.h"

module byte_unit ( /*OUTPUTS to EVEN output select pipe*/
		   byte_output, byte_out_availible, byte_addr_rt,
		   
		   /*INPUTS*/ clk,reset,unit_reset,
		   
		   /*INPUTS from Register File*/
		   ra_data_even, rb_data_even,

                    /*INPUTS from Decode Unit*/    
		   op_11_even, byte_unit_sel, inst_even);


input clk,reset,unit_reset;

//--------------INPUTS from Decode Unit
input byte_unit_sel, op_11_even;
input [0:31] inst_even;
reg [0:31] inst_even_d; 
//--------------INPUTS from Register File
input [0:127] ra_data_even, rb_data_even;

//-------------- OUTPUTS to EVEN output select pipe
output reg [0:127] byte_output; 
output reg byte_out_availible; 
output reg [0:6] byte_addr_rt;

//--------------------------------------------------
reg [0:7]array_16[0:15];
reg [0:127] temp_ra, temp_rb, temp_1,result,ra_data_even_d, rb_data_even_d;
reg[0:7]temp_ra_1,temp_ra_2,temp_ra_3,temp_ra_4,temp_ra_5,temp_ra_6,temp_ra_7;
reg[0:7]temp_ra_8,temp_ra_9,temp_ra_10,temp_ra_11,temp_ra_12,temp_ra_13,temp_ra_14,temp_ra_15,temp_ra_16;

reg [0:7] result_1,result_2,result_3,result_4,result_5,result_6,result_7,result_8,result_9;
reg [0:7] result_10,result_11,result_12,result_13,result_14,result_15,result_16;
integer i;

reg unit_op_0,unit_op_1,unit_op_2,unit_op_3,unit_op_4,unit_op_5,unit_op_6;
reg [0:127] byte_output_0,byte_output_1,byte_output_2,byte_output_3,byte_output_4;
reg [0:6] addr_rt_even_0,addr_rt_even_1,addr_rt_even_2,addr_rt_even_3,addr_rt_even_4,addr_rt_even_5,addr_rt_even_6;
reg op_11_even_d, byte_unit_sel_d;
//----------------------------------------------------
always @(*) 
begin
        result = 0;
        {temp_ra,temp_rb,temp_1} = 0;
        {result_1,result_2,result_3,result_4,result_5,result_6} = 0;
        {result_7,result_8,result_9,result_10,result_11,result_12,result_13,result_14,result_15,result_16} = 0;
        
    if(byte_unit_sel_d) 
    begin      
        if (op_11_even_d) 
        begin
            case (inst_even_d[0:10])
            `CNTB:begin
                  temp_ra_1 = ra_data_even_d[0:7];
                  temp_ra_2 = ra_data_even_d[8:15];
                  temp_ra_3 = ra_data_even_d[16:23];
                  temp_ra_4 = ra_data_even_d[24:31];
                  temp_ra_5 = ra_data_even_d[32:39];
                  temp_ra_6 = ra_data_even_d[40:47];
                  temp_ra_7 = ra_data_even_d[48:55];
                  temp_ra_8 = ra_data_even_d[56:63];
                  temp_ra_9 = ra_data_even_d[64:71];
                  temp_ra_10 = ra_data_even_d[72:79];
                  temp_ra_11 = ra_data_even_d[80:87];
                  temp_ra_12 = ra_data_even_d[88:95];
                  temp_ra_13 = ra_data_even_d[96:103];
                  temp_ra_14 = ra_data_even_d[104:111];
                  temp_ra_15 = ra_data_even_d[112:119];
                  temp_ra_16 = ra_data_even_d[120:127];
                  

                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_1[i]==1'b1) result_1 = result_1+1;
                            else                   result_1 = result_1;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_2[i]==1'b1) result_2 = result_2+1;
                            else                   result_2 = result_2;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_3[i]==1'b1) result_3 = result_3+1;
                            else                   result_3 = result_3;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_4[i]==1'b1) result_4 = result_4+1;
                            else                   result_4 = result_4;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_5[i]==1'b1) result_5 = result_5+1;
                            else                   result_5 = result_5;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_6[i]==1'b1) result_6 = result_6+1;
                            else                   result_6 = result_6;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_7[i]==1'b1) result_7 = result_7+1;
                            else                   result_7 = result_7;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_8[i]==1'b1) result_8 = result_8+1;
                            else                   result_8 = result_8;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_9[i]==1'b1) result_9 = result_9+1;
                            else                   result_9 = result_9;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_10[i]==1'b1) result_10 = result_10+1;
                            else                   result_10 = result_10;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_11[i]==1'b1) result_11 = result_11+1;
                            else                   result_11 = result_11;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_12[i]==1'b1) result_12 = result_12+1;
                            else                   result_12 = result_12;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_13[i]==1'b1) result_13 = result_13+1;
                            else                   result_13 = result_13;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_14[i]==1'b1) result_14 = result_14+1;
                            else                   result_14 = result_14;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_15[i]==1'b1) result_15 = result_15+1;
                            else                   result_15 = result_15;
                       end
                       
                  for (i=0;i<8;i=i+1) 
                       begin
                            if(temp_ra_16[i]==1'b1) result_16 = result_16+1;
                            else                   result_16 = result_16;
                       end     
                       
                   result = result_1 + result_2 + result_3 + result_4 + result_5 + result_6 + 
                            result_7 + result_8 + result_9 + result_10 + result_11 + result_12 + 
                            result_13 + result_14 + result_15 + result_16;  
        
                  end
                  
            `GBB:begin
                 temp_ra = ra_data_even_d;
                 for (i=0;i<16;i=i+1) 
                    begin
                    result[127-i] = temp_ra[127];
                    temp_ra = temp_ra>>8;
                    end
                 end
            
            `GB:begin
                 temp_ra = ra_data_even_d;
                 for (i=0;i<4;i=i+1) 
                    begin
                    result[127-i] = temp_ra[127];
                    temp_ra = temp_ra>>32;
                    end
                 end
                
            `AVGB:begin
                  temp_ra = ra_data_even_d;
                  temp_rb = rb_data_even_d;
                  for(i=0;i<16;i=i+1)
                    begin
                    temp_1 = temp_ra[120:127] + temp_rb[120:127] + 1'b1;
                    array_16[i] = temp_1>>1;
                    temp_ra = temp_ra>>8;
                    temp_rb = temp_rb>>8;
                    end
                  result = {array_16[0],array_16[1],array_16[2],array_16[3],array_16[4],array_16[5],
                            array_16[6],array_16[7],array_16[8],array_16[9],array_16[10],array_16[11],
                            array_16[12],array_16[13],array_16[14],array_16[15]};
                  end
            endcase 
        end 

        else 
        begin
        result = 0;
        {temp_ra,temp_rb,temp_1} = 0;
        end
    end 
end 


always @(posedge clk or posedge reset or posedge unit_reset) 
begin
    if(reset)
    begin
    op_11_even_d <= 0;
    byte_unit_sel_d <= 0;
    {ra_data_even_d, rb_data_even_d} <= 0;
    inst_even_d <= 0;
    byte_output_0 <= 128'd0;
    byte_output_1 <= 128'd0;
    byte_output_2 <= 128'd0;
    byte_output_3 <= 128'd0;
    byte_output_4 <= 128'd0;
    byte_output <= 128'd0;
    
    addr_rt_even_0 <= 32'd0;
    addr_rt_even_1 <= 32'd0;
    addr_rt_even_2 <= 32'd0;
    addr_rt_even_3 <= 32'd0;
    addr_rt_even_4 <= 32'd0;
    addr_rt_even_5 <= 32'd0;
    addr_rt_even_6 <= 32'd0;
    byte_addr_rt <= 0;
    byte_out_availible <= 1'b0;
    unit_op_0 <= 1'b0;
    unit_op_1 <= 1'b0;
    unit_op_2 <= 1'b0;
    unit_op_3 <= 1'b0;
    unit_op_4 <= 1'b0;
    unit_op_5 <= 1'b0;
    unit_op_6 <= 1'b0;
    end
	
    else if (unit_reset)
    begin
    op_11_even_d <= 0;
    byte_unit_sel_d <= 0;
    inst_even_d <= 0;
    {ra_data_even_d, rb_data_even_d} <= 0;
    byte_output_0 <= 128'd0;
    byte_output_1 <= 128'd0;
    byte_output_2 <= 128'd0;
    byte_output_3 <= 128'd0;
    byte_output_4 <= 128'd0;
    byte_output <= 128'd0;
    
    addr_rt_even_0 <= 32'd0;
    addr_rt_even_1 <= 32'd0;
    addr_rt_even_2 <= 32'd0;
    addr_rt_even_3 <= 32'd0;
    addr_rt_even_4 <= 32'd0;
    addr_rt_even_5 <= 32'd0;
    addr_rt_even_6 <= 32'd0;
    byte_addr_rt <= 0;
    byte_out_availible <= 1'b0;
    unit_op_0 <= 1'b0;
    unit_op_1 <= 1'b0;
    unit_op_2 <= 1'b0;
    unit_op_3 <= 1'b0;
    unit_op_4 <= 1'b0;
    unit_op_5 <= 1'b0;
    unit_op_6 <= 1'b0;
    end
    
    else begin
    byte_unit_sel_d <= byte_unit_sel;  
    
    if (byte_unit_sel)begin
    op_11_even_d <= op_11_even;
    inst_even_d <= inst_even;
    {ra_data_even_d, rb_data_even_d} <= {ra_data_even, rb_data_even}; end 
    
    else begin
     op_11_even_d <= 0;
    inst_even_d <= 0;
    {ra_data_even_d, rb_data_even_d} <= 0; 
    end
    
    byte_output <= result;         //----- FIXEDPOINT UNIT OUTPUT PIPELINED
//     byte_output_1 <= byte_output_0;
//     byte_output_2 <= byte_output_1;
//     byte_output_3 <= byte_output_2;
//     byte_output_4 <= byte_output_3;
//     byte_output <= byte_output_4;
    
        //----- RT ADDRESS OUTPUT PIPELINED
//     addr_rt_even_1 <= addr_rt_even_0;
//     addr_rt_even_2 <= addr_rt_even_1;
//     addr_rt_even_3 <= addr_rt_even_2;
//     addr_rt_even_4 <= addr_rt_even_3;
//     addr_rt_even_5 <= addr_rt_even_4;
//     byte_addr_rt <= addr_rt_even_5;
    
    
    if(byte_unit_sel_d)
    begin byte_out_availible <= 1'b1; byte_addr_rt <= inst_even_d[25:31];end
    
    else
    begin byte_out_availible <= 1'b0; byte_addr_rt <= 0;end
    
//     unit_op_1 <= unit_op_0;    //----- FIXEDPOINT UNIT OUTPUT AVAILIBLE BIT PIPELINED
//     unit_op_2 <= unit_op_1;
//     unit_op_3 <= unit_op_2;
//     unit_op_4 <= unit_op_3;
//     unit_op_5 <= unit_op_4;
//     byte_out_availible <= unit_op_5;
    end
end    
endmodule
