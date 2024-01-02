.global _start

arr:   .word 68, -22, -31, 75, -10, -61, 39, 92, 94, -55 // test array
n:     .word 10

_start:
ldr r0 , =arr
ldr r1 , =n
bl insertionsort

stop:
b stop

insertionsort: // go through loop
push {r2-r6}
ldr r1 , [r1]
add r1, r3, r1, LSL #2
mov r2, #4
b sort

sort:
add r3, r0, r2
cmp r3, r1
ble innerloop

innerloop:
ldr r4, [r3], #-4
ldr r5, [r3]
cmp r4,r5
bge reset
mov r6, r5
str r4, [r3], #4
str r6, [r3], #-4
cmp r3, r0
bgt innerloop
b reset

reset:
add r2, #4
cmp r2, r1
blt sort
pop {r2-r6}
bx lr

.end
