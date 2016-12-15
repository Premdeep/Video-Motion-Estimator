module control_testbench();

// inputs are of reg type
reg clk,start;

// outputs are of wire type
wire[15:0] S1S2mux,newdist,peready;
wire [11:0] count;
wire compstart;
wire [3:0] vectorX,vectorY;
wire [7:0] AddressR;
wire[9:0] AddressS1,AddressS2;

control u1 (.clk(clk), .start(start), .S1S2mux(S1S2mux), .count(count),

				.newdist(newdist), .peready(peready), .compstart(compstart),
				
				.vectorX(vectorX), .vectorY(vectorY), .AddressR(AddressR),
				
					.AddressS1(AddressS1), .AddressS2(AddressS2));
					
		always #5 clk = ~clk;
					
initial
			begin
			
			$monitor("time = %5d ns, S1S2mux = %d, newdist = %d", $time, S1S2mux, newdist);

			$monitor("peready = %d, compstart = %d, count = %d", peready, compstart, count);

			$monitor("vectorX = %d, vectorY = %d", vectorX, vectorY);

			$monitor("AddressR = %d, AddressS1 = %d,AddressS2 = %d,",AddressR, AddressS1, AddressS2);
						
						
						clk = 1'b0;
						start = 0;
						
						@(posedge clk); start = 1'b1;
						
						#10 start = 1'b0;
						
						#10000;

						
					
					if(count[11:0] != 12'h000) begin

					$display("Error Occured ");

					end

					$display("All tests are passed for now");

						$finish;
						
						end
						
						 initial begin
						 $dumpfile ("control.dump");
						 $dumpvars (0, control_testbench);						 					
						 end
												 
							endmodule
						
						
						
