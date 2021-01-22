#####################################################################
#
# Bitmap Display Configuration:
# - Unit width in pixels: 	8				     
# - Unit height in pixels: 	8
# - Display width in pixels: 	256
# - Display height in pixels: 	512
# - Base Address for Display: 	0x10008000 ($gp)
#
#
# Which approved additional features have been implemented?
#
# 1. More platform types: 
#	- Vertically moving blocks (blue)
#	- Horozontally moving blocks (grey)
#	- “Fragile" blocks (dotted line)
#
# 2. Boosting / power-ups:
#	- Magic Boots - grant higher jumping height (red boots)
#	- Rocket suits - boost up the doodler for a long distance (blue arrow)
#	- Springs - boost up the doodler for a medium distance (grey spring) (it may not look like a spring though XD)
#
# 3. Fancier graphics: 
#	- smoothly scrolling screen without flickers or glitches
#	- well designed GAMEOVER / PAUSE / RESUME animations
#	- a 5x5 cute kitty as the doodler
#	- carefully designed item icons / platforms / font in pixelart style
#	- dynamically updated scoreboard
#
# 4. Dynamic on-screen notifications: 
#	- Good! (at 200pts)
#	- Wow! 	(at 500pts)
#	- Cool! (at 1000pts)
#	- POG! 	(at 2000pts)
#
# 5. Opponents / lethal creatures:
#	- lethal traps (only occur on regular plats; looks like orange fences)
#
# 6. Shields (for protection of Doodler)
#	- Shields - protect the doodler from traps (green cross)
#
#
#####################################################################

.data
	PROMPT_BEGIN: .asciiz "----------------------------------\nWelcome to KITTY JUMP! Use J and K on your keyboard to move the doodler, and press P to pause the game.\n\n"
	PROMPT_GG: .asciiz "Game Over! Press S to play again\n\n"
	PROMPT_PAUSE: .asciiz "The kitty has been frozen. Press P again to resume\n\n"
	PROMPT_RESUME: .asciiz "The kitty has been defrosted.\n\n"
	
	displayAddress:		.word	0x10008000
	
	COLOR_BG:		.word	0xfffcf0
	COLOR_WHITE:		.word	0xfffcf0
	COLOR_GREEN:		.word	0x82cfb5
	COLOR_LIGHT_GREEN:	.word	0xb5e3d3
	COLOR_YELLOW: 		.word	0xfce8aa
	COLOR_BLACK: 		.word	0x000000
	COLOR_DARK_ORANGE:	.word	0xe7a668
	COLOR_RED: 		.word 	0xff7373
	COLOR_RED_1:		.word	0xff8c8c
	COLOR_RED_2:		.word	0xd86060
	COLOR_ORANGE: 		.word 	0xf9cdad
	COLOR_CREAM:		.word	0xffdcc2
	COLOR_BLUE:		.word 	0x62c1e5
	COLOR_DARK_BLUE:	.word 	0x93bbca
	COLOR_LIGHT_BLUE:	.word	0xbcd8e2
	COLOR_DARK_GREY:	.word	0xa99a8e
	COLOR_GREY:		.word	0xc3b6ad
	COLOR_GREY_0:		.word	0xb3b3b3
	COLOR_GREY_1:		.word	0x868686
	COLOR_DOODLE_BOOTS:	.word	0xfce8aa	# variable
	COLOR_SHIELD:		.word	0xb5e3d3
	
	PLAT_LEN_K: 		.word 	6
	PLAT_MIN_DISTANCE:	.word	9
	JUMP_HEIGHT: 		.word 	20
	DOODLE_MAX_HEIGHT: 	.word 	35
	DOODLE_INITIAL_POS:	.word 	6740
	MV_SPEED: 		.word	3 	# movement speed for doodler & moving plats (higher value = lower speed)
	STEP_LEN:		.word 	8	# the step length upon every key press
	
	ITEM_GENERATOR_K:	.word	20	# 1/20
	PLAT_GENERATOR_K:	.word	15	# 1/15
	TRAP_GENERATOR_K:	.word	15	# 1/15
	
	shield_timer:		.word	-1
	boots_timer:		.word 	-1
	prevDoodlePos: 		.word 	0x10008000
	currDoodlePos:		.word	0x10008000	# $s3
	prevRocketPos:		.word	0x10008000
	
	currScore: 		.word 	0
	prevScore: 		.word 	0
	face: 			.word 	0	# 0 = facing left; 1 = facing right
	
	platNum: 		.word 	1
	plat_list: 		.space 	500
	prev_plats_list: 	.space 	500 
	
	# 0		4	8	12		16		20
	# leftPos, rightPos, randomItem, randomItemPos, platformType, platformTypeArg
	saved_list: .word 6980,7032,0,0,0,0, 5532,5568,0,0,0,0, 4168,4204,0,0,0,0, 2832,2872,0,0,0,0, 1740,1772,0,0,0,0
	
	# every num takes 14 places 0						1						2							3						4							5							6						7						8						9
	nums_list: 	.word 0,4,8,128,136,256,264,384,392,512,516,520,888,888, 0,4,132,260,388,512,516,520,888,888,888,888,888,888, 0,4,8,136,256,260,264,384,512,516,520,888,888,888, 0,4,8,136,256,260,264,392,512,516,520,888,888,888, 0,8,128,136,256,260,264,392,520,888,888,888,888,888, 0,4,8,128,256,260,264,392,512,516,520,888,888,888, 0,4,8,128,256,260,264,384,392,512,516,520,888,888, 0,4,8,136,264,392,520,888,888,888,888,888,888,888, 0,4,8,128,136,256,260,264,384,392,512,516,520,888, 0,4,8,128,136,256,260,264,392,512,516,520,888,888
	
	# alphabet
	letter_G: 	.word 4, 8, 128, 256, 384, 516, 520, 396, 268, 264 ,888
	letter_A: 	.word 4,8,128,256,260,264,384,512,140,268,396,524,888
	letter_M: 	.word 4,12,128,256,384,512,136,264,392,520,144,272,400,528,888
	letter_E: 	.word 0,4,8,128,256,260,384,512,516,520,888
	letter_O: 	.word 4,8,128,256,384,516,520,140,268,396,888
	letter_V: 	.word 0,128,256,388,520,396,272,144,16,888
	letter_R: 	.word 0,4,8,128,256,384,512,140,260,264,392,524,888
	letter_P: 	.word 0,4,8,128,256,384,512,140,260,264,888
	letter_S: 	.word 4,8,12,128,260,264,396,512,516,520,888
	letter_U: 	.word 0,12,128,256,384,516,520,140,268,396,888
	letter_D: 	.word 0,4,8,128,256,384,512,516,520,140,268,396,888
	letter_C: 	.word 4,8,128,256,384, 396,516,520,140,888
	letter_W: 	.word 0,16,128,256,384,516,136,264,392,524,144,272,400,888
	letter_L: 	.word 0,128,256,384,512,516,520,888
	letter_K:	.word 0,128,256,384,512, 12,136,260,392,524, 888
	letter_I:	.word 0,4,8, 132,260,388, 512,516,520, 888
	letter_T:	.word 0,4,8, 132,260,388,516, 888
	letter_Y:	.word 0,132,264,140,16,392,520, 888
	letter_J:	.word 0,4,8,12, 136,264,392,516,384, 888
	letter_block: 	.word 0,4,8,12,16, 128,132,136,140,144, 256,260,264,268,272, 384,388,392,396,400, 512,516,520,524,528, 888
	letter_excl_mark: .word  0,128,256,512, 888
	_6x1_bar:	.word 0,128,256,384,512,640, 888
	_5x1_bar:	.word 0,128,256,384,512, 888
	rocket_icon:	.word 0,-124,-116,-248,-244,-380,-376,-372, 888
	shield:		.word 8,12,16,20,24, 132, 156, 256,384,512,640,768, 900,904, 1032,1036,1040,1044,1048, 924,920, 288,416,544,672,800, 888
	
	
.text
	
