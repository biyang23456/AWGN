
// this module is to calculate the value of -2ln(u0)

module logarithm_unit (in, out);

input unsigned [47:0]in;
output reg unsigned[31:0]out;

reg unsigned [54:0] out_vec;
//because u0=[0,1], the max value of -2ln(u0)=66.54, therefore 7 bits will be needed to represent the integer result
//i will add 7 bits on the left of the result to maintain the same precision as u0, in order to use a single expression for the result,
// then ignore the right most 7 bits to get the 48 bits resuilt

reg unsigned [47:0] in_value, out_temp;

always@(*) begin
in_value=in;
if (in_value==48'd0) begin
 out=32'hFFFFFFFF; // -2ln(0) should be infinity, here i am assigning this to be the max number possile
end
// i seperated the approximation to several parts, each parts follows a 1st degree polynomial fuction
// the if input is less than 262146, the the function of out = -4596294162 * in + 12729679795506912
else if ( in_value<48'd262146) begin
 out_vec = -55'd4596294162 * in_value + 55'd12729679795506912; out = out_vec[54:22];
end 

//*****************************************************************************************
else if (in_value<48'd8388608) begin
 out_vec = -55'd133115508 * in_value + 55'd10696957185212076; out = out_vec[54:22];
end 
//******************************************************************************************
else if (in_value<48'd67108866) begin
 out_vec = -55'd58696661 * in_value + 55'd9750546706161786; out = out_vec[54:22];
end 
//*******************************************************************************************
else if ( in_value<48'd268435459) begin
 out_vec = -55'd3264868 * in_value + 55'd8412089989012722; out = out_vec[54:22];
end 
//*******************************************************************************************
else if (in_value<48'd8590000131) begin
 out_vec = -55'd135891 * in_value + 55'd6852483945149678; out = out_vec[54:22];
end 
//*******************************************************************************************
else if ( in_value<48'd274878103555) begin
 out_vec = -55'd3721 * in_value + 55'd4840037325616444; out = out_vec[54:22];

end 
//*******************************************************************************************

else if (in_value<48'd8796126773251) begin
 out_vec = -55'd118 * in_value + 55'd2895811187055675; out = out_vec[54:22];
end 
//*******************************************************************************************

else if (in_value<48'd43980515639299) begin
  out_vec = -55'd10 * in_value + 55'd1549879485147386; out = out_vec[54:22];
end 
//*******************************************************************************************
else if (in_value<48'd74766812518809) begin
 out_vec = -55'd5 * in_value + 55'd959370732905237; out = out_vec[54:22];
end 
//*******************************************************************************************

else if( in_value<48'd145135573473689) begin
 out_vec = -55'd3 * in_value + 55'd620537941247840; out = out_vec[54:22];
 
end 
//*******************************************************************************************

else if( in_value<48'd281474976710655) begin
  out_vec = -55'd2 * in_value + 55'd467221481698759; out = out_vec[54:22];
end 
//*******************************************************************************************

else begin      // when in put is out of [0,1] the output of this fuction gives all 0 because its out of range
out=32'h00000000;
end
end
endmodule 


module test_log;
reg unsigned [47:0] in;
wire [31:0] out;

logarithm_unit logarithm1(.in(in), .out(out));
initial begin
$monitor("monitor in:%d out:%d @ %0t", in, out, $time);
for (in=0; in< 32'd2232711905; in = in+32'd100000000) begin
#20;
end
$finish;
end
endmodule 