module pe(i_clk, i_refMem, i_searchMem1, i_searchMem2, i_s1s2Mux, i_newDist, o_accumulate, o_rPipe);

input			i_clk;
input	[7:0]	i_refMem, i_searchMem1, i_searchMem2;
input			i_s1s2Mux, i_newDist;
output	[7:0]	o_accumulate, o_rPipe;

reg		[7:0]	o_accumulate, diff, o_rPipe;
reg     [7:0]   temp;
reg             diff_carry;
reg				carry;

always @(posedge i_clk) o_rPipe <= i_refMem;

always @(*) begin
	{diff_carry, diff} = i_refMem - (i_s1s2Mux ? i_searchMem1 : i_searchMem2);
	if (diff_carry) diff = 0 - diff;	//absolute value
end

always @(posedge i_clk) begin
    if (i_newDist) begin 
        o_accumulate <= diff;	
        temp <= 8'h0;
    end else if(o_accumulate < 8'hff) begin
        {carry, temp} <= diff + o_accumulate;
	    if (carry) o_accumulate <= 8'hff;
        else o_accumulate <= temp;
    end
end
endmodule

