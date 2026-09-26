#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${TMPDIR:-/tmp}/cf_pll_100m_tb"
iverilog -g2005 -o "$OUT" \
  "$ROOT/hdl/gl/CF_PLL_100M.v" \
  "$ROOT/verify/beh_model/CF_PLL_100M_core.v" \
  "$ROOT/verify/beh_model/tb_CF_PLL_100M.v"
vvp "$OUT"
