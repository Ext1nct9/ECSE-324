.global _start
_start:
        bl      input_loop
end:
        b       end

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
mov r4, #0x40
mov r3, #1
add r4, r4, r3, LSL #8
cmp r0, r4
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
		bxgt lr
		cmp r1, #59
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
strb r4, [r0]
mov r0, #1
pop {r4,lr}
bx lr

		
		

write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}
	
	
	
	