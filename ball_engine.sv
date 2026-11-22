

/** 

this module increases or decreases the coordinates of the ball depending on the following signals

the changes for all variables are determined by the clk.


The initial values for o_x and o_y are determined by the several conditions:

    1 there is a posedge clk. 
	 2 there is nededge of rst_n. 
	 3 after the 2 above conditions are met, the  o_x will be equal to initial_x and the o_y will be equal to initial_y. 
	 
Eack clk posedge, and while the rst_n is deasserted, or high,  the 	 o_x, o_y and o_current_angle will change in the following way:


1 depending in the o_current_angle, enumerated as  6 positions: left, left_up, left_down, rigth, rigth_up, rigth_down. The o_x and o_y will change by one or not. 

	 
	 left      : o_y will not change,   o_x will decrease.
    left_up   : o_y will increase,     o_x will decrease.
	 left_down : oy will decrease,      o_x will decrease.
	 rigth     : o_y will not change,   o_x will increase.
	 rigth_up  : o_y will increase,     o_x will increase.
	 rigth_down: oy will decrease,      o_x will increase.
	 
2 	 o_current_angle will be always equal to i_new_angle
*/

/** added feature to ball bounce top and bottom of the screeen*/

import ball_pkg::*;

module ball_engine #(
  parameter int COORD_WIDTH =6 , // Adjust width to match your screen/grid resolution
  parameter int MIN_Y = 0,
  parameter int MAX_Y = 23,
  parameter int MIN_X = 0,
  parameter int MAX_X = 31
)(
  input  logic                   clk,
  input  logic                   rst_n, 
  input  logic                   i_move,        // Optional movement enable (see note below)
  input  angle_t                 i_new_angle,
  input  logic [COORD_WIDTH-1:0] initial_x,
  input  logic [COORD_WIDTH-1:0] initial_y,

  output angle_t                 o_current_angle,
  output logic [COORD_WIDTH-1:0] o_current_x,
  output logic [COORD_WIDTH-1:0] o_current_y
);



logic [COORD_WIDTH-1:0] o_x;
logic [COORD_WIDTH-1:0] o_y;
angle_t angle_reg ;


  // Asynchronous active-low reset, synchronous clock edge
  always_ff @(posedge clk or negedge rst_n) begin
  
     angle_reg <= i_new_angle;
    if (!rst_n) begin
      o_x             <= initial_x;
      o_y             <= initial_y;
    // Default reset state (or assign to i_new_angle)
    end else begin

      // Update X and Y coordinates based on o_current_angle
      
      case (angle_reg)
        LEFT: begin
		    if(o_x >= MIN_X)//allow to get to minus one
              o_x <= o_x - 1'b1;
        end

        LEFT_UP: begin
				if( (o_x >= MIN_X+1) && (o_y <= MAX_Y))begin
					o_x <= o_x - 1'b1;
					o_y <= o_y + 1'b1;	 
			    end
        end

        LEFT_DOWN: begin
         
				if( (o_x >= MIN_X) && (o_y >= MIN_Y+1))begin
					o_x <= o_x - 1'b1;
					o_y <= o_y - 1'b1;	 
			    end 
        end

        RIGHT: begin
          o_x <= o_x + 1'b1;
   
        end

        RIGHT_UP: begin
			 	if( (o_x <= (MAX_X)) && (o_y <= MAX_Y))begin
				 o_x <= o_x + 1'b1;
             o_y <= o_y + 1'b1; 
			    end 
		
			 
        end

        RIGHT_DOWN: begin
       
			
			if( (o_x <= (MAX_X-1)) && (o_y >= MIN_Y+1))begin
				   o_x <= o_x + 1'b1;
                o_y <= o_y - 1'b1;
			    end
        end

        default: begin
          o_x <= o_x;
          o_y <= o_y;
			
        end
      endcase
    end
	 
	 
	
  end

  assign  o_current_x = o_x;
  assign  o_current_y = o_y; 
  assign  o_current_angle = angle_reg;
endmodule