main:
	li $v0, 4
	la $a0, PROMPT_BEGIN
	syscall
	
	lw $t0, displayAddress	# $t0 stores the base address for display
	
	jal reset_canva			# set the canva to COLOR_BG
	
	lw $t1,  DOODLE_INITIAL_POS
	add $s3, $t0, $t1		# reset initial position
	
	la $s0, currScore
	sw $0, 0($s0)			# reset currScore
	
	la $t1, platNum
	li $t2, 3
	sw $t2, 0($t1)			# reset platNum
	
	li $t1, -1
	sw $t1, shield_timer		# reset shield timer
	li $t1, -1
	sw $t1, boots_timer		# reset boots timer
	jal disarm_boots
	
	jal to_difficulty_0		# reset the difficulty to level 0
	jal reset_platform_lists	# reset plats_list & prev_plats_list
	
	jal add_platform
	jal add_platform
	jal add_platform
	jal add_platform
	jal add_platform
	jal add_platform
	jal add_platform
	jal add_platform
	jal add_platform		# add initial plats
	
WHILE:
	lw $t8, 0xffff0000 
	bne $t8, 1, skip_check_keyboard_input
	
	#check_keyboard_input
	lw $t1, 0xffff0004
	bne $t1, 0x6A, skip_j_call
	jal respond_to_j
	skip_j_call:
	
	bne $t1, 0x6B, skip_k_call
	jal respond_to_k
	skip_k_call:
	
	bne $t1, 0x70, skip_p_call
	jal respond_to_p
	skip_p_call:
	
	skip_check_keyboard_input:
	
	#sleep
	li $v0, 32
  	li $a0, 10
  	syscall

 	jal refresh_screen
 	
	addi $t8, $t0, 8064	# if doodler falls to bottom, game over
	bge $s3, $t8, game_over
	
j WHILE

Exit:
	li $v0, 10 		# terminate the program
	syscall
	
	
respond_to_j:
	addi $sp, $sp, -4 	# move the stack pointer to increase stack size 
	sw $ra, 0($sp)
	
	lw $t2, STEP_LEN
	sub $s3, $s3, $t2
	
	#change the facing direction of doodler
	lw $t2, face
	li $t2, 0
	sw $t2, face
	
	lw $ra, 0($sp)        # load the word at the top of the stack
    	addi $sp, $sp, 4     # decrease the size of the stack
    	
	jr $ra
	
respond_to_k:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t2, STEP_LEN
	add $s3, $s3, $t2
	
	#change the facing direction of doodler
	lw $t2, face
	li $t2, 1
	sw $t2, face
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
	
respond_to_p: # pause/ continue
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, 4
	la $a0, PROMPT_PAUSE
	syscall
	add $a1, $t0, 3860	# 31*128 + 5*4
	jal pause_display
	
	
	pause_while:
	li $v0, 32
	li $a0, 10
	syscall
	lw $t8, 0xffff0000 
	bne $t8, 1, skip_check_keyboard_input_during_pause
	#check_keyboard_input
	lw $t1, 0xffff0004
	bne $t1, 0x70, pause_while
	
	jal reset_canva
	jal draw
	
	add $a1, $t0, 3848
	jal resume_display
	
	jal reset_canva
	li $v0, 4
	la $a0, PROMPT_RESUME
	syscall
	j WHILE
	skip_check_keyboard_input_during_pause:
	j pause_while
	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
	
refresh_screen:		# 'jal draw' 3 times
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_doodle_height
	add $v0, $v0, $s4		# $v0 = expected height
	lw $t6, DOODLE_MAX_HEIGHT
	sub $t6, $v0, $t6		# difference between DOODLE_MAX_HEIGHT and expected height
	
	
	
	blez $t6, skip_scroll_plat	# if expected height <= 0, skip scrolling
	# scroll_plat
	addi $a0, $0, 1
	subi $t6, $t6, 1	# 
	subi $s4, $s4, 1	# jump -1
	
	lw $t7, currScore
	add $t7, $t7, 1
	sw $t7, currScore	# add score by 1
	
	jal scroll_platform
	jal draw
	skip_scroll_plat:
	
	beqz $s5, start_move_cond
	addi $s5, $s5, -1
	
	j fall_exit
	
	# every "MV_SPEED" frames
	start_move_cond:
	lw $s5, MV_SPEED
	jal notifi_display
	
	# for shield
	lw $t2, shield_timer
	bltz $t2, skip_shield_countdown
	addi $t2, $t2, -1
	sw $t2, shield_timer
	skip_shield_countdown:
	
	# for boots
  	lw $t2, boots_timer

	bltz $t2, skip_disarm_boots
	beqz $t2, disarm_boots_call
	addi $t2, $t2, -1
	sw $t2, boots_timer
	j skip_disarm_boots
	
	disarm_boots_call:
	jal disarm_boots
	addi $t2, $0, -1
	sw $t2, boots_timer
	skip_disarm_boots:
	
	# for mobile plats
  	la $t1, plat_list
	lw $t2, platNum
	
	check_mobile_plat_loop:
		beqz $t2, check_mobile_plat_loop_exit
		
		lw $t3, 16($t1)
		bne $t3, 1, skip_move_hori_mobile_plat
		# move_hori
		move $a0, $t1
		jal move_horizontal_mobile_platform
		skip_move_hori_mobile_plat:
		
		bne $t3, 3, skip_move_vert_mobile_plat
		#move_vert
		move $a0, $t1
		jal move_vertical_mobile_platform
		skip_vert:
	
		skip_move_vert_mobile_plat:
		
		addi $t1, $t1, 24
		subi $t2, $t2, 1
		j check_mobile_plat_loop
		
	check_mobile_plat_loop_exit:
	
	
	ble $s4, 0, fall_call # $s4 == 0 means it is falling
	j jump_call
	
	fall_call:
	
		addi $s3, $s3, 128
		addi $t8, $s3, 16	# $t8 is the left margin of the doodler
		la $t1, plat_list
		lw $s6, platNum
		
		# {loop START
		check_fall_on_plat_loop:
		
			blez $s6, check_fall_on_plat_loop_exit
			lw $t3, 0($t1)
			lw $t9, 16($t1)
			
			bge $t8, $t3, check_right_edge	# if left edge < leftPos. then it can't be on a plat, skip checking right edge
			
			beq $t9, 3, go_rough_check1
			j skip_check_right_edge
			check_right_edge:
			lw $t4, 4($t1)			# load word "rightPos" -> $t4
			blt $s3, $t4, collide_with_plat	# if right edge < rightPos, change to jump
			beq $t9, 3, go_rough_check1
			j skip_check_right_edge
			
			go_rough_check1:
			addi $t9, $s3, 144
			blt $t9, $t3, skip_rough_check1
			
			addi $t9, $s3, 128
			lw $t4, 4($t1)			# load word "rightPos" -> $t4
			blt $t9, $t4, add_128	# if right edge < rightPos, change to jump
			
			skip_rough_check1:
			
			go_rough_check2:
			addi $t9, $s3, -112
			blt $t9, $t3, skip_check_right_edge
			
			addi $t9, $s3, -128
			lw $t4, 4($t1)			# load word "rightPos" -> $t4
			blt $t9, $t4, add_128
			j skip_check_right_edge
			add_128:
			add $s3, $s3, 128
			j collide_with_plat	# if right edge < rightPos, change to jump
			
			
			collide_with_plat:
				lw $t7, 8($t1)
				bne $t7, 1, skip_rocket_trigger
				
				lw $t6, 12($t1)
				sub $t5, $s3, $t3
				div $t5, $t5, 128	#distance between s3 and the item
				mfhi $t5
				sub $t5, $t6, $t5
				ble $t5, -16,  skip_items_trigger
				bge $t5, 20,  skip_items_trigger
				li $a0, 10
				jal rocket
				jal reset_canva
	
 				j skip_items_trigger
				
				skip_rocket_trigger:
				
				#   boots check
				bne $t7, 2, skip_boots_trigger
				
				lw $t6, 12($t1)
				sub $t5, $s3, $t3
				div $t5, $t5, 128	#distance between s3 and the item
				mfhi $t5
				sub $t5, $t6, $t5
				ble $t5, -16,  skip_items_trigger
				bge $t5, 20,  skip_items_trigger
				jal get_boots
 				j skip_items_trigger
 				
				skip_boots_trigger:
				
				#   spring check
				bne $t7, 3, skip_spring_trigger
				
				lw $t6, 12($t1)
				sub $t5, $s3, $t3
				div $t5, $t5, 128	#distance between s3 and the item
				mfhi $t5
				sub $t5, $t6, $t5
				ble $t5, -16,  skip_items_trigger
				bge $t5, 20,  skip_items_trigger
				li $a0, 4
				jal rocket
 				j skip_items_trigger
 				
				skip_spring_trigger:
				
				#   SHIELD check
				bne $t7, 4, skip_shield_trigger
				
				lw $t6, 12($t1)
				sub $t5, $s3, $t3
				div $t5, $t5, 128	#distance between s3 and the item
				mfhi $t5
				sub $t5, $t6, $t5
				ble $t5, -16,  skip_items_trigger
				bge $t5, 20,  skip_items_trigger
				jal get_shield
 				j skip_items_trigger
 				
				skip_shield_trigger:
				
				#   TRAP check
				bne $t7, 5, skip_trap_trigger
				
				lw $t6, 12($t1)
				sub $t5, $s3, $t3
				div $t5, $t5, 128	#distance between s3 and the item
				mfhi $t5
				sub $t5, $t6, $t5
				ble $t5, -16,  skip_items_trigger
				bge $t5, 20,  skip_items_trigger
				lw $t5, shield_timer
				bgtz $t5, skip_items_trigger
				j game_over
 				j skip_items_trigger
 				
				skip_trap_trigger:
				
				skip_items_trigger:
				
				#   fragile check
				lw $t7, 16($t1)
				bne $t7, 2, skip_fragile
				add $t7, $0, 0
				sw $t7, 0($t1)
				add $t7, $0, 0
				sw $t7, 4($t1)
				
				skip_fragile:
				j change_to_jump
			
			skip_check_right_edge:
			addi $s6, $s6, -1
			addi $t1, $t1, 24
		j check_fall_on_plat_loop
		check_fall_on_plat_loop_exit:
		# loop END }
		
		
		jal draw
 		j fall_exit

 		change_to_jump:
			lw $t5, platNum
			sub $t5, $t5, $s6
 			sub $t5, $t5, 2
 			refresh_plats_loop:
 				blez $t5, refresh_plats_loop_exit
 				jal add_platform
 				jal remove_lowest_platform
 				addi $t5, $t5, -1
 				j refresh_plats_loop
 		
 			refresh_plats_loop_exit:

 			lw $s4, JUMP_HEIGHT
 			j jump_call
 	
 	jump_call:
 		addi $s3, $s3, -128
 		addi $s4, $s4, -1
 		jal draw

	fall_exit:
	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra

draw:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $t6, 4($sp)
	sw $t5, 8($sp)
	
	jal draw_doodle		# draw doodle
	
	la $t1, plat_list
	la $t3, prev_plats_list
	lw $t2, platNum
	
	draw_plats_loop:	# draw platforms
		blez $t2, draw_plats_loop_exit
		
		add $a0, $0, $t1
		add $a1, $0, $t3
		
		jal draw_platform
		
		lw $t5, 0($a0)	# store data into prev_plat_list
		sw $t5, 0($a1)
		lw $t5, 4($a0)
		sw $t5, 4($a1)
		lw $t5, 8($a0)
		sw $t5, 8($a1)
		lw $t5, 12($a0)
		sw $t5, 12($a1)
		lw $t5, 16($a0)
		sw $t5, 16($a1)
		lw $t5, 20($a0)
		sw $t5, 20($a1)
		
		addi $t3, $t3, 24
		addi $t1, $t1, 24
		subi $t2, $t2, 1
		j draw_plats_loop
	draw_plats_loop_exit:

	jal draw_doodle		# draw doodler again to avoid glitches
	jal draw_scoreboard	# draw scoreboard
	
	lw $t1, currScore
	beq $t1, 6  reset_title
	bge $t1, 6, skip_title
	add $a1, $t0, 396
	lw $a2, COLOR_DARK_GREY
 	jal title_display
 	j skip_title
 	reset_title:
	add $a1, $t0, 396
	lw $a2, COLOR_BG
	jal title_display
 	add $t1, $t1, 1
 	sw $t1, currScore
	skip_title:
	
	lw $ra, 0($sp) 
	lw $t6, 4($sp)
	lw $t5, 8($sp)
    	addi $sp, $sp, 12
    	
	jr $ra
	
get_shield:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t5, 4($sp)
	
	#lw $t5, COLOR_LIGHT_GREEN
	#sw $t5, COLOR_SHIELD
	
	li $t5, 100
	sw $t5, shield_timer
	
	lw $ra, 0($sp)  
	lw $t5, 4($sp)
    	addi $sp, $sp, 8
	jr $ra

get_boots:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t5, 4($sp)
	
	lw $t5, COLOR_RED
	sw $t5, COLOR_DOODLE_BOOTS
	li $t5, 35
	sw $t5, JUMP_HEIGHT
	li $t5, 100
	sw $t5, boots_timer
	
	lw $ra, 0($sp)  
	lw $t5, 4($sp)
    	addi $sp, $sp, 8
	jr $ra
disarm_boots:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t5, 4($sp)
	
	lw $t5, COLOR_YELLOW
	sw $t5, COLOR_DOODLE_BOOTS
	li $t5, 20
	sw $t5, JUMP_HEIGHT
	
	lw $ra, 0($sp)  
	lw $t5, 4($sp)
    	addi $sp, $sp, 8
	jr $ra
rocket:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t5, 4($sp)
	
	move $t5, $a0
	lw $t2, COLOR_BLUE	# if > 8, rocket
	
	bgt $t5, 8, skip_paint_boots_grey
	lw $t2, COLOR_GREY_1
	skip_paint_boots_grey:
	
	
	sw $t2, COLOR_DOODLE_BOOTS
	rocket_jump_loop:
		blez $t5, rocket_jump_loop_exit
		lw $t8, 0xffff0000 
		bne $t8, 1, skip_jk_calls
		lw $t1, 0xffff0004
		beq $t1, 0x6A, J_call2
		beq $t1, 0x6B, K_call2
		j skip_jk_calls
		
		J_call2: 
		jal respond_to_j
		j rocket_jump_loop
		K_call2: 
		jal respond_to_k
		j rocket_jump_loop
		skip_jk_calls:
		
		jal add_platform
 		lw $t6, PLAT_MIN_DISTANCE
 		addi $t6, $t6, 1
 		
 		scroll_rocket_loop:
 			beqz $t6,scroll_rocket_loop_exit
 			
 			addi $a0, $0, 1
 			jal scroll_platform
 			jal draw
 			
 			lw $s0, currScore
 			addi $s0, $s0, 1
 			sw $s0, currScore
 			
 			addi $t6, $t6, -1
 			li $v0, 32
  			li $a0, 5
  			syscall
 			j scroll_rocket_loop
 		scroll_rocket_loop_exit:
 		
 		jal remove_lowest_platform	
 		addi $t5, $t5, -1
 		j rocket_jump_loop
 	rocket_jump_loop_exit:
 	
	lw $s4, JUMP_HEIGHT
 	div $s4, $s4, 2
	lw $t2, COLOR_YELLOW
	sw $t2, COLOR_DOODLE_BOOTS
	
	lw $ra, 0($sp)  
	lw $t5, 4($sp)
    	addi $sp, $sp, 8
	jr $ra

# $a0 = the height of scroll
scroll_platform:	
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $t2, 4($sp)
	sw $t4, 8($sp)
	sw $t5, 12($sp)
	
	addi $t4, $0, 128
	mult $a0, $t4
	mflo $a0
	
	la $t1, plat_list
	lw $t2, platNum
	scroll_plat_while:
		beqz $t2, scroll_plat_exit
		lw $t3, 0($t1)
		
		beqz $t3, skip_this_plat
		add $t3, $t3, $a0
		sw $t3, 0($t1)
		
		lw $t3, 4($t1)
		add $t3, $t3, $a0
		sw $t3, 4($t1)
		skip_this_plat:
		addi $t1, $t1, 24
		subi $t2, $t2, 1
		j scroll_plat_while
	scroll_plat_exit:
	#jal draw
	lw $ra, 0($sp)  
	lw $t2, 4($sp)
	lw $t4, 8($sp)
	lw $t5, 12($sp)
    	addi $sp, $sp, 16
	jr $ra

