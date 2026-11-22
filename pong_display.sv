

import paddle_pkg::*;

module pong_display #(
    parameter SCALE = 20
) (
    input  wire [9:0]  v_counter,    // v pos of vga driver
    input  wire [9:0]  h_counter,    // h pos of vga driver
    input  wire        active_video,
	 input  paddle_t i_paddle_left_coords,
	 input  paddle_t i_paddle_right_coords,
	 input  logic [10-1:0] ball_x,
    input  logic [10-1:0] ball_y, 
	
	

    output wire [23:0] rgb
);

    reg [23:0] rgb_tmp;
	 reg [23:0] rgb_;

	 
	 /// draw field 
    always @(*) begin
	 
	 
	 ///draw field lines
        if (!active_video) begin
            rgb_tmp = 24'h000000;
			end

    
      
		// L paddle *****************************************************************************************************************	
		  else if (
							(h_counter > ( i_paddle_left_coords.center.x * SCALE))  && (h_counter < ((i_paddle_left_coords.center.x+1)*SCALE)) &&
		               (v_counter > (i_paddle_left_coords.center.y * SCALE)) &&    (v_counter < ((i_paddle_left_coords.center.y+1) * SCALE))
							) begin	
				           rgb_tmp = 24'hFF_02_FF; // YELLOW
        end
		  else if ((h_counter > ( i_paddle_left_coords.bottom.x * SCALE))  && (h_counter < ((i_paddle_left_coords.bottom.x+1)*SCALE)) &&
		            (v_counter > (i_paddle_left_coords.bottom.y * SCALE)) &&    (v_counter < ((i_paddle_left_coords.bottom.y+1) * SCALE))) begin	
				       rgb_tmp = 24'hFF_02_FF; // YELLOW
        end  
		  else if ((h_counter > ( i_paddle_left_coords.top.x * SCALE))  && (h_counter < ((i_paddle_left_coords.top.x+1)*SCALE)) &&
		            (v_counter > (i_paddle_left_coords.top.y * SCALE)) &&    (v_counter < ((i_paddle_left_coords.top.y+1) * SCALE))) begin	
				       rgb_tmp = 24'hFF_50_FF; // YELLOW
        end 
		  // R paddle *****************************************************************************************************************
		 else if (
							(h_counter > ( i_paddle_right_coords.center.x * SCALE))  && (h_counter < ((i_paddle_right_coords.center.x+1)*SCALE)) &&
		               (v_counter > (i_paddle_right_coords.center.y * SCALE)) &&    (v_counter < ((i_paddle_right_coords.center.y+1) * SCALE))
							) begin	
				           rgb_tmp = 24'hFF_FF_00; // 
        end
		  else if ((h_counter > ( i_paddle_right_coords.bottom.x * SCALE))  && (h_counter < ((i_paddle_right_coords.bottom.x+1)*SCALE)) &&
		            (v_counter > (i_paddle_right_coords.bottom.y * SCALE)) &&    (v_counter < ((i_paddle_right_coords.bottom.y+1) * SCALE))) begin	
				       rgb_tmp = 24'hFF_FF_10; 
        end  
		  else if ((h_counter > ( i_paddle_right_coords.top.x * SCALE))  && (h_counter < ((i_paddle_right_coords.top.x+1)*SCALE)) &&
		            (v_counter > (i_paddle_right_coords.top.y * SCALE)) &&    (v_counter < ((i_paddle_right_coords.top.y+1) * SCALE))) begin	
				       rgb_tmp = 24'hFF_FF_08; // YELLOW
        end
		  
		  
		  /** BALL ***********************************************************************************************************************************/
		   else if ((h_counter > ( ball_x * SCALE))  && (h_counter < ((ball_x+1)*SCALE)) &&
		            (v_counter > (ball_y * SCALE)) &&    (v_counter < ((ball_y +1) * SCALE))) begin	
				       rgb_tmp = 24'hFF_A5_00; // expected to be orange
        end
		  
		  else begin
            rgb_tmp = 24'h222222; // Dark Gray
        end
    end

	 
	 
	 
    assign rgb = rgb_tmp;

endmodule