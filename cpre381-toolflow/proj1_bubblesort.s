  #bubblesort tests for proc
  #$a0 = a[]
  #$a1 = n

  addi    $t8, $a0        #ptr:   original pointer to a
  addi    $t7, $zero, 0   #bool:  swapped
  addi    $t6, $zero, 0   #int:   i

whileloop:
  slt   $t9, $t6, $a1
  bne   $t9, 1, whiledone
  


swapif:
	  lw    $t0, 0($t8)
	  lw    $t1, 4($t8)
	  slt   $t2, $t1, $t0
	  beq   $t2, $zero, else
	  sw    $t0, 4($t8)
	  sw    $t1, 0($a8)
	  addi  $t7, $zero, 1
	  jr    whileloop
else:
	  addi  $t7, $zero, 0
	  j     whileloop

whiledone:
    
