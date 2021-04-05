  #bubblesort tests for proc
  #$a0 = a[]
  #$a1 = n
  
main:
  add	$a0, $gp, $zero
  addi	$a1, $zero, 5
  addi	$t1, $zero, 1
  sw	$t1, 0($a0)
  addi	$t1, $zero, 2
  sw	$t1, 4($a0)
  addi	$t1, $zero, 3
  sw	$t1, 8($a0)
  addi	$t1, $zero, 4
  sw	$t1, 12($a0)
  addi	$t1, $zero, 5
  sw	$t1, 16($a0)
  addi	$t1, $zero, 0
bubble:
  addi  $t8, $a0, 0     #ptr:     original pointer to a[]
  addi  $t7, $zero, 0   #bool:    swapped
  addi  $t6, $zero, 0   #int:     i

whileloop:
  slt   $t9, $t6, $a1
  bne   $t9, 1, whiledone
  
swapif:
	lw	$t0, 0($t8)             #load a = a[i]
	addi	$t0, $t0, 0
	lw	$t1, 4($t8)             #load b = a[i+1]
	addi	$t1, $t1, 0
	slt	$t2, $t1, $t0           #if a[i+1] < a[i]
	bne	$t2, 1, else        	#if a[i+1] > a[i], go to else
	sw	$t1, 0($t8)             #a[i]   = a[i+1]
	sw	$t0, 4($t8)             #a[i+1] = a[i]
	addi	$t7, $zero, 1           #set swapped to true
	j	preloop                 #go to preloop
else:
	addi  $t7, $zero, 0
	j     preloop
preloop:
  addi    $t6, $t6, 4           #i++
  addi    $t8, $t8, 4           #a[]++
  j       whileloop             #go back to loop
whiledone:
  lw	$t0, 0($a0)
  lw	$t1, 4($a0)
  lw	$t2, 8($a0)
  lw	$t3, 12($a0)
  lw	$t4, 16($a0)
