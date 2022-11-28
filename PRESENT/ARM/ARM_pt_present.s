//////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// ARM PLAINTEXT PRESENT /////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

.syntax unified
.thumb

.data 

.align 4
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



///////////////////////////////////////////////////////////////////////
/////////////////////////// sbox //////////////////////////////////////
///////////////////////////////////////////////////////////////////////

.align 4
.global   sbox
.type   sbox, %function;
sbox:

    sub sp, sp, #(4 * 5)

    ldr r4, =sboxT
    str r0, [sp, #0]
  
    // BLOCK 1
    ldr r1, [r0, #0]

    // byte 0
    lsr r2, r1, #24

    and r3, r2, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r2, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    lsl r7, r5, #24

    // byte 1
    lsr r2, r1, #16

    and r3, r2, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r2, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    lsl r5, r5, #16
    eor r7, r7, r5

    // byte 2
    lsr r2, r1, #8

    and r3, r2, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r2, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    lsl r5, r5, #8
    eor r7, r7, r5

    // byte 3
    and r3, r1, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r1, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    eor r7, r7, r5

    str r7, [r0, #0]


    // BLOCK 2
    ldr r1, [r0, #4] 

    // byte 0
    lsr r2, r1, #24

    and r3, r2, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r2, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    lsl r7, r5, #24

    // byte 1
    lsr r2, r1, #16

    and r3, r2, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r2, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    lsl r5, r5, #16
    eor r7, r7, r5

    // byte 2
    lsr r2, r1, #8

    and r3, r2, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r2, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    lsl r5, r5, #8
    eor r7, r7, r5

    // byte 3
    and r3, r1, 0xF0
    lsr r3, r3, #4
    add r3, r4, r3
    ldrb r5, [r3, #0]
    lsl r5, r5, #4

    and r3, r1, 0x0F
    add r3, r4, r3
    ldrb r6, [r3, #0]

    eor r5, r5, r6
    eor r7, r7, r5

    str r7, [r0, #4]
    
    add sp, sp, #(4 * 5)
    bx lr


.align 4
.global   pLayer
.type   pLayer, %function;
pLayer:

    push {r4-r11,r14}
    sub sp, sp, #(4 * 8)

    //load part 1 with lower bits
    ldr r2, [r0, #0]
    
    //load part 2 with higher bits
    ldr r3, [r0, #4]

    mov r4, #0 // part 1 with lower bits
    mov r5, #0 // part 2 with higher bits


    //////////////////////////////////////////// PART 1

    // 0 -> 0
    and r4, r2, #1
    
    // 1 -> 16
    lsr r10, r2, #1 
    and r10, r10, #1
    lsl r10, r10, #16
    orr r4, r4, r10

    // 2 -> 32 % 32 = 0
    lsr r10, r2, #2 
    and r10, r10, #1
    orr r5, r5, r10

    // 3 -> 48
    lsr r10, r2, #3 
    and r10, r10, #1
    lsl r10, r10, #16
    orr r5, r5, r10

    // 4 -> 1
    lsr r10, r2, #4 
    and r10, r10, #1
    lsl r10, r10, #1
    orr r4, r4, r10

    // 5 -> 17
    lsr r10, r2, #5 
    and r10, r10, #1
    lsl r10, r10, #17
    orr r4, r4, r10

    // 6 -> 33 % 32 = 1
    lsr r10, r2, #6 
    and r10, r10, #1
    lsl r10, r10, #1
    orr r5, r5, r10    

    
                                        
    // 7 -> 49 % 32 = 17
    lsr r10, r2, #7 
    and r10, r10, #1
    lsl r10, r10, #17
    orr r5, r5, r10 

               
                                        
    // 8 -> 2                  
    lsr r10, r2, #8 
    and r10, r10, #1
    lsl r10, r10, #2
    orr r4, r4, r10

    // 9 -> 18
    lsr r10, r2, #9 
    and r10, r10, #1
    lsl r10, r10, #18
    orr r4, r4, r10

    // 10 -> 34 % 32 = 2
    lsr r10, r2, #10 
    and r10, r10, #1
    lsl r10, r10, #2
    orr r5, r5, r10 

    // 11 -> 50 % 32 = 18
    lsr r10, r2, #11 
    and r10, r10, #1
    lsl r10, r10, #18
    orr r5, r5, r10 

    // 12 -> 3
    lsr r10, r2, #12 
    and r10, r10, #1
    lsl r10, r10, #3
    orr r4, r4, r10

    // 13 -> 19
    lsr r10, r2, #13 
    and r10, r10, #1
    lsl r10, r10, #19
    orr r4, r4, r10

    // 14 -> 35 % 32 = 3
    lsr r10, r2, #14 
    and r10, r10, #1
    lsl r10, r10, #3
    orr r5, r5, r10 

    // 15 -> 5 % 32 = 19
    lsr r10, r2, #15 
    and r10, r10, #1
    lsl r10, r10, #19
    orr r5, r5, r10 

    // 16 -> 4                
    lsr r10, r2, #16 
    and r10, r10, #1
    lsl r10, r10, #4
    orr r4, r4, r10

    // 17-> 20
    lsr r10, r2, #17 
    and r10, r10, #1
    lsl r10, r10, #20
    orr r4, r4, r10


    // 18 -> 36 % 32 = 4
    lsr r10, r2, #18 
    and r10, r10, #1
    lsl r10, r10, #4
    orr r5, r5, r10 

    // 19 -> 52 % 32 = 20
    lsr r10, r2, #19 
    and r10, r10, #1
    lsl r10, r10, #20
    orr r5, r5, r10 


    // 20-> 5
    lsr r10, r2, #20 
    and r10, r10, #1
    lsl r10, r10, #5
    orr r4, r4, r10


    // 21-> 21
    lsr r10, r2, #21 
    and r10, r10, #1
    lsl r10, r10, #21
    orr r4, r4, r10

    // 22 -> 37 % 32 = 5
    lsr r10, r2, #22 
    and r10, r10, #1
    lsl r10, r10, #5
    orr r5, r5, r10 

    // 23 -> 53 % 32 = 21
    lsr r10, r2, #23 
    and r10, r10, #1
    lsl r10, r10, #21
    orr r5, r5, r10     

    // 24 -> 6
    lsr r10, r2, #24 
    and r10, r10, #1
    lsl r10, r10, #6
    orr r4, r4, r10

    // 25 -> 22
    lsr r10, r2, #25 
    and r10, r10, #1
    lsl r10, r10, #22
    orr r4, r4, r10

    // 26 -> 38 % 32 = 6
    lsr r10, r2, #26 
    and r10, r10, #1
    lsl r10, r10, #6
    orr r5, r5, r10     

    // 27 -> 54 % 32 =22
    lsr r10, r2, #27 
    and r10, r10, #1
    lsl r10, r10, #22
    orr r5, r5, r10 

    // 28 -> 7
    lsr r10, r2, #28 
    and r10, r10, #1
    lsl r10, r10, #7
    orr r4, r4, r10

    // 29 -> 23
    lsr r10, r2, #29 
    and r10, r10, #1
    lsl r10, r10, #23
    orr r4, r4, r10

    // 30 -> 39 % 32 = 7
    lsr r10, r2, #30 
    and r10, r10, #1
    lsl r10, r10, #7
    orr r5, r5, r10     

    // 31 -> 55 % 32 = 23
    lsr r10, r2, #31 
    and r10, r10, #1
    lsl r10, r10, #23
    orr r5, r5, r10     

    //////////////////////////////////////////// PART 2

    // 0 -> 8
    and r10, r3, #1
    lsl r10, r10, #8
    orr r4, r4, r10

    // 1 -> 24
                                                    
    lsr r10, r3, #1 
    and r10, r10, #1
    lsl r10, r10, #24
    orr r4, r4, r10


    // 2 -> 40 % 32 = 8
                                                    
    lsr r10, r3, #2 
    and r10, r10, #1
    lsl r10, r10, #8
    orr r5, r5, r10     

    // 3 -> 56 % 32 = 24
    lsr r10, r3, #3 
    and r10, r10, #1
    lsl r10, r10, #24
    orr r5, r5, r10    

    // 4 -> 9
    lsr r10, r3, #4 
    and r10, r10, #1
    lsl r10, r10, #9
    orr r4, r4, r10

    // 5 -> 25
    lsr r10, r3, #5 
    and r10, r10, #1
    lsl r10, r10, #25
    orr r4, r4, r10

    // 6 -> 41 % 32 = 9
    lsr r10, r3, #6 
    and r10, r10, #1
    lsl r10, r10, #9
    orr r5, r5, r10      

    // 7 -> 57 % 32 = 25
    lsr r10, r3, #7 
    and r10, r10, #1
    lsl r10, r10, #25
    orr r5, r5, r10      

    // 8 -> 10
    lsr r10, r3, #8 
    and r10, r10, #1
    lsl r10, r10, #10
    orr r4, r4, r10

    // 9 -> 26
    lsr r10, r3, #9 
    and r10, r10, #1
    lsl r10, r10, #26
    orr r4, r4, r10

    // 10 -> 42 % 32 = 10
    lsr r10, r3, #10 
    and r10, r10, #1
    lsl r10, r10, #10
    orr r5, r5, r10   

    // 11 -> 58 % 32 = 26
    lsr r10, r3, #11 
    and r10, r10, #1
    lsl r10, r10, #26
    orr r5, r5, r10   

    // 12 -> 11
    lsr r10, r3, #12 
    and r10, r10, #1
    lsl r10, r10, #11
    orr r4, r4, r10

    // 13 -> 27
    lsr r10, r3, #13 
    and r10, r10, #1
    lsl r10, r10, #27
    orr r4, r4, r10

    // 14 -> 43 % 32 = 11
    lsr r10, r3, #14 
    and r10, r10, #1
    lsl r10, r10, #11
    orr r5, r5, r10


    // 15 -> 59 % 32 = 27
    lsr r10, r3, #15 
    and r10, r10, #1
    lsl r10, r10, #27
    orr r5, r5, r10


    // 16 -> 12
    lsr r10, r3, #16 
    and r10, r10, #1
    lsl r10, r10, #12
    orr r4, r4, r10

    // 17 -> 28
    lsr r10, r3, #17 
    and r10, r10, #1
    lsl r10, r10, #28
    orr r4, r4, r10

    // 18 -> 44 % 32 = 12
    lsr r10, r3, #18 
    and r10, r10, #1
    lsl r10, r10, #12
    orr r5, r5, r10

    // 19 -> 60 % 32 = 28
    lsr r10, r3, #19 
    and r10, r10, #1
    lsl r10, r10, #28
    orr r5, r5, r10

    // 20 -> 13
    lsr r10, r3, #20 
    and r10, r10, #1
    lsl r10, r10, #13
    orr r4, r4, r10

    // 21 -> 29
    lsr r10, r3, #21 
    and r10, r10, #1
    lsl r10, r10, #29
    orr r4, r4, r10

    // 22 -> 45 % 32 = 13
    lsr r10, r3, #22 
    and r10, r10, #1
    lsl r10, r10, #13
    orr r5, r5, r10

    // 23 -> 61 % 32 = 29
    lsr r10, r3, #23 
    and r10, r10, #1
    lsl r10, r10, #29
    orr r5, r5, r10

    // 24 -> 14
    lsr r10, r3, #24 
    and r10, r10, #1
    lsl r10, r10, #14
    orr r4, r4, r10

    // 25 -> 30
    lsr r10, r3, #25 
    and r10, r10, #1
    lsl r10, r10, #30
    orr r4, r4, r10

    // 26 -> 46 % 32 = 14
    lsr r10, r3, #26 
    and r10, r10, #1
    lsl r10, r10, #14
    orr r5, r5, r10

    // 27 -> 62 % 32 = 30
    lsr r10, r3, #27 
    and r10, r10, #1
    lsl r10, r10, #30
    orr r5, r5, r10

    // 28 -> 15
    lsr r10, r3, #28 
    and r10, r10, #1
    lsl r10, r10, #15
    orr r4, r4, r10

    // 29 -> 31
    lsr r10, r3, #29 
    and r10, r10, #1
    lsl r10, r10, #31
    orr r4, r4, r10

    // 30 -> 47 % 32 = 15
    lsr r10, r3, #30 
    and r10, r10, #1
    lsl r10, r10, #15
    orr r5, r5, r10


    // 31 -> 63 % 32 = 31
    lsr r10, r3, #31 
    and r10, r10, #1
    lsl r10, r10, #31
    orr r5, r5, r10

    str r4, [r0, #0]
    str r5, [r0, #4]

    
    add sp, sp, #(4 * 8)
    pop {r4-r11,r14}
    bx lr

    /////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// PRESENT //////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////


.align 4
.global   present
.type   present, %function;
present:

// r0 = shares0
// r1 = subkeyHH
// r2 = subkeyHL


    push {r4-r11,r14}
    sub sp, sp, #(4 * 15)
    
    // store arrays pointers in stack
    str r0, [sp, #0] // Shares A
    str r1, [sp, #8] // H0
    str r2, [sp, #16] // L0
    
    mov r2, #0// COUNTER 31 loop
    str r2, [sp, #24]
    mov r11, #0 // offset for round Key array
    str r11, [sp, #28]


loop:

    /////////////////////////////////////////////////////////////////
    ///////////////////////// ADD ROUND KEY /////////////////////////
    /////////////////////////////////////////////////////////////////


    ////////////////// Update High ////////////////// 
    
  
    ldr r2, [r0, #4] 
    ldr r1, [sp, #8] // H0
    ldr r5, [sp, #28] //get current offset for round key array
    add r4, r5, r1
    ldr r3, [r4, #0] // Share A High KEY
    eor r2, r2, r3
    str r2, [r0, #4] 
    

    ////////////////// Update LOW ////////////////// 
    ldr r2, [r0, #0] 
    ldr r1, [sp, #16]
    add r4, r5, r1
    ldr r3, [r4, #0] 
    eor r2, r2, r3
    str r2, [r0, #0] 
    
     // increase and store in memory offset for round keys array
    add r5, r5, #4
    str r5, [sp, #28] 
 
    

    ////////////////////////////////////////////////////////
    ///////////////////////// SBOX /////////////////////////
    ////////////////////////////////////////////////////////
    
    
    bl sbox
    
    /////////////////////////////////////////////////////////////////////
    ///////////////////////// Permutation Layer /////////////////////////
    /////////////////////////////////////////////////////////////////////
    
    bl pLayer


    // LOOP ITERATION
    ldr r2, [sp, #24] // counter
    add r2, r2, #1
    str r2, [sp, #24] // counter
    cmp r2, #31
    blt loop


    /////////////////////////////////////////////////////////////////////////////
    ///////////////////////// LAST ADD ROUND KEY RK[31] /////////////////////////
    /////////////////////////////////////////////////////////////////////////////

  
    ldr r2, [r0, #4] 
    ldr r1, [sp, #8] // H0

    ldr r5, [sp, #28] //get current offset for round key array
    add r4, r5, r1
    ldr r3, [r4, #0] // Share A High KEY
    eor r2, r2, r3
    str r2, [r0, #4] 
    

    ////////////////// Update LOW ////////////////// 
    ldr r2, [r0, #0] 
    ldr r1, [sp, #16]
    add r4, r5, r1
    ldr r3, [r4, #0] 
    eor r2, r2, r3
    str r2, [r0, #0] 
    
     // increase and store in memory offset for round keys array
    add r5, r5, #4
    str r5, [sp, #28] 

    
    
    add sp, sp, #(4 * 15)
    pop {r4-r11,r14}
    bx lr

    