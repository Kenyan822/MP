	.file	1 "test.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	softfloat
	.module	nooddspreg
	.text
 #APP
	.global __start__		
	__start__:			
		lui $sp, 0		
		ori $sp, 0xff00		
		li $gp, 0		
		li $k0, 0x02000101	
		mtc0 $k0, $12		
	
 #NO_APP
	.align	2
	.globl	__reset__
	.set	nomips16
	.set	nomicromips
	.ent	__reset__
	.type	__reset__, @function
__reset__:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	lui	$2,%hi(__sbackup)
	addiu	$2,$2,%lo(__sbackup)
	sw	$2,0($fp)
	lui	$2,%hi(__sdata)
	addiu	$2,$2,%lo(__sdata)
	sw	$2,4($fp)
	b	$L2
$L3:
	lw	$3,0($fp)
	#nop
	addiu	$2,$3,4
	sw	$2,0($fp)
	lw	$2,4($fp)
	#nop
	addiu	$4,$2,4
	sw	$4,4($fp)
	lw	$3,0($3)
	#nop
	sw	$3,0($2)
$L2:
	lw	$3,4($fp)
	lui	$2,%hi(__edata)
	addiu	$2,$2,%lo(__edata)
	sltu	$2,$3,$2
	bne	$2,$0,$L3
	lui	$2,%hi(__sbss)
	addiu	$2,$2,%lo(__sbss)
	sw	$2,4($fp)
	b	$L4
$L5:
	lw	$2,4($fp)
	#nop
	sw	$0,0($2)
	lw	$2,4($fp)
	#nop
	addiu	$2,$2,4
	sw	$2,4($fp)
$L4:
	lw	$3,4($fp)
	lui	$2,%hi(__ebss)
	addiu	$2,$2,%lo(__ebss)
	sltu	$2,$3,$2
	bne	$2,$0,$L5
 #APP
 # 24 "crt0.c" 1
	j main
 # 0 "" 2
 #NO_APP
	.set	noreorder
	nop
	.set	reorder
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	.end	__reset__
	.size	__reset__, .-__reset__
 #APP
	nop			
		nop			
		nop			
		nop			
		nop			
	__vector__:			
	.set noat			
		move $k0, $sp		
		lui $sp, 0		
		ori $sp, 0xc000		
		addiu $sp, $sp, -128	
		sw $k0, 124($sp)	
		sw $at, 120($sp)	
	.set at			
		sw $v0, 116($sp)	
		sw $v1, 112($sp)	
		sw $a0, 108($sp)	
		sw $a1, 104($sp)	
		sw $a2, 100($sp)	
		sw $a3,  96($sp)	
		sw $t0,  92($sp)	
		sw $t1,  88($sp)	
		sw $t2,  84($sp)	
		sw $t3,  80($sp)	
		sw $t4,  76($sp)	
		sw $t5,  72($sp)	
		sw $t6,  68($sp)	
		sw $t7,  64($sp)	
		sw $s0,  60($sp)	
		sw $s1,  56($sp)	
		sw $s2,  52($sp)	
		sw $s3,  48($sp)	
		sw $s4,  44($sp)	
		sw $s5,  40($sp)	
		sw $s6,  36($sp)	
		sw $s7,  32($sp)	
		sw $t8,  28($sp)	
		sw $t9,  24($sp)	
		sw $gp,  20($sp)	
		sw $s8,  16($sp)	
		sw $ra,  12($sp)	
		jal interrupt_handler	
		lw $ra,  12($sp)	
		lw $s8,  16($sp)	
		lw $gp,  20($sp)	
		lw $t9,  24($sp)	
		lw $t8,  28($sp)	
		lw $s7,  32($sp)	
		lw $s6,  36($sp)	
		lw $s5,  40($sp)	
		lw $s4,  44($sp)	
		lw $s3,  48($sp)	
		lw $s2,  52($sp)	
		lw $s1,  56($sp)	
		lw $s0,  60($sp)	
		lw $t7,  64($sp)	
		lw $t6,  68($sp)	
		lw $t5,  72($sp)	
		lw $t4,  76($sp)	
		lw $t3,  80($sp)	
		lw $t2,  84($sp)	
		lw $t1,  88($sp)	
		lw $t0,  92($sp)	
		lw $a3,  96($sp)	
		lw $a2, 100($sp)	
		lw $a1, 104($sp)	
		lw $a0, 108($sp)	
		lw $v1, 112($sp)	
		lw $v0, 116($sp)	
	.set noat			
		lw $at, 120($sp)	
		lw $k0, 124($sp)	
		move $sp, $k0		
		mfc0 $k1, $14		
		nop			
		rfe			
		nop			
		jr $k1			
		nop			
	
 #NO_APP
	.align	2
	.globl	memcpy
	.set	nomips16
	.set	nomicromips
	.ent	memcpy
	.type	memcpy, @function
memcpy:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	sw	$6,24($fp)
	lw	$2,16($fp)
	nop
	sw	$2,0($fp)
	lw	$2,20($fp)
	nop
	sw	$2,4($fp)
	b	$L7
	nop

$L8:
	lw	$3,4($fp)
	nop
	addiu	$2,$3,1
	sw	$2,4($fp)
	lw	$2,0($fp)
	nop
	addiu	$4,$2,1
	sw	$4,0($fp)
	lb	$3,0($3)
	nop
	sb	$3,0($2)
$L7:
	lw	$2,24($fp)
	nop
	addiu	$3,$2,-1
	sw	$3,24($fp)
	bne	$2,$0,$L8
	nop

	lw	$2,16($fp)
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	memcpy
	.size	memcpy, .-memcpy
	.align	2
	.globl	memset
	.set	nomips16
	.set	nomicromips
	.ent	memset
	.type	memset, @function
memset:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	sw	$6,24($fp)
	lw	$2,16($fp)
	nop
	sw	$2,0($fp)
	b	$L11
	nop

$L12:
	lw	$2,0($fp)
	nop
	addiu	$3,$2,1
	sw	$3,0($fp)
	lw	$3,20($fp)
	nop
	sll	$3,$3,24
	sra	$3,$3,24
	sb	$3,0($2)
$L11:
	lw	$2,24($fp)
	nop
	addiu	$3,$2,-1
	sw	$3,24($fp)
	bne	$2,$0,$L12
	nop

	lw	$2,16($fp)
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	memset
	.size	memset, .-memset
	.globl	font8x8
	.rdata
	.align	2
	.type	font8x8, @object
	.size	font8x8, 768
font8x8:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	95
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	3
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	100
	.byte	60
	.byte	38
	.byte	100
	.byte	60
	.byte	38
	.byte	36
	.byte	0
	.byte	38
	.byte	73
	.byte	73
	.byte	127
	.byte	73
	.byte	73
	.byte	50
	.byte	0
	.byte	66
	.byte	37
	.byte	18
	.byte	8
	.byte	36
	.byte	82
	.byte	33
	.byte	0
	.byte	32
	.byte	80
	.byte	78
	.byte	85
	.byte	34
	.byte	88
	.byte	40
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	28
	.byte	34
	.byte	65
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	65
	.byte	34
	.byte	28
	.byte	0
	.byte	0
	.byte	0
	.byte	21
	.byte	21
	.byte	14
	.byte	14
	.byte	21
	.byte	21
	.byte	0
	.byte	0
	.byte	8
	.byte	8
	.byte	62
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	80
	.byte	48
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.byte	8
	.byte	8
	.byte	8
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	64
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.byte	0
	.byte	0
	.byte	62
	.byte	65
	.byte	65
	.byte	65
	.byte	62
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	65
	.byte	127
	.byte	64
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	66
	.byte	97
	.byte	81
	.byte	73
	.byte	110
	.byte	0
	.byte	0
	.byte	0
	.byte	34
	.byte	65
	.byte	73
	.byte	73
	.byte	54
	.byte	0
	.byte	0
	.byte	0
	.byte	24
	.byte	20
	.byte	18
	.byte	127
	.byte	16
	.byte	0
	.byte	0
	.byte	0
	.byte	39
	.byte	73
	.byte	73
	.byte	73
	.byte	113
	.byte	0
	.byte	0
	.byte	0
	.byte	60
	.byte	74
	.byte	73
	.byte	72
	.byte	112
	.byte	0
	.byte	0
	.byte	0
	.byte	67
	.byte	33
	.byte	17
	.byte	13
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	54
	.byte	73
	.byte	73
	.byte	73
	.byte	54
	.byte	0
	.byte	0
	.byte	0
	.byte	6
	.byte	9
	.byte	73
	.byte	41
	.byte	30
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	18
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	82
	.byte	48
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.byte	20
	.byte	20
	.byte	34
	.byte	0
	.byte	0
	.byte	0
	.byte	20
	.byte	20
	.byte	20
	.byte	20
	.byte	20
	.byte	20
	.byte	0
	.byte	0
	.byte	0
	.byte	34
	.byte	20
	.byte	20
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.byte	1
	.byte	89
	.byte	5
	.byte	2
	.byte	0
	.byte	0
	.byte	62
	.byte	65
	.byte	93
	.byte	85
	.byte	77
	.byte	81
	.byte	46
	.byte	0
	.byte	64
	.byte	124
	.byte	74
	.byte	9
	.byte	74
	.byte	124
	.byte	64
	.byte	0
	.byte	65
	.byte	127
	.byte	73
	.byte	73
	.byte	73
	.byte	73
	.byte	54
	.byte	0
	.byte	28
	.byte	34
	.byte	65
	.byte	65
	.byte	65
	.byte	65
	.byte	34
	.byte	0
	.byte	65
	.byte	127
	.byte	65
	.byte	65
	.byte	65
	.byte	34
	.byte	28
	.byte	0
	.byte	65
	.byte	127
	.byte	73
	.byte	73
	.byte	93
	.byte	65
	.byte	99
	.byte	0
	.byte	65
	.byte	127
	.byte	73
	.byte	9
	.byte	29
	.byte	1
	.byte	3
	.byte	0
	.byte	28
	.byte	34
	.byte	65
	.byte	73
	.byte	73
	.byte	58
	.byte	8
	.byte	0
	.byte	65
	.byte	127
	.byte	8
	.byte	8
	.byte	8
	.byte	127
	.byte	65
	.byte	0
	.byte	0
	.byte	65
	.byte	65
	.byte	127
	.byte	65
	.byte	65
	.byte	0
	.byte	0
	.byte	48
	.byte	64
	.byte	65
	.byte	65
	.byte	63
	.byte	1
	.byte	1
	.byte	0
	.byte	65
	.byte	127
	.byte	8
	.byte	12
	.byte	18
	.byte	97
	.byte	65
	.byte	0
	.byte	65
	.byte	127
	.byte	65
	.byte	64
	.byte	64
	.byte	64
	.byte	96
	.byte	0
	.byte	65
	.byte	127
	.byte	66
	.byte	12
	.byte	66
	.byte	127
	.byte	65
	.byte	0
	.byte	65
	.byte	127
	.byte	66
	.byte	12
	.byte	17
	.byte	127
	.byte	1
	.byte	0
	.byte	28
	.byte	34
	.byte	65
	.byte	65
	.byte	65
	.byte	34
	.byte	28
	.byte	0
	.byte	65
	.byte	127
	.byte	73
	.byte	9
	.byte	9
	.byte	9
	.byte	6
	.byte	0
	.byte	12
	.byte	18
	.byte	33
	.byte	33
	.byte	97
	.byte	82
	.byte	76
	.byte	0
	.byte	65
	.byte	127
	.byte	9
	.byte	9
	.byte	25
	.byte	105
	.byte	70
	.byte	0
	.byte	102
	.byte	73
	.byte	73
	.byte	73
	.byte	73
	.byte	73
	.byte	51
	.byte	0
	.byte	3
	.byte	1
	.byte	65
	.byte	127
	.byte	65
	.byte	1
	.byte	3
	.byte	0
	.byte	1
	.byte	63
	.byte	65
	.byte	64
	.byte	65
	.byte	63
	.byte	1
	.byte	0
	.byte	1
	.byte	15
	.byte	49
	.byte	64
	.byte	49
	.byte	15
	.byte	1
	.byte	0
	.byte	1
	.byte	31
	.byte	97
	.byte	20
	.byte	97
	.byte	31
	.byte	1
	.byte	0
	.byte	65
	.byte	65
	.byte	54
	.byte	8
	.byte	54
	.byte	65
	.byte	65
	.byte	0
	.byte	1
	.byte	3
	.byte	68
	.byte	120
	.byte	68
	.byte	3
	.byte	1
	.byte	0
	.byte	67
	.byte	97
	.byte	81
	.byte	73
	.byte	69
	.byte	67
	.byte	97
	.byte	0
	.byte	0
	.byte	0
	.byte	127
	.byte	65
	.byte	65
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	2
	.byte	4
	.byte	8
	.byte	16
	.byte	32
	.byte	64
	.byte	0
	.byte	0
	.byte	0
	.byte	65
	.byte	65
	.byte	127
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	4
	.byte	2
	.byte	1
	.byte	1
	.byte	2
	.byte	4
	.byte	0
	.byte	0
	.byte	64
	.byte	64
	.byte	64
	.byte	64
	.byte	64
	.byte	64
	.byte	0
	.byte	0
	.byte	1
	.byte	2
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	52
	.byte	74
	.byte	74
	.byte	74
	.byte	60
	.byte	64
	.byte	0
	.byte	0
	.byte	65
	.byte	63
	.byte	72
	.byte	72
	.byte	72
	.byte	48
	.byte	0
	.byte	0
	.byte	60
	.byte	66
	.byte	66
	.byte	66
	.byte	36
	.byte	0
	.byte	0
	.byte	0
	.byte	48
	.byte	72
	.byte	72
	.byte	73
	.byte	63
	.byte	64
	.byte	0
	.byte	0
	.byte	60
	.byte	74
	.byte	74
	.byte	74
	.byte	44
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	72
	.byte	126
	.byte	73
	.byte	9
	.byte	0
	.byte	0
	.byte	0
	.byte	38
	.byte	73
	.byte	73
	.byte	73
	.byte	63
	.byte	1
	.byte	0
	.byte	65
	.byte	127
	.byte	72
	.byte	4
	.byte	68
	.byte	120
	.byte	64
	.byte	0
	.byte	0
	.byte	0
	.byte	68
	.byte	125
	.byte	64
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	64
	.byte	68
	.byte	61
	.byte	0
	.byte	0
	.byte	0
	.byte	65
	.byte	127
	.byte	16
	.byte	24
	.byte	36
	.byte	66
	.byte	66
	.byte	0
	.byte	0
	.byte	64
	.byte	65
	.byte	127
	.byte	64
	.byte	64
	.byte	0
	.byte	0
	.byte	66
	.byte	126
	.byte	2
	.byte	124
	.byte	2
	.byte	126
	.byte	64
	.byte	0
	.byte	66
	.byte	126
	.byte	68
	.byte	2
	.byte	66
	.byte	124
	.byte	64
	.byte	0
	.byte	0
	.byte	60
	.byte	66
	.byte	66
	.byte	66
	.byte	60
	.byte	0
	.byte	0
	.byte	0
	.byte	65
	.byte	127
	.byte	73
	.byte	9
	.byte	9
	.byte	6
	.byte	0
	.byte	0
	.byte	6
	.byte	9
	.byte	9
	.byte	73
	.byte	127
	.byte	65
	.byte	0
	.byte	0
	.byte	66
	.byte	126
	.byte	68
	.byte	2
	.byte	2
	.byte	4
	.byte	0
	.byte	0
	.byte	100
	.byte	74
	.byte	74
	.byte	74
	.byte	54
	.byte	0
	.byte	0
	.byte	0
	.byte	4
	.byte	63
	.byte	68
	.byte	68
	.byte	32
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.byte	62
	.byte	64
	.byte	64
	.byte	34
	.byte	126
	.byte	64
	.byte	2
	.byte	14
	.byte	50
	.byte	64
	.byte	50
	.byte	14
	.byte	2
	.byte	0
	.byte	2
	.byte	30
	.byte	98
	.byte	24
	.byte	98
	.byte	30
	.byte	2
	.byte	0
	.byte	66
	.byte	98
	.byte	20
	.byte	8
	.byte	20
	.byte	98
	.byte	66
	.byte	0
	.byte	1
	.byte	67
	.byte	69
	.byte	56
	.byte	5
	.byte	3
	.byte	1
	.byte	0
	.byte	0
	.byte	70
	.byte	98
	.byte	82
	.byte	74
	.byte	70
	.byte	98
	.byte	0
	.byte	0
	.byte	0
	.byte	8
	.byte	54
	.byte	65
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	127
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	65
	.byte	54
	.byte	8
	.byte	0
	.byte	0
	.byte	0
	.byte	24
	.byte	8
	.byte	8
	.byte	16
	.byte	16
	.byte	24
	.byte	0
	.byte	-86
	.byte	85
	.byte	-86
	.byte	85
	.byte	-86
	.byte	85
	.byte	-86
	.byte	85
	.globl	RACKET_PATTERN
	.align	2
	.type	RACKET_PATTERN, @object
	.size	RACKET_PATTERN, 96
