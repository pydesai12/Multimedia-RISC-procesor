/* This file contains the operation codes definition for instructions */

/* 11 bits Opcodes */
//-----------------------------
`define LQX     11'b00111000100
`define STQX    11'b00101000100
`define AH      11'b00011001000
`define SFH     11'b00001001000
`define BG      11'b00001000010
`define MPY     11'b01111000100
`define MPYU    11'b01111001100
`define CNTB    11'b01010110100
`define GBB     11'b00110110010
`define GB      11'b00110110000
`define AVGB    11'b00011010011
`define AND     11'b00011000001
`define OR      11'b00001000001
`define XOR     11'b01001000001
`define NAND    11'b00011001001
`define NOR     11'b00001001001
`define EQV     11'b01001001001
`define SHLQBI  11'b00111011011
`define SHLQBY  11'b00111011111
`define ROTQBI  11'b00111011000
`define ROTQBY  11'b00111011100

`define ROTQMBY 11'b00111011101

`define CEQB    11'b01111010000
`define CEQH    11'b01111001000
`define CGTB    11'b01001010000
`define CGT     11'b01001000000
`define NOP     11'b01000000001
//-----------------------------


/* 9 bits Opcodes */
//-----------------------------
`define LQA  9'b001100001
`define STQA 9'b001000001
`define ILH  9'b010000011
`define IL   9'b010000001
`define BR   9'b001100100
`define BRNZ 9'b001000010
`define BRZ  9'b001000000
`define BRA  9'b001100000
//-----------------------------


/* 8 bits Opcodes */
//-----------------------------
`define LQD   8'b00110100
`define STQD  8'b00100100
`define AHI   8'b00011101
`define MPYI  8'b01110100
`define ANDHI 8'b00010101
`define ORHI  8'b00000101
`define XORHI  8'b01000100
`define CEQBI 8'b01111110
`define CGTI  8'b01001100
//-----------------------------


/* 7 bits Opcodes */
//-----------------------------
`define ILA 7'b0100001
//-----------------------------


