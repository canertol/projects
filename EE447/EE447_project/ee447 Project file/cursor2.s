;*************************************************************** 
; cursor.s  
; This program gets (X,Y) coordinates from R7 and R8. 
; Displays the cursor on the screen according to (X,Y).
;***************************************************************	
;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL			DIRECTIVE	VALUE		COMMENT
DC            	EQU  0x40004100 
SSI0_SR_R       EQU  0x4000800C 
SSI0_DR_R       EQU  0x40008008 
X				EQU  0x87
Y				EQU  0x41
memory			EQU	 0x20000400
offset_memory	EQU  0x20000500
;***************************************************************
; Program section					      
;***************************************************************
;LABEL			DIRECTIVE	VALUE	   	COMMENT
                AREA    	main, READONLY, CODE
                THUMB
                EXPORT    	cursor2		; Make available
              
cursor2
                PUSH {R0-R12,LR}
				LSR R12, #7				
				MOV	R1, #8
				UDIV R0, R12, R1
				MUL	R1, R0
				SUB	R0, R12, R1
				CMP R0, #2
				BEQ.W	finish
				CMP R0, #3
				BEQ.W finish
				CMP R0, #4
				BEQ.W finish
				CMP R0, #5
				BEQ.W case_four
				CMP R0, #6
				BEQ.W case_five
				CMP R0, #7
				BEQ.W case_six
				CMP R0, #0
				BEQ.W case_seven
				CMP R0, #1
				BEQ.W finish
				
				B   finish

cursor_line       
		
 
case_four     	MOV32 R0, SSI0_SR_R
                LDR R1, [R0]
                ANDS R1, R1, #0x10
				BNE case_four
				MOV32 R0, DC 			      ;dc_command  
                MOV R1, #0x40		      	; make DC 1
                STR R1, [R0]
              ; sent
                MOV32 R0, SSI0_DR_R ;     0 0 0 1 0 0 0
                MOV R1, #0x0
                STR R1, [R0]
                MOV R1, #0x0
                STR R1, [R0]
                MOV R1, #0x1
                STR R1, [R0]
                MOV R1, #0x0
                STR R1, [R0]
                MOV R1, #0x0
                STR R1, [R0]
				
				B finish	
				
                                  
case_five     	MOV32 R0, SSI0_SR_R
                LDR R1, [R0]
                ANDS R1, R1, #0x10
				BNE case_five
				MOV32 R0, DC 			      ;dc_command  
                MOV R1, #0x40		      	; make DC 1
                STR R1, [R0]
              ; sent
                MOV32 R0, SSI0_DR_R ;      0 0 3 0 0 
                MOV R1, #0x0
                STR R1, [R0]
                MOV R1, #0x0
                STR R1, [R0]
                MOV R1, #0x3
                STR R1, [R0]
                MOV R1, #0x0
                STR R1, [R0]
                MOV R1, #0x0
                STR R1, [R0]
				
				B finish					
				
				
case_six    	MOV32 R0, SSI0_SR_R
                LDR R1, [R0]
                ANDS R1, R1, #0x10
				BNE case_six
				MOV32 R0, DC 			      ;dc_command  
                MOV R1, #0x40		      	; make DC 1
                STR R1, [R0]
              ; sent
                MOV32 R0, SSI0_DR_R;     1 1 0 D 0 1 1
                MOV R1, #0x1
                STR R1, [R0]
                MOV R1, #0x1
                STR R1, [R0]
                MOV R1, #0x7
                STR R1, [R0]
                MOV R1, #0x1
                STR R1, [R0]
                MOV R1, #0x1
                STR R1, [R0]
				
				B finish	
				
case_seven      MOV32 R0, SSI0_SR_R
                LDR R1, [R0]
                ANDS R1, R1, #0x10
				BNE case_seven
				MOV32 R0, DC 			      ;dc_command  
                MOV R1, #0x40		      	; make DC 1
                STR R1, [R0]
              ; sent
                MOV32 R0, SSI0_DR_R ;     2 2 0 1A 0 2 2
                MOV R1, #0x2
                STR R1, [R0]
case_seven1      MOV32 R0, SSI0_SR_R
                LDR R1, [R0]
                ANDS R1, R1, #0x10
				BNE case_seven1
                MOV R1, #0x2
                STR R1, [R0]
case_seven2      MOV32 R0, SSI0_SR_R
                LDR R1, [R0]
                ANDS R1, R1, #0x10
				BNE case_seven2
                MOV R1, #0xF
                STR R1, [R0]
                MOV R1, #0x2
case_seven3     MOV32 R0, SSI0_SR_R
                LDR R1, [R0]
                ANDS R1, R1, #0x10
				BNE case_seven3
                STR R1, [R0]
                MOV R1, #0x2
				
				B finish					
				
;case_eight      MOV32 R0, SSI0_SR_R
;                LDR R1, [R0]
;                AND R1, #0x10
;                CMP R1, #0x10
;                BEQ case_eight
;              ; sent
;                MOV32 R0, SSI0_DR_R ;     4 4 0 35 0 4 4
;                MOV R1, #0x4
;                STR R1, [R0]
;                MOV R1, #0x4
;                STR R1, [R0]
;                MOV R1, #0x1F
;                STR R1, [R0]
;                MOV R1, #0x4
;                STR R1, [R0]
;                MOV R1, #0x4
;                STR R1, [R0]
;				
;				B finish	


				POP {LR}
				BX LR
				
				
finish          POP {R0-R12,LR}
                BX  LR
				ALIGN
                END
