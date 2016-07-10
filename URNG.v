module URNG (u, s0, s1, s2);

input [31:0] s0, s1, s2; //define input seeds for URNG
output reg [31:0] u;    //define outpur for URNG

reg [31:0] b0, b1, b2, s0_temp, s1_temp, s2_temp;

// code from the paper figure 3
// This code use 3 LFSRs to generate a uniformed random number

always @ (*)
begin
b0 = ( ( ( s0 << 13 ) ^ s0 ) >> 19 );
s0_temp = ( ( ( s0 & 32'hFFFFFFFE ) << 12 ) ^ b0 );
b1 = (((s1 << 2) ^ s1 ) >> 25 );
s1_temp = ((( s1 & 32'hFFFFFFF8) << 4) ^ b1);
b2 = ((( s2 << 3) ^ s2) >> 11);
s2_temp = ((( s2 & 32'hFFFFFFF0) << 17) ^ b2);

u = s0_temp ^ s1_temp ^ s2_temp;

end
endmodule 

/* Test Bench for the URNG, just manually test those shifts and xors.

module URNG_test ;

wire [31:0] u0;
reg [31:0] s0, s1, s2;
URNG urng1 (.u0(u0), .s0(s0), .s1(s1), .s2(s2));

initial begin
s0 = 32'hF111F111;
s1 = 32'h07770777;
s2 = 32'hE888E888;
#200;
end
endmodule

*/

