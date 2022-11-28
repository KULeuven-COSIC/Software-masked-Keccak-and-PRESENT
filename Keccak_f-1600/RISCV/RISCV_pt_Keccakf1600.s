////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// RISC-V plaintext Keccak-f[1600] /////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

.data

.balign 4
.globl KeccakP1600_RotationConstants 
KeccakP1600_RotationConstants:
    .word 0x00000001
    .word 0x00000003
    .word 0x00000006
    .word 0x0000000a
    .word 0x0000000f
    .word 0x00000015
    .word 0x0000001c
    .word 0x00000024
    .word 0x0000002d
    .word 0x00000037
    .word 0x00000002
    .word 0x0000000e
    .word 0x0000001b
    .word 0x00000029
    .word 0x00000038
    .word 0x00000008
    .word 0x00000019
    .word 0x0000002b
    .word 0x0000003e
    .word 0x00000012
    .word 0x00000027
    .word 0x0000003d
    .word 0x00000014
    .word 0x0000002c


.balign 4
.globl KeccakP1600_PiLane 
KeccakP1600_PiLane:
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

.word 0x00000001 // low
.word 0x00000000 // high
.word 0x00000000
.word 0x00000089
.word 0x00000000
.word 0x8000008b
.word 0x00000000
.word 0x80008080
.word 0x00000001
.word 0x0000008b
.word 0x00000001
.word 0x00008000
.word 0x00000001
.word 0x80008088
.word 0x00000001
.word 0x80000082
.word 0x00000000
.word 0x0000000b
.word 0x00000000
.word 0x0000000a
.word 0x00000001
.word 0x00008082
.word 0x00000000
.word 0x00008003
.word 0x00000001
.word 0x0000808b
.word 0x00000001
.word 0x8000000b
.word 0x00000001
.word 0x8000008a
.word 0x00000001
.word 0x80000081
.word 0x00000000
.word 0x80000081
.word 0x00000000
.word 0x80000008
.word 0x00000000
.word 0x00000083
.word 0x00000000
.word 0x80008003
.word 0x00000001
.word 0x80008088
.word 0x00000000
.word 0x80000088
.word 0x00000001
.word 0x00008000
.word 0x00000000
.word 0x80008082

.text


.macro rolTheta reg,dist
    slli  a6, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, a6
    add a6, zero, zero 
.endm


.macro rolRho reg,dist
    slli  a5, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, a5
    add a5, zero, zero 
.endm


.balign 4

iA:
    add t0,zero, a1
    slli a1,a1,2
    add a1,a1,t0
    slli a1,a1,1 // 10*y
    slli a0,a0,1 // 2*x
    add a0,a0,a1 
    slli a0,a0,2
    ret


.balign 4

iB:
    add t0,zero, a1
    slli a1,a1,2
    add a1,a1,t0
    slli a1,a1,1 // 10*y
    slli a0,a0,1 // 2*x
    add a0,a0,a1 
    addi a0, a0, 1
    slli a0,a0,2
    ret



///////////////////////////////////////////////////////////////////////////
////////////////////////////////// THETA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////


.global theta
.balign 4
// a0 = state

