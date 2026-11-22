`timescale 1ns / 1ps

module tb_vga_driver;

    // Entradas del DUT (registros para estimular)
    logic       CLOCK_50;
    logic       rst_n;
    logic       KEY_0;
    logic       KEY_1;
    logic       KEY_2;
    logic       KEY_3;

    // Salidas del DUT (wires)
    wire [7:0]  VGA_R;
    wire [7:0]  VGA_G;
    wire [7:0]  VGA_B;
    wire        VGA_HS;
    wire        VGA_VS;
    wire        VGA_CLK;
    wire        VGA_BLANK_N;
    wire        VGA_SYNC_N;

    // Instanciación del módulo bajo prueba (DUT)
    vga_driver dut (
        .CLOCK_50    (CLOCK_50),
        .rst_n       (rst_n),
        .KEY_0       (KEY_0),
        .KEY_1       (KEY_1),
        .KEY_2       (KEY_2),
        .KEY_3       (KEY_3),
        .VGA_R       (VGA_R),
        .VGA_G       (VGA_G),
        .VGA_B       (VGA_B),
        .VGA_HS      (VGA_HS),
        .VGA_VS      (VGA_VS),
        .VGA_CLK     (VGA_CLK),
        .VGA_BLANK_N (VGA_BLANK_N),
        .VGA_SYNC_N  (VGA_SYNC_N)
    );

    // Generación de reloj de 50 MHz (Periodo = 20 ns)
    initial begin
        CLOCK_50 = 1'b0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    // Secuencia de estímulos
    initial begin
        // 1. Estado inicial: Reset activo (en bajo) y botones sin presionar (en alto)
        rst_n = 1'b0;
        KEY_0 = 1'b1;
        KEY_1 = 1'b1;
        KEY_2 = 1'b1;
        KEY_3 = 1'b1;

        // 2. Tiempo de inicialización razonable (5 ciclos de reloj = 100 ns)
        repeat (5) @(posedge CLOCK_50);
        #2; // Pequeño desfase para evitar condiciones de carrera con el flanco de reloj
        rst_n = 1'b1; // Se libera el reset (sube a 1)

        // 3. Esperar estabilización tras liberar el reset (10 ciclos = 200 ns)
        repeat (10) @(posedge CLOCK_50);
        #2;

        // 4. Hacer assert (presionar en bajo) a KEY_2 y KEY_3
        KEY_2 = 1'b0;
        KEY_3 = 1'b0;

        // 5. Dejar correr la simulación un tiempo para observar el comportamiento
        repeat (50) @(posedge CLOCK_50);
        
        // Opcional: si necesitas soltar las teclas después, descomenta las siguientes líneas:
        // KEY_2 = 1'b1;
        // KEY_3 = 1'b1;
        // repeat (20) @(posedge CLOCK_50);

        $stop;
    end

endmodule