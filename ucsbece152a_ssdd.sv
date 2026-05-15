module ucsbece152a_ssdd (
    input  logic [2:0] data_i,
    output logic [6:0] seven_segment_display_o
);

always_comb begin
    case (data_i)
        3'h0: seven_segment_display_o = 7'b1111110; // 0
        3'h1: seven_segment_display_o = 7'b0110000; // 1
        3'h2: seven_segment_display_o = 7'b1101101; // 2
        3'h3: seven_segment_display_o = 7'b1111001; // 3
        3'h4: seven_segment_display_o = 7'b0110011; // 4
        3'h5: seven_segment_display_o = 7'b1011011; // 5
        3'h6: seven_segment_display_o = 7'b1011111; // 6
        3'h7: seven_segment_display_o = 7'b1110000; // 7
        default: seven_segment_display_o = 7'b0000000;
    endcase
end

endmodule
