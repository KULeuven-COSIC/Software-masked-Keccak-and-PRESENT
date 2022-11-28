////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// CORTEX M4 Plaintext Keccak-f[1600] //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

.syntax unified
.thumb

.data

.align 4
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


.align 4
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


.align 4
.globl KeccakRoundConstants 
KeccakRoundConstants:

.word 0x00000001 
.word 0x00000000 
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

.align 4
.global   iA
.type   iA, %function;
iA:
    mov r7, r1
    lsl r1,r1, #2
    add r1,r1,r7
    lsl r1,r1, #1 
    lsl r0,r0, #1 
    add r0,r0,r1 
    lsl r0,r0, #2
    mov r7, #0 
    bx lr


.align 4
.global   iB
.type   iB, %function;
iB:
    mov r7, r1
    lsl r1,r1, #2
    add r1,r1,r7
    lsl r1,r1, #1 
    lsl r0,r0, #1 
    add r0,r0,r1 
    add r0, r0, #1
    lsl r0,r0, #2
    mov r7, #0 
    bx lr


///////////////////////////////////////////////////////////////////////////
////////////////////////////////// THETA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////

.align 4
.global   theta
.type   theta, %function;
// r0 = state

theta:
    push {r4-r11,r14}
    sub sp, sp, #(4 * 16)

    // load sheet 1A
    ldr r6, [r0, #0] 
    ldr r7, [r0, #40] 
    ldr r8, [r0, #80] 
    ldr r9, [r0, #120] 
    ldr r10, [r0, #160] 
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10 
    str r11, [sp, #0]

    // load sheet 1B
    ldr r1, [r0, #4] 
    ldr r2, [r0, #44] 
    ldr r3, [r0, #84] 
    ldr r4, [r0, #124] 
    ldr r5, [r0, #164] 
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5 
    str r12, [sp, #4]

    // load sheet 3A
    ldr r6, [r0, #16] 
    ldr r7, [r0, #56] 
    ldr r8, [r0, #96] 
    ldr r9, [r0, #136] 
    ldr r10, [r0, #176] 
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10 
    str r11, [sp, #8]

    // load sheet 3B
    ldr r1, [r0, #20] 
    ldr r2, [r0, #60] 
    ldr r3, [r0, #100] 
    ldr r4, [r0, #140] 
    ldr r5, [r0, #180] 
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5 
    str r12, [sp, #12]
    
    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 2/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 2A
    ldr r6, [r0, #8] 
    ldr r7, [r0, #48] 
    ldr r8, [r0, #88] 
    ldr r9, [r0, #128] 
    ldr r10, [r0, #168] 
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10 
    str r11, [sp, #16]

    // load sheet 2B
    ldr r1, [r0, #12] 
    ldr r2, [r0, #52] 
    ldr r3, [r0, #92] 
    ldr r4, [r0, #132] 
    ldr r5, [r0, #172] 
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5 
    str r12, [sp, #20]

    // ADD SUM S1A
    ldr r11, [sp, #0]
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    // ADD SUM S1B
    ldr r12, [sp, #4]
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    
    ldr r11, [sp, #8] // 3A
    ldr r12, [sp, #12] // 3B
    ror r12, #31 // ROL 1
    
    

    // ADD ROL S3A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S3B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // Store updated Sheet 2
    // store sheet 2A
    str r6, [r0, #8] 
    str r7, [r0, #48] 
    str r8, [r0, #88] 
    str r9, [r0, #128] 
    str r10, [r0, #168] 

    // store sheet 2B
    str r1, [r0, #12] 
    str r2, [r0, #52] 
    str r3, [r0, #92] 
    str r4, [r0, #132] 
    str r5, [r0, #172] 

    ///---------------------------------------------------//

    // load sheet 4A
    ldr r6, [r0, #24] 
    ldr r7, [r0, #64] 
    ldr r8, [r0, #104] 
    ldr r9, [r0, #144] 
    ldr r10, [r0, #184] 
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10 
    str r11, [sp, #24]

    // load sheet 4B
    ldr r1, [r0, #28] 
    ldr r2, [r0, #68] 
    ldr r3, [r0, #108] 
    ldr r4, [r0, #148] 
    ldr r5, [r0, #188] 
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5 
    str r12, [sp, #28]

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 3/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 3A
    ldr r6, [r0, #16] 
    ldr r7, [r0, #56] 
    ldr r8, [r0, #96] 
    ldr r9, [r0, #136] 
    ldr r10, [r0, #176] 

    // load sheet 3B
    ldr r1, [r0, #20] 
    ldr r2, [r0, #60] 
    ldr r3, [r0, #100] 
    ldr r4, [r0, #140] 
    ldr r5, [r0, #180] 


    ldr r11, [sp, #16]
    // ADD SUM S2A
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    ldr r12, [sp, #20]
    // ADD SUM S2B
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    
    ldr r11, [sp, #24] // 4A
    ldr r12, [sp, #28] // 4B
    ror r12, #31 // ROL 1
    
    

    // ADD ROL S4A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S4B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // Store updated Sheet 3
    // store sheet 3A
    str r6, [r0, #16] 
    str r7, [r0, #56] 
    str r8, [r0, #96] 
    str r9, [r0, #136] 
    str r10, [r0, #176] 

    // store sheet 3B
    str r1, [r0, #20] 
    str r2, [r0, #60] 
    str r3, [r0, #100] 
    str r4, [r0, #140] 
    str r5, [r0, #180] 

///---------------------------------------------------//

    // load sheet 5A
    ldr r6, [r0, #32] 
    ldr r7, [r0, #72] 
    ldr r8, [r0, #112] 
    ldr r9, [r0, #152] 
    ldr r10, [r0, #192] 
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10 
    str r11, [sp, #32]

    // load sheet 5B
    ldr r1, [r0, #36] 
    ldr r2, [r0, #76] 
    ldr r3, [r0, #116] 
    ldr r4, [r0, #156] 
    ldr r5, [r0, #196] 
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5 
    str r12, [sp, #36]

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 4/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 4A
    ldr r6, [r0, #24] 
    ldr r7, [r0, #64] 
    ldr r8, [r0, #104] 
    ldr r9, [r0, #144] 
    ldr r10, [r0, #184] 

    // load sheet 4B
    ldr r1, [r0, #28] 
    ldr r2, [r0, #68] 
    ldr r3, [r0, #108] 
    ldr r4, [r0, #148] 
    ldr r5, [r0, #188] 

    ldr r11, [sp, #8]
    // ADD SUM S3A
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    ldr r12, [sp, #12]
    // ADD SUM S3B
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    
    ldr r11, [sp, #32] // 5A
    ldr r12, [sp, #36] // 5B
    ror r12, #31 // ROL 1
    
    

    // ADD ROL S5A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S5B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // store sheet 4A
    str r6, [r0, #24] 
    str r7, [r0, #64] 
    str r8, [r0, #104] 
    str r9, [r0, #144] 
    str r10, [r0, #184] 

    // store sheet 4B
    str r1, [r0, #28] 
    str r2, [r0, 68] 
    str r3, [r0, #108] 
    str r4, [r0, #148] 
    str r5, [r0, #188] 

    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 5/////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // load sheet 5A
    ldr r6, [r0, #32] 
    ldr r7, [r0, #72] 
    ldr r8, [r0, #112] 
    ldr r9, [r0, #152] 
    ldr r10, [r0, #192] 

    // load sheet 5B
    ldr r1, [r0, #36] 
    ldr r2, [r0, #76] 
    ldr r3, [r0, #116] 
    ldr r4, [r0, #156] 
    ldr r5, [r0, #196] 

    // ADD SUM S4A
    ldr r11, [sp, #24]
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    // ADD SUM S4B
    ldr r12, [sp, #28]
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    
    ldr r11, [sp, #0] // 1A
    ldr r12, [sp, #4] // 1B
    ror r12, #31 // ROL 1
    
    

    // ADD ROL S1A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S1B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11

    // store sheet 5A
    str r6, [r0, #32] 
    str r7, [r0, #72] 
    str r8, [r0, #112] 
    str r9, [r0, #152] 
    str r10, [r0, #192] 

    // store sheet 5B
    str r1, [r0, #36] 
    str r2, [r0, #76] 
    str r3, [r0, #116] 
    str r4, [r0, #156] 
    str r5, [r0, #196] 


    ///////////////////////////////////////////////////////////////////////////
    /////////////////////////Compute θ step on sheet 1/////////////////////////
    ///////////////////////////////////////////////////////////////////////////

    // load sheet 1A
    ldr r6, [r0, #0] 
    ldr r7, [r0, #40] 
    ldr r8, [r0, #80] 
    ldr r9, [r0, #120] 
    ldr r10, [r0, #160] 
    
    // load sheet 1B
    ldr r1, [r0, #4] 
    ldr r2, [r0, #44] 
    ldr r3, [r0, #84] 
    ldr r4, [r0, #124] 
    ldr r5, [r0, #164] 
    
    // ADD SUM S5A
    ldr r11, [sp, #32]
    eor r6, r6, r11
    eor r7, r7, r11
    eor r8, r8, r11
    eor r9, r9, r11
    eor r10, r10, r11

    // ADD SUM S5B
    ldr r12, [sp, #36]
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    
    ldr r11, [sp, #16] // 2A
    ldr r12, [sp, #20] // 2B
    ror r12, #31 // ROL 1
    
    

    // ADD ROL S2A
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12

    // ADD ROL S2B
    eor r1, r1, r11
    eor r2, r2, r11
    eor r3, r3, r11
    eor r4, r4, r11
    eor r5, r5, r11
    
    // store sheet 5A
    str r6, [r0, #0] 
    str r7, [r0, #40] 
    str r8, [r0, #80] 
    str r9, [r0, #120] 
    str r10, [r0, #160] 
    
    // store sheet 5B
    str r1, [r0, #4] 
    str r2, [r0, #44] 
    str r3, [r0, #84] 
    str r4, [r0, #124] 
    str r5, [r0, #164] 


    add sp, sp, #(4 * 16)
    pop {r4-r11,r14}
    bx lr


//////////////////////////////////////////////////////////////////////////
////////////////////////////////// RHO_PI ////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.align 4
.global   rhoPi
.type   rhoPi, %function;
rhoPi:
    push {r4-r11,r14}
    sub sp, sp, #(4 * 5)

    ldr r14, =KeccakP1600_PiLane


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  0 : odd and tau =  0.0




    mov r5, #0 //r5 = x
    mov r8, #1 
    lsl r9, r8, #3
    add r3, r9, r0
    ldr r1, [r3, #0] 
    ldr r6, [r3, #4] 


    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] //// KeccakP1600_PiLane[x] value
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] // r2 = BCA[x] = ((uint32_t*)state)[KeccakP1600_PiLane[x]]
    ldr r7, [r10, #4] // r7 = BCB[x] = ((uint32_t*)state)[KeccakP1600_PiLane[x]]
    


    // *****ODD ***** ROL64(tempA-tempB,r11) (left rotation)
    ror r6, #31


    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1
    

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  1 : odd and tau =  1.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    


    // *****ODD ***** ROL64(tempA-tempB,r11) (left rotation)
    ror r6, #30
    ror r1, #31 

    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1
    
//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  2 : even and tau =  3.0


    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r1, #29
    ror r6, #29

    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  3 : even and tau =  5.0


    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r1, #27
    ror r6, #27

    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  4 : odd and tau =  7.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r6, #24
    ror r1, #25

    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  5 : odd and tau =  10.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
   
    ror r6, #21
    ror r1, #22


    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  6 : even and tau =  14.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r1, #18
    ror r6, #18

    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  7 : even and tau =  18.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r1, #14
    ror r6, #14


    
    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  8 : odd and tau =  22.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r6, #9
    ror r1, #10

    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  9 : odd and tau =  27.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r6, #4
    ror r1, #5

    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  10 : even and tau =  1.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r1, #31
    ror r6, #31

    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  11 : even and tau =  7.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r1, #25
    ror r6, #25


    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  12 : odd and tau =  13.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r6, #18
    ror r1, #19



    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  13 : odd and tau =  20.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r6, 11
    ror r1, 12

    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  14 : even and tau =  28.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r1, #4
    ror r6, #4


    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  15 : even and tau =  4.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r1, #28
    ror r6, #28

    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  16 : odd and tau =  12.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r6, #19
    ror r1, #20


    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  17 : odd and tau =  21.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r6, #10
    ror r1, #11


    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  18 : even and tau =  31.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r1, #1
    ror r6, #1

    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1


//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  19 : even and tau =  9.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    

    ror r1, #23
    ror r6, #23

    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  20 : odd and tau =  19.0

    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r6, #12
    ror r1, #13


    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  21 : odd and tau =  30.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r6, #1
    ror r1, #2


    str r6, [r10, #0] 
    str r1, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  22 : even and tau =  10.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r1, #22
    ror r6, #22


    str r1, [r10, #0] 
    str r6, [r10, #4] 

    mov r1, r2 
    mov r6, r7 
    add r5, r5, #1

//////////////////////////////////////////////////////////////////////////////////////////////// ROUND  23 : even and tau =  22.0
    lsl r4, r5, #2
    add r3, r4, r14 
    ldr r3, [r3, #0] 
    lsl r11, r3, #3
    add r10, r0, r11 
    ldr r2, [r10, #0] 
    ldr r7, [r10, #4] 
    
    ror r1, #10
    ror r6, #10

    str r1, [r10, #0] 
    str r6, [r10, #4] 


    add sp, sp, #(4 * 5)
    pop {r4-r11,r14}
    bx lr



//////////////////////////////////////////////////////////////////////////
////////////////////////////////// chi_ptA plaintext//////////////////////////
//////////////////////////////////////////////////////////////////////////


.align 4
.global   chi_ptA
.type   chi_ptA, %function;
chi_ptA:
    
    push {r4-r11,r14}
    sub sp, sp, #(4 * 6)


    
    mov r12, r0 
    mov r11, #0 



loopChi:

    
    mov r0, #0 
    mov r1, r11 
    bl iA
    str r0, [sp, #4]
    ldr r1, [r12, r0]


    
    mov r0, #1 
    mov r1, r11 
    bl iA
    str r0, [sp, #8]
    ldr r2, [r12, r0]


    
    mov r0, #2 
    mov r1, r11 
    bl iA
    str r0, [sp, #12]
    ldr r3, [r12, r0]


    
    mov r0, #3 
    mov r1, r11 
    bl iA
    str r0, [sp, #16]
    ldr r4, [r12, r0]


    
    mov r0, #4 
    mov r1, r11 
    bl iA
    str r0, [sp, #20]
    ldr r5, [r12, r0]

    ldr r8, [sp,#4]
    ldr r1, [r12, r8]


// Compute χ on the plane //
////////////////// x = 0
    mvn r8, r2
    and r8, r8, r3
    eor r8, r8, r1
    ldr r9, [sp, #4] 
    str r8, [r12, r9]

////////////////// x = 1
    mvn r8, r3
    and r8, r8, r4
    eor r8, r8, r2
    ldr r9, [sp, #8] 
    str r8, [r12, r9]

////////////////// x = 2
    mvn r8, r4
    and r8, r8, r5
    eor r8, r8, r3
    ldr r9, [sp, #12] 
    str r8, [r12, r9]

////////////////// x = 3
    mvn r8, r5
    and r8, r8, r1
    eor r8, r8, r4
    ldr r9, [sp, #16] 
    str r8, [r12, r9]


////////////////// x = 4
    mvn r8, r1
    and r8, r8, r2
    eor r8, r8, r5
    ldr r9, [sp, #20] 
    str r8, [r12, r9]

    add r11, #1
    cmp r11, #5

    blt loopChi
    mov r0, r12

    

    
    add sp, sp, #(4 * 6) 
    pop {r4-r11,r14}
    bx lr



//////////////////////////////////////////////////////////////////////////
////////////////////////////////// chi_ptB plaintext//////////////////////////
//////////////////////////////////////////////////////////////////////////


.align 4
.global   chi_ptB
.type   chi_ptB, %function;
chi_ptB:
    
    push {r4-r11,r14}
    sub sp, sp, #(4 * 6)


    
    mov r12, r0 
    mov r11, #0 



loopChiB:

    
    mov r0, #0 
    mov r1, r11 
    bl iB
    str r0, [sp, #4]
    ldr r1, [r12, r0]


    
    mov r0, #1 
    mov r1, r11 
    bl iB
    str r0, [sp, #8]
    ldr r2, [r12, r0]


    
    mov r0, #2 
    mov r1, r11 
    bl iB
    str r0, [sp, #12]
    ldr r3, [r12, r0]


    
    mov r0, #3 
    mov r1, r11 
    bl iB
    str r0, [sp, #16]
    ldr r4, [r12, r0]


    
    mov r0, #4 
    mov r1, r11 
    bl iB
    str r0, [sp, #20]
    ldr r5, [r12, r0]

    ldr r8, [sp,#4]
    ldr r1, [r12, r8]


// Compute χ on the plane //
////////////////// x = 0
    mvn r8, r2
    and r8, r8, r3
    eor r8, r8, r1
    ldr r9, [sp, #4] 
    str r8, [r12, r9]

////////////////// x = 1
    mvn r8, r3
    and r8, r8, r4
    eor r8, r8, r2
    ldr r9, [sp, #8] 
    str r8, [r12, r9]

////////////////// x = 2
    mvn r8, r4
    and r8, r8, r5
    eor r8, r8, r3
    ldr r9, [sp, #12] 
    str r8, [r12, r9]

////////////////// x = 3
    mvn r8, r5
    and r8, r8, r1
    eor r8, r8, r4
    ldr r9, [sp, #16] 
    str r8, [r12, r9]


////////////////// x = 4
    mvn r8, r1
    and r8, r8, r2
    eor r8, r8, r5
    ldr r9, [sp, #20] 
    str r8, [r12, r9]

    add r11, #1
    cmp r11, #5

    blt loopChiB
    mov r0, r12

    

    
    add sp, sp, #(4 * 6) 
    pop {r4-r11,r14}
    bx lr



///////////////////////////////////////////////////////////////////////////
/////////////////////////////////// IOTA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////

.align 4
.global iota
.type   iota, %function;
iota:
// r0 = void * state0
// r1 = nround


    ldr r12, =KeccakRoundConstants

    // PART A
    lsl r2, r1, #3
    add r12, r12, r2 
    add r8, r12, #4 
    ldr r2, [r12, #0] 
    ldr r8, [r8, #0] 

    ldr r12, [r0, #0] 
    eor r12, r12, r2
    str r12, [r0, #0] 

    ldr r12, [r0, #4] 
    eor r12, r12, r8
    str r12, [r0, #4] 

    bx lr


///////////////////////////////////////////////////////////////////////
/////////////////////////// KeccakF1600_StatePermute_TI ///////////////
///////////////////////////////////////////////////////////////////////


.align 4
.global   KeccakF1600_StatePermute_TI
.type   KeccakF1600_StatePermute_TI, %function;
KeccakF1600_StatePermute_TI:

// r0 = void * state0


    push {r4-r11,lr}
    sub sp, sp, #(4 * 6)

// Round 0-22
    mov r11, #0
    str r11, [sp, #0]
    str r0, [sp, #8]

mainloop:

    bl theta
    bl rhoPi    
    //ldr r0, [sp, #8]

    bl chi_ptA
    bl chi_ptB
    ldr r0, [sp, #8]
    ldr r1, [sp, #0]
    /////// iota ///////
    bl iota
    
    ldr r11, [sp, #0]
    add r11, r11, #1
    str r11, [sp, #0]
    cmp r11, #24
    blt mainloop

    add sp, sp, #(4 * 6)
    pop {r4-r11,lr}
    bx lr

