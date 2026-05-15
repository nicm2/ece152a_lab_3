module ucsbece152a_counter_tb();

    // Parameters
    parameter WIDTH = 3;

    // Create clock signal
    logic clk = 0;
    always #(10) clk = ~clk;

    // Instantiate counter nets
    logic             rst;
    logic             enable;
    logic             dir;
    logic [WIDTH-1:0] count;

    // Instantiate the "Design Under Test"
    ucsbece152a_counter #(
        .WIDTH(WIDTH)
    ) DUT (
        .clk     (clk),
        .rst     (rst),
        .count_o (count),
        .enable_i(enable),
        .dir_i   (dir)
    );

    integer i;
    initial begin
        $display("Begin simulation.");

        rst    = 1;
        enable = 1;
        dir    = 0;
        @(negedge clk);
        rst = 0;

// Basic counting and wrapping Test (part 1)

        for (i = 0; i < 16; i++) begin
            if (count != i % (2**WIDTH))
                $display("Error: expected %0d, received %0d",
                         $unsigned(i), count);
            @(negedge clk);
        end

// Reset Test (part 1)

        repeat(5) @(negedge clk);
        $display("Count before rst #1: %0d (should be 5)", count);
        rst = 1;
        @(negedge clk);
        if (count != 0)
            $display("FAIL rst #1: expected 0, received %0d", count);
        else
            $display("PASS rst #1: reset at 5, count is now %0d", count);
        rst = 0;

        repeat(8) @(negedge clk);
        repeat(3) @(negedge clk);
        $display("Count before rst #2: %0d (should be 3)", count);
        rst = 1;
        @(negedge clk);
        if (count != 0)
            $display("FAIL rst #2: expected 0, received %0d", count);
        else
            $display("PASS rst #2: reset at 3, count is now %0d", count);
        rst = 0;

        for (i = 0; i < 8; i++) begin
            if (count != i % (2**WIDTH))
                $display("Error after rst #2: expected %0d, received %0d",
                         $unsigned(i), count);
            @(negedge clk);
        end
        $display("PASS: counting resumed correctly after rst #2");

// Enable Test (part 2)

        $display("Enable Test");

        repeat(4) @(negedge clk);
        $display("Count before pause: %0d (should be 4)", count);

        enable = 0;
        repeat(5) @(negedge clk);
        if (count != 4)
            $display("FAIL [enable hold]: expected 4, received %0d", count);
        else
            $display("PASS [enable hold]: count held at %0d for 5 cycles", count);

        enable = 1;
        repeat(4) @(negedge clk);

        repeat(3) @(negedge clk);
        $display("Count before second pause: %0d (should be 3)", count);

        enable = 0;
        repeat(4) @(negedge clk);
        if (count != 3)
            $display("FAIL [enable hold #2]: expected 3, received %0d", count);
        else
            $display("PASS [enable hold #2]: count held at %0d for 4 cycles", count);

        enable = 1;
        @(negedge clk);
        if (count != 4)
            $display("FAIL [enable resume #2]: expected 4, received %0d", count);
        else
            $display("PASS [enable resume #2]: count resumed to %0d", count);

// Direction Test (part 2)

        $display("Direction Test");

        rst = 1;
        @(negedge clk);
        rst = 0;

        // incrementing
        dir = 0;
        repeat(5) @(negedge clk);
        $display("Count after counting up: %0d (should be 5)", count);
        if (count != 5)
            $display("FAIL [count up]: expected 5, received %0d", count);
        else
            $display("PASS [count up]: reached %0d", count);

        // decrementing
        $display("decrementing");
        dir = 1;
        for (i = 4; i >= 0; i--) begin
            @(negedge clk);
            if (count != i)
                $display("FAIL [decrement]: expected %0d, received %0d", i, count);
            else
                $display("PASS [decrement]: count = %0d", count);
        end

        @(negedge clk);
        if (count != 7)
            $display("FAIL [decrement wrap]: expected 7, received %0d", count);
        else
            $display("PASS [decrement wrap]: wrapped from 0 to %0d", count);

        repeat(3) @(negedge clk);
        $display("Count after wrapping down: %0d (should be 4)", count);

        // incrementing
        $display("incrementing");
        dir = 0;
        repeat(5) @(negedge clk);
        $display("Count after counting up again: %0d (should be 1)", count);
        if (count != 1)
            $display("FAIL [dir switch up]: expected 1, received %0d", count);
        else
            $display("PASS [dir switch up]: count = %0d", count);

        $display("End simulation.");
        $stop;

    end  

endmodule
