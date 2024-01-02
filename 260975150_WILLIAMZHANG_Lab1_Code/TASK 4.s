.global _start

arr:   .word 68, -22, -31, 75, -10, -61, 39, 92, 94, -55 // test array
n:     .word 10

_start:
ldr r0 , =arr
ldr r1 , =n
ldr r1 , [r1]
mov r4, #0
b insertionsort

stop:
b stop

insertionsort:
add r4, r4, #1
mov r3, #0
cmp r4, r1
bge stop
add r3, r3, r4, LSL #2
b innerloop

innerloop:
ldr r2, [r3], #-4
ldr r5, [r3] 
cmp r2,r5
bge insertionsort
mov r6, r5
str r2, [r3], #4
str r6, [r3], #-4
cmp r3, r0
bgt innerloop
b insertionsort
.end
