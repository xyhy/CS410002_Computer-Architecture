# This example demonstrates an implementation of LCS's algorithm for finding longest common subsequences.
# We provided two strings in global for simplfy.
# Reference link : https://www.geeksforgeeks.org/longest-common-subsequence-dp-4/
# The ouput of test pattern 1 should be =>  Found LCS length : 8 
# The ouput of test pattern 2 should be =>  Found LCS length : 13

.data
.align 4
# test pattern 1
# SequenceA: .string "ACGTTCGCGACA"
# SequenceB: .string "ATCGATGCGC"
# SASize: .word 12
# SBSize: .word 10
# test pattern 2
SequenceA: .string "ACGTTTGTAACGACA"
SequenceB: .string "ACGTCTGTAACGTCCACGCTC"
SASize: .word 15
SBSize: .word 21
str: .string "Found LCS length : "
newline: .string "\n"
.text
.global _start
# Start your coding below, don't change anything upper.

_start:
    la a1, SequenceA
    la a2, SequenceB
    lw a3, SASize
    lw a4, SBSize
    addi sp, sp, -4
    # jump to lcs
    jal lcs
    
    addi sp, sp, 4
    j end
    
lcs:
    # stack space
    sw ra, 0(sp)
    addi sp, sp, -1424
    addi s0, sp, 1424
    add s1, sp, zero
    sw zero, -4(s0) # int i=0
    j .L1 # go to loopi

.L1:
    lw a5, -4(s0)
    ble a5, a3, .L2 # go to loopj
    j .print

.L2:
    sw zero, -8(s0) # j=0
    j .L3

.L3:
    lw a5, -8(s0)
    ble a5, a4, .L4 # go into loopj
    j .updatei

.L4:
    lw a5, -4(s0)
    beq a5, zero, .L5 # i==0 -> go L5
    lw a5, -8(s0)
    beq a5, zero, .L5 # j==0 -> go L5

    # both i, j not equal 0
    lw a5, -4(s0)
    lw a6, -8(s0)
    addi a5, a5, -1 # a5 = i-1
    add a5, a1, a5 # SequenceA[i-1]
    lb a5, 0(a5)
    addi a6, a6, -1 # a6 = j-1
    add a6, a2, a6 # SequenceB[j-1]
    lb a6, 0(a6)
    bne a5, a6, .L6

    lw a5, -4(s0)
    lw a6, -8(s0)
    mv t0, a5 # t0=i
    mv t1, a6 # t1=j
    addi a5, a5, -1 # a5 = i-1
    addi a6, a6, -1 # a6 = j-1
    # L[i][j]
    addi t2, a4, 1
    mul t0, t0, t2 # i*(sizeB+1)
    add t0, t0, t1 # i*sizeB+j
    slli t0, t0, 2 # mul 4 to find address
    add t0, s1, t0 # L[i*sizeB+j]

    # L[i-1][j-1]
    addi t2, a4, 1
    mul a5, a5, t2 # (sizeB+1)
    add a5, a6, a5 # i*sizeB+j
    slli a5, a5, 2 # mul 4 to find address
    add a5, s1, a5 # L[i*sizeB+j]
    lw a5, 0(a5)

    # L[i][j] = L[i-1][j-1]+1
    addi a5, a5, 1
    sw a5, 0(t0)
    j .updatej

.L5:
    lw a6, -4(s0)
    lw a5, -8(s0)
    addi t0, a4, 1
    mul a6, a6, t0 # i*(sizeB+1)
    add a5, a5, a6 # i*sizeB+j
    slli a5, a5, 2 # mul 4 to find address
    add a5, s1, a5 # L[i*sizeB+j]
    sw zero, 0(a5) # L[i][j]=0
    j .updatej

.L6: 
    lw a5, -4(s0)
    lw a6, -8(s0)
    mv t0, a5 # t0=i
    mv t1, a6 # t1=j
    addi a5, a5, -1 # a5 = i-1
    addi a6, a6, -1 # a6 = j-1
    #L[i-1][j]
    addi t3, a4, 1
    mul t2, a5, t3
    add t2, t2, t1
    slli t2, t2, 2
    add t2, s1, t2
    #L[i][j-1]
    addi t4, a4, 1
    mul t3, t0, t4
    add t3, t3, a6
    slli t3, t3, 2
    add t3, s1, t3
    # compare t2, t3
    lw t2, 0(t2)
    lw t3, 0(t3)
    bgt t2, t3, .L7
    # L[i][j] = L[i][j-1]
    addi t2, a4, 1
    mul t0, t0, t2 # i*sizeB
    add t0, t0, t1 # i*sizeB+j
    slli t0, t0, 2 # mul 4 to find address
    add t0, s1, t0 # L[i*sizeB+j]
    sw t3, 0(t0)
    j .updatej

.L7: #L[i-1][j] > #L[i][j-1]
    lw a5, -4(s0)
    lw a6, -8(s0)
    mv t0, a5 # t0=i
    mv t1, a6 # t1=j
    addi a5, a5, -1 # a5 = i-1
    addi a6, a6, -1 # a6 = j-1
    #L[i-1][j]
    addi t2, a4, 1
    mul t2, a5, t2
    add t2, t2, t1
    slli t2, t2, 2
    add t2, s1, t2
    lw t2, 0(t2)
    # L[i][j] = L[i-1][j]
    addi t3, a4, 1
    mul t0, t0, t3 # i*sizeB
    add t0, t0, t1 # i*sizeB+j
    slli t0, t0, 2 # mul 4 to find address
    add t0, s1, t0 # L[i*sizeB+j]
    sw t2, 0(t0)
    j .updatej

.print:
    # out of loopi
    # print "Found LCS length : "
    la a0, str
    li a7, 4
    ecall

    # print L[A][B]

    addi a5, a4, 1
    mul a5, a3, a5
    add a5, a5, a4
    slli a5, a5, 2
    add a5, s1, a5
    lw a0, 0(a5)
    li a7, 1
    ecall

    # print "\n"
    la a0, newline
    li a7, 4
    ecall

    addi sp, sp, 1424
    lw ra, 0(sp)
    jr x1

.updatei:
    # back to loopi, i++
    lw a5, -4(s0)
    addi a5, a5, 1
    sw a5, -4(s0)
    j .L1

.updatej:
    # back to loopj, j++
    lw a5, -8(s0)
    addi a5, a5, 1 
    sw a5, -8(s0)
    j .L3

end:nop

/*
note

i: -4(s0)
j: -8(s0)
L[i][j]= L[i*(sizeB+1)+j]
L: s1
*/