RACKET_PATTERN:
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	2
	.byte	2
	.byte	2
	.byte	2
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	2
	.byte	2
	.byte	2
	.byte	2
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	2
	.byte	2
	.byte	2
	.byte	2
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	2
	.byte	2
	.byte	2
	.byte	2
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.globl	PLAYER_PATTERN
	.align	2
	.type	PLAYER_PATTERN, @object
	.size	PLAYER_PATTERN, 64
PLAYER_PATTERN:
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	0
	.globl	game_state
	.section	.bss,"aw",@nobits
	.align	2
	.type	game_state, @object
	.size	game_state, 4
game_state:
	.space	4
	.globl	game_mode
	.align	2
	.type	game_mode, @object
	.size	game_mode, 4
game_mode:
	.space	4
	.globl	cursor
	.align	2
	.type	cursor, @object
	.size	cursor, 4
cursor:
	.space	4
	.globl	frame_counter
	.align	2
	.type	frame_counter, @object
	.size	frame_counter, 4
frame_counter:
	.space	4
	.globl	btn0_prev
	.align	2
	.type	btn0_prev, @object
	.size	btn0_prev, 4
btn0_prev:
	.space	4
	.globl	btn2_prev
	.align	2
	.type	btn2_prev, @object
	.size	btn2_prev, 4
btn2_prev:
	.space	4
	.globl	btn3_prev
	.align	2
	.type	btn3_prev, @object
	.size	btn3_prev, 4
btn3_prev:
	.space	4
	.globl	rotary_prev
	.data
	.align	2
	.type	rotary_prev, @object
	.size	rotary_prev, 4
rotary_prev:
	.word	128
	.globl	rotary_threshold
	.align	2
	.type	rotary_threshold, @object
	.size	rotary_threshold, 4
rotary_threshold:
	.word	4
	.globl	p1_x
	.align	2
	.type	p1_x, @object
	.size	p1_x, 4
p1_x:
	.word	2
	.globl	p1_y
	.align	2
	.type	p1_y, @object
	.size	p1_y, 4
p1_y:
	.word	24
	.globl	p2_x
	.align	2
	.type	p2_x, @object
	.size	p2_x, 4
p2_x:
	.word	86
	.globl	p2_y
	.align	2
	.type	p2_y, @object
	.size	p2_y, 4
p2_y:
	.word	24
	.globl	ball_x
	.align	2
	.type	ball_x, @object
	.size	ball_x, 4
ball_x:
	.word	46
	.globl	ball_y
	.align	2
	.type	ball_y, @object
	.size	ball_y, 4
ball_y:
	.word	30
	.globl	ball_vx
	.align	2
	.type	ball_vx, @object
	.size	ball_vx, 4
ball_vx:
	.word	3
	.globl	ball_vy
	.align	2
	.type	ball_vy, @object
	.size	ball_vy, 4
ball_vy:
	.word	2
	.globl	score_p1
	.section	.bss
	.align	2
	.type	score_p1, @object
	.size	score_p1, 4
score_p1:
	.space	4
	.globl	score_p2
	.align	2
	.type	score_p2, @object
	.size	score_p2, 4
score_p2:
	.space	4
	.globl	input_p1_dir
	.data
	.align	2
	.type	input_p1_dir, @object
	.size	input_p1_dir, 4
input_p1_dir:
	.word	-1
	.globl	input_p2_dir
	.align	2
	.type	input_p2_dir, @object
	.size	input_p2_dir, 4
input_p2_dir:
	.word	-1
	.globl	input_btn0
	.section	.bss
	.align	2
	.type	input_btn0, @object
	.size	input_btn0, 4
input_btn0:
	.space	4
	.globl	input_btn1
	.align	2
	.type	input_btn1, @object
	.size	input_btn1, 4
input_btn1:
	.space	4
	.globl	buzzer_timer
	.align	2
	.type	buzzer_timer, @object
	.size	buzzer_timer, 4
buzzer_timer:
	.space	4
	.globl	sq_p1_x
	.data
	.align	2
	.type	sq_p1_x, @object
	.size	sq_p1_x, 4
sq_p1_x:
	.word	2
	.globl	sq_p1_y
	.align	2
	.type	sq_p1_y, @object
	.size	sq_p1_y, 4
sq_p1_y:
	.word	20
	.globl	sq_p2_x
	.align	2
	.type	sq_p2_x, @object
	.size	sq_p2_x, 4
sq_p2_x:
	.word	2
	.globl	sq_p2_y
	.align	2
	.type	sq_p2_y, @object
	.size	sq_p2_y, 4
sq_p2_y:
	.word	36
	.globl	sq_ball_x
	.align	2
	.type	sq_ball_x, @object
	.size	sq_ball_x, 4
sq_ball_x:
	.word	46
	.globl	sq_ball_y
	.align	2
	.type	sq_ball_y, @object
	.size	sq_ball_y, 4
sq_ball_y:
	.word	26
	.globl	sq_ball_vx
	.align	2
	.type	sq_ball_vx, @object
	.size	sq_ball_vx, 4
sq_ball_vx:
	.word	3
	.globl	sq_ball_vy
	.align	2
	.type	sq_ball_vy, @object
	.size	sq_ball_vy, 4
sq_ball_vy:
	.word	2
	.globl	sq_score
	.section	.bss
	.align	2
	.type	sq_score, @object
	.size	sq_score, 4
sq_score:
	.space	4
	.globl	sq_lives
	.data
	.align	2
	.type	sq_lives, @object
	.size	sq_lives, 4
sq_lives:
	.word	3
	.globl	sq_turn
	.section	.bss
	.align	2
	.type	sq_turn, @object
	.size	sq_turn, 4
sq_turn:
	.space	4
	.globl	sq_rally
	.align	2
	.type	sq_rally, @object
	.size	sq_rally, 4
sq_rally:
	.space	4
	.rdata
	.align	2
$LC0:
	.ascii	"TENNIS MODE\000"
	.align	2
$LC1:
	.ascii	"SQUASH 1P\000"
	.align	2
$LC2:
	.ascii	"SQUASH 2P\000"
	.align	2
$LC3:
	.ascii	"PRESS 0\000"
	.align	2
$LC4:
	.ascii	"TO START\000"
	.align	2
$LC5:
	.ascii	"============\000"
	.align	2
$LC6:
	.ascii	" GAME OVER! \000"
	.align	2
$LC7:
	.ascii	" WINNER: P1 \000"
	.align	2
$LC8:
	.ascii	" WINNER: P2 \000"
	.align	2
$LC9:
	.ascii	"0+1:RESET\000"
	.text
	.align	2
	.globl	interrupt_handler
	.set	nomips16
	.set	nomicromips
	.ent	interrupt_handler
	.type	interrupt_handler, @function
interrupt_handler:
	.frame	$fp,64,$31		# vars= 32, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-64
	sw	$31,60($sp)
	sw	$fp,56($sp)
	move	$fp,$sp
	lui	$2,%hi(frame_counter)
	lw	$2,%lo(frame_counter)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(frame_counter)
	sw	$3,%lo(frame_counter)($2)
	lui	$2,%hi(buzzer_timer)
	lw	$2,%lo(buzzer_timer)($2)
	nop
	blez	$2,$L15
	nop

	lui	$2,%hi(buzzer_timer)
	lw	$2,%lo(buzzer_timer)($2)
	nop
	addiu	$3,$2,-1
	lui	$2,%hi(buzzer_timer)
	sw	$3,%lo(buzzer_timer)($2)
	lui	$2,%hi(buzzer_timer)
	lw	$2,%lo(buzzer_timer)($2)
	nop
	bne	$2,$0,$L15
	nop

	jal	buzzer_stop
	nop

$L15:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,1			# 0x1
	bne	$3,$2,$L16
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	move	$4,$2
	jal	draw_mode_select
	nop

	b	$L17
	nop

$L16:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L18
	nop

	jal	lcd_clear_vbuf
	nop

	sw	$0,24($fp)
	sw	$0,28($fp)
	sw	$0,32($fp)
	lui	$2,%hi(frame_counter)
	lw	$3,%lo(frame_counter)($2)
	li	$2,3			# 0x3
	divu	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$3
	li	$2,3			# 0x3
	nop
	divu	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	sw	$2,40($fp)
	lw	$2,40($fp)
	nop
	bne	$2,$0,$L19
	nop

	li	$2,255			# 0xff
	sw	$2,24($fp)
	sw	$0,28($fp)
	sw	$0,32($fp)
	b	$L20
	nop

$L19:
	lw	$3,40($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L21
	nop

	sw	$0,24($fp)
	li	$2,255			# 0xff
	sw	$2,28($fp)
	sw	$0,32($fp)
	b	$L20
	nop

$L21:
	sw	$0,24($fp)
	sw	$0,28($fp)
	li	$2,255			# 0xff
	sw	$2,32($fp)
$L20:
	lui	$2,%hi(game_mode)
	lw	$2,%lo(game_mode)($2)
	nop
	bne	$2,$0,$L22
	nop

	lw	$2,32($fp)
	nop
	sw	$2,20($sp)
	lw	$2,28($fp)
	nop
	sw	$2,16($sp)
	lw	$7,24($fp)
	lui	$2,%hi($LC0)
	addiu	$6,$2,%lo($LC0)
	li	$5,1			# 0x1
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

	b	$L23
	nop

$L22:
	lui	$2,%hi(game_mode)
	lw	$3,%lo(game_mode)($2)
	li	$2,1			# 0x1
	bne	$3,$2,$L24
	nop

	lw	$2,32($fp)
	nop
	sw	$2,20($sp)
	lw	$2,28($fp)
	nop
	sw	$2,16($sp)
	lw	$7,24($fp)
	lui	$2,%hi($LC1)
	addiu	$6,$2,%lo($LC1)
	move	$5,$0
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

	b	$L23
	nop

$L24:
	lw	$2,32($fp)
	nop
	sw	$2,20($sp)
	lw	$2,28($fp)
	nop
	sw	$2,16($sp)
	lw	$7,24($fp)
	lui	$2,%hi($LC2)
	addiu	$6,$2,%lo($LC2)
	move	$5,$0
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

$L23:
	lui	$2,%hi(frame_counter)
	lw	$3,%lo(frame_counter)($2)
	li	$2,5			# 0x5
	divu	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$2
	andi	$2,$2,0x1
	beq	$2,$0,$L25
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC3)
	addiu	$6,$2,%lo($LC3)
	move	$5,$0
	li	$4,4			# 0x4
	jal	lcd_puts_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC4)
	addiu	$6,$2,%lo($LC4)
	move	$5,$0
	li	$4,5			# 0x5
	jal	lcd_puts_color
	nop

	b	$L17
	nop

$L25:
	sw	$0,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC3)
	addiu	$6,$2,%lo($LC3)
	move	$5,$0
	li	$4,4			# 0x4
	jal	lcd_puts_color
	nop

	sw	$0,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC4)
	addiu	$6,$2,%lo($LC4)
	move	$5,$0
	li	$4,5			# 0x5
	jal	lcd_puts_color
	nop

	b	$L17
	nop

$L18:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,3			# 0x3
	bne	$3,$2,$L27
	nop

	lui	$2,%hi(game_mode)
	lw	$2,%lo(game_mode)($2)
	nop
	bne	$2,$0,$L28
	nop

	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,1			# 0x1
	bne	$3,$2,$L29
	nop

	lui	$2,%hi(p1_y)
	lw	$2,%lo(p1_y)($2)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L29
	nop

	lui	$2,%hi(p1_y)
	lw	$2,%lo(p1_y)($2)
	nop
	addiu	$3,$2,-6
	lui	$2,%hi(p1_y)
	sw	$3,%lo(p1_y)($2)
$L29:
	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,7			# 0x7
	bne	$3,$2,$L30
	nop

	lui	$2,%hi(p1_y)
	lw	$2,%lo(p1_y)($2)
	nop
	slt	$2,$2,47
	beq	$2,$0,$L30
	nop

	lui	$2,%hi(p1_y)
	lw	$2,%lo(p1_y)($2)
	nop
	addiu	$3,$2,6
	lui	$2,%hi(p1_y)
	sw	$3,%lo(p1_y)($2)
$L30:
	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,4			# 0x4
	bne	$3,$2,$L31
	nop

	lui	$2,%hi(p1_x)
	lw	$2,%lo(p1_x)($2)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L31
	nop

	lui	$2,%hi(p1_x)
	lw	$2,%lo(p1_x)($2)
	nop
	addiu	$3,$2,-6
	lui	$2,%hi(p1_x)
	sw	$3,%lo(p1_x)($2)
$L31:
	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,5			# 0x5
	bne	$3,$2,$L32
	nop

	lui	$2,%hi(p1_x)
	lw	$2,%lo(p1_x)($2)
	nop
	slt	$2,$2,40
	beq	$2,$0,$L32
	nop

	lui	$2,%hi(p1_x)
	lw	$2,%lo(p1_x)($2)
	nop
	addiu	$3,$2,6
	lui	$2,%hi(p1_x)
	sw	$3,%lo(p1_x)($2)
$L32:
	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,10			# 0xa
	bne	$3,$2,$L33
	nop

	lui	$2,%hi(p2_y)
	lw	$2,%lo(p2_y)($2)
	nop
	slt	$2,$2,6
	bne	$2,$0,$L33
	nop

	lui	$2,%hi(p2_y)
	lw	$2,%lo(p2_y)($2)
	nop
	addiu	$3,$2,-6
	lui	$2,%hi(p2_y)
	sw	$3,%lo(p2_y)($2)
$L33:
	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,12			# 0xc
	bne	$3,$2,$L34
	nop

	lui	$2,%hi(p2_y)
	lw	$2,%lo(p2_y)($2)
	nop
	slt	$2,$2,47
	beq	$2,$0,$L34
	nop

	lui	$2,%hi(p2_y)
	lw	$2,%lo(p2_y)($2)
	nop
	addiu	$3,$2,6
	lui	$2,%hi(p2_y)
	sw	$3,%lo(p2_y)($2)
