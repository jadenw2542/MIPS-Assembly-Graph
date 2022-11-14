############## JADEN WONG ##############
############## JADWONG #################
############## 113469617 ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person:	
 addi $sp, $sp, -36
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 move $s0, $a0 # $s0 = Network Starting adress
 lw $s1, 0($s0)# $s1 = total nodes
 addi $s0, $s0, 4
 lw $s2, 0($s0) # $s2 = total edges
 addi $s0, $s0, 4
 lw $s3, 0($s0) # $s3 = size of node
 addi $s0, $s0, 8
 lw $s4, 0($s0) # $s4 = curr num_of_nodes
 
 mult $s4, $s3 # size of node * curr_num_of_nodes = bytes to move to get to empty space
 mflo $t0
 
 beq $s1, $s4, node_capacity_full
 addi $s4, $s4, 1
 sw $s4, 0($s0)
 
 addi $s0, $s0, 8 #$s0 at starting address of nodes
 add $s0, $s0, $t0 # move to where we want to create person
 move $s5, $s0 #save address of new person to $s5 to be returned
 
 move $t0, $s3 #counter for how many 0s to fill
 create_person_node:
 	beqz $t0, create_person_node_exit
 	sb $0, 0($s0) # store 0 at current byte
 	addi $s0, $s0, 1 #go to next byte
 	addi $t0, $t0, -1
 	j create_person_node
 
 node_capacity_full:
 li $v0, -1
 j create_person_terminate
 
 create_person_node_exit:
 
 create_person_terminate:
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 36
 jr $ra

.globl add_person_property 
add_person_property: #int add_person_property(Network* ntwrk, Node* person, char* prop_name, char* prop_val)
 addi $sp, $sp, -36
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 move $s0, $a0 # $s0 = Network address
 move $s1, $a1 # $s1 = reference to person node
 move $s2, $a2 # $s2 = property name(null_terminated string), 
 move $s3, $a3 # $s3 = property value (null_termianted string) used to replace 
 move $t0, $s0
 lw $s4, 0($t0) # $s4 =  total_nodes
 addi $t0, $t0, 8
 lw $s5, 0($t0) # $s5 = size of node
 addi $t0, $t0, 8
 lw $s6, 0($t0) # $s6 = curr_num_of_nodes
 
 #prop_val is unique in the Network.(check if prop_val already exists or not
 
 move $a0, $s0 # a0 = network addres
 move $a1, $s3 # a1 = prop_val
 
 jal get_person
 beqz $v0, prop_val_is_unique #if $v0 = 0, continue, else return 0 because prop_val exists in buffer
 li $v0, 0 #return value
 j add_person_property_terminate
 prop_val_is_unique:
 
 #The length of prop_val (excluding null character) <= Network.size_of_node
 move $t0, $s3 # $t0 = address of prop_val
 li $t2, 0 # $t2 = counter for num of chars in prop_val
 
 lb $t1, 0($t0)

 prop_val_length_loop:
 	beqz $t1, prop_val_length_loop_end
  	
  	addi $t2, $t2, 1 #increment counter
  	addi $t0, $t0, 1 # go to next byte
 	lb $t1, 0($t0)
 	j prop_val_length_loop
 
 prop_val_length_loop_end:
 bgt $t2, $s5, prop_val_too_long # if prop_val length > max size of node, terminate, else continue

 # person exists in Network check - if address is divisible by size of nodes, -24 first then check if divisible
 move $t0, $s0
 addi $t0, $t0, 24 #beginning of node[]
 move $t7, $s6
 addi $t7, $t7, -1 
 mult $s5, $t7 # size of nodes * curr_num_of_nodes
 mflo $t2 # $t2 = product
 add $t2, $t0, $t2 # $t2 = end of node[] where nodes exist
 
 bgt $s1, $t2, person_address_out_of_bounds
 blt $s1, $t0, person_address_out_of_bounds
 
 move $t3, $s1 #t3 = address of node*person
 li $t4, -1
 mult $t0, $t4 #node addess * -1
 mflo $t0
 add $t3, $t3, $t0 # address of node*person - node address
 #check if divisible by size of nodes
 div $t3, $s5
 mfhi $t5 # $t5 = remainder
 bnez $t5, person_address_out_of_bounds
 
 #prop_name is equal to the string constant “NAME”  N = 78 A = 65 M = 77 E = 69
 move $t0, $s2 # $t0 = address of prop_name(Should be NAME)
 lb $t1, 0($t0)
 li $t2, 78
 bne $t1, $t2, prop_name_not_NAME
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 65
 bne $t1, $t2, prop_name_not_NAME
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 77
 bne $t1, $t2, prop_name_not_NAME
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 69
 bne $t1, $t2, prop_name_not_NAME
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 0
 bne $t1, $t2, prop_name_not_NAME
 
 # this function should set the name of an existing person in the Network to the string prop_val if and only if:
 move $t0, $s1 #address of node person
 move $t1, $s3 #address of prop_val
 move $t3, $s5 # $t3 = size of node
 li $t4, 0 #num of chars in exisiting poerson
 lb $t2, 0($t1)
 
 add_person_property_to_network:
 	beqz $t2, person_added_to_network
 	
 	sb $t2, 0($t0)
 	addi $t0, $t0, 1 #incremetn
 	addi $t1, $t1, 1 #increment
 	addi $t4, $t4, 1 #incremnt size of chars
 	lb $t2, 0($t1)
 	j add_person_property_to_network
 
 person_added_to_network:
 
 person_added_padding: #padds string if length of person < max length of string
 	beq $t3, $t4, person_added_success #if size of node = curr num of chars of string in Network, return 1

 	sb $0, 0($t0)
 	addi $t0, $t0, 1
 	addi $t4, $t4, 1
 	j person_added_padding
 	
 	
 person_added_success:
 li $v0, 1
 j add_person_property_terminate
 
 prop_name_not_NAME:
  li $v0, 0 #return 0
 j add_person_property_terminate
 
 person_address_out_of_bounds:
 li $v0, 0 #return 0
 j add_person_property_terminate
 
 prop_val_too_long: # length of prop_val (excluding null character) > Network.size_of_node
 li $v0, 0 #return 0
 j add_person_property_terminate
 
 add_person_property_terminate:
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 36
 jr $ra

