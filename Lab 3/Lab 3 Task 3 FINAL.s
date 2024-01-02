keyboarddata: .space 4
ampersandvalue: .space 4
.equ LOAD_VALUE, 0xFFFEC600
.equ CONTROL_REGISTER, 0xFFFEC608
.equ INTERRUPT_STATUS_REGISTER, 0xFFFEC60C
playedmaze: .space 432

input_mazes:// First Obstacle Course
            .word 2,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,0,0,0,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,1,1
            .word 0,1,0,1,1,1,0,0,0,1,1,1
            .word 0,0,0,1,1,1,0,0,0,1,1,1
            .word 1,1,1,1,1,1,0,0,1,0,0,0
            .word 1,1,1,1,1,1,0,1,0,0,0,0
            .word 1,1,1,1,1,1,0,0,0,0,0,3
            // Second Obstacle Course
            .word 2,1,0,1,1,1,0,0,0,0,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,0,0,0,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,0,0,1,1,1,0,0,0,1,0,1
            .word 1,1,1,1,1,1,0,0,1,0,0,0
            .word 1,1,1,1,1,1,0,1,0,0,0,0
            .word 1,1,1,1,1,1,1,0,0,0,0,3
            // Third Obstacle Course
            .word 2,0,0,0,0,1,0,0,0,1,0,1
            .word 0,1,1,1,0,1,1,1,0,1,0,1
            .word 0,1,0,0,0,0,0,0,0,0,0,1
            .word 0,1,1,1,1,1,0,1,1,1,0,1
            .word 0,1,0,0,0,0,0,0,0,1,0,1
            .word 1,1,0,1,1,1,1,1,1,1,1,1
            .word 0,1,0,0,0,0,0,0,0,0,0,1
            .word 0,1,1,1,0,1,1,1,1,1,0,1
            .word 0,0,0,0,0,0,0,1,0,0,0,3
            // Fourth Obstacle Course
            .word 2,1,0,0,0,0,0,0,0,0,0,1
            .word 0,1,0,1,1,1,0,1,1,1,0,1
            .word 0,1,0,0,0,1,0,1,0,1,0,1
            .word 0,1,0,1,0,1,1,1,0,1,0,1
            .word 0,0,0,1,0,0,0,0,0,1,0,1
            .word 0,1,0,1,1,1,1,1,1,1,0,1
            .word 0,1,0,1,0,0,0,1,0,0,0,1
            .word 0,1,0,1,1,1,0,1,0,1,1,1
            .word 0,1,0,1,0,0,0,0,0,0,0,3
            // Fifth Obstacle Course
            .word 2,0,0,0,0,1,0,1,0,1,0,1
            .word 1,1,0,1,1,1,0,1,0,1,0,1
            .word 0,0,0,0,0,0,0,0,0,0,0,1
            .word 0,1,1,1,0,1,1,1,1,1,0,1
            .word 0,0,0,1,0,1,0,1,0,0,0,1
            .word 1,1,0,1,1,1,0,1,1,1,0,1
            .word 0,0,0,1,0,1,0,0,0,0,0,1
            .word 0,1,0,1,0,1,0,1,0,1,1,1
            .word 0,1,0,0,0,1,0,1,0,0,0,3
            // Sixth Obstacle Course
            .word 2,0,0,0,0,0,0,1,0,0,0,1
            .word 1,1,0,1,0,1,0,1,0,1,0,1
            .word 0,0,0,1,0,1,0,0,0,1,0,1
            .word 1,1,1,1,0,1,1,1,1,1,1,1
            .word 0,0,0,1,0,0,0,1,0,0,0,1
            .word 0,1,1,1,0,1,1,1,0,1,0,1
            .word 0,1,0,0,0,0,0,0,0,1,0,1
            .word 0,1,0,1,1,1,1,1,1,1,0,1
            .word 0,0,0,0,0,0,0,0,0,1,0,3
            // Seventh Obstacle Course
            .word 2,0,0,0,0,0,0,0,1,0,1,0
            .word 1,1,1,0,1,1,1,1,1,0,1,0
            .word 1,0,0,0,0,0,1,0,0,0,0,0
            .word 1,1,1,1,1,0,1,1,1,0,1,1
            .word 1,0,0,0,1,0,0,0,0,0,0,0
            .word 1,0,1,0,1,0,1,0,1,0,1,0
            .word 1,0,1,0,0,0,1,0,1,0,1,0
            .word 1,1,1,1,1,1,1,1,1,0,1,0
            .word 1,0,0,0,0,0,0,0,0,0,1,3
            // Eighth Obstacle Course
            .word 2,0,0,0,0,0,0,0,0,0,0,0
            .word 1,0,1,1,1,1,1,0,1,1,1,0
            .word 1,0,0,0,1,0,0,0,1,0,0,0
            .word 1,1,1,1,1,0,1,1,1,1,1,1
            .word 1,0,0,0,1,0,1,0,0,0,0,0
            .word 1,0,1,1,1,0,1,1,1,0,1,0
            .word 1,0,0,0,0,0,0,0,1,0,1,0
            .word 1,1,1,0,1,0,1,1,1,1,1,0
            .word 1,0,0,0,1,0,0,0,0,0,0,3
            // Nineth Obstacle Course
            .word 2,0,0,0,0,0,1,0,1,0,1,0
            .word 1,0,1,1,1,1,1,0,1,0,1,0
            .word 1,0,0,0,1,0,0,0,0,0,0,0
            .word 1,0,1,0,1,1,1,0,1,1,1,1
            .word 1,0,1,0,1,0,1,0,0,0,1,0
            .word 1,0,1,1,1,0,1,0,1,1,1,0
            .word 1,0,0,0,1,0,0,0,0,0,1,0
            .word 1,0,1,1,1,0,1,1,1,0,1,0
            .word 1,0,0,0,0,0,1,0,0,0,0,3