$L34:
	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,6			# 0x6
	bne	$3,$2,$L35
	nop

	lui	$2,%hi(p2_x)
	lw	$2,%lo(p2_x)($2)
	nop
	slt	$2,$2,51
	bne	$2,$0,$L35
	nop

	lui	$2,%hi(p2_x)
	lw	$2,%lo(p2_x)($2)
	nop
	addiu	$3,$2,-6
	lui	$2,%hi(p2_x)
	sw	$3,%lo(p2_x)($2)
$L35:
	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,11			# 0xb
	bne	$3,$2,$L36
	nop

	lui	$2,%hi(p2_x)
	lw	$2,%lo(p2_x)($2)
	nop
	slt	$2,$2,86
	beq	$2,$0,$L36
	nop

	lui	$2,%hi(p2_x)
	lw	$2,%lo(p2_x)($2)
	nop
	addiu	$3,$2,6
	lui	$2,%hi(p2_x)
	sw	$3,%lo(p2_x)($2)
$L36:
	lui	$2,%hi(ball_x)
	lw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_vx)
	lw	$2,%lo(ball_vx)($2)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(ball_x)
	sw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_y)
	lw	$3,%lo(ball_y)($2)
	lui	$2,%hi(ball_vy)
	lw	$2,%lo(ball_vy)($2)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(ball_y)
	sw	$3,%lo(ball_y)($2)
	lui	$2,%hi(ball_y)
	lw	$2,%lo(ball_y)($2)
	nop
	slt	$2,$2,6
	beq	$2,$0,$L37
	nop

	lui	$2,%hi(ball_y)
	li	$3,5			# 0x5
	sw	$3,%lo(ball_y)($2)
	lui	$2,%hi(ball_vy)
	lw	$2,%lo(ball_vy)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(ball_vy)
	sw	$3,%lo(ball_vy)($2)
$L37:
	lui	$2,%hi(ball_y)
	lw	$2,%lo(ball_y)($2)
	nop
	slt	$2,$2,55
	bne	$2,$0,$L38
	nop

	lui	$2,%hi(ball_y)
	li	$3,55			# 0x37
	sw	$3,%lo(ball_y)($2)
	lui	$2,%hi(ball_vy)
	lw	$2,%lo(ball_vy)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(ball_vy)
	sw	$3,%lo(ball_vy)($2)
$L38:
	lui	$2,%hi(p1_x)
	lw	$2,%lo(p1_x)($2)
	nop
	addiu	$3,$2,8
	lui	$2,%hi(ball_x)
	lw	$2,%lo(ball_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L39
	nop

	lui	$2,%hi(ball_x)
	lw	$2,%lo(ball_x)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(p1_x)
	lw	$2,%lo(p1_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L39
	nop

	lui	$2,%hi(ball_y)
	lw	$2,%lo(ball_y)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(p1_y)
	lw	$2,%lo(p1_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L39
	nop

	lui	$2,%hi(p1_y)
	lw	$2,%lo(p1_y)($2)
	nop
	addiu	$3,$2,12
	lui	$2,%hi(ball_y)
	lw	$2,%lo(ball_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L39
	nop

	lui	$2,%hi(p1_x)
	lw	$2,%lo(p1_x)($2)
	nop
	addiu	$3,$2,8
	lui	$2,%hi(ball_x)
	sw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_vx)
	lw	$2,%lo(ball_vx)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(ball_vx)
	sw	$3,%lo(ball_vx)($2)
	li	$4,8			# 0x8
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,2			# 0x2
	sw	$3,%lo(buzzer_timer)($2)
$L39:
	lui	$2,%hi(ball_x)
	lw	$2,%lo(ball_x)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(p2_x)
	lw	$2,%lo(p2_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L40
	nop

	lui	$2,%hi(p2_x)
	lw	$2,%lo(p2_x)($2)
	nop
	addiu	$3,$2,8
	lui	$2,%hi(ball_x)
	lw	$2,%lo(ball_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L40
	nop

	lui	$2,%hi(ball_y)
	lw	$2,%lo(ball_y)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(p2_y)
	lw	$2,%lo(p2_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L40
	nop

	lui	$2,%hi(p2_y)
	lw	$2,%lo(p2_y)($2)
	nop
	addiu	$3,$2,12
	lui	$2,%hi(ball_y)
	lw	$2,%lo(ball_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L40
	nop

	lui	$2,%hi(p2_x)
	lw	$2,%lo(p2_x)($2)
	nop
	addiu	$3,$2,-4
	lui	$2,%hi(ball_x)
	sw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_vx)
	lw	$2,%lo(ball_vx)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(ball_vx)
	sw	$3,%lo(ball_vx)($2)
	li	$4,8			# 0x8
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,2			# 0x2
	sw	$3,%lo(buzzer_timer)($2)
$L40:
	lui	$2,%hi(ball_x)
	lw	$2,%lo(ball_x)($2)
	nop
	bgez	$2,$L41
	nop

	lui	$2,%hi(score_p2)
	lw	$2,%lo(score_p2)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(score_p2)
	sw	$3,%lo(score_p2)($2)
	lui	$2,%hi(ball_x)
	li	$3,46			# 0x2e
	sw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_y)
	li	$3,26			# 0x1a
	sw	$3,%lo(ball_y)($2)
	lui	$2,%hi(ball_vx)
	li	$3,3			# 0x3
	sw	$3,%lo(ball_vx)($2)
	lui	$2,%hi(ball_vy)
	li	$3,2			# 0x2
	sw	$3,%lo(ball_vy)($2)
	li	$4,13			# 0xd
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,5			# 0x5
	sw	$3,%lo(buzzer_timer)($2)
$L41:
	lui	$2,%hi(ball_x)
	lw	$2,%lo(ball_x)($2)
	nop
	slt	$2,$2,93
	bne	$2,$0,$L42
	nop

	lui	$2,%hi(score_p1)
	lw	$2,%lo(score_p1)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(score_p1)
	sw	$3,%lo(score_p1)($2)
	lui	$2,%hi(ball_x)
	li	$3,46			# 0x2e
	sw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_y)
	li	$3,26			# 0x1a
	sw	$3,%lo(ball_y)($2)
	lui	$2,%hi(ball_vx)
	li	$3,-3			# 0xfffffffffffffffd
	sw	$3,%lo(ball_vx)($2)
	lui	$2,%hi(ball_vy)
	li	$3,2			# 0x2
	sw	$3,%lo(ball_vy)($2)
	li	$4,13			# 0xd
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,5			# 0x5
	sw	$3,%lo(buzzer_timer)($2)
$L42:
	lui	$2,%hi(score_p1)
	lw	$2,%lo(score_p1)($2)
	nop
	slt	$2,$2,5
	beq	$2,$0,$L43
	nop

	lui	$2,%hi(score_p2)
	lw	$2,%lo(score_p2)($2)
	nop
	slt	$2,$2,5
	bne	$2,$0,$L44
	nop

$L43:
	lui	$2,%hi(game_state)
	li	$3,4			# 0x4
	sw	$3,%lo(game_state)($2)
$L44:
	jal	draw_tennis_game
	nop

	b	$L17
	nop

$L28:
	jal	squash_update
	nop

	b	$L17
	nop

$L27:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,4			# 0x4
	bne	$3,$2,$L17
	nop

	lui	$2,%hi(game_mode)
	lw	$2,%lo(game_mode)($2)
	nop
	bne	$2,$0,$L46
	nop

	jal	lcd_clear_vbuf
	nop

	lui	$2,%hi(frame_counter)
	lw	$2,%lo(frame_counter)($2)
	nop
	srl	$2,$2,1
	andi	$2,$2,0x1
	sw	$2,36($fp)
	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC5)
	addiu	$6,$2,%lo($LC5)
	move	$5,$0
	li	$4,1			# 0x1
	jal	lcd_puts_color
	nop

	lw	$2,36($fp)
	nop
	beq	$2,$0,$L47
	nop

	sw	$0,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC6)
	addiu	$6,$2,%lo($LC6)
	move	$5,$0
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

	b	$L48
	nop

$L47:
	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC6)
	addiu	$6,$2,%lo($LC6)
	move	$5,$0
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

$L48:
	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC5)
	addiu	$6,$2,%lo($LC5)
	move	$5,$0
	li	$4,3			# 0x3
	jal	lcd_puts_color
	nop

	lui	$2,%hi(score_p1)
	lw	$3,%lo(score_p1)($2)
	lui	$2,%hi(score_p2)
	lw	$2,%lo(score_p2)($2)
	nop
	slt	$2,$2,$3
	beq	$2,$0,$L49
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	lui	$2,%hi($LC7)
	addiu	$6,$2,%lo($LC7)
	move	$5,$0
	li	$4,4			# 0x4
	jal	lcd_puts_color
	nop

	b	$L50
	nop

$L49:
	sw	$0,20($sp)
	li	$2,128			# 0x80
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC8)
	addiu	$6,$2,%lo($LC8)
	move	$5,$0
	li	$4,4			# 0x4
	jal	lcd_puts_color
	nop

$L50:
	li	$2,83			# 0x53
	sb	$2,44($fp)
	li	$2,67			# 0x43
	sb	$2,45($fp)
	li	$2,79			# 0x4f
	sb	$2,46($fp)
	li	$2,82			# 0x52
	sb	$2,47($fp)
	li	$2,69			# 0x45
	sb	$2,48($fp)
	li	$2,58			# 0x3a
	sb	$2,49($fp)
	lui	$2,%hi(score_p1)
	lw	$2,%lo(score_p1)($2)
	nop
	andi	$2,$2,0x00ff
	addiu	$2,$2,48
	andi	$2,$2,0x00ff
	sll	$2,$2,24
	sra	$2,$2,24
	sb	$2,50($fp)
	li	$2,45			# 0x2d
	sb	$2,51($fp)
	lui	$2,%hi(score_p2)
	lw	$2,%lo(score_p2)($2)
	nop
	andi	$2,$2,0x00ff
	addiu	$2,$2,48
	andi	$2,$2,0x00ff
	sll	$2,$2,24
	sra	$2,$2,24
	sb	$2,52($fp)
	sb	$0,53($fp)
	addiu	$3,$fp,44
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	move	$6,$3
	li	$5,1			# 0x1
	li	$4,6			# 0x6
	jal	lcd_puts_color
	nop

	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	lui	$2,%hi($LC9)
	addiu	$6,$2,%lo($LC9)
	move	$5,$0
	li	$4,7			# 0x7
	jal	lcd_puts_color
	nop

	b	$L17
	nop

$L46:
	lui	$2,%hi(sq_score)
	lw	$2,%lo(sq_score)($2)
	nop
	move	$4,$2
	jal	draw_result_squash
	nop

$L17:
	jal	lcd_sync_vbuf
	nop

	nop
	move	$sp,$fp
	lw	$31,60($sp)
	lw	$fp,56($sp)
	addiu	$sp,$sp,64
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	interrupt_handler
	.size	interrupt_handler, .-interrupt_handler
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,64,$31		# vars= 40, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-64
	sw	$31,60($sp)
	sw	$fp,56($sp)
	move	$fp,$sp
	li	$2,65300			# 0xff14
	sw	$2,20($fp)
	lw	$2,20($fp)
	li	$3,5			# 0x5
	sw	$3,0($2)
	li	$2,65536			# 0x10000
	ori	$4,$2,0x86a0
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	li	$3,8			# 0x8
	sw	$3,0($2)
	li	$2,131072			# 0x20000
	ori	$4,$2,0x49f0
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	li	$3,10			# 0xa
	sw	$3,0($2)
	li	$2,196608			# 0x30000
	ori	$4,$2,0xd40
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	li	$3,13			# 0xd
	sw	$3,0($2)
	li	$2,262144			# 0x40000
	ori	$4,$2,0x93e0
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	nop
	sw	$0,0($2)
	li	$2,196608			# 0x30000
	ori	$4,$2,0xd40
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	li	$3,8			# 0x8
	sw	$3,0($2)
	li	$2,131072			# 0x20000
	ori	$4,$2,0x49f0
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	li	$3,10			# 0xa
	sw	$3,0($2)
	li	$2,131072			# 0x20000
	ori	$4,$2,0x49f0
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	li	$3,12			# 0xc
	sw	$3,0($2)
	li	$2,262144			# 0x40000
	ori	$4,$2,0x93e0
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	nop
	sw	$0,0($2)
	li	$2,65536			# 0x10000
	ori	$4,$2,0x86a0
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	li	$3,13			# 0xd
	sw	$3,0($2)
	li	$2,458752			# 0x70000
	ori	$4,$2,0xa120
	jal	lcd_wait
	nop

	lw	$2,20($fp)
	nop
	sw	$0,0($2)
	li	$2,65536			# 0x10000
	ori	$4,$2,0x86a0
	jal	lcd_wait
	nop

$L70:
	lui	$2,%hi(game_state)
	lw	$2,%lo(game_state)($2)
	nop
	bne	$2,$0,$L52
	nop

	jal	lcd_init
	nop

	lui	$2,%hi(game_state)
	li	$3,1			# 0x1
	sw	$3,%lo(game_state)($2)
	lui	$2,%hi(cursor)
	sw	$0,%lo(cursor)($2)
	jal	rotary_read
	nop

	move	$3,$2
	lui	$2,%hi(rotary_prev)
	sw	$3,%lo(rotary_prev)($2)
	b	$L70
	nop

$L52:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,1			# 0x1
	bne	$3,$2,$L54
	nop

	jal	btn_check_3
	nop

	sw	$2,40($fp)
	jal	btn_check_2
	nop

	sw	$2,44($fp)
	jal	btn_check_0
	nop

	sw	$2,48($fp)
	lw	$2,40($fp)
	nop
	beq	$2,$0,$L55
	nop

	lui	$2,%hi(btn3_prev)
	lw	$2,%lo(btn3_prev)($2)
	nop
	bne	$2,$0,$L55
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	blez	$2,$L55
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	addiu	$3,$2,-1
	lui	$2,%hi(cursor)
	sw	$3,%lo(cursor)($2)
	jal	led_blink
	nop

$L55:
	lw	$2,44($fp)
	nop
	beq	$2,$0,$L56
	nop

	lui	$2,%hi(btn2_prev)
	lw	$2,%lo(btn2_prev)($2)
	nop
	bne	$2,$0,$L56
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	slt	$2,$2,2
	beq	$2,$0,$L56
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(cursor)
	sw	$3,%lo(cursor)($2)
	jal	led_blink
	nop

$L56:
	jal	rotary_read
	nop

	sw	$2,52($fp)
	lui	$2,%hi(rotary_prev)
	lw	$2,%lo(rotary_prev)($2)
	lw	$3,52($fp)
	nop
	subu	$2,$3,$2
	sw	$2,16($fp)
	lw	$2,16($fp)
	nop
	slt	$2,$2,129
	bne	$2,$0,$L57
	nop

	lw	$2,16($fp)
	nop
	addiu	$2,$2,-256
	sw	$2,16($fp)
	b	$L58
	nop

$L57:
	lw	$2,16($fp)
	nop
	slt	$2,$2,-128
	beq	$2,$0,$L58
	nop

	lw	$2,16($fp)
	nop
	addiu	$2,$2,256
	sw	$2,16($fp)
$L58:
	lui	$2,%hi(rotary_threshold)
	lw	$2,%lo(rotary_threshold)($2)
	lw	$3,16($fp)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L59
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	slt	$2,$2,2
	beq	$2,$0,$L60
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(cursor)
	sw	$3,%lo(cursor)($2)
	jal	led_blink
	nop

$L60:
	lui	$2,%hi(rotary_prev)
	lw	$3,52($fp)
	nop
	sw	$3,%lo(rotary_prev)($2)
	b	$L61
	nop

