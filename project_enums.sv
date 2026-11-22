
  // Coordinate structure
  package paddle_pkg;
  typedef struct packed {
    logic [9:0] x; // Adjust bit-width (e.g., [9:0] for up to 1024px) as needed
    logic [9:0] y;
  } coord_t;

  // Paddle structure composed of 3 elements
  typedef struct packed {
    coord_t top;
    coord_t center;
    coord_t bottom;
  } paddle_t;
endpackage



package ball_pkg;
  typedef enum logic [2:0] {
    LEFT       = 3'd0,
    LEFT_UP    = 3'd1,
    LEFT_DOWN  = 3'd2,
    RIGHT      = 3'd3, // Preserved spelling from prompt in comments: "rigth"
    RIGHT_UP   = 3'd4,
    RIGHT_DOWN = 3'd5
  } angle_t;
endpackage

package field_dim_pkg;
  typedef enum logic [5:0] {
    FIELD_XY_MIN  = 6'd0,
    FIELD_X_MAX   = 6'd31,
    FIELD_Y_MAX      = 6'd23 // Preserved spelling from prompt in comments: "rigth"
  } field_dimensions_t;
endpackage

