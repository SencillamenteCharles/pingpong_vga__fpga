
/** this driver module is made for the DE10 standard because it includes additional signals for its VGA driver. 

to use it you need to read current v and h positions and send the rgb colour you want during the desired h and v*/


module vga_480_680_de10_driver (
    input  wire       CLOCK_50,
    input  wire [0:0] KEY,	 // KEY[0] acts as active-low reset
	 input  reg [23:0] rgb,  //input value of the rgb
    output wire [7:0] VGA_R,
    output wire [7:0] VGA_G,
    output wire [7:0] VGA_B,
    output wire       VGA_HS,
    output wire       VGA_VS,
    output wire       VGA_CLK,
    output wire       VGA_BLANK_N,
    output wire       VGA_SYNC_N,
	 output reg [9:0]  v_counter, // v pos of vga driver
	 output reg [9:0]  h_counter,  // v pos of vga driver
	 output logic o_active_video
);

    wire rst = KEY[0];
    reg  clk_25 = 0;

    // 1. Divide 50 MHz board clock to 25 MHz pixel clock
    always @(posedge CLOCK_50) begin
        clk_25 <= ~clk_25;
    end

    // 2. 640x480 @ 60Hz Timing Constants
    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800; // 640 + 16 + 96 + 48

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525; // 480 + 10 + 2 + 33
	 
	 
	 localparam MAP_20_PIXELS =20 ;

    reg [9:0] h_cnt = 0;
    reg [9:0] v_cnt = 0;

    // 3. Horizontal and Vertical Raster Counters
    always @(posedge clk_25 or negedge rst) begin
        if (!rst) begin
            h_cnt <= 0;
            v_cnt <= 0;
        end else begin
            if (h_cnt == H_TOTAL - 1) begin
                h_cnt <= 0;
                if (v_cnt == V_TOTAL - 1)
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
            end else begin
                h_cnt <= h_cnt + 1;
            end
        end
    end

    // 4. Sync and ADV7123 DAC Control Signals
    assign VGA_HS      = ~((h_cnt >= H_VISIBLE + H_FRONT) && 
                           (h_cnt <  H_VISIBLE + H_FRONT + H_SYNC));
    assign VGA_VS      = ~((v_cnt >= V_VISIBLE + V_FRONT) && 
                           (v_cnt <  V_VISIBLE + V_FRONT + V_SYNC));

    wire active_video  = (h_cnt < H_VISIBLE) && (v_cnt < V_VISIBLE);
    assign VGA_BLANK_N = active_video; // Must be high during visible pixels
    assign VGA_SYNC_N  = 1'b0;         // Tied low when not using sync-on-green
    assign VGA_CLK     = clk_25;       // DAC latches RGB on rising edge

    // 5. Simple Test Pattern (8 Vertical Color Bars)
	 // reg [23:0] rgb;
/***	 
   
    always @(*) begin
        if (!active_video) begin
            rgb = 24'h000000;
				
			//DRAW FIELD	
        end else if (   (h_cnt > 0) &&  (h_cnt < (34*20)) && (v_cnt > 0) &&  (v_cnt <  1*20)  )  begin
            rgb = 24'hFFFF00; // YELLOW				
			end
			
           else if (   (h_cnt > 0) &&  (h_cnt < (34*20)) &&  (v_cnt > 23*20) &&  (v_cnt <  24*20)  )  begin
            rgb = 24'hFFFF10; // YELLOW				
			end	
			
				
        else begin
            rgb = 24'h222222; // Dark Gray
        end
    end
*///
    assign {VGA_R, VGA_G, VGA_B} = rgb;
	 assign v_counter = v_cnt ;
	 assign h_counter = h_cnt ;
	 assign o_active_video =  active_video ;  
	  

endmodule