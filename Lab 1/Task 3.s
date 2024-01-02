.global _start

arr:   .word 68, -22, -31, 75, -10, -61, 39, 92, 94, -55 // test array
n:     .word 10

_start:
ldr r0 , =arr
ldr r1 , =n
ldr r1 , [r1]
mov r3, #0
add r3, r1, r3
bl insertionsort
b stop

stop:
b stop

insertionsort:
push {r3-r8, lr}
mov r8, #0
cmp r3, #1
ble exit
sub r3, r3, #1
bl insertionsort
add r8, r8, r3, LSL #2
b innerloop

innerloop:
ldr r7, [r8], #-4
ldr r5, [r8] 
cmp r7,r5
bge exit
mov r6, r5
str r7, [r8], #4
str r6, [r8], #-4
cmp r8, r0
bgt innerloop
b exit

exit: 
mov r8, #0
pop {r3-r8, lr}
bx lr
.end
