//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module color (	input			[9:0] BallX, BallY, DrawX, DrawY, Ball_size,
					input			[9:0] Paddle1X, Paddle1Y, Paddle2X, Paddle2Y, 
											Paddle1L, Paddle1W, Paddle2L, Paddle2W,			 
					output logic[7:0]  Red, Green, Blue );
					
    logic ball_on;
	 logic paddle1_on;
	 logic paddle2_on;
	 
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//    int DistX, DistY, Size;
//	 assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
	  
    always_comb
    begin:Ball_on_proc
            if ((DrawX >= BallX - Ball_size) &&
					(DrawX <= BallX + Ball_size) &&
					(DrawY >= BallY - Ball_size) &&
					(DrawY <= BallY + Ball_size))
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
       
	 always_comb
    begin:paddle1_on_proc
			if ((DrawX >= Paddle1X - Paddle1W) &&
				(DrawX <= Paddle1X + Paddle1W) &&
				(DrawY >= Paddle1Y - Paddle1L) &&
				(DrawY <= Paddle1Y + Paddle1L))
            paddle1_on = 1'b1;
			else 
            paddle1_on = 1'b0;
     end 
	
	 always_comb
    begin:paddle2_on_proc
			if ((DrawX >= Paddle2X - Paddle2W) &&
				(DrawX <= Paddle2X + Paddle2W) &&
				(DrawY >= Paddle2Y - Paddle2L) &&
				(DrawY <= Paddle2Y + Paddle2L))
					paddle2_on = 1'b1;
			else 
					paddle2_on = 1'b0;
     end 
		 
	always_comb
	begin:RGB_Display
		  //background (blue)
				Red = 8'h00; 
				Green = 8'h00;
				Blue = 8'h7f;
			
			if ((ball_on == 1'b1)) 
				begin 
				//ball color (red)
					Red = 8'hff;
					Green = 8'h00;
					Blue = 8'h00;
				end  
			if ((paddle1_on == 1'b1)) 
				begin 
				//paddle1 color (white)
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end  
			if ((paddle2_on == 1'b1)) 
				begin 
				//paddle2 color (white)
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end  
	end 
    
endmodule
