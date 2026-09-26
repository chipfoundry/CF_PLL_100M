`timescale 1ns / 1ps

module tb_CF_PLL_100M;
    integer errors;
    integer toggles;
    reg [7:0] p;
    reg [3:0] q;
    reg ref, reset, pd, pd_vdd, i_in, vpwr, vpwr_int, vgnd, trim_b;
    reg [2:0] test, icpsel;
    reg [1:0] vco_gain, delay, lock_wait;
    wire VctrlIO;
    wire lock_out, setb_buf, pll_out, p_ctr_out, q_ctr_out;

    CF_PLL_100M u (
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
        .lock_out(lock_out),
        .setb_buf(setb_buf),
        .pll_out(pll_out),
        .p_ctr_out(p_ctr_out),
        .q_ctr_out(q_ctr_out),
        .trim_b(trim_b)
    );

    initial begin
        ref = 1'b0;
        forever #40 ref = ~ref;
    end

    always @(pll_out) begin
        if ($time > 200)
            toggles = toggles + 1;
    end

    task expect_bit;
        input got;
        input exp;
        input [8*32-1:0] tag;
        begin
            if (got !== exp) begin
                $display("FAIL %s got=%b exp=%b", tag, got, exp);
                errors = errors + 1;
            end else $display("PASS %s %b", tag, got);
        end
    endtask

    initial begin
        errors = 0;
        toggles = 0;
        p = 8;
        q = 1;
        reset = 1'b0;
        pd = 1'b1;
        pd_vdd = 1'b0;
        test = 3'b000;
        icpsel = 3'b000;
        i_in = 1'b0;
        vco_gain = 2'b00;
        delay = 2'b00;
        lock_wait = 2'b00;
        vpwr = 1'b1;
        vpwr_int = 1'b1;
        vgnd = 1'b0;
        trim_b = 1'b0;
        #200;
        expect_bit(pll_out, 1'b0, "powerdown pll_out");
        expect_bit(lock_out, 1'b0, "powerdown lock");
        pd = 1'b0;
        #800;
        expect_bit(lock_out, 1'b1, "lock after ref");
        expect_bit(setb_buf, 1'b1, "set buffer while running");
        if (toggles < 4) begin
            $display("FAIL pll_out toggles %0d", toggles);
            errors = errors + 1;
        end else $display("PASS pll_out toggles %0d", toggles);
        pd = 1'b1;
        #80;
        expect_bit(lock_out, 1'b0, "relock cleared");
        expect_bit(pll_out, 1'b0, "output cleared");
        if (errors != 0) begin
            $display("FAILED %0d", errors);
            $fatal(1);
        end
        $display("ALL PASS");
        $finish;
    end
endmodule