.globl get_person # Node* get_person(Network* network, char* name)
get_person:
 addi $sp, $sp, -36
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 move $s0, $a0 # $s0 = Start of Network adress
 move $s1, $a1 # $s1 = Start of reference to name we want
 lw $s2, 0($s0) # $s2 = total_nodes
 addi $s0, $s0, 8
 lw $s3, 0($s0) # $s3 = size_of_node
 addi $s0, $s0, 8
 lw $s4, 0($s0) # $s4 = cur_num_of_nodes
 addi $s0, $s0, 8 # $s0 = start of nodes(made of bytes)
 
 move $t0, $s1
 lb $t1, 0($t0)
 li $t2, 0 #counter for length of string
 get_person_query_check_length:
 	beqz $t1, get_person_query_check_length_exit
 	
 	addi $t2, $t2, 1
 	addi $t0, $t0, 1
 	lb $t1, 0($t0)
 	j get_person_query_check_length
 	
 get_person_query_check_length_exit:
 bgt $t2, $s3, get_person_query_not_found  # if size of string > size of node, error
 
 
 move $t0, $s4 # counter for cur_num_of_nodes
 get_person_query:
 	beqz $t0, get_person_query_not_found
 	
 	move $t2, $s0 # $t2 = save address of beginning of string, return if string  matches
 	move $t3, $s0 # $t3 = used to loop through string in Network
 	move $t4, $s1 # $t4 = address of string we want
 	
 	li $t8, 0 #counter for num of chars read
 	move $t1, $s3 # counter for size_of_node
	get_person_query_search:	 	
 		beqz $t1, get_person_query_found
 	
 		lb $t5, 0($t3)
 		lb $t6, 0($t4)
 		li $t7, 0
 		
 		#beq $t6, $t7, get_person_query_found #if char of string we want = string terminator, query_found
 		beq $t8, $s3, get_person_query_found

 		beq $t5, $t6, continue_query 
 		j query_next_string #if $t5 != $t6 check next string,else check next char
 		continue_query:
 		
 		addi $t3, $t3, 1
 		addi $t8, $t8, 1
 		
 		beq $t6, $t7, at_null_terminator
 		addi $t4, $t4, 1
 		at_null_terminator:
 		
 		addi $t1, $t1, -1
 	j get_person_query_search
 	
 	query_next_string:

 	add $s0, $s0, $s3 # go to next string 
 	addi $t0, $t0, -1
 j get_person_query
 
 
 get_person_query_found:
 move $v0, $t2
 j get_person_query_terminate
 
 get_person_query_not_found:
 li $v0, 0
 j get_person_query_terminate
 
 get_person_query_terminate:
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 36
 jr $ra