# $a0 = address of leftPos; $a1 = address of prevLeftPos; $a2  = address of itemPos
draw_platform:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $t1, 12($sp)
	sw $t2, 16($sp)
	sw $t3, 20($sp)
	sw $t4, 24($sp)
	
	lw $t1, 0($a0)	# leftPos
	lw $t2, 4($a0)	# rightPos
	
	lw $t3, 0($a1)	# prevLeftPos
	lw $t4, 4($a1)	# prevRightPos
	
	
	addi $t5, $t0, -256
	ble $t3, $t5, draw_platform_exit	#if the platform is outside the canva, go exit


	lw $t5, 8($a1)	# $t5 = itemArg of the previous platform
	
	bne $t1, $t3, erasePrevPlat
	beq $t2, $t4, erasePrevPlat_exit	# if the plat did not move, then skip the erasing process
	
	lw $s0, COLOR_BG
	# erase the previous painted platform
	erasePrevPlat:
		bge $t3, $t4, erasePrevPlat_exit
		sw $s0, 0($t3)
		beqz $t5, skip_top_erase	# if previously no item painted, skip some rerasing process
		sw $s0, -128($t3)
		sw $s0, -256($t3)
		sw $s0, -384($t3)
		sw $s0, -512($t3)
		skip_top_erase:
		sw $s0, 128($t3)
		addi $t3, $t3, 4
		j erasePrevPlat
	erasePrevPlat_exit:
	
	
	beqz $t1, draw_platform_exit			# if something = 0 (generated after fragile plat disappears), skip drawing
	
	## SET COLORS; $s1 = plat color; $t4 = plat base color
	lw $s1, COLOR_ORANGE			# 0 = regular plat; set the color to be orange
	lw $t4, COLOR_CREAM
	
	lw $s2, 16($a0)
	beq $s2, 2, draw_fragile_plat_loop	# 2 = fragile plat
	bne $s2, 3, skip_paint_grey		# 3 = vertically moving plat
	
	lw $s1, COLOR_DARK_GREY			# set the color to be grey
	lw $t4, COLOR_GREY
	skip_paint_grey:
	
	bne $s2, 1, skip_paint_blue		# 1 = horonzontally moving plat
	lw $s1, COLOR_DARK_BLUE			# set the color to be blue
	lw $t4, COLOR_LIGHT_BLUE
	skip_paint_blue:
	
	# DRAW the platform	(0/1/3)
	addi $t3, $t1, 132		# $t3 = left position of plat base ( stored before $t1 changes )
	draw_plat_loop:
		bge $t1, $t2, draw_plat_loop_exit
		sw $s1, 0($t1)
		addi $t1, $t1, 4
		j draw_plat_loop
	draw_plat_loop_exit:
	
	# DRAW the platform base
	addi $t2, $t2, 124		# $t2 = right position of plat base
	draw_plat_base_loop:		# iterate from $t3 -> $t2
		bge $t3, $t2, draw_plat_base_loop_exit
		sw $t4, 0($t3)
		addi $t3, $t3, 4
		j draw_plat_base_loop
	draw_plat_base_loop_exit:
	j draw_fragile_plat_loop_exit
	
	# DRAW fragile platform	(2)
	draw_fragile_plat_loop:		# iterate from $t1 -> $t2
		bge $t1, $t2, draw_fragile_plat_loop_exit
		sw $s1, 0($t1)
		addi $t1, $t1, 8
		j draw_fragile_plat_loop
	draw_fragile_plat_loop_exit:
	
	
	
	# draw rocket icon
	lw $t2, 8($a0)
	bne $t2, 1, skip_rocket_draw
	
	lw $t2, 12($a0)
	lw $t3, 0($a0)
	add $t2, $t2, $t3
	addi $t2, $t2, -128
	lw $a2, COLOR_BLUE
	la $a0, rocket_icon
	move $a1, $t2
	sw $t2, prevRocketPos
	jal draw_single_letter
	skip_rocket_draw:
	
	# draw boots icon
	lw $t2, 8($a0)
	bne $t2, 2, skip_boots_draw
	
	lw $t2, 12($a0)
	lw $t3, 0($a0)
	add $t2, $t2, $t3
	addi $t2, $t2, -256
	lw $s2, COLOR_RED_2
	sw $s2, 0($t2)
	sw $s2, 4($t2)
	sw $s2, 8($t2)
	sw $s2, 12($t2)
	lw $s2, COLOR_RED_1
	sw $s2, -128($t2)
	sw $s2, -256($t2)
	lw $s2, COLOR_RED
	sw $s2, -124($t2)
	sw $s2, -120($t2)
	sw $s2, -116($t2)
	sw $s2, -252($t2)
	skip_boots_draw:
	
	# draw spring icon
	lw $t2, 8($a0)
	bne $t2, 3, skip_spring_draw
	
	lw $t2, 12($a0)
	lw $t3, 0($a0)
	add $t2, $t2, $t3
	addi $t2, $t2, -384
	lw $s2, COLOR_GREY_1
	sw $s2, 0($t2)
	sw $s2, 4($t2)
	sw $s2, 8($t2)
	sw $s2, 12($t2)
	sw $s2, 128($t2)
	sw $s2, 132($t2)
	sw $s2, 264($t2)
	sw $s2, 268($t2)
	lw $s2, COLOR_GREY_0
	sw $s2, 136($t2)
	sw $s2, 260($t2)
	skip_spring_draw:
	
	# draw shield icon
	lw $t2, 8($a0)
	bne $t2, 4, skip_shield_draw
	
	lw $t2, 12($a0)
	lw $t3, 0($a0)
	add $t2, $t2, $t3
	addi $t2, $t2, -384
	lw $s2, COLOR_GREEN
	sw $s2, 0($t2)
	sw $s2, 4($t2)
	sw $s2, 8($t2)
	sw $s2, -124($t2)
	sw $s2, 132($t2)
	skip_shield_draw:
	
	# draw trap icon
	lw $t2, 8($a0)
	bne $t2, 5, skip_trap_draw
	
	lw $t2, 12($a0)
	lw $t3, 0($a0)
	add $t2, $t2, $t3
	addi $t2, $t2, -128
	lw $s2, COLOR_ORANGE
	sw $s2, 0($t2)
	sw $s2, 8($t2)
	sw $s2, 16($t2)
	skip_trap_draw:
	
	draw_platform_exit:
	
	lw $ra, 0($sp)  
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	lw $t3, 20($sp)
	lw $t4, 24($sp)
    	addi $sp, $sp, 28
	jr $ra
	
remove_lowest_platform:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	la $t1, plat_list
	lw $t2, platNum		# $t2 = platNum
	addi $t2, $t2, -1	# $t2 -= 1
	sw $t2, platNum		# store it back to platNum
	
	li $t3, 6
	mult $t3, $t2
	mflo $t2	# number of the nodes in the list
	# e.g. if there were 3 plats in the list, 1 removed ($t2 = $t2 - 1),  $t2 = 12
	
	# shift all platform data left by 1 unit (24 nodes)
	shift_list_down_loop:	# iterate from $t2 -> 0
		blez $t2, shift_list_down_loop_exit
		lw $t3, 24($t1)
		sw $t3, 0($t1)
		
		addi $t1, $t1, 4
		addi $t2, $t2, -1
		j shift_list_down_loop
	shift_list_down_loop_exit:
	
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
	jr $ra

