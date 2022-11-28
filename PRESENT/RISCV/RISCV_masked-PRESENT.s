//////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// RISC-V masked PRESENT /////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////


.text

.macro rorA reg,dist
    srli  s8, \reg, \dist
    slli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s8
    add s8, zero, zero // CLEAR
.endm

.macro rolA reg,dist
    slli  s8, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s8
    add s8, zero, zero // CLEAR
.endm


.macro ror8_1 reg
    andi  s11, \reg, 0x01
    slli s11, s11, 7
    andi  \reg, \reg, 0xfe
    srli  \reg, \reg, 1
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero // CLEAR
    add s10, zero, zero // CLEAR
.endm

.macro ror8_2 reg
    andi  s11, \reg, 0x03
    slli s11, s11, 6
    andi  \reg, \reg, 0xfc
    srli  \reg, \reg, 2
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero // CLEAR
    add s10, zero, zero // CLEAR
.endm

.macro rol8_1 reg
    andi  s11, \reg, 0x80
    srli s11, s11, 7
    andi  \reg, \reg, 0x7f
    slli  \reg, \reg, 1
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero // CLEAR
    add s10, zero, zero // CLEAR
.endm

.macro rol8_2 reg
    andi  s11, \reg, 0xC0
    srli s11, s11, 6
    andi  \reg, \reg, 0x3f
    slli  \reg, \reg, 2
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero // CLEAR
    add s10, zero, zero // CLEAR
.endm


.macro big_ror_1 reg
    // p1
    andi s8, \reg, 0xFF
    // p2
    srli s9, \reg, 8
    ror8_1 s8
    ror8_1 s9
    slli s9, s9, 8
    xor \reg, s8, s9
    add s8, zero, zero // CLEAR
    add s9, zero, zero // CLEAR
.endm


.macro big_ror_2 reg
    // p1
    andi s8, \reg, 0xFF
    // p2
    srli s9, \reg, 8
    ror8_2 s8
    ror8_2 s9
    slli s9, s9, 8
    xor \reg, s8, s9
    add s8, zero, zero // CLEAR
    add s9, zero, zero // CLEAR
.endm

.macro big_rol_1 reg
    // p1
    andi s8, \reg, 0xFF
    // p2
    srli s9, \reg, 8
    rol8_1 s8
    rol8_1 s9
    slli s9, s9, 8
    xor \reg, s8, s9
    add s8, zero, zero // CLEAR
    add s9, zero, zero // CLEAR
.endm

.macro big_rol_2 reg
    // p1
    andi s8, \reg, 0xFF
    // p2
    srli s9, \reg, 8
    rol8_2 s8
    rol8_2 s9
    slli s9, s9, 8
    xor \reg, s8, s9
    add s8, zero, zero // CLEAR
    add s9, zero, zero // CLEAR
.endm

///////////////////////////////////////////////////////////////////////
/////////////////////////// sbox //////////////////////////////////////
///////////////////////////////////////////////////////////////////////


.global A
.balign 4
A:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    sw t0, -12(fp)
    sw t1, -16(fp)
    sw t2, -20(fp)
    sw t3, -24(fp)

    
    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv t3, a3
    mv a2, t3
    xor a3, t1, t2

    lw t0, -12(fp)
    lw t1, -16(fp)
    lw t2, -20(fp)
    lw t3, -24(fp)

    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64

ret


.global Ap
.balign 4
Ap:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    sw t0, -12(fp)
    sw t1, -16(fp)
    sw t2, -20(fp)
    sw t3, -24(fp)

    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv t3, a3

    xor a0, t0, t2
    xor a0, a0, t3
    mv a1, t0
    xor a3, t0, t1

    lw t0, -12(fp)
    lw t1, -16(fp)
    lw t2, -20(fp)
    lw t3, -24(fp)

    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64


ret

.global App
.balign 4
App:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    sw t0, -12(fp)
    sw t1, -16(fp)
    sw t2, -20(fp)
    sw t3, -24(fp)

    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv t3, a3

    xor a1, t2, t3
    xor a2, t0, t1
    xor a2, a2, t3
    addi t0, zero, 0xFF
    slli t0, t0, 8
    xori t0, t0, 0XFF
    xor a2, a2, t0
    xor a3, t2, t0


    lw t0, -12(fp)
    lw t1, -16(fp)
    lw t2, -20(fp)
    lw t3, -24(fp)

    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64

ret


.global App_b
.balign 4
App_b:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    sw t0, -12(fp)
    sw t1, -16(fp)
    sw t2, -20(fp)
    sw t3, -24(fp)

    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv t3, a3

    xor a1, t2, t3
    xor a2, t0, t1
    xor a2, a2, t3
    mv a3, t2


    lw t0, -12(fp)
    lw t1, -16(fp)
    lw t2, -20(fp)
    lw t3, -24(fp)

    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64

ret


.global Appp
.balign 4
Appp:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    sw t0, -12(fp)
    sw t1, -16(fp)
    sw t2, -20(fp)
    sw t3, -24(fp)

    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv t3, a3

    xor a0, t0, t1
    mv a1, t0
    xor a2, t0, t1
    xor a2, a2, t2
    xor a2, a2, t3

    addi t0, zero, 0xFF
    slli t0, t0, 8
    xori t0, t0, 0XFF
    xor a3, t3, t0
        lw t0, -12(fp)
    lw t1, -16(fp)
    lw t2, -20(fp)
    lw t3, -24(fp)

    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
ret

.global Appp_b
.balign 4
Appp_b:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    sw t0, -12(fp)
    sw t1, -16(fp)
    sw t2, -20(fp)
    sw t3, -24(fp)

    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv t3, a3

    xor a0, t0, t1
    mv a1, t0
    xor a2, t0, t1
    xor a2, a2, t2
    xor a2, a2, t3


    lw t0, -12(fp)
    lw t1, -16(fp)
    lw t2, -20(fp)
    lw t3, -24(fp)

    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
ret


///////////////////////////////////////////////////////////////////////
/////////////////////////// sbox //////////////////////////////////////
///////////////////////////////////////////////////////////////////////


.global sbox
.balign 4
// a0 = shares0 
// a1 = shares1 

