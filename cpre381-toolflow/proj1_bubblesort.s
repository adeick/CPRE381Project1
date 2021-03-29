  #bubblesort tests for proc
  #$a0 = a[]
  #$a1 = n

  addi    $t8, $a0, 0     #ptr:     original pointer to a[]
  addi    $t7, $zero, 0   #bool:    swapped
  addi    $t6, $zero, 0   #int:     i

whileloop:
  slt   $t9, $t6, $a1
  bne   $t9, 1, whiledone
  j     swapif
  
swapif:
	lw    $t0, 0($t8)             #load a = a[i]
	lw    $t1, 4($t8)             #load b = a[i+1]
	slt   $t2, $t1, $t0           #if a[i+1] < a[i]
	bne   $t2, $zero, else        #if a[i+1] > a[i], go to else
	sw    $t0, 4($t8)             #a[i+1] = a[i]
	sw    $t1, 0($t8)             #a[i]   = a[i+1]
	addi  $t7, $zero, 1           #set swapped to true
	j     preloop                 #go to preloop
else:
	addi  $t7, $zero, 0
	j     preloop
preloop:
  addi    $t6, $t6, 1           #i++
  addi    $t8, $t8, 1           #a[]++
  j       whileloop             #go back to loop
whiledone:
  