add_platform:
	addi $sp, $sp, -8
	sw $t5, 4($sp)
	sw $ra, 0($sp)

 		
	la $t4, platNum
	lw $t2, 0($t4)
	addi $t3, $t2, 1
	sw $t3, 0($t4)
	
	
 	jal generate_plat_data
 	li $t3, 24
	mult $t2, $t3
	mflo $t2	# ($t2) * 24; if there are 2 plats and need to add one, t2 should be 40
	
 	la $t1, plat_list
	add $t1, $t1, $t2
	lw $t3, -24($t1)
	
	sub $t3, $t3, $t0
	div $t4, $t3, 128
	mfhi $t4
	sub $t3, $t3, $t4
	add $t3, $t3, $t0
	
 	add $t4, $t3, $v1
 	add $t5, $t4, $v0
 	
	sw $t4, 0($t1)	#leftPos
	sw $t5, 4($t1)	#rightPos
	
	
	
	li $v0, 42
	li $a0, 0
  	lw $a1, PLAT_GENERATOR_K	# 1/8: mobile; 1/8: fragile
  	syscall
  	
	bne $a0, 0, skip_hori_mobile_plat
	li $v0, 1
	sw $v0, 16($t1)
	li $v0, 1
	sw $v0, 20($t1)
	j generate_plat_type_end
	skip_hori_mobile_plat:
	

	bne $a0, 1, skip_fragile_plat
	li $v0, 2
	sw $v0, 16($t1)
	j generate_plat_type_end
	skip_fragile_plat:
	
	bne $a0, 2, skip_vert_mobile_plat
	li $v0, 3
	sw $v0, 16($t1)
	
	li $v0, 42
	li $a0, 0
  	li $a1, 5	#(0 ~ 5)
  	syscall
	sw $a0, 20($t1)
	j generate_plat_type_end
	skip_vert_mobile_plat:
	
	li $v0, 0
	sw $v0, 16($t1)
	sw $v0, 20($t1)
	generate_plat_type_end:

 	move $a0, $t1
	jal generate_plat_item
	sw $v0, 8($t1)	#itemType
	sw $v1, 12($t1)	#itemPos
	
	
	lw $ra, 0($sp)  
	lw $t5, 4($sp)
    	addi $sp, $sp, 8
	jr $ra
	
# $a0 = leftPosAddress;  OUTPUT: $v0 == 1 -> rocket; 2 -> boots ; $v1 = itemPos(Relative)
generate_plat_item:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	lw $t1, 0($a0)
	lw $t2, 4($a0)
	lw $t5, 16($a0)
	sub $t4, $t2, $t1
	div $t4, $t4, 4
	addi $t4, $t4, -4	# $t4 = FLOOR(len/4) - 4

	# 1/K probability of every item
	
	li $v0, 42
	li $a0, 0
  	lw $a1, ITEM_GENERATOR_K
  	syscall
  	
  	bne $a0, 1, skip_generate_rocket
  	
  	# rocket
  	li $v0, 42
	li $a0, 0
  	add $a1, $0, $t4	# itemPos = 0 ~ length
  	syscall
  	
  	li $t3, 4
  	mult $t3, $a0
  	mflo $v1
  	li $v0, 1
  	j item_output
  	skip_generate_rocket:

  	bne $a0, 2, skip_boots
  	
    	# magic boots 
  	li $v0, 42
	li $a0, 0
  	add $a1, $0, $t4	# itemPos = 0 ~ length
  	syscall
  	
  	li $t3, 4
  	mult $t3, $a0
  	mflo $v1
  	li $v0, 2
  	j item_output
  	skip_boots:
  	
  	bne $a0, 3, skip_spring
  	# spring
  	li $v0, 42
	li $a0, 0
  	add $a1, $0, $t4	# itemPos = 0 ~ length
  	syscall
  	
  	li $t3, 4
  	mult $t3, $a0
  	mflo $v1
  	li $v0, 3
  	j item_output
  	skip_spring:
  	
  	bne $a0, 4, skip_shield
  	
  	# shield
  	li $v0, 42
	li $a0, 0
  	add $a1, $0, $t4	# itemPos = 0 ~ length
  	syscall
  	
  	li $t3, 4
  	mult $t3, $a0
  	mflo $v1
  	li $v0, 4
  	j item_output
  	skip_shield:
  	
  	
  	li $v0, 42
	li $a0, 0
  	lw $a1, TRAP_GENERATOR_K
  	syscall
  	bne $a0, 0, skip_trap	
  	bne $t5, 0, skip_trap	# only occurs on regular plats
  	ble $t4, 5, skip_trap	# only occurs on plats longer than 9

  	# trap
  	li $v0, 42
	li $a0, 0
  	addi $a1, $t4, -1	# itemPos = 0 ~ length - 1
  	syscall
  	
  	li $t3, 4
  	mult $t3, $a0
  	mflo $v1
  	li $v0, 5
  	j item_output
  	skip_trap:
  	
  	default_set:
  	li $v0, 0
  	li $v1, 0
  		
  	item_output:
  		
  	lw $ra, 0($sp)  
	lw $t1, 4($sp)
	lw $t2, 8($sp)
    	addi $sp, $sp, 12
	jr $ra
		
# $v1 = move up offset $v0 = right_margin
generate_plat_data: 
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	lw $t8, PLAT_LEN_K
	sub $t7, $t8, 28	#  32 - 4 = 38
	sub $t7, $0, $t7
	
	
	li $v0, 42
	li $a0, 0
  	li $a1, 3	# $a0 = 0 ~ 2
  	syscall
  	
	lw $v1, PLAT_MIN_DISTANCE
  	add $v1, $v1, $a0 
  	
  	li $t9, -128
  	mult $v1, $t9
  	mflo $v1	# move up how many units

	li $v0, 42	# RANDOM_NUM_GENERATOR
	li $a0, 0
  	move $a1, $t7	# (0 ~ $t7) * 4 leftPos
  	syscall
  	
  	li $t9, 4
  	mult $a0, $t9
  	mflo $a0
  	add $v1, $v1, $a0	# $v1 is move up offset
  	
  	li $v0, 42
	li $a0, 0
  	move $a1, $t8	# ($t7 ~ $t7 + 4 + $t8) * 4 right margin
  	syscall
  	
  	addi $a0, $a0, 6
  	li $t9, 4
  	mult $a0, $t9
  	mflo $v0

  	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
	

# $a0 = address of the start of node i.e. leftPos
move_vertical_mobile_platform:
    	addi $sp, $sp, -20
	sw $ra, 0($sp)  
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	
	lw $v0, 20($a0)
	
	lw $t1, 0($a0)	# leftPos
	lw $t2, 4($a0)	# rightPos
	lw $t3, 20($a0)	# platArg
	
	
	addi $t3, $t3, 1
	sw $t3, 20($a0)
	
	# 0-21: up; 21-42: down
	bgt $t3, 42, reset_move_up
	
	div $t4, $t3, 3
	mfhi $t4
	bnez $t4, move_vertical_mobile_platform_end
	
	ble $t3, 21, move_up_call
	bgt $t3, 21, move_down_call
	
	move_up_call:
	li $v0, -128
	add $t1, $t1, $v0
	add $t2, $t2, $v0
	sw $t1, 0($a0)
	sw $t2, 4($a0)
	j move_vertical_mobile_platform_end
	
	move_down_call:
	li $v0, 128
	add $t1, $t1, $v0
	add $t2, $t2, $v0
	sw $t1, 0($a0)
	sw $t2, 4($a0)
	
	j move_vertical_mobile_platform_end
	
	reset_move_up:
		li $t3, 0
		sw $t3, 20($a0)

	move_vertical_mobile_platform_end:
	
	lw $ra, 0($sp)  
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
    	addi $sp, $sp, 20
	jr $ra
	
# $a0 = address of the start of node i.e. leftPos
move_horizontal_mobile_platform:
    	addi $sp, $sp, -20
	sw $ra, 0($sp)  
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	
	lw $v0, 20($a0)
	
	lw $t1, 0($a0)	# leftPos
	div $t2, $t1, 128
	mfhi $t2	#remainder
	
	lw $t3, 4($a0)	# rightPos
	div $t4, $t3, 128
	mfhi $t4	#remainder
	
	ble $t2, 4, change_to_move_right
	bge $t4, 124, change_to_move_left
	j move_mobile_platform_end
	
	change_to_move_right:
		li $v0, 1
		sw $v0, 20($a0)
	j move_mobile_platform_end
	
	change_to_move_left:
		li $v0, -1
		sw $v0, 20($a0)
	
	move_mobile_platform_end:
	li $v1, 4
	mult $v1, $v0
	mflo $v0
	add $t1, $t1, $v0
	add $t3, $t3, $v0
	sw $t1, 0($a0)
	sw $t3, 4($a0)
	
	lw $ra, 0($sp)  
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
    	addi $sp, $sp, 20
	jr $ra
	
