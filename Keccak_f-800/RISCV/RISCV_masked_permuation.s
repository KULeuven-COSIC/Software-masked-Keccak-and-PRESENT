////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// RISC-V masked Keccak-f[800] /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

.data

.balign 4
.globl KeccakP800_RotationConstants
KeccakP800_RotationConstants:
    .word 0x00000001
    .word 0x00000003
    .word 0x00000006
    .word 0x0000000a
    .word 0x0000000f
    .word 0x00000015
    .word 0x0000001c
    .word 0x00000004
    .word 0x0000000d
    .word 0x00000017
    .word 0x00000002
    .word 0x0000000e
    .word 0x0000001b
    .word 0x00000009
    .word 0x00000018
    .word 0x00000008
    .word 0x00000019
    .word 0x0000000b
    .word 0x0000001e
    .word 0x00000012
    .word 0x00000007
    .word 0x0000001d
    .word 0x00000014
    .word 0x0000000c

.balign 4
.globl KeccakP800_PiLane
KeccakP800_PiLane:
    .word 0x0000000a
    .word 0x00000007
    .word 0x0000000b
    .word 0x00000011
    .word 0x00000012
    .word 0x00000003
    .word 0x00000005
    .word 0x00000010
    .word 0x00000008
    .word 0x00000015
    .word 0x00000018
    .word 0x00000004
    .word 0x0000000f
    .word 0x00000017
    .word 0x00000013
    .word 0x0000000d
    .word 0x0000000c
    .word 0x00000002
    .word 0x00000014
    .word 0x0000000e
    .word 0x00000016
    .word 0x00000009
    .word 0x00000006
    .word 0x00000001

.balign 4
.globl KeccakRoundConstants
KeccakRoundConstants:
    .word 0x00000001
    .word 0x00008082
    .word 0x0000808a
    .word 0x80008000
    .word 0x0000808b
    .word 0x80000001
    .word 0x80008081
    .word 0x00008009
    .word 0x0000008a
    .word 0x00000088
    .word 0x80008009
    .word 0x8000000a
    .word 0x8000808b
    .word 0x0000008b
    .word 0x00008089
    .word 0x00008003
    .word 0x00008002
    .word 0x00000080
    .word 0x0000800a
    .word 0x8000000a
    .word 0x80008081
    .word 0x00008080


.text

.balign 4
// return (x)+5*(y);
// a0 = x, a1=y
i:
    add t0,zero, a1
    slli a1,a1,2
    add a1,a1,t0
    add a0,a0,a1
    slli a0,a0,2
    ret


///////////////////////////////////////////////////////////////////////////
////////////////////////////////// THETA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////


.global theta
.balign 4

