module wrapper_tb();
reg clk,rst_n,ss_n,mosi;
wire miso;
spi_wrapper sr (clk,rst_n,mosi,miso,ss_n);
reg [9:0]temp;
integer i=0;

initial begin
clk=0;
forever
#1clk=~clk;
end

initial begin
rst_n=0;
ss_n=1;
temp=0;
#10;
temp=10'b0000_01010;
rst_n=1;
#10;
//write in address  mem[10]
@(negedge clk)begin
ss_n=0;
end
@(negedge clk)begin
mosi=0;
end
for(i=10;i>0;i=i-1)begin
@(negedge clk)
	mosi=temp[i-1];
end
//end the communication and go to the idle state
@(negedge clk)
ss_n=1;
//write the address
@(negedge clk)
ss_n=0;
@(negedge clk)begin
mosi=0;
//write 10
temp=10'b01000_01010;
end
for(i=10;i>0;i=i-1)begin
@(negedge clk)
	mosi=temp[i-1];
end
@(negedge clk)
ss_n=1;
//read address
@(negedge clk)
ss_n=0;
@(negedge clk)begin
mosi=1;
//read address 10
temp=10'b10000_01010;
end
for(i=10;i>0;i=i-1)begin
@(negedge clk)
	mosi=temp[i-1];
end
@(negedge clk)
ss_n=1;
@(negedge clk)
ss_n=1;
//read address
@(negedge clk)
ss_n=0;
@(negedge clk)begin
mosi=1;
//read address 10
temp=10'b11000_01010;
end
for(i=10;i>0;i=i-1)begin
@(negedge clk)
	mosi=temp[i-1];
end
//wait to take the data from miso
#25;
//finally we close the communiction
@(negedge clk)
ss_n=1;
#100;
$stop;
end

initial begin
	$monitor("mosi=%b,miso=%b,ss_n=%b,clk=%b",mosi,miso,ss_n,clk);
end
endmodule