# $v0 = height, $v1 = 64 - height
get_doodle_height:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	sub $v1, $s3, $t0	# get relative coordinate
	div $v1, $v1, 128	# get distance to top
	
	sub $v0, $v1, 64
	sub $v0, $0, $v0	# get height
	
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
	jr $ra


reset_canva:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	addi $t9, $t0, 0
	addi $t8, $t0, 8192
	lw $s0, COLOR_BG
	
	reset_canva_loop:
		bgt $t9, $t8, reset_canva_loop_exit
		sw $s0, 0($t9)
		addi $t9, $t9, 4
		j reset_canva_loop
		
	reset_canva_loop_exit:
	addi $t9, $t9, 0
	lw $ra, 0($sp) 
    	addi $sp, $sp, 4    
	jr $ra

reset_platform_lists:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	la $t1, plat_list
	la $t2, saved_list
	la $t5, prev_plats_list
	
	lw $t3, platNum
	addi $t4, $0, 6
	mult $t3, $t4
	mflo $t3
	reset_list_loop:
		beqz $t3, reset_list_loop_exit
		lw $t4, 0($t2)
		beqz $t4, skip_add
		add $t4, $t4, $t0
		skip_add:
		sw $t4, 0($t1)
		sw $t4, 0($t5)
		
		addi $t5, $t5, 4
		addi $t2, $t2, 4
		addi $t1, $t1, 4
		subi $t3, $t3, 1
		j reset_list_loop
	reset_list_loop_exit:
	lw $ra, 0($sp) 
    	addi $sp, $sp, 4    
	jr $ra


	
draw_numbers: #a0 is the top left corner coordinate; $a1 is the number to draw(max: 99999), $a2 is the color
	addi $sp, $sp, -4 	
	sw $ra, 0($sp)
	
	move $t3, $a0	#$a0 stores the pivot address
	move $t4, $a1	
	
	blt $t4, 10, skip4
	blt $t4, 100, skip3
	blt $t4, 1000, skip2
	blt $t4, 10000, skip1
	blt $t4, 100000, skip0
	
	div $t2, $t4, 100000	# hundred-thousands
	mfhi $t4		# remainder
	addi $a0, $t3, -32
	move $a1, $t2
	jal draw_single_num
	skip0:
	
	div $t2, $t4, 10000	# ten-thousands
	mfhi $t4		# remainder
	addi $a0, $t3, -16
	move $a1, $t2
	jal draw_single_num
	skip1:
	
	div $t2, $t4, 1000	# thousands
	mfhi $t4		# remainder
	addi $a0, $t3, 0
	move $a1, $t2
	jal draw_single_num
	skip2:

	div $t2, $t4, 100	# hundreds
	mfhi $t4
	addi $a0, $t3, 16
	move $a1, $t2
	jal draw_single_num
	skip3:
	
	div $t2, $t4, 10	# tens
	mfhi $t4
	addi $a0, $t3, 32
	move $a1, $t2
	jal draw_single_num
	skip4:
	
	addi $a0, $t3, 48
	move $a1, $t4
	jal draw_single_num
	
	lw $ra, 0($sp)        
    	addi $sp, $sp, 4     
	jr $ra
	
draw_single_num: #$a0 is the coordinate; $a1 is the number (0 ~ 9); $a2 is the color code
	addi $sp, $sp, -20	
	sw $ra, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	sw $t4, 12($sp)
	sw $t5, 16($sp) 
	
	move $s2, $a2	# move color code to $s2
	li $t2, 56	# 14 * 4 = 56
	
	mult $a1, $t2
	mflo $t2
	
	la $t4, nums_list	# the address of nums_list[0]
	add $t4, $t4, $t2
	draw_single_num_loop:
		lw $t3, 0($t4)
		bge $t3, 800, draw_single_num_loop_exit
		add $t5, $a0, $t3	# $t5 is the absolute coordinate of the target block
		sw $s2, 0($t5)
		addi $t4, $t4, 4
		j draw_single_num_loop
	draw_single_num_loop_exit:
	
	lw $ra, 0($sp)
	lw $t2, 4($sp)
	lw $t3, 8($sp)
	lw $t4, 12($sp)
	 lw $t5, 16($sp)    
    	addi $sp, $sp, 20 
	jr $ra
	
# $a0 = list address $a1 = absolute coordinate	$a2 = color
draw_single_letter:
	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $t3, 4($sp)
	sw $t4, 8($sp)
	
	draw_single_letter_loop:
		lw $t3, 0($a0)
		beq $t3, 888, draw_single_letter_loop_exit
		add $t4, $a1, $t3	# $t5 is the absolute coordinate of the target block
		sw $a2, 0($t4)
		addi $a0, $a0, 4
		j draw_single_letter_loop
	draw_single_letter_loop_exit:
	
	lw $ra, 0($sp) 
	lw $t3, 4($sp)
	lw $t4, 8($sp)     
    	addi $sp, $sp, 16  
    	jr $ra
    
# $a3 = offset
notifi_display:
	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)   	
	
	
	lw $a0, currScore
	blt $a0, 230, skip_notifi_reset_canva_call
	blt $a0, 235, notifi_reset_canva_call
	blt $a0, 530, skip_notifi_reset_canva_call
	blt $a0, 535, notifi_reset_canva_call
	blt $a0, 1050, skip_notifi_reset_canva_call
	blt $a0, 1055, notifi_reset_canva_call
	blt $a0, 2050, skip_notifi_reset_canva_call
	blt $a0, 2055, notifi_reset_canva_call
	j skip_notifi_reset_canva_call
	
	notifi_reset_canva_call:
	
	lw $a2, COLOR_BG
	addi $a1, $t0, 6152
	la $a0, letter_block
	jal draw_single_letter
	la $a0, letter_block
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_block
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_block
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_block
	addi $a1, $a1, 20
	jal draw_single_letter
	
	skip_notifi_reset_canva_call:
	
	blt $a0, 200, skip_good
	blt $a0, 230, show_good
	j skip_good
	
	show_good:
	
	lw $a2, COLOR_BLUE
	la $a0, letter_G
	addi $a1, $t0, 6152
	add $a1, $a1, $a3
	jal draw_single_letter
	la $a0, letter_O
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_O
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_D
	addi $a1, $a1, 20
	jal draw_single_letter
	j skipthis
	skip_good:
	
	lw $a0, currScore
	blt $a0, 500, skip_wow
	blt $a0, 530, show_wow
	j skip_wow
	show_wow:
	lw $a2, COLOR_GREEN
	la $a0, letter_W
	addi $a1, $t0, 6152
	add $a1, $a1, $a3
	jal draw_single_letter
	la $a0, letter_O
	addi $a1, $a1, 24
	jal draw_single_letter
	la $a0, letter_W
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_excl_mark
	addi $a1, $a1, 24
	jal draw_single_letter
	j skipthis
	skip_wow:
	
	lw $a0, currScore
	blt $a0, 1000, skip_cool
	blt $a0, 1050, show_cool
	j skip_cool
	
	show_cool:
	
	lw $a2, COLOR_DARK_GREY
	la $a0, letter_C
	addi $a1, $t0, 6152
	add $a1, $a1, $a3
	jal draw_single_letter
	la $a0, letter_O
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_O
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_L
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_excl_mark
	addi $a1, $a1, 16
	jal draw_single_letter
	
	j skipthis
	skip_cool:
	
	
	lw $a0, currScore
	blt $a0, 2000, skip_pog
	blt $a0, 2050, show_pog
	j skip_pog
	show_pog:
	
	lw $a2, COLOR_RED
	la $a0, letter_P
	addi $a1, $t0, 6152
	add $a1, $a1, $a3
	jal draw_single_letter
	la $a0, letter_O
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_G
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_excl_mark
	addi $a1, $a1, 20
	jal draw_single_letter
	j skipthis
	skip_pog:
	
	skipthis:
	lw $ra, 0($sp) 
	lw $a0, 4($sp)
	lw $a1, 8($sp)     
    	addi $sp, $sp, 16  
    	jr $ra   
 
 title_display:
 	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	la $a0, letter_K
	addi $a1, $a1, 0
	jal draw_single_letter
	la $a0, letter_I
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_T
	addi $a1, $a1, 16
	jal draw_single_letter
	la $a0, letter_T
	addi $a1, $a1, 16
	jal draw_single_letter
	la $a0, letter_Y
	addi $a1, $a1, 16
	jal draw_single_letter
	add $a1, $a1, -92
	add $a1, $a1, 768  # 6x128
	la $a0, letter_J
	addi $a1, $a1, 24
	jal draw_single_letter
	la $a0, letter_U
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_M
	addi $a1, $a1, 20
	jal draw_single_letter
	la $a0, letter_P
	addi $a1, $a1, 24
	jal draw_single_letter
	lw $ra, 0($sp) 
	lw $a0, 4($sp)
	lw $a1, 8($sp)     
    	addi $sp, $sp, 16  
    	jr $ra   
 #$a1 = coordinate
 pause_display:
	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	lw $a2, COLOR_DARK_GREY
	la $a0, letter_P
	addi $a1, $a1, 0
	jal draw_single_letter
	
	la $a0, letter_A
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_U
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_S
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_E
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, _6x1_bar
	addi $a1, $a1, -1200	# - 9*128 - 12*4
	jal draw_single_letter
	
	la $a0, _6x1_bar
	addi $a1, $a1, 4	
	jal draw_single_letter
	
	la $a0, _6x1_bar
	addi $a1, $a1, 12	
	jal draw_single_letter
	
	la $a0, _6x1_bar
	addi $a1, $a1, 4	
	jal draw_single_letter
	
	lw $a2, COLOR_GREY
	la $a0, _6x1_bar
	addi $a1, $a1, -12	
	jal draw_single_letter
	
	la $a0, _6x1_bar
	addi $a1, $a1, 16	
	jal draw_single_letter
	
	lw $ra, 0($sp) 
	lw $a0, 4($sp)
	lw $a1, 8($sp)     
    	addi $sp, $sp, 16  
    	jr $ra   	
  #$a1 = coordinate