theta:
    addi sp,sp,-64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp,sp,64
    sw a0, -12(fp)

    // load sheet 1
    lw s1, 0(a0)
    lw s2, 20(a0)
    lw s3, 40(a0)
    lw s4, 60(a0)
    lw s5, 80(a0)
    xor s6, s1, s2
    xor s6, s6, s3
    xor s6, s6, s4
    xor s6, s6, s5 // sum of Sheet 1 in s6

    // load sheet 2
    lw t1, 4(a0)
    lw t2, 24(a0)
    lw t3, 44(a0)
    lw t4, 64(a0)
    lw t5, 84(a0)
    xor s7, t1, t2
    xor s7, s7, t3
    xor s7, s7, t4
    xor s7, s7, t5 // sum of Sheet 2 in s7

    // load sheet 3
    lw s1, 8(a0)
    lw s2, 28(a0)
    lw s3, 48(a0)
    lw s4, 68(a0)
    lw s5, 88(a0)
    xor s8, s1, s2
    xor s8, s8, s3
    xor s8, s8, s4
    xor s8, s8, s5 // sum of Sheet 3 in s8

    //Compute θ step on sheet 2
    xor t1, t1, s6
    xor t2, t2, s6
    xor t3, t3, s6
    xor t4, t4, s6
    xor t5, t5, s6
    mv a7, s8
    slli a6, s8, 1
    srli s8, s8, 31
    xor a6, a6, s8
    mv s8, a7
    xor t1, t1, a6
    xor t2, t2, a6
    xor t3, t3, a6
    xor t4, t4, a6
    xor t5, t5, a6
    // Store updated sheet 2
    sw t1, 4(a0)
    sw t2, 24(a0)
    sw t3, 44(a0)
    sw t4, 64(a0)
    sw t5, 84(a0)

    // load sheet 4
    lw t1, 12(a0)
    lw t2, 32(a0)
    lw t3, 52(a0)
    lw t4, 72(a0)
    lw t5, 92(a0)
    xor s9, t1, t2
    xor s9, s9, t3
    xor s9, s9, t4
    xor s9, s9, t5 // sum of Sheet 4 in s9

    //Compute θ step on sheet 3
    xor s1, s1, s7
    xor s2, s2, s7
    xor s3, s3, s7
    xor s4, s4, s7
    xor s5, s5, s7
    mv a7, s9
    slli a6, s9, 1
    srli s9, s9, 31
    xor a6, a6, s9
    mv s9, a7
    xor s1, s1, a6
    xor s2, s2, a6
    xor s3, s3, a6
    xor s4, s4, a6
    xor s5, s5, a6
    // Store updated sheet 3
    sw s1, 8(a0)
    sw s2, 28(a0)
    sw s3, 48(a0)
    sw s4, 68(a0)
    sw s5, 88(a0)

    // load sheet 5
    lw s1, 16(a0)
    lw s2, 36(a0)
    lw s3, 56(a0)
    lw s4, 76(a0)
    lw s5, 96(a0)

    // Compute first step of θ on sheet 4:
    xor t1, t1, s8
    xor t2, t2, s8
    xor t3, t3, s8
    xor t4, t4, s8
    xor t5, t5, s8

    xor s8, s1, s2
    xor s8, s8, s3
    xor s8, s8, s4
    xor s8, s8, s5 // sum of Sheet 5 in s8

    // Compute second step of θ step on sheet 4
    mv a7, s8
    slli a6, s8, 1
    srli s8, s8, 31
    xor a6, a6, s8
    mv s8, a7
    xor t1, t1, a6
    xor t2, t2, a6
    xor t3, t3, a6
    xor t4, t4, a6
    xor t5, t5, a6
    // Store updated sheet 4
    sw t1, 12(a0)
    sw t2, 32(a0)
    sw t3, 52(a0)
    sw t4, 72(a0)
    sw t5, 92(a0)

    //Load sheet 1
    lw t1, 0(a0)
    lw t2, 20(a0)
    lw t3, 40(a0)
    lw t4, 60(a0)
    lw t5, 80(a0)
    // Compute θ step on sheet 1
    xor t1, t1, s8
    xor t2, t2, s8
    xor t3, t3, s8
    xor t4, t4, s8
    xor t5, t5, s8
    mv a7, s7
    slli a6, s7, 1
    srli s7, s7, 31
    xor a6, a6, s7
    mv s7, a7
    xor t1, t1, a6
    xor t2, t2, a6
    xor t3, t3, a6
    xor t4, t4, a6
    xor t5, t5, a6
    //Store updated sheet 1
    sw t1, 0(a0)
    sw t2, 20(a0)
    sw t3, 40(a0)
    sw t4, 60(a0)
    sw t5, 80(a0)

    // Compute θ step on sheet 5
    xor s1, s1, s9
    xor s2, s2, s9
    xor s3, s3, s9
    xor s4, s4, s9
    xor s5, s5, s9
    mv a7, s6
    slli a6, s6, 1
    srli s6, s6, 31
    xor a6, a6, s6
    mv s6, a7
    xor s1, s1, a6
    xor s2, s2, a6
    xor s3, s3, a6
    xor s4, s4, a6
    xor s5, s5, a6
    // Store updated sheet 5
    sw s1, 16(a0)
    sw s2, 36(a0)
    sw s3, 56(a0)
    sw s4, 76(a0)
    sw s5, 96(a0)

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


//////////////////////////////////////////////////////////////////////////
////////////////////////////////// RHO_PI ////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.global rhoPi
.balign 4

rhoPi:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    la s5, KeccakP800_RotationConstants
    la s9, KeccakP800_PiLane


    addi s1, zero, 24 // s1 = limit of for loop
    add s2, zero, zero //s2 = x
    addi s3, zero, 1 
    slli s4, s3, 2
    add a6, s4, a0
    lw t1, 0(a6) // t1 = temp
