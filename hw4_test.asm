############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
############################ Add more names if needed ####################################
############################ Change network if needed ####################################
.data

Name1: .asciiz "abc" #97 98 99 abc
Name2: .asciiz "defg" #100 101 102 103  defg
Name3: .asciiz "Alit"
Name4: .asciiz "NAME"
Name5: .asciiz "JOHN"
Name: .asciiz "NAME"
FRIEND: .asciiz "FRIEND"


.align 2
Network:
  .word 5   #total_nodes
  .word 3  #total_edges
  .word 4   #size_of_node
  .word 12  #size_of_edges
  .word 4   #curr_num_of_nodes
  .word 2   #curr_num_of_edges
   # set of nodess
  .byte 65 65 0 0 97 98 99 0 100 101 102 103 0 0 0 0 1 2 3 4 
   # set of edges
  .word 1 2 3 268501060 268501056 0 7 8 9 # word 0 0 0 268501060 268501056 1 0 0 0 
.text
main:

    la $a0, Network
    la $a1, Name1
    la $a2, Name2
    la $a3, FRIEND
    li $t0, 1
        addi $sp, $sp, -4
        sw $t0, 0($sp)
        jal add_relation_property
        addi $sp, $sp, 4



    #la $a0, Network
    #la $a1, Network
    #addi $a1, $a1, 28 #268501044   28
    #la $a2, Name #constant "NAME"
    #la $a3, Name1 #Jane replacment
      #jal add_person_property 
      #move $s0, $v0        # return person

      #write test code



exit:
    li $v0, 10
    syscall
.include "hw4.asm"