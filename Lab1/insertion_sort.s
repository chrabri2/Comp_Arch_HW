			;##########################################
			;		Lab 01 skeleton
			;##########################################
			
			
data_to_sort	dcd		34,23,22,8 ;34, 23, 22, 8, 50, 74, 2, 1, 17, 40	: TODO: restore original list
list_elements	dcd		4 ;10
			
main			ldr		r3, =data_to_sort   ; Load the starting address of the first element of the array of numbers into r3
			ldr		r4, =list_elements  ; address of number of elements in the list
			ldr		r4, [r4]            ; number of elements in the list
			
			add		r5, r3, #400	 	; location of first element of linked list - "head pointer"
			;		(note that I assume it is at a "random" location beyond the end of the array.)
			; Used registers: r3, r4, r5 (r0, r1, r2 are parameters)
			
			;Supposed	to call bt -> setup list?	; TODO: Remove this?
			;		Then sort here?
			;		Then call deletes from here?
			
			;#################################################################################
			;		Include any setup code here prior to loop that loads data elements in array
			;#################################################################################
			
			;		SETUP HEAD ELEMENT ;
			mov		r6, r5			; r6 = r5, use r6 to move around in the future.
			mov		r7, r5			; r7 = r5, used to keep track of previous elements. 	TODO: MAY REMOVE THESE BECAUSE OF r0, r1, r2
			ldr		r8, [r3]			; r8 = [r3] put the first element of the array in r8
			str		r8, [r6, #4]		; M[r6+4] = r8, put data into first element
			; Used registers: (r0 to r7)
			
			;#################################################################################
			;		Start a loop here to load elements in the array and add them to a linked list
			;#################################################################################
			add		r6, r6, #32	; Move from head to second element
			;		every time you create a new struct, add 32 to
			;		starting address of last struct to mimic
			;		non-contiguous memory locations
			;		I assume address of last struct is in r6
			;		you DO NOT need to make this assumption
			
			mov		r8, #4			; index for loop
			lsl		r9, r4, #2		; use r9 as a maxiumum for the loop
insrtloop		cmp		r8, r9			; See how many elements are left to add
			;
			bge		swaptest
			mov		r0, r7			; Put prev addr into r0
			ldr		r2, [r3, r8]			; Move current data into r2
			mov		r1, #0			; Move next addr into r1 (don't need this since always NULL, updated on future add???)
			bl		insert
			mov		r7, r6			; Move the prev location up by 32
			add		r6, r6, #32		; Set r6 to the next non-contiguous location
			add		r8, r8, #4		; Update remaining elements to be added
			b		insrtloop			; Loop back
			
			;;;;;;;;;;;;;;;	TESTING SWAP HERE
			;mov		r0, r5
swaptest		add		r0, r5, #32
			add		r1, r5, #64
			;ldr		r1, [r0, #8]
			bl		swap
			b		finish
			;;;;;;;;;;;;;;;;	TESTING SWAP HERE
			; Used registers: r0 to r5, r9, r10
			
			; Insertsort loop ;
insertsort	
			b		finish
			
			;#################################################################################
			;		Add insert, swap, delete functions
			;#################################################################################
			
insert		; 		Inserts an element into a linked list
			;		This function takes arguments r0, r1, and r2
			;		r0: address of previous element
			;		r1: address of next element
			;		r2: data of element
			;		The element's address should be in r6.
			str		r0, [r6]			; M[r6] = r0, stores the previous address in the element
			str		r2, [r6, #4]		; M[r6+1] = r2, stores the data in the element
			str		r1, [r6, #8]		; M[r6+2] = r1, stores the next address in the element
			str		r6, [r0, #8]		; M[r0+2] = r6, stores the element's address in the previous element's next
			mov		r15, r14			; return back to loop
			
			
			
			
swap			;		Swap elements in the linked list by changing prev and next pointer entries
			;		r0: (arg) address of a[j-1] (N)	Can be done with only one arg but it might be less readable
			;		r1: (arg) address of a[j]   (N+1)
			;		r2: holds address of (N-1)
			;		r9: holds address of (N+2)
			ldr		r2, [r0]			; Load address of (N-1)
			ldr		r9, [r1, #8]		; Load address of (N+2)
			
			;		At this point everything that could be needed is loaded set the pointers to N-1 and N+2 to 0 incase we
			;		have a head or tail, they will get corrected if they should
			mov		r10, #0
			str		r10, [r1]			; (N+1)(prev) = (N-1)
			str		r10, [r0, #8]		; (N)(next) = (N+2)
			
			cmp		r2, #0			; Check that there exists an element before N (not true for the head)
			beq		noprev			; Avoid accessing the prev of the head
			str		r1, [r2, #8]		; (N-1)(next) = (N+1)
			str		r2, [r1]			; (N+1)(prev) = (N-1)
			
noprev		cmp		r9, #0 			; Check that there exists an element after N+1 (not true for the tail)
			beq		nonext			; Avoid acessing the next of the tail
			str		r9, [r0, #8]		; (N)(next) = (N+2)
			str		r0, [r9]			; (N+2)(prev) = (N)
			
nonext		str		r1, [r0]			; (N)(prev) = (N+1)
			str		r0, [r1, #8]		; (N+1)(next) = (N)
			mov		r15, r14 			; return back
			
			;		TODO: Delete function
			
finish
			end


			; Updates: Added TODO markers
			; Fixed insertloop to not lose previous data and be more efficient
