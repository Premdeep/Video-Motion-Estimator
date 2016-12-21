module refmem (i_addressR, o_dataRef);

input 	[7:0]	i_addressR;
output	[7:0]	o_dataRef;
reg	[7:0]	rmem[7:0];

integer i;

always @ (*) begin

for (i = 0; i<256; i=i+1) begin
rmem[i] = 2;
end

always@ (*) begin

o_dataRef = rmem[i_addressR];

end

endmodule

