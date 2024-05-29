module ram(clk,rst_n,rx_valid,din,tx_valid,dout);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input clk,rst_n,rx_valid;
input[9:0]din;
output reg tx_valid;
output reg [7:0]dout;
reg [ADDR_SIZE-1:0]temp;
reg[7:0]mem[MEM_DEPTH-1:0];
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin 
	  dout<=0;
	  tx_valid<=0;	
	  end	
	else if (rx_valid) begin
		case(din[9:8])
		 2'b00:begin
		 	 temp<=din[7:0];
		 end
		 2'b01:begin
		     mem[temp]<=din[7:0];
		 end
		 2'b10:begin
		     temp<=din[7:0];
		 end		     
		 2'b11:begin
		     dout<=mem[temp];
		     tx_valid<=1;
		 end
		endcase
	end
end
endmodule