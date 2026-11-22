module one_shot_counter #(
parameter int unsigned COUNT_CYCLES = 10  // Number of clock cycles output stays high
) (
    input  logic clk,      // System clock
    input  logic rst_n,    // Active-low asynchronous reset
    input  logic start_n,  // Triggers on falling edge (1 -> 0)
    output logic out_pulse // High while counting, returns to 0 when done
);

    localparam int unsigned WIDTH = (COUNT_CYCLES > 1) ? $clog2(COUNT_CYCLES) : 1;

    logic [WIDTH-1:0] count;
    logic             start_n_d;   // Delayed start_n for falling-edge detection
    logic             falling_edge;

    // Detect when start_n just transitioned from 1 to 0
    assign falling_edge = start_n_d && !start_n;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_n_d <= 1'b1; // Default high so reset doesn't false-trigger
            count     <= '0;
            out_pulse <= 1'b0;
        end else begin
            start_n_d <= start_n;

            if (out_pulse) begin
                // Currently counting
                if (count == WIDTH'(COUNT_CYCLES - 1)) begin
                    out_pulse <= 1'b0;
                    count     <= '0;
                end else begin
                    count <= count + 1'b1;
                end
            end else if (falling_edge && (COUNT_CYCLES > 0)) begin
                // Triggered on falling edge of start_n
                out_pulse <= 1'b1;
                count     <= '0;
            end
        end
    end

endmodule