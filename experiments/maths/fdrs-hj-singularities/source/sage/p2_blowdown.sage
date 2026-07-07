# p2_blowdown.sage — FDRS HJ Singularities · Phase P2
#
# Blow-up / blow-down as carry's NORMALIZATION role (value-preserving re-canonicalization
# — enc∘dec / rechart Def 68-69 / exact nesting Thm 97-98), NOT the successor (Tick=+1).
#
#   interior blow-up  : (a_i, a_{i+1})  ->  (a_i+1, 1, a_{i+1}+1)   [insert a (-1)-curve]
#   Castelnuovo down  : (a, 1, b)       ->  (a-1, b-1)             [contract the (-1)-curve]
#
# Claim (positive): both preserve (n,q) exactly — the birational invariant — so blow-down
# is carry-as-NORMALIZATION. Reduction is confluent to the minimal chain (all a_i>=2), the
# canonical form. F-carry (the forbidden reading): a successor/value-changing edit does NOT
# preserve (n,q); we exhibit one so the negative is exercised, not merely asserted.
# Grounded against Sage's toric STAR-SUBDIVISION on a sample. ZZ/QQ only.

def hj_chain(n, q):
    ch = []
    while q != 0:
        a = (n + q - 1) // q
        ch.append(a); n, q = q, a*q - n
    return ch

def continuant(a):
    if not a: return Integer(1)
    p2, p1 = Integer(1), Integer(a[0])
    for ai in a[1:]:
        p2, p1 = p1, ai*p1 - p2
    return p1

def nq_of(chain):
    """(n,q) represented by a (possibly non-reduced) chain: n=K[chain], q=K[chain[1:]]."""
    return continuant(chain), continuant(chain[1:])

def blowup_interior(chain, i):
    """Insert a (-1)-curve on the wall between a_i and a_{i+1}: chain-preserving blow-up."""
    assert 0 <= i < len(chain) - 1
    return chain[:i] + [chain[i]+1, 1, chain[i+1]+1] + chain[i+2:]

def reduce_castelnuovo(chain):
    """Contract interior (-1)-curves to the minimal (reduced) chain. Asserts no boundary 1
       ever appears (interior blow-ups never create one — verified structurally)."""
    c = list(chain)
    steps = 0
    while True:
        j = next((k for k in range(len(c)) if c[k] == 1), None)
        if j is None:
            break
        assert 0 < j < len(c) - 1, "boundary (-1)-curve: out of P2 scope (changes framing)"
        c = c[:j-1] + [c[j-1]-1, c[j+1]-1] + c[j+2:]
        steps += 1
    return c, steps

# --- adversarial F-carry witness: a successor-style (value-changing) edit ---
def wrong_successor_edit(chain, i):
    """A carry-AS-SUCCESSOR-flavored edit: bump one radix like an odometer digit. This is
       the forbidden reading; it must NOT preserve (n,q)."""
    c = list(chain); c[i] = c[i] + 1
    return c

# --- toric grounding: blow-up = star subdivision (insert ray u_i + u_{i+1}) ---
import math
def toric_chain_and_rays(n, q):
    c = Cone([(1,0),(-q,n)])
    rays = sorted((vector(ZZ, list(v)) for v in c.Hilbert_basis()),
                  key=lambda v: math.atan2(float(v[1]), float(v[0])))
    ch = []
    for i in range(1, len(rays)-1):
        s = rays[i-1] + rays[i+1]; u = rays[i]
        ch.append(Integer(s[0]/u[0]) if u[0] != 0 else Integer(s[1]/u[1]))
    return ch, rays

def toric_blowup_chain(n, q, wall):
    """Star-subdivide the toric resolution at the given interior wall; read the new chain."""
    _, rays = toric_chain_and_rays(n, q)
    # rays[0..r+1]; interior divisors are rays[1..r]; walls between consecutive rays.
    # 'wall' indexes interior divisor walls to match blowup_interior on the chain:
    # chain position i corresponds to inserting ray between divisor rays[1+i] and rays[2+i].
    idx = 1 + wall
    new_ray = rays[idx] + rays[idx+1]
    rr = rays[:idx+1] + [new_ray] + rays[idx+1:]
    ch = []
    for i in range(1, len(rr)-1):
        s = rr[i-1] + rr[i+1]; u = rr[i]
        ch.append(Integer(s[0]/u[0]) if u[0] != 0 else Integer(s[1]/u[1]))
    return ch