sbox:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    sw a0, -12(fp)
    sw a1, -16(fp)

    add s1, zero, zero
    add s2, zero, zero
    add s3, zero, zero
    add s4, zero, zero

    add t1, zero, zero
    add t2, zero, zero
    add t3, zero, zero
    add t4, zero, zero


    ////////////////////////////////////////
    ////////////////////////////////////////
    ///// Construct bitsliced format ///////
    ////////////////////////////////////////
    ////////////////////////////////////////



    ////////////////////////////////////////
    /////////////// SHARE A ////////////////
    ////////////////////////////////////////

    // ************ S1 REGISTER ************ //


    // FIRST SHARE part 2
    lw t5, 4(a0)

    srli t0, t5, 28 
    and t0, t0, 0x1
    slli t0, t0, 8
    or s1, s1, t0

    srli t0, t5, 24 
    and t0, t0, 0x1
    slli t0, t0, 9
    or s1, s1, t0

    srli t0, t5, 20 
    and t0, t0, 0x1
    slli t0, t0, 10
    or s1, s1, t0

    srli t0, t5, 16 
    and t0, t0, 0x1
    slli t0, t0, 11
    or s1, s1, t0

    srli t0, t5, 12 
    and t0, t0, 0x1
    slli t0, t0, 12
    or s1, s1, t0

    srli t0, t5, 8 
    and t0, t0, 0x1
    slli t0, t0, 13
    or s1, s1, t0

    srli t0, t5, 4 
    and t0, t0, 0x1
    slli t0, t0, 14
    or s1, s1, t0
    

    and t0, t5, 0x1 
    slli t0, t0, 15
    or s1, s1, t0

    // FIRST SHARE part 1
    lw t5, 0(a0)

    srli t0, t5, 28 
    and t0, t0, 0x1
    slli t0, t0, 0
    or s1, s1, t0

    srli t0, t5, 24 
    and t0, t0, 0x1
    slli t0, t0, 1
    or s1, s1, t0

    srli t0, t5, 20 
    and t0, t0, 0x1
    slli t0, t0, 2
    or s1, s1, t0

    srli t0, t5, 16 
    and t0, t0, 0x1
    slli t0, t0, 3
    or s1, s1, t0

    srli t0, t5, 12 
    and t0, t0, 0x1
    slli t0, t0, 4
    or s1, s1, t0

    srli t0, t5, 8 
    and t0, t0, 0x1
    slli t0, t0, 5
    or s1, s1, t0

    srli t0, t5, 4 
    and t0, t0, 0x1
    slli t0, t0, 6
    or s1, s1, t0
    

    and t0, t5, 0x1 
    slli t0, t0, 7
    or s1, s1, t0


    // ************ S2 REGISTER ************ //

    // FIRST SHARE part 2
    lw t5, 4(a0)

    srli t0, t5, 29 
    and t0, t0, 0x1
    slli t0, t0, 8
    or s2, s2, t0

    srli t0, t5, 25 
    and t0, t0, 0x1
    slli t0, t0, 9
    or s2, s2, t0

    srli t0, t5, 21 
    and t0, t0, 0x1
    slli t0, t0, 10
    or s2, s2, t0

    srli t0, t5, 17 
    and t0, t0, 0x1
    slli t0, t0, 11
    or s2, s2, t0

    srli t0, t5, 13 
    and t0, t0, 0x1
    slli t0, t0, 12
    or s2, s2, t0

    srli t0, t5, 9 
    and t0, t0, 0x1
    slli t0, t0, 13
    or s2, s2, t0

    srli t0, t5, 5 
    and t0, t0, 0x1
    slli t0, t0, 14
    or s2, s2, t0
    

    srli t0, t5, 1 
    and t0, t0, 0x1 
    slli t0, t0, 15
    or s2, s2, t0

    // FIRST SHARE part 1
    lw t5, 0(a0)

    srli t0, t5, 29 
    and t0, t0, 0x1
    slli t0, t0, 0
    or s2, s2, t0

    srli t0, t5, 25 
    and t0, t0, 0x1
    slli t0, t0, 1
    or s2, s2, t0

    srli t0, t5, 21 
    and t0, t0, 0x1
    slli t0, t0, 2
    or s2, s2, t0

    srli t0, t5, 17 
    and t0, t0, 0x1
    slli t0, t0, 3
    or s2, s2, t0

    srli t0, t5, 13 
    and t0, t0, 0x1
    slli t0, t0, 4
    or s2, s2, t0

    srli t0, t5, 9 
    and t0, t0, 0x1
    slli t0, t0, 5
    or s2, s2, t0

    srli t0, t5, 5 
    and t0, t0, 0x1
    slli t0, t0, 6
    or s2, s2, t0
    

    srli t0, t5, 1 
    and t0, t0, 0x1 
    slli t0, t0, 7
    or s2, s2, t0

    // ************ S3 REGISTER ************ //

    // FIRST SHARE part 2
    lw t5, 4(a0)

    srli t0, t5, 30 
    and t0, t0, 0x1
    slli t0, t0, 8
    or s3, s3, t0

    srli t0, t5, 26 
    and t0, t0, 0x1
    slli t0, t0, 9
    or s3, s3, t0

    srli t0, t5, 22 
    and t0, t0, 0x1
    slli t0, t0, 10
    or s3, s3, t0

    srli t0, t5, 18 
    and t0, t0, 0x1
    slli t0, t0, 11
    or s3, s3, t0

    srli t0, t5, 14 
    and t0, t0, 0x1
    slli t0, t0, 12
    or s3, s3, t0

    srli t0, t5, 10 
    and t0, t0, 0x1
    slli t0, t0, 13
    or s3, s3, t0

    srli t0, t5, 6 
    and t0, t0, 0x1
    slli t0, t0, 14
    or s3, s3, t0
    

    srli t0, t5, 2 
    and t0, t0, 0x1 
    slli t0, t0, 15
    or s3, s3, t0

    // FIRST SHARE part 1
    lw t5, 0(a0)

    srli t0, t5, 30 
    and t0, t0, 0x1
    slli t0, t0, 0
    or s3, s3, t0

    srli t0, t5, 26 
    and t0, t0, 0x1
    slli t0, t0, 1
    or s3, s3, t0

    srli t0, t5, 22 
    and t0, t0, 0x1
    slli t0, t0, 2
    or s3, s3, t0

    srli t0, t5, 18 
    and t0, t0, 0x1
    slli t0, t0, 3
    or s3, s3, t0

    srli t0, t5, 14 
    and t0, t0, 0x1
    slli t0, t0, 4
    or s3, s3, t0

    srli t0, t5, 10 
    and t0, t0, 0x1
    slli t0, t0, 5
    or s3, s3, t0

    srli t0, t5, 6 
    and t0, t0, 0x1
    slli t0, t0, 6
    or s3, s3, t0
    

    srli t0, t5, 2 
    and t0, t0, 0x1 
    slli t0, t0, 7
    or s3, s3, t0


    // ************ S4 REGISTER ************ //

    // FIRST SHARE part 2
    lw t5, 4(a0)

    srli t0, t5, 31 
    and t0, t0, 0x1
    slli t0, t0, 8
    or s4, s4, t0

    srli t0, t5, 27 
    and t0, t0, 0x1
    slli t0, t0, 9
    or s4, s4, t0

    srli t0, t5, 23 
    and t0, t0, 0x1
    slli t0, t0, 10
    or s4, s4, t0

    srli t0, t5, 19 
    and t0, t0, 0x1
    slli t0, t0, 11
    or s4, s4, t0

    srli t0, t5, 15 
    and t0, t0, 0x1
    slli t0, t0, 12
    or s4, s4, t0

    srli t0, t5, 11 
    and t0, t0, 0x1
    slli t0, t0, 13
    or s4, s4, t0

    srli t0, t5, 7 
    and t0, t0, 0x1
    slli t0, t0, 14
    or s4, s4, t0
    

    srli t0, t5, 3 
    and t0, t0, 0x1 
    slli t0, t0, 15
    or s4, s4, t0

    // FIRST SHARE part 1
    lw t5, 0(a0)

    srli t0, t5, 31 
    and t0, t0, 0x1
    slli t0, t0, 0
    or s4, s4, t0

    srli t0, t5, 27 
    and t0, t0, 0x1
    slli t0, t0, 1
    or s4, s4, t0

    srli t0, t5, 23 
    and t0, t0, 0x1
    slli t0, t0, 2
    or s4, s4, t0

    srli t0, t5, 19 
    and t0, t0, 0x1
    slli t0, t0, 3
    or s4, s4, t0

    srli t0, t5, 15 
    and t0, t0, 0x1
    slli t0, t0, 4
    or s4, s4, t0

    srli t0, t5, 11 
    and t0, t0, 0x1
    slli t0, t0, 5
    or s4, s4, t0

    srli t0, t5, 7 
    and t0, t0, 0x1
    slli t0, t0, 6
    or s4, s4, t0
    

    srli t0, t5, 3 
    and t0, t0, 0x1 
    slli t0, t0, 7
    or s4, s4, t0


    ////////////////////////////////////////
    /////////////// SHARE B ////////////////
    ////////////////////////////////////////


    // ************ t1 REGISTER ************ //


    // SECOND SHARE part 2
    lw t5, 4(a1)
    

    srli t0, t5, 23 
    and t0, t0, 0x1
    slli t0, t0, 8 
    or t1, t1, t0

    srli t0, t5, 19 
    and t0, t0, 0x1
    slli t0, t0, 9
    or t1, t1, t0

    srli t0, t5, 15 
    and t0, t0, 0x1
    slli t0, t0, 10
    or t1, t1, t0

    srli t0, t5, 11 
    and t0, t0, 0x1
    slli t0, t0, 11
    or t1, t1, t0

    srli t0, t5, 7 
    and t0, t0, 0x1
    slli t0, t0, 12
    or t1, t1, t0

    srli t0, t5, 3 
    and t0, t0, 0x1
    slli t0, t0, 13
    or t1, t1, t0

    srli t0, t5, 31 
    and t0, t0, 0x1
    slli t0, t0, 14
    or t1, t1, t0
    

    srli t0, t5, 27 
    and t0, t0, 0x1 
    slli t0, t0, 15
    or t1, t1, t0

    // SECOND SHARE part 1
    lw t5, 0(a1)
    

    srli t0, t5, 23 
    and t0, t0, 0x1
    slli t0, t0, 0
    or t1, t1, t0

    srli t0, t5, 19 
    and t0, t0, 0x1
    slli t0, t0, 1
    or t1, t1, t0

    srli t0, t5, 15 
    and t0, t0, 0x1
    slli t0, t0, 2
    or t1, t1, t0

    srli t0, t5, 11 
    and t0, t0, 0x1
    slli t0, t0, 3
    or t1, t1, t0

    srli t0, t5, 7 
    and t0, t0, 0x1
    slli t0, t0, 4
    or t1, t1, t0

    srli t0, t5, 3 
    and t0, t0, 0x1
    slli t0, t0, 5
    or t1, t1, t0

    srli t0, t5, 31 
    and t0, t0, 0x1
    slli t0, t0, 6
    or t1, t1, t0
    

    srli t0, t5, 27 
    and t0, t0, 0x1 
    slli t0, t0, 7
    or t1, t1, t0


    // ************ t2 REGISTER ************ //

    // SECOND SHARE part 2
    lw t5, 4(a1)
    

    srli t0, t5, 24 
    and t0, t0, 0x1
    slli t0, t0, 8
    or t2, t2, t0

    srli t0, t5, 20 
    and t0, t0, 0x1
    slli t0, t0, 9
    or t2, t2, t0

    srli t0, t5, 16 
    and t0, t0, 0x1
    slli t0, t0, 10
    or t2, t2, t0

    srli t0, t5, 12 
    and t0, t0, 0x1
    slli t0, t0, 11
    or t2, t2, t0

    srli t0, t5, 8 
    and t0, t0, 0x1
    slli t0, t0, 12
    or t2, t2, t0

    srli t0, t5, 4 
    and t0, t0, 0x1
    slli t0, t0, 13
    or t2, t2, t0

    srli t0, t5, 0 
    and t0, t0, 0x1
    slli t0, t0, 14
    or t2, t2, t0
    

    srli t0, t5, 28 
    and t0, t0, 0x1 
    slli t0, t0, 15
    or t2, t2, t0

    // SECOND SHARE part 1
    lw t5, 0(a1)
    

    srli t0, t5, 24 
    and t0, t0, 0x1
    slli t0, t0, 0
    or t2, t2, t0

    srli t0, t5, 20 
    and t0, t0, 0x1
    slli t0, t0, 1
    or t2, t2, t0

    srli t0, t5, 16 
    and t0, t0, 0x1
    slli t0, t0, 2
    or t2, t2, t0

    srli t0, t5, 12 
    and t0, t0, 0x1
    slli t0, t0, 3
    or t2, t2, t0

    srli t0, t5, 8 
    and t0, t0, 0x1
    slli t0, t0, 4
    or t2, t2, t0

    srli t0, t5, 4 
    and t0, t0, 0x1
    slli t0, t0, 5
    or t2, t2, t0

    srli t0, t5, 0 
    and t0, t0, 0x1
    slli t0, t0, 6
    or t2, t2, t0
    

    srli t0, t5, 28 
    and t0, t0, 0x1 
    slli t0, t0, 7
    or t2, t2, t0

    // ************ t3 REGISTER ************ //

    // SECOND SHARE part 2
    lw t5, 4(a1)
    

    srli t0, t5, 25 
    and t0, t0, 0x1
    slli t0, t0, 8
    or t3, t3, t0

    srli t0, t5, 21 
    and t0, t0, 0x1
    slli t0, t0, 9
    or t3, t3, t0

    srli t0, t5, 17 
    and t0, t0, 0x1
    slli t0, t0, 10
    or t3, t3, t0

    srli t0, t5, 13 
    and t0, t0, 0x1
    slli t0, t0, 11
    or t3, t3, t0

    srli t0, t5, 9 
    and t0, t0, 0x1
    slli t0, t0, 12
    or t3, t3, t0

    srli t0, t5, 5 
    and t0, t0, 0x1
    slli t0, t0, 13
    or t3, t3, t0

    srli t0, t5, 1 
    and t0, t0, 0x1
    slli t0, t0, 14
    or t3, t3, t0
    

    srli t0, t5, 29 
    and t0, t0, 0x1 
    slli t0, t0, 15
    or t3, t3, t0

    // SECOND SHARE part 1
    lw t5, 0(a1)
    

    srli t0, t5, 25 
    and t0, t0, 0x1
    slli t0, t0, 0
    or t3, t3, t0

    srli t0, t5, 21 
    and t0, t0, 0x1
    slli t0, t0, 1
    or t3, t3, t0

    srli t0, t5, 17 
    and t0, t0, 0x1
    slli t0, t0, 2
    or t3, t3, t0

    srli t0, t5, 13 
    and t0, t0, 0x1
    slli t0, t0, 3
    or t3, t3, t0

    srli t0, t5, 9 
    and t0, t0, 0x1
    slli t0, t0, 4
    or t3, t3, t0

    srli t0, t5, 5 
    and t0, t0, 0x1
    slli t0, t0, 5
    or t3, t3, t0

    srli t0, t5, 1 
    and t0, t0, 0x1
    slli t0, t0, 6
    or t3, t3, t0
    

    srli t0, t5, 29 
    and t0, t0, 0x1 
    slli t0, t0, 7
    or t3, t3, t0


    // ************ t4 REGISTER ************ //

    // SECOND SHARE part 2
    lw t5, 4(a1)
    

    srli t0, t5, 26 
    and t0, t0, 0x1
    slli t0, t0, 8
    or t4, t4, t0

    srli t0, t5, 22 
    and t0, t0, 0x1
    slli t0, t0, 9
    or t4, t4, t0

    srli t0, t5, 18 
    and t0, t0, 0x1
    slli t0, t0, 10
    or t4, t4, t0

    srli t0, t5, 14 
    and t0, t0, 0x1
    slli t0, t0, 11
    or t4, t4, t0

    srli t0, t5, 10 
    and t0, t0, 0x1
    slli t0, t0, 12
    or t4, t4, t0

    srli t0, t5, 6 
    and t0, t0, 0x1
    slli t0, t0, 13
    or t4, t4, t0

    srli t0, t5, 2 
    and t0, t0, 0x1
    slli t0, t0, 14
    or t4, t4, t0
    

    srli t0, t5, 30 
    and t0, t0, 0x1 
    slli t0, t0, 15
    or t4, t4, t0

    // SECOND SHARE part 1
    lw t5, 0(a1)
    

    srli t0, t5, 26 
    and t0, t0, 0x1
    slli t0, t0, 0
    or t4, t4, t0

    srli t0, t5, 22 
    and t0, t0, 0x1
    slli t0, t0, 1
    or t4, t4, t0

    srli t0, t5, 18 
    and t0, t0, 0x1
    slli t0, t0, 2
    or t4, t4, t0

    srli t0, t5, 14 
    and t0, t0, 0x1
    slli t0, t0, 3
    or t4, t4, t0

    srli t0, t5, 10 
    and t0, t0, 0x1
    slli t0, t0, 4
    or t4, t4, t0

    srli t0, t5, 6 
    and t0, t0, 0x1
    slli t0, t0, 5
    or t4, t4, t0

    srli t0, t5, 2 
    and t0, t0, 0x1
    slli t0, t0, 6
    or t4, t4, t0
    

    srli t0, t5, 30 
    and t0, t0, 0x1 
    slli t0, t0, 7
    or t4, t4, t0



    ////////////////////////////////////////////
    ///////////////// NOW SBOX /////////////////
    ////////////////////////////////////////////


    ///////////////////////////////// A //////////////////////////////
    // shares A
    mv a0, s1
    mv a1, s2
    mv a2, s3
    mv a3, s4
    jal A
    mv s1, a0
    mv s2, a1
    mv s3, a2
    mv s4, a3

    // shares B
    mv a0, t1
    mv a1, t2
    mv a2, t3
    mv a3, t4
    jal A
    mv t1, a0
    mv t2, a1
    mv t3, a2
    mv t4, a3

    ///////////////////////////////// Q12 //////////////////////////////

    /////////// PTs(b,a,c) ///////////


    and s5, s4, s2 // a0c0
    xor s3, s3, s5 // s3 + a0c0

    ////////////// s3 + a0c0 + a0c1
    // a0c1
    big_ror_2 s4
    big_ror_1 t2
    and s5, s4, t2
    big_rol_2 s4
    big_rol_1 t2
    big_ror_2 s3
    xor s3, s3, s5
    big_rol_2 s3


    ////////////// t3 + a1c1
    // a1c1
    and s5, t4, t2
    xor t3, t3, s5
    ////////////// t3 + a1c1 + a1c0
    // a1c0
    big_ror_2 s2
    big_ror_1 t4
    and s5, s2, t4
    big_rol_2 s2
    big_rol_1 t4
    big_ror_1 t3
    xor t3, t3, s5
    big_rol_1 t3


    /////////// PTs(c,a,b) ///////////
    ////////////// s2 + b0c0
    // a0b0
    and s5, s4, s3
    xor s2, s2, s5

    ////////////// s2 + a0b0 + a0b1
    // a0b1
    big_ror_2 s4
    big_ror_1 t3
    and s5, s4, t3
    big_rol_2 s4
    big_rol_1 t3
    big_ror_2 s2
    xor s2, s2, s5
    big_rol_2 s2

    ////////////// t2 + a1b1
    // a1b1
    and s5, t4, t3
    xor t2, t2, s5

    ////////////// t2 + a1b1 + a1b0
    // a1b0
    big_ror_2 s3
    big_ror_1 t4
    and s5, s3, t4
    big_rol_2 s3
    big_rol_1 t4
    big_ror_1 t2
    xor t2, t2, s5
    big_rol_1 t2


   // shares A''
    mv a0, s1
    mv a1, s2
    mv a2, s3
    mv a3, s4
    jal App
    mv s1, a0
    mv s2, a1
    mv s3, a2
    mv s4, a3

    // shares B
    mv a0, t1
    mv a1, t2
    mv a2, t3
    mv a3, t4
    jal App_b
    mv t1, a0
    mv t2, a1
    mv t3, a2
    mv t4, a3


    ///////////////////////////////// A''' //////////////////////////////
    // shares A
    mv a0, s1
    mv a1, s2
    mv a2, s3
    mv a3, s4
    jal Appp
    mv s1, a0
    mv s2, a1
    mv s3, a2
    mv s4, a3

    // shares B
    mv a0, t1
    mv a1, t2
    mv a2, t3
    mv a3, t4
    jal Appp_b
    mv t1, a0
    mv t2, a1
    mv t3, a2
    mv t4, a3

    ///////////////////////////////// A //////////////////////////////
    // shares A
    mv a0, s1
    mv a1, s2
    mv a2, s3
    mv a3, s4
    jal A
    mv s1, a0
    mv s2, a1
    mv s3, a2
    mv s4, a3

    // shares B
    mv a0, t1
    mv a1, t2
    mv a2, t3
    mv a3, t4
    jal A
    mv t1, a0
    mv t2, a1
    mv t3, a2
    mv t4, a3


    ///////////////////////////////// Q12 //////////////////////////////

    /////////// PTs(b,a,c) ///////////


    and s5, s4, s2 // a0c0
    xor s3, s3, s5 // s3 + a0c0

    ////////////// s3 + a0c0 + a0c1
    // a0c1
    big_ror_2 s4
    big_ror_1 t2
    and s5, s4, t2
    big_rol_2 s4
    big_rol_1 t2
    big_ror_2 s3
    xor s3, s3, s5
    big_rol_2 s3
    ////////////// t3 + a1c1
    // a1c1
    and s5, t4, t2
    xor t3, t3, s5
    ////////////// t3 + a1c1 + a1c0
    // a1c0
    big_ror_2 s2
    big_ror_1 t4
    and s5, s2, t4
    big_rol_2 s2
    big_rol_1 t4
    big_ror_1 t3
    xor t3, t3, s5
    big_rol_1 t3


    /////////// PTs(c,a,b) ///////////
    ////////////// s2 + b0c0
    // a0b0
    and s5, s4, s3
    xor s2, s2, s5

    ////////////// s2 + a0b0 + a0b1
    // a0b1
    big_ror_2 s4
    big_ror_1 t3
    and s5, s4, t3
    big_rol_2 s4
    big_rol_1 t3
    big_ror_2 s2
    xor s2, s2, s5
    big_rol_2 s2

    ////////////// t2 + a1b1
    // a1b1
    and s5, t4, t3
    xor t2, t2, s5

    ////////////// t2 + a1b1 + a1b0
    // a1b0
    big_ror_2 s3
    big_ror_1 t4
    and s5, s3, t4
    big_rol_2 s3
    big_rol_1 t4
    big_ror_1 t2
    xor t2, t2, s5
    big_rol_1 t2



    ///////////////////////////////// A'' //////////////////////////////
    // shares A
    mv a0, s1
    mv a1, s2
    mv a2, s3
    mv a3, s4
    jal App
    mv s1, a0
    mv s2, a1
    mv s3, a2
    mv s4, a3

    // shares B
    mv a0, t1
    mv a1, t2
    mv a2, t3
    mv a3, t4
    jal App_b
    mv t1, a0
    mv t2, a1
    mv t3, a2
    mv t4, a3



    ////////////////////////////////////////
    ////////////////////////////////////////
    //// Reconstruct registers format //////
    ////////////////////////////////////////
    ////////////////////////////////////////


    // Share A block 2

    add t5, zero, zero

    srli t0, s1, 8
    andi t0, t0, 0x1
    slli t0, t0, 28
    xor t5, t5, t0

    srli t0, s1, 9
    andi t0, t0, 0x1
    slli t0, t0, 24
    xor t5, t5, t0

    srli t0, s1, 10
    andi t0, t0, 0x1
    slli t0, t0, 20
    xor t5, t5, t0

    srli t0, s1, 11
    andi t0, t0, 0x1
    slli t0, t0, 16
    xor t5, t5, t0

    srli t0, s1, 12
    andi t0, t0, 0x1
    slli t0, t0, 12
    xor t5, t5, t0

    srli t0, s1, 13
    andi t0, t0, 0x1
    slli t0, t0, 8
    xor t5, t5, t0

    srli t0, s1, 14
    andi t0, t0, 0x1
    slli t0, t0, 4
    xor t5, t5, t0

    srli t0, s1, 15
    andi t0, t0, 0x1
    xor t5, t5, t0

    srli t0, s2, 8
    andi t0, t0, 0x1
    slli t0, t0, 29
    xor t5, t5, t0

    srli t0, s2, 9
    andi t0, t0, 0x1
    slli t0, t0, 25
    xor t5, t5, t0

    srli t0, s2, 10
    andi t0, t0, 0x1
    slli t0, t0, 21
    xor t5, t5, t0

    srli t0, s2, 11
    andi t0, t0, 0x1
    slli t0, t0, 17
    xor t5, t5, t0

    srli t0, s2, 12
    andi t0, t0, 0x1
    slli t0, t0, 13
    xor t5, t5, t0

    srli t0, s2, 13
    andi t0, t0, 0x1
    slli t0, t0, 9
    xor t5, t5, t0

    srli t0, s2, 14
    andi t0, t0, 0x1
    slli t0, t0, 5
    xor t5, t5, t0

    srli t0, s2, 15
    andi t0, t0, 0x1
    slli t0, t0, 1
    xor t5, t5, t0


    srli t0, s3, 8
    andi t0, t0, 0x1
    slli t0, t0, 30
    xor t5, t5, t0

    srli t0, s3, 9
    andi t0, t0, 0x1
    slli t0, t0, 26
    xor t5, t5, t0

    srli t0, s3, 10
    andi t0, t0, 0x1
    slli t0, t0, 22
    xor t5, t5, t0

    srli t0, s3, 11
    andi t0, t0, 0x1
    slli t0, t0, 18
    xor t5, t5, t0

    srli t0, s3, 12
    andi t0, t0, 0x1
    slli t0, t0, 14
    xor t5, t5, t0

    srli t0, s3, 13
    andi t0, t0, 0x1
    slli t0, t0, 10
    xor t5, t5, t0

    srli t0, s3, 14
    andi t0, t0, 0x1
    slli t0, t0, 6
    xor t5, t5, t0

    srli t0, s3, 15
    andi t0, t0, 0x1
    slli t0, t0, 2
    xor t5, t5, t0

    srli t0, s4, 8
    andi t0, t0, 0x1
    slli t0, t0, 31
    xor t5, t5, t0

    srli t0, s4, 9
    andi t0, t0, 0x1
    slli t0, t0, 27
    xor t5, t5, t0

    srli t0, s4, 10
    andi t0, t0, 0x1
    slli t0, t0, 23
    xor t5, t5, t0

    srli t0, s4, 11
    andi t0, t0, 0x1
    slli t0, t0, 19
    xor t5, t5, t0

    srli t0, s4, 12
    andi t0, t0, 0x1
    slli t0, t0, 15
    xor t5, t5, t0

    srli t0, s4, 13
    andi t0, t0, 0x1
    slli t0, t0, 11
    xor t5, t5, t0

    srli t0, s4, 14
    andi t0, t0, 0x1
    slli t0, t0, 7
    xor t5, t5, t0

    srli t0, s4, 15
    andi t0, t0, 0x1
    slli t0, t0, 3
    xor t5, t5, t0

    lw a0, -12(fp)
    sw t5, 4(a0)

    // Share A block 1
    add t5, zero, zero

    srli t0, s1, 0
    andi t0, t0, 0x1
    slli t0, t0, 28
    xor t5, t5, t0

    srli t0, s1, 1
    andi t0, t0, 0x1
    slli t0, t0, 24
    xor t5, t5, t0

    srli t0, s1, 2
    andi t0, t0, 0x1
    slli t0, t0, 20
    xor t5, t5, t0

    srli t0, s1, 3
    andi t0, t0, 0x1
    slli t0, t0, 16
    xor t5, t5, t0

    srli t0, s1, 4
    andi t0, t0, 0x1
    slli t0, t0, 12
    xor t5, t5, t0

    srli t0, s1, 5
    andi t0, t0, 0x1
    slli t0, t0, 8
    xor t5, t5, t0

    srli t0, s1, 6
    andi t0, t0, 0x1
    slli t0, t0, 4
    xor t5, t5, t0

    srli t0, s1, 7
    andi t0, t0, 0x1
    xor t5, t5, t0

    srli t0, s2, 0
    andi t0, t0, 0x1
    slli t0, t0, 29
    xor t5, t5, t0

    srli t0, s2, 1
    andi t0, t0, 0x1
    slli t0, t0, 25
    xor t5, t5, t0

    srli t0, s2, 2
    andi t0, t0, 0x1
    slli t0, t0, 21
    xor t5, t5, t0

    srli t0, s2, 3
    andi t0, t0, 0x1
    slli t0, t0, 17
    xor t5, t5, t0

    srli t0, s2, 4
    andi t0, t0, 0x1
    slli t0, t0, 13
    xor t5, t5, t0

    srli t0, s2, 5
    andi t0, t0, 0x1
    slli t0, t0, 9
    xor t5, t5, t0

    srli t0, s2, 6
    andi t0, t0, 0x1
    slli t0, t0, 5
    xor t5, t5, t0

    srli t0, s2, 7
    andi t0, t0, 0x1
    slli t0, t0, 1
    xor t5, t5, t0


    srli t0, s3, 0
    andi t0, t0, 0x1
    slli t0, t0, 30
    xor t5, t5, t0

    srli t0, s3, 1
    andi t0, t0, 0x1
    slli t0, t0, 26
    xor t5, t5, t0

    srli t0, s3, 2
    andi t0, t0, 0x1
    slli t0, t0, 22
    xor t5, t5, t0

    srli t0, s3, 3
    andi t0, t0, 0x1
    slli t0, t0, 18
    xor t5, t5, t0

    srli t0, s3, 4
    andi t0, t0, 0x1
    slli t0, t0, 14
    xor t5, t5, t0

    srli t0, s3, 5
    andi t0, t0, 0x1
    slli t0, t0, 10
    xor t5, t5, t0

    srli t0, s3, 6
    andi t0, t0, 0x1
    slli t0, t0, 6
    xor t5, t5, t0

    srli t0, s3, 7
    andi t0, t0, 0x1
    slli t0, t0, 2
    xor t5, t5, t0

    srli t0, s4, 0
    andi t0, t0, 0x1
    slli t0, t0, 31
    xor t5, t5, t0

    srli t0, s4, 1
    andi t0, t0, 0x1
    slli t0, t0, 27
    xor t5, t5, t0

    srli t0, s4, 2
    andi t0, t0, 0x1
    slli t0, t0, 23
    xor t5, t5, t0

    srli t0, s4, 3
    andi t0, t0, 0x1
    slli t0, t0, 19
    xor t5, t5, t0

    srli t0, s4, 4
    andi t0, t0, 0x1
    slli t0, t0, 15
    xor t5, t5, t0

    srli t0, s4, 5
    andi t0, t0, 0x1
    slli t0, t0, 11
    xor t5, t5, t0

    srli t0, s4, 6
    andi t0, t0, 0x1
    slli t0, t0, 7
    xor t5, t5, t0

    srli t0, s4, 7
    andi t0, t0, 0x1
    slli t0, t0, 3
    xor t5, t5, t0

    lw a0, -12(fp)
    sw t5, 0(a0)

    // SHARES B
    // Share B block 2

    add t5, zero, zero

    srli t0, t1, 8
    andi t0, t0, 0x1
    slli t0, t0, 23
    xor t5, t5, t0

    srli t0, t1, 9
    andi t0, t0, 0x1
    slli t0, t0, 19
    xor t5, t5, t0

    srli t0, t1, 10
    andi t0, t0, 0x1
    slli t0, t0, 15
    xor t5, t5, t0

    srli t0, t1, 11
    andi t0, t0, 0x1
    slli t0, t0, 11
    xor t5, t5, t0

    srli t0, t1, 12
    andi t0, t0, 0x1
    slli t0, t0, 7
    xor t5, t5, t0

    srli t0, t1, 13
    andi t0, t0, 0x1
    slli t0, t0, 3
    xor t5, t5, t0

    srli t0, t1, 14
    andi t0, t0, 0x1
    slli t0, t0, 31
    xor t5, t5, t0

    srli t0, t1, 15
    andi t0, t0, 0x1
    slli t0, t0, 27
    xor t5, t5, t0

    srli t0, t2, 8
    andi t0, t0, 0x1
    slli t0, t0, 24
    xor t5, t5, t0

    srli t0, t2, 9
    andi t0, t0, 0x1
    slli t0, t0, 20
    xor t5, t5, t0

    srli t0, t2, 10
    andi t0, t0, 0x1
    slli t0, t0, 16
    xor t5, t5, t0

    srli t0, t2, 11
    andi t0, t0, 0x1
    slli t0, t0, 12
    xor t5, t5, t0

    srli t0, t2, 12
    andi t0, t0, 0x1
    slli t0, t0, 8
    xor t5, t5, t0

    srli t0, t2, 13
    andi t0, t0, 0x1
    slli t0, t0, 4
    xor t5, t5, t0

    srli t0, t2, 14
    andi t0, t0, 0x1
    slli t0, t0, 0
    xor t5, t5, t0

    srli t0, t2, 15
    andi t0, t0, 0x1
    slli t0, t0, 28
    xor t5, t5, t0


    srli t0, t3, 8
    andi t0, t0, 0x1
    slli t0, t0, 25
    xor t5, t5, t0

    srli t0, t3, 9
    andi t0, t0, 0x1
    slli t0, t0, 21
    xor t5, t5, t0

    srli t0, t3, 10
    andi t0, t0, 0x1
    slli t0, t0, 17
    xor t5, t5, t0

    srli t0, t3, 11
    andi t0, t0, 0x1
    slli t0, t0, 13
    xor t5, t5, t0

    srli t0, t3, 12
    andi t0, t0, 0x1
    slli t0, t0, 9
    xor t5, t5, t0

    srli t0, t3, 13
    andi t0, t0, 0x1
    slli t0, t0, 5
    xor t5, t5, t0

    srli t0, t3, 14
    andi t0, t0, 0x1
    slli t0, t0, 1
    xor t5, t5, t0

    srli t0, t3, 15
    andi t0, t0, 0x1
    slli t0, t0, 29
    xor t5, t5, t0

    srli t0, t4, 8
    andi t0, t0, 0x1
    slli t0, t0, 26
    xor t5, t5, t0

    srli t0, t4, 9
    andi t0, t0, 0x1
    slli t0, t0, 22
    xor t5, t5, t0

    srli t0, t4, 10
    andi t0, t0, 0x1
    slli t0, t0, 18
    xor t5, t5, t0

    srli t0, t4, 11
    andi t0, t0, 0x1
    slli t0, t0, 14
    xor t5, t5, t0

    srli t0, t4, 12
    andi t0, t0, 0x1
    slli t0, t0, 10
    xor t5, t5, t0

    srli t0, t4, 13
    andi t0, t0, 0x1
    slli t0, t0, 6
    xor t5, t5, t0

    srli t0, t4, 14
    andi t0, t0, 0x1
    slli t0, t0, 2
    xor t5, t5, t0

    srli t0, t4, 15
    andi t0, t0, 0x1
    slli t0, t0, 30
    xor t5, t5, t0


    lw a1, -16(fp)
    sw t5, 4(a1)

    // Share B block 1
    add t5, zero, zero

    srli t0, t1, 0
    andi t0, t0, 0x1
    slli t0, t0, 23
    xor t5, t5, t0

    srli t0, t1, 1
    andi t0, t0, 0x1
    slli t0, t0, 19
    xor t5, t5, t0

    srli t0, t1, 2
    andi t0, t0, 0x1
    slli t0, t0, 15
    xor t5, t5, t0

    srli t0, t1, 3
    andi t0, t0, 0x1
    slli t0, t0, 11
    xor t5, t5, t0

    srli t0, t1, 4
    andi t0, t0, 0x1
    slli t0, t0, 7
    xor t5, t5, t0

    srli t0, t1, 5
    andi t0, t0, 0x1
    slli t0, t0, 3
    xor t5, t5, t0

    srli t0, t1, 6
    andi t0, t0, 0x1
    slli t0, t0, 31
    xor t5, t5, t0

    srli t0, t1, 7
    andi t0, t0, 0x1
    slli t0, t0, 27
    xor t5, t5, t0

    srli t0, t2, 0
    andi t0, t0, 0x1
    slli t0, t0, 24
    xor t5, t5, t0

    srli t0, t2, 1
    andi t0, t0, 0x1
    slli t0, t0, 20
    xor t5, t5, t0

    srli t0, t2, 2
    andi t0, t0, 0x1
    slli t0, t0, 16
    xor t5, t5, t0

    srli t0, t2, 3
    andi t0, t0, 0x1
    slli t0, t0, 12
    xor t5, t5, t0

    srli t0, t2, 4
    andi t0, t0, 0x1
    slli t0, t0, 8
    xor t5, t5, t0

    srli t0, t2, 5
    andi t0, t0, 0x1
    slli t0, t0, 4
    xor t5, t5, t0

    srli t0, t2, 6
    andi t0, t0, 0x1
    slli t0, t0, 0
    xor t5, t5, t0

    srli t0, t2, 7
    andi t0, t0, 0x1
    slli t0, t0, 28
    xor t5, t5, t0

    srli t0, t3, 0
    andi t0, t0, 0x1
    slli t0, t0, 25
    xor t5, t5, t0

    srli t0, t3, 1
    andi t0, t0, 0x1
    slli t0, t0, 21
    xor t5, t5, t0

    srli t0, t3, 2
    andi t0, t0, 0x1
    slli t0, t0, 17
    xor t5, t5, t0

    srli t0, t3, 3
    andi t0, t0, 0x1
    slli t0, t0, 13
    xor t5, t5, t0

    srli t0, t3, 4
    andi t0, t0, 0x1
    slli t0, t0, 9
    xor t5, t5, t0

    srli t0, t3, 5
    andi t0, t0, 0x1
    slli t0, t0, 5
    xor t5, t5, t0

    srli t0, t3, 6
    andi t0, t0, 0x1
    slli t0, t0, 1
    xor t5, t5, t0

    srli t0, t3, 7
    andi t0, t0, 0x1
    slli t0, t0, 29
    xor t5, t5, t0

    srli t0, t4, 0
    andi t0, t0, 0x1
    slli t0, t0, 26
    xor t5, t5, t0

    srli t0, t4, 1
    andi t0, t0, 0x1
    slli t0, t0, 22
    xor t5, t5, t0

    srli t0, t4, 2
    andi t0, t0, 0x1
    slli t0, t0, 18
    xor t5, t5, t0

    srli t0, t4, 3
    andi t0, t0, 0x1
    slli t0, t0, 14
    xor t5, t5, t0

    srli t0, t4, 4
    andi t0, t0, 0x1
    slli t0, t0, 10
    xor t5, t5, t0

    srli t0, t4, 5
    andi t0, t0, 0x1
    slli t0, t0, 6
    xor t5, t5, t0

    srli t0, t4, 6
    andi t0, t0, 0x1
    slli t0, t0, 2
    xor t5, t5, t0

    srli t0, t4, 7
    andi t0, t0, 0x1
    slli t0, t0, 30
    xor t5, t5, t0


    lw a1, -16(fp)
    sw t5, 0(a1)



    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret



.global masked_pLayer_A
.balign 4
masked_pLayer_A:
// a0 = shares A

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    //load part 1 with lower bits
    lw s1, 0(a0)
    //load part 2 with higher bits
    lw s2, 4(a0)

    //updated registers
    add s3, zero, zero // part 1 with lower bits
    add s4, zero, zero // part 2 with higher bits


    //////////////////////////////////////////// PART 1

    // 0 -> 0
    andi s3, s1, 0x1

    // 1 -> 16
    srli t0, s1, 1 
    andi t0, t0, 0x1
    slli t0, t0, 16
    or s3, s3, t0

    // 2 -> 32 % 32 = 0
    srli t0, s1, 2 
    andi t0, t0, 0x1
    or s4, s4, t0

    // 3 -> 48
    srli t0, s1, 3 
    andi t0, t0, 0x1
    slli t0, t0, 16
    or s4, s4, t0

    // 4 -> 1
    srli t0, s1, 4 
    andi t0, t0, 0x1
    slli t0, t0, 1
    or s3, s3, t0

    // 5 -> 17
    srli t0, s1, 5 
    andi t0, t0, 0x1
    slli t0, t0, 17
    or s3, s3, t0

    // 6 -> 33 % 32 = 1
    srli t0, s1, 6 
    andi t0, t0, 0x1
    slli t0, t0, 1
    or s4, s4, t0


                                        
    // 7 -> 49 % 32 = 17
    srli t0, s1, 7 
    andi t0, t0, 0x1
    slli t0, t0, 17
    or s4, s4, t0


                                        
    // 8 -> 2
    srli t0, s1, 8 
    andi t0, t0, 0x1
    slli t0, t0, 2
    or s3, s3, t0

    // 9 -> 18
    srli t0, s1, 9 
    andi t0, t0, 0x1
    slli t0, t0, 18
    or s3, s3, t0

    // 10 -> 34 % 32 = 2
    srli t0, s1, 10 
    andi t0, t0, 0x1
    slli t0, t0, 2
    or s4, s4, t0

    // 11 -> 50 % 32 = 18
    srli t0, s1, 11 
    andi t0, t0, 0x1
    slli t0, t0, 18
    or s4, s4, t0

    // 12 -> 3
    srli t0, s1, 12 
    andi t0, t0, 0x1
    slli t0, t0, 3
    or s3, s3, t0

    // 13 -> 19
    srli t0, s1, 13 
    andi t0, t0, 0x1
    slli t0, t0, 19
    or s3, s3, t0

    // 14 -> 35 % 32 = 3
    srli t0, s1, 14 
    andi t0, t0, 0x1
    slli t0, t0, 3
    or s4, s4, t0

    // 15 -> 5 % 32 = 19
    srli t0, s1, 15 
    andi t0, t0, 0x1
    slli t0, t0, 19
    or s4, s4, t0

    // 16 -> 4
    srli t0, s1, 16 
    andi t0, t0, 0x1
    slli t0, t0, 4
    or s3, s3, t0

    // 17-> 20
    srli t0, s1, 17 
    andi t0, t0, 0x1
    slli t0, t0, 20
    or s3, s3, t0


    // 18 -> 36 % 32 = 4
    srli t0, s1, 18 
    andi t0, t0, 0x1
    slli t0, t0, 4
    or s4, s4, t0

    // 19 -> 52 % 32 = 20
    srli t0, s1, 19 
    andi t0, t0, 0x1
    slli t0, t0, 20
    or s4, s4, t0


    // 20-> 5
    srli t0, s1, 20 
    andi t0, t0, 0x1
    slli t0, t0, 5
    or s3, s3, t0


    // 21-> 21
    srli t0, s1, 21 
    andi t0, t0, 0x1
    slli t0, t0, 21
    or s3, s3, t0

    // 22 -> 37 % 32 = 5
    srli t0, s1, 22 
    andi t0, t0, 0x1
    slli t0, t0, 5
    or s4, s4, t0

    // 23 -> 53 % 32 = 21
    srli t0, s1, 23 
    andi t0, t0, 0x1
    slli t0, t0, 21
    or s4, s4, t0

    // 24 -> 6
    srli t0, s1, 24 
    andi t0, t0, 0x1
    slli t0, t0, 6
    or s3, s3, t0

    // 25 -> 22
    srli t0, s1, 25 
    andi t0, t0, 0x1
    slli t0, t0, 22
    or s3, s3, t0

    // 26 -> 38 % 32 = 6
    srli t0, s1, 26 
    andi t0, t0, 0x1
    slli t0, t0, 6
    or s4, s4, t0

    // 27 -> 54 % 32 =22
    srli t0, s1, 27 
    andi t0, t0, 0x1
    slli t0, t0, 22
    or s4, s4, t0

    // 28 -> 7
    srli t0, s1, 28 
    andi t0, t0, 0x1
    slli t0, t0, 7
    or s3, s3, t0

    // 29 -> 23
    srli t0, s1, 29 
    andi t0, t0, 0x1
    slli t0, t0, 23
    or s3, s3, t0

    // 30 -> 39 % 32 = 7
    srli t0, s1, 30 
    andi t0, t0, 0x1
    slli t0, t0, 7
    or s4, s4, t0

    // 31 -> 55 % 32 = 23
    srli t0, s1, 31 
    andi t0, t0, 0x1
    slli t0, t0, 23
    or s4, s4, t0

    //////////////////////////////////////////// PART 2

    // 0 -> 8
    andi t0, s2, 0x1 
    slli t0, t0, 8
    or s3, s3, t0

    // 1 -> 24
    srli t0, s2, 1 
    andi t0, t0, 0x1
    slli t0, t0, 24
    or s3, s3, t0


    // 2 -> 40 % 32 = 8
    srli t0, s2, 2 
    andi t0, t0, 0x1
    slli t0, t0, 8
    or s4, s4, t0

    // 3 -> 56 % 32 = 24
    srli t0, s2, 3 
    andi t0, t0, 0x1
    slli t0, t0, 24
    or s4, s4, t0

    // 4 -> 9
    srli t0, s2, 4 
    andi t0, t0, 0x1
    slli t0, t0, 9
    or s3, s3, t0

    // 5 -> 25
    srli t0, s2, 5 
    andi t0, t0, 0x1
    slli t0, t0, 25
    or s3, s3, t0

    // 6 -> 41 % 32 = 9
    srli t0, s2, 6 
    andi t0, t0, 0x1
    slli t0, t0, 9
    or s4, s4, t0

    // 7 -> 57 % 32 = 25
    srli t0, s2, 7 
    andi t0, t0, 0x1
    slli t0, t0, 25
    or s4, s4, t0

    // 8 -> 10
    srli t0, s2, 8 
    andi t0, t0, 0x1
    slli t0, t0, 10
    or s3, s3, t0

    // 9 -> 26
    srli t0, s2, 9 
    andi t0, t0, 0x1
    slli t0, t0, 26
    or s3, s3, t0

    // 10 -> 42 % 32 = 10
    srli t0, s2, 10 
    andi t0, t0, 0x1
    slli t0, t0, 10
    or s4, s4, t0

    // 11 -> 58 % 32 = 26
    srli t0, s2, 11 
    andi t0, t0, 0x1
    slli t0, t0, 26
    or s4, s4, t0

    // 12 -> 11
    srli t0, s2, 12 
    andi t0, t0, 0x1
    slli t0, t0, 11
    or s3, s3, t0

    // 13 -> 27
    srli t0, s2, 13 
    andi t0, t0, 0x1
    slli t0, t0, 27
    or s3, s3, t0

    // 14 -> 43 % 32 = 11
    srli t0, s2, 14 
    andi t0, t0, 0x1
    slli t0, t0, 11
    or s4, s4, t0


    // 15 -> 59 % 32 = 27
    srli t0, s2, 15 
    andi t0, t0, 0x1
    slli t0, t0, 27
    or s4, s4, t0


    // 16 -> 12
    srli t0, s2, 16 
    andi t0, t0, 0x1
    slli t0, t0, 12
    or s3, s3, t0

    // 17 -> 28
    srli t0, s2, 17 
    andi t0, t0, 0x1
    slli t0, t0, 28
    or s3, s3, t0

    // 18 -> 44 % 32 = 12
    srli t0, s2, 18 
    andi t0, t0, 0x1
    slli t0, t0, 12
    or s4, s4, t0

    // 19 -> 60 % 32 = 28
    srli t0, s2, 19 
    andi t0, t0, 0x1
    slli t0, t0, 28
    or s4, s4, t0

    // 20 -> 13
    srli t0, s2, 20 
    andi t0, t0, 0x1
    slli t0, t0, 13
    or s3, s3, t0

    // 21 -> 29
    srli t0, s2, 21 
    andi t0, t0, 0x1
    slli t0, t0, 29
    or s3, s3, t0

    // 22 -> 45 % 32 = 13
    srli t0, s2, 22 
    andi t0, t0, 0x1
    slli t0, t0, 13
    or s4, s4, t0

    // 23 -> 61 % 32 = 29
    srli t0, s2, 23 
    andi t0, t0, 0x1
    slli t0, t0, 29
    or s4, s4, t0

    // 24 -> 14
    srli t0, s2, 24 
    andi t0, t0, 0x1
    slli t0, t0, 14
    or s3, s3, t0

    // 25 -> 30
    srli t0, s2, 25 
    andi t0, t0, 0x1
    slli t0, t0, 30
    or s3, s3, t0

    // 26 -> 46 % 32 = 14
    srli t0, s2, 26 
    andi t0, t0, 0x1
    slli t0, t0, 14
    or s4, s4, t0

    // 27 -> 62 % 32 = 30
    srli t0, s2, 27 
    andi t0, t0, 0x1
    slli t0, t0, 30
    or s4, s4, t0

    // 28 -> 15
    srli t0, s2, 28 
    andi t0, t0, 0x1
    slli t0, t0, 15
    or s3, s3, t0

    // 29 -> 31
    srli t0, s2, 29 
    andi t0, t0, 0x1
    slli t0, t0, 31
    or s3, s3, t0

    // 30 -> 47 % 32 = 15
    srli t0, s2, 30 
    andi t0, t0, 0x1
    slli t0, t0, 15
    or s4, s4, t0


    // 31 -> 63 % 32 = 31
    srli t0, s2, 31 
    andi t0, t0, 0x1
    slli t0, t0, 31
    or s4, s4, t0


    //store updated part 1 with lower bits
    sw s3, 0(a0)
    //store updated part 2 with higher bits
    sw s4, 4(a0)


    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
