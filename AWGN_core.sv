

include "URNG.v";
include "sin_cos_unit.v";
include "logarithm_unit.sv";
include "squareroot_unit.sv";

module AWGN_IP_CORE (x0, x1, s0, s1, s2, s3, s4, s5, clk, reset);
output reg [15:0] x0, x1;
input clk, reset;
input [31:0] s0, s1, s2, s3, s4, s5;

wire [31:0] URNG_a, URNG_b, log_sqrt ;
wire [15:0] u1, g0, g1, f;
wire [47:0] u0;

URNG URNG1 (.s0(s0), .s1(s1), .s2(s2), .u(URNG_a));
URNG URNG2 (.s0(s3), .s1(s4), .s2(s5), .u(URNG_b));
assign u0={URNG_a,URNG_b[31:16]};
assign u1=URNG_b[15:0];
logarithm_unit logarithm1 (.in(u0), .out(log_sqrt));
sin_cos_unit sin_cos (.in(u1), .out1(g0), .out2(g1));
squareroot_unit squareroot (.in(log_sqrt), .out(f));

always @ (posedge clk, reset)
begin
if (reset) begin
x0=32'h00000000;
x1=32'h00000000;
end
else begin
x0 = f * g0;
x1 = f * g1;
end

end
endmodule 

module test_AWGN; 
logic [31:0] s0, s1, s2, s3, s4, s5;
logic clk, reset;
wire [15:0] x1, x0;

AWGN_IP_CORE ic1 (.clk(clk), .reset(reset), .s0(s0), .s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5), .x0(x0), .x1(x1));
initial begin
clk=0;
reset=0;
#20;
reset=1;
#40;
reset=0;
end

initial begin
repeat(10)begin
s0=$random;
s1=$random;
s2=$random;
s3=$random;
s4=$random;
s5=$random;
#10;
end
end

always begin
# 10;
clk=~clk;
end
endmodule 