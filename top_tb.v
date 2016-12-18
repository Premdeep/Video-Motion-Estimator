`include "/courses/engr852/engr852-20/asic_flow_setup/krc/src/motion_estimator/rtl/top.v"

module top_testbench();

// inputs are of reg type

reg		clk;
reg		start;
reg	[7:0]	dataR;
reg	[7:0]	dataS1;
reg	[7:0]	dataS2;

// outputs are of wire type

wire	[7:0]	addressR;
wire	[9:0]	addressS1;
wire	[9:0]	addressS2;
wire	[7:0]	bestdist;
wire	[3:0]	motionX;
wire	[3:0]	motionY;


// Ref memory Instantiation

refmem  u1 (.i_addressR(addressR), .o_dataRef(dataR) );

// Search Memory Instantiation

searchmem  u2 (.i_addressS1(addressS1), .i_addressS2(addressS2), .o_dataSearch1(dataS1), .o_dataSearch2(dataS2));

// Top module instatiation

motion_estimator u3 (.clock(clk), .start(start), .dataRef(dataR), .dataSearch1(dataS1), .dataSearch2(dataS2),

			.addressR(addressR), .addressS1(addressS1), .addressS2(addressS2), .bestDist(bestdist),

			 .motionX(motionX), .motionY(motionY));
		
		always #5 clk = ~clk;

initial		
		begin
	
	$monitor ("time = %5d ns, addressR = %d, addressS1 = %d ", $time, addressR, addressS1 );

	$monitor ("addressS2 = %d, bestdist = %d, motionX = %d , motionY = %d", addressS2, bestdist, motionX, motionY);

			clk = 1'b0;
			start = 0;

		@(posedge clk); start = 1'b1;

		#10 start = 1'b0;
		
			#655390;

			start = 1'b1;

		if(addressS2 != 10'd961) begin

			$display("Error Occured");

			end

			$display("All tests are passed for now");

			$finish;

			end

			initial begin
			
			$dumpfile ("Top.dump");
			$dumpvars (0,Top_testbench);

				end

					endmodule



	








