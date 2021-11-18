//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
					input	[9:0] Paddle1X, Paddle1Y, Paddle2X, Paddle2Y, 
									Paddle1L, Paddle1W, Paddle2L, Paddle2W,	
               output[9:0] BallX, BallY, BallS,
					output[3:0] scoreL, scoreR);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 logic [1:0] ledgeCountVal, redgeCountVal, tedgeCountVal, bedgeCountVal;
	 logic [3:0] score_left, score_right;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=33;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=596;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=20;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=461;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=4;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=4;      // Step size on the Y axis

    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign scoreL = 1;
	 assign scoreR = 2;
	 int paddle1minHeight, paddle1maxHeight, paddle1minWidth, paddle1maxWidth;
	 int paddle2minHeight, paddle2maxHeight, paddle2minWidth, paddle2maxWidth;
	 int ballymotion, bally2motion;
	 
	 assign paddle1minHeight = Paddle1Y - Paddle1L;
	 assign paddle1maxHeight = Paddle1Y + Paddle1L;
	 assign paddle1minWidth = Paddle1X - Paddle1W;
	 assign paddle1maxWidth = Paddle1X + Paddle1W;
	 
	 assign paddle2minHeight = Paddle2Y - Paddle2L;
	 assign paddle2maxHeight = Paddle2Y + Paddle2L;
	 assign paddle2minWidth = Paddle2X - Paddle2W;
	 assign paddle2maxWidth = Paddle2X + Paddle2W;
	 
	 assign bally1motion = (Ball_Y_Pos - Paddle1Y)>>3;
	 assign bally2motion = (Ball_Y_Pos - Paddle2Y)>>3;
  
		
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
		  //initalize ball
        begin 
				score_left <= 0;
				score_right <= 0;
				bedgeCountVal <= 0;
				tedgeCountVal <= 0;
				ledgeCountVal <= 0;
				redgeCountVal <= 0;
            Ball_Y_Motion <= 0;
				Ball_X_Motion <= Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
           
        else 
        begin 
				Ball_Y_Motion <= Ball_Y_Motion;
				
				if (((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max) && (bedgeCountVal == 0))  // Ball is at the bottom edge, BOUNCE!
					begin
						Ball_Y_Motion <= (~ (Ball_Y_Motion) + 1'b1);
						bedgeCountVal <= bedgeCountVal + 1;
					end
				 
				else if (((Ball_Y_Pos - Ball_Size) <= Ball_Y_Min) && (tedgeCountVal == 0))  // Ball is at the top edge, BOUNCE!
					begin
						Ball_Y_Motion <= (~ (Ball_Y_Motion) + 1'b1);
						tedgeCountVal <= tedgeCountVal + 1;
					end
					
				else if (((Ball_X_Pos + Ball_Size) >= Ball_X_Max) && (redgeCountVal == 0))  // Ball is at the Right edge, BOUNCE!
					begin
					  Ball_X_Motion <= (~ (Ball_X_Motion) + 1'b1); 
					  redgeCountVal <= redgeCountVal + 1;
					end
					
				else if (((Ball_X_Pos - Ball_Size) <= Ball_X_Min) && (ledgeCountVal == 0))  // Ball is at the Left edge, BOUNCE!
					begin
					  Ball_X_Motion <= (~ (Ball_X_Motion) + 1'b1);
					  ledgeCountVal <= ledgeCountVal + 1;
					end
					
					
				if (bedgeCountVal > 0 && bedgeCountVal < 3)
					begin
					  bedgeCountVal <= bedgeCountVal + 1;
					end
				else if (bedgeCountVal == 3)
					begin
						bedgeCountVal <= 0;
					end
					
				if (tedgeCountVal > 0 && tedgeCountVal < 3)
					begin
					  tedgeCountVal <= tedgeCountVal + 1;
					end
				else if (tedgeCountVal == 3)
					begin
						tedgeCountVal <= 0;
					end
					
				if (ledgeCountVal > 0 && ledgeCountVal < 3)
					begin
					  ledgeCountVal <= ledgeCountVal + 1;
					end
				else if (ledgeCountVal == 3)
					begin
						ledgeCountVal <= 0;
					end
					
				if (redgeCountVal > 0 && redgeCountVal < 3)
					begin
					  redgeCountVal <= redgeCountVal + 1;
					end
				else if (redgeCountVal == 3)
					begin
						redgeCountVal <= 0;
					end
					 
				//if hits paddle1
				//rightEdge
				if (((Ball_X_Pos - Ball_Size) <= paddle1maxWidth) && 
					((Ball_Y_Pos - Ball_Size) <= paddle1maxHeight ) &&
					((Ball_Y_Pos + Ball_Size) >= paddle1minHeight ))
					begin
						Ball_X_Motion <= Ball_X_Step;
						Ball_Y_Motion <= bally1motion;
						if (bally1motion < 0)
							Ball_Y_Motion <= (~ (bally1motion) + 1'b1);
					end
				
				//if hits paddle2
				//leftEdge
				if (((Ball_X_Pos + Ball_Size) >= paddle2minWidth) && 
					((Ball_Y_Pos - Ball_Size) <= paddle2maxHeight ) &&
					((Ball_Y_Pos + Ball_Size) >= paddle2minHeight ))
					begin
						Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
						Ball_Y_Motion <= bally2motion;
						if (bally2motion < 0)
							Ball_Y_Motion <= (~ (bally2motion) + 1'b1);
					end
				
//				 case (keycode)
//					8'h04 : begin
//								if ((Ball_X_Pos - Ball_Size) > Ball_X_Min)
//									begin
//										Ball_X_Motion <= -Ball_X_Step;//A
//										Ball_Y_Motion<= 0;
//									end
//							  end    
//					8'h07 : begin
//								if ((Ball_X_Pos + Ball_Size) < Ball_X_Max)
//									begin	
//										Ball_X_Motion <= Ball_X_Step;//D
//										Ball_Y_Motion <= 0;	
//									end
//							  end 
//					8'h16 : begin
//								if ((Ball_Y_Pos + Ball_Size) < Ball_Y_Max)
//									begin	
//										Ball_Y_Motion <= Ball_Y_Step;//S
//										Ball_X_Motion <= 0;		
//									end   
//							 end		  
//					8'h1A : begin
//								if ((Ball_Y_Pos - Ball_Size) > Ball_Y_Min)
//									begin
//										Ball_Y_Motion <= -Ball_Y_Step;//W
//										Ball_X_Motion <= 0;
//									end
//							 end	  
//					default: ;
//			   endcase
				 
				Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
		end  
    end
		 
	assign BallX = Ball_X_Pos;
	assign BallY = Ball_Y_Pos;
	assign BallS = Ball_Size;

endmodule
