.equ LOAD_VALUE, 0xFFFEC600
.equ CONTROL_REGISTER, 0xFFFEC608
.equ INTERRUPT_STATUS_REGISTER, 0xFFFEC60C
.equ SW_7segment, 0xFF200020
.equ DATA_REGISTER, 0xFF200050
.equ INTERRUPT_MASK_REGISTER, 0xFF200058
.equ EDGE_CAPTURE_REGISTER, 0xFF20005c
.equ LED_MEMORY, 0xFF200000
.equ SW_MEMORY, 0xFF200040
PB_int_flag:
    .word 0x0
TIM_int_flag:
    .word 0x0
.global _start

.section .vectors, "ax"
B _start
B SERVICE_UND       // undefined instruction vector
B SERVICE_SVC       // software interrupt vector
B SERVICE_ABT_INST  // aborted prefetch vector
B SERVICE_ABT_DATA  // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ       // IRQ interrupt vector
B SERVICE_FIQ       // FIQ interrupt vector

_start:
	 /* Set up stack pointers for IRQ and SVC processor modes */
    MOV    R1, #0b11010010      // interrupts masked, MODE = IRQ
    MSR    CPSR_c, R1           // change to IRQ mode
    LDR    SP, =0xFFFFFFFF - 3  // set IRQ stack to A9 onchip memory
    /* Change to SVC (supervisor) mode with interrupts disabled */
    MOV    R1, #0b11010011      // interrupts masked, MODE = SVC
    MSR    CPSR, R1             // change to supervisor mode
    LDR    SP, =0x3FFFFFFF - 3  // set SVC stack to top of DDR3 memory
    BL     CONFIG_GIC           // configure the ARM GIC
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
	mov r2, #0b111
	mov r3, #0
	bl ARM_TIM_config_ASM  
    LDR    R0, =0xFF200050      // pushbutton KEY base address
    MOV    R1, #0xF             // set interrupt mask bits
    STR    R1, [R0, #0x8]       // interrupt mask register (base + 8)
    // enable IRQ interrupts in the processor
    MOV    R0, #0b01010011      // IRQ unmasked, MODE = SVC
    MSR    CPSR_c, R0


idle:
	ldr r0, =PB_int_flag
	ldr r0,[r0]
	TST r0, #1
	blne PB_clear_edgecp_ASM
	TST r0, #4
	blne _start
	TST r0, #2
	blne idle
	bl KEY_ISR
	ldr r0, =TIM_int_flag
	ldr r0,[r0]
	TST r0, #1
	addne r5, r5, #1
	bl ARM_TIM_ISR
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
	b idle


/*--- Undefined instructions ---------------------------------------- */
SERVICE_UND:
    B SERVICE_UND
/*--- Software interrupts ------------------------------------------- */
SERVICE_SVC:
    B SERVICE_SVC
/*--- Aborted data reads -------------------------------------------- */
SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA
/*--- Aborted instruction fetch ------------------------------------- */
SERVICE_ABT_INST:
    B SERVICE_ABT_INST
/*--- IRQ ----------------------------------------------------------- */
SERVICE_IRQ:
    PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
    LDR R4, =0xFFFEC100
    LDR R5, [R4, #0x0C] // read from ICCIAR
	ARM_TIM_check:
	CMP r5, #29
	BEQ ARM_TIM_ISR
/* To Do: Check which interrupt has occurred (check interrupt IDs)
   Then call the corresponding ISR
   If the ID is not recognized, branch to UNEXPECTED 
   See the assembly example provided in the De1-SoC Computer_Manual on page 46 */     
 	Pushbutton_check:
    CMP R5, #73
UNEXPECTED:
    BNE UNEXPECTED      // if not recognized, stop here
    BL KEY_ISR
EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
    STR R5, [R4, #0x10] // write to ICCEOIR
    POP {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ----------------------------------------------------------- */
SERVICE_FIQ:
    B SERVICE_FIQ
	
	
CONFIG_GIC:
    PUSH {LR}
/* To configure the FPGA KEYS interrupt (ID 73):
* 1. set the target to cpu0 in the ICDIPTRn register
* 2. enable the interrupt in the ICDISERn register */
/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
/* To Do: you can configure different interrupts
   by passing their IDs to R0 and repeating the next 3 lines */  
    MOV R0, #73            // KEY port (Interrupt ID = 73)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT 
	MOV R0, #29            // KEY port (Interrupt ID = 29)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT

/* configure the GIC CPU Interface */
    LDR R0, =0xFFFEC100    // base address of CPU Interface
/* Set Interrupt Priority Mask Register (ICCPMR) */
    LDR R1, =0xFFFF        // enable interrupts of all priorities levels
    STR R1, [R0, #0x04]
/* Set the enable bit in the CPU Interface Control Register (ICCICR).
* This allows interrupts to be forwarded to the CPU(s) */
    MOV R1, #1
    STR R1, [R0]
/* Set the enable bit in the Distributor Control Register (ICDDCR).
* This enables forwarding of interrupts to the CPU Interface(s) */
    LDR R0, =0xFFFED000
    STR R1, [R0]
    POP {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/
CONFIG_INTERRUPT:
    PUSH {R4-R5, LR}
/* Configure Interrupt Set-Enable Registers (ICDISERn).
* reg_offset = (integer_div(N / 32) * 4
* value = 1 << (N mod 32) */
    LSR R4, R0, #3    // calculate reg_offset
    BIC R4, R4, #3    // R4 = reg_offset
    LDR R2, =0xFFFED100
    ADD R4, R2, R4    // R4 = address of ICDISER
    AND R2, R0, #0x1F // N mod 32
    MOV R5, #1        // enable
    LSL R2, R5, R2    // R2 = value
/* Using the register address in R4 and the value in R2 set the
* correct bit in the GIC register */
    LDR R3, [R4]      // read current register value
    ORR R3, R3, R2    // set the enable bit
    STR R3, [R4]      // store the new register value
/* Configure Interrupt Processor Targets Register (ICDIPTRn)
* reg_offset = integer_div(N / 4) * 4
* index = N mod 4 */
    BIC R4, R0, #3    // R4 = reg_offset
    LDR R2, =0xFFFED800
    ADD R4, R2, R4    // R4 = word address of ICDIPTR
    AND R2, R0, #0x3  // N mod 4
    ADD R4, R2, R4    // R4 = byte address in ICDIPTR
/* Using register address in R4 and the value in R2 write to
* (only) the appropriate byte */
    STRB R1, [R4]
    POP {R4-R5, PC}
	
KEY_ISR:
	push {r3-r4,lr}
    LDR R4, =0xFF200050    // base address of pushbutton KEY port
    LDR R1, [R4, #0xC]     // read edge capture register
	LDR r3, =PB_int_flag
	str r1, [r3]
    MOV R2, #0xF
    STR R2, [R4, #0xC]     // clear the interrupt
	pop {r3-r4,lr}
    BX LR	
	
ARM_TIM_ISR:
	push {r0-r3,lr}
	bl ARM_TIM_read_INT_ASM
	ldr r3, =TIM_int_flag
	str r0, [r3]
	bl ARM_TIM_clear_INT_ASM
	pop {r0-r3,lr}
	bx lr

	
	
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
	push {r0,r1,lr}
	ldr r1, =EDGE_CAPTURE_REGISTER
	bl read_PB_edgecp_ASM
	str r0, [r1]
	pop {r0,r1,lr}
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
		
	
	