////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// RISC-V masked shares aligned Keccak-f[800] //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    lw s1, 0(a0)
    lw s2, 20(a0)
    lw s3, 40(a0)
    lw s4, 60(a0)
    lw s5, 80(a0)
    xor s6, s1, s2
    xor s6, s6, s3
    xor s6, s6, s4
    xor s6, s6, s5

    lw t1, 4(a0)
    lw t2, 24(a0)
    lw t3, 44(a0)
    lw t4, 64(a0)
    lw t5, 84(a0)
    xor s7, t1, t2
    xor s7, s7, t3
    xor s7, s7, t4
    xor s7, s7, t5

    lw s1, 8(a0)
    lw s2, 28(a0)
    lw s3, 48(a0)
    lw s4, 68(a0)
    lw s5, 88(a0)
    xor s8, s1, s2
    xor s8, s8, s3
    xor s8, s8, s4
    xor s8, s8, s5

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
    sw t1, 4(a0)
    sw t2, 24(a0)
    sw t3, 44(a0)
    sw t4, 64(a0)
    sw t5, 84(a0)

    lw t1, 12(a0)
    lw t2, 32(a0)
    lw t3, 52(a0)
    lw t4, 72(a0)
    lw t5, 92(a0)
    xor s9, t1, t2
    xor s9, s9, t3
    xor s9, s9, t4
    xor s9, s9, t5

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
    sw s1, 8(a0)
    sw s2, 28(a0)
    sw s3, 48(a0)
    sw s4, 68(a0)
    sw s5, 88(a0)

    lw s1, 16(a0)
    lw s2, 36(a0)
    lw s3, 56(a0)
    lw s4, 76(a0)
    lw s5, 96(a0)
    xor t1, t1, s8
    xor t2, t2, s8
    xor t3, t3, s8
    xor t4, t4, s8
    xor t5, t5, s8

    xor s8, s1, s2
    xor s8, s8, s3
    xor s8, s8, s4
    xor s8, s8, s5
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
    sw t1, 12(a0)
    sw t2, 32(a0)
    sw t3, 52(a0)
    sw t4, 72(a0)
    sw t5, 92(a0)

    lw t1, 0(a0)
    lw t2, 20(a0)
    lw t3, 40(a0)
    lw t4, 60(a0)
    lw t5, 80(a0)
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
    sw t1, 0(a0)
    sw t2, 20(a0)
    sw t3, 40(a0)
    sw t4, 60(a0)
    sw t5, 80(a0)
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


    addi s1, zero, 24 
    add s2, zero, zero
    addi s3, zero, 1
    slli s4, s3, 2
    add a6, s4, a0
    lw t1, 0(a6) 
1:
    slli a7, s2, 2 
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 2
    add s7, a0, s8 
    lw t2, 0(s7) 

    add s8, s5 ,a7 
    lw s8, 0(s8) 

    sll t3, t1, s8
    sub s8, zero, s8
    addi s8, s8, 32
    srl t1, t1, s8
    xor t3, t1, t3 

    sw t3, 0(s7)
    mv t1, t2
    addi s2, s2, 1
    blt s2, s1, 1b

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret



//////////////////////////////////////////////////////////////////////////
////////////////////////////////// CHI ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.global chi
.balign 4

chi:
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    add s9, zero, zero
    add s10, zero, zero 
    addi s11, zero, 5 

    lw a6, 0(a2)
    lw a7, 0(a3)

