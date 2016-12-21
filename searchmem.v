module searchmem (i_addressS1, i_addressS2, o_dataSearch1, o_dataSearch2)

input	[9:0]	i_addressS1;
input	[9:0]	i_addressS2;
output	[7:0]	o_dataSearch1;
output	[7:0]	o_dataSearch2;

reg	[7:0]	smem[9:0];

integer j;

always @ (*) begin

for (j=0; j<962; j=j+1) begin	

if(j<256) begin
 smem[j] = 3;
end

else if(j< 512) begin
smem[j] = 2;
end

else smem[j] = 1;

end

always @ (*) begin

dataSearch1 = smem[addressS1];
dataSearch2 = smem[addressS2];

end

endmodule	
