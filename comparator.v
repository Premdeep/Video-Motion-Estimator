module comparator(i_clk, i_CompStart, i_PEout, i_PEready, i_vectorX, i_vectorY, o_BestDist, o_motionX, o_motionY);

input               i_clk;
input               i_CompStart;
input   [8*16-1:0]  i_PEout;
input   [15:0]      i_PEready;
input   [7:0]       i_vectorX,i_vectorY;
output  [7:0]       o_BestDist;
output  [7:0]       o_motionX,o_motionY;

reg     [7:0]       o_BestDist, newPEout;
reg     [7:0]       o_motionX, o_motionY;
reg                 newBest;

always @(posedge i_clk)
    if (i_CompStart == 0) o_BestDist <= 8'hFF;
    else if (newBest == 1) begin
        o_BestDist <= newPEout;
        o_motionX <= i_vectorX;
        o_motionY <= i_vectorY;
    end 

//always @(o_BestDist or i_PEout or i_PEready) begin
always @(*) begin
    case(i_PEready) 
        16'h0001    :   newPEout = i_PEout[7:0];        //PE0
        16'h0002    :   newPEout = i_PEout[15:8];       //PE1
        16'h0004    :   newPEout = i_PEout[23:16];      //PE2
        16'h0008    :   newPEout = i_PEout[31:24];      //PE3
        16'h0010    :   newPEout = i_PEout[39:32];      //PE4
        16'h0020    :   newPEout = i_PEout[47:40];      //PE5
        16'h0040    :   newPEout = i_PEout[55:48];      //PE6
        16'h0080    :   newPEout = i_PEout[63:56];      //PE7
        16'h0100    :   newPEout = i_PEout[71:64];      //PE8
        16'h0200    :   newPEout = i_PEout[79:72];      //PE9
        16'h0400    :   newPEout = i_PEout[87:80];      //PE10
        16'h0800    :   newPEout = i_PEout[95:88];      //PE11
        16'h1000    :   newPEout = i_PEout[103:96];     //PE12
        16'h2000    :   newPEout = i_PEout[111:104];    //PE13
        16'h4000    :   newPEout = i_PEout[119:112];    //PE14
        16'h8000    :   newPEout = i_PEout[127:120];    //PE15
        default     :   newPEout = o_BestDist;
    endcase
    //newPEout = i_PEout[i_PEready*8+7 : i_PEready*8];
    if ((|i_PEready == 0) || (i_CompStart == 0))
        newBest = 0;
    else if (newPEout <= o_BestDist)
        newBest = 1;
    else
        newBest = 0;
end

endmodule /* comparator */


