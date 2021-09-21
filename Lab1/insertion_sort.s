			;##########################################
			;		Lab 01 skeleton
			;##########################################
			
data_to_sort	dcd		34, 23, 22, 8, 50, 74, 2, 1, 17, 40
list_elements	dcd		10
			
main			ldr		r3, =data_to_sort   ; Load the starting address of the first element of the array of numbers into r3
			ldr		r4, =list_elements  ; address of number of elements in the list
			ldr		r4, [r4]            ; number of elements in the list
			
			
			add		r5, r3, #400	 	; location of first element of linked list - "head pointer"
			;		(note that I assume it is at a "random" location beyond the end of the array.)
			
			
			;#################################################################################
			;		Include any setup code here prior to loop that loads data elements in array
			;#################################################################################
			
			;		SETUP HEAD ELEMENT ;
			
			mov		r6, r5			; r6 = r5, use r6 to move around in the future.
			mov		r7, r5			; r7 = r5, used to keep track of previous elements. 	NOTE: MAY REMOVE THESE BECAUSE OF r0, r1, r2
			ldr		r8, [r3]			; r8 = [r3] put the first element of the array in r8
			str		r8, [r6, #4]		; M[r6+4] = r8, put data into first element
			
			;#################################################################################
			;		Start a loop here to load elements in the array and add them to a linked list
			;#################################################################################
			add		r6, r6, #32         
			; 		every time you create a new struct, add 32 to
			;		starting address of last struct to mimic
			;		non-contiguous memory locations
			;		I assume address of last struct is in r6
			;		you DO NOT need to make this assumption
			
			;		INSERT NEXT ELEMENT AS A TEST ;
			
			mov		r0, r7			; r0 = r7, setup arguments for call (previous element)
			ldr		r2, [r3, #4]		; r2 = M[r3+1],  data for element
			mov		r1, #0			; r1 = r6, next element
			
			bl		insert			; test call for insert function
			
			add		r1, r1, #32		; filler test instruction (r1 += 32)
			
			b		finish			; end program
			;#################################################################################
			;		Add insert, swap, delete functions
			;#################################################################################
			
insert		; 		Inserts an element into a linked list
			;		This function takes arguments r0, r1, and r1
			;		r0: address of previous element
			;		r1: address of next element
			;		r2: data of element
			;		The element's address should be in r6.
			
			str		r0, [r6]			; M[r6] = r0, stores the previous address in the element
			str		r2, [r6, #4]		; M[r6+1] = r2, stores the data in the element
			str		r1, [r6, #8]		; M[r6+2] = r1, stores the next address in the element
			str		r6, [r0, #8]		; M[r0+2] = r6, stores the element's address in the previous element
			cmp		r1, #0			; checks if r1 == 0, if it is that means there is no next element
			strne	r6, [r1]			; M[r1] = r6, stores the element's address in the next element, but only if there is a next element.
			
			mov		r15, r14			; return to call test
			
finish
			end
