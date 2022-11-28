.text

.macro rorA reg,dist
    srli  t6, \reg, \dist
    slli  \reg, \reg, 32-\dist
    xor   \reg, \reg, t6
    add t6, zero, zero 
.endm

.macro rolA reg,dist
    slli  t6, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, t6
    add t6, zero, zero 
.endm

.macro rorB reg,dist
    srli  s6, \reg, \dist
    slli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s6
    add s6, zero, zero 
.endm

.macro rolB reg,dist
    slli  s6, \reg, \dist
    srli  \reg, \reg, 32-\dist
    xor   \reg, \reg, s6
    add s6, zero, zero 
.endm

.balign 4
.global PTs
// a0 = a_0
// a1 = b_0
// a2 = c_0
// a3 = a_1
// a4 = b_1
// a5 = c_1



.balign 4
.global test_Sboxes
// a0 = state_shares0
// a1 = state_shares1
// a2 = out0
// a3 = out1

test_Sboxes:

//FUNCTION PROLOGUE
    addi sp, sp, -64
    sw ra, 60(sp)
    sw fp, 56(sp)
    addi fp, sp, 64

    // load share 0 into register
    lw t1, 0(a0) //a0
    lw t2, 4(a0) //b0
    lw t3, 8(a0) //c0
    lw t4, 12(a0) //d0


    // load share 1 into register
    lw s1, 0(a1) //a1
    lw s2, 4(a1) //b1
    lw s3, 8(a1) //c1
    lw s4, 12(a1) //d1


    ////////////////////////////////
    ////////////SboxesQ4////////////
    ////////////////////////////////
    ////////////// d0 + a0b0
      // b0c0
      and s10, t1, t2
      xor t4, t4, s10

     ////////////// d0 + a0b0 + a0b1
      // a0b1
      rorA t1, 2
      rorB s2, 1
      and s10, t1, s2
      rolA t1, 2
      rolB s2, 1
      rorA t4, 2
      xor t4, t4, s10
      rolA t4, 2

      ////////////// d1 + a1b1
      // b1c1
      and s10, s1, s2
      xor s4, s4, s10

      ////////////// d1 + a1b1 + a1b0
      // a1b0
      rorA t2, 2
      rorB s1, 1
      and s10, t2, s1
      rolA t2, 2
      rolB s1, 1
      rorB s4, 1
      xor s4, s4, s10
      rolB s4, 1


    ////////////////////////////////
    ////////////SboxesQ12////////////
    ////////////////////////////////

    /////////// PTs(b,a,c) ///////////

    // b0c0
    and s10, t1, t3
    xor t2, t2, s10

    ////////////// t2 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s3, 1
    and s10, t1, s3
    rolA t1, 2
    rolB s3, 1
    rorA t2, 2
    xor t2, t2, s10
    rolA t2, 2
    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s3
    xor s2, s2, s10
    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s1, 1
    and s10, t3, s1
    rolA t3, 2
    rolB s1, 1
    rorB s2, 1
    xor s2, s2, s10
    rolB s2, 1


    /////////// PTs(c,a,b) ///////////
    ////////////// t3 + b0c0
    // b0c0
    and s10, t1, t2
    xor t3, t3, s10

    ////////////// t3 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s2, 1
    and s10, t1, s2
    rolA t1, 2
    rolB s2, 1
    rorA t3, 2
    xor t3, t3, s10
    rolA t3, 2

    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s2
    xor s3, s3, s10

    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t2, 2
    rorB s1, 1
    and s10, t2, s1
    rolA t2, 2
    rolB s1, 1
    rorB s3, 1
    xor s3, s3, s10
    rolB s3, 1

    ////////////////////////////////
    ////////////SboxesQ293//////////
    ////////////////////////////////

    /////////// PTs(d,b,c) ///////////
    ////////////// t4 + b0c0
    // b0c0
    and s10, t2, t3
    xor t4, t4, s10

    ////////////// t4 + b0c0 + b0c1
    // b0c1
    rorA t2, 2
    rorB s3, 1
    and s10, t2, s3
    rolA t2, 2
    rolB s3, 1
    rorA t4, 2
    xor t4, t4, s10
    rolA t4, 2

    ////////////// t2 + b1c1
    // b1c1
    and s10, s2, s3
    xor s4, s4, s10

    ////////////// t2 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s2, 1
    and s10, t3, s2
    rolA t3, 2
    rolB s2, 1
    rorB s4, 1
    xor s4, s4, s10
    rolB s4, 1


    /////////// PTs(b,a,c) ///////////
    ////////////// t2 + b0c0
    // b0c0
    and s10, t1, t3
    xor t2, t2, s10

    ////////////// t2 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s3, 1
    and s10, t1, s3
    rolA t1, 2
    rolB s3, 1
    rorA t2, 2
    xor t2, t2, s10
    rolA t2, 2

    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s3
    xor s2, s2, s10

    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s1, 1
    and s10, t3, s1
    rolA t3, 2
    rolB s1, 1
    rorB s2, 1
    xor s2, s2, s10
    rolB s2, 1

    /////////// PTs(c,a,b) ///////////
    ////////////// t3 + b0c0
    // b0c0
    and s10, t1, t2
    xor t3, t3, s10

    ////////////// t3 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s2, 1
    and s10, t1, s2
    rolA t1, 2
    rolB s2, 1
    rorA t3, 2
    xor t3, t3, s10
    rolA t3, 2

    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s2
    xor s3, s3, s10

    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t2, 2
    rorB s1, 1
    and s10, t2, s1
    rolA t2, 2
    rolB s1, 1
    rorB s3, 1
    xor s3, s3, s10
    rolB s3, 1

    ////////////////////////////////
    ////////////SboxesQ294//////////
    ////////////////////////////////

    /////////// PTs(c,a,b) ///////////
    ////////////// t3 + b0c0
    // b0c0
    and s10, t1, t2
    xor t3, t3, s10

    ////////////// t3 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s2, 1
    and s10, t1, s2
    rolA t1, 2
    rolB s2, 1
    rorA t3, 2
    xor t3, t3, s10
    rolA t3, 2

    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s2
    xor s3, s3, s10

    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t2, 2
    rorB s1, 1
    and s10, t2, s1
    rolA t2, 2
    rolB s1, 1
    rorB s3, 1
    xor s3, s3, s10
    rolB s3, 1


    /////////// PTs(d,a,b) ///////////
    ////////////// t4 + b0c0
    // b0c0
    and s10, t1, t2
    xor t4, t4, s10

    ////////////// t4 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s2, 1
    and s10, t1, s2
    rolA t1, 2
    rolB s2, 1
    rorA t4, 2
    xor t4, t4, s10
    rolA t4, 2

    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s2
    xor s4, s4, s10

    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t2, 2
    rorB s1, 1
    and s10, t2, s1
    rolA t2, 2
    rolB s1, 1
    rorB s4, 1
    xor s4, s4, s10
    rolB s4, 1


    /////////// PTs(d,a,c) ///////////
    ////////////// t4 + b0c0
    // b0c0
    and s10, t1, t3
    xor t4, t4, s10

    ////////////// t4 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s3, 1
    and s10, t1, s3
    rolA t1, 2
    rolB s3, 1
    rorA t4, 2
    xor t4, t4, s10
    rolA t4, 2

    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s3
    xor s4, s4, s10

    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s1, 1
    and s10, t3, s1
    rolA t3, 2
    rolB s1, 1
    rorB s4, 1
    xor s4, s4, s10
    rolB s4, 1

    ////////////////////////////////
    ////////////SboxesQ299//////////
    ////////////////////////////////

    /////////// PTs(b,a,c) ///////////
    ////////////// t2 + b0c0
    // b0c0
    and s10, t1, t3
    xor t2, t2, s10

    ////////////// t2 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s3, 1
    and s10, t1, s3
    rolA t1, 2
    rolB s3, 1
    rorA t2, 2
    xor t2, t2, s10
    rolA t2, 2

    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s3
    xor s2, s2, s10

    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s1, 1
    and s10, t3, s1
    rolA t3, 2
    rolB s1, 1
    rorB s2, 1
    xor s2, s2, s10
    rolB s2, 1


    /////////// PTs(c,a,b) ///////////
    ////////////// t3 + b0c0
    // b0c0
    and s10, t1, t2
    xor t3, t3, s10
    ////////////// t3 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s2, 1
    and s10, t1, s2
    rolA t1, 2
    rolB s2, 1
    rorA t3, 2
    xor t3, t3, s10
    rolA t3, 2
    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s2
    xor s3, s3, s10
    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t2, 2
    rorB s1, 1
    and s10, t2, s1
    rolA t2, 2
    rolB s1, 1
    rorB s3, 1
    xor s3, s3, s10
    rolB s3, 1


   /////////// PTs(b,a,c) ///////////
    ////////////// t2 + b0c0
    // b0c0
    and s10, t1, t3
    xor t2, t2, s10
    ////////////// t2 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s3, 1
    and s10, t1, s3
    rolA t1, 2
    rolB s3, 1
    rorA t2, 2
    xor t2, t2, s10
    rolA t2, 2
    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s3
    xor s2, s2, s10
    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s1, 1
    and s10, t3, s1
    rolA t3, 2
    rolB s1, 1
    rorB s2, 1
    xor s2, s2, s10
    rolB s2, 1


    /////////// PTs(c,a,d) ///////////
    ////////////// t3 + b0c0
    // b0c0
    and s10, t1, t4
    xor t3, t3, s10
    ////////////// t3 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s4, 1
    and s10, t1, s4
    rolA t1, 2
    rolB s4, 1
    rorA t3, 2
    xor t3, t3, s10
    rolA t3, 2
    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s4
    xor s3, s3, s10
    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t4, 2
    rorB s1, 1
    and s10, t4, s1
    rolA t4, 2
    rolB s1, 1
    rorB s3, 1
    xor s3, s3, s10
    rolB s3, 1


   /////////// PTs(d,a,c) ///////////
    ////////////// t4 + b0c0
    // b0c0
    and s10, t1, t3
    xor t4, t4, s10
    ////////////// t4 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s3, 1
    and s10, t1, s3
    rolA t1, 2
    rolB s3, 1
    rorA t4, 2
    xor t4, t4, s10
    rolA t4, 2
    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s3
    xor s4, s4, s10
    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s1, 1
    and s10, t3, s1
    rolA t3, 2
    rolB s1, 1
    rorB s4, 1
    xor s4, s4, s10
    rolB s4, 1


    ////////////////////////////////
    ////////////SboxesQ300//////////
    ////////////////////////////////

   //XorFirst(b, a)
    xor t2, t2, t1
    xor s2, s2, s1

    //XorFirst(c, a)
    xor t3, t3, t1
    xor s3, s3, s1

    /////////// PTs(a,b,c) ///////////
    ////////////// t1 + b0c0
    // b0c0
    and s10, t2, t3
    xor t1, t1, s10
    ////////////// t1 + b0c0 + b0c1
    // b0c1
    rorA t2, 2
    rorB s3, 1
    and s10, t2, s3
    rolA t2, 2
    rolB s3, 1
    rorA t1, 2
    xor t1, t1, s10
    rolA t1, 2
    ////////////// t2 + b1c1
    // b1c1
    and s10, s2, s3
    xor s1, s1, s10
    ////////////// t2 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s2, 1
    and s10, t3, s2
    rolA t3, 2
    rolB s2, 1
    rorB s1, 1
    xor s1, s1, s10
    rolB s1, 1

    /////////// PTs(b,a,c) ///////////
    ////////////// t2 + b0c0
    // b0c0
    and s10, t1, t3
    xor t2, t2, s10
    ////////////// t2 + b0c0 + b0c1
    // b0c1
    rorA t1, 2
    rorB s3, 1
    and s10, t1, s3
    rolA t1, 2
    rolB s3, 1
    rorA t2, 2
    xor t2, t2, s10
    rolA t2, 2
    ////////////// t1 + b1c1
    // b1c1
    and s10, s1, s3
    xor s2, s2, s10
    ////////////// t1 + b1c1 + b1c0
    // b1c0
    rorA t3, 2
    rorB s1, 1
    and s10, t3, s1
    rolA t3, 2
    rolB s1, 1
    rorB s2, 1
    xor s2, s2, s10
    rolB s2, 1


    /////////// PXs(c,b,a) ///////////

    ////////////// t3 + b0c0 + c0
    // b0c0
    and s10, t2, t1
    xor t3, t3, s10
    xor t3, t3, t1
    ////////////// t3 + b0c1 + c1
    // b0c1
    rorA t2, 2
    rorB s1, 1
    and s10, t2, s1
    // b0c1 + c1
    xor s10, s10, s1
    rolA t2, 2
    rolB s1, 1
    // t3 + b0c1 + c1
    rorA t3, 2
    xor t3, t3, s10
    rolA t3, 2
    ////////////// t2 + b1c1
    // b1c1
    and s10, s2, s1
    xor s3, s3, s10
    ////////////// t2 + b1c0
    // b1c0
    rorA t1, 2
    rorB s2, 1
    and s10, t1, s2
    rolA t1, 2
    rolB s2, 1
    rorB s3, 1
    xor s3, s3, s10
    rolB s3, 1


    sw t1, 0(a2) //a0
    sw t2, 4(a2) //b0
    sw t3, 8(a2) //c0
    sw t4, 12(a2) //d0

    sw s1, 0(a3) //a1
    sw s2, 4(a3) //b1
    sw s3, 8(a3) //c1
    sw s4, 12(a3) //d1


    lw ra, 60(sp)
    lw fp, 56(sp)
    addi sp, sp, 64
    ret