# ====================== battery ======================
print("================================================================")
print("  P2 — blow-down as carry-normalization (value-preserving)")
print("================================================================")

# 1) value preservation under a deterministic blow-up schedule, then full reduction back.
N_MAX = 100
pairs = 0
fail_preserve = 0
fail_reduce = 0
for n in range(2, N_MAX+1):
    for q in range(1, n):
        if gcd(n, q) != 1: continue
        pairs += 1
        C = hj_chain(n, q)
        target_nq = (n, q)
        # deterministic (no RNG) schedule of interior blow-ups
        cur = list(C)
        K = 2 * len(C)
        for step in range(K):
            if len(cur) < 2: break
            i = step % (len(cur) - 1)
            cur = blowup_interior(cur, i)
            if nq_of(cur) != target_nq:
                fail_preserve += 1; break
        # now fully reduce back to the canonical minimal chain
        red, _ = reduce_castelnuovo(cur)
        if red != C or nq_of(red) != target_nq:
            fail_reduce += 1

print("  value preservation + confluent reduction:")
print("    pairs (n<=%d)          : %d" % (N_MAX, pairs))
print("    blow-up (n,q)-changes  : %d   (must be 0 -> F-carry silent)" % fail_preserve)
print("    reduction != canonical : %d   (must be 0 -> confluence to minimal chain)" % fail_reduce)

# 2) F-carry adversarial witness — a successor-style edit changes (n,q).
print("")
print("  F-carry witness (carry-AS-SUCCESSOR must break (n,q)):")
demo = [(7,3),(5,4),(11,7),(30,7)]
succ_breaks = 0
for (n,q) in demo:
    C = hj_chain(n,q)
    w = wrong_successor_edit(C, 0)
    got = nq_of(w)
    broke = (got != (n,q))
    succ_breaks += broke
    print("    (%d,%d) chain %s  --successor-bump a_0-->  %s  gives (n,q)=%s  %s" %
          (n,q,C,w,got,"BROKEN (as required)" if broke else "PRESERVED (unexpected!)"))
print("    -> %d/%d successor edits broke (n,q): carry-as-successor != blow-down (narrow negative confirmed)." % (succ_breaks, len(demo)))

# 3) toric grounding: chain blow-up == toric star subdivision, on a sample.
print("")
print("  toric grounding (blow-up == star subdivision), sample:")
tor_pairs = tor_fail = 0
for n in range(3, 41):
    for q in range(1, n):
        if gcd(n,q) != 1: continue
        C = hj_chain(n,q)
        if len(C) < 2: continue
        for wall in range(len(C)-1):
            tor_pairs += 1
            if toric_blowup_chain(n,q,wall) != blowup_interior(C, wall):
                tor_fail += 1
print("    wall blow-ups checked  : %d" % tor_pairs)
print("    toric != chain rewrite : %d   (must be 0)" % tor_fail)

print("")
allpass = (fail_preserve == 0 and fail_reduce == 0 and succ_breaks == len(demo) and tor_fail == 0)
if allpass:
    print("  ALL PASS.")
    print("   blow-up/down PRESERVE (n,q) on the whole n<=%d battery (birational invariant)." % N_MAX)
    print("   reduction is confluent to the canonical minimal chain (all a_i>=2).")
    print("   => blow-down IS carry-as-NORMALIZATION (enc∘dec / rechart / exact nesting).")
    print("   F-carry EXERCISED: successor-style edits break (n,q) -> carry-as-successor != blow-down.")
    print("   grounded against toric star-subdivision. F-exact silent (ZZ/QQ only).")
else:
    print("  >>> CHECK: preserve=%d reduce=%d succ=%d/%d toric=%d" %
          (fail_preserve, fail_reduce, succ_breaks, len(demo), tor_fail))