.globl add_relation #int add_relation(Network* ntwrk, char* name2, char* name2)
add_relation:
 addi $sp, $sp, -36
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 # total_edges, #size of node, curr_num_of_edges
 move $s0, $a0 # $s0 = network address
 move $s1, $a1 # $s1 = address of name 1
 move $s2, $a2 # $s2 = address of name 2
 move $t0, $s0 # $s0 = address of network
 lw $t1, 0($t0) # $t1 = total # of nodes
 addi $t0, $t0, 4
 lw $s3, 0($t0) # $s3 =  total edges max
 addi $t0, $t0, 4
 
 lw $t2, 0($t0) # $t2 = size of node
 mult $t1, $t2
 mflo $t1 # $t1 = num of bytes to skip
 addi $sp $sp, -4
 sw $t1, 0($sp) #store bytes to skip into stack
 
 addi $t0, $t0, 4
 lw $s4, 0($t0) # $s4 = size_of_edge
 addi $t0, $t0, 8
 lw $s5, 0($t0) # $s5 = curr_num_of_edges
 addi $t0, $t0, 8 #$t0 at start of edge list
 
 #If no person with name1 exists in the network, or
 move $a0, $s0
 move $a1, $s1
 jal get_person # Node* get_person(Network* network, char* name)
 beq $v0, $0, add_relation_failed #if $v0 = 0, return 0
 move $s6, $v0 # $s6 = referene to name 1
 
 #If no person with name2 exists in the network, or
 move $a0, $s0
 move $a1, $s2
 jal get_person # Node* get_person(Network* network, char* name)
 beq $v0, $0, add_relation_failed #if $v0 = 0, return 0
 move $s7, $v0 # $s7 = referene to name 2
 
 #The network is at capacity, that is, it already contains the maximum no. of edges possible
 beq $s3, $s5, add_relation_failed
 
 #name1 == name2. A person cannot be related to themselves.
 beq $s6, $s7, add_relation_failed # if addresses are the same, error

 
 #A relation between a person with name1 and a person with name2 already exists in the network. Relations must be unique
 # double loop- loop through size, check if edge has (name1,name2, x) or (name2,name1, x)
 
 
 lw $t1, 0($sp) # resstore bytes to skip into stack into $t1
 
 #(name1,name2, x)
 move $t0, $s0
 addi $t0, $t0, 24
 add $t0, $t0, $t1 # $t0 = start of node[]
 
 move $t2, $s5 # $t2 = curr_num_of_edges 
 add_relation_n1_n2:
 	beqz $t2, add_relation_n1_n2_not_found
 	lw $t3, 0($t0) #$t3 = p1
 	
 	beq $t3, $s6, add_relation_check_n1_n2 # if address = n1
 	j add_relation_check_n2
 	add_relation_check_n1_n2:
 		move $t4, $t0
 		addi $t4, $t4, 4
 		lw $t5, 0($t4)
 		beq $s7, $t5, add_relation_failed  # if second p2 = 2nd address, error
 		
 	
 	add_relation_check_n2:
 	beq $t3, $s7, add_relation_check_n2_n1 # if address = n2
 	j add_relation_loop
 	add_relation_check_n2_n1:
 		move $t4, $t0,
 		addi $t4, $t4, 4
 		lw $t5, 0($t4)
 		beq $s6, $t5, add_relation_failed  # if second p2 = 1std address, error
 	
 	
 	
 	add_relation_loop:
 	
 	add $t0, $t0, $s4 #incrmetn $t0 by size of edgessss
 	addi $t2, $t2, -1
	j add_relation_n1_n2
 
 add_relation_n1_n2_not_found: #adding relation to edge[] *incremnt current # of edges 
 
 move $t0, $s0
 addi $t0, $t0, 24
 add $t0, $t0, $t1 # $t0 = start of node[]
 mult $s5, $s4 # size of node * cur # of edges
 mflo $t2 
 add $t0, $t0, $t2 # $t0 at empty edge[] index
 sw $s6, 0($t0)
 addi $t0, $t0, 4
 sw $s7, 0($t0)
 addi $t0, $t0, 4
 sw $0, 0($t0)
 
 #curr_num_of_edges + 1
 move $t0, $s0 
 addi $t0, $t0, 20
 addi $s5, $s5, 1
 sw $s5, 0($t0) # $s4 = curr num_of_nodes
 
 add_relation_success:
 li $v0, 1		
 j add_relation_terminate	
 
 
 add_relation_failed:
 li $v0, 0
 j add_relation_terminate
 
 
 
 add_relation_terminate:
 addi $sp $sp, 4 #$t1 = # of bytes to skip from node[] address
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 36
 jr $ra