$L59:
	lui	$2,%hi(rotary_threshold)
	lw	$2,%lo(rotary_threshold)($2)
	nop
	subu	$2,$0,$2
	lw	$3,16($fp)
	nop
	slt	$2,$2,$3
	bne	$2,$0,$L61
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	blez	$2,$L62
	nop

	lui	$2,%hi(cursor)
	lw	$2,%lo(cursor)($2)
	nop
	addiu	$3,$2,-1
	lui	$2,%hi(cursor)
	sw	$3,%lo(cursor)($2)
	jal	led_blink
	nop

$L62:
	lui	$2,%hi(rotary_prev)
	lw	$3,52($fp)
	nop
	sw	$3,%lo(rotary_prev)($2)
$L61:
	lw	$2,48($fp)
	nop
	beq	$2,$0,$L63
	nop

	lui	$2,%hi(btn0_prev)
	lw	$2,%lo(btn0_prev)($2)
	nop
	bne	$2,$0,$L63
	nop

	lui	$2,%hi(cursor)
	lw	$3,%lo(cursor)($2)
	lui	$2,%hi(game_mode)
	sw	$3,%lo(game_mode)($2)
	lui	$2,%hi(game_state)
	li	$3,2			# 0x2
	sw	$3,%lo(game_state)($2)
	jal	led_blink
	nop

$L63:
	lui	$2,%hi(btn0_prev)
	lw	$3,48($fp)
	nop
	sw	$3,%lo(btn0_prev)($2)
	lui	$2,%hi(btn2_prev)
	lw	$3,44($fp)
	nop
	sw	$3,%lo(btn2_prev)($2)
	lui	$2,%hi(btn3_prev)
	lw	$3,40($fp)
	nop
	sw	$3,%lo(btn3_prev)($2)
	b	$L70
	nop

$L54:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L64
	nop

	jal	btn_check_0
	nop

	sw	$2,32($fp)
	jal	btn_check_1
	nop

	sw	$2,36($fp)
	lw	$2,32($fp)
	nop
	beq	$2,$0,$L65
	nop

	lw	$2,36($fp)
	nop
	beq	$2,$0,$L65
	nop

	lui	$2,%hi(game_state)
	li	$3,1			# 0x1
	sw	$3,%lo(game_state)($2)
	lui	$2,%hi(cursor)
	sw	$0,%lo(cursor)($2)
	jal	rotary_read
	nop

	move	$3,$2
	lui	$2,%hi(rotary_prev)
	sw	$3,%lo(rotary_prev)($2)
	b	$L66
	nop

$L65:
	lw	$2,32($fp)
	nop
	beq	$2,$0,$L66
	nop

	lui	$2,%hi(btn0_prev)
	lw	$2,%lo(btn0_prev)($2)
	nop
	bne	$2,$0,$L66
	nop

	lui	$2,%hi(game_mode)
	lw	$2,%lo(game_mode)($2)
	nop
	bne	$2,$0,$L67
	nop

	lui	$2,%hi(p1_x)
	li	$3,2			# 0x2
	sw	$3,%lo(p1_x)($2)
	lui	$2,%hi(p1_y)
	li	$3,24			# 0x18
	sw	$3,%lo(p1_y)($2)
	lui	$2,%hi(p2_x)
	li	$3,86			# 0x56
	sw	$3,%lo(p2_x)($2)
	lui	$2,%hi(p2_y)
	li	$3,24			# 0x18
	sw	$3,%lo(p2_y)($2)
	lui	$2,%hi(ball_x)
	li	$3,46			# 0x2e
	sw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_y)
	li	$3,30			# 0x1e
	sw	$3,%lo(ball_y)($2)
	lui	$2,%hi(ball_vx)
	li	$3,3			# 0x3
	sw	$3,%lo(ball_vx)($2)
	lui	$2,%hi(ball_vy)
	li	$3,2			# 0x2
	sw	$3,%lo(ball_vy)($2)
	lui	$2,%hi(score_p1)
	sw	$0,%lo(score_p1)($2)
	lui	$2,%hi(score_p2)
	sw	$0,%lo(score_p2)($2)
	b	$L68
	nop

$L67:
	lui	$2,%hi(sq_p1_x)
	li	$3,2			# 0x2
	sw	$3,%lo(sq_p1_x)($2)
	lui	$2,%hi(sq_p1_y)
	li	$3,16			# 0x10
	sw	$3,%lo(sq_p1_y)($2)
	lui	$2,%hi(sq_p2_x)
	li	$3,2			# 0x2
	sw	$3,%lo(sq_p2_x)($2)
	lui	$2,%hi(sq_p2_y)
	li	$3,36			# 0x24
	sw	$3,%lo(sq_p2_y)($2)
	lui	$2,%hi(sq_ball_x)
	li	$3,20			# 0x14
	sw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_y)
	li	$3,26			# 0x1a
	sw	$3,%lo(sq_ball_y)($2)
	lui	$2,%hi(sq_ball_vx)
	li	$3,3			# 0x3
	sw	$3,%lo(sq_ball_vx)($2)
	lui	$2,%hi(sq_ball_vy)
	li	$3,2			# 0x2
	sw	$3,%lo(sq_ball_vy)($2)
	lui	$2,%hi(sq_score)
	sw	$0,%lo(sq_score)($2)
	lui	$2,%hi(sq_lives)
	li	$3,3			# 0x3
	sw	$3,%lo(sq_lives)($2)
	lui	$2,%hi(sq_turn)
	sw	$0,%lo(sq_turn)($2)
	lui	$2,%hi(sq_rally)
	sw	$0,%lo(sq_rally)($2)
$L68:
	lui	$2,%hi(game_state)
	li	$3,3			# 0x3
	sw	$3,%lo(game_state)($2)
	jal	led_blink
	nop

$L66:
	lui	$2,%hi(btn0_prev)
	lw	$3,32($fp)
	nop
	sw	$3,%lo(btn0_prev)($2)
	b	$L70
	nop

$L64:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,3			# 0x3
	bne	$3,$2,$L69
	nop

	lui	$2,%hi(input_p2_dir)
	addiu	$5,$2,%lo(input_p2_dir)
	lui	$2,%hi(input_p1_dir)
	addiu	$4,$2,%lo(input_p1_dir)
	jal	kypd_scan_both
	nop

	jal	btn_check_0
	nop

	move	$3,$2
	lui	$2,%hi(input_btn0)
	sw	$3,%lo(input_btn0)($2)
	jal	btn_check_1
	nop

	move	$3,$2
	lui	$2,%hi(input_btn1)
	sw	$3,%lo(input_btn1)($2)
	b	$L70
	nop

$L69:
	lui	$2,%hi(game_state)
	lw	$3,%lo(game_state)($2)
	li	$2,4			# 0x4
	bne	$3,$2,$L70
	nop

	jal	btn_check_0
	nop

	sw	$2,24($fp)
	jal	btn_check_1
	nop

	sw	$2,28($fp)
	lw	$2,24($fp)
	nop
	beq	$2,$0,$L70
	nop

	lw	$2,28($fp)
	nop
	beq	$2,$0,$L70
	nop

	lui	$2,%hi(game_state)
	li	$3,1			# 0x1
	sw	$3,%lo(game_state)($2)
	lui	$2,%hi(cursor)
	sw	$0,%lo(cursor)($2)
	jal	rotary_read
	nop

	move	$3,$2
	lui	$2,%hi(rotary_prev)
	sw	$3,%lo(rotary_prev)($2)
	b	$L70
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.rdata
	.align	2
$LC10:
	.ascii	"== SELECT ==\000"
	.align	2
$LC11:
	.ascii	"> TENNIS   <\000"
	.align	2
$LC12:
	.ascii	"  TENNIS    \000"
	.align	2
$LC13:
	.ascii	"> SQUASH 1P<\000"
	.align	2
$LC14:
	.ascii	"  SQUASH 1P \000"
	.align	2
$LC15:
	.ascii	"> SQUASH 2P<\000"
	.align	2
$LC16:
	.ascii	"  SQUASH 2P \000"
	.align	2
$LC17:
	.ascii	"ROTARY/3/2\000"
	.align	2
$LC18:
	.ascii	"0:DECIDE\000"
	.text
	.align	2
	.globl	draw_mode_select
	.set	nomips16
	.set	nomicromips
	.ent	draw_mode_select
	.type	draw_mode_select, @function
draw_mode_select:
	.frame	$fp,64,$31		# vars= 32, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-64
	sw	$31,60($sp)
	sw	$fp,56($sp)
	move	$fp,$sp
	sw	$4,64($fp)
	jal	lcd_clear_vbuf
	nop

	lui	$2,%hi(frame_counter)
	lw	$2,%lo(frame_counter)($2)
	nop
	srl	$3,$2,1
	li	$2,6			# 0x6
	divu	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	sw	$2,36($fp)
	lw	$2,36($fp)
	nop
	sltu	$2,$2,6
	beq	$2,$0,$L72
	nop

	lw	$2,36($fp)
	nop
	sll	$3,$2,2
	lui	$2,%hi($L74)
	addiu	$2,$2,%lo($L74)
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	jr	$2
	nop

	.rdata
	.align	2
	.align	2
$L74:
	.word	$L73
	.word	$L75
	.word	$L76
	.word	$L77
	.word	$L78
	.word	$L79
	.text
$L73:
	li	$2,255			# 0xff
	sw	$2,24($fp)
	sw	$0,28($fp)
	sw	$0,32($fp)
	b	$L80
	nop

$L75:
	li	$2,255			# 0xff
	sw	$2,24($fp)
	li	$2,255			# 0xff
	sw	$2,28($fp)
	sw	$0,32($fp)
	b	$L80
	nop

$L76:
	sw	$0,24($fp)
	li	$2,255			# 0xff
	sw	$2,28($fp)
	sw	$0,32($fp)
	b	$L80
	nop

$L77:
	sw	$0,24($fp)
	li	$2,255			# 0xff
	sw	$2,28($fp)
	li	$2,255			# 0xff
	sw	$2,32($fp)
	b	$L80
	nop

$L78:
	sw	$0,24($fp)
	sw	$0,28($fp)
	li	$2,255			# 0xff
	sw	$2,32($fp)
	b	$L80
	nop

$L79:
	li	$2,255			# 0xff
	sw	$2,24($fp)
	sw	$0,28($fp)
	li	$2,255			# 0xff
	sw	$2,32($fp)
	b	$L80
	nop

$L72:
	li	$2,255			# 0xff
	sw	$2,24($fp)
	li	$2,255			# 0xff
	sw	$2,28($fp)
	li	$2,255			# 0xff
	sw	$2,32($fp)
	nop
$L80:
	lw	$2,32($fp)
	nop
	sw	$2,20($sp)
	lw	$2,28($fp)
	nop
	sw	$2,16($sp)
	lw	$7,24($fp)
	lui	$2,%hi($LC10)
	addiu	$6,$2,%lo($LC10)
	move	$5,$0
	move	$4,$0
	jal	lcd_puts_color
	nop

	lui	$2,%hi(frame_counter)
	lw	$3,%lo(frame_counter)($2)
	li	$2,3			# 0x3
	divu	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$2
	andi	$2,$2,0x1
	sw	$2,40($fp)
	li	$2,255			# 0xff
	sw	$2,44($fp)
	lw	$2,40($fp)
	nop
	beq	$2,$0,$L81
	nop

	li	$2,255			# 0xff
	b	$L82
	nop

$L81:
	move	$2,$0
$L82:
	sw	$2,48($fp)
	sw	$0,52($fp)
	lw	$2,64($fp)
	nop
	bne	$2,$0,$L83
	nop

	lw	$2,52($fp)
	nop
	sw	$2,20($sp)
	lw	$2,48($fp)
	nop
	sw	$2,16($sp)
	lw	$7,44($fp)
	lui	$2,%hi($LC11)
	addiu	$6,$2,%lo($LC11)
	move	$5,$0
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

	b	$L84
	nop

$L83:
	li	$2,255			# 0xff
	sw	$2,20($sp)
	sw	$0,16($sp)
	move	$7,$0
	lui	$2,%hi($LC12)
	addiu	$6,$2,%lo($LC12)
	move	$5,$0
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

$L84:
	lw	$3,64($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L85
	nop

	lw	$2,52($fp)
	nop
	sw	$2,20($sp)
	lw	$2,48($fp)
	nop
	sw	$2,16($sp)
	lw	$7,44($fp)
	lui	$2,%hi($LC13)
	addiu	$6,$2,%lo($LC13)
	move	$5,$0
	li	$4,3			# 0x3
	jal	lcd_puts_color
	nop

	b	$L86
	nop

$L85:
	li	$2,255			# 0xff
	sw	$2,20($sp)
	sw	$0,16($sp)
	move	$7,$0
	lui	$2,%hi($LC14)
	addiu	$6,$2,%lo($LC14)
	move	$5,$0
	li	$4,3			# 0x3
	jal	lcd_puts_color
	nop

$L86:
	lw	$3,64($fp)
	li	$2,2			# 0x2
	bne	$3,$2,$L87
	nop

	lw	$2,52($fp)
	nop
	sw	$2,20($sp)
	lw	$2,48($fp)
	nop
	sw	$2,16($sp)
	lw	$7,44($fp)
	lui	$2,%hi($LC15)
	addiu	$6,$2,%lo($LC15)
	move	$5,$0
	li	$4,4			# 0x4
	jal	lcd_puts_color
	nop

	b	$L88
	nop

$L87:
	li	$2,255			# 0xff
	sw	$2,20($sp)
	sw	$0,16($sp)
	move	$7,$0
	lui	$2,%hi($LC16)
	addiu	$6,$2,%lo($LC16)
	move	$5,$0
	li	$4,4			# 0x4
	jal	lcd_puts_color
	nop

$L88:
	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	lui	$2,%hi($LC17)
	addiu	$6,$2,%lo($LC17)
	move	$5,$0
	li	$4,6			# 0x6
	jal	lcd_puts_color
	nop

	li	$2,255			# 0xff
	sw	$2,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC18)
	addiu	$6,$2,%lo($LC18)
	move	$5,$0
	li	$4,7			# 0x7
	jal	lcd_puts_color
	nop

	nop
	move	$sp,$fp
	lw	$31,60($sp)
	lw	$fp,56($sp)
	addiu	$sp,$sp,64
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_mode_select
	.size	draw_mode_select, .-draw_mode_select
	.align	2
	.globl	btn_check_0
	.set	nomips16
	.set	nomicromips
	.ent	btn_check_0
	.type	btn_check_0, @function
btn_check_0:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	li	$2,65284			# 0xff04
	sw	$2,0($fp)
	lw	$2,0($fp)
	nop
	lw	$2,0($2)
	nop
	andi	$2,$2,0x10
	sltu	$2,$0,$2
	andi	$2,$2,0x00ff
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	btn_check_0
	.size	btn_check_0, .-btn_check_0
	.align	2
	.globl	btn_check_1
	.set	nomips16
	.set	nomicromips
	.ent	btn_check_1
	.type	btn_check_1, @function
btn_check_1:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	li	$2,65284			# 0xff04
	sw	$2,0($fp)
	lw	$2,0($fp)
	nop
	lw	$2,0($2)
	nop
	andi	$2,$2,0x20
	sltu	$2,$0,$2
	andi	$2,$2,0x00ff
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	btn_check_1
	.size	btn_check_1, .-btn_check_1
	.align	2
	.globl	btn_check_2
	.set	nomips16
	.set	nomicromips
	.ent	btn_check_2
	.type	btn_check_2, @function
