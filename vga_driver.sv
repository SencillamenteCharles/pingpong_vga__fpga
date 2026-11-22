

import paddle_pkg::*;
import ball_pkg::*;

// pong module 
module vga_driver (
    input  wire       CLOCK_50,
    input  wire rst_n,          // KEY[0] acts as active-low reset
	 input  wire  KEY_0,  
	 input  wire  KEY_1,  
	 input  wire  KEY_2,  
	 input  wire  KEY_3,  
    output wire [7:0] VGA_R,
    output wire [7:0] VGA_G,
    output wire [7:0] VGA_B,
    output wire       VGA_HS,
    output wire       VGA_VS,
    output wire       VGA_CLK,
    output wire       VGA_BLANK_N,
    output wire       VGA_SYNC_N
);


wire  [23:0] w_rgb; 
wire  [9:0]  v_counter;
wire  [9:0]  h_counter; 
wire  w_active_video; 
paddle_t w_paddle_left_coords;
paddle_t w_paddle_right_coords;
wire w_paddle_clk;
wire w_ball_clk;

wire  w_paddle_up_l;
wire  w_paddle_down_l;
wire  w_paddle_up_r;
wire  w_paddle_down_r;
wire [6-1:0] w_ball_current_x;
wire [6-1:0] w_ball_current_y;
angle_t w_ball_current_angle;
angle_t w_ball_new_angle;


one_shot_counter #(
    .COUNT_CYCLES (300_000)
) u_paddle_up_l (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_3),
    .out_pulse    (w_paddle_up_l)
);

one_shot_counter #(
    .COUNT_CYCLES (300_000)
) u_paddle_down_l (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_2),
    .out_pulse    (w_paddle_down_l)
);

one_shot_counter #(
    .COUNT_CYCLES (300_000)
) u_paddle_up_r (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_1),
    .out_pulse    (w_paddle_up_r)
);

one_shot_counter #(
    .COUNT_CYCLES (300_000)
) u_paddle_down_r (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_0),
    .out_pulse    (w_paddle_down_r)
);

/*
one_shot_counter #(
    .COUNT_CYCLES (3)
) u_paddle_up_l (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_3),
    .out_pulse    (w_paddle_up_l)
);

one_shot_counter #(
    .COUNT_CYCLES (3)
) u_paddle_down_l (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_2),
    .out_pulse    (w_paddle_down_l)
);

one_shot_counter #(
    .COUNT_CYCLES (3)
) u_paddle_up_r (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_1),
    .out_pulse    (w_paddle_up_r)
);

one_shot_counter #(
    .COUNT_CYCLES (3)
) u_paddle_down_r (
    .clk          (CLOCK_50),
    .rst_n        (rst_n),
    .start_n      (KEY_0),
    .out_pulse    (w_paddle_down_r)
);

*/




//paddle clock generator.
free_running_counter #(
    .TOP_COUNT ( 150_000 )
) u_paddle_clock (
    .clk           ( CLOCK_50 ),
    .rst_n         ( rst_n ),
    .en            ( 1'b1),//always enabled
    .out_tgl       ( w_paddle_clk),
    .o_tgl_counter (  )
);



paddle_engine #(
    .FIELD_X_MIN      (0),
    .FIELD_X_MAX      (31), 
    .FIELD_Y_MIN      (0),
    .FIELD_Y_MAX      (10), 
    .STATIC_PADDLE_X  (2),
    .DEFAULT_PADDLE_Y (15),
    .MAX_Y            (23), // Leaves 1-cell border for bottom wall
    .MIN_Y            (0)   // Leaves 1-cell border for top wall
) u_paddle_left_engine (
    .paddle_clk    (w_paddle_clk),
    .rst_n         (rst_n),
    .i_paddle_up   (w_paddle_up_l),
    .i_paddle_down (w_paddle_down_l),
    .o_paddle_coords(w_paddle_left_coords)
);



paddle_engine #(
    .FIELD_X_MIN      (0),
    .FIELD_X_MAX      (31), 
    .FIELD_Y_MIN      (0),
    .FIELD_Y_MAX      (10), 
    .STATIC_PADDLE_X  (29),
    .DEFAULT_PADDLE_Y (13),
    .MAX_Y            (23), // Leaves 1-cell border for bottom wall
    .MIN_Y            (0)   // Leaves 1-cell border for top wall
) u_paddle_r_engine (
    .paddle_clk    (w_paddle_clk),
    .rst_n         (rst_n),
    .i_paddle_up   (w_paddle_up_r),
    .i_paddle_down (w_paddle_down_r),
    .o_paddle_coords(w_paddle_right_coords)
);





 vga_480_680_de10_driver u_vga_driver (
    .CLOCK_50    (CLOCK_50),
    .KEY         (rst_n),
	 .rgb          (w_rgb), 
    .VGA_R       (VGA_R),
    .VGA_G       (VGA_G),
    .VGA_B       (VGA_B),
    .VGA_HS      (VGA_HS),
    .VGA_VS      (VGA_VS),
    .VGA_CLK     (VGA_CLK),
    .VGA_BLANK_N (VGA_BLANK_N),
    .VGA_SYNC_N  (VGA_SYNC_N),
	 .v_counter(v_counter), // v pos of vga driver
	 .h_counter(h_counter), 
	 .o_active_video(w_active_video)
);


/**   BALL ENGINE ******************************************************************************************************************/
free_running_counter #(
    .TOP_COUNT ( 5_000_000 )
	 //.TOP_COUNT ( 10)
) u_ball_clk(
    .clk           ( CLOCK_50 ),
    .rst_n         ( rst_n ),
    .en            ( 1'b1),//always enabled
    .out_tgl       ( w_ball_clk),
    .o_tgl_counter (  )
);

hit_engine u_hit_engine (
    .clk                  (w_ball_clk),
    .rst_n                (rst_n),
    .i_initial_ball_x     (w_ball_current_x),
    .i_initial_ball_y     (w_ball_current_y),
    .i_initial_ball_angle (w_ball_current_angle),
	 .i_paddle_left_pos(w_paddle_left_coords),
	 .i_paddle_right_pos(w_paddle_right_coords),
    .o_new_ball_x         (),
    .o_new_ball_y         (),
    .o_new_ball_angle     (w_ball_new_angle)
);


ball_engine #(
    .COORD_WIDTH (6),
	 .MIN_Y(0),
	 .MAX_Y(23), 
	 .MIN_X(6'd0),
	 .MAX_X(31)
  ) u_ball_engine (
    .clk             (w_ball_clk),
    .rst_n           (rst_n),
    .i_move          (0),
    .i_new_angle     (w_ball_new_angle),
    .initial_x       (29),
    .initial_y       (13),
    .o_current_angle (w_ball_current_angle),
    .o_current_x             (w_ball_current_x),
    .o_current_y             (w_ball_current_y)
  );



//with a scale of 20 will multiply by 20 each received coordinate. 
pong_display   #(
  .SCALE(20)
)
  u_pong_display(
 .v_counter(v_counter), // v pos of vga driver
 .h_counter(h_counter),  // v pos of vga driver
 .active_video(w_active_video),  
 .i_paddle_left_coords(w_paddle_left_coords),
 .i_paddle_right_coords(w_paddle_right_coords),
 .ball_x( w_ball_current_x ),
 .ball_y( w_ball_current_y ),
 .rgb(w_rgb)
 );
 
endmodule