`timescale 1ns/10ps
`include "opcode.h"
module top_test;

reg clk,reset;
reg [0:6] instuction_address;
reg [0:1023] inst_2_local;
reg write;


initial  begin
  clk = 1'b1;
end

  always
  begin
  #10 clk <= ~clk;
  end

initial begin
$dumpfile ("top.vcd");
$dumpvars (0,top_test);
end

top top_inst(/*regs*/  clk,reset,instuction_address,inst_2_local,write);

initial
begin
reset=1'b1; instuction_address = 0; inst_2_local = 0; write = 0;
#10 reset =1'b0;

#6 reset=1'b0; instuction_address = 0;write = 1'b1;

inst_2_local = {


                `BRNZ,16'd0,7'd34,



                

                `ILA,18'h1234,7'd35,
                `AVGB,7'd32,7'd33,7'd34,

                `SFH,7'd29,7'd30,7'd31,  //structural hazard
                `GB,7'd0,7'd27,7'd28,

                `ROTQMBY,7'd24,7'd25,7'd26,
                `ANDHI,10'd123,7'd22,7'd23,

                `ROTQBY,7'd19,7'd20,7'd21,
                `GBB,7'd0,7'd17,7'd18,

                `ROTQBI, 7'd13,7'd15,7'd16,
                `XORHI,10'd123,7'd12,7'd13,

                `SHLQBY,7'd9,7'd10,7'd11,
                `CNTB,7'd0,7'd7,7'd8,

                `SHLQBI,7'd4,7'd5,7'd6,
                `AH,7'd1,7'd2,7'd3};

                
                
/*inst_2_local = {`AH,7'd1,7'd2,7'd3,
                `SHLQBI,7'd4,7'd5,7'd6,
                
                `CNTB,7'd0,7'd7,7'd8,
                `SHLQBY,7'd9,7'd10,7'd11,
                
                `XORHI,10'd123,7'd12,7'd13,
                `ROTQBI, 7'd14,7'd15,7'd16,
                
                `GBB,7'd0,7'd17,7'd18,
                `ROTQBY,7'd19,7'd20,7'd21,
                
                `ANDHI,10'd123,7'd22,7'd23,
                `ROTQMBY,7'd24,7'd25,7'd26,
                
                `GB,7'd0,7'd27,7'd28,
                `SFH,7'd29,7'd30,7'd31,  //structural hazard
                
                `AVGB,7'd32,7'd33,7'd34,
                `ILA,18'h1234,7'd35

                };   */             
                
//--------------------- no hazard code              
//     inst_2_local = {
//                     `ILA,18'd95,7'd96,
//                     `CGTI,10'h94,7'd93,7'd92, 
//     
//                     `ILH,16'd90,7'd91,
//                     `CEQBI,10'h89,7'd88,7'd87,     
//     
// 
// 
//     
//     
//                     `LQA,16'd80,7'd81,
//                     `AVGB,7'd79,7'd78,7'd77,
//                     
//                     `ROTQMBY,7'd74,7'd75,7'd76,
//                     `GB,7'd71,7'd72,7'd73, 
//                     
//                     
//                     `SHLQBI,7'd64,7'd63,7'd62,     //RAW Hazard
//                     `ANDHI,10'd59,7'd65,7'd61,
//                     
//                     
//                     `SHLQBY,7'd68,7'd69,7'd70,     //RAW Hazard               
//                     `GBB,7'd67,7'd66,7'd65, 
//                     
// 
//   
//   
//   /*
//                     `ANDHI,10'd83,7'd84,7'd85, 
//                     `XORI,10'd84,7'd83,7'd82,      // structural hazard */
//   
//   
//   
//   
//   
//   
//   
//   
// /////////////////////////////////////////////////////////////  
//     
//     
//     
//     
//                     `ILA,18'd47,7'd46,
//                     `CGTI,10'h43,7'd44,7'd45, 
//     
//                     `ILH,16'd42,7'd41,
//                     `CEQBI,10'h38,7'd39,7'd40,     
//     
// 
//                     `ROTQBY,7'd36,7'd37,7'd100,
//                     `XORI,10'd35,7'd34,7'd33,  
//     
//     
//                     `ROTQBI,7'd31,7'd32,7'd99,
//                     `AVGB,7'd28,7'd29,7'd30,
//                     
//                     `ROTQMBY,7'd25,7'd26,7'd27,
//                     `GB,7'd22,7'd23,7'd24, 
//                     
//                     `SHLQBY,7'd19,7'd20,7'd21,                    
//                     `GBB,7'd16,7'd17,7'd18, 
//                     
//                     `SHLQBI,7'd13,7'd14,7'd15,
//                     `CNTB,7'd11,7'd10,7'd12 
//                     };
            
#44  write = 1'b0;                        
// #5 fix_unit_sel = 1'b1; 
//    {op_11_even, op_8_even} = 2'b01;   
//    inst_in_even = {`AHI,10'd9,14'd00}; ra_data_even = 128'd4; rb_data_even = 128'd6;

// inst_in_even = {`AH,7'h14,7'h15,7'h16}; ra_data_even = 128'd6; rb_data_even = 128'd3;
// #90 inst_in_even = {`SFH,7'h14,7'h15,7'h17}; ra_data_even = 128'd4; rb_data_even = 128'd5;
// #90 inst_in_even = {`MPY,7'h14,7'h15,7'h21}; ra_data_even = 128'd4; rb_data_even = 128'd6;
// #90 inst_in_even = {`CEQB,7'h14,7'h15,7'h29};ra_data_even = 128'd4; rb_data_even = 128'd4;
// #90 inst_in_even = {`CEQH,7'h14,7'h15,7'h30};ra_data_even = 128'd4; rb_data_even = 128'd4;
// #90 inst_in_even = {`SF,7'h14,7'h15,7'h18};  ra_data_even = 128'd3; rb_data_even = 128'd6;
// #90 inst_in_even = {`CG,7'h14,7'h15,7'h19};  ra_data_even = {1'b1,127'd4}; rb_data_even = {1'b1,127'd4};
// #90 inst_in_even = {`BG,7'h14,7'h15,7'h20};  ra_data_even = 128'd6; rb_data_even = 128'd5;

// #90 inst_in_even = {`MPYU,7'h14,7'h15,7'h22};ra_data_even = 128'd4; rb_data_even = 128'd6;
// #90 inst_in_even = {`AND,7'h14,7'h15,7'h23}; ra_data_even = 128'd4; rb_data_even = 128'd6;
// #90 inst_in_even = {`OR,7'h14,7'h15,7'h24};  ra_data_even = 128'd4; rb_data_even = 128'd6;
// #90 inst_in_even = {`XOR,7'h14,7'h15,7'h25}; ra_data_even = 128'd4; rb_data_even = 128'd6;
// #90 inst_in_even = {`NAND,7'h14,7'h15,7'h26};ra_data_even = 128'd4; rb_data_even = 128'd6;
// #90 inst_in_even = {`NOR,7'h14,7'h15,7'h27}; ra_data_even = 128'd4; rb_data_even = 128'd6;
// #90 inst_in_even = {`EQV,7'h14,7'h15,7'h28}; ra_data_even = 128'd4; rb_data_even = 128'd4;

// #90 inst_in_even = {`CGTB,7'h14,7'h15,7'h31};ra_data_even = 128'd6; rb_data_even = 128'd4;
// #90 inst_in_even = {`CGT,7'h14,7'h15,7'h32}; ra_data_even = 128'd6; rb_data_even = 128'd4;
// 






#2000 $finish;
end

endmodule 