ret



.global masked_pLayer_B
.balign 4
masked_pLayer_B:
// a0 = shares B

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    //load part 1 with lower bits
    lw t1, 0(a0)
    //load part 2 with higher bits
    lw t2, 4(a0)

    //updated registers
    add t3, zero, zero // part 1 with lower bits
    add t4, zero, zero // part 2 with higher bits


    //////////////////////////////////////////// PART 1
    // place from 31 to 
    srli t0, t1, 31
    andi t0, t0, 0x01
    slli t3, t0, 31


    srli t0, t2, 28
    andi t0, t0, 0x01
    slli t0, t0, 30
    or t3, t3, t0

    // 58 mod 32
    srli t0, t2, 24
    andi t0, t0, 0x01
    slli t0, t0, 29
    or t3, t3, t0

    // 54 mod 32
    srli t0, t2, 20
    andi t0, t0, 0x01
    slli t0, t0, 28
    or t3, t3, t0

    // 50 mod 32
    srli t0, t2, 16
    andi t0, t0, 0x01
    slli t0, t0, 27
    or t3, t3, t0

    // 46 mod 32
    srli t0, t2, 12
    andi t0, t0, 0x01
    slli t0, t0, 26
    or t3, t3, t0

    // 42 mod 32
    srli t0, t2, 8
    andi t0, t0, 0x01
    slli t0, t0, 25
    or t3, t3, t0

    // 38 mod 32
    srli t0, t2, 4
    andi t0, t0, 0x01
    slli t0, t0, 24
    or t3, t3, t0

    // 34 mod 32
    srli t0, t2, 0
    andi t0, t0, 0x01
    slli t0, t0, 23
    or t3, t3, t0

    // 26 mod 32
    srli t0, t1, 28
    andi t0, t0, 0x01
    slli t0, t0, 22
    or t3, t3, t0

    // 22 mod 32
    srli t0, t1, 24
    andi t0, t0, 0x01
    slli t0, t0, 21
    or t3, t3, t0

    // 18 mod 32
    srli t0, t1, 20
    andi t0, t0, 0x01
    slli t0, t0, 20
    or t3, t3, t0

    // 14 mod 32
    srli t0, t1, 16
    andi t0, t0, 0x01
    slli t0, t0, 19
    or t3, t3, t0

    // 10 mod 32
    srli t0, t1, 12
    andi t0, t0, 0x01
    slli t0, t0, 18
    or t3, t3, t0

    // 6 mod 32
    srli t0, t1, 8
    andi t0, t0, 0x01
    slli t0, t0, 17
    or t3, t3, t0

    // 2 mod 32
    srli t0, t1, 4
    andi t0, t0, 0x01
    slli t0, t0, 16
    or t3, t3, t0

    // 61 mod 32
    srli t0, t1, 0
    andi t0, t0, 0x01
    slli t0, t0, 15
    or t3, t3, t0

    // 61 mod 32
    srli t0, t2, 27
    andi t0, t0, 0x01
    slli t0, t0, 14
    or t3, t3, t0

    // 53 mod 32
    srli t0, t2, 23
    andi t0, t0, 0x01
    slli t0, t0, 13
    or t3, t3, t0

    // 49 mod 32
    srli t0, t2, 19
    andi t0, t0, 0x01
    slli t0, t0, 12
    or t3, t3, t0

    // 45 mod 32
    srli t0, t2, 15
    andi t0, t0, 0x01
    slli t0, t0, 11
    or t3, t3, t0

    // 41 mod 32
    srli t0, t2, 11
    andi t0, t0, 0x01
    slli t0, t0, 10
    or t3, t3, t0

    // 37 mod 32
    srli t0, t2, 7
    andi t0, t0, 0x01
    slli t0, t0, 9
    or t3, t3, t0

    // 33 mod 32
    srli t0, t2, 3
    andi t0, t0, 0x01
    slli t0, t0, 8
    or t3, t3, t0

    // 29 mod 32
    srli t0, t2, 31
    andi t0, t0, 0x01
    slli t0, t0, 7
    or t3, t3, t0

    // 25 mod 32
    srli t0, t1, 27
    andi t0, t0, 0x01
    slli t0, t0, 6
    or t3, t3, t0

    // 21 mod 32
    srli t0, t1, 23
    andi t0, t0, 0x01
    slli t0, t0, 5
    or t3, t3, t0

    // 17 mod 32
    srli t0, t1, 19
    andi t0, t0, 0x01
    slli t0, t0, 4
    or t3, t3, t0

    // 13 mod 32
    srli t0, t1, 15
    andi t0, t0, 0x01
    slli t0, t0, 3
    or t3, t3, t0

    // 9 mod 32
    srli t0, t1, 11
    andi t0, t0, 0x01
    slli t0, t0, 2
    or t3, t3, t0

    // 5 mod 32
    srli t0, t1, 7
    andi t0, t0, 0x01
    slli t0, t0, 1
    or t3, t3, t0

    // 1 mod 32
    srli t0, t1, 3
    andi t0, t0, 0x01
    slli t0, t0, 0
    or t3, t3, t0