resume_display:
	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	lw $a2, COLOR_GREEN
	la $a0, letter_R
	addi $a1, $a1, 0
	jal draw_single_letter
	
	la $a0, letter_E
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_S
	addi $a1, $a1, 16
	jal draw_single_letter
	
	la $a0, letter_U
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_M
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_E
	addi $a1, $a1, 24
	jal draw_single_letter
	
	jal resume_icon_display
	
	lw $ra, 0($sp) 
	lw $a0, 4($sp)
	lw $a1, 8($sp)     
    	addi $sp, $sp, 16  
    	jr $ra
resume_icon_display:
	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	li $t2, 3
	res_icon_loop:


	lw $a2, COLOR_GREEN
	la $a0, _6x1_bar
	addi $a1, $a1, -1328
	jal draw_single_letter
	
 	addi $a1, $a1, 132
	sw $a2, 0($a1)
	addi $a1, $a1, 128
	sw $a2, 0($a1)
	addi $a1, $a1, 4
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	addi $a1, $a1, 4
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	
	lw $a2, COLOR_LIGHT_GREEN
	addi $a1, $a1, -120
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1) 	
		
	li $v0, 32
	li $a0, 360
	syscall
	addi $t2, $t2, -1
	beqz $t2, exit_res_icon_loop
	
	
	add $a1, $a1, 560
	lw $a2, COLOR_BG
	la $a0, _6x1_bar
	addi $a1, $a1, -1328
	jal draw_single_letter
	
 	addi $a1, $a1, 132
	sw $a2, 0($a1)
	addi $a1, $a1, 128
	sw $a2, 0($a1)
	addi $a1, $a1, 4
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	addi $a1, $a1, 4
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	
	addi $a1, $a1, -120
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1)
	addi $a1, $a1, 124
	sw $a2, 0($a1) 	
	
	li $v0, 32
	li $a0, 360
	syscall
	
	add $a1, $a1, 560

	
	j res_icon_loop
	exit_res_icon_loop:
	
	lw $ra, 0($sp) 
	lw $a1, 4($sp)
	lw $a2, 8($sp)     
    	addi $sp, $sp, 16  
    	jr $ra
   
gg_display:
	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a0, 8($sp)
	
	#lw $a2, COLOR_RED
	la $a0, letter_G
	addi $a1, $a1, 0
	jal draw_single_letter
	
	la $a0, letter_A
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_M
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_E
	addi $a1, $a1, 24
	jal draw_single_letter
	
	addi $a1, $a1, 832 # 22x128, move down by 22 units
	
	la $a0, letter_O
	addi $a1, $a1, 0
	jal draw_single_letter
	
	la $a0, letter_V
	addi $a1, $a1, 20
	jal draw_single_letter
	
	la $a0, letter_E
	addi $a1, $a1, 24
	jal draw_single_letter
	
	la $a0, letter_R
	addi $a1, $a1, 16
	jal draw_single_letter
	
	lw $a1, 4($sp)
	lw $ra, 0($sp)      
	lw $a0, 8($sp)
    	addi $sp, $sp, 16  
    	jr $ra

gg_fall:
	addi $sp, $sp, -16	
	sw $ra, 0($sp)
	sw $t6, 4($sp)
	
	addi $t6, $0, 64
	addi $t5, $0, 2
	gg_fall_loop:
 		beqz $t6, gg_fall_loop_exit
 		bnez $t5, skip_doodle_fall
		addi $s3, $s3, -128
		addi $t5, $0, 2
		skip_doodle_fall:
		 
 		addi $a0, $0, -1
 		jal scroll_platform
 		jal draw
 			
 		addi $t6, $t6, -1
 		addi $t5, $t5, -1
 		li $v0, 32
  		li $a0, 5
  		syscall
  		
 	j gg_fall_loop
 	
 	gg_fall_loop_exit:
 		
	addi $t5, $t0, 8064
 	doodle_to_bot_loop:
 		bge $s3, $t5, doodle_to_bot_loop_exit
		addi $s3, $s3, 128
		li $v0, 32
  		li $a0, 7
  		syscall
		jal draw
		j doodle_to_bot_loop
	doodle_to_bot_loop_exit:
 	
 	lw $t6, 4($sp)
	lw $ra, 0($sp)      
    	addi $sp, $sp, 16  
    	jr $ra
    	



draw_doodle:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $s0, COLOR_BG
	la $t4, prevDoodlePos
	lw $t3, 0($t4)
		
	sw $s0, 0($t3)
	sw $s0, 8($t3)
	sw $s0, 16($t3)
	sw $s0, -128($t3)
	sw $s0, -124($t3)
	sw $s0, -120($t3)
	sw $s0, -116($t3)
	sw $s0, -112($t3)
	sw $s0, -256($t3)
	sw $s0, -252($t3)
	sw $s0, -248($t3)
	sw $s0, -244($t3)
	sw $s0, -240($t3)	#
	sw $s0, -372($t3)
	sw $s0, -384($t3)
	sw $s0, -504($t3)
	sw $s0, -496($t3)
	sw $s0, -368($t3)
	sw $s0, -376($t3)
	sw $s0, -512($t3)
	
	sw $s0, -380($t3)
	
	lw $a0, shield_timer
	bltz $a0, skip_draw_shield
	la $a0, shield
	addi $a1, $t3,-776 #-3x4 - 6x128
	lw $a2, COLOR_BG
	jal draw_single_letter
	skip_draw_shield:
	
	
	lw $t2, face

	bnez $t2, skip_draw_left	#face right

	jal draw_doodle_left
	j skip_doodle_draw
	skip_draw_left:
	jal draw_doodle_right
	skip_doodle_draw:
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra
	
draw_doodle_right:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $s1, COLOR_DOODLE_BOOTS
	sw $s1, 0($s3)
	sw $s1, 8($s3)
	sw $s1, 16($s3)
	lw $s1, COLOR_YELLOW
	sw $s1, -128($s3)
	sw $s1, -124($s3)
	sw $s1, -120($s3)
	sw $s1, -116($s3)
	sw $s1, -112($s3)
	sw $s1, -256($s3)
	sw $s1, -252($s3)
	sw $s1, -248($s3)
	sw $s1, -244($s3)
	sw $s1, -240($s3)	##
	sw $s1, -372($s3)
	sw $s1, -384($s3)
	sw $s1, -504($s3)
	sw $s1, -496($s3)
	lw $s1, COLOR_BLACK
	sw $s1, -368($s3)
	sw $s1, -376($s3)
	lw $s1, COLOR_DARK_ORANGE
	sw $s1, -512($s3)
	
	lw $a0, shield_timer
	blez $a0, skip_draw_shield1
	la $a0, shield
	addi $a1, $s3,-776 #-3x4 - 7x128
	lw $a2, COLOR_SHIELD
	jal draw_single_letter
	skip_draw_shield1:
	
	sw $s3, 0($t4)
	
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra
	