1:
    slli a7, s2, 2
    add a6, a7, s9 // offset for KeccakP800_PiLane[x]
    lw a6, 0(a6) // KeccakP800_PiLane[x] value
    slli s8, a6, 2
    add s7, a0, s8 // offset for ((uint32_t*)state)[KeccakP800_PiLane[x]]
    lw t2, 0(s7) // t2 = BC[x] = ((uint32_t*)state)[KeccakP800_PiLane[x]]
    
    add s8, s5 ,a7 // offset for KeccakP800_RotationConstants[x]
    lw s8, 0(s8) // KeccakP800_RotationConstants[x] value
    
    // ROL32(tempA,s8)
    sll t3, t1, s8 
    sub s8, zero, s8 
    addi s8, s8, 32
    srl t1, t1, s8 
    xor t3, t1, t3 // ROL32(temp, KeccakP800_RotationConstants[x])

    sw t3, 0(s7)
    mv t1, t2 // temp = BC[x];
    addi s2, s2, 1
    blt s2, s1, 1b

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


//////////////////////////////////////////////////////////////////////////
////////////////////////////////// CHI ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.macro rorA reg,dist
    srli  t6, \reg, \dist
    slli  \reg, \reg, 32-\dist
    xor   \reg, \reg, t6
    add t6, zero, zero // CLEAR
.endm

.macro rolA reg,dist
    slli  t6, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, t6
    add t6, zero, zero // CLEAR
.endm

.macro rorB reg,dist
    srli  s6, \reg, \dist
    slli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s6
    add s6, zero, zero // CLEAR
.endm

.macro rolB reg,dist
    slli  s6, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s6
    add s6, zero, zero // CLEAR
.endm


.global chi
.balign 4
// a0 = void * state0
// a1 = void * state1
chi:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

// a0 = void * state0
// a1 = void * state1
// t1-t5 for shares0
// s1-s5 for shares1
// s7 temporary register for cross-products
// a6 randomness R0
// a7 randomness R1

    add s9, zero, zero 
    add s10, zero, zero
    addi s11, zero, 5
    
    // Load share A randomness in a6
    lw a6, 0(a2)
    // Load share B randomness in a7
    lw a7, 0(a3)

1:

// x = 0
// lane at (0,y)
    // get index (0,y)
    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 0
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -20(fp)
    lw a0, -12(fp)
    lw a1, -16(fp)
    // set offset for (((uint32_t *)stateA)[i(0, y)])
    add t1, a0, a4
    // get (((uint32_t *)stateA)[i(0, y)])
    lw t1, 0(t1)
    // set offset for (((uint32_t *)stateB)[i(0, y)])
    add s1, a1, a4
    // get (((uint32_t *)stateB)[i(0, y)])
    lw s1, 0(s1)

// x = 1
// lane at (1,y)
    // get index (1,y)
    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 1
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -24(fp) // store pointer index x = 1
    lw a0, -12(fp)
    lw a1, -16(fp)
    // set offset for (((uint32_t *)stateA)[i(1, y)])
    add t2, a0, a4
    // get (((uint32_t *)stateA)[i(1, y)])
    lw t2, 0(t2)
    // set offset for (((uint32_t *)stateB)[i(1, y)])
    add s2, a1, a4
    // get (((uint32_t *)stateB)[i(1, y)])
    lw s2, 0(s2)

// x = 2
// lane at (2,y)
    // get index (2,y)
    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 2
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -28(fp) // store pointer index x = 2
    lw a0, -12(fp)
    lw a1, -16(fp)
    // set offset for (((uint32_t *)state)[i(2, y)])
    add t3, a0, a4
    // get (((uint32_t *)stateA)[i(2, y)])
    lw t3, 0(t3)
    // set offset for (((uint32_t *)stateB)[i(2, y)])
    add s3, a1, a4
    // get (((uint32_t *)stateB)[i(2, y)])
    lw s3, 0(s3)

// x = 3
// lane at (3,y)
    // get index (3,y)
    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 3
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -32(fp) // store pointer index x = 3
    lw a0, -12(fp)
    lw a1, -16(fp)
    // set offset for (((uint32_t *)state)[i(3, y)])
    add t4, a0, a4
    // get (((uint32_t *)stateA)[i(3, y)])
    lw t4, 0(t4)
    // set offset for (((uint32_t *)stateB)[i(3, y)])
    add s4, a1, a4
    // get (((uint32_t *)stateB)[i(3, y)])
    lw s4, 0(s4)

