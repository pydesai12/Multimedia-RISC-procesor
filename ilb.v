//The ILB receives 32 instructions every cycle (128-bytes), which are then stored
//in the buffer for the duration of the entire 32-cycle period. Two instructions
//are passed out every cycle. All it receives as an input is the instuction pointer
//(address, ranging from 0 to 32) and the instruction set.

`timescale 1ns/10ps
`include "opcode.h"
module ilb(/*OUTPUTS*/  instruction1, instruction2, // to decode unit
	   /*INPUTS*/   reset,fetch_reset,
			inst_number, //comes from fetch module 
			inst_set);   // comes from local store unit

input  reset,fetch_reset;
input [0:1023] inst_set; 
input [0:4] inst_number;
output reg [0:31] instruction1, instruction2;
reg [0:31] insts[0:31]; //The array holding 32 instructions


//for testing which inst get what data registers
// reg [0:31]a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,az,bz,cz,dz,ez,fz;



always @ (inst_set)
begin
  insts[31] = inst_set[0:31];      insts[30] = inst_set[32:63];
  insts[29] = inst_set[64:95];     insts[28] = inst_set[96:127];
  insts[27] = inst_set[128:159];   insts[26] = inst_set[160:191];
  insts[25] = inst_set[192:223];   insts[24] = inst_set[224:255];
  insts[23] = inst_set[256:287];   insts[22] = inst_set[288:319];
  insts[21] = inst_set[320:351];  insts[20] = inst_set[352:383];
  insts[19] = inst_set[384:415];  insts[18] = inst_set[416:447];
  insts[17] = inst_set[448:479];  insts[16] = inst_set[480:511];
  insts[15] = inst_set[512:543];  insts[14] = inst_set[544:575];
  insts[13] = inst_set[576:607];  insts[12] = inst_set[608:639];
  insts[11] = inst_set[640:671];  insts[10] = inst_set[672:703];
  insts[9] = inst_set[704:735];  insts[8] = inst_set[736:767];
  insts[7] = inst_set[768:799];  insts[6] = inst_set[800:831];
  insts[5] = inst_set[832:863];  insts[4] = inst_set[864:895];
  insts[3] = inst_set[896:927];  insts[2] = inst_set[928:959];
  insts[1] = inst_set[960:991];  insts[0] = inst_set[992:1023];
  
  
  //

//   // for testing which instrucion gets what data//   -------------------------------------
//   fz = inst_set[0:31];      ez = inst_set[32:63];
//   dz = inst_set[64:95];     cz = inst_set[96:127];
//   bz = inst_set[128:159];   az = inst_set[160:191];
//   z = inst_set[192:223];   y = inst_set[224:255];
//   x = inst_set[256:287];   w = inst_set[288:319];
//   v = inst_set[320:351];  u = inst_set[352:383];
//   t = inst_set[384:415];  s = inst_set[416:447];
//   r = inst_set[448:479];  q = inst_set[480:511];
//   p = inst_set[512:543];  o = inst_set[544:575];
//   n = inst_set[576:607];  m = inst_set[608:639];
//   l = inst_set[640:671];  k = inst_set[672:703];
//   j= inst_set[704:735];  i= inst_set[736:767];
//   h= inst_set[768:799];  g= inst_set[800:831];
//   f= inst_set[832:863];  e= inst_set[864:895];
//   d= inst_set[896:927];  c= inst_set[928:959];
//   b= inst_set[960:991];  a= inst_set[992:1023];
  

  
// // to test in reverse ordering  --------------------------------------------------
//     insts[0] = inst_set[0:31];      insts[1] = inst_set[32:63];
//   insts[2] = inst_set[64:95];     insts[3] = inst_set[96:127];
//   insts[4] = inst_set[128:159];   insts[5] = inst_set[160:191];
//   insts[6] = inst_set[192:223];   insts[7] = inst_set[224:255];
//   insts[8] = inst_set[256:287];   insts[9] = inst_set[288:319];
//   insts[10] = inst_set[320:351];  insts[11] = inst_set[352:383];
//   insts[12] = inst_set[384:415];  insts[13] = inst_set[416:447];
//   insts[14] = inst_set[448:479];  insts[15] = inst_set[480:511];
//   insts[16] = inst_set[512:543];  insts[17] = inst_set[544:575];
//   insts[18] = inst_set[576:607];  insts[19] = inst_set[608:639];
//   insts[20] = inst_set[640:671];  insts[21] = inst_set[672:703];
//   insts[22] = inst_set[704:735];  insts[23] = inst_set[736:767];
//   insts[24] = inst_set[768:799];  insts[25] = inst_set[800:831];
//   insts[26] = inst_set[832:863];  insts[27] = inst_set[864:895];
//   insts[28] = inst_set[896:927];  insts[29] = inst_set[928:959];
//   insts[30] = inst_set[960:991];  insts[31] = inst_set[992:1023];
  
  ///
  
  

end


always @ (*) 
begin
  if (reset | fetch_reset) 
  begin
//   temp1 = 32'b0;
//   temp2 = 32'b0;
  instruction1 = 0;
  instruction2 = 0;
  end

  else 
  begin



//     $display ("instruction 1 is %h ",inst_set[0:31]);
//     $display ("instruction 2 is %h ",inst_set[32:63]);
  if (inst_number % 2 == 1) 
  begin
    instruction1 = insts[inst_number];
    instruction2 = `NOP;
  end

  else 
  begin
    instruction1 = insts[inst_number];
    instruction2 = insts[inst_number+1];
  end

//   instruction1 = temp1; 
//   instruction2 = temp2;
  end
end 
endmodule 