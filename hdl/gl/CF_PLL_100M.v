// Structural PG wrapper. Analog leaf is CF_PLL_100M_core.
// Customer rails are vpwr/vgnd; well taps vpb/vnb/vpbe are tied inside.
module CF_PLL_100M (
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
    output lock_out;
    output setb_buf;
    output pll_out;
    output p_ctr_out;
    output q_ctr_out;
    input trim_b;
    CF_PLL_100M_core u_core (
        .p(p),
        .q(q),
        .ref(ref),
        .test(test),
        .reset(reset),
        .pd(pd),
        .pd_vdd(pd_vdd),
        .icpsel(icpsel),
        .i_in(i_in),
        .vco_gain(vco_gain),
        .VctrlIO(VctrlIO),
        .delay(delay),
        .lock_wait(lock_wait),
        .vpwr(vpwr),
        .vpwr_int(vpwr_int),
        .vgnd(vgnd),
        .nwl(vpwr),
        .sub(vgnd),
        .lock_out(lock_out),
        .setb_buf(setb_buf),
        .pll_out(pll_out),
        .p_ctr_out(p_ctr_out),
        .q_ctr_out(q_ctr_out),
        .trim_b(trim_b)
    );
endmodule
