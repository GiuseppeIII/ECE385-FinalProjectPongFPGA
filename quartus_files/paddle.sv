//Paddle 1 is left, Paddle 2 is right

module  paddle ( 	input Reset, frame_clk,
						input [7:0] 	keycode,
						output [9:0]  	Paddle1X, Paddle1Y, Paddle2X, Paddle2Y, 
										Paddle1L, Paddle1W, Paddle2L, Paddle2W);
    
	 logic [9:0] Paddle1Y_Pos, Paddle2Y_Pos, Paddle1X_Pos, Paddle2X_Pos,
	 Paddle1Y_Motion, Paddle2Y_Motion, 
	 Paddle1_Length, Paddle2_Length, Paddle1_Width, Paddle2_Width;
	 
	 parameter [9:0] Paddle1_Y_Center=240;
	 parameter [9:0] Paddle2_Y_Center=240;
	 
    parameter [9:0] Paddle1_Y_Min=20;
    parameter [9:0] Paddle1_Y_Max=461;
	 parameter [9:0] Paddle2_Y_Min=20;
    parameter [9:0] Paddle2_Y_Max=461;
	 
	 parameter [9:0] Paddle1_Y_Step=4;
	 parameter [9:0] Paddle2_Y_Step=4;
	 
	 assign Paddle1_Length = 50;
	 assign Paddle2_Length = 50;
	 assign Paddle1_Width = 2;
	 assign Paddle2_Width = 2;
	 assign Paddle1X_Pos = 60;
	 assign Paddle2X_Pos = 550;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Paddle1Y_Motion <= 10'd0;
				Paddle2Y_Motion <= 10'd0;
				Paddle1Y_Pos <= Paddle1_Y_Center;
				Paddle2Y_Pos <= Paddle2_Y_Center;
        end
           
        else 
        begin 
			
				//Paddle 1
				Paddle1Y_Motion <= 0;
				case (keycode)					  
					8'h1A : begin
						if ((Paddle1Y_Pos - Paddle1_Length) >= Paddle1_Y_Min) begin
							Paddle1Y_Motion <= -Paddle1_Y_Step;//W
						end
					end	
					8'h16 : begin
						if ((Paddle1Y_Pos + Paddle1_Length) <= Paddle1_Y_Max) begin
							Paddle1Y_Motion <= Paddle1_Y_Step;//S
						end
					end  
					default: ;
				endcase
				
				//Paddle 2
				Paddle2Y_Motion <= 0;
				case (keycode)					  
					8'h52 : begin
						if ((Paddle2Y_Pos - Paddle2_Length) >= Paddle2_Y_Min) begin
							Paddle2Y_Motion <= -Paddle2_Y_Step;//UpArrow
						end
					end	  
					8'h51 : begin
						if ((Paddle2Y_Pos + Paddle2_Length) <= Paddle2_Y_Max) begin
							Paddle2Y_Motion <= Paddle2_Y_Step;//DownArrow
						end
					end
					default: ;
			   endcase
				 
				Paddle1Y_Pos <= (Paddle1Y_Pos + Paddle1Y_Motion);
				Paddle2Y_Pos <= (Paddle2Y_Pos + Paddle2Y_Motion);
		end  
    end
      
	 
	 assign Paddle1Y = Paddle1Y_Pos;
    assign Paddle2Y = Paddle2Y_Pos;
	 assign Paddle1X = Paddle1X_Pos;
    assign Paddle2X = Paddle2X_Pos;
    assign Paddle1L = Paddle1_Length;
	 assign Paddle1W = Paddle1_Width;
    assign Paddle2L = Paddle2_Length;
    assign Paddle2W = Paddle2_Width;
	 
    

endmodule
