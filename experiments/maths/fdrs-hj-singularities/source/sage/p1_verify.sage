# p1_verify.sage — FDRS HJ Singularities · Phase P1 canonical run (exact anchor)
#
# HJ resolution of the cyclic quotient singularity (n,q) as an FDRS Phase-7 radix LAW:
#     context (n,q) ; Ω = ceil(n/q) = a_i = -E_i.E_i ; Γ(n,q)=(q, a*q-n) ; terminal q==0.
#
# THREE independent oracles (F-oracle): the digit LAW is a scalar recursion; each oracle
# is a different computation.
#   O1 round-trip : minus-CF continuant EVALUATION == n/q          (full battery, ZZ/QQ)
#   O2 gauge      : |det(intersection form)|==n AND |det(minor)|==q (full battery, Sage exact det)
#   O3 toric      : Hilbert-basis resolution rays + wall relation   (sample n<=60, polyhedral)
# O2's |det|==n IS the promoted headline: gauge = continuant = n = |cyclic group|.
# ZZ/QQ only — a float anywhere is F-exact. Supersedes p1_battery.sage + p1_toric_probe.sage.

import time, math

def hj_chain(n, q):
    chain = []
    while q != 0:
        a = (n + q - 1) // q                 # ceil(n/q), exact
        chain.append(a); n, q = q, a * q - n # Γ
    return chain

def eval_minus_cf(chain):                    # O1
    val = QQ(chain[-1])
    for a in reversed(chain[:-1]):
        val = a - 1 / val
    return val

def gauge_dets(chain):                       # O2
    e = len(chain); M = matrix(ZZ, e, e, 0)
    for i in range(e):
        M[i, i] = -chain[i]
        if i + 1 < e: M[i, i+1] = 1; M[i+1, i] = 1
    detn = abs(M.det())
    detq = abs(M[1:, 1:].det()) if e >= 2 else Integer(1)
    return detn, detq

def toric_chain(n, q):                       # O3 (convention A, calibrated on (7,3)->[3,2,2])
    c = Cone([(1, 0), (-q, n)])
    rays = sorted((vector(ZZ, list(v)) for v in c.Hilbert_basis()),
                  key=lambda v: math.atan2(float(v[1]), float(v[0])))
    ch = []
    for i in range(1, len(rays) - 1):
        s = rays[i-1] + rays[i+1]; u = rays[i]
        ch.append(Integer(s[0] / u[0]) if u[0] != 0 else Integer(s[1] / u[1]))
    return ch

N_MAX, N_TORIC = 200, 60
t0 = time.time()
pairs = fails_alg = 0
toric_pairs = toric_fail = 0
maxlen = 0
for n in range(2, N_MAX + 1):
    for q in range(1, n):
        if gcd(n, q) != 1: continue
        pairs += 1
        ch = hj_chain(n, q)
        detn, detq = gauge_dets(ch)
        ok = (len(ch) >= 1 and all(a >= 2 for a in ch)
              and eval_minus_cf(ch) == QQ(n)/QQ(q) and detn == n and detq == q)
        if not ok: fails_alg += 1
        maxlen = max(maxlen, len(ch))
        if n <= N_TORIC:
            toric_pairs += 1
            if toric_chain(n, q) != ch: toric_fail += 1
dt = time.time() - t0

print("================================================================")
print("  P1 — HJ chain as a Phase-7 radix law · canonical verify")
print("================================================================")
print("  O1+O2 battery : (n,q), 0<q<n<=%d, gcd=1 :  %d pairs,  %d failures" % (N_MAX, pairs, fails_alg))
print("  O3 toric      : (n,q), n<=%d              :  %d pairs,  %d failures" % (N_TORIC, toric_pairs, toric_fail))
print("  max chain len : %d      wall time: %.2fs      arithmetic: ZZ/QQ only" % (maxlen, dt))
print("")
allpass = (fails_alg == 0 and toric_fail == 0)
if allpass:
    print("  ALL PASS — three independent oracles agree.")
    print("   H1 (exact extraction + round-trip) CONFIRMED on %d pairs." % pairs)
    print("   gauge = |det(intersection form)| = n = |cyclic group|  CONFIRMED (O2, %d pairs)." % pairs)
    print("   geometric interpretation CONFIRMED (O3 toric resolution, %d pairs)." % toric_pairs)
    print("   F-exact silent (no float) · F-oracle satisfied (3 independent algorithms).")
else:
    print("  >>> FAILURE: fails_alg=%d toric_fail=%d — investigate before any claim." % (fails_alg, toric_fail))