.globl add_relation_property #int add_relation_property(Network* ntwrk, char* name1, char* name2, char* prop_name, int prop_val)
add_relation_property: #int add_relation_property(Network* ntwrk, char* name1, char* name2, char* prop_name, int prop_val)

 lw $t0, 0($sp) #$t0 = prop_val
 
 addi $sp, $sp, -36
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
  #The argument prop_val == 1.
 li $t1, 1
 bne $t0, $t1, add_relation_property_fail
 
 move $s0, $a0 # $s0 = network address
 move $s1, $a1 # $s1 = name 1
 move $s2, $a2 # $s2 = name 2
 
 #the argument prop_name == “FRIEND”  70, 82, 73, 69, 78, 68
 move $t0, $a3
 lb $t1, 0($t0)
 li $t2, 70
 bne $t1, $t2, add_relation_property_fail
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 82
 bne $t1, $t2, add_relation_property_fail
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 73
 bne $t1, $t2, add_relation_property_fail
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 69
 bne $t1, $t2, add_relation_property_fail
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 78
 bne $t1, $t2, add_relation_property_fail
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 li $t2, 68
 bne $t1, $t2, add_relation_property_fail
 addi $t0, $t0, 1
 
 lb $t1, 0($t0)
 bne $t1, $0, add_relation_property_fail
 
 
 
 move $t0, $s0 #$t0 = network address
 lw $t1, 0($t0)  #$t1 = max no. of nodes in the network
 addi $t0, $t0, 4 
 lw $s3, 0($t0) #$s3 =max no. of edges in the network
 addi $t0, $t0, 4
 lw $t2, 0 ($t0) #$t2 = The size of a node
 addi $t0, $t0, 4
 lw $s4, 0($t0) # $s4 = size_of_edge
 addi $t0, $t0, 8
 lw $s5, 0($t0) # $s5 = curr_num_of_edges
 addi $t0, $t0, 4
 mult $t1, $t2 
 mflo $t1 #$t1 = number of bytes to skip from start of node[]
 add $t0, $t0, $t1 # $t0 = start of edge[]
 move $s6, $t0
 
 
 #get length of both strings
 li $t6, 0 #counter of p1
 move $t7, $s1
 length_of_p1:
 	lb $t8, 0($t7)
 	beqz $t8, length_of_p1_exit
 	addi $t7, $t7,1
 	addi $t6, $t6, 1
 	j length_of_p1
 length_of_p1_exit:
 
 li $t9, 0 #counter of p2
 move $t7, $s2
 length_of_p2:
 	lb $t8, 0($t7)
 	beqz $t8, length_of_p2_exit
 	addi $t7, $t7,1
 	addi $t9, $t9, 1
 	j length_of_p2
 length_of_p2_exit:
 addi $s4, $0, 0
 addi $sp, $sp, -8
 sw $t2, 0($sp)#counter 
 bgt $t6, $t2, add_relation_property_ignore_extra1 #if > greater thatn size of node
 bgt $t9, $t2, add_relation_property_ignore_extra2
 j add_relation_property_check_existence
 
 
 add_relation_property_ignore_extra1: #sets array of max_size_of node to $0
 move $t6, $s1
 add $t6, $t6, $t2
 lb $t7, 0($t6)
 sb $t7, 5($sp)
 
 sb $0, 0($t6)
 li $s4, 1 # 1 = ignore for p1
 bgt $t9, $t2, add_relation_property_ignore_extra_both
 
 add_relation_property_ignore_extra_both:
 li $s4, 3 # 3 = ignore for both
 
 add_relation_property_ignore_extra2: 
 move $t6, $s2
 add $t6, $t6, $t2
 lb $t7, 0($t6)
 sb $t7, 6($sp)
 
 sb $0, 0($t6)
 
 li $t7, 3
 beq $t7, $s4, add_relation_property_check_existence
 li $s4, 2 # 2 = ignore for p2
 
 
  #A relation between a person with name1 and person2 with name2 exists in the network, and
 add_relation_property_check_existence:
 
 move $a0, $s0 #a0 = network
 move $a1, $s1
 jal get_person
 beqz $v0, get_person_11
 j get_person_10
 get_person_11:
 addi $sp, $sp, 8 
 j add_relation_property_fail
 
 get_person_10:
 beqz $s4, add_relation_property_restore1
 li $t6, 2
 beq $t6, $s4, add_relation_property_restore1
 #restore last char
 lw $t2, 0($sp)#counter 
 move $t6, $s1
 add $t6, $t6, $t2
 lb $t9, 5($sp)
 sb $t9, 0($t6)
 add_relation_property_restore1:
 move $s1, $v0
 
 
 move $a0, $s0 #a0 = network
 move $a1, $s2
 jal get_person
 beqz $v0, get_person_21
 j get_person_20
 get_person_21:
 addi $sp, $sp, 8 
 j add_relation_property_fail
 
 get_person_20:
 
 
 beqz $s4, add_relation_property_restore2
 li $t6, 1
 beq $t6, $s4, add_relation_property_restore2
 #restore last char
 lw $t2, 0($sp)#counter
 move $t6, $s2
 add $t6, $t6, $t2
 lb $t9, 6($sp)
 sb $t9, 0($t6)

 add_relation_property_restore2:
 
 addi $sp, $sp, 8
 move $s2, $v0
 
 
 
 move $t2, $s5 # $t2 num times to loop(num of edges)
 add_relation_property_loop:
 	beqz $t2, add_relation_property_fail
 	
 	move $t3, $s6 # $t3 = $s6
 	lw $t4, 0($t3)
 	bne $t4, $s1 add_relation_property_n2#if = name 1
 		addi $t3, $t3, 4
 		lw $t4, 0($t3)
 		bne $t4, $s2, add_relation_property_n2 #if = name 2
 		addi $t3, $t3, 4 #store 1 into 3rd arg
 		li $t5, 1
 		sw $t5, 0($t3)
 		j add_relation_property_success
 		
 
 	
 	add_relation_property_n2:
 	move $t3, $s6
 	lw $t4, 0($t3)
 	bne $t4, $s2, add_relation_property_next_edge
 		addi $t3, $t3, 4
 		lw $t4, 0($t3)
 		bne $t4, $s1, add_relation_property_next_edge #if = name 2
 		addi $t3, $t3, 4 #store 1 into 3rd arg
 		li $t5, 1
 		sw $t5, 0($t3)
 		j add_relation_property_success
 
 
 
 	add_relation_property_next_edge:
 	addi $s6, $s6, 12 # address + size_of_edge
 	addi $t2, $t2, -1
 	j add_relation_property_loop


 
 add_relation_property_fail:
 li $t0, 0
 move $v0, $t0
 j add_relation_property_terminate
 
 add_relation_property_success:
 li $t0, 1
 move $v0, $t0

 
 add_relation_property_terminate:
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 36
 jr $ra

