#!/usr/bin/env sage
"""
Run FDRS Experiment 38 with SVG output for site_data display testing.

This wrapper leaves the original HiR experiment script untouched. It reads the
canonical Exp 38 Sage script, changes the generated atlas filename from PNG to
SVG, and executes the experiment in this directory.
"""

from pathlib import Path


ORIGINAL = Path(
    "/home/billy/HiR/math_research/proofs/fdrs_formal/Sage/"
    "fdrs_exp38_kernel_cylinder_radix9_atlas.sage"
)


source = ORIGINAL.read_text(encoding="utf-8")
source = source.replace(
    'f"fdrs_exp38_kernel_cylinder_radix_atlas_a{KERNEL_A}_B{out_b}.png"',
    'f"fdrs_exp38_kernel_cylinder_radix_atlas_a{KERNEL_A}_B{out_b}.svg"',
)

exec(compile(source, str(ORIGINAL), "exec"))
