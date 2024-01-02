.equ LOAD_VALUE, 0xFFFEC600
.equ CONTROL_REGISTER, 0xFFFEC608
.equ INTERRUPT_STATUS_REGISTER, 0xFFFEC60C
.equ SW_7segment, 0xFF200020
.equ DATA_REGISTER, 0xFF200050
.equ INTERRUPT_MASK_REGISTER, 0xFF200058
.equ EDGE_CAPTURE_REGISTER, 0xFF20005c
.equ LED_MEMORY, 0xFF200000
.equ SW_MEMORY, 0xFF200040

.global _start

_start:
	mov r1, #0b111
	bl enable_PB_INT_ASM
	mov r1, #0x00
	mov r8, #0x2D
	add r1, r1, r8, LSL #8
	mov r8, #0x31
	add r1, r1, r8, LSL #16
	mov r8, #0x1
	add r1, r1, r8, LSL #24
	mov r5, #0
	mov r6, #0
	mov r9, #0
	mov r10, #0
	mov r11, #0
	mov r12, #0
	mov r2, #0b011
	mov r3, #0
	bl ARM_TIM_config_ASM
	b timerloop
	
timerloop:
	CMP r5, #0xA
	moveq r5, #0
	addeq r6, r6, #1
	CMP r6, #0xA
	moveq r6, #0
	addeq r9, r9, #1
	CMP r9, #0x6
	moveq r9, #0
	addeq r10, r10, #1
	CMP r10, #0xA
	moveq r10, #0
	addeq r11, r11, #1
	CMP r11, #0x6
	moveq r11, #0
	addeq r12, r12, #1
	mov r2, r5
	mov r7, #1
	bl HEX_write_ASM
	mov r2, r6
	mov r7, #2
	bl HEX_write_ASM
	mov r2, r9
	mov r7, #4
	bl HEX_write_ASM
	mov r2, r10
	mov r7, #8
	bl HEX_write_ASM
	mov r2, r11
	mov r7, #16
	bl HEX_write_ASM
	mov r2, r12
	mov r7, #32
	bl HEX_write_ASM
	b checkloop
checkloop:
	bl read_PB_edgecp_ASM
	CMP r0, #3
	bleq PB_clear_edgecp_ASM
	bleq timerloop
	TST r0, #1
	blne PB_clear_edgecp_ASM
	TST r0, #4
	blne _start
	TST r0, #2
	blne checkloop
	bl ARM_TIM_read_INT_ASM
	TST r0, #1
	addne r5, r5, #1
	blne ARM_TIM_clear_INT_ASM
	b timerloop
	
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
ARM_TIM_clear_INT_ASM:
	push {r3-r4,lr}
	ldr r3, =INTERRUPT_STATUS_REGISTER
	MOV r4, #1
	str r4, [r3]
	pop {r3-r4,lr}
	
clear:
	push {r7,lr}
	mov r7, #0x3F
	bl HEX_clear_ASM
	pop {r7,lr}
	bx lr

read_slider_switches_ASM:
	push {r1,lr}
    LDR R1, =SW_MEMORY
    LDR R0, [R1]
	pop {r1,lr}
    BX  LR
	
write_LEDs_ASM:
	push {r1,lr}
    LDR R1, =LED_MEMORY
    STR R0, [R1]
	pop {r1,lr}
    BX  LR

HEX_clear_ASM:
	push {r1-r5,lr}
	ldr r1, =SW_7segment
	mov r4, #0
	mov r3, #0
	TST R7, #0b1
	blne loop
	add r4, r4, #1
	TST R7, #0b10
	blne loop
	add r4, r4, #1
	TST R7, #0b100
	blne loop
	add r4, r4, #1
	TST R7, #0b1000
	blne loop
	add r1, r1, #0x10
	mov r4, #0
	TST R7, #0b10000
	blne loop
	add r4, r4, #1
	TST R7, #0b100000
	blne loop
	pop {r1-r5,lr}
	bx lr

HEX_flood_ASM:
	push {r1-r5,lr}
	ldr r1, =SW_7segment
	mov r4, #0
	mov r3, #127
	TST R7, #0b1
	blne loop
	add r4, r4, #1
	TST R7, #0b10
	blne loop
	add r4, r4, #1
	TST R7, #0b100
	blne loop
	add r4, r4, #1
	TST R7, #0b1000
	blne loop
	add r1, r1, #0x10
	mov r4, #0
	TST R7, #0b10000
	blne loop
	add r4, r4, #1
	TST R7, #0b100000
	blne loop
	pop {r1-r5,lr}
	bx lr

loop:
	strb r3, [r1,r4]
	bx lr


HEX_write_ASM:
	push {r1-r5,lr}
	ldr r1, =SW_7segment
	mov r4, #0
	mov r3, #0
	CMP r2, #0b0
	addeq r3, r3, #0b0111111
	CMP r2, #0b1
	addeq r3, r3, #0b0000110
	CMP r2, #0b10
	addeq r3, r3, #0b1011011
	CMP r2, #0b11
	addeq r3, r3, #0b1001111
	CMP r2, #0b100
	addeq r3, r3, #0b1100110
	CMP r2, #0b101
	addeq r3, r3, #0b1101101
	CMP r2, #0b110
	addeq r3, r3, #0b1111101
	CMP r2, #0b111
	addeq r3, r3, #0b0000111
	CMP r2, #0b1000
	addeq r3, r3, #0b1111111
	CMP r2, #0b1001
	addeq r3, r3, #0b1101111
	CMP r2, #0b1010
	addeq r3, r3, #0b1110111
	CMP r2, #0b1011
	addeq r3, r3, #0b1111100
	CMP r2, #0b1100
	addeq r3, r3, #0b0111001
	CMP r2, #0b1101
	addeq r3, r3, #0b1011110
	CMP r2, #0b1110
	addeq r3, r3, #0b1111001
	CMP r2, #0b1111
	addeq r3, r3, #0b1110001
	TST R7, #0b1
	blne loop
	add r4, r4, #1
	TST R7, #0b10
	blne loop
	add r4, r4, #1
	TST R7, #0b100
	blne loop
	add r4, r4, #1
	TST R7, #0b1000
	blne loop
	add r1,r1,#0x10
	mov r4, #0
	TST R7, #0b10000
	blne loop
	add r4, r4, #1
	TST R7, #0b100000
	blne loop
	pop {r1-r5,lr}
	bx lr
	
read_PB_data_ASM:
	push {r1,lr}
	ldr r0, =DATA_REGISTER
	ldr r0, [r0]
	mov r1, #0
	TST r0, #0b1
	addne r1, r1, #1
	TST r0, #0b10
	addne r1, r1, #2
	TST r0, #0b100
	addne r1, r1, #4
	TST r0, #0b1000
	addne r1, r1, #8
	mov r0, r1
	pop {r1,lr}
	bx lr
PB_data_is_pressed_ASM:
	push {r1,lr}
	bl read_PB_data_ASM
	tst r0,r1
	movne r0, #1
	pop {r1,lr}
	bx lr


read_PB_edgecp_ASM:
	push {r1,lr}
	ldr r0, =EDGE_CAPTURE_REGISTER
	ldr r0, [r0]
	mov r1, #0
	TST r0, #0b1
	addne r1, r1, #1
	TST r0, #0b10
	addne r1, r1, #2
	TST r0, #0b100
	addne r1, r1, #4
	TST r0, #0b1000
	addne r1, r1, #8
	mov r0, r1
	pop {r1,lr}
	bx lr
PB_edgecp_is_pressed_ASM:
	push {r1,lr}
	bl read_PB_edgecp_ASM
	tst r0,r1
	movne r0, #1
	pop {r1,lr}
	bx lr
PB_clear_edgecp_ASM:
	push {r1,lr}
	ldr r1, =EDGE_CAPTURE_REGISTER
	bl read_PB_edgecp_ASM
	str r0, [r1]
	pop {r1,lr}
	bx lr
	
enable_PB_INT_ASM:
	push {r1-r3,lr}
	ldr r2, =INTERRUPT_MASK_REGISTER
	ldr r3, [r2]
	orr r1, r1, r3
	str r1, [r2]
	pop {r1-r3, lr}
	bx lr
disable_PB_INT_ASM:
	push {r1-r3,lr}
	ldr r2, =INTERRUPT_MASK_REGISTER
	ldr r3, [r2]
	eor r1, r1, #0b1111
	and r1, r1, r3
	str r1, [r2]
	pop {r1-r3, lr}
	bx lr
		
	
	
	