.global _start
_start:
	bl read_PS2_data_ASM
	mov r1, #0
	mov r2, #0
	mov r3, #0
	mov r4, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	mov r8, #0
	mov r9, #0
	mov r10, #0
	mov r11, #0
	mov r12, #0
	ldr r9, =ampersandvalue
	ldr r4, =playedmaze
	str r4, [r9]
	bl VGA_clear_pixelbuff_ASM
	bl VGA_clear_charbuff_ASM
	bl VGA_fill_ASM
	bl draw_grid_ASM
	bl wait
	push {r0-r6}
	ldr r0, =keyboarddata
	ldr r0, [r0]
	ldr r3, =input_mazes
	mov r6, #0x1b0
	mul r0, r0, r6
	add r3, r3, r0
	mov r6, #0
	bl copy
	bl fill_grid_ASM
	pop {r0-r6}
	bl wait
	bl play
	
copy:
push {lr}
ldr r6, [r3], #4
str r6, [r4], #4
pop {lr}
cmp r4, #440
ldreq r4, =playedmaze
moveq r6, #0
bxeq lr
b copy

play:
	bl wait
	bl move_ASM
	bl wait
	b play


wait:
	push {lr}
	bl read_PS2_data_ASM
	pop {lr}
	cmp r0, #1
	bxeq lr
	b wait
	
	
	
VGA_draw_point_ASM:
		push	{r4}
		mov 	r4, #0xC8000000
		add 	r4, r4, r0, LSL #1
		add 	r4, r4, r1, LSL #10
		strh	r2, [r4]
		pop 	{r4}
		bx lr
VGA_clear_pixelbuff_ASM:
		push {r0-r4,lr}
		mov r0, #0
		mov r1, #0
		mov r2, #0xff
		add r2, r2, r2, LSL #8
		bl loop
		pop {r0-r4,lr}
		bx lr
loop:
push {r4,lr}
bl VGA_draw_point_ASM
add r0, r0, #1
cmp r0, #320
moveq r0, #0
addeq r1, #1
pop {r4,lr}
cmp r1, #240
bxeq lr
b loop

		
VGA_write_char_ASM:
		push {r4}
		mov r4, #0xC9000000
		cmp r0, #79
		popgt {r4}
		bxgt lr
		cmp r1, #59
		popgt {r4}
		bxgt lr
		add r4, r4, r0
		add r4, r4, r1, LSL #7
		strb r2, [r4]
		pop {r4}
		bx lr
		
VGA_clear_charbuff_ASM:
		push {r0-r4,lr}
		mov r0, #0
		mov r1, #0
		mov r2, #0
		bl loop2
		pop {r0-r4,lr}
		bx lr
loop2:
push {lr}
bl VGA_write_char_ASM
add r0, r0, #1
cmp r0, #79
moveq r0, #0
addeq r1, #1
pop {lr}
cmp r1, #60
bxeq lr
b loop2

@ TODO: insert PS/2 driver here.
read_PS2_data_ASM:
		push {r4-r6, lr}
		mov r4, #0x00100
		mov r5, #0xf2
		add r4, r4, r5, LSL #20
		mov r5, #0xf
		add r4, r4, r5, LSL #28
		ldr r4, [r4]
		mov r5, #0
		add r5, r5, r4, LSR #15
		TST r5, #0x1
		moveq r0, #0
		blne storedata
		pop {r4-r6, lr}
		bx lr
		
storedata:
push {r4,lr}
and r4, r4, #0b11111111
cmp r4, #0xE0
moveq r4, #0
bleq read_PS2_data_ASM
cmp r4, #0xF0
moveq r4, #0
bleq read_PS2_data_ASM
mov r0, #0
cmp r4, #0x75 // up
moveq r4, #11
streqb r4, [r0]
cmp r4, #0x6B // left
moveq r4, #12
streqb r4, [r0]
cmp r4, #0x72 // down
moveq r4, #13
streqb r4, [r0]
cmp r4, #0x74 // right
moveq r4, #14
streqb r4, [r0]
cmp r4, #0x16
moveq r4, #0
streqb r4, [r0]
cmp r4, #0x1E
moveq r4, #1
streqb r4, [r0]
cmp r4, #0x26
moveq r4, #2
streqb r4, [r0]
cmp r4, #0x25
moveq r4, #3
streqb r4, [r0]
cmp r4, #0x2E
moveq r4, #4
streqb r4, [r0]
cmp r4, #0x36
moveq r4, #5
streqb r4, [r0]
cmp r4, #0x3D
moveq r4, #6
streqb r4, [r0]
cmp r4, #0x3E
moveq r4, #7
streqb r4, [r0]
cmp r4, #0x46
moveq r4, #8
streqb r4, [r0]
bl read_PS2_data_ASM
mov r0, #1
pop {r4,lr}
bx lr

VGA_fill_ASM:
		push {r0-r4,lr}
		mov r0, #0
		mov r1, #0
		mov r2, #0xFF
		bl loop3
		pop {r0-r4,lr}
		bx lr
		
loop3:
push {r4,lr}
bl VGA_draw_point_ASM
add r0, r0, #1
cmp r0, #196
moveq r0, #0
addeq r1, #1
pop {r4,lr}
cmp r1, #200
bxeq lr
b loop3

draw_grid_ASM:
		push {r0-r5,lr}
		mov r0, #0
		mov r1, #0
		mov r2, #0
		mov r3, #196
		mov r4, #4
		push {r0-r1}
		bl columnloop
		pop {r0-r1}
		bl rowloop
		pop {r0-r5,lr}
		bx lr
		
columnloop:
push {lr}
bl VGA_draw_point_ASM
add r1, r1, #1
cmp r1, #148
moveq r1, #0
addeq r0, #1
cmp r0, r4
addeq r0, r0, #12
addeq r4, r4, #16
cmp r4, #196
moveq r4, #4
pop {lr}
cmp r0, #196
bxeq lr
b columnloop

rowloop:
push {lr}
bl VGA_draw_point_ASM
add r0, r0, #1
cmp r0, #196
moveq r0, #0
addeq r1, #1
cmp r1, r4
addeq r1, r1, #12
addeq r4, r4, #16
cmp r4, #148
moveq r4, #4
pop {lr}
cmp r1, #148
bxeq lr
b rowloop

draw_ampersand_ASM:
		push {r2,lr}
		mov r2, #38
		//mov r0, #2
		//mov r1, #2
		bl VGA_write_char_ASM
		pop {r2,lr}
		bx lr

draw_exit_ASM:
		push {r2,lr}
		mov r2, #88
		//mov r0, #46
		//mov r1, #34
		bl VGA_write_char_ASM
		pop {r2,lr}
		bx lr
		

draw_obstacles_ASM:
		push {r2,lr}
		mov r2, #39
		bl VGA_write_char_ASM
		pop {r2,lr}
		bx lr
		
fill_grid_ASM:
		push {r0-r4,lr}
		ldr r3, =playedmaze
		mov r0, #2
		mov r1, #2
		bl draw_objects
		pop {r0-r4,lr}
		bx lr
		
		