.globl is_a_distant_friend #int is_a_distant_friend(Network* ntwrk, char* name1, char* name2)
is_a_distant_friend: 
 addi $sp, $sp, -36
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 move $s0, $a0 #$a0 = network address
 move $s1, $a1 # $s1 = name 1
 move $s2, $a2 # $s2 =  name 2
 
 
 move $a0, $s0
 move $a1, $s1
 jal get_person
 beqz $v0, is_a_distant_friend_names_dont_exist
 move $s1, $v0 # $s1 = address name 1 in network
 
 move $a0, $s0
 move $a1, $s2
 jal get_person
 beqz $v0, is_a_distant_friend_names_dont_exist
 move $s2, $v0 # $s2 = address name 2 in network
 
 #get network edge[] address
 move $t0, $s0
 lw $t1, 0($t0) #$t1 = total # of nodes
 addi $t0, $t0, 8
 lw $t2, 0($t0) #$t2 = size of a node
 mult $t1, $t2  # size of node * total # of nodes
 mflo $t1
 move $t0, $s0
 addi $t0, $t0, 24
 add $t0, $t0, $t1
 move $s3, $t0 # $s3 = start of edge[] address
 
 li $s4, 1 #number of friends in stack
 li $s6, 1 # wheere in stack to look for edges
 
 addi $sp, $sp, -80
 sw $s1, 0($sp) # $p1 stored in stack
	 addi $sp, $sp, 80

 move $t0, $s0
 addi $t0, $t0, 20
 lw $s5, 0($t0)
 
 
 #helper function
 	help_loop:
 # li $s4, 1 #number of friends in stack
 #li $s6, 1 # wheere in stack to look for edges
 
 addi $sp, $sp, -80
 move $t5, $sp
 li $t6, 4
 mult $t6, $s6
 mflo $t7
 li $t6, -1
 mult $t6, $t7
 mflo $t7
 add $t5, $t5, $t7
 addi $t5, $t5, 4
 lw $t5, 0($t5)
 addi $sp, $sp, 80
 
 
 move $a0, $s3 # $a0 = edge[] address
 move $a1, $t5 # $a1 = p2
 move $a2, $s5 #$a2 = curr_num_of_edges (to be changed after helping function
 move $a3, $s4 # $a3 = num of friends in stack
 	jal helper_function
 
 beqz $v0, decrement_pointer
 add $s4, $s4, $v0 # increment total friends in stack
 move $s6, $s4
 j continue_loop
 
 decrement_pointer:
 addi $sp, $sp, -80
 move $t5, $sp
 li $t6, 4
 mult $t6, $s6
 mflo $t7
 li $t6, -1
 mult $t6, $t7
 mflo $t7
 add $t5, $t5, $t7
 lw $t5, 0($t5)
 addi $sp, $sp, 80
 
 beq $t5, $s2, check_if_edge_between
 
 addi $s6, $s6, -1
 li $t9,1
 beq $t9, $s6, is_a_distant_friend_false
 j continue_loop
 
 
 
 check_if_edge_between: #return 0 if there is a edgde between them(since they are not distant)
 move $t0, $s3 # $t0 = edge[] address
 move $t1, $s5 # $t1 = curr_num_of_edges (times to loop)
 find_edges_between:
	beqz $t1, is_a_distant_friend_true
	
	lw $t6, 0($t0)
	bne $t6, $s1, check_switch_arg
	lw $t7, 4($t0)
	bne $t7, $s2, check_switch_arg
	#return 0
	j is_a_distant_friend_false
	
	check_switch_arg:
	lw $t6, 0($t0)
	bne $t6, $s2, find_edges_between_continue
 	lw $t7, 0($t0)
 	bne $t7, $s1, find_edges_between_continue
 	#return 0
 	j is_a_distant_friend_false
	
	find_edges_between_continue:
	
 	addi $t1, $t1, -1 #decrement
 	addi $t0, $t0, 12 # go to next edge[] index
 	j find_edges_between
 
 continue_loop:


 j help_loop 
 # if num of friends = 0, then return 0
 
 break_out:
 
 
 
 
 
 
 is_a_distant_friend_true:
 li $v0, 1
 j is_a_distant_friend_terminate
 
 is_a_distant_friend_names_dont_exist:
 li $v0, -1
 j is_a_distant_friend_terminate
 
 is_a_distant_friend_false:
 li $v0, 0
 
 is_a_distant_friend_terminate:
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 36
 jr $ra