theta:
    addi sp,sp,-64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp,sp,64
    sw a0, -12(fp)



    // load sheet 1A
    lw s1, 0(a0)
    lw s2, 40(a0)
    lw s3, 80(a0)
    lw s4, 120(a0)
    lw s5, 160(a0)
    xor s6, s1, s2
    xor s6, s6, s3
    xor s6, s6, s4
    xor s6, s6, s5 

    // load sheet 1B
    lw t1, 4(a0)
    lw t2, 44(a0)
    lw t3, 84(a0)
    lw t4, 124(a0)
    lw t5, 164(a0)
    xor s7, t1, t2
    xor s7, s7, t3
    xor s7, s7, t4
    xor s7, s7, t5 

    // load sheet 3A
    lw s1, 16(a0)
    lw s2, 56(a0)
    lw s3, 96(a0)
    lw s4, 136(a0)
    lw s5, 176(a0)
    xor s8, s1, s2
    xor s8, s8, s3
    xor s8, s8, s4
    xor s8, s8, s5 

    // load sheet 3B
    lw t1, 20(a0)
    lw t2, 60(a0)
    lw t3, 100(a0)
    lw t4, 140(a0)
    lw t5, 180(a0)
    xor s9, t1, t2
    xor s9, s9, t3
    xor s9, s9, t4
    xor s9, s9, t5 

    
    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 2/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 2A
    lw s1, 8(a0)
    lw s2, 48(a0)
    lw s3, 88(a0)
    lw s4, 128(a0)
    lw s5, 168(a0)
    xor a2, s1, s2
    xor a2, a2, s3
    xor a2, a2, s4
    xor a2, a2, s5 

    // load sheet 2B
    lw t1, 12(a0)
    lw t2, 52(a0)
    lw t3, 92(a0)
    lw t4, 132(a0)
    lw t5, 172(a0)
    xor a3, t1, t2
    xor a3, a3, t3
    xor a3, a3, t4
    xor a3, a3, t5 


    // ADD SUM S1A
    xor s1, s1, s6
    xor s2, s2, s6
    xor s3, s3, s6
    xor s4, s4, s6
    xor s5, s5, s6

    // ADD SUM S1B
    xor t1, t1, s7
    xor t2, t2, s7
    xor t3, t3, s7
    xor t4, t4, s7
    xor t5, t5, s7

    
    mv s11, s9 
    rolTheta s11, 1 
    mv s10, s8 

    // ADD ROL S3A
    xor s1, s1, s11
    xor s2, s2, s11
    xor s3, s3, s11
    xor s4, s4, s11
    xor s5, s5, s11

    // ADD ROL S3B
    xor t1, t1, s10
    xor t2, t2, s10
    xor t3, t3, s10
    xor t4, t4, s10
    xor t5, t5, s10

    // Store updated Sheet 2
    // store sheet 2A
    sw s1, 8(a0)
    sw s2, 48(a0)
    sw s3, 88(a0)
    sw s4, 128(a0)
    sw s5, 168(a0)

    // store sheet 2B
    sw t1, 12(a0)
    sw t2, 52(a0)
    sw t3, 92(a0)
    sw t4, 132(a0)
    sw t5, 172(a0)

    ///---------------------------------------------------//


    // load sheet 4A
    lw s1, 24(a0)
    lw s2, 64(a0)
    lw s3, 104(a0)
    lw s4, 144(a0)
    lw s5, 184(a0)
    xor t0, s1, s2
    xor t0, t0, s3
    xor t0, t0, s4
    xor t0, t0, s5 

    // load sheet 4B
    lw t1, 28(a0)
    lw t2, 68(a0)
    lw t3, 108(a0)
    lw t4, 148(a0)
    lw t5, 188(a0)
    xor t6, t1, t2
    xor t6, t6, t3
    xor t6, t6, t4
    xor t6, t6, t5 

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 3/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 3A
    lw s1, 16(a0)
    lw s2, 56(a0)
    lw s3, 96(a0)
    lw s4, 136(a0)
    lw s5, 176(a0)

    // load sheet 3B
    lw t1, 20(a0)
    lw t2, 60(a0)
    lw t3, 100(a0)
    lw t4, 140(a0)
    lw t5, 180(a0)

    // ADD SUM S2A
    xor s1, s1, a2
    xor s2, s2, a2
    xor s3, s3, a2
    xor s4, s4, a2
    xor s5, s5, a2

    // ADD SUM S2B
    xor t1, t1, a3
    xor t2, t2, a3
    xor t3, t3, a3
    xor t4, t4, a3
    xor t5, t5, a3

    
    mv s11, t6 
    rolTheta s11, 1 
    mv s10, t0 



    // ADD ROL S4A
    xor s1, s1, s11
    xor s2, s2, s11
    xor s3, s3, s11
    xor s4, s4, s11
    xor s5, s5, s11

    // ADD ROL S4B
    xor t1, t1, s10
    xor t2, t2, s10
    xor t3, t3, s10
    xor t4, t4, s10
    xor t5, t5, s10

    // Store updated Sheet 3
    // store sheet 3A
    sw s1, 16(a0)
    sw s2, 56(a0)
    sw s3, 96(a0)
    sw s4, 136(a0)
    sw s5, 176(a0)

    // store sheet 3B
    sw t1, 20(a0)
    sw t2, 60(a0)
    sw t3, 100(a0)
    sw t4, 140(a0)
    sw t5, 180(a0)

