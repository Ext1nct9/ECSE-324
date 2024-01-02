.global _start

_start:
	result: .space 4
	MOV r0, #22  // dividend
	MOV r1, #10  // divisor
	MOV R2, #0  // remainder
	BL dev
	b stop
	
stop:
b stop


dev:
	push {r3,r4}
	MOV r3, #0  // quotient
	ldr r4, result
	ADD r2, r2,r0
dev2:
	CMP r2,r1
	BLT continue
	b devloop
	
continue:
	ADD r2, r2, r3, LSL#16
	STR r2, [r4]
	MOV r2, r4
	ldr r0, [r4]
	pop {r3,r4}
	bx lr
	
devloop:
	SUB r2,r2,r1
	ADD r3, r3, #1
	B dev2
	
.end

	