draw_doodle_left:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $s1, COLOR_DOODLE_BOOTS
	sw $s1, 0($s3)
	sw $s1, 8($s3)
	sw $s1, 16($s3)
	
	lw $s1, COLOR_YELLOW
	sw $s1, -128($s3)
	sw $s1, -124($s3)
	sw $s1, -120($s3)
	sw $s1, -116($s3)
	sw $s1, -112($s3)
	sw $s1, -256($s3)
	sw $s1, -252($s3)
	sw $s1, -248($s3)
	sw $s1, -244($s3)
	sw $s1, -240($s3)
	sw $s1, -368($s3)
	sw $s1, -380($s3)
	sw $s1, -504($s3)
	sw $s1, -512($s3)
	lw $s1, COLOR_BLACK
	sw $s1, -384($s3)
	sw $s1, -376($s3)
	lw $s1, COLOR_DARK_ORANGE
	sw $s1, -496($s3)
	
	lw $a0, shield_timer
	blez $a0, skip_draw_shield2
	la $a0, shield
	addi $a1, $s3,-776 #-3x4 - 7x128
	lw $a2, COLOR_SHIELD
	jal draw_single_letter
	skip_draw_shield2:
	
	sw $s3, 0($t4)
	
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra
	
draw_scoreboard:
	addi $sp, $sp, -4 	
	sw $ra, 0($sp)
	
	
	lw $t1, currScore
	lw $t2, prevScore
	beq $t1, $t2, skip_score_reset
	sw $t1, prevScore
	
	beq $t1, 2000, difficulty4_call
	beq $t1, 1000, difficulty3_call
	beq $t1, 500, difficulty2_call
	beq $t1, 300, difficulty1_call
	j skip_diff_change
	
	difficulty4_call:
	jal to_difficulty_4
	j skip_diff_change
	
	difficulty3_call:
	jal to_difficulty_3
	j skip_diff_change
	
	difficulty2_call:
	jal to_difficulty_2
	j skip_diff_change
	
	difficulty1_call:
	jal to_difficulty_1
	skip_diff_change:
	
	
	blt $t1, 10, erase_units
	blt $t1, 100, erase_tens
	blt $t1, 1000, erase_hundreds
	blt $t1, 10000, erase_thousands
	blt $t1, 100000, erase_tenthousands
	
	lw $a2, COLOR_BG
	li $a1, 888888
	addi $a0, $t0, 192
	jal draw_numbers
	li $a1, 111111
	addi $a0, $t0, 192
	j start_draw_scoreboard
	
	erase_tenthousands:
	lw $a2, COLOR_BG
	li $a1, 88888
	addi $a0, $t0, 192
	jal draw_numbers
	li $a1, 11111
	addi $a0, $t0, 192
	j start_draw_scoreboard
	
	erase_thousands:
	lw $a2, COLOR_BG
	li $a1, 8888
	addi $a0, $t0, 192
	jal draw_numbers
	li $a1, 1111
	addi $a0, $t0, 192
	j start_draw_scoreboard
	
	erase_hundreds:
	lw $a2, COLOR_BG
	li $a1, 888
	addi $a0, $t0, 192
	jal draw_numbers
	li $a1, 111
	addi $a0, $t0, 192
	j start_draw_scoreboard
	
	erase_tens:
	lw $a2, COLOR_BG
	li $a1, 88
	addi $a0, $t0, 192
	jal draw_numbers
	li $a1, 11
	addi $a0, $t0, 192
	j start_draw_scoreboard
	
	erase_units:
	lw $a2, COLOR_BG
	li $a1, 8
	addi $a0, $t0, 192
	jal draw_numbers
	li $a1, 1
	addi $a0, $t0, 192
	j start_draw_scoreboard
	
	
	start_draw_scoreboard:
	jal draw_numbers
	
	skip_score_reset:
	lw $a1, currScore
	lw $a2, COLOR_GREEN
	addi $a0, $t0, 192
	jal draw_numbers
	
	lw $ra, 0($sp)        
    	addi $sp, $sp, 4     
	jr $ra
	
to_difficulty_0:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, 6	# no traps
	sw $v0,	TRAP_GENERATOR_K
	li $v0, 20
	sw $v0, JUMP_HEIGHT
	li $v0, 10
	sw $v0, PLAT_LEN_K
	li $v0, 8
	sw $v0, PLAT_MIN_DISTANCE
	li $v0, 4
	sw $v0, MV_SPEED
	li $v0, 15
	sw $v0, PLAT_GENERATOR_K
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra

to_difficulty_1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 3	# some traps
	sw $v0,	TRAP_GENERATOR_K
	li $v0, 8
	sw $v0,	PLAT_LEN_K
	li $v0, 10
	sw $v0, PLAT_MIN_DISTANCE
	li $v0, 4
	sw $v0, MV_SPEED
	li $v0, 9
	sw $v0, PLAT_GENERATOR_K
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra

to_difficulty_2:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 2	# more traps
	sw $v0,	TRAP_GENERATOR_K
	li $v0, 8
	sw $v0,PLAT_LEN_K
	li $v0, 11
	sw $v0, PLAT_MIN_DISTANCE
	li $v0, 3
	sw $v0, MV_SPEED
	li $v0, 6
	sw $v0, PLAT_GENERATOR_K
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra
to_difficulty_3:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 27
	sw $v0, JUMP_HEIGHT
	li $v0, 1	# more traps
	sw $v0,	TRAP_GENERATOR_K
	li $v0, 8
	sw $v0,PLAT_LEN_K
	li $v0, 12
	sw $v0, PLAT_MIN_DISTANCE
	li $v0, 3
	sw $v0, MV_SPEED
	li $v0, 4
	sw $v0, PLAT_GENERATOR_K
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra
	
to_difficulty_4:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 1	# more traps
	sw $v0,	TRAP_GENERATOR_K
	li $v0, 12
	sw $v0, STEP_LEN
	li $v0, 8
	sw $v0,PLAT_LEN_K
	li $v0, 12
	sw $v0, PLAT_MIN_DISTANCE
	li $v0, 2
	sw $v0, MV_SPEED
	li $v0, 3
	sw $v0, PLAT_GENERATOR_K
	lw $ra, 0($sp)  
    	addi $sp, $sp, 4
    	
	jr $ra
game_over:
	li $v0, 4
	la $a0, PROMPT_GG
	syscall
	
	gg_remove_loop:
	lw $t1, plat_list
	
	add $t2, $t0, 8192
	blt $t1, $t2, gg_remove_loop_exit
	jal remove_lowest_platform
	j gg_remove_loop
	gg_remove_loop_exit:
	jal gg_fall
	
	gg_display_loop:
		lw $t8, 0xffff0000 
		bne $t8, 1, skip_gg_keyboard_input
		
		lw $t1, 0xffff0004
		beq $t1, 0x73, s_call	# if key S pressed, jump back to main (restart the game)
		skip_gg_keyboard_input:
		
		addi $a1, $t0, 2844 # 22x128 + 24
		lw $a2, COLOR_RED
  		jal gg_display
  		
		li $v0, 32
  		li $a0, 150
  		syscall
  		
  		addi $a1, $t0, 2844 # 22x128 + 24
		lw $a2, COLOR_BG
  		jal gg_display
 		
  		
  		addi $a1, $t0, 2844 # 22x128 + 24
  		addi $a1, $a1, 128
		lw $a2, COLOR_RED
  		jal gg_display
  		
  		li $v0, 32
  		li $a0, 150
  		syscall
  		
  		addi $a1, $t0, 2844 # 22x128 + 24
  		addi $a1, $a1, 128
		lw $a2, COLOR_BG
  		jal gg_display
	j gg_display_loop
	
	s_call:
	j main