// x = 4
// lane at (4,y)
    // get index (4,y)
    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 4
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -36(fp) // store pointer index x = 4
    lw a0, -12(fp)
    lw a1, -16(fp)
    // set offset for (((uint32_t *)state)[i(4, y)])
    add t5, a0, a4
    // get (((uint32_t *)stateA)[i(4, y)])
    lw t5, 0(t5)
    // set offset for (((uint32_t *)stateB)[i(4, y)])
    add s5, a1, a4
    // get (((uint32_t *)stateB)[i(4, y)])
    lw s5, 0(s5)

    ////////////// Compute χ on the plane //////////////

    // update R0
    and s7, t1, t5 // e0a0
    xor a6, a6, s7 // r0 + e0a0
    xor a6, a6, t1 // r0 + e0a0 + a0
    rorA t5, 2
    rorB s1, 1
    and s7, t5, s1 // e0a1
    rolA t5, 2
    rolB s1, 1
    // shift a6 to index 2
    rorA a6, 2
    xor a6, a6, s7
    // shift back a6
    rolA a6, 2

    // update R1
    and s7, s1, s5 // e1a1
    xor a7, a7, s7 // r1 + e1a1
    xor a7, a7, s1 // r1 + e1a1 + a1
    rorA t1, 2
    rorB s5, 1
    and s7, t1, s5 // e1a0
    rolA t1, 2
    rolB s5, 1
    // shift a7 to index 2
    rorB a7, 1
    xor a7, a7, s7
    // shift back a7
    rolB a7, 1

    //update A0
    and s7, t2, t3 // b0c0
    xor t1, t1, s7 // a0 + b0c0
    xor t1, t1, t3 // a0 + b0c0 + c0
    rorA t2, 2
    rorB s3, 1
    and s7, t2, s3 // b0c1
    rolA t2, 2
    rolB s3, 1
    // shift t1 to index 2
    rorA t1, 2
    xor t1, t1, s7
    // shift back t1
    rolA t1, 2
    // store in memory
    lw a4, -20(fp)
    // construct offset A
    add t0, a0, a4
    sw t1, 0(t0)
    
    //update A1
    and s7, s2, s3 // b1c1
    xor s1, s1, s7 // a1 + b1c1
    xor s1, s1, s3 // a1 + b1c1 + c1
    rorA t3, 2
    rorB s2, 1
    and s7, t3, s2 // b1c0
    rolA t3, 2
    rolB s2, 1
    // shift s1 to index 2
    rorB s1, 1
    xor s1, s1, s7
    // shift back s1
    rolB s1, 1
    // store in memory
    // construct offset B
    add t0, a1, a4
    sw s1, 0(t0)

    //update C0
    and s7, t4, t5 // d0e0
    xor t3, t3, s7 // c0 + d0e0
    xor t3, t3, t5 // c0 + d0e0 + e0
    rorA t4, 2
    rorB s5, 1
    and s7, t4, s5 // d0e1
    rolA t4, 2
    rolB s5, 1
    // shift t3 to index 2
    rorA t3, 2
    xor t3, t3, s7
    // shift back t3
    rolA t3, 2
    // store in memory
    lw a4, -28(fp)
    // construct offset A
    add t0, a0, a4
    sw t3, 0(t0)

    //update C1
    and s7, s4, s5 // d1e1
    xor s3, s3, s7 // c1 + d1e1
    xor s3, s3, s5 // c1 + d1e1 + e1
    rorA t5, 2
    rorB s4, 1
    and s7, t5, s4 // d1e0
    rolA t5, 2
    rolB s4, 1
    // shift s3 to index 2
    rorB s3, 1
    xor s3, s3, s7
    // shift back s3
    rolB s3, 1
    // store in memory
    // construct offset B
    add t0, a1, a4
    sw s3, 0(t0)

    //update E0
    and s7, t1, t2 // a0b0
    xor t5, t5, s7 // e0 + a0b0
    xor t5, t5, t2 // e0 + a0b0 + b0
    rorA t1, 2
    rorB s2, 1
    and s7, t1, s2 // a0b1
    rolA t1, 2
    rolB s2, 1
    // shift t5 to index 2
    rorA t5, 2
    xor t5, t5, s7
    // shift back t5
    rolA t5, 2
    // store in memory
    lw a4, -36(fp)
    // construct offset A
    add t0, a0, a4
    sw t5, 0(t0)

    //update E1
    and s7, s1, s2 // a1b1
    xor s5, s5, s7 // e1 + a1b1
    xor s5, s5, s2 // e1 + a1b1 + b1
    rorA t2, 2
    rorB s1, 1
    and s7, t2, s1 // a1b0
    rolA t2, 2
    rolB s1, 1
    // shift s5 to index 2
    rorB s5, 1
    xor s5, s5, s7
    // shift back s5
    rolB s5, 1
    // store in memory
    // construct offset B
    add t0, a1, a4
    sw s5, 0(t0)

    //update B0
    and s7, t3, t4 // c0d0
    xor t2, t2, s7 // b0 + c0d0
    xor t2, t2, t4 // b0 + c0d0 + d0
    rorA t3, 2
    rorB s4, 1
    and s7, t3, s4 // c0d1
    rolA t3, 2
    rolB s4, 1
    // shift t2 to index 2
    rorA t2, 2
    xor t2, t2, s7
    // shift back t2
    rolA t2, 2
    // store in memory 
    lw a4, -24(fp)
    // construct offset A
    add t0, a0, a4
    sw t2, 0(t0)

    //update B1
    and s7, s3, s4 // c1d1
    xor s2, s2, s7 // b1 + c1d1
    xor s2, s2, s4 // b1 + c1d1 + d1
    rorA t4, 2
    rorB s3, 1
    and s7, t4, s3 // c1d0
    rolA t4, 2
    rolB s3, 1
    // shift s2 to index 2
    rorB s2, 1
    xor s2, s2, s7
    // shift back s2
    rolB s2, 1
    // store in memory
    // construct offset B
    add t0, a1, a4
    sw s2, 0(t0)

    //update D0
    xor t4, t4, a6 // d0 + r0 
    // store in memory
    lw a4, -32(fp)
    // construct offset A
    add t0, a0, a4
    sw t4, 0(t0)

    //update D1
    xor s4, s4, a7 // d1 + r1
    // store in memory
    // construct offset B
    add t0, a1, a4
    sw s4, 0(t0)

    //update the two randomness with A1
    mv a6, s1 // update R0
    mv a7, s1 // update R1
    //rotate R1
    rorB a7, 1

    addi s10, s10, 1
    blt s10, s11, 1b

    //store in memory the updated randomness
    sw a6, 0(a2)
    sw a7, 0(a3)

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


