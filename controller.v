module controller(i_clk, i_start, o_s1s2Mux, o_newdist, o_count, o_compstart, o_peready, o_vectorX, o_vectorY, o_addressR, o_addressS1, o_addressS2);

input               i_clk;
input               i_start;

output  [15:0]      o_s1s2Mux;
output  [15:0]      o_newdist;
output              o_compstart;
output  [15:0]      o_peready;
output  [7:0]       o_vectorX, o_vectorY;
output  [7:0]       o_addressR;
output  [9:0]       o_addressS1,o_addressS2;
output  [12:0]      o_count;

reg     [15:0]      o_s1s2Mux;
reg     [15:0]      o_newdist;
reg     [15:0]      o_peready;
reg     [7:0]       o_vectorX,o_vectorY;
reg     [7:0]       o_addressR;
reg     [9:0]       o_addressS1,o_addressS2;
reg     [12:0]      o_count;
reg     [11:0]      temp_count;
reg                 completed;

integer             i;

always @(posedge i_clk) begin
    if(i_start == 1 || completed == 1) o_count <= 13'b0;
    else o_count <= o_count + 1'b1;
end

assign o_compstart = ((o_count[12:0] >= 12'd256) ? 1 : 0);

always @(*) begin
    for (i=0; i<16; i = i+1) begin
        o_newdist[i] = (o_count[7:0] == i);
        o_peready[i] = (o_newdist[i] && (o_count > 8'd255));
        o_s1s2Mux[i] = (o_count[3:0] >= i);
    end
    o_addressR = o_count[7:0];
    o_addressS1 = (((o_count[11:8] + o_count[7:4]) << 5) - (o_count[11:8] + o_count[7:4])) + o_count[3:0];
    temp_count = o_count[11:0] - 5'd16;
    o_addressS2 = (((temp_count[11:8] + temp_count[7:4]) << 5) - (temp_count[11:8] + temp_count[7:4])) + temp_count[3:0] + 5'd16;
    o_vectorX = o_count[3:0] - 4'd8;
    o_vectorY = o_count[12:8] - 4'd9;
    //completed = (o_count[11:0] == 4'hF * (8'hFF + 1));
    completed = (o_count[12:0] == ((256 * 16) + 16));
end

endmodule


