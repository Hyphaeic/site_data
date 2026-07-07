# p1_battery.sage — FDRS HJ Singularities · Phase P1 (exact anchor)
#
# The HJ resolution of the cyclic quotient singularity (n,q) encoded as an FDRS
# Phase-7 context-dependent radix LAW (Def 89/103):
#     context = (n,q) ;  Ω(state) = ceil(n/q) = a_i = -E_i.E_i ;
#     Γ(n,q) = (q, a*q - n) ;  terminal q==0  (a Base-0 Wall, Phase 9).
#
# Exactness ladder, Sage side — the digit LAW (direct recursion) is cross-checked on
# the FULL battery against TWO independent, convention-free oracles (F-oracle):
#   O1  round-trip : minus-CF continuant EVALUATION == n/q   (evaluation, not extraction)
#   O2  gauge      : |det(intersection form)| == n  AND  |det(minor)| == q
#                    (Sage exact ZZ determinant — a different code path from the recursion)
# O2's "|det| == n" IS the promoted headline: gauge = continuant = n = |cyclic group|.
# Integer/rational arithmetic only — a float here is F-exact.
#
# Battery: all (n,q), 0 < q < n <= 200, gcd(n,q)=1.

import time

def hj_chain(n, q):
    """Phase-7 radix law: Ω(state)=ceil(n/q); Γ(n,q)=(q, a*q-n); terminal q==0.
       Returns the chain [a_1,...,a_e] of self-intersections (all a_i >= 2)."""
    assert 0 < q < n and gcd(n, q) == 1
    chain = []
    while q != 0:
        a = (n + q - 1) // q          # ceil(n/q), exact integer arithmetic
        chain.append(a)
        n, q = q, a * q - n           # Γ
    return chain

def eval_minus_cf(chain):
    """O1 — independent round-trip: a_1 - 1/(a_2 - 1/(... - 1/a_e)) as an exact Rational."""
    val = QQ(chain[-1])
    for a in reversed(chain[:-1]):
        val = a - 1 / val
    return val

def intersection_form(chain):
    """Tridiagonal intersection matrix M: M_ii = -a_i, M_{i,i+1}=M_{i+1,i}=1."""
    e = len(chain)
    M = matrix(ZZ, e, e, 0)
    for i in range(e):
        M[i, i] = -chain[i]
        if i + 1 < e:
            M[i, i + 1] = 1
            M[i + 1, i] = 1
    return M

def gauge_check(chain):
    """O2 — independent gauge via Sage exact det: (|det M|, |det of minor dropping row/col 0|)."""
    M = intersection_form(chain)
    detn = abs(M.det())
    detq = abs(M[1:, 1:].det()) if len(chain) >= 2 else Integer(1)  # continuant of () = 1 = q for (n,1)
    return detn, detq

N_MAX = 200
t0 = time.time()
pairs = 0
fails = []
max_len = 0
len_hist = {}
examples_wanted = [(2,1),(5,1),(5,2),(5,3),(5,4),(7,3),(11,7),(30,7),(199,1),(200,199)]
examples = {}

for n in range(2, N_MAX + 1):
    for q in range(1, n):
        if gcd(n, q) != 1:
            continue
        pairs += 1
        chain = hj_chain(n, q)
        ok_min2 = (len(chain) >= 1) and all(a >= 2 for a in chain)
        ok_rt   = (eval_minus_cf(chain) == QQ(n) / QQ(q))
        detn, detq = gauge_check(chain)
        ok_detn = (detn == n)
        ok_detq = (detq == q)
        if not (ok_min2 and ok_rt and ok_detn and ok_detq):
            fails.append((n, q, chain, ok_min2, ok_rt, ok_detn, ok_detq))
        L = len(chain)
        max_len = max(max_len, L)
        len_hist[L] = len_hist.get(L, 0) + 1
        if (n, q) in examples_wanted:
            examples[(n, q)] = chain

dt = time.time() - t0

print("================================================================")
print("  P1 battery — HJ chain as a Phase-7 radix law (exact anchor)")
print("================================================================")
print("  battery: all (n,q), 0<q<n<=%d, gcd(n,q)=1" % N_MAX)
print("  pairs tested         : %d" % pairs)
print("  FAILURES             : %d" % len(fails))
print("  checks/pair          : a_i>=2 · minus-CF round-trip == n/q · |det M|==n · |det minor|==q")
print("  max chain length     : %d" % max_len)
print("  wall time            : %.2fs" % dt)
print("  arithmetic           : ZZ/QQ only (no float) -> F-exact silent")
print("")
print("  example chains (n,q) -> [a_1..a_e]:")
for k in sorted(examples):
    ch = examples[k]
    print("    (%3d,%3d) -> %-28s  len %d   |det|=%d  |minor|=%d" %
          (k[0], k[1], str(ch), len(ch), *gauge_check(ch)))
print("")
if fails:
    print("  >>> FAIL (first 8):")
    for f in fails[:8]:
        print("      ", f)
else:
    print("  ALL PASS.")
    print("  -> HJ radix law reproduces the battery exactly (integer-only).")
    print("  -> round-trip exact on all %d pairs (O1)." % pairs)
    print("  -> gauge = |det(intersection form)| = n = |cyclic group| on all pairs (O2, independent det).")
    print("  -> |det(minor)| = q on all pairs (independent recovery of the weight).")
    print("  -> F-exact, F-oracle silent; H1 + the promoted gauge=n anchor CONFIRMED.")
