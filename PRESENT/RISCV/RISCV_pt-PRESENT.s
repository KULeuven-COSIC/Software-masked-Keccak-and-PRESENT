
/////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// RISC-V plaintext PRESENT /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

.data

.balign 4
.globl sboxT
sboxT:
    .byte 0x0c
    .byte 0x05
    .byte 0x06
    .byte 0x0b
    .byte 0x09
    .byte 0x00
    .byte 0x0a
    .byte 0x0d
    .byte 0x03
    .byte 0x0e
    .byte 0x0f
    .byte 0x08
    .byte 0x04
    .byte 0x07
    .byte 0x01
    .byte 0x02


.text

.macro rorA reg,dist
    srli  s8, \reg, \dist
    slli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s8
    add s8, zero, zero 
.endm

.macro rolA reg,dist
    slli  s8, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s8
    add s8, zero, zero 
.endm


.macro ror8_1 reg
    andi  s11, \reg, 0x01
    slli s11, s11, 7
    andi  \reg, \reg, 0xfe
    srli  \reg, \reg, 1
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero 
    add s10, zero, zero 
.endm

.macro ror8_2 reg
    andi  s11, \reg, 0x03
    slli s11, s11, 6
    andi  \reg, \reg, 0xfc
    srli  \reg, \reg, 2
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero 
    add s10, zero, zero 
.endm

.macro rol8_1 reg
    andi  s11, \reg, 0x80
    srli s11, s11, 7
    andi  \reg, \reg, 0x7f
    slli  \reg, \reg, 1
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero 
    add s10, zero, zero 
.endm

.macro rol8_2 reg
    andi  s11, \reg, 0xC0
    srli s11, s11, 6
    andi  \reg, \reg, 0x3f
    slli  \reg, \reg, 2
    xor   \reg, \reg, s11
    andi  \reg, \reg, 0xff
    add s11, zero, zero 
    add s10, zero, zero 
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
    add s8, zero, zero 
    add s9, zero, zero 
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
    add s8, zero, zero 
    add s9, zero, zero 
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
    add s8, zero, zero 
    add s9, zero, zero 
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
    add s8, zero, zero 
    add s9, zero, zero 
.endm



//////////////////////////////////////////////////////////////////////////////
/////////////////////////// sbox //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


.global sbox
.balign 4
// a0 = shares0 (64 bits)
// a1 = shares1 (64 bits)

sbox:
//FUNCTION PROLOGUE
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    la t0, sboxT
    sw a0, -12(fp)
  
    // BLOCK 1
    lw s0, 0(a0) // BLOCK 1

    // byte 0
    srli s1, s0, 24

    andi t1, s1, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s1, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    slli s3, t2, 24

    // byte 1
    srli s1, s0, 16

    andi t1, s1, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s1, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    slli t2, t2, 16
    xor s3, s3, t2

    // byte 2
    srli s1, s0, 8

    andi t1, s1, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s1, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    slli t2, t2, 8
    xor s3, s3, t2

    // byte 3
    andi t1, s0, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s0, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    xor s3, s3, t2

    sw s3, 0(a0)


    // BLOCK 2
    lw s0, 4(a0) // BLOCK 2

    // byte 0
    srli s1, s0, 24

    andi t1, s1, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s1, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    slli s3, t2, 24

    // byte 1
    srli s1, s0, 16

    andi t1, s1, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s1, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    slli t2, t2, 16
    xor s3, s3, t2

    // byte 2
    srli s1, s0, 8

    andi t1, s1, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s1, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    slli t2, t2, 8
    xor s3, s3, t2

    // byte 3
    andi t1, s0, 0xF0
    srli t1, t1, 4
    add t1, t0, t1
    lb  t2, 0(t1)
    slli t2, t2, 4

    andi t1, s0, 0x0F
    add t1, t0, t1
    lb  t3, 0(t1)

    xor t2, t2, t3
    xor s3, s3, t2

    sw s3, 4(a0)




    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret

.global masked_pLayer
.balign 4
masked_pLayer:
// a0 = shares

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    //load part 1 with lower bits
    lw s1, 0(a0)
    //load part 2 with higher bits
    lw s2, 4(a0)

    //updated registers 
    add s3, zero, zero 
    add s4, zero, zero 


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




.global present
.balign 4
present:



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

    sw a1, -24(fp)    
    sw a2, -32(fp)

    sw a0, -40(fp)
    

1:

    /////////////////////////////////////////////////////////////////
    ///////////////////////// ADD ROUND KEY /////////////////////////
    /////////////////////////////////////////////////////////////////


    ////////////////// Update High ////////////////// 
    
    lw s1, 4(a0) // Share A
    lw s9, -20(fp) 
    add t0, s9, a1
    lw s2, 0(t0) // Share A High KEY
    xor s1, s1, s2
    sw s1, 4(a0)
    
    ////////////////// Update LOW ////////////////// 
    lw s1, 0(a0) // Share A
    add t0, s9, a2
    lw s2, 0(t0) // Share A Low Key
    xor s1, s1, s2
    sw s1, 0(a0)

     
    addi s9, s9, 4
    sw s9, -20(fp)


    ////////////////////////////////////////////////////////
    ///////////////////////// SBOX /////////////////////////
    ////////////////////////////////////////////////////////

    jal sbox

    /////////////////////////////////////////////////////////////////////
    ///////////////////////// Permutation Layer /////////////////////////
    /////////////////////////////////////////////////////////////////////
    
    jal masked_pLayer

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
    lw s9, -20(fp) 
    add t0, s9, a1
    lw s2, 0(t0) // Share A High KEY
    xor s1, s1, s2
    sw s1, 4(a0)
    
    ////////////////// Update LOW ////////////////// 
    lw s1, 0(a0) // Share A      
    add t0, s9, a2
    lw s2, 0(t0) // Share A Low Key
    xor s1, s1, s2
    sw s1, 0(a0)

    

    
    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret

