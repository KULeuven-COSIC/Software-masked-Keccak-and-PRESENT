//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// CORTEX-M4 masked shares aligned Keccak-f[800] /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

.syntax unified
.thumb


.data

.align 4
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

.align 4
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


.align 4
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

.align 4
index:
    add r0, r0, r1
    lsl r1,r1, #2
    add r0,r0,r1
    lsl r0,r0, #2

    bx lr

///////////////////////////////////////////////////////////////////////////
////////////////////////////////// THETA //////////////////////////////////
///////////////////////////////////////////////////////////////////////////

.align 4
.global   theta
.type   theta, %function;
theta:

    sub sp, sp, #(4 * 5)

    ldr r6, [r0, #0]
    ldr r7, [r0, #20]
    ldr r8, [r0, #40]
    ldr r9, [r0, #60]
    ldr r10, [r0, #80]
    eor r11, r6, r7
    eor r11, r11, r8
    eor r11, r11, r9
    eor r11, r11, r10
    str r11, [sp, #0]


    ldr r1, [r0, #4]
    ldr r2, [r0, #24]
    ldr r3, [r0, #44]
    ldr r4, [r0, #64]
    ldr r5, [r0, #84]
    eor r12, r1, r2
    eor r12, r12, r3
    eor r12, r12, r4
    eor r12, r12, r5
    str r12, [sp, #4]

    ldr r6, [r0, #8]
    ldr r7, [r0, #28]
    ldr r8, [r0, #48]
    ldr r9, [r0, #68]
    ldr r10, [r0, #88]
    eor r12, r6, r7
    eor r12, r12, r8
    eor r12, r12, r9
    eor r12, r12, r10

    str r12, [sp, #8]

    ror r12, #31
    eor r12, r11, r12
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12

    str r1, [r0, #4]
    str r2, [r0, #24]
    str r3, [r0, #44]
    str r4, [r0, #64]
    str r5, [r0, #84]

    ldr r1, [r0, #12]
    ldr r2, [r0, #32]
    ldr r3, [r0, #52]
    ldr r4, [r0, #72]
    ldr r5, [r0, #92]
    eor r11, r1, r2
    eor r11, r11, r3
    eor r11, r11, r4
    eor r11, r11, r5
    str r11, [sp, #12]

    ldr r12, [sp, #4]
    ror r11, #31 
    eor r12, r12, r11
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12
    str r6, [r0, #8]
    str r7, [r0, #28]
    str r8, [r0, #48]
    str r9, [r0, #68]
    str r10, [r0, #88]


    ldr r6, [r0, #16]
    ldr r7, [r0, #36]
    ldr r8, [r0, #56]
    ldr r9, [r0, #76]
    ldr r10, [r0, #96]
    eor r12, r6, r7
    eor r12, r12, r8
    eor r12, r12, r9
    eor r12, r12, r10
    str r12, [sp, #16]


    ldr r11, [sp, #8]
    ror r12, #31
    eor r12, r11, r12
    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12
    str r1, [r0, #12]
    str r2, [r0, #32]
    str r3, [r0, #52]
    str r4, [r0, #72]
    str r5, [r0, #92]

    ldr r1, [r0, #0]
    ldr r2, [r0, #20]
    ldr r3, [r0, #40]
    ldr r4, [r0, #60]
    ldr r5, [r0, #80]

    ldr r11, [sp, #16]
    ldr r12, [sp, #4]
    ror r12, #31
    eor r12, r12, r11

    eor r1, r1, r12
    eor r2, r2, r12
    eor r3, r3, r12
    eor r4, r4, r12
    eor r5, r5, r12
    str r1, [r0, #0]
    str r2, [r0, #20]
    str r3, [r0, #40]
    str r4, [r0, #60]
    str r5, [r0, #80]

    ldr r11, [sp, #12]
    ldr r12, [sp, #0]
    ror r12, #31
    eor r12, r12, r11
    eor r6, r6, r12
    eor r7, r7, r12
    eor r8, r8, r12
    eor r9, r9, r12
    eor r10, r10, r12
    str r6, [r0, #16]
    str r7, [r0, #36]
    str r8, [r0, #56]
    str r9, [r0, #76]
    str r10, [r0, #96]

    add sp, sp, #(4 * 5)
    bx lr

//////////////////////////////////////////////////////////////////////////
////////////////////////////////// RHO_PI ////////////////////////////////
//////////////////////////////////////////////////////////////////////////



.align 4
.global   rhoPi
.type   rhoPi, %function;
rhoPi:

    ldr r11, =KeccakP800_RotationConstants
    ldr r12, =KeccakP800_PiLane

    mov r10, #24
    mov r9, #0 
    ldr r1, [r0, #4]
loop:
    lsl r8, r9, #2
    ldr r3, [r12, r8]
    lsl r7, r3, #2
    ldr r2, [r0, r7] 

    ldr r4, [r11, r8]

    mov r5, #32
    sub r5, r5, r4
    ror r6, r1, r5 

    str r6, [r0, r7] 

    mov r1, r2 
    add r9, #1
    cmp r9, r10

    blt loop

    bx lr

//////////////////////////////////////////////////////////////////////////
////////////////////////////////// CHI ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////


.align 4
.global   chi
.type   chi, %function;
chi:

    push {r4-r11,r14}
    sub sp, sp, #(4 * 15)

    str r0, [sp, #32]
    str r1, [sp, #36]
    str r2, [sp, #40]
    str r3, [sp, #44]

    mov r14, #0
    str r14, [sp, #8]


loopChi:


    mov r0, #0 
    ldr r1, [sp, #8] 
    bl index
    str r0, [sp, #12] 

    mov r0, #1 
    ldr r1, [sp, #8] 
    bl index
    str r0, [sp, #16] 

    mov r0, #2 
    ldr r1, [sp, #8] 
    bl index
    str r0, [sp, #20] 

    mov r0, #3 
    ldr r1, [sp, #8] 
    bl index
    str r0, [sp, #24] 

    mov r0, #4 
    ldr r1, [sp, #8] 
    bl index
    str r0, [sp, #28] 

    ldr r0, [sp, #32] 
    ldr r1, [sp, #36] 

    ldr r14, [sp, #12] 
    ldr r2, [r0, r14] 
    ldr r8, [r1, r14] 

    ldr r14, [sp, #16] 
    ldr r3, [r0, r14] 
    ldr r9, [r1, r14] 

    ldr r14, [sp, #20] 
    ldr r4, [r0, r14] 
    ldr r10, [r1, r14] 

    ldr r14, [sp, #24] 
    ldr r5, [r0, r14] 
    ldr r11, [r1, r14] 

    ldr r14, [sp, #28] 
    ldr r6, [r0, r14] 
    ldr r12, [r1, r14] 

    ldr r14, [sp, #40] 
    ldr r1, [r14] 
    ldr r14, [sp, #44] 
    ldr r7, [r14] 

    and r14, r2, r6
    eor r1, r1, r14
    eor r1, r1, r2
    and r14, r6, r8
    eor r1, r1, r14

    and r14, r8, r12
    eor r7, r7, r14
    eor r7, r7, r8
    and r14, r2, r12
    eor r7, r7, r14


    and r14, r3, r4
    eor r2, r2, r14
    eor r2, r2, r4
    and r14, r3, r10
    eor r2, r2, r14
   
    ldr r0, [sp, #32]
    ldr r14, [sp, #12]
    str r2, [r0,r14]


    
    and r14, r9, r10 
    eor r8, r8, r14 
    eor r8, r8, r10 
    and r14, r4, r9 
    eor r8, r8, r14
    ldr r0, [sp, #36] 
    ldr r14, [sp, #12] 
    str r8, [r0,r14] 

    
    and r14, r5, r6 
    eor r4, r4, r14 
    eor r4, r4, r6 
    and r14, r5, r12 
    eor r4, r4, r14
    
    ldr r0, [sp, #32] 
    ldr r14, [sp, #20] 
    str r4, [r0,r14] 

    
    and r14, r11, r12 
    eor r10, r10, r14 
    eor r10, r10, r12 
    and r14, r6, r11 
    eor r10, r10, r14
    ldr r0, [sp, #36] 
    ldr r14, [sp, #20] 
    str r10, [r0,r14] 

    
    and r14, r2, r3 
    eor r6, r6, r14 
    eor r6, r6, r3 
    and r14, r2, r9 
    eor r6, r6, r14
    
    ldr r0, [sp, #32] 
    ldr r14, [sp, #28] 
    str r6, [r0,r14] 

    
    and r14, r8, r9 
    eor r12, r12, r14 
    eor r12, r12, r9 
    and r14, r3, r8 
    eor r12, r12, r14
    
    ldr r0, [sp, #36] 
    ldr r14, [sp, #28] 
    str r12, [r0,r14] 

    
    and r14, r4, r5 
    eor r3, r3, r14 
    eor r3, r3, r5 
    and r14, r4, r11 
    eor r3, r3, r14
    
    ldr r0, [sp, #32] 
    ldr r14, [sp, #16] 
    str r3, [r0,r14] 


    
    and r14, r10, r11 
    eor r9, r9, r14 
    eor r9, r9, r11 
    and r14, r5, r10 
    eor r9, r9, r14
    
    ldr r0, [sp, #36] 
    ldr r14, [sp, #16] 
    str r9, [r0,r14] 

    
    eor r5, r5, r1
   
    ldr r0, [sp, #32]
    ldr r14, [sp, #24]
    str r5, [r0,r14]

    
    eor r11, r11, r7
   
    ldr r0, [sp, #36]
    ldr r14, [sp, #24]
    str r11, [r0,r14]

    
    mov r1, r8 
    mov r7, r8 

    
    ldr r14, [sp, #40] 
    str r1, [r14]
    ldr r14, [sp, #44] 
    str r7, [r14]

    
    ldr r14, [sp, #8]
    add r14, r14, #1 
    str r14, [sp, #8] 
    cmp r14, #5
    blt loopChi

    add sp, sp, #(4 * 15)
    pop {r4-r11,r14}
    bx lr



//////////////////////////////////////////////////////////////////////////
/////////////////////////////////// IOTA//////////////////////////////////
//////////////////////////////////////////////////////////////////////////



.align 4
.global   iota
.type   iota, %function;
iota:

    ldr r12, =KeccakRoundConstants
    lsl r7, r1, #2
    ldr r7, [r12,r7] 
    ldr r2, [r0] 
    eor r2, r2, r7
    str r2, [r0]

    bx lr


///////////////////////////////////////////////////////////////////////
/////////////////////////// KeccakF800_StatePermute ///////////////////
///////////////////////////////////////////////////////////////////////


.align 4
.global   KeccakF800_StatePermute
.type   KeccakF800_StatePermute, %function;
KeccakF800_StatePermute:

    push {r4-r11,lr}
    sub sp, sp, #(4 * 6)
    str r2, [sp, #12]
    str r3, [sp, #16]

    mov r11, #0
    str r11, [sp, #0]
    str r1, [sp, #4]
    str r0, [sp, #8]


mainloop:


   /////// THETA share A ///////
    bl theta
    bl rhoPi

    /////// THETA share B ///////
    ldr r0, [sp, #4]
    bl theta
    bl rhoPi
    mov r1, r0
    ldr r0, [sp, #8]

    /////// CHI ///////
    ldr r2, [sp, #12]
    ldr r3, [sp, #16]
    bl chi
    ldr r0, [sp, #8]
    ldr r1, [sp, #0] 
    /////// iota ///////
    bl iota
    ldr r1, [sp, #4]

    ldr r11, [sp, #0] 
    add r11, r11, #1
    str r11, [sp, #0] 
    cmp r11, #22
    blt mainloop

    add sp, sp, #(4 * 6)
    pop {r4-r11,lr}
    bx lr
