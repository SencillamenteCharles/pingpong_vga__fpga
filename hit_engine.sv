
import ball_pkg::*;
import paddle_pkg::*;
import field_dim_pkg::*;



/** do ball bounce*/
module hit_engine(

//standard intputs
  input  logic                   clk,
  input  logic                   rst_n,
// ball inputs
  input  logic [5:0] i_initial_ball_x,
  input  logic [5:0] i_initial_ball_y,
  input angle_t                i_initial_ball_angle,
  input paddle_t i_paddle_left_pos,   
  input paddle_t i_paddle_right_pos,   // Output paddle coordinates
  
  
  //ball outputs
  output logic [5:0] o_new_ball_x,
  output logic [5:0] o_new_ball_y,
  output angle_t                 o_new_ball_angle
  
);

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_new_ball_angle <= LEFT_DOWN;
  end else begin
    // Top wall (Y max) -> bounce DOWN
    if (i_initial_ball_y >= FIELD_Y_MAX && o_new_ball_angle == RIGHT_UP) begin
      o_new_ball_angle <= RIGHT_DOWN;
    end else if (i_initial_ball_y >= FIELD_Y_MAX && o_new_ball_angle == LEFT_UP) begin
      o_new_ball_angle <= LEFT_DOWN;
    
    // Bottom wall (Y min) -> bounce UP
    end else if (i_initial_ball_y <= FIELD_XY_MIN && o_new_ball_angle == LEFT_DOWN) begin
      o_new_ball_angle <= LEFT_UP;
    end else if (i_initial_ball_y <= FIELD_XY_MIN && o_new_ball_angle == RIGHT_DOWN) begin
      o_new_ball_angle <= RIGHT_UP;
    end
	 
	 else if (  ( i_initial_ball_x ==  i_paddle_left_pos.top.x+1 ) &&  (i_initial_ball_y == i_paddle_left_pos.center.y) && (i_initial_ball_angle== LEFT ||  i_initial_ball_angle== LEFT_UP  ||  i_initial_ball_angle== LEFT_DOWN)) begin
	      o_new_ball_angle <=  RIGHT;
	 end 
	
	 else if (  ( i_initial_ball_x ==  i_paddle_left_pos.top.x+1 ) &&  (i_initial_ball_y == i_paddle_left_pos.top.y)   && (i_initial_ball_angle== LEFT ||  i_initial_ball_angle== LEFT_UP  ||  i_initial_ball_angle== LEFT_DOWN)) begin
	      o_new_ball_angle <=  RIGHT_UP;
	 end 
	 
	 else if (  ( i_initial_ball_x ==  i_paddle_left_pos.top.x+1 ) &&  (i_initial_ball_y == i_paddle_left_pos.top.y+1)  && (i_initial_ball_angle== LEFT ||  i_initial_ball_angle== LEFT_UP  ||  i_initial_ball_angle== LEFT_DOWN)) begin
	      o_new_ball_angle <=  RIGHT_UP;
	 end 
	 
	 else if (  ( i_initial_ball_x ==  i_paddle_left_pos.top.x+1 ) &&  (i_initial_ball_y == i_paddle_left_pos.bottom.y) && (i_initial_ball_angle== LEFT ||  i_initial_ball_angle== LEFT_UP  ||  i_initial_ball_angle== LEFT_DOWN)) begin
	      o_new_ball_angle <=  RIGHT_DOWN;
	 end 
	 else if (  ( i_initial_ball_x ==  i_paddle_left_pos.top.x+1 ) &&  (i_initial_ball_y == i_paddle_left_pos.bottom.y-1)  && (i_initial_ball_angle== LEFT ||  i_initial_ball_angle== LEFT_UP  ||  i_initial_ball_angle== LEFT_DOWN)) begin
	      o_new_ball_angle <=  RIGHT_DOWN;
	 end 
	 
	 
	 else if (  ( i_initial_ball_x ==  i_paddle_right_pos.top.x-1 ) &&  (i_initial_ball_y == i_paddle_right_pos.center.y)  && (i_initial_ball_angle== RIGHT ||  i_initial_ball_angle== RIGHT_UP  ||  i_initial_ball_angle== RIGHT_DOWN)) begin
	      o_new_ball_angle <=  LEFT;
	 end 
	 else if (  ( i_initial_ball_x ==  i_paddle_right_pos.top.x-1 ) &&  (i_initial_ball_y == i_paddle_right_pos.top.y) ) begin
	      o_new_ball_angle <=  LEFT_UP;
	 end 
	 else if (  ( i_initial_ball_x ==  i_paddle_right_pos.top.x-1 ) &&  (i_initial_ball_y == i_paddle_right_pos.top.y+1) ) begin
	      o_new_ball_angle <=  LEFT_UP;
	 end 
	 else if (  ( i_initial_ball_x ==  i_paddle_right_pos.top.x-1 ) &&  (i_initial_ball_y == i_paddle_right_pos.bottom.y) ) begin
	      o_new_ball_angle <=  LEFT_DOWN;
	 end 
	  else if (  ( i_initial_ball_x ==  i_paddle_right_pos.top.x-1 ) &&  (i_initial_ball_y == i_paddle_right_pos.bottom.y-1) ) begin
	      o_new_ball_angle <=  LEFT_DOWN;
	 end 
	 
	 /**
	 else if ( i_initial_ball_x <= FIELD_XY_MIN)begin
	       o_new_ball_angle <=  RIGHT_DOWN;
	 end 
	 
	 else if ( i_initial_ball_x >= FIELD_X_MAX)begin
	       o_new_ball_angle <=  LEFT_UP;
	 end
	 
    // No hit  -> keep current angle
     else begin
      o_new_ball_angle <= o_new_ball_angle;
    end
	 */
	 
  end
end
endmodule
