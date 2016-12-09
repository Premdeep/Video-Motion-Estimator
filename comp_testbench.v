
module comp_testbench();

// inputs must be assigned to reg type

reg clk,compstart;
reg[3:0] vectorX,vectorY;
reg[16*8-1:0] peout;
reg[15:0] peready;

// outputs must be of wire type

wire[7:0] newpe;
wire[3:0] motionX,motionY;
wire[7:0] bestdist;

comparator u1 ( // inputs
		.clk(clk), .compstart(compstart), .vectorX(vectorX),
		.vectorY(vectorY),.peout(peout), .peready(peready), .newpe(newpe),

		// outputs
		.motionX(motionX), .motionY(motionY), .bestdist(bestdist)
		);

always #5 clk = ~clk;

initial
begin
$monitor("time = %5d ns, newpe = %d, bestdist = %d,motionX = %d, motionY = %d \n ",$time, newpe,bestdist,motionX,motionY);

clk = 1'b0;

	@(posedge clk);
	 #1 compstart =0; peready = 0; // here the best distortion should be 8'hFF
 
 	@(posedge clk); #1;

 	compstart = 0;
 	peready[15:0] = 16'h0002;	// here also the best distortion should be 8'hFF
 	peout[15:8] = 8'h5;	
 	vectorX = 4'h3;			// motion X should be 4'hxx;
 	vectorY = 4'h2;			// motion Y should be 4'hxx;
 
 	@(posedge clk); #1;

 	compstart = 1;
 	peready[15:0] = 16'h0004;	// here the best distortion should be 8'h08; 
 	peout[23:16] = 8'h08;
 	vectorX[3:0] = 4'h5;		// motion X is 4'h5;
 	vectorY[3:0] = 4'h6;		// motion Y is 4'h6;
 
 	@(posedge clk); #1;

 	peready[15:0] = 16'h0008;	// here the best distortion should be 8'h03;
 	peout[31:24]  = 8'h3;
 	vectorX = 4'h7;			// motion X is 4'h7;
 	vectorY = 4'h5;			// motion Y is 4'h5;

	@(posedge clk); #1;

	peready[15:0] = 16'h0040;	// here the best distortion should be 8'h03;	
	peout[55:48] = 8'h7;
	vectorX = 4'h8;			// motion X is 4'h7;		
	vectorY = 4'h6;			// motion Y is 4'h5;


	@(posedge clk); #1;

	peready[15:0] = 16'h0010;	// here the best distortion should be 8'h01;
	peout[39:32] = 8'h1;
	vectorX = 4'h1;			// motion X is 4'h1;
	vectorY = 4'h2;			// motion X is 4'h2;


@(posedge clk); #1;
@(posedge clk); #1;
@(posedge clk); #1;
@(posedge clk); #1;

 
 
 if(bestdist[7:0] != 8'h01) begin
 $display("ERROR OCCUREDD DATA MISMATCH");
end


 $display("ALL TESTS ARE PASSED");
 
 $finish;
 end
 
 initial begin
 
$dumpfile ("comp.dump");
$dumpvars (0, comp_testbench);
end

endmodule