btn_check_2:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	li	$2,65284			# 0xff04
	sw	$2,0($fp)
	lw	$2,0($fp)
	nop
	lw	$2,0($2)
	nop
	andi	$2,$2,0x40
	sltu	$2,$0,$2
	andi	$2,$2,0x00ff
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	btn_check_2
	.size	btn_check_2, .-btn_check_2
	.align	2
	.globl	btn_check_3
	.set	nomips16
	.set	nomicromips
	.ent	btn_check_3
	.type	btn_check_3, @function
btn_check_3:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	li	$2,65284			# 0xff04
	sw	$2,0($fp)
	lw	$2,0($fp)
	nop
	lw	$2,0($2)
	nop
	andi	$2,$2,0x80
	sltu	$2,$0,$2
	andi	$2,$2,0x00ff
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	btn_check_3
	.size	btn_check_3, .-btn_check_3
	.align	2
	.globl	rotary_read
	.set	nomips16
	.set	nomicromips
	.ent	rotary_read
	.type	rotary_read, @function
rotary_read:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	li	$2,65296			# 0xff10
	sw	$2,0($fp)
	lw	$2,0($fp)
	nop
	lw	$2,0($2)
	nop
	sw	$2,4($fp)
	lw	$2,4($fp)
	nop
	sra	$2,$2,2
	andi	$2,$2,0xff
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	rotary_read
	.size	rotary_read, .-rotary_read
	.align	2
	.globl	tiny_wait
	.set	nomips16
	.set	nomicromips
	.ent	tiny_wait
	.type	tiny_wait, @function
tiny_wait:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$0,0($fp)
	b	$L100
	nop

$L101:
	lw	$2,0($fp)
	nop
	addiu	$2,$2,1
	sw	$2,0($fp)
$L100:
	lw	$2,0($fp)
	lw	$3,16($fp)
	nop
	slt	$2,$2,$3
	bne	$2,$0,$L101
	nop

	nop
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	tiny_wait
	.size	tiny_wait, .-tiny_wait
	.align	2
	.globl	kypd_scan
	.set	nomips16
	.set	nomicromips
	.ent	kypd_scan
	.type	kypd_scan, @function
kypd_scan:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	li	$2,65304			# 0xff18
	sw	$2,16($fp)
	lw	$2,16($fp)
	li	$3,7			# 0x7
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lb	$2,20($fp)
	nop
	bltz	$2,$L103
	nop

	li	$2,1			# 0x1
	b	$L104
	nop

$L103:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L105
	nop

	li	$2,4			# 0x4
	b	$L104
	nop

$L105:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x20
	bne	$2,$0,$L106
	nop

	li	$2,7			# 0x7
	b	$L104
	nop

$L106:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x10
	bne	$2,$0,$L107
	nop

	move	$2,$0
	b	$L104
	nop

$L107:
	lw	$2,16($fp)
	li	$3,11			# 0xb
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lb	$2,20($fp)
	nop
	bltz	$2,$L108
	nop

	li	$2,2			# 0x2
	b	$L104
	nop

$L108:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L109
	nop

	li	$2,5			# 0x5
	b	$L104
	nop

$L109:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x20
	bne	$2,$0,$L110
	nop

	li	$2,8			# 0x8
	b	$L104
	nop

$L110:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x10
	bne	$2,$0,$L111
	nop

	li	$2,15			# 0xf
	b	$L104
	nop

$L111:
	lw	$2,16($fp)
	li	$3,13			# 0xd
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lb	$2,20($fp)
	nop
	bltz	$2,$L112
	nop

	li	$2,3			# 0x3
	b	$L104
	nop

$L112:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L113
	nop

	li	$2,6			# 0x6
	b	$L104
	nop

$L113:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x20
	bne	$2,$0,$L114
	nop

	li	$2,9			# 0x9
	b	$L104
	nop

$L114:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x10
	bne	$2,$0,$L115
	nop

	li	$2,14			# 0xe
	b	$L104
	nop

$L115:
	lw	$2,16($fp)
	li	$3,14			# 0xe
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lb	$2,20($fp)
	nop
	bltz	$2,$L116
	nop

	li	$2,10			# 0xa
	b	$L104
	nop

$L116:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L117
	nop

	li	$2,11			# 0xb
	b	$L104
	nop

$L117:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x20
	bne	$2,$0,$L118
	nop

	li	$2,12			# 0xc
	b	$L104
	nop

$L118:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x10
	bne	$2,$0,$L119
	nop

	li	$2,13			# 0xd
	b	$L104
	nop

$L119:
	li	$2,-1			# 0xffffffffffffffff
$L104:
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	kypd_scan
	.size	kypd_scan, .-kypd_scan
	.align	2
	.globl	kypd_scan_both
	.set	nomips16
	.set	nomicromips
	.ent	kypd_scan_both
	.type	kypd_scan_both, @function
kypd_scan_both:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$5,36($fp)
	li	$2,65304			# 0xff18
	sw	$2,16($fp)
	lw	$2,32($fp)
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,0($2)
	lw	$2,36($fp)
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,0($2)
	lw	$2,16($fp)
	li	$3,7			# 0x7
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lb	$2,20($fp)
	nop
	bltz	$2,$L121
	nop

	lw	$2,32($fp)
	li	$3,1			# 0x1
	sw	$3,0($2)
$L121:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L122
	nop

	lw	$2,32($fp)
	li	$3,4			# 0x4
	sw	$3,0($2)
$L122:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x20
	bne	$2,$0,$L123
	nop

	lw	$2,32($fp)
	li	$3,7			# 0x7
	sw	$3,0($2)
$L123:
	lw	$2,16($fp)
	li	$3,11			# 0xb
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L124
	nop

	lw	$2,32($fp)
	li	$3,5			# 0x5
	sw	$3,0($2)
$L124:
	lw	$2,16($fp)
	li	$3,13			# 0xd
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L125
	nop

	lw	$2,36($fp)
	li	$3,6			# 0x6
	sw	$3,0($2)
$L125:
	lw	$2,16($fp)
	li	$3,14			# 0xe
	sw	$3,0($2)
	li	$4,300			# 0x12c
	jal	tiny_wait
	nop

	lw	$2,16($fp)
	nop
	lw	$2,0($2)
	nop
	sb	$2,20($fp)
	lb	$2,20($fp)
	nop
	bltz	$2,$L126
	nop

	lw	$2,36($fp)
	li	$3,10			# 0xa
	sw	$3,0($2)
$L126:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x40
	bne	$2,$0,$L127
	nop

	lw	$2,36($fp)
	li	$3,11			# 0xb
	sw	$3,0($2)
$L127:
	lbu	$2,20($fp)
	nop
	andi	$2,$2,0x20
	bne	$2,$0,$L128
	nop

	lw	$2,36($fp)
	li	$3,12			# 0xc
	sw	$3,0($2)
$L128:
	lw	$2,16($fp)
	li	$3,15			# 0xf
	sw	$3,0($2)
	li	$4,100			# 0x64
	jal	tiny_wait
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	kypd_scan_both
	.size	kypd_scan_both, .-kypd_scan_both
	.align	2
	.globl	led_set
	.set	nomips16
	.set	nomicromips
	.ent	led_set
	.type	led_set, @function
led_set:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	li	$2,65288			# 0xff08
	sw	$2,0($fp)
	lw	$2,0($fp)
	lw	$3,16($fp)
	nop
	sw	$3,0($2)
	nop
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	led_set
	.size	led_set, .-led_set
	.align	2
	.globl	led_blink
	.set	nomips16
	.set	nomicromips
	.ent	led_blink
	.type	led_blink, @function
led_blink:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	li	$4,15			# 0xf
	jal	led_set
	nop

	sw	$0,16($fp)
	b	$L131
	nop

$L132:
	lw	$2,16($fp)
	nop
	addiu	$2,$2,1
	sw	$2,16($fp)
$L131:
	lw	$3,16($fp)
	li	$2,65536			# 0x10000
	ori	$2,$2,0x86a0
	slt	$2,$3,$2
	bne	$2,$0,$L132
	nop

	move	$4,$0
	jal	led_set
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	led_blink
	.size	led_blink, .-led_blink
	.align	2
	.globl	buzzer_play
	.set	nomips16
	.set	nomicromips
	.ent	buzzer_play
	.type	buzzer_play, @function
buzzer_play:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	li	$2,65300			# 0xff14
	sw	$2,0($fp)
	lw	$2,0($fp)
	lw	$3,16($fp)
	nop
	sw	$3,0($2)
	nop
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	buzzer_play
	.size	buzzer_play, .-buzzer_play
	.align	2
	.globl	buzzer_stop
	.set	nomips16
	.set	nomicromips
	.ent	buzzer_stop
	.type	buzzer_stop, @function
buzzer_stop:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	li	$2,65300			# 0xff14
	sw	$2,0($fp)
	lw	$2,0($fp)
	nop
	sw	$0,0($2)
	nop
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	buzzer_stop
	.size	buzzer_stop, .-buzzer_stop

	.comm	lcd_vbuf,6144,4
	.align	2
	.globl	lcd_wait
	.set	nomips16
	.set	nomicromips
	.ent	lcd_wait
	.type	lcd_wait, @function
lcd_wait:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$0,0($fp)
	b	$L136
	nop

$L137:
	lw	$2,0($fp)
	nop
	addiu	$2,$2,1
	sw	$2,0($fp)
$L136:
	lw	$3,0($fp)
	lw	$2,16($fp)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L137
	nop

	nop
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_wait
	.size	lcd_wait, .-lcd_wait
	.align	2
	.globl	lcd_cmd
	.set	nomips16
	.set	nomicromips
	.ent	lcd_cmd
	.type	lcd_cmd, @function
lcd_cmd:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	move	$2,$4
	sb	$2,32($fp)
	li	$2,65292			# 0xff0c
	sw	$2,16($fp)
	lbu	$3,32($fp)
	lw	$2,16($fp)
	nop
	sw	$3,0($2)
	li	$4,1000			# 0x3e8
	jal	lcd_wait
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_cmd
	.size	lcd_cmd, .-lcd_cmd
	.align	2
	.globl	lcd_data
	.set	nomips16
	.set	nomicromips
	.ent	lcd_data
	.type	lcd_data, @function
lcd_data:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	move	$2,$4
	sb	$2,32($fp)
	li	$2,65292			# 0xff0c
	sw	$2,16($fp)
	lbu	$2,32($fp)
	nop
	ori	$3,$2,0x100
	lw	$2,16($fp)
	nop
	sw	$3,0($2)
	li	$4,200			# 0xc8
	jal	lcd_wait
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_data
	.size	lcd_data, .-lcd_data
	.align	2
	.globl	lcd_pwr_on
	.set	nomips16
	.set	nomicromips
	.ent	lcd_pwr_on
	.type	lcd_pwr_on, @function
lcd_pwr_on:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	li	$2,65292			# 0xff0c
	sw	$2,16($fp)
	lw	$2,16($fp)
	li	$3,512			# 0x200
	sw	$3,0($2)
	li	$2,655360			# 0xa0000
	ori	$4,$2,0xae60
	jal	lcd_wait
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_pwr_on
	.size	lcd_pwr_on, .-lcd_pwr_on
	.align	2
	.globl	lcd_init
	.set	nomips16
	.set	nomicromips
	.ent	lcd_init
	.type	lcd_init, @function
lcd_init:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$fp,16($sp)
	move	$fp,$sp
	jal	lcd_pwr_on
	nop

	li	$4,160			# 0xa0
	jal	lcd_cmd
	nop

	li	$4,32			# 0x20
	jal	lcd_cmd
	nop

	li	$4,21			# 0x15
	jal	lcd_cmd
	nop

	move	$4,$0
	jal	lcd_cmd
	nop

	li	$4,95			# 0x5f
	jal	lcd_cmd
	nop

	li	$4,117			# 0x75
	jal	lcd_cmd
	nop

	move	$4,$0
	jal	lcd_cmd
	nop

	li	$4,63			# 0x3f
	jal	lcd_cmd
	nop

	li	$4,175			# 0xaf
	jal	lcd_cmd
	nop

	nop
	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_init
	.size	lcd_init, .-lcd_init
	.align	2
	.globl	lcd_set_vbuf_pixel
	.set	nomips16
	.set	nomicromips
	.ent	lcd_set_vbuf_pixel
	.type	lcd_set_vbuf_pixel, @function