///---------------------------------------------------//

    // load sheet 5A
    lw s1, 32(a0)
    lw s2, 72(a0)
    lw s3, 112(a0)
    lw s4, 152(a0)
    lw s5, 192(a0)
    xor a4, s1, s2
    xor a4, a4, s3
    xor a4, a4, s4
    xor a4, a4, s5 

    // load sheet 5B
    lw t1, 36(a0)
    lw t2, 76(a0)
    lw t3, 116(a0)
    lw t4, 156(a0)
    lw t5, 196(a0)
    xor a5, t1, t2
    xor a5, a5, t3
    xor a5, a5, t4
    xor a5, a5, t5 

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 4/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 4A
    lw s1, 24(a0)
    lw s2, 64(a0)
    lw s3, 104(a0)
    lw s4, 144(a0)
    lw s5, 184(a0)

    // load sheet 4B
    lw t1, 28(a0)
    lw t2, 68(a0)
    lw t3, 108(a0)
    lw t4, 148(a0)
    lw t5, 188(a0)

    // ADD SUM S3A
    xor s1, s1, s8
    xor s2, s2, s8
    xor s3, s3, s8
    xor s4, s4, s8
    xor s5, s5, s8

    // ADD SUM S3B
    xor t1, t1, s9
    xor t2, t2, s9
    xor t3, t3, s9
    xor t4, t4, s9
    xor t5, t5, s9

    
    mv s11, a5 
    rolTheta s11, 1 
    mv s10, a4 

    // ADD ROL S5A
    xor s1, s1, s11
    xor s2, s2, s11
    xor s3, s3, s11
    xor s4, s4, s11
    xor s5, s5, s11

    // ADD ROL S5B
    xor t1, t1, s10
    xor t2, t2, s10
    xor t3, t3, s10
    xor t4, t4, s10
    xor t5, t5, s10

    // store sheet 4A
    sw s1, 24(a0)
    sw s2, 64(a0)
    sw s3, 104(a0)
    sw s4, 144(a0)
    sw s5, 184(a0)

    // store sheet 4B
    sw t1, 28(a0)
    sw t2, 68(a0)
    sw t3, 108(a0)
    sw t4, 148(a0)
    sw t5, 188(a0)

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 5/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 5A
    lw s1, 32(a0)
    lw s2, 72(a0)
    lw s3, 112(a0)
    lw s4, 152(a0)
    lw s5, 192(a0)

    // load sheet 5B
    lw t1, 36(a0)
    lw t2, 76(a0)
    lw t3, 116(a0)
    lw t4, 156(a0)
    lw t5, 196(a0)

    // ADD SUM S4A
    xor s1, s1, t0
    xor s2, s2, t0
    xor s3, s3, t0
    xor s4, s4, t0
    xor s5, s5, t0

    // ADD SUM S4B
    xor t1, t1, t6
    xor t2, t2, t6
    xor t3, t3, t6
    xor t4, t4, t6
    xor t5, t5, t6

    
    mv s11, s7 
    rolTheta s11, 1 
    mv s10, s6 

    // ADD ROL S1A
    xor s1, s1, s11
    xor s2, s2, s11
    xor s3, s3, s11
    xor s4, s4, s11
    xor s5, s5, s11

    // ADD ROL S1B
    xor t1, t1, s10
    xor t2, t2, s10
    xor t3, t3, s10
    xor t4, t4, s10
    xor t5, t5, s10

    // store sheet 5A
    sw s1, 32(a0)
    sw s2, 72(a0)
    sw s3, 112(a0)
    sw s4, 152(a0)
    sw s5, 192(a0)

    // store sheet 5B
    sw t1, 36(a0)
    sw t2, 76(a0)
    sw t3, 116(a0)
    sw t4, 156(a0)
    sw t5, 196(a0)


    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 1/////////////////////////
    ///////////////////////////////////////////////////////////////////////////

    // load sheet 1A
    lw s1, 0(a0)
    lw s2, 40(a0)
    lw s3, 80(a0)
    lw s4, 120(a0)
    lw s5, 160(a0)
    
    // load sheet 1B
    lw t1, 4(a0)
    lw t2, 44(a0)
    lw t3, 84(a0)
    lw t4, 124(a0)
    lw t5, 164(a0)
    
    // ADD SUM S5A
    xor s1, s1, a4
    xor s2, s2, a4
    xor s3, s3, a4
    xor s4, s4, a4
    xor s5, s5, a4

    // ADD SUM S5B
    xor t1, t1, a5
    xor t2, t2, a5
    xor t3, t3, a5
    xor t4, t4, a5
    xor t5, t5, a5

    
    mv s11, a3 
    rolTheta s11, 1 
    mv s10, a2 

    // ADD ROL S2A
    xor s1, s1, s11
    xor s2, s2, s11
    xor s3, s3, s11
    xor s4, s4, s11
    xor s5, s5, s11

    // ADD ROL S2B
    xor t1, t1, s10
    xor t2, t2, s10
    xor t3, t3, s10
    xor t4, t4, s10
    xor t5, t5, s10
    
    // store sheet 5A
    sw s1, 0(a0)
    sw s2, 40(a0)
    sw s3, 80(a0)
    sw s4, 120(a0)
    sw s5, 160(a0)
    
    // store sheet 5B
    sw t1, 4(a0)
    sw t2, 44(a0)
    sw t3, 84(a0)
    sw t4, 124(a0)
    sw t5, 164(a0)


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

    la s5, KeccakP1600_RotationConstants
    la s9, KeccakP1600_PiLane


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  0 : odd and tau =  0.0


    

    add t5, zero, zero //t5 = x
    addi s3, zero, 1 
    slli s4, s3, 3 
    add a6, s4, a0
    lw t1, 0(a6) 
    lw s1, 4(a6) 


    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 1 
    mv s11, t1 
    

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1
    

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  1 : odd and tau =  1.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 2 
    mv s11, t1 
    rolRho s11, 1 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1
    
