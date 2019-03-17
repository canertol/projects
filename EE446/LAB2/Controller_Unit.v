module Controller_Unit #(parameter W=4)(CLK,
            AccRight, AccParallel, AccCLR, // Acc register control
            ALUCtrl, ASrc, BSrc,  // ALU Controllers
            Stat, NFlag,    // Status bits
            LOAD,R1m, R0m,
            COMP, R1Clr, R1Src, R0WE, R1WE, R0Src,
            OP,  //ALP Operation
				QParallel, QSrc, QnCLR, RST, QRight, QzSrc, Qn, Qz,
            CLR, // reset registers
            ERR // Arithmetic overflow
            
              );
     input CLK,  CLR;
     input LOAD, COMP;
     input [2:0] OP;
     input [1:0] Stat;
	  input R1m, R0m;
     output reg R1Clr=0, R1Src, R0WE=0, R1WE=0;
	  output reg [1:0] R0Src, ASrc, BSrc;
	  output reg [2:0] ALUCtrl;
     input NFlag , Qn, Qz;
     output reg ERR=0;
     output reg AccRight, AccParallel, AccCLR, QParallel, QSrc, QnCLR=0, RST=0, QRight, QzSrc;
     
     
	  parameter [4:0] ST0 =0, ST1=1, ST2=2, ST3=3, ST4 =4, ST5=5, ST6=6,
							ST7=7, ST8=8, ST9=9, ST10=10, ST11=11, ST12=12, ST13=13,
							ST14=14, ST15=15, ST16=16, ST17=17, ST18=18, ST19=19, ST20=20, ST21=21;
							
	  integer k=0, Count=W;
	  reg [1:0]r;
	  reg NS, CS;
	  
	  initial
	  begin
	  CS = ST0;
	  end
	  
	  always @(CS, CLR, ERR)
			begin : COMB
			NS = ST0;
			
			case(CS)
			ST0: begin
					if(LOAD && k==2 && COMP)
						case(OP)
							3'b000 : NS = ST1;
							3'b001 : NS = ST1;
							3'b010 : NS = ST2; 
							3'b011 : NS = ST3;
							3'b100 : NS = ST1;
							3'b101 : NS = ST1;
							3'b110 : NS = ST1;
							3'b111 : NS = ST1;
						endcase
					else
						NS = ST0;
				  end
				  
			ST1: begin
					NS = ST0;
				  end
				  
			ST2: begin
					case({Qz,Qn})
						2'b00 : NS = ST6;
						
						2'b01 : NS = ST4;
						
						2'b10 : NS = ST5;
						
						2'b11 : NS = ST6;
					
					endcase
				  end
				  
			ST3: begin
						if(R1m)
							NS = ST7;
						else if(R0m)
							NS = ST9;
						else if(NFlag)
							NS = ST12;
						else 
							NS = ST11;				
				  end
				  
			ST4: begin
					NS = ST5;
				  end
				  
			ST5: begin
					NS = ST0;
				  end
				  
			ST6: begin
						if(Count==0)
							NS = ST0;
						else
							case({Qz,Qn})
								2'b00 : NS = ST6;
								
								2'b01 : NS = ST4;
								
								2'b10 : NS = ST5;
								
								2'b11 : NS = ST6;
							
							endcase
				  end
				  
			ST7: begin
					NS = ST8;
				  end
				  
			ST8: begin
						if(R0m)
							NS = ST9;
						else if(NFlag)
							NS = ST12;
						else 
							NS = ST11;	
				  end
				  
			ST9: begin
					NS = ST10;
				  end
				  
			ST10: begin
						if(NFlag)
							NS = ST12;
						else 
							NS = ST11;	
				   end
				  
			ST11: begin
					NS = ST13;
				   end
				  
			ST12: begin
					NS = ST14;
				   end
				  
			ST13: begin
						if(NFlag)
							NS = ST16;
						else 
							NS = ST15;	
				   end
				  
			ST14: begin
						if(NFlag)
							NS = ST16;
						else 
							NS = ST15;	
				   end
				  
			ST15: begin
						if(Count==0)
							 begin
								if(NFlag)
									NS = ST17;
								else 
									NS = ST0;
							 end
						else
								if(NFlag)
									NS = ST12;
								else 
									NS = ST11;
				   end
				  
			ST16: begin
						if(Count==0)
							 begin
								if(NFlag)
									NS = ST17;
								else 
									NS = ST0;
							 end
						else
								if(NFlag)
									NS = ST12;
								else 
									NS = ST11;
				   end
				  
			ST17: begin
						NS = ST18;
					end
					
			ST18: begin
						if(r[1])
							NS = ST19;
						else if(r[0] ^ r[1])
							NS = ST21;
						else 
							NS = ST0;
					end	
					
			ST19: begin
						NS = ST20;
					end
			
			ST20: begin
						if(r[0] ^ r[1])
							NS = ST21;
						else 
							NS = ST0;
					end
			ST21: begin
						NS = ST0;
					end
			endcase	
		  	end
			
	  
	  always @(posedge CLK or posedge CLR)
			begin : SEQ
				if(CLR)
					CS <= ST0;
				else
					CS <= NS;
			end
			
	 always @(CS or CLR or Stat[1])
		   begin: OUT
				ERR = Stat[1];

				if (CLR==1)
						begin
							RST = CLR;
							AccCLR = CLR;
							QnCLR = CLR;
							R1Clr = CLR;
						end
				else
					begin
							RST = CLR;
							AccCLR = CLR;
							QnCLR = CLR;
							R1Clr = CLR;
						
					case(CS)
						ST0 : if(LOAD)
								begin
									R0Src = 2'b11;
									R1Src = 1'b0;
									R0WE = 1'b1;
									R1WE = 1'b1;
									ASrc = 2'b11;
									BSrc = 2'b01;
									k = k + 1;
								end
								
						ST1 : begin				
									ALUCtrl = OP;
									R1Clr = 1'b1;
									ASrc = 2'b11;
									BSrc = 2'b10;
									R0WE = 1'b1;
									R1WE = 1'b0;
									R0Src = 2'b10;
								end
								
						ST2 : begin
									AccCLR = 1'b1;
									AccParallel = 1'b0;
									QnCLR = 1'b1;
									QParallel = 1'b1;
									QSrc = 1'b0;
									ASrc = 2'b11;
									Count = W;
									R0WE = 1'b0;
									R1WE = 1'b0;				
								end
								
						ST3 : begin
									r = 2'b00;
									if(R1m)
										begin
										BSrc = 2'b10;
										ASrc = 2'b00;
										ALUCtrl = 3'b110;
										R0WE = 1'b0;
										R1WE = 1'b1;
										R1Src = 1'b0;
										r[1] = 1'b1;
										end
									else if(R0m)
										begin
										BSrc = 2'b11;
										ASrc = 2'b00;
										ALUCtrl = 3'b110;
										R0WE = 1'b1;
										R1WE = 1'b0;
										R0Src = 2'b10;
										r[0] = 1'b1;
										end
									else
										begin
										AccCLR = 1'b1;
										AccParallel = 1'b0;
										QnCLR = 1'b1;
										QParallel = 1'b1;
										QSrc = 1'b0;
										ASrc = 2'b10;
										Count = W;
										R0WE = 1'b0;
										R1WE = 1'b0;
										end
								end
								
						ST4 : begin
									BSrc = 2'b10;
									ASrc = 2'b01;
									ALUCtrl = 3'b000;
									AccParallel = 1'b1;
								end
								
						ST5 : begin
									BSrc = 2'b10;
									ASrc = 2'b01;
									ALUCtrl = 3'b001;
									AccParallel = 1'b1;
								end
								
						ST6 : begin
									AccParallel = 1'b0;
									QParallel = 1'b0;
									AccRight = 1'b1;
									QRight = 1'b1;
									Count = Count -1;
									if(Count==0)
										begin
										R0WE = 1'b1;
										R1WE = 1'b1;
										R0Src = 2'b01;
										R1Src = 1'b1;
										end
								end
								
						ST7 : begin
									BSrc = 2'b00;
									ASrc = 2'b10;
									ALUCtrl = 3'b000;
									R0WE = 1'b0;
									R1WE = 1'b1;
									R1Src = 1'b0;							
								end
								
						ST8 : begin
									if(R0m)
										begin
										BSrc = 2'b11;
										ASrc = 2'b00;
										ALUCtrl = 3'b110;
										R0WE = 1'b1;
										R1WE = 1'b0;
										R0Src = 2'b10;
										r[0] = 1'b1;
										end
									else
										begin
										AccCLR = 1'b1;
										AccParallel = 1'b0;
										QnCLR = 1'b1;
										QParallel = 1'b1;
										QSrc = 1'b0;
										ASrc = 2'b10;
										Count = W;
										R0WE = 1'b0;
										R1WE = 1'b0;
										end							
								end
								
						ST9 : begin
									BSrc = 2'b00;
									ASrc = 2'b11;
									ALUCtrl = 3'b000;
									R0WE = 1'b1;
									R1WE = 1'b0;
									R0Src = 2'b10;	
								end
								
						ST10 : begin
									AccCLR = 1'b1;
									AccParallel = 1'b0;
									QnCLR = 1'b1;
									QParallel = 1'b1;
									QSrc = 1'b0;
									ASrc = 2'b10;
									Count = W;
									R0WE = 1'b0;
									R1WE = 1'b0;
								 end
								 
						ST11 : begin
									AccParallel = 1'b0;
									QParallel = 1'b0;
									AccRight = 1'b0;
									QRight = 1'b0;
								 end
								 
						ST12 : begin
									AccParallel = 1'b0;
									QParallel = 1'b0;
									AccRight = 1'b0;
									QRight = 1'b0;
								 end
								 
						ST13 : begin	
									BSrc = 2'b11;
									ASrc = 2'b01;
									ALUCtrl = 3'b001;
									AccParallel = 1'b1;
								 end
								 
						ST14 : begin
									BSrc = 2'b11;
									ASrc = 2'b01;
									ALUCtrl = 3'b000;
									AccParallel = 1'b1;
								 end
								 
						ST15 : begin
									QSrc = 1'b1;
									QzSrc = 1'b1;
									QParallel = 1'b1;
									Count = Count - 1;
									if((Count == 0) && NFlag)
										begin
										R0WE = 1'b1;
										R1WE = 1'b1;
										R0Src = 2'b01;
										R1Src = 1'b1;
										end
								 end
								 
						ST16 : begin
									QSrc = 1'b1;
									QzSrc = 1'b0;
									QParallel = 1'b1;
									Count = Count - 1;
									if((Count == 0) && NFlag)
										begin
										R0WE = 1'b1;
										R1WE = 1'b1;
										R0Src = 2'b01;
										R1Src = 1'b1;
										end
								 end
								 
						ST17 : begin
									BSrc = 2'b11;
									ASrc = 2'b01;
									ALUCtrl = 3'b000;
									AccParallel = 1'b1;
									
									R0WE = 1'b1;
									R1WE = 1'b1;
									R0Src = 2'b01;
									R1Src = 1'b1;
								 end
					endcase
					end
					end
			
endmodule