draw_objects:
		push {r4,lr}
		ldr r4, [r3], #4
		cmp r4, #1
		bleq draw_obstacles_ASM
		cmp r4, #2
		bleq draw_ampersand_ASM
		cmp r4, #3
		bleq draw_exit_ASM
		pop {r4,lr}
		add r0, r0, #4
		cmp r0, #50
		moveq r0, #2
		addeq r1, #4
		cmp r1, #38
		ldreq r3, =playedmaze
		bxeq lr
		b draw_objects
		
		

move_ASM:
		push {r5-r10}
		ldr r9, =ampersandvalue
		ldr r9, [r9]
		ldr r5, =keyboarddata
		ldr r5, [r5]
		mov r7, #2
		mov r8, #0
		mov r6, #1
		//moving vertically changes the address by 48
		//moving horizontally changes the address by 4
		cmp r9, #0x34
		cmpgt r5, #11
		ldreq r6, [r9, #-48]
		cmp r6, #0
		streq r8, [r9]
		subeq r9, #48
		streq r7, [r9]
		moveq r6, #1
		cmp r5, #12
		ldreq r6, [r9, #-4]
		cmp r6, #0
		streq r8, [r9]
		subeq r9, #4
		streq r7, [r9]
		moveq r6, #1
		cmp r9, #0x188
		cmplt r5, #13
		ldreq r6, [r9, #48]
		cmp r6, #3
		bleq result_ASM
		cmp r6, #0
		streq r8, [r9]
		addeq r9, #48
		streq r7, [r9]
		moveq r6, #1
		cmp r5, #14
		ldreq r6, [r9,#4]
		cmp r6, #3
		bleq result_ASM
		cmp r6, #0
		streq r8, [r9]
		addeq r9, #4
		streq r7, [r9]
		ldr r8, =ampersandvalue
		str r9, [r8]
		push {lr}
		bl VGA_clear_charbuff_ASM
		bl fill_grid_ASM
		pop {lr}
		pop {r5-r10}
		bx lr

result_ASM:
		push    {r0,r4, r5, r6, r7, r8, r9, r10,lr}
        mov     r2, #86
        mov     r1, #42
        mov     r0, #20
        bl      VGA_write_char_ASM
        mov     r2, #73
        mov     r1, #42
        mov     r0, #21
        bl      VGA_write_char_ASM
        mov     r2, #67
        mov     r1, #42
        mov     r0, #22
        bl      VGA_write_char_ASM
        mov     r2, #84
        mov     r1, #42
        mov     r0, #23
        bl      VGA_write_char_ASM
        mov     r2, #79
        mov     r1, #42
        mov     r0, #24
        bl      VGA_write_char_ASM
        mov     r2, #82
        mov     r1, #42
        mov     r0, #25
        bl      VGA_write_char_ASM
        mov     r2, #89
        mov     r1, #42
        mov     r0, #26
		bl      VGA_write_char_ASM
		mov     r2, #33
        mov     r1, #42
        mov     r0, #27
		bl      VGA_write_char_ASM
        pop     {r0,r4, r5, r6, r7, r8, r9, r10,lr}
		mov r0, #0
		mov r1, #0x00
		mov r8, #0x2D
		add r1, r1, r8, LSL #8
		mov r8, #0x31
		add r1, r1, r8, LSL #16
		mov r8, #0xA
		add r1, r1, r8, LSL #24
		mov r8, #0b1001
		mov r2, #0b0001
		add r2, r2, r8, LSL #8
		bl ARM_TIM_config_ASM
		bl ARM_TIM_clear_INT_ASM
		b checkloop
		
checkloop:
		bl ARM_TIM_read_INT_ASM
		TST r0, #1
		blne ARM_TIM_clear_INT_ASM
		blne _start
		b checkloop
		
ARM_TIM_config_ASM: 
	push {r3-r4,lr}
	ldr r3, =LOAD_VALUE
	ldr r4, =CONTROL_REGISTER
	str r1, [r3]
	str r2, [r4]
	pop {r3-r4, lr}
	bx lr
	
ARM_TIM_read_INT_ASM:
	push {r3,lr}
	ldr r3, =INTERRUPT_STATUS_REGISTER
	ldr r3, [r3]
	mov r0, r3
	pop {r3,lr}
	bx lr
	
ARM_TIM_clear_INT_ASM:
	push {r3-r4,lr}
	ldr r3, =INTERRUPT_STATUS_REGISTER
	MOV r4, #1
	str r4, [r3]
	pop {r3-r4,lr}
	bx lr
	
	
	