//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  2 : even and tau =  3.0


    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 3 
    mv s11, s1 
    rolRho s11, 3 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  3 : even and tau =  5.0


    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 5 
    mv s11, s1 
    rolRho s11, 5 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  4 : odd and tau =  7.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 8 
    mv s11, t1 
    rolRho s11, 7 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  5 : odd and tau =  10.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 11 
    mv s11, t1 
    rolRho s11, 10 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  6 : even and tau =  14.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 14 
    mv s11, s1 
    rolRho s11, 14 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  7 : even and tau =  18.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 18 
    mv s11, s1 
    rolRho s11, 18 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  8 : odd and tau =  22.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 23 
    mv s11, t1 
    rolRho s11, 22 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  9 : odd and tau =  27.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 28 
    mv s11, t1 
    rolRho s11, 27 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  10 : even and tau =  1.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 1 
    mv s11, s1 
    rolRho s11, 1 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  11 : even and tau =  7.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 7 
    mv s11, s1 
    rolRho s11, 7 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  12 : odd and tau =  13.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 14 
    mv s11, t1 
    rolRho s11, 13 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  13 : odd and tau =  20.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 21 
    mv s11, t1 
    rolRho s11, 20 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  14 : even and tau =  28.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 28 
    mv s11, s1 
    rolRho s11, 28 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  15 : even and tau =  4.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 4 
    mv s11, s1 
    rolRho s11, 4 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  16 : odd and tau =  12.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 13 
    mv s11, t1 
    rolRho s11, 12 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  17 : odd and tau =  21.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 22 
    mv s11, t1 
    rolRho s11, 21 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  18 : even and tau =  31.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 31 
    mv s11, s1 
    rolRho s11, 31 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  19 : even and tau =  9.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 9 
    mv s11, s1 
    rolRho s11, 9 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  20 : odd and tau =  19.0

    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 20 
    mv s11, t1 
    rolRho s11, 19 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  21 : odd and tau =  30.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****ODD ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, s1 
    rolRho s10, 31 
    mv s11, t1 
    rolRho s11, 30 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  22 : even and tau =  10.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 10 
    mv s11, s1 
    rolRho s11, 10 

    sw s10, 0(s7)
    sw s11, 4(s7)

    mv t1, t2 
    mv s1, s2 
    addi t5, t5, 1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  23 : even and tau =  22.0
    slli a7, t5, 2
    add a6, a7, s9 
    lw a6, 0(a6) 
    slli s8, a6, 3
    add s7, a0, s8 
    lw t2, 0(s7) 
    lw s2, 4(s7) 
    


    // *****EVEN ***** ROL64(tempA-tempB,s8) (left rotation)
    mv s10, t1 
    rolRho s10, 22 
    mv s11, s1 
    rolRho s11, 22 

    sw s10, 0(s7)
    sw s11, 4(s7)


    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


//////////////////////////////////////////////////////////////////////////
////////////////////////////////// CHI_pA ///////////////////////////////////
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




//////////////////////////////////////////////////////////////////////////
////////////////////////////////// chi_ptA ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////


////////////////////////////////// CHI //////////////////////////////////
.balign 4


.global chi_ptA
chi_ptA:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64



    add t4, zero, zero 
    add t5, zero, zero 
    addi t6, zero, 5 
1:
////////////////// x = 0
    
    sw a0, -12(fp)
    addi t4, zero, 0
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s1, 0(t1)

////////////////// x = 1
    
    sw a0, -12(fp)
    addi t4, zero, 1
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s2, 0(t1)

////////////////// x = 2
    
    sw a0, -12(fp)
    addi t4, zero, 2
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s3, 0(t1)

////////////////// x = 3
    
    sw a0, -12(fp)
    addi t4, zero, 3
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s4, 0(t1)

////////////////// x = 4
    
    sw a0, -12(fp)
    addi t4, zero, 4
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s5, 0(t1)

// Compute χ on the plane //
////////////////// x = 0
    
    sw a0, -12(fp)
    addi t4, zero, 0
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s2
    and t0, t0, s3
    xor t0, t0, s1
    sw t0, 0(t1)

