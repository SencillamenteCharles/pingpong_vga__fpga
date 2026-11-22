
// this module is enabled high, and is parametric
//is is a custom free running counter, counts only when enabled and overflows when hits top_count
//also has a custom counter for the toggles

module free_running_counter #(
    parameter int unsigned TOP_COUNT = 10  // Maximum count value before rollover
) (
    input  logic clk,      // System clock
    input  logic rst_n,    // Active-low asynchronous reset
    input  logic en,     // 
    output logic out_tgl,   // Toggles every time TOP_COUNT is reached
	 output logic [ 7:0 ] o_tgl_counter 
);

    logic [32-1:0] count;
	 logic [7:0] tgl_counter;

    always_ff @(posedge clk ) begin
        if ((rst_n == 1'b0 )|| ( en  == 1'b0)) begin//reset conditions
            count   <= '0;
            out_tgl <= 1'b0;
				tgl_counter<= '0;
        end 
		  
		   if (rst_n== 1'b1 && (en == 1'b1) ) begin
            count   <= count + 1'b1;
        
				 if (count > (TOP_COUNT)) begin// counter overflow condition. 
                count   <= '0;
                out_tgl <= ~out_tgl;
					 if(out_tgl == 1'b1) begin
						tgl_counter <= tgl_counter + 8'd1; // Fixed: nonblocking assignment      //count the number of toggles.
					 end 
			    end
        end 
    end
 	 
	 assign  o_tgl_counter = tgl_counter;
endmodule