//////////////////////////////////////////// PART 2
    // place from 31 to 0
    // 60 mod 32
    srli t0, t1, 1
    andi t0, t0, 0x01
    slli t4, t0, 31

    // 56 mod 32
    srli t0, t2, 30
    andi t0, t0, 0x01
    slli t0, t0, 30
    or t4, t4, t0

    // 52 mod 32
    srli t0, t2, 26
    andi t0, t0, 0x01
    slli t0, t0, 29
    or t4, t4, t0

    // 48 mod 32
    srli t0, t2, 22
    andi t0, t0, 0x01
    slli t0, t0, 28
    or t4, t4, t0

    // 44 mod 32
    srli t0, t2, 18
    andi t0, t0, 0x01
    slli t0, t0, 27
    or t4, t4, t0

    // 40 mod 32
    srli t0, t2, 14
    andi t0, t0, 0x01
    slli t0, t0, 26
    or t4, t4, t0

    // 36 mod 32
    srli t0, t2, 10
    andi t0, t0, 0x01
    slli t0, t0, 25
    or t4, t4, t0

    // 32 mod 32
    srli t0, t2, 6
    andi t0, t0, 0x01
    slli t0, t0, 24
    or t4, t4, t0

    // 28 mod 32
    srli t0, t2, 2
    andi t0, t0, 0x01
    slli t0, t0, 23
    or t4, t4, t0

    srli t0, t1, 30
    andi t0, t0, 0x01
    slli t0, t0, 22
    or t4, t4, t0

    srli t0, t1, 26
    andi t0, t0, 0x01
    slli t0, t0, 21
    or t4, t4, t0

    srli t0, t1, 22
    andi t0, t0, 0x01
    slli t0, t0, 20
    or t4, t4, t0

    srli t0, t1, 18
    andi t0, t0, 0x01
    slli t0, t0, 19
    or t4, t4, t0

    srli t0, t1, 14
    andi t0, t0, 0x01
    slli t0, t0, 18
    or t4, t4, t0

    srli t0, t1, 10
    andi t0, t0, 0x01
    slli t0, t0, 17
    or t4, t4, t0

    // 63 mod 32
    srli t0, t1, 6
    andi t0, t0, 0x01
    slli t0, t0, 16
    or t4, t4, t0

    // 59 mod 32
    srli t0, t1, 2
    andi t0, t0, 0x01
    slli t0, t0, 15
    or t4, t4, t0

    // 55 mod 32
    srli t0, t2, 29
    andi t0, t0, 0x01
    slli t0, t0, 14
    or t4, t4, t0

    // 51 mod 32
    srli t0, t2, 25
    andi t0, t0, 0x01
    slli t0, t0, 13
    or t4, t4, t0

    // 47 mod 32
    srli t0, t2, 21
    andi t0, t0, 0x01
    slli t0, t0, 12
    or t4, t4, t0

    // 43 mod 32
    srli t0, t2, 17
    andi t0, t0, 0x01
    slli t0, t0, 11
    or t4, t4, t0

    // 39 mod 32
    srli t0, t2, 13
    andi t0, t0, 0x01
    slli t0, t0, 10
    or t4, t4, t0

    // 35 mod 32
    srli t0, t2, 9
    andi t0, t0, 0x01
    slli t0, t0, 9
    or t4, t4, t0

    // 31 mod 32
    srli t0, t2, 5
    andi t0, t0, 0x01
    slli t0, t0, 8
    or t4, t4, t0

    srli t0, t2, 1
    andi t0, t0, 0x01
    slli t0, t0, 7
    or t4, t4, t0

    srli t0, t1, 29
    andi t0, t0, 0x01
    slli t0, t0, 6
    or t4, t4, t0

    srli t0, t1, 25
    andi t0, t0, 0x01
    slli t0, t0, 5
    or t4, t4, t0

    srli t0, t1, 21
    andi t0, t0, 0x01
    slli t0, t0, 4
    or t4, t4, t0

    srli t0, t1, 17
    andi t0, t0, 0x01
    slli t0, t0, 3
    or t4, t4, t0

    srli t0, t1, 13
    andi t0, t0, 0x01
    slli t0, t0, 2
    or t4, t4, t0

    srli t0, t1, 9
    andi t0, t0, 0x01
    slli t0, t0, 1
    or t4, t4, t0

    // 64 mod 32
    srli t0, t1, 5
    andi t0, t0, 0x01
    slli t0, t0, 0
    or t4, t4, t0

    //store updated part 1 with lower bits
    sw t3, 0(a0)
    //store updated part 2 with higher bits
    sw t4, 4(a0)
    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