helper_function: # $a0 = edge[] address $a1 = node that we are looking for edges $a2 = curr_num_of_edges $a3 = counter of friend currently in stack
		#returns # of friends in stack
 addi $sp, $sp, -64
 sw $t0, 60($sp)
 sw $t1, 56($sp)
 sw $t2, 52($sp)
 sw $t3, 48($sp)
 sw $t4, 44($sp)
 sw $t5, 40($sp)
 sw $t6, 36($sp)
 sw $s0, 32($sp)
 sw $s1, 28($sp)
 sw $s2, 24($sp)
 sw $s3, 20($sp)
 sw $s4, 16($sp)
 sw $s5, 12($sp)
 sw $s6, 8($sp)
 sw $s7, 4($sp)
 sw $ra, 0($sp)
 
 move $s0, $a0 #$s0 = edge[] address
 move $s1, $a1 #  pointer(address) - loop through edges of pointer
 move $s2, $a2 # curr_num_of_edges
 move $s3, $a3 # counter of friend currently in stack
 addi $sp, $sp, -16 # $sp at start of stack of friends
 
 li $s5, 0 # $s5 = new things added to stack
 
 # set $t2 to where the pointer is
 #li $t0, 4
 #mult $t0, $s1
# mflo $t1
 #li $t0, -1
 #mult $t1, $t0
 #mflo $t0
 
 #move $t1, $sp
 #add $t1, $t1, $t0
 #lw $t2, 0($t1) #t2 = addresss - search edges of that address
 
 
 move $t2, $s1
 move $t0, $s0 # $t0 = edge[] address
 move $t1, $s2 # $t1 = curr_num_of_edges (times to loop)
 find_edges:
	beqz $t1, exit_helper
 	
 	
 	#checking if 1st arg is $t2
 	lw $t3, 0($t0) #t3 = 1st arg
 	bne $t3, $t2, check_second_arg
 	lw $t4, 4($t0) #t3 = 2 arg
 	lw $t5, 8($t0) #t3 = 3 arg
 	li $t6, 1
 	bne $t5, $t6, check_second_arg #check if friend
 	j check_if_duplicate
 	
  	
  	
  	check_second_arg:
  	lw $t3, 4($t0) #t3 = 2nd arg
 	bne $t3, $t2, check_next_index
 	lw $t4, 0($t0) #t3 = 1st arg
 	lw $t5, 8($t0) #t3 = 3 arg
 	li $t6, 1
 	bne $t5, $t6, check_next_index #check if friend
 	j check_if_duplicate
  	
 
 	check_if_duplicate: #checks stack for dups
 	move $t7, $s3 # $t7 = num of friends in stack
 	move $t8, $sp # $t8 = (sp address)
 		check_stack_for_dups:
 		beqz $t7, not_a_dup
 		lw $t9, 0($t8)
 		beq $t9, $t4, check_next_index
 		
 		addi $t7, $t7, -1
 		addi $t8, $t8, -4 #go next stack space
 		j check_stack_for_dups
 		
 		
 	not_a_dup: #add to stack 
 	sw $t4, 0($t8)
 	addi $s5, $s5, 1 #counter for number of friends added to stack in helpers
 	addi $s3, $s3, 1 # counter of total friend in stack
 	
 	check_next_index:
 addi $t1, $t1, -1 #decrement
 addi $t0, $t0, 12 # go to next edge[] index
 j find_edges
 
 
 exit_helper:
 move $v0, $s5
 
 helper_terminate:
 
 addi $sp, $sp, 16 # $sp at start of stack of friends
 lw $t0, 60($sp)
 lw $t1, 56($sp)
 lw $t2, 52($sp)
 lw $t3, 48($sp)
 lw $t4, 44($sp)
 lw $t5, 40($sp)
 lw $s0, 32($sp)
 lw $s1, 28($sp)
 lw $s2, 24($sp)
 lw $s3, 20($sp)
 lw $s4, 16($sp)
 lw $s5, 12($sp)
 lw $s6, 8($sp)
 lw $s7, 4($sp)
 lw $ra, 0($sp)
 addi $sp, $sp, 64
 jr $ra