1:

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
    add t1, a0, a4
    lw t1, 0(t1)
    add s1, a1, a4
    lw s1, 0(s1)

    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 1
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -24(fp)
    lw a0, -12(fp)
    lw a1, -16(fp)
    add t2, a0, a4
    lw t2, 0(t2)
    add s2, a1, a4
    lw s2, 0(s2)

    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 2
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -28(fp)
    lw a0, -12(fp)
    lw a1, -16(fp)
    add t3, a0, a4
    lw t3, 0(t3)
    add s3, a1, a4
    lw s3, 0(s3)

    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 3
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -32(fp)
    lw a0, -12(fp)
    lw a1, -16(fp)
    add t4, a0, a4
    lw t4, 0(t4)
    add s4, a1, a4
    lw s4, 0(s4)

    sw a0, -12(fp)
    sw a1, -16(fp)
    addi s9, zero, 4
    mv a0, s9
    mv a1, s10
    jal ra, i
    mv a4, a0
    sw a4, -36(fp)
    lw a0, -12(fp)
    lw a1, -16(fp)
    add t5, a0, a4
    lw t5, 0(t5)
    add s5, a1, a4
    lw s5, 0(s5)

    and s7, t1, t5 
    xor a6, a6, s7 
    xor a6, a6, t1 
    and s7, t5, s1 
    xor a6, a6, s7

    and s7, s1, s5 
    xor a7, a7, s7 
    xor a7, a7, s1 
    and s7, t1, s5 
    xor a7, a7, s7

    and s7, t2, t3 
    xor t1, t1, s7
    xor t1, t1, t3
    and s7, t2, s3
    xor t1, t1, s7
    lw a4, -20(fp) 
    add t0, a0, a4
    sw t1, 0(t0)

    and s7, s2, s3 
    xor s1, s1, s7 
    xor s1, s1, s3 
    and s7, t3, s2 
    xor s1, s1, s7
    add t0, a1, a4
    sw s1, 0(t0)


   
    and s7, t4, t5 
    xor t3, t3, s7 
    xor t3, t3, t5 
    and s7, t4, s5
    xor t3, t3, s7
    lw a4, -28(fp) 
    add t0, a0, a4
    sw t3, 0(t0)


    and s7, s4, s5
    xor s3, s3, s7
    xor s3, s3, s5
    and s7, t5, s4
    xor s3, s3, s7
    add t0, a1, a4
    sw s3, 0(t0)


    and s7, t1, t2 
    xor t5, t5, s7 
    xor t5, t5, t2 
    and s7, t1, s2 
    xor t5, t5, s7
    lw a4, -36(fp)
    add t0, a0, a4
    sw t5, 0(t0)


    and s7, s1, s2 
    xor s5, s5, s7
    xor s5, s5, s2
    and s7, t2, s1
    xor s5, s5, s7
    add t0, a1, a4
    sw s5, 0(t0)

    and s7, t3, t4
    xor t2, t2, s7
    xor t2, t2, t4
    and s7, t3, s4
    xor t2, t2, s7
    lw a4, -24(fp)
    add t0, a0, a4
    sw t2, 0(t0)

    and s7, s3, s4
    xor s2, s2, s7
    xor s2, s2, s4
    and s7, t4, s3
    xor s2, s2, s7
    add t0, a1, a4
    sw s2, 0(t0)

    xor t4, t4, a6
    lw a4, -32(fp) 
    add t0, a0, a4
    sw t4, 0(t0)

    xor s4, s4, a7
    add t0, a1, a4
    sw s4, 0(t0)

    mv a6, s1
    mv a7, s1

    addi s10, s10, 1
    blt s10, s11, 1b

    sw a6, 0(a2)
    sw a7, 0(a3)

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


//////////////////////////////////////////////////////////////////////////
/////////////////////////////////// IOTA//////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.global iota
.balign 4

iota:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64


    la t1, KeccakRoundConstants
    slli t2, a1, 2
    add t1, t1, t2
    lw t2, 0(t1)
    lw t1, 0(a0)
    xor t1, t1, t2
    sw t1, 0(a0)

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


///////////////////////////////////////////////////////////////////////
/////////////////////////// KeccakF800_StatePermute ///////////////////
///////////////////////////////////////////////////////////////////////


.global KeccakF800_StatePermute
.balign 4

KeccakF800_StatePermute:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64
    sw a2, -28(fp)
    sw a3, -32(fp)

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

    lw t4, -12(fp)
    lw t5, -16(fp)
    lw a1, -20(fp)
    addi t4, t4, 1
    blt t4, t5, 1b

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret

