# p1_checksum.sage — deterministic u64 checksum of the whole HJ battery, so the Rust
# mirror can pin exact cross-language fidelity (identical chains on every pair).
# Order: n ascending 2..200, q ascending 1..n-1 with gcd(n,q)==1. Fold n,q,then each a.
MASK = (1 << 64) - 1
MUL  = 1000003

def hj_chain(n, q):
    ch = []
    while q != 0:
        a = (n + q - 1) // q
        ch.append(a); n, q = q, a*q - n
    return ch

h = 0
count = 0
for n in range(2, 201):
    for q in range(1, n):
        if gcd(n, q) != 1: continue
        count += 1
        h = (h*MUL + n) & MASK
        h = (h*MUL + q) & MASK
        for a in hj_chain(n, q):
            h = (h*MUL + int(a)) & MASK
print("pairs   :", count)
print("checksum:", h)
