# CF_PLL_100M behavioral model

Ideal functional model for digital simulation. It is **not** SPICE-accurate
and it is **not** silicon-verified. Do not add this file to OpenLane
`VERILOG_FILES`.

## Files

| File | Replaces |
|---|---|
| `CF_PLL_100M_core.v` | `hdl/gl/CF_PLL_100M_core.v` |

Keep the customer wrap in `hdl/gl/CF_PLL_100M.v`. Do **not** compile the empty
`hdl/gl/CF_PLL_100M_core.v` stub in the same sim (duplicate module name).

```bash
./verify/beh_model/run_tb.sh
```

## Behavior

`pd`, `pd_vdd`, or `reset` high forces `pll_out`, `lock_out`, `setb_buf`,
`p_ctr_out`, and `q_ctr_out` low. Otherwise `lock_out` rises after eight
`ref` edges, and `pll_out` runs at `ref` frequency times `p / q` when both
dividers are nonzero. `p_ctr_out` is `pll_out` divided by `p`. `q_ctr_out`
is `ref` divided by `q`. `vpwr_int` is a supply input and is not generated.
Charge-pump select, VCO gain, delay, test, trim, and `VctrlIO` are not modeled.
