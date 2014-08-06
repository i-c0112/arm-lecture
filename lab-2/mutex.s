	.syntax unified
	.arch armv7-a
	.text

	.equ locked, 1
	.equ unlocked, 0

	.global lock_mutex
	.type lock_mutex, function
lock_mutex:
        @ INSERT CODE BELOW
	// initialized once and for all
	mov r1, #locked

lock_retry:
	ldrex r2, [r0]

	cmp r2, r1
	// retry, currently flag set to locked
	beq lock_retry
	// otherwise, change public flag to locked
	strexne r2, r1, [r0] 

	cmpne r2, #0 
	// failed to strex, status != 0, retry
	bne lock_retry
	dmb
        @ END CODE INSERT
	bx lr

	.size lock_mutex, .-lock_mutex

	.global unlock_mutex
	.type unlock_mutex, function
unlock_mutex:
	@ INSERT CODE BELOW
        mov r1, #unlocked
	dmb
	str r1, [r0]
        @ END CODE INSERT
	bx lr
	.size unlock_mutex, .-unlock_mutex

	.end
