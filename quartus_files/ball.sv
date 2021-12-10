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
					output[3:0] scoreL, scoreR,
					output		resetB, paddle1Hit, paddle2Hit, nGame, eGame);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 logic [5:0] ledgeCountVal, redgeCountVal, tedgeCountVal, bedgeCountVal;
	 logic 		 resetBall, newGame, endGame;
	 logic [3:0] score_left, score_right;
	 
    parameter [9:0] Ball_X_Center=320;
    parameter [9:0] Ball_Y_Center=240;
    parameter [9:0] Ball_X_Min=33;
    parameter [9:0] Ball_X_Max=596;
    parameter [9:0] Ball_Y_Min=20;
    parameter [9:0] Ball_Y_Max=461;
    parameter [9:0] Ball_X_Step=7; 
    parameter [9:0] Ball_Y_Step=5;

    assign Ball_Size = 5;
	 int paddle1minHeight, paddle1maxHeight, paddle1minWidth, paddle1maxWidth;
	 int paddle2minHeight, paddle2maxHeight, paddle2minWidth, paddle2maxWidth;
	 int bally1motion, bally2motion, ballExtra;
	 
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
        if (Reset)
		  //initalize ball
        begin 
				ballExtra <= 0;
				paddle1Hit <= 0;
				paddle2Hit <= 0;
				resetBall <= 0;
				score_left <= 0;
				score_right <= 0;
				bedgeCountVal <= 0;
				tedgeCountVal <= 0;
				ledgeCountVal <= 0;
				redgeCountVal <= 0;
            Ball_Y_Motion <= 0;
				Ball_X_Motion <= 0;
				newGame <= 1;
				endGame <= 0;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
		  else if (endGame)
		  begin
				ballExtra <= 0;
				paddle1Hit <= 0;
				paddle2Hit <= 0;
				resetBall <= 0;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				Ball_Y_Motion <= 0;
				Ball_X_Motion <= 0;
				bedgeCountVal <= 0;
				tedgeCountVal <= 0;
				ledgeCountVal <= 0;
				redgeCountVal <= 0;
				if (keycode >= 1)
				begin
					endGame <= 0;
					resetBall <= 1;
					score_right<=0;
					score_left<=0;
				end
				end
        else if (resetBall)
		  begin
				ballExtra <= 0;
				paddle1Hit <= 0;
				paddle2Hit <= 0;
				resetBall <= 0;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				Ball_Y_Motion <= 0;
				bedgeCountVal <= 0;
				tedgeCountVal <= 0;
				ledgeCountVal <= 0;
				redgeCountVal <= 0;
				Ball_X_Motion <= Ball_X_Step;
				end
        else 
				begin
				Ball_Y_Motion <= Ball_Y_Motion;
				
				if (((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max) && (bedgeCountVal == 0))  //bottom
					begin
						Ball_Y_Motion <= (~ (Ball_Y_Motion) + 1'b1);
						bedgeCountVal <= bedgeCountVal + 1;
					end
				 
				else if (((Ball_Y_Pos - Ball_Size) <= Ball_Y_Min) && (tedgeCountVal == 0))  //top
					begin
						Ball_Y_Motion <= (~ (Ball_Y_Motion) + 1'b1);
						tedgeCountVal <= tedgeCountVal + 1;
					end
					
				else if (((Ball_X_Pos + Ball_Size) >= Ball_X_Max) && (redgeCountVal == 0))  //right
					begin
					  Ball_X_Motion <= (~ (Ball_X_Motion + ballExtra) + 1'b1); 
					  redgeCountVal <= redgeCountVal + 1;
					  score_left <= score_left + 1;
					  resetBall <= 1;
					end
					
				else if (((Ball_X_Pos - Ball_Size) <= Ball_X_Min) && (ledgeCountVal == 0))  //left
					begin
					  Ball_X_Motion <= (~ (Ball_X_Motion + ballExtra) + 1'b1);
					  ledgeCountVal <= ledgeCountVal + 1;
					  score_right <= score_right + 1;
					  resetBall <= 1;
					end
					
					
				if (bedgeCountVal > 0 && bedgeCountVal < 63)
					begin
						bedgeCountVal <= bedgeCountVal + 1;
					end
				else if (bedgeCountVal == 63)
					begin
						bedgeCountVal <= 0;
					end
					
				if (tedgeCountVal > 0 && tedgeCountVal < 63)
					begin
					  tedgeCountVal <= tedgeCountVal + 1;
					end
				else if (tedgeCountVal == 63)
					begin
						tedgeCountVal <= 0;
					end
					
				if (ledgeCountVal > 0 && ledgeCountVal < 63)
					begin
					  ledgeCountVal <= ledgeCountVal + 1;
					end
				else if (ledgeCountVal == 63)
					begin
						ledgeCountVal <= 0;
					end
					
				if (redgeCountVal > 0 && redgeCountVal < 63)
					begin
					  redgeCountVal <= redgeCountVal + 1;
					end
				else if (redgeCountVal == 63)
					begin
						redgeCountVal <= 0;
					end
					 
				//if hits paddle1
				//rightEdge
				if (((Ball_X_Pos - Ball_Size) <= paddle1maxWidth) && 
					((Ball_Y_Pos - Ball_Size) <= paddle1maxHeight ) &&
					((Ball_Y_Pos + Ball_Size) >= paddle1minHeight ) &&
					((Ball_X_Pos + Ball_Size) >= paddle1minWidth ))
					begin
						Ball_X_Motion <= (Ball_X_Step + ballExtra);
						ledgeCountVal <= 0;
						redgeCountVal <= 0;
						tedgeCountVal <= 0; 
						bedgeCountVal <= 0;
						paddle1Hit <= 1;
						Ball_Y_Motion <= bally1motion;
						if (bally1motion < 0)
						begin
							Ball_Y_Motion <= (~ (bally1motion) + 1'b1);
						end
					end
				else
					begin	
						paddle1Hit <= 0;
					end
				
				//if hits paddle2
				//leftEdge
				if (((Ball_X_Pos + Ball_Size) <= paddle2minWidth) && 
					((Ball_Y_Pos - Ball_Size) <= paddle2maxHeight ) &&
					((Ball_Y_Pos + Ball_Size) >= paddle2minHeight ) &&
					((Ball_X_Pos + Ball_Size) >= paddle2minWidth ))
					begin
						Ball_X_Motion <= (~ (Ball_X_Step + ballExtra) + 1'b1);
						ledgeCountVal <= 0;
						redgeCountVal <= 0;
						tedgeCountVal <= 0; 
						bedgeCountVal <= 0;
						paddle2Hit <= 1;
						Ball_Y_Motion <= bally2motion;
						if (bally2motion < 0)
							Ball_Y_Motion <= (~ (bally2motion) + 1'b1);
					end
				else
					begin	
						paddle2Hit <= 0;
					end
				
				if (( (score_left == 7) || (score_right == 7)))
					begin
						endGame <= 1;
					end
				 
				Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				if (keycode == 20)
					Ball_X_Motion <= (Ball_X_Motion + 1);
				if (keycode == 4)
					Ball_X_Motion <= (Ball_X_Motion - 1);
					
				if (keycode >= 1 && newGame)
				begin
					newGame <= 0;
					resetBall <= 1;
				end
		end  
    end
	 
	assign eGame = endGame;
	assign nGame = newGame;
	assign resetB =  resetBall;
	assign scoreL = score_left;
	assign scoreR = score_right;
	assign BallX = Ball_X_Pos;
	assign BallY = Ball_Y_Pos;
	assign BallS = Ball_Size;

endmodule