////////////////// x = 1
    
    sw a0, -12(fp)
    addi t4, zero, 1
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s3
    and t0, t0, s4
    xor t0, t0, s2
    sw t0, 0(t1)

////////////////// x = 2
    
    sw a0, -12(fp)
    addi t4, zero, 2
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s4
    and t0, t0, s5
    xor t0, t0, s3
    sw t0, 0(t1)

////////////////// x = 3
    
    sw a0, -12(fp)
    addi t4, zero, 3
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s5
    and t0, t0, s1
    xor t0, t0, s4
    sw t0, 0(t1)

////////////////// x = 4
    
    sw a0, -12(fp)
    addi t4, zero, 4
    mv a0, t4
    mv a1, t5
    jal ra, iA
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s1
    and t0, t0, s2
    xor t0, t0, s5
    sw t0, 0(t1)

    addi t5, t5, 1
    blt t5, t6, 1b



    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret



//////////////////////////////////////////////////////////////////////////
////////////////////////////////// chi_ptB///////////////////////////////////
//////////////////////////////////////////////////////////////////////////


////////////////////////////////// CHI //////////////////////////////////
.balign 4


.global chi_ptB
chi_ptB:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64



    add t4, zero, zero 
    add t5, zero, zero 
    addi t6, zero, 5 
1:
////////////////// x = 0
    
    sw a0, -12(fp)
    addi t4, zero, 0
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s1, 0(t1)

////////////////// x = 1
    
    sw a0, -12(fp)
    addi t4, zero, 1
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s2, 0(t1)

////////////////// x = 2
    
    sw a0, -12(fp)
    addi t4, zero, 2
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s3, 0(t1)

////////////////// x = 3
    
    sw a0, -12(fp)
    addi t4, zero, 3
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s4, 0(t1)

////////////////// x = 4
    
    sw a0, -12(fp)
    addi t4, zero, 4
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    
    lw s5, 0(t1)

// Compute χ on the plane //
////////////////// x = 0
    
    sw a0, -12(fp)
    addi t4, zero, 0
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s2
    and t0, t0, s3
    xor t0, t0, s1
    sw t0, 0(t1)

////////////////// x = 1
    
    sw a0, -12(fp)
    addi t4, zero, 1
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s3
    and t0, t0, s4
    xor t0, t0, s2
    sw t0, 0(t1)

////////////////// x = 2
    
    sw a0, -12(fp)
    addi t4, zero, 2
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s4
    and t0, t0, s5
    xor t0, t0, s3
    sw t0, 0(t1)

////////////////// x = 3
    
    sw a0, -12(fp)
    addi t4, zero, 3
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s5
    and t0, t0, s1
    xor t0, t0, s4
    sw t0, 0(t1)

////////////////// x = 4
    
    sw a0, -12(fp)
    addi t4, zero, 4
    mv a0, t4
    mv a1, t5
    jal ra, iB
    mv a1, a0
    lw a0, -12(fp)
    
    add t1, a0, a1
    not t0, s1
    and t0, t0, s2
    xor t0, t0, s5
    sw t0, 0(t1)

    addi t5, t5, 1
    blt t5, t6, 1b



    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


///////////////////////////////////////////////////////////////////////////
/////////////////////////////////// IOTA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////


.global iota
.balign 4

iota:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64



    la t1, KeccakRoundConstants

    // PART A
    slli t2, a1, 3
    add t1, t1, t2 
    add s1, t1, 4 
    lw t2, 0(t1) 
    lw s2, 0(s1) 

    lw t1, 0(a0) 
    xor t1, t1, t2
    sw t1, 0(a0)

    lw t1, 4(a0) 
    xor t1, t1, s2
    sw t1, 4(a0)

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret


//////////////////////////////////////////////////////////////////////////
/////////////////////////// KeccakF1600_StatePermute_TI ///////////////////
//////////////////////////////////////////////////////////////////////////


.global KeccakF1600_StatePermute_TI
.balign 4




KeccakF1600_StatePermute_TI:

    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64


    add t4, zero, zero
    addi t5, zero, 24

1:
    sw t4, -12(fp)
    sw t5, -16(fp)
    
    jal ra, theta
    jal ra, rhoPi
    
    jal ra, chi_ptA
    jal ra, chi_ptB

    lw t4, -12(fp)
    mv a1, t4
    /////// iota ///////
    jal ra, iota
    // loop update
    lw t4, -12(fp)
    lw t5, -16(fp)
    addi t4, t4, 1
    blt t4, t5, 1b

    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret

