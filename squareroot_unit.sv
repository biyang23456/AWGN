// This module calculates the value of square root of its input
module squareroot_unit (in, out);
input unsigned [31:0] in;
output logic unsigned [15:0] out;
logic unsigned[31:0] in_value, out_vec;
real  i,j;

assign in_value=in;

always @(*)
begin
//in this module, I al split the graph of sqrt(in) into 8 pieces.
if (in_value==32'd0) begin
 out=16'h0000; // sqrt(0)=0
end
//********************************************************************************
else if ( in_value<32'd213450752) begin
 i=0.00005;
 j=4883;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end 
//*********************************************************************************
else if ( in_value<32'd408682496) begin
 i=0.000029;
 j=8702;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end 
//********************************************************************************
else if ( in_value<32'd599785472) begin
 i=0.000023;
 j=11096;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end 
//**********************************************************************************
else if ( in_value<32'd801046528) begin
 i=0.000019;
 j=13326;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end
//***********************************************************************************
else if ( in_value<32'd994508800) begin
 i=0.000015;
 j=16622;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end
//***********************************************************************************
else if ( in_value<32'd1318200000) begin
 i=0.000014;
 j=17337;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end
//*************************************************************************************
else if ( in_value<32'd1728200000) begin
 i=0.000013;
 j=19668;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end
//***********************************************************************************

else if ( in_value<32'd2232800000) begin
 i=0.000012;
 j=21629;
 out_vec = i * in_value + j; 
 out = out_vec[16:0];
end
//*************************************************************************
else begin
out=16'hFFFF;// input is out of range, then give output the maximunm value
end


end
endmodule




// This approach is good for small value inputs, as the inputs getting larger, its gonna take forever to calculate sqrt(in)
// results are less in error, but take long time to run.

// in this module, I will try to find the value for variable j, just at j*j = i. in this way, i will be the input and j will be the
// square root of i. 

/*always @ (*)
begin
 
in_value=in;
 for (i=0;i<=in_value;i=i+1) begin 
    for (j=0; j*j<=i; j=j+1) begin // I then scan j from one to find the closest j*j=1, j should be the closest sqrt(i);
           assign out_temp = j;     // keep refreshing j until it reaches sqrt(i);
end
 out = out_temp;
end 
end
endmodule */



module test_square_root;
logic unsigned [31:0] in;
wire [15:0] out;

squareroot_unit sqrt1(.in(in), .out(out));
initial begin
$monitor("monitor in:%d out:%d @ %0t", in, out, $time);
for (in=0; in< 32'd2232711905; in = in+32'd100000000) begin
#20;
end
$finish;
end
endmodule 