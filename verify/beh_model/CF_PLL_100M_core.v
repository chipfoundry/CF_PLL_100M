`timescale 1ns / 1ps

// Ideal functional model of analog leaf CF_PLL_100M_core.
// Drop this file in place of hdl/gl/CF_PLL_100M_core.v for simulation.
// Do not add it to OpenLane VERILOG_FILES.
//
// Assumed protocol (ideal, not silicon-verified):
//   * pd, pd_vdd, or reset high forces the clocks and lock low.
//   * Otherwise, after eight ref edges, lock_out rises.
//   * pll_out frequency is ref frequency * p / q when p and q are both nonzero.
//   * p_ctr_out is pll_out divided by p. q_ctr_out is ref divided by q.
//   * vpwr_int is a supply input and is not generated.
// Charge-pump, VCO gain, delay, test, trim, and VctrlIO are not modeled.

module CF_PLL_100M_core (
    p,
    q,
    ref,
    test,
    reset,
    pd,
    pd_vdd,
    icpsel,
    i_in,
    vco_gain,
    VctrlIO,
    delay,
    lock_wait,
    vpwr,
    vpwr_int,
    vgnd,
    nwl,
    sub,
    lock_out,
    setb_buf,
    pll_out,
    p_ctr_out,
    q_ctr_out,
    trim_b
);
    input [7:0] p;
    input [3:0] q;
    input ref;
    input [2:0] test;
    input reset;
    input pd;
    input pd_vdd;
    input [2:0] icpsel;
    input i_in;
    input [1:0] vco_gain;
    inout VctrlIO;
    input [1:0] delay;
    input [1:0] lock_wait;
    input vpwr;
    input vpwr_int;
    input vgnd;
    input nwl;
    input sub;
    output lock_out;
    output setb_buf;
    output pll_out;
    output p_ctr_out;
    output q_ctr_out;
    input trim_b;

    reg lock_out;
    reg setb_buf;
    reg pll_out;
    reg p_ctr_out;
    reg q_ctr_out;
    integer seen;
    integer p_count;
    integer q_count;
    real ref_period;
    real prev_ref;
    integer half_ns;

    initial begin
        lock_out = 1'b0;
        setb_buf = 1'b0;
        pll_out = 1'b0;
        p_ctr_out = 1'b0;
        q_ctr_out = 1'b0;
        seen = 0;
        p_count = 0;
        q_count = 0;
        ref_period = 0.0;
        prev_ref = 0.0;
        half_ns = 1;
    end

    always @(posedge ref) begin
        if (prev_ref > 0.0 && $realtime > prev_ref)
            ref_period = $realtime - prev_ref;
        prev_ref = $realtime;
        if (pd === 1'b1 || pd_vdd === 1'b1 || reset === 1'b1) begin
            seen = 0;
            q_count = 0;
            lock_out = 1'b0;
            setb_buf = 1'b0;
            q_ctr_out = 1'b0;
        end else begin
            setb_buf = 1'b1;
            if (seen < 8)
                seen = seen + 1;
            if (seen >= 8)
                lock_out = 1'b1;
            if (q > 0) begin
                q_count = q_count + 1;
                if (q_count >= q) begin
                    q_ctr_out = ~q_ctr_out;
                    q_count = 0;
                end
            end
        end
    end

    always @(posedge pll_out) begin
        if (pd === 1'b1 || pd_vdd === 1'b1 || reset === 1'b1 || p == 0) begin
            p_count = 0;
            p_ctr_out = 1'b0;
        end else begin
            p_count = p_count + 1;
            if (p_count >= p) begin
                p_ctr_out = ~p_ctr_out;
                p_count = 0;
            end
        end
    end

    initial begin
        forever begin
            if (pd !== 1'b1 && pd_vdd !== 1'b1 && reset !== 1'b1
                    && p > 0 && q > 0 && ref_period > 0.0) begin
                half_ns = ref_period * q / p / 2.0;
                if (half_ns < 1)
                    half_ns = 1;
                #(half_ns) pll_out = ~pll_out;
            end else begin
                pll_out = 1'b0;
                p_ctr_out = 1'b0;
                #1;
            end
        end
    end
endmodule
