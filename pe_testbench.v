// test bench for pe

module pe_testbench();

// inputs must be declared as of reg type
reg [7:0] R, S1, S2;

reg S1S2mux, newdist, clk;

// outputs must be declared as wire type
wire [7:0] accumulate, rpipe;
wire carry;


	pe u1 ( 
		 // outputs

		.accumulate(accumulate), .rpipe(rpipe), .carry(carry),
 
		// inputs
		.R(R), .S1(S1), .S2(S2), .S1S2mux(S1S2mux), .newdist(newdist),

		 .clk(clk) 	);
		
		always #5 clk = ~clk; // setting clk period for 10 ns
		
		initial 
		begin
		
		// setting up the monitor for difference,accumulatein, accumulate
		
	$monitor("time = %5d ns, clk = %b, accumulate = %b, difference = %d \n\n", $time, clk, accumulate,u1.difference);

		// first initializing the inputs
		
		clk = 1'b0;
		 
		@(posedge clk); #1;

		newdist = 1;
		S1S2mux = 1;
		R = 8'h8;
		S1 = 8'h0;
		S2 = 8'h8;  // here accumulate should load the difference i.e 8'h8
		
		@(posedge clk); #1;
		
		newdist = 0;
		S1S2mux = 1;

		R = 8'h0;
		S1 = 8'h1;
		S2 = 8'h7; // here accumulate should add the diffrences i.e 8+1 = 8'h9

		@(posedge clk);

		S1S2mux = 0;
		R = 8'h1;
		S1 = 8'h1;
		S2 = 8'h5; // here accumulate should add the difference i.e 4 + 9 = 8'hD;

		@(posedge clk);

		S1S2mux = 1;
		R = 8'h2;
		S1 = 8'h1;
		S2 = 8'h7; // here accumulate should become D + 1 = 8'hE	
		
		
		
		@(posedge clk); 
		
		
		S1S2mux =0;
		R = 8'h2;
		S1 = 8'h0;
		S2 = 8'h1; // here accumulate should become 8'hF
		
		
		#100;
		
		@(posedge clk);
		S1S2mux =1;
		R = 8'h5;
		S1 = 8'hFF;
		S2 = 8'h1; // here accumulate should  overflow become 8'hFF
		
		@(posedge clk); #1;
		S1S2mux =0;
		R = 8'h2;
		S1 = 8'h0;
		S2 = 8'h1; // here accumulate should become 8'hFF
	
		#100;
		
		
		if(accumulate != 8'hFF) begin
		$display("Error 1: carry is not equal to one");
		$finish;
		end

		
		$display("All tests are passed\n");
		$finish;
		end
		
		// To create a dump file for offline viewing.
		initial
		begin
		$dumpfile("pe.dump");
		$dumpvars(0,pe_testbench);
		end
		
		endmodule // pe_testbench
		
		

