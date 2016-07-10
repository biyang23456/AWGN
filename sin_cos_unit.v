// this module calculates the sin and cos value of a fixed point number
// the number is with 5 bits integer and 11 bits fraction, therefore the precision will be 2^(-11)=0.00048828
//
module sin_cos_unit (out1, out2, in);

input [15:0] in;
output reg [15:0] out1, out2;
reg [15:0] sin_out, cos_out, in_value, in_hold;

// Because of the symmetric and periodic behavior of sin and cos, I am only creating 
// the LUT for sin(2pi*x) where x= [0,1/4]

function [15:0] sin; // the function used to calculate sin(2pi*x)
input [15:0] sin_in;
reg [15:0] sin_value;
//**********************************************************************************************************//
//based on the precision (0.00048828), the sin_in interval of [0,0.25] can be devided to
//512 piece. for the ease of coding, I will use decimal number to represent the pieces
//for example 16'd1 will represent 0.00048828 and 16'd513 will represent 0.2474
//the output will be rounded to the nearest precision number, for example if sin(2pi*sin_in)=0.24737, it will
//be rounded to 0.2474 which is 512
//***********************************************************************************************************//
//***********************************************************************************************************//
// by compareing the value of sin (2pi* sin_in) I found that the result output will follow sin_in untill sin_in 
// reaches 233, and after that, sin_value will follow sin_in-1 until sin_in = 337, and so on.
// Instead of writing a look up table with 512 cases, the code will be simplified as follow.
//************************************************************************************************************//
// IN SHORT, I DIDNT USE THE POLYNOMIALS FUCTION TO APPROXIMATE THE VALUES, I INTEAD DID THIS BY OBSERVATION OF 
// THE RESULTS FROM MATLAB.
begin

if (sin_in<=233) begin
sin_value = sin_in;
end else if (sin_in<=336) begin
sin_value = sin_in - 1;
end else if (sin_in<=397) begin
sin_value = sin_in - 2;
end else if (sin_in<=445) begin
sin_value = sin_in - 3;
end else if (sin_in<=484) begin
sin_value = sin_in - 4;
end else if (sin_in<=512) begin
sin_value = sin_in - 5;
end

assign sin = sin_value;

end
endfunction

always @ (*)
begin
// because the sin and cos value repeats itself after 2pi, here I am to reduce the input to fit in the interval [0,1)
// remember we are calculating sin(2pi*input) here

if (in >= 16'h0800) begin
 in_value = in & 16'h07FF; end
else begin
 in_value = in; end

if (in_value <= 16'd512)begin
assign sin_out = sin(in_value);
assign cos_out = sin(16'd512 - in_value); // cos(x) = sin (pi/2-x)
end
else if (in_value <= 16'd1024) begin
assign sin_out = sin(16'd1024-in_value);
assign cos_out = -sin(in_value-16'd512);
end
else if (in_value <= 16'd1536) begin
assign sin_out = -sin(in_value-16'd1536);
assign cos_out = -sin(16'd1536-in_value);
end
else if (in_value <= 16'd2048) begin
assign sin_out = -sin(16'd2048-in_value);
assign cos_out = sin(in_value-16'd1536);
end

assign out1 = sin_out;
assign out2 = cos_out;
end

endmodule










