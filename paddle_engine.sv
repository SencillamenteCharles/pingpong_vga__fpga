/* padle engine 



The paddle is composed by 3 elements: paddle.center, paddle.top, paddle.bottom.
 
Each element has the same  x coordinate, which is always the same, but is equal to  PARAMETER STATIC_PADDLE_X.
This is like saying paddle.center.x = STATIC_PADDLE_X, paddle.top.x = STATIC_PADDLE_X,  paddle.bottom.x = STATIC_PADDLE_X

During reset low, each of the paddle elementrs will get a default value. This value is equal to PARAMETER 
DEFAULT_PADDLE_Y. The paddle.center.y will be equal to DEFAULT_PADDLE_Y. 

paddle.top will always be paddle.center + 1,  paddle.bottom will always be paddle.center -1.


When reset is not asserted, the paddle will be able go up and down in y. when i_paddle_down is detected, 
the paddle.center.y will be decreased by one, on each cicle of course. When i_paddle_up is detected the
paddle.center.y will be increased by 1. This means that to move the paddle coordinates only by 1 element the i_paddle_down and the 
i_paddle_up signals must be a pulse of the duration of a paddle clock pulse paddle_clk.



*/



import paddle_pkg::*;

module paddle_engine #( 
  parameter int FIELD_X_MIN      =  0, 
  parameter int FIELD_X_MAX      =  40,
  parameter int FIELD_Y_MIN      =  0,
  parameter int FIELD_Y_MAX      =  20,
  parameter int STATIC_PADDLE_X  =  1,
  parameter int DEFAULT_PADDLE_Y =  10,
  parameter int MAX_Y            =  23, // Upper screen boundary (prevents overflow)
  parameter int MIN_Y            =  0    // Lower screen boundary (prevents underflow)
) (
  input  logic    paddle_clk,    // Paddle clock
  input  logic    rst_n,         // Active-low asynchronous reset
  input  logic    i_paddle_up,   // 1-cycle pulse to move paddle up (+1)
  input  logic    i_paddle_down, // 1-cycle pulse to move paddle down (-1)

  output paddle_t o_paddle_coords         // Output paddle coordinates
);

  // Internal register to track the center Y position
  logic [9:0] center_y_reg;
  

  // Sequential logic for updating center Y position
  always_ff @(posedge paddle_clk or negedge rst_n) begin
    if (!rst_n) begin
      center_y_reg <= DEFAULT_PADDLE_Y;
    end else begin
      // Move up if i_paddle_up is asserted (and not moving down simultaneously)
      if (i_paddle_up ) begin
        if (center_y_reg <= (MAX_Y)) begin
          center_y_reg <= center_y_reg + 1'b1;
		
        end else 
		 center_y_reg <= center_y_reg;
		  
      end 
      // Move down if i_paddle_down is asserted (and not moving up simultaneously)
      else if (i_paddle_down ) begin
        if (center_y_reg > (MIN_Y+1)) begin
          center_y_reg <= center_y_reg - 1'b1;
			 
        end
      end
    end
  end

  // Combinational assignments for static X and relative Y coordinates
  always_comb begin
    // Constant X coordinates
    o_paddle_coords.center.x = STATIC_PADDLE_X;
    o_paddle_coords.top.x    = STATIC_PADDLE_X;
    o_paddle_coords.bottom.x = STATIC_PADDLE_X;

    // Y coordinates relative to center
    o_paddle_coords.center.y = center_y_reg;
    o_paddle_coords.top.y    = center_y_reg + 1'b1;
    o_paddle_coords.bottom.y = center_y_reg - 1'b1;
  end

endmodule