`timescale 1ns/100ps

`include "/courses/engr852/engr852-20/asic_flow_setup/krc/src/motion_estimator/rtl/pe.v"
`include "/courses/engr852/engr852-20/asic_flow_setup/krc/src/motion_estimator/rtl/comparator.v"
`include "/courses/engr852/engr852-20/asic_flow_setup/krc/src/motion_estimator/rtl/controller.v"

module motion_estimator(
    clock, 
    start,
    dataRef, 
    dataSearch1, 
    dataSearch2, 
    addressR, 
    addressS1, 
    addressS2, 
    bestDist, 
    motionX, 
    motionY
);


input               clock;
input               start;
input   [7:0]       dataRef; 
input   [7:0]       dataSearch1; 
input   [7:0]       dataSearch2; 
output  [7:0]       addressR; 
output  [9:0]       addressS1; 
output  [9:0]       addressS2; 
output  [7:0]       bestDist; 
output  [7:0]       motionX;
output  [7:0]       motionY; 

//Regs for all inputs
//reg                 clock;
//reg     [7:0]       dataRef; 
//reg     [7:0]       dataSearch1; 
//reg     [7:0]       dataSearch2; 
//reg                 start;

//comparator
wire	[127:0]  pe_out;

//Wires for all outputs
//controller
wire    [15:0]  s1s2Mux;
wire    [15:0]  newdist;
wire    [12:0]  count;
wire            compstart;
wire    [15:0]  peready;
wire    [7:0]   vectorX, vectorY;
wire    [7:0]   addressR;
wire    [9:0]   addressS1; 
wire    [9:0]   addressS2;
//comparator
wire    [7:0]   bestDist;
wire    [7:0]   motionX;
wire    [7:0]   motionY;

//pe
wire    [7:0]  rpipe[15:0];



controller cntrl(
    .i_clk (clock), 
    .i_start (start), 
    .o_s1s2Mux (s1s2Mux), 
    .o_newdist (newdist), 
    .o_count (count), 
    .o_compstart (compstart), 
    .o_peready (peready), 
    .o_vectorX (vectorX), 
    .o_vectorY (vectorY), 
    .o_addressR (addressR), 
    .o_addressS1 (addressS1), 
    .o_addressS2 (addressS2)
);
    
comparator comp(
    .i_clk(clock), 
    .i_CompStart (compstart), 
    .i_PEout (pe_out), 
    .i_PEready (peready), 
    .i_vectorX (vectorX), 
    .i_vectorY (vectorY), 
    .o_BestDist (bestDist), 
    .o_motionX (motionX), 
    .o_motionY (motionY)
);
    
generate
    genvar i;
    for(i = 0; i < 16; i = i+1) begin
        if (i == 0) begin
            pe pe_inst(
                .i_clk (clock), 
                .i_refMem (dataRef),
                .i_searchMem1 (dataSearch1),
                .i_searchMem2 (dataSearch2), 
                .i_s1s2Mux (s1s2Mux[i]), 
                .i_newDist (newdist[i]),     
                .o_accumulate (pe_out[((i*8)+7):(i*8)]), 
                .o_rPipe (rpipe[i])
            ); 
        end else begin
            pe pe_inst(
                .i_clk (clock), 
                .i_refMem (rpipe[i-1]),
                .i_searchMem1 (dataSearch1),
                .i_searchMem2 (dataSearch2),                 
                .i_s1s2Mux (s1s2Mux[i]), 
                .i_newDist (newdist[i]),     
                .o_accumulate (pe_out[((i*8)+7):(i*8)]), 
                .o_rPipe(rpipe[i])
            ); 
        end
    end
endgenerate

endmodule 
