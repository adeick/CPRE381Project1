swapif:
	  lw    $t0, 0($a0)
	  lw    $t1, 4($a0)
	  slt   $t2, $t1, $t0
	  beq   $t2, $zero, else
	  sw    $t0, 4($a0)
	  sw    $t1, 0($a0)
	  addi  $v0, $zero, 1
	  jr    $ra
else:
	  addi  $v0, $zero, 0
	  jr    $ra
