// Code your design here
module booths_multiplier(clk, reset, start, M, Q, valid, Acc);
	input reset, start, clk;
	input signed [7:0] M;
	input signed [7:0] Q;
	output signed  [15:0] Acc;
	output valid;
	
	parameter	IDLE  	 = 1'b0,
				START 	 = 1'b1;
				
	reg signed [15:0] Acc, temp_Acc, next_Acc;
	reg [1:0] state, next_state;
	reg [1:0] temp, next_temp;
	reg [2:0] count, next_count;
	reg valid, next_valid;
	
	always @(posedge clk or negedge reset) 
		begin
			if(!reset) begin 
				Acc	<= 16'b0;
				count	<= 3'b0;
				valid	<= 1'b0;
				temp	<= 2'b0;
				state	<= IDLE;
			end
			else begin
				Acc	<= next_Acc;
				count	<= next_count;
				valid	<= next_valid;
				temp	<= next_temp;
				state	<= next_state;
			end
		end
	
	// Next-State Logic
	always @(*)
		begin
			case(state) 
				IDLE	: 	begin
								next_count = 3'b0;
								next_valid  = 2'b0;
								if(start) begin
									next_state = START;
									next_temp  = {Q[0], 1'b0};
									next_Acc   = {8'd0, Q};
								end
								else begin
									next_state = IDLE;
									next_temp  = 2'b0;
									next_Acc   = 16'b0;
								end
							end	
				START	:	begin
								case(temp)
									2'b01	:	temp_Acc = {Acc[15:8] + M, Acc[7:0]};
									2'b10	:	temp_Acc = {Acc[15:8] - M, Acc[7:0]};
									default	:   temp_Acc = {Acc[15:8], Acc[7:0]};
								endcase
							next_temp = {Q[count+1],Q[count]};
							next_count = count + 1'b1;
							next_Acc   = temp_Acc >>> 1;
							next_valid = (&count) ? 1'b1 : 1'b0; 
							next_state = (&count) ? IDLE : state;
							end
			endcase
		end
endmodule