ret



.global masked_present
.balign 4
masked_present:
// a0 = shares0
// a1 = shares1

// a2 = RK_H0
// a3 = RK_H1

// a4 = RK_L0
// a5 = RK_L1

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    add s10, zero, zero
    addi s11, zero, 31
    add s9, zero, zero

    sw s10, -12(fp)
    sw s11, -16(fp)
    sw s9, -20(fp)

    sw a2, -24(fp)
    sw a3, -28(fp)
    sw a4, -32(fp)
    sw a5, -36(fp)
    sw a0, -40(fp)
    sw a1, -44(fp)

1:

    /////////////////////////////////////////////////////////////////
    ///////////////////////// ADD ROUND KEY /////////////////////////
    /////////////////////////////////////////////////////////////////


    ////////////////// Update High //////////////////

    lw s1, 4(a0) // Share A
    lw t1, 4(a1) // Share B

    lw s9, -20(fp) //get current offset for round key array

    add t0, s9, a2
    lw s2, 0(t0) // Share A High Key
    add t0, s9, a3
    lw t2, 0(t0) // Share B High Key

    xor s1, s1, s2
    xor t1, t1, t2

    sw s1, 4(a0)
    sw t1, 4(a1)

    ////////////////// Update LOW //////////////////
    lw s1, 0(a0) // Share A
    lw t1, 0(a1) // Share B


    add t0, s9, a4
    lw s2, 0(t0) // Share A Low Key
    add t0, s9, a5
    lw t2, 0(t0) // Share B Low Key

    xor s1, s1, s2
    xor t1, t1, t2

    sw s1, 0(a0)
    sw t1, 0(a1)

    // increase and store in memory offset for round keys array
    addi s9, s9, 4
    sw s9, -20(fp)


    ////////////////////////////////////////////////////////
    ///////////////////////// SBOX /////////////////////////
    ////////////////////////////////////////////////////////

    jal sbox

    lw a2, -24(fp)
    lw a3, -28(fp)
    lw a4, -32(fp)
    lw a5, -36(fp)


    /////////////////////////////////////////////////////////////////////
    ///////////////////////// Permutation Layer /////////////////////////
    /////////////////////////////////////////////////////////////////////

    jal masked_pLayer_A

    mv a0, a1
    jal masked_pLayer_B
    mv a1, a0
    lw a0, -40(fp)


    // LOOP ITERATION
    lw s10, -12(fp) 
    lw s11, -16(fp) 
    addi s10, s10, 1
    sw s10, -12(fp) 
    blt s10, s11, 1b


    /////////////////////////////////////////////////////////////////////////////
    ///////////////////////// LAST ADD ROUND KEY RK[31] /////////////////////////
    /////////////////////////////////////////////////////////////////////////////


     ////////////////// Update High //////////////////
    lw s1, 4(a0) // Share A
    lw t1, 4(a1) // Share B

    lw s9, -20(fp) //get current offset for round key array

    add t0, s9, a2
    lw s2, 0(t0) // Share A High KEY
    add t0, s9, a3
    lw t2, 0(t0) // Share B High KEY

    xor s1, s1, s2
    xor t1, t1, t2

    sw s1, 4(a0)
    sw t1, 4(a1)

    ////////////////// Update LOW //////////////////
    lw s1, 0(a0) // Share A
    lw t1, 0(a1) // Share B


    add t0, s9, a4
    lw s2, 0(t0) // Share A Low Key
    add t0, s9, a5
    lw t2, 0(t0) // Share B Low Key

    xor s1, s1, s2
    xor t1, t1, t2

    sw s1, 0(a0)
    sw t1, 0(a1)
    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64

    ret