///////////////////////////////////////////////////////////////////////////
/////////////////////////////////// IOTA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////


.global iota
.balign 4

// a0 = void * state0
// a1 = nround
iota:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    la t1, KeccakRoundConstants
    slli t2, a1, 2
    add t1, t1, t2 // get offset for KeccakRoundConstants
    lw t2, 0(t1) // t2 = value KeccakRoundConstants[x]
    lw t1, 0(a0) // get state(0,0)
    xor t1, t1, t2
    sw t1, 0(a0)

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


//////////////////////////////////////////////////////////////////////////
/////////////////////////// KeccakF800_StatePermute ///////////////////
//////////////////////////////////////////////////////////////////////////


.global KeccakF800_StatePermute
.balign 4

// a0 = void * state0
// a1 = void * state1
// a2 = void * randomness0
// a3 = void * randomness1

KeccakF800_StatePermute:
//FUNCTION PROLOGUE
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64
    sw a2, -28(fp)
    sw a3, -32(fp)

// CODE
    add t4, zero, zero
    addi t5, zero, 22

1:
    sw t4, -12(fp)
    sw t5, -16(fp)
    sw a1, -20(fp)
    /////// share A ///////
    jal ra, theta
    jal ra, rhoPi
    sw a0, -24(fp)
    ///////  share B ///////
    lw a0, -20(fp)
    jal ra, theta
    jal ra, rhoPi
    mv a1, a0
    lw a0, -24(fp)
    /////// CHI ///////
    lw a2, -28(fp)
    lw a3, -32(fp)
    jal ra, chi
    lw t4, -12(fp)
    sw a1, -20(fp)
    mv a1, t4
    /////// iota ///////
    jal ra, iota
    // loop update
    lw t4, -12(fp)
    lw t5, -16(fp)
    lw a1, -20(fp)
    addi t4, t4, 1
    blt t4, t5, 1b

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret

