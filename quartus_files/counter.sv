module counter_4( 
			input Reset, Count,
			output logic [2:0] counter_4_val
);
    
always_ff @ (posedge Count or posedge Reset) begin
		if(Reset)
			counter_4_val <= 0;
		else if (counter_4_val == 3)
				counter_4_val <= 0;
		else if(Count)
			counter_4_val <= counter_4_val + 1;
	end
endmodule
