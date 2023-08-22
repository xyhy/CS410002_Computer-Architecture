fib:    addi sp, sp, -16        #make space on stack
        sd x1, 8(sp)            #save return addr.
        sd x10, 0(sp)           #save argv in x10
        beq x10, x0, EXIT       #n==0 return 0
        addi x5, x0, 1          #produce a 1 for check n==1 
        beq x10, x5, EXIT       #n==1 return 1
        addi x10, x10, -1       #produce n-1
        jal x1, fib             #fib(n-1)
        ld x5, 0(sp)            #load n
        sd x10, 0(sp)           #store fib(n-1)
        addi x10, x5, -2        #produce n-2
        jal x1, fib             #fib(n-2)
        mul x10, x10, 2         #2*fib(n-2)
        add x10, x5, x10        #ret=fib(n-1)+2*fib(n-2)
        ld x1, 8(sp)            #restore return addr
        addi sp, sp, 16         #return space on stack
EXIT:   jalr x0, 0(x1)          #return