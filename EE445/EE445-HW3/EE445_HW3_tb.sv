module basic_comp_tb();
 
	reg clk, set_S, set_FGI, set_FGO, INPR_in;
	wire FGI_out, FGO_out, OUTR_out;
 
  basic_comp DUT (
    .clk(clk),
	 .set_S(set_S), .set_FGI(set_FGI), .set_FGO(set_FGO),
	 .FGI_out(FGI_out), .FGO_out(FGO_out),
	 .INPR_in(INPR_in), .OUTR_out(OUTR_out)
  );
 
  initial begin
		clk = 1'b0;
		repeat(250) #10 clk = ~clk; // generate a clock
  end
  
  initial begin
		set_S <= 1'b0;
		set_FGI <= 1'b0;
		set_FGO <= 1'b0;
		INPR_in <= 1'h0;
		
		repeat(250) @(posedge clk);
		INPR_in <= INPR_in + 1;
		
		repeat(250) @(posedge clk);
		$finish;
		
		
  end
 
endmodule