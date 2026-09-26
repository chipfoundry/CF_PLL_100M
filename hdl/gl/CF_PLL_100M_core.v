// Empty blackbox stub for hierarchical integration LVS.
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
endmodule
