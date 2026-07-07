# p1_toric_probe.sage — calibrate a GEOMETRIC oracle (O3) for the HJ chain.
# The cyclic quotient singularity 1/n(1,q) is the affine toric variety of a 2D cone.
# Its minimal resolution rays are the primitive boundary lattice points (the Hilbert
# basis, in angular order); the self-intersections come from the wall relation
#     u_{i-1} + u_{i+1} = a_i * u_i   (a_i = -E_i.E_i).
# This is algorithmically independent of the scalar (n,q) recursion. Calibrate the
# (n,q)->cone convention on the KNOWN answers before trusting it.

def ordered_boundary_rays(cone):
    """Hilbert basis of a 2D cone, sorted by angle between the two extreme rays."""
    hb = [vector(ZZ, list(v)) for v in cone.Hilbert_basis()]
    # sort by polar angle
    import math
    hb.sort(key=lambda v: math.atan2(float(v[1]), float(v[0])))
    return hb

def toric_chain(n, q, conv):
    if conv == 'A':
        c = Cone([(1, 0), (-q, n)])
    elif conv == 'B':
        c = Cone([(0, 1), (n, -q)])
    elif conv == 'C':
        c = Cone([(1, 0), (n - q, n)])
    rays = ordered_boundary_rays(c)
    # extract a_i from interior rays via u_{i-1}+u_{i+1} = a_i u_i
    chain = []
    for i in range(1, len(rays) - 1):
        um, u, up = rays[i - 1], rays[i], rays[i + 1]
        s = um + up
        # a_i is the scalar with s = a_i * u (u primitive)
        if u[0] != 0:
            a = s[0] / u[0]
        else:
            a = s[1] / u[1]
        chain.append(Integer(a))
    return chain, rays

def hj_chain(n, q):
    chain = []
    while q != 0:
        a = (n + q - 1) // q
        chain.append(a)
        n, q = q, a * q - n
    return chain

tests = [(7, 3), (5, 2), (5, 3), (5, 4), (11, 7), (30, 7)]
for conv in ['A', 'B', 'C']:
    print("=== convention %s ===" % conv)
    for (n, q) in tests:
        ref = hj_chain(n, q)
        try:
            ch, rays = toric_chain(n, q, conv)
            match = (ch == ref)
            revmatch = (ch == ref[::-1])
            tag = "MATCH" if match else ("REVERSED(dual)" if revmatch else "----")
            print("  (%d,%d) ref=%-18s toric=%-18s %s" % (n, q, str(ref), str(ch), tag))
        except Exception as ex:
            print("  (%d,%d) ref=%-18s  ERROR: %s" % (n, q, str(ref), repr(ex)[:60]))