lcd_set_vbuf_pixel:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-8
	sw	$fp,4($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	sw	$5,12($fp)
	sw	$6,16($fp)
	sw	$7,20($fp)
	lw	$2,16($fp)
	nop
	sra	$2,$2,5
	sw	$2,16($fp)
	lw	$2,20($fp)
	nop
	sra	$2,$2,5
	sw	$2,20($fp)
	lw	$2,24($fp)
	nop
	sra	$2,$2,6
	sw	$2,24($fp)
	lw	$2,16($fp)
	nop
	sll	$2,$2,5
	sll	$3,$2,24
	sra	$3,$3,24
	lw	$2,20($fp)
	nop
	sll	$2,$2,2
	sll	$2,$2,24
	sra	$2,$2,24
	or	$2,$3,$2
	sll	$3,$2,24
	sra	$3,$3,24
	lw	$2,24($fp)
	nop
	sll	$2,$2,24
	sra	$2,$2,24
	or	$2,$3,$2
	sll	$2,$2,24
	sra	$2,$2,24
	andi	$4,$2,0x00ff
	lui	$5,%hi(lcd_vbuf)
	lw	$3,8($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,5
	addiu	$3,$5,%lo(lcd_vbuf)
	addu	$3,$2,$3
	lw	$2,12($fp)
	nop
	addu	$2,$3,$2
	sb	$4,0($2)
	nop
	move	$sp,$fp
	lw	$fp,4($sp)
	addiu	$sp,$sp,8
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_set_vbuf_pixel
	.size	lcd_set_vbuf_pixel, .-lcd_set_vbuf_pixel
	.align	2
	.globl	lcd_clear_vbuf
	.set	nomips16
	.set	nomicromips
	.ent	lcd_clear_vbuf
	.type	lcd_clear_vbuf, @function
lcd_clear_vbuf:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$0,0($fp)
	b	$L144
	nop

$L147:
	sw	$0,4($fp)
	b	$L145
	nop

$L146:
	lui	$4,%hi(lcd_vbuf)
	lw	$3,0($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,5
	addiu	$3,$4,%lo(lcd_vbuf)
	addu	$3,$2,$3
	lw	$2,4($fp)
	nop
	addu	$2,$3,$2
	sb	$0,0($2)
	lw	$2,4($fp)
	nop
	addiu	$2,$2,1
	sw	$2,4($fp)
$L145:
	lw	$2,4($fp)
	nop
	slt	$2,$2,96
	bne	$2,$0,$L146
	nop

	lw	$2,0($fp)
	nop
	addiu	$2,$2,1
	sw	$2,0($fp)
$L144:
	lw	$2,0($fp)
	nop
	slt	$2,$2,64
	bne	$2,$0,$L147
	nop

	nop
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_clear_vbuf
	.size	lcd_clear_vbuf, .-lcd_clear_vbuf
	.align	2
	.globl	lcd_sync_vbuf
	.set	nomips16
	.set	nomicromips
	.ent	lcd_sync_vbuf
	.type	lcd_sync_vbuf, @function
lcd_sync_vbuf:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$0,16($fp)
	b	$L149
	nop

$L152:
	sw	$0,20($fp)
	b	$L150
	nop

$L151:
	lui	$4,%hi(lcd_vbuf)
	lw	$3,16($fp)
	nop
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,5
	addiu	$3,$4,%lo(lcd_vbuf)
	addu	$3,$2,$3
	lw	$2,20($fp)
	nop
	addu	$2,$3,$2
	lbu	$2,0($2)
	nop
	move	$4,$2
	jal	lcd_data
	nop

	lw	$2,20($fp)
	nop
	addiu	$2,$2,1
	sw	$2,20($fp)
$L150:
	lw	$2,20($fp)
	nop
	slt	$2,$2,96
	bne	$2,$0,$L151
	nop

	lw	$2,16($fp)
	nop
	addiu	$2,$2,1
	sw	$2,16($fp)
$L149:
	lw	$2,16($fp)
	nop
	slt	$2,$2,64
	bne	$2,$0,$L152
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_sync_vbuf
	.size	lcd_sync_vbuf, .-lcd_sync_vbuf
	.align	2
	.globl	lcd_putc
	.set	nomips16
	.set	nomicromips
	.ent	lcd_putc
	.type	lcd_putc, @function
lcd_putc:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	sw	$5,44($fp)
	sw	$6,48($fp)
	sw	$0,24($fp)
	b	$L154
	nop

$L158:
	sw	$0,28($fp)
	b	$L155
	nop

$L157:
	lw	$2,48($fp)
	nop
	addiu	$2,$2,-32
	sll	$3,$2,3
	lw	$2,28($fp)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(font8x8)
	addiu	$2,$2,%lo(font8x8)
	addu	$2,$3,$2
	lbu	$2,0($2)
	nop
	move	$3,$2
	lw	$2,24($fp)
	nop
	sra	$2,$3,$2
	andi	$2,$2,0x1
	beq	$2,$0,$L156
	nop

	lw	$2,40($fp)
	nop
	sll	$3,$2,3
	lw	$2,24($fp)
	nop
	addu	$4,$3,$2
	lw	$2,44($fp)
	nop
	sll	$3,$2,3
	lw	$2,28($fp)
	nop
	addu	$2,$3,$2
	sw	$0,16($sp)
	li	$7,255			# 0xff
	move	$6,$0
	move	$5,$2
	jal	lcd_set_vbuf_pixel
	nop

$L156:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L155:
	lw	$2,28($fp)
	nop
	slt	$2,$2,8
	bne	$2,$0,$L157
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L154:
	lw	$2,24($fp)
	nop
	slt	$2,$2,8
	bne	$2,$0,$L158
	nop

	nop
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_putc
	.size	lcd_putc, .-lcd_putc
	.align	2
	.globl	lcd_puts
	.set	nomips16
	.set	nomicromips
	.ent	lcd_puts
	.type	lcd_puts, @function
lcd_puts:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$5,36($fp)
	sw	$6,40($fp)
	sw	$0,16($fp)
	b	$L160
	nop

$L163:
	lw	$2,16($fp)
	lw	$3,40($fp)
	nop
	addu	$2,$3,$2
	lb	$2,0($2)
	nop
	slt	$2,$2,32
	bne	$2,$0,$L161
	nop

	lw	$3,36($fp)
	lw	$2,16($fp)
	nop
	addu	$4,$3,$2
	lw	$2,16($fp)
	lw	$3,40($fp)
	nop
	addu	$2,$3,$2
	lb	$2,0($2)
	nop
	move	$6,$2
	move	$5,$4
	lw	$4,32($fp)
	jal	lcd_putc
	nop

$L161:
	lw	$2,16($fp)
	nop
	addiu	$2,$2,1
	sw	$2,16($fp)
$L160:
	lw	$2,16($fp)
	lw	$3,40($fp)
	nop
	addu	$2,$3,$2
	lb	$2,0($2)
	nop
	beq	$2,$0,$L164
	nop

	lw	$3,36($fp)
	lw	$2,16($fp)
	nop
	addu	$2,$3,$2
	slt	$2,$2,12
	bne	$2,$0,$L163
	nop

$L164:
	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_puts
	.size	lcd_puts, .-lcd_puts
	.align	2
	.globl	lcd_putc_color
	.set	nomips16
	.set	nomicromips
	.ent	lcd_putc_color
	.type	lcd_putc_color, @function
lcd_putc_color:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	sw	$5,44($fp)
	sw	$6,48($fp)
	sw	$7,52($fp)
	sw	$0,24($fp)
	b	$L166
	nop

$L170:
	sw	$0,28($fp)
	b	$L167
	nop

$L169:
	lw	$2,48($fp)
	nop
	addiu	$2,$2,-32
	sll	$3,$2,3
	lw	$2,28($fp)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(font8x8)
	addiu	$2,$2,%lo(font8x8)
	addu	$2,$3,$2
	lbu	$2,0($2)
	nop
	move	$3,$2
	lw	$2,24($fp)
	nop
	sra	$2,$3,$2
	andi	$2,$2,0x1
	beq	$2,$0,$L168
	nop

	lw	$2,40($fp)
	nop
	sll	$3,$2,3
	lw	$2,24($fp)
	nop
	addu	$4,$3,$2
	lw	$2,44($fp)
	nop
	sll	$3,$2,3
	lw	$2,28($fp)
	nop
	addu	$3,$3,$2
	lw	$2,60($fp)
	nop
	sw	$2,16($sp)
	lw	$7,56($fp)
	lw	$6,52($fp)
	move	$5,$3
	jal	lcd_set_vbuf_pixel
	nop

$L168:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L167:
	lw	$2,28($fp)
	nop
	slt	$2,$2,8
	bne	$2,$0,$L169
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L166:
	lw	$2,24($fp)
	nop
	slt	$2,$2,8
	bne	$2,$0,$L170
	nop

	nop
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_putc_color
	.size	lcd_putc_color, .-lcd_putc_color
	.align	2
	.globl	lcd_puts_color
	.set	nomips16
	.set	nomicromips
	.ent	lcd_puts_color
	.type	lcd_puts_color, @function
lcd_puts_color:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	sw	$5,44($fp)
	sw	$6,48($fp)
	sw	$7,52($fp)
	sw	$0,24($fp)
	b	$L172
	nop

$L175:
	lw	$2,24($fp)
	lw	$3,48($fp)
	nop
	addu	$2,$3,$2
	lb	$2,0($2)
	nop
	slt	$2,$2,32
	bne	$2,$0,$L173
	nop

	lw	$3,44($fp)
	lw	$2,24($fp)
	nop
	addu	$4,$3,$2
	lw	$2,24($fp)
	lw	$3,48($fp)
	nop
	addu	$2,$3,$2
	lb	$2,0($2)
	nop
	move	$3,$2
	lw	$2,60($fp)
	nop
	sw	$2,20($sp)
	lw	$2,56($fp)
	nop
	sw	$2,16($sp)
	lw	$7,52($fp)
	move	$6,$3
	move	$5,$4
	lw	$4,40($fp)
	jal	lcd_putc_color
	nop

$L173:
	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L172:
	lw	$2,24($fp)
	lw	$3,48($fp)
	nop
	addu	$2,$3,$2
	lb	$2,0($2)
	nop
	beq	$2,$0,$L176
	nop

	lw	$3,44($fp)
	lw	$2,24($fp)
	nop
	addu	$2,$3,$2
	slt	$2,$2,12
	bne	$2,$0,$L175
	nop

$L176:
	nop
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	lcd_puts_color
	.size	lcd_puts_color, .-lcd_puts_color
	.align	2
	.globl	draw_court_lines
	.set	nomips16
	.set	nomicromips
	.ent	draw_court_lines
	.type	draw_court_lines, @function
draw_court_lines:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	li	$2,4			# 0x4
	sw	$2,24($fp)
	b	$L178
	nop

$L179:
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	lw	$5,24($fp)
	li	$4,4			# 0x4
	jal	lcd_set_vbuf_pixel
	nop

	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	lw	$5,24($fp)
	li	$4,59			# 0x3b
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L178:
	lw	$2,24($fp)
	nop
	slt	$2,$2,92
	bne	$2,$0,$L179
	nop

	li	$2,4			# 0x4
	sw	$2,28($fp)
	b	$L180
	nop

$L181:
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	li	$5,4			# 0x4
	lw	$4,28($fp)
	jal	lcd_set_vbuf_pixel
	nop

	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	li	$5,91			# 0x5b
	lw	$4,28($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L180:
	lw	$2,28($fp)
	nop
	slt	$2,$2,60
	bne	$2,$0,$L181
	nop

	li	$2,16			# 0x10
	sw	$2,32($fp)
	b	$L182
	nop

$L183:
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	li	$5,24			# 0x18
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	li	$5,71			# 0x47
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,32($fp)
	nop
	addiu	$2,$2,1
	sw	$2,32($fp)
$L182:
	lw	$2,32($fp)
	nop
	slt	$2,$2,48
	bne	$2,$0,$L183
	nop

	li	$2,24			# 0x18
	sw	$2,36($fp)
	b	$L184
	nop

$L185:
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	lw	$5,36($fp)
	li	$4,32			# 0x20
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,36($fp)
	nop
	addiu	$2,$2,2
	sw	$2,36($fp)
$L184:
	lw	$2,36($fp)
	nop
	slt	$2,$2,72
	bne	$2,$0,$L185
	nop

	li	$2,2			# 0x2
	sw	$2,40($fp)
	b	$L186
	nop

$L187:
	li	$2,180			# 0xb4
	sw	$2,16($sp)
	li	$7,180			# 0xb4
	li	$6,180			# 0xb4
	li	$5,48			# 0x30
	lw	$4,40($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,40($fp)
	nop
	addiu	$2,$2,2
	sw	$2,40($fp)
$L186:
	lw	$2,40($fp)
	nop
	slt	$2,$2,62
	bne	$2,$0,$L187
	nop

	nop
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_court_lines
	.size	draw_court_lines, .-draw_court_lines
	.align	2
	.globl	draw_racket
	.set	nomips16
	.set	nomicromips
	.ent	draw_racket
	.type	draw_racket, @function
draw_racket:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	sw	$4,56($fp)
	sw	$5,60($fp)
	sw	$6,64($fp)
	sw	$7,68($fp)
	sw	$0,24($fp)
	b	$L189
	nop

$L194:
	sw	$0,28($fp)
	b	$L190
	nop

$L193:
	lw	$3,60($fp)
	lw	$2,24($fp)
	nop
	addu	$2,$3,$2
	sw	$2,32($fp)
	lw	$3,56($fp)
	lw	$2,28($fp)
	nop
	addu	$2,$3,$2
	sw	$2,36($fp)
	lw	$2,36($fp)
	nop
	bltz	$2,$L191
	nop

	lw	$2,36($fp)
	nop
	slt	$2,$2,96
	beq	$2,$0,$L191
	nop

	lw	$2,32($fp)
	nop
	bltz	$2,$L191
	nop

	lw	$2,32($fp)
	nop
	slt	$2,$2,64
	beq	$2,$0,$L191
	nop

	lui	$2,%hi(RACKET_PATTERN)
	lw	$3,24($fp)
	nop
	sll	$3,$3,3
	addiu	$2,$2,%lo(RACKET_PATTERN)
	addu	$3,$3,$2
	lw	$2,28($fp)
	nop
	addu	$2,$3,$2
	lbu	$2,0($2)
	nop
	sw	$2,40($fp)
	lw	$3,40($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L192
	nop

	lw	$2,72($fp)
	nop
	sw	$2,16($sp)
	lw	$7,68($fp)
	lw	$6,64($fp)
	lw	$5,36($fp)
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

	b	$L191
	nop

$L192:
	lw	$3,40($fp)
	li	$2,2			# 0x2
	bne	$3,$2,$L191
	nop

	li	$2,100			# 0x64
	sw	$2,16($sp)
	li	$7,100			# 0x64
	li	$6,100			# 0x64
	lw	$5,36($fp)
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

$L191:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L190:
	lw	$2,28($fp)
	nop
	slt	$2,$2,8
	bne	$2,$0,$L193
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L189:
	lw	$2,24($fp)
	nop
	slt	$2,$2,12
	bne	$2,$0,$L194
	nop

	nop
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_racket
	.size	draw_racket, .-draw_racket
	.align	2
	.globl	draw_ball
	.set	nomips16
	.set	nomicromips
	.ent	draw_ball
	.type	draw_ball, @function
draw_ball:
	.frame	$fp,48,$31		# vars= 16, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	sw	$4,48($fp)
	sw	$5,52($fp)
	sw	$0,24($fp)
	b	$L196
	nop

$L200:
	sw	$0,28($fp)
	b	$L197
	nop

$L199:
	lw	$3,52($fp)
	lw	$2,24($fp)
	nop
	addu	$2,$3,$2
	sw	$2,32($fp)
	lw	$3,48($fp)
	lw	$2,28($fp)
	nop
	addu	$2,$3,$2
	sw	$2,36($fp)
	lw	$2,36($fp)
	nop
	bltz	$2,$L198
	nop

	lw	$2,36($fp)
	nop
	slt	$2,$2,96
	beq	$2,$0,$L198
	nop

	lw	$2,32($fp)
	nop
	bltz	$2,$L198
	nop

	lw	$2,32($fp)
	nop
	slt	$2,$2,64
	beq	$2,$0,$L198
	nop

	sw	$0,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	lw	$5,36($fp)
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

$L198:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L197:
	lw	$2,28($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L199
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L196:
	lw	$2,24($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L200
	nop

	nop
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_ball
	.size	draw_ball, .-draw_ball
	.align	2
	.globl	draw_tennis_game
	.set	nomips16
	.set	nomicromips
	.ent	draw_tennis_game
	.type	draw_tennis_game, @function
draw_tennis_game:
	.frame	$fp,48,$31		# vars= 16, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	jal	lcd_clear_vbuf
	nop

	sw	$0,24($fp)
	b	$L202
	nop

$L205:
	sw	$0,28($fp)
	b	$L203
	nop

$L204:
	sw	$0,16($sp)
	li	$7,100			# 0x64
	move	$6,$0
	lw	$5,28($fp)
	lw	$4,24($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L203:
	lw	$2,28($fp)
	nop
	slt	$2,$2,96
	bne	$2,$0,$L204
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L202:
	lw	$2,24($fp)
	nop
	slt	$2,$2,64
	bne	$2,$0,$L205
	nop

	jal	draw_court_lines
	nop

	lui	$2,%hi(p1_x)
	lw	$3,%lo(p1_x)($2)
	lui	$2,%hi(p1_y)
	lw	$2,%lo(p1_y)($2)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	move	$6,$0
	move	$5,$2
	move	$4,$3
	jal	draw_racket
	nop

	lui	$2,%hi(p2_x)
	lw	$3,%lo(p2_x)($2)
	lui	$2,%hi(p2_y)
	lw	$2,%lo(p2_y)($2)
	sw	$0,16($sp)
	li	$7,128			# 0x80
	li	$6,255			# 0xff
	move	$5,$2
	move	$4,$3
	jal	draw_racket
	nop

	lui	$2,%hi(ball_x)
	lw	$3,%lo(ball_x)($2)
	lui	$2,%hi(ball_y)
	lw	$2,%lo(ball_y)($2)
	nop
	move	$5,$2
	move	$4,$3
	jal	draw_ball
	nop

	lui	$2,%hi(score_p1)
	lw	$2,%lo(score_p1)($2)
	nop
	andi	$2,$2,0x00ff
	addiu	$2,$2,48
	andi	$2,$2,0x00ff
	sll	$2,$2,24
	sra	$2,$2,24
	sb	$2,32($fp)
	li	$2,45			# 0x2d
	sb	$2,33($fp)
	lui	$2,%hi(score_p2)
	lw	$2,%lo(score_p2)($2)
	nop
	andi	$2,$2,0x00ff
	addiu	$2,$2,48
	andi	$2,$2,0x00ff
	sll	$2,$2,24
	sra	$2,$2,24
	sb	$2,34($fp)
	sb	$0,35($fp)
	addiu	$3,$fp,32
	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	move	$6,$3
	li	$5,5			# 0x5
	move	$4,$0
	jal	lcd_puts_color
	nop

	nop
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_tennis_game
	.size	draw_tennis_game, .-draw_tennis_game
	.align	2
	.globl	draw_squash_background
	.set	nomips16
	.set	nomicromips
	.ent	draw_squash_background
	.type	draw_squash_background, @function
draw_squash_background:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$0,24($fp)
	b	$L207
	nop

$L210:
	sw	$0,28($fp)
	b	$L208
	nop

$L209:
	li	$2,60			# 0x3c
	sw	$2,16($sp)
	li	$7,40			# 0x28
	move	$6,$0
	lw	$5,28($fp)
	lw	$4,24($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L208:
	lw	$2,28($fp)
	nop
	slt	$2,$2,96
	bne	$2,$0,$L209
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L207:
	lw	$2,24($fp)
	nop
	slt	$2,$2,56
	bne	$2,$0,$L210
	nop

	nop
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_squash_background
	.size	draw_squash_background, .-draw_squash_background
	.align	2
	.globl	draw_squash_walls
	.set	nomips16
	.set	nomicromips
	.ent	draw_squash_walls
	.type	draw_squash_walls, @function
draw_squash_walls:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	sw	$0,24($fp)
	b	$L212
	nop

$L215:
	sw	$0,28($fp)
	b	$L213
	nop

$L214:
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,180			# 0xb4
	move	$6,$0
	lw	$5,28($fp)
	lw	$4,24($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L213:
	lw	$2,28($fp)
	nop
	slt	$2,$2,96
	bne	$2,$0,$L214
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L212:
	lw	$2,24($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L215
	nop

	li	$2,52			# 0x34
	sw	$2,32($fp)
	b	$L216
	nop

$L219:
	sw	$0,36($fp)
	b	$L217
	nop

$L218:
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,180			# 0xb4
	move	$6,$0
	lw	$5,36($fp)
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,36($fp)
	nop
	addiu	$2,$2,1
	sw	$2,36($fp)
$L217:
	lw	$2,36($fp)
	nop
	slt	$2,$2,96
	bne	$2,$0,$L218
	nop

	lw	$2,32($fp)
	nop
	addiu	$2,$2,1
	sw	$2,32($fp)
$L216:
	lw	$2,32($fp)
	nop
	slt	$2,$2,56
	bne	$2,$0,$L219
	nop

	sw	$0,40($fp)
	b	$L220
	nop

$L223:
	li	$2,92			# 0x5c
	sw	$2,44($fp)
	b	$L221
	nop

$L222:
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,180			# 0xb4
	move	$6,$0
	lw	$5,44($fp)
	lw	$4,40($fp)
	jal	lcd_set_vbuf_pixel
	nop

	lw	$2,44($fp)
	nop
	addiu	$2,$2,1
	sw	$2,44($fp)
$L221:
	lw	$2,44($fp)
	nop
	slt	$2,$2,96
	bne	$2,$0,$L222
	nop

	lw	$2,40($fp)
	nop
	addiu	$2,$2,1
	sw	$2,40($fp)
$L220:
	lw	$2,40($fp)
	nop
	slt	$2,$2,56
	bne	$2,$0,$L223
	nop

	nop
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_squash_walls
	.size	draw_squash_walls, .-draw_squash_walls
	.align	2
	.globl	draw_squash_racket
	.set	nomips16
	.set	nomicromips
	.ent	draw_squash_racket
	.type	draw_squash_racket, @function
draw_squash_racket:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	sw	$4,56($fp)
	sw	$5,60($fp)
	sw	$6,64($fp)
	sw	$7,68($fp)
	sw	$0,24($fp)
	b	$L225
	nop

$L230:
	sw	$0,28($fp)
	b	$L226
	nop

$L229:
	lw	$3,60($fp)
	lw	$2,24($fp)
	nop
	addu	$2,$3,$2
	sw	$2,32($fp)
	lw	$3,56($fp)
	lw	$2,28($fp)
	nop
	addu	$2,$3,$2
	sw	$2,36($fp)
	lw	$2,36($fp)
	nop
	bltz	$2,$L227
	nop

	lw	$2,36($fp)
	nop
	slt	$2,$2,96
	beq	$2,$0,$L227
	nop

	lw	$2,32($fp)
	nop
	bltz	$2,$L227
	nop

	lw	$2,32($fp)
	nop
	slt	$2,$2,56
	beq	$2,$0,$L227
	nop

	lui	$2,%hi(RACKET_PATTERN)
	lw	$3,24($fp)
	nop
	sll	$3,$3,3
	addiu	$2,$2,%lo(RACKET_PATTERN)
	addu	$3,$3,$2
	lw	$2,28($fp)
	nop
	addu	$2,$3,$2
	lbu	$2,0($2)
	nop
	sw	$2,40($fp)
	lw	$3,40($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L228
	nop

	lw	$2,72($fp)
	nop
	sw	$2,16($sp)
	lw	$7,68($fp)
	lw	$6,64($fp)
	lw	$5,36($fp)
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

	b	$L227
	nop

$L228:
	lw	$3,40($fp)
	li	$2,2			# 0x2
	bne	$3,$2,$L227
	nop

	li	$2,100			# 0x64
	sw	$2,16($sp)
	li	$7,100			# 0x64
	li	$6,100			# 0x64
	lw	$5,36($fp)
	lw	$4,32($fp)
	jal	lcd_set_vbuf_pixel
	nop

$L227:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L226:
	lw	$2,28($fp)
	nop
	slt	$2,$2,8
	bne	$2,$0,$L229
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L225:
	lw	$2,24($fp)
	nop
	slt	$2,$2,12
	bne	$2,$0,$L230
	nop

	nop
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_squash_racket
	.size	draw_squash_racket, .-draw_squash_racket
	.align	2
	.globl	draw_squash_ball
	.set	nomips16
	.set	nomicromips
	.ent	draw_squash_ball
	.type	draw_squash_ball, @function
draw_squash_ball:
	.frame	$fp,48,$31		# vars= 16, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	sw	$4,48($fp)
	sw	$5,52($fp)
	sw	$0,24($fp)
	b	$L232
	nop

$L236:
	sw	$0,28($fp)
	b	$L233
	nop

$L235:
	lw	$3,48($fp)
	lw	$2,28($fp)
	nop
	addu	$2,$3,$2
	sw	$2,32($fp)
	lw	$3,52($fp)
	lw	$2,24($fp)
	nop
	addu	$2,$3,$2
	sw	$2,36($fp)
	lw	$2,32($fp)
	nop
	bltz	$2,$L234
	nop

	lw	$2,32($fp)
	nop
	slt	$2,$2,96
	beq	$2,$0,$L234
	nop

	lw	$2,36($fp)
	nop
	bltz	$2,$L234
	nop

	lw	$2,36($fp)
	nop
	slt	$2,$2,56
	beq	$2,$0,$L234
	nop

	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	li	$6,255			# 0xff
	lw	$5,32($fp)
	lw	$4,36($fp)
	jal	lcd_set_vbuf_pixel
	nop

$L234:
	lw	$2,28($fp)
	nop
	addiu	$2,$2,1
	sw	$2,28($fp)
$L233:
	lw	$2,28($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L235
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L232:
	lw	$2,24($fp)
	nop
	slt	$2,$2,4
	bne	$2,$0,$L236
	nop

	nop
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_squash_ball
	.size	draw_squash_ball, .-draw_squash_ball
	.align	2
	.globl	draw_squash_score
	.set	nomips16
	.set	nomicromips
	.ent	draw_squash_score
	.type	draw_squash_score, @function
draw_squash_score:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,83			# 0x53
	move	$5,$0
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,58			# 0x3a
	li	$5,1			# 0x1
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	lw	$3,32($fp)
	li	$2,100			# 0x64
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$3
	li	$2,10			# 0xa
	nop
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	addiu	$3,$2,48
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	move	$6,$3
	li	$5,2			# 0x2
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	lw	$3,32($fp)
	li	$2,10			# 0xa
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$3
	li	$2,10			# 0xa
	nop
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	addiu	$3,$2,48
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	move	$6,$3
	li	$5,3			# 0x3
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	lw	$3,32($fp)
	li	$2,10			# 0xa
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	addiu	$3,$2,48
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	move	$6,$3
	li	$5,4			# 0x4
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_squash_score
	.size	draw_squash_score, .-draw_squash_score
	.align	2
	.globl	draw_lives
	.set	nomips16
	.set	nomicromips
	.ent	draw_lives
	.type	draw_lives, @function
draw_lives:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	sw	$0,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	li	$6,76			# 0x4c
	li	$5,6			# 0x6
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	sw	$0,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	li	$6,58			# 0x3a
	li	$5,7			# 0x7
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	sw	$0,24($fp)
	b	$L239
	nop

$L242:
	lw	$3,24($fp)
	lw	$2,40($fp)
	nop
	slt	$2,$3,$2
	beq	$2,$0,$L240
	nop

	lw	$2,24($fp)
	nop
	addiu	$2,$2,8
	sw	$0,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	li	$6,42			# 0x2a
	move	$5,$2
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

	b	$L241
	nop

$L240:
	lw	$2,24($fp)
	nop
	addiu	$3,$2,8
	li	$2,100			# 0x64
	sw	$2,20($sp)
	li	$2,100			# 0x64
	sw	$2,16($sp)
	li	$7,100			# 0x64
	li	$6,45			# 0x2d
	move	$5,$3
	li	$4,7			# 0x7
	jal	lcd_putc_color
	nop

$L241:
	lw	$2,24($fp)
	nop
	addiu	$2,$2,1
	sw	$2,24($fp)
$L239:
	lw	$2,24($fp)
	nop
	slt	$2,$2,3
	bne	$2,$0,$L242
	nop

	nop
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_lives
	.size	draw_lives, .-draw_lives
	.rdata
	.align	2
$LC19:
	.ascii	"P1\000"
	.align	2
$LC20:
	.ascii	" <\000"
	.align	2
$LC21:
	.ascii	"P2\000"
	.text
	.align	2
	.globl	draw_turn_indicator
	.set	nomips16
	.set	nomicromips
	.ent	draw_turn_indicator
	.type	draw_turn_indicator, @function
draw_turn_indicator:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	sw	$5,44($fp)
	lw	$3,44($fp)
	li	$2,3			# 0x3
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$3
	li	$2,-2147483648			# 0xffffffff80000000
	ori	$2,$2,0x1
	and	$2,$3,$2
	bgez	$2,$L244
	nop

	addiu	$2,$2,-1
	li	$3,-2			# 0xfffffffffffffffe
	or	$2,$2,$3
	addiu	$2,$2,1
$L244:
	sw	$2,24($fp)
	lw	$2,40($fp)
	nop
	bne	$2,$0,$L245
	nop

	lw	$2,24($fp)
	nop
	beq	$2,$0,$L246
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	lui	$2,%hi($LC19)
	addiu	$6,$2,%lo($LC19)
	move	$5,$0
	move	$4,$0
	jal	lcd_puts_color
	nop

	b	$L247
	nop

$L246:
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC19)
	addiu	$6,$2,%lo($LC19)
	move	$5,$0
	move	$4,$0
	jal	lcd_puts_color
	nop

$L247:
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC20)
	addiu	$6,$2,%lo($LC20)
	li	$5,2			# 0x2
	move	$4,$0
	jal	lcd_puts_color
	nop

	b	$L251
	nop

$L245:
	lw	$2,24($fp)
	nop
	beq	$2,$0,$L249
	nop

	sw	$0,20($sp)
	li	$2,128			# 0x80
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC21)
	addiu	$6,$2,%lo($LC21)
	move	$5,$0
	move	$4,$0
	jal	lcd_puts_color
	nop

	b	$L250
	nop

$L249:
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC21)
	addiu	$6,$2,%lo($LC21)
	move	$5,$0
	move	$4,$0
	jal	lcd_puts_color
	nop

$L250:
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC20)
	addiu	$6,$2,%lo($LC20)
	li	$5,2			# 0x2
	move	$4,$0
	jal	lcd_puts_color
	nop

$L251:
	nop
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_turn_indicator
	.size	draw_turn_indicator, .-draw_turn_indicator
	.align	2
	.globl	draw_squash_game
	.set	nomips16
	.set	nomicromips
	.ent	draw_squash_game
	.type	draw_squash_game, @function
draw_squash_game:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	jal	lcd_clear_vbuf
	nop

	jal	draw_squash_background
	nop

	jal	draw_squash_walls
	nop

	lui	$2,%hi(sq_turn)
	lw	$2,%lo(sq_turn)($2)
	nop
	bne	$2,$0,$L253
	nop

	lui	$2,%hi(sq_p1_x)
	lw	$3,%lo(sq_p1_x)($2)
	lui	$2,%hi(sq_p1_y)
	lw	$2,%lo(sq_p1_y)($2)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	move	$6,$0
	move	$5,$2
	move	$4,$3
	jal	draw_squash_racket
	nop

	lui	$2,%hi(game_mode)
	lw	$3,%lo(game_mode)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L255
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$3,%lo(sq_p2_x)($2)
	lui	$2,%hi(sq_p2_y)
	lw	$2,%lo(sq_p2_y)($2)
	sw	$0,16($sp)
	li	$7,64			# 0x40
	li	$6,128			# 0x80
	move	$5,$2
	move	$4,$3
	jal	draw_squash_racket
	nop

	b	$L255
	nop

$L253:
	lui	$2,%hi(sq_p1_x)
	lw	$3,%lo(sq_p1_x)($2)
	lui	$2,%hi(sq_p1_y)
	lw	$2,%lo(sq_p1_y)($2)
	sw	$0,16($sp)
	li	$7,128			# 0x80
	move	$6,$0
	move	$5,$2
	move	$4,$3
	jal	draw_squash_racket
	nop

	lui	$2,%hi(game_mode)
	lw	$3,%lo(game_mode)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L255
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$3,%lo(sq_p2_x)($2)
	lui	$2,%hi(sq_p2_y)
	lw	$2,%lo(sq_p2_y)($2)
	sw	$0,16($sp)
	li	$7,128			# 0x80
	li	$6,255			# 0xff
	move	$5,$2
	move	$4,$3
	jal	draw_squash_racket
	nop

$L255:
	lui	$2,%hi(sq_ball_x)
	lw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_y)
	lw	$2,%lo(sq_ball_y)($2)
	nop
	move	$5,$2
	move	$4,$3
	jal	draw_squash_ball
	nop

	lui	$2,%hi(game_mode)
	lw	$3,%lo(game_mode)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L256
	nop

	lui	$2,%hi(sq_turn)
	lw	$3,%lo(sq_turn)($2)
	lui	$2,%hi(frame_counter)
	lw	$2,%lo(frame_counter)($2)
	nop
	move	$5,$2
	move	$4,$3
	jal	draw_turn_indicator
	nop

$L256:
	lui	$2,%hi(sq_score)
	lw	$2,%lo(sq_score)($2)
	nop
	move	$4,$2
	jal	draw_squash_score
	nop

	lui	$2,%hi(sq_lives)
	lw	$2,%lo(sq_lives)($2)
	nop
	move	$4,$2
	jal	draw_lives
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_squash_game
	.size	draw_squash_game, .-draw_squash_game
	.align	2
	.globl	squash_update
	.set	nomips16
	.set	nomicromips
	.ent	squash_update
	.type	squash_update, @function
squash_update:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$fp,16($sp)
	move	$fp,$sp
	jal	squash_move_players
	nop

	lui	$2,%hi(sq_ball_x)
	lw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_vx)
	lw	$2,%lo(sq_ball_vx)($2)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(sq_ball_x)
	sw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_y)
	lw	$3,%lo(sq_ball_y)($2)
	lui	$2,%hi(sq_ball_vy)
	lw	$2,%lo(sq_ball_vy)($2)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(sq_ball_y)
	sw	$3,%lo(sq_ball_y)($2)
	lui	$2,%hi(sq_ball_y)
	lw	$2,%lo(sq_ball_y)($2)
	nop
	slt	$2,$2,5
	beq	$2,$0,$L258
	nop

	lui	$2,%hi(sq_ball_y)
	li	$3,4			# 0x4
	sw	$3,%lo(sq_ball_y)($2)
	lui	$2,%hi(sq_ball_vy)
	lw	$2,%lo(sq_ball_vy)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(sq_ball_vy)
	sw	$3,%lo(sq_ball_vy)($2)
	li	$4,8			# 0x8
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,2			# 0x2
	sw	$3,%lo(buzzer_timer)($2)
$L258:
	lui	$2,%hi(sq_ball_y)
	lw	$2,%lo(sq_ball_y)($2)
	nop
	slt	$2,$2,48
	bne	$2,$0,$L259
	nop

	lui	$2,%hi(sq_ball_y)
	li	$3,48			# 0x30
	sw	$3,%lo(sq_ball_y)($2)
	lui	$2,%hi(sq_ball_vy)
	lw	$2,%lo(sq_ball_vy)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(sq_ball_vy)
	sw	$3,%lo(sq_ball_vy)($2)
	li	$4,8			# 0x8
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,2			# 0x2
	sw	$3,%lo(buzzer_timer)($2)
$L259:
	lui	$2,%hi(sq_ball_x)
	lw	$2,%lo(sq_ball_x)($2)
	nop
	slt	$2,$2,88
	bne	$2,$0,$L260
	nop

	lui	$2,%hi(sq_ball_x)
	li	$3,88			# 0x58
	sw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_vx)
	lw	$2,%lo(sq_ball_vx)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(sq_ball_vx)
	sw	$3,%lo(sq_ball_vx)($2)
	li	$4,8			# 0x8
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,2			# 0x2
	sw	$3,%lo(buzzer_timer)($2)
$L260:
	lui	$2,%hi(sq_ball_vx)
	lw	$2,%lo(sq_ball_vx)($2)
	nop
	bgez	$2,$L261
	nop

	lui	$2,%hi(sq_p1_x)
	lw	$2,%lo(sq_p1_x)($2)
	nop
	addiu	$3,$2,8
	lui	$2,%hi(sq_ball_x)
	lw	$2,%lo(sq_ball_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L261
	nop

	lui	$2,%hi(sq_ball_x)
	lw	$2,%lo(sq_ball_x)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(sq_p1_x)
	lw	$2,%lo(sq_p1_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L261
	nop

	lui	$2,%hi(sq_ball_y)
	lw	$2,%lo(sq_ball_y)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(sq_p1_y)
	lw	$2,%lo(sq_p1_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L261
	nop

	lui	$2,%hi(sq_p1_y)
	lw	$2,%lo(sq_p1_y)($2)
	nop
	addiu	$3,$2,12
	lui	$2,%hi(sq_ball_y)
	lw	$2,%lo(sq_ball_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L261
	nop

	lui	$2,%hi(sq_p1_x)
	lw	$2,%lo(sq_p1_x)($2)
	nop
	addiu	$3,$2,8
	lui	$2,%hi(sq_ball_x)
	sw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_vx)
	lw	$2,%lo(sq_ball_vx)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(sq_ball_vx)
	sw	$3,%lo(sq_ball_vx)($2)
	lui	$2,%hi(sq_score)
	lw	$2,%lo(sq_score)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(sq_score)
	sw	$3,%lo(sq_score)($2)
	lui	$2,%hi(sq_rally)
	lw	$2,%lo(sq_rally)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(sq_rally)
	sw	$3,%lo(sq_rally)($2)
	lui	$2,%hi(game_mode)
	lw	$3,%lo(game_mode)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L262
	nop

	lui	$2,%hi(sq_turn)
	li	$3,1			# 0x1
	sw	$3,%lo(sq_turn)($2)
$L262:
	li	$4,8			# 0x8
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,2			# 0x2
	sw	$3,%lo(buzzer_timer)($2)
$L261:
	lui	$2,%hi(game_mode)
	lw	$3,%lo(game_mode)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L263
	nop

	lui	$2,%hi(sq_ball_vx)
	lw	$2,%lo(sq_ball_vx)($2)
	nop
	bgez	$2,$L263
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$2,%lo(sq_p2_x)($2)
	nop
	addiu	$3,$2,8
	lui	$2,%hi(sq_ball_x)
	lw	$2,%lo(sq_ball_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L263
	nop

	lui	$2,%hi(sq_ball_x)
	lw	$2,%lo(sq_ball_x)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(sq_p2_x)
	lw	$2,%lo(sq_p2_x)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L263
	nop

	lui	$2,%hi(sq_ball_y)
	lw	$2,%lo(sq_ball_y)($2)
	nop
	addiu	$3,$2,4
	lui	$2,%hi(sq_p2_y)
	lw	$2,%lo(sq_p2_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L263
	nop

	lui	$2,%hi(sq_p2_y)
	lw	$2,%lo(sq_p2_y)($2)
	nop
	addiu	$3,$2,12
	lui	$2,%hi(sq_ball_y)
	lw	$2,%lo(sq_ball_y)($2)
	nop
	slt	$2,$3,$2
	bne	$2,$0,$L263
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$2,%lo(sq_p2_x)($2)
	nop
	addiu	$3,$2,8
	lui	$2,%hi(sq_ball_x)
	sw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_vx)
	lw	$2,%lo(sq_ball_vx)($2)
	nop
	subu	$3,$0,$2
	lui	$2,%hi(sq_ball_vx)
	sw	$3,%lo(sq_ball_vx)($2)
	lui	$2,%hi(sq_score)
	lw	$2,%lo(sq_score)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(sq_score)
	sw	$3,%lo(sq_score)($2)
	lui	$2,%hi(sq_rally)
	lw	$2,%lo(sq_rally)($2)
	nop
	addiu	$3,$2,1
	lui	$2,%hi(sq_rally)
	sw	$3,%lo(sq_rally)($2)
	lui	$2,%hi(sq_turn)
	sw	$0,%lo(sq_turn)($2)
	li	$4,8			# 0x8
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,2			# 0x2
	sw	$3,%lo(buzzer_timer)($2)
$L263:
	lui	$2,%hi(sq_ball_x)
	lw	$2,%lo(sq_ball_x)($2)
	nop
	bgez	$2,$L264
	nop

	lui	$2,%hi(sq_lives)
	lw	$2,%lo(sq_lives)($2)
	nop
	addiu	$3,$2,-1
	lui	$2,%hi(sq_lives)
	sw	$3,%lo(sq_lives)($2)
	lui	$2,%hi(sq_lives)
	lw	$2,%lo(sq_lives)($2)
	nop
	bgtz	$2,$L265
	nop

	lui	$2,%hi(game_state)
	li	$3,4			# 0x4
	sw	$3,%lo(game_state)($2)
	b	$L266
	nop

$L265:
	lui	$2,%hi(sq_ball_x)
	li	$3,20			# 0x14
	sw	$3,%lo(sq_ball_x)($2)
	lui	$2,%hi(sq_ball_y)
	li	$3,26			# 0x1a
	sw	$3,%lo(sq_ball_y)($2)
	lui	$2,%hi(sq_ball_vx)
	li	$3,3			# 0x3
	sw	$3,%lo(sq_ball_vx)($2)
	lui	$2,%hi(sq_ball_vy)
	li	$3,2			# 0x2
	sw	$3,%lo(sq_ball_vy)($2)
	lui	$2,%hi(sq_rally)
	sw	$0,%lo(sq_rally)($2)
	lui	$2,%hi(sq_turn)
	sw	$0,%lo(sq_turn)($2)
$L266:
	li	$4,13			# 0xd
	jal	buzzer_play
	nop

	lui	$2,%hi(buzzer_timer)
	li	$3,5			# 0x5
	sw	$3,%lo(buzzer_timer)($2)
$L264:
	jal	draw_squash_game
	nop

	nop
	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	squash_update
	.size	squash_update, .-squash_update
	.align	2
	.globl	squash_move_players
	.set	nomips16
	.set	nomicromips
	.ent	squash_move_players
	.type	squash_move_players, @function
squash_move_players:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	li	$2,6			# 0x6
	sw	$2,0($fp)
	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,1			# 0x1
	bne	$3,$2,$L268
	nop

	lui	$2,%hi(sq_p1_y)
	lw	$2,%lo(sq_p1_y)($2)
	nop
	slt	$2,$2,5
	bne	$2,$0,$L268
	nop

	lui	$2,%hi(sq_p1_y)
	lw	$3,%lo(sq_p1_y)($2)
	lw	$2,0($fp)
	nop
	subu	$3,$3,$2
	lui	$2,%hi(sq_p1_y)
	sw	$3,%lo(sq_p1_y)($2)
$L268:
	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,7			# 0x7
	bne	$3,$2,$L269
	nop

	lui	$2,%hi(sq_p1_y)
	lw	$2,%lo(sq_p1_y)($2)
	nop
	slt	$2,$2,40
	beq	$2,$0,$L269
	nop

	lui	$2,%hi(sq_p1_y)
	lw	$3,%lo(sq_p1_y)($2)
	lw	$2,0($fp)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(sq_p1_y)
	sw	$3,%lo(sq_p1_y)($2)
$L269:
	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,4			# 0x4
	bne	$3,$2,$L270
	nop

	lui	$2,%hi(sq_p1_x)
	lw	$2,%lo(sq_p1_x)($2)
	nop
	blez	$2,$L270
	nop

	lui	$2,%hi(sq_p1_x)
	lw	$3,%lo(sq_p1_x)($2)
	lw	$2,0($fp)
	nop
	subu	$3,$3,$2
	lui	$2,%hi(sq_p1_x)
	sw	$3,%lo(sq_p1_x)($2)
$L270:
	lui	$2,%hi(input_p1_dir)
	lw	$3,%lo(input_p1_dir)($2)
	li	$2,5			# 0x5
	bne	$3,$2,$L271
	nop

	lui	$2,%hi(sq_p1_x)
	lw	$2,%lo(sq_p1_x)($2)
	nop
	slt	$2,$2,80
	beq	$2,$0,$L271
	nop

	lui	$2,%hi(sq_p1_x)
	lw	$3,%lo(sq_p1_x)($2)
	lw	$2,0($fp)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(sq_p1_x)
	sw	$3,%lo(sq_p1_x)($2)
$L271:
	lui	$2,%hi(game_mode)
	lw	$3,%lo(game_mode)($2)
	li	$2,2			# 0x2
	bne	$3,$2,$L276
	nop

	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,10			# 0xa
	bne	$3,$2,$L273
	nop

	lui	$2,%hi(sq_p2_y)
	lw	$2,%lo(sq_p2_y)($2)
	nop
	slt	$2,$2,5
	bne	$2,$0,$L273
	nop

	lui	$2,%hi(sq_p2_y)
	lw	$3,%lo(sq_p2_y)($2)
	lw	$2,0($fp)
	nop
	subu	$3,$3,$2
	lui	$2,%hi(sq_p2_y)
	sw	$3,%lo(sq_p2_y)($2)
$L273:
	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,12			# 0xc
	bne	$3,$2,$L274
	nop

	lui	$2,%hi(sq_p2_y)
	lw	$2,%lo(sq_p2_y)($2)
	nop
	slt	$2,$2,40
	beq	$2,$0,$L274
	nop

	lui	$2,%hi(sq_p2_y)
	lw	$3,%lo(sq_p2_y)($2)
	lw	$2,0($fp)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(sq_p2_y)
	sw	$3,%lo(sq_p2_y)($2)
$L274:
	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,6			# 0x6
	bne	$3,$2,$L275
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$2,%lo(sq_p2_x)($2)
	nop
	blez	$2,$L275
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$3,%lo(sq_p2_x)($2)
	lw	$2,0($fp)
	nop
	subu	$3,$3,$2
	lui	$2,%hi(sq_p2_x)
	sw	$3,%lo(sq_p2_x)($2)
$L275:
	lui	$2,%hi(input_p2_dir)
	lw	$3,%lo(input_p2_dir)($2)
	li	$2,11			# 0xb
	bne	$3,$2,$L276
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$2,%lo(sq_p2_x)($2)
	nop
	slt	$2,$2,80
	beq	$2,$0,$L276
	nop

	lui	$2,%hi(sq_p2_x)
	lw	$3,%lo(sq_p2_x)($2)
	lw	$2,0($fp)
	nop
	addu	$3,$3,$2
	lui	$2,%hi(sq_p2_x)
	sw	$3,%lo(sq_p2_x)($2)
$L276:
	nop
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	squash_move_players
	.size	squash_move_players, .-squash_move_players
	.align	2
	.globl	draw_result_squash
	.set	nomips16
	.set	nomicromips
	.ent	draw_result_squash
	.type	draw_result_squash, @function
draw_result_squash:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 24, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	jal	lcd_clear_vbuf
	nop

	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC5)
	addiu	$6,$2,%lo($LC5)
	move	$5,$0
	li	$4,1			# 0x1
	jal	lcd_puts_color
	nop

	sw	$0,20($sp)
	sw	$0,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC6)
	addiu	$6,$2,%lo($LC6)
	move	$5,$0
	li	$4,2			# 0x2
	jal	lcd_puts_color
	nop

	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	li	$7,255			# 0xff
	lui	$2,%hi($LC5)
	addiu	$6,$2,%lo($LC5)
	move	$5,$0
	li	$4,3			# 0x3
	jal	lcd_puts_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,83			# 0x53
	move	$5,$0
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,67			# 0x43
	li	$5,1			# 0x1
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,79			# 0x4f
	li	$5,2			# 0x2
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,82			# 0x52
	li	$5,3			# 0x3
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,69			# 0x45
	li	$5,4			# 0x4
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	li	$6,58			# 0x3a
	li	$5,5			# 0x5
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	lw	$3,32($fp)
	li	$2,100			# 0x64
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$3
	li	$2,10			# 0xa
	nop
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	addiu	$3,$2,48
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	move	$6,$3
	li	$5,6			# 0x6
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	lw	$3,32($fp)
	li	$2,10			# 0xa
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	mflo	$3
	li	$2,10			# 0xa
	nop
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	addiu	$3,$2,48
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	move	$6,$3
	li	$5,7			# 0x7
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	lw	$3,32($fp)
	li	$2,10			# 0xa
	div	$0,$3,$2
	bne	$2,$0,1f
	nop
	break	7
1:
	mfhi	$2
	addiu	$3,$2,48
	sw	$0,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	move	$6,$3
	li	$5,8			# 0x8
	li	$4,5			# 0x5
	jal	lcd_putc_color
	nop

	li	$2,255			# 0xff
	sw	$2,20($sp)
	li	$2,255			# 0xff
	sw	$2,16($sp)
	move	$7,$0
	lui	$2,%hi($LC9)
	addiu	$6,$2,%lo($LC9)
	move	$5,$0
	li	$4,7			# 0x7
	jal	lcd_puts_color
	nop

	nop
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	draw_result_squash
	.size	draw_result_squash, .-draw_result_squash
	.ident	"GCC: (GNU) 7.4.0"
