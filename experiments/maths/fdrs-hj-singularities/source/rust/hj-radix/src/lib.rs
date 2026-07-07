//! # hj-radix — the HJ resolution as an FDRS Phase-7 radix law (P1 mirror)
//!
//! The cyclic quotient surface singularity `(n,q)` (`0 < q < n`, `gcd = 1`) resolves by
//! the Hirzebruch–Jung / negative-regular continued fraction. We encode it as an FDRS
//! Phase-7 context-dependent radix **law** (Def 89/103):
//!
//! ```text
//!   context   (n, q)
//!   radix     Ω(state) = ceil(n/q) = a_i = -E_i·E_i        (unbounded — Phase-7 legal)
//!   evolution Γ(n, q)  = (q, a·q − n)
//!   terminal  q == 0                                        (a Base-0 Wall, Phase 9)
//! ```
//!
//! A singularity is a radix **law** (a finite word over `{2,3,…}` = its chain), not a
//! point on one line (`F-lawpoint`). This crate is the **fidelity rung** of the
//! exactness ladder: an independent (Rust, integer-only, `no_std`) implementation of the
//! same law, pinned to reproduce the Sage battery **bit-for-bit** via a u64 checksum over
//! all 12231 pairs `0 < q < n ≤ 200`. `F-exact`: no float anywhere.

#![cfg_attr(not(test), no_std)]

/// Max chain length we store. `n ≤ 200 ⇒ len ≤ n−1 ≤ 199`, so 256 is a safe cap.
pub const MAXLEN: usize = 256;

/// A Hirzebruch–Jung chain `[a_1, …, a_e]`, `a_i = −E_i·E_i ≥ 2` (fixed-capacity, no alloc).
#[derive(Clone, Copy)]
pub struct Chain {
    a: [u32; MAXLEN],
    /// Number of exceptional divisors (chain length `e`).
    pub len: usize,
}

impl Chain {
    /// The self-intersection data `[a_1, …, a_e]`.
    #[inline]
    pub fn digits(&self) -> &[u32] {
        &self.a[..self.len]
    }
}

/// The HJ radix law: `Ω = ceil(n/q)`, `Γ(n,q) = (q, a·q − n)`, terminal `q == 0`.
///
/// Requires `0 < q0 < n0` with `gcd(n0,q0) = 1` (the singularity contract).
pub fn hj_chain(n0: u32, q0: u32) -> Chain {
    debug_assert!(0 < q0 && q0 < n0, "cyclic quotient needs 0 < q < n");
    let (mut n, mut q) = (n0 as i64, q0 as i64);
    let mut c = Chain { a: [0; MAXLEN], len: 0 };
    while q != 0 {
        let a = (n + q - 1) / q; // ceil(n/q), exact integer arithmetic
        c.a[c.len] = a as u32;
        c.len += 1;
        let (nn, qq) = (q, a * q - n); // Γ
        n = nn;
        q = qq;
    }
    c
}

/// The minus-continuant `K[a_1,…,a_k]` via the tridiagonal-determinant recurrence
/// `p_0 = 1, p_1 = a_1, p_i = a_i·p_{i−1} − p_{i−2}`. Equals `|det|` of the intersection
/// form of the chain. For a full HJ chain this is `n`; started at `a_2` it is `q`.
pub fn continuant(a: &[u32]) -> i64 {
    if a.is_empty() {
        return 1;
    }
    let mut prev2: i64 = 1; // K of the empty prefix
    let mut prev1: i64 = a[0] as i64; // K[a_1]
    for &ai in &a[1..] {
        let p = (ai as i64) * prev1 - prev2;
        prev2 = prev1;
        prev1 = p;
    }
    prev1
}

/// The FDRS **gauge** of the law = the group order: `|det(intersection form)| = n`.
#[inline]
pub fn gauge(chain: &Chain) -> i64 {
    continuant(chain.digits())
}

/// Independent round-trip: evaluate `a_1 − 1/(a_2 − 1/(… − 1/a_e))` as a reduced
/// fraction `(num, den)` with `den > 0`. (A different computation from `continuant`.)
pub fn minus_cf_eval(a: &[u32]) -> (i64, i64) {
    let e = a.len();
    let mut num = a[e - 1] as i64;
    let mut den = 1i64;
    let mut i = e - 1;
    while i > 0 {
        i -= 1;
        // a_i − den/num = (a_i·num − den) / num
        let n2 = (a[i] as i64) * num - den;
        let d2 = num;
        num = n2;
        den = d2;
        let g = gcd_i64(num.unsigned_abs(), den.unsigned_abs()) as i64;
        if g != 0 {
            num /= g;
            den /= g;
        }
        if den < 0 {
            num = -num;
            den = -den;
        }
    }
    (num, den)
}

#[inline]
pub fn gcd_i64(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let t = a % b;
        a = b;
        b = t;
    }
    a
}

#[inline]
pub fn gcd_u32(mut a: u32, mut b: u32) -> u32 {
    while b != 0 {
        let t = a % b;
        a = b;
        b = t;
    }
    a
}

#[cfg(test)]
mod tests {
    use super::*;

    fn assert_chain(n: u32, q: u32, want: &[u32]) {
        let c = hj_chain(n, q);
        assert_eq!(c.digits(), want, "chain ({n},{q})");
    }

    /// Known-answer pins — these values are the Sage oracle's (O1/O2/O3 all agreed).
    #[test]
    fn known_chains() {
        assert_chain(2, 1, &[2]);
        assert_chain(5, 1, &[5]);
        assert_chain(5, 2, &[3, 2]);
        assert_chain(5, 3, &[2, 3]); // Riemenschneider dual of (5,2), reversed
        assert_chain(5, 4, &[2, 2, 2, 2]); // A_4 chain
        assert_chain(7, 3, &[3, 2, 2]);
        assert_chain(11, 7, &[2, 3, 2, 2]);
        assert_chain(30, 7, &[5, 2, 2, 3]);
        // A_199: 199 twos
        let big = hj_chain(200, 199);
        assert_eq!(big.len, 199);
        assert!(big.digits().iter().all(|&a| a == 2));
    }

    /// The full battery: every invariant the Sage side checked, re-checked in Rust.
    #[test]
    fn battery_invariants() {
        let mut pairs = 0u32;
        let mut maxlen = 0usize;
        for n in 2..=200u32 {
            for q in 1..n {
                if gcd_u32(n, q) != 1 {
                    continue;
                }
                pairs += 1;
                let c = hj_chain(n, q);
                let d = c.digits();
                // a_i ≥ 2, nonempty
                assert!(!d.is_empty() && d.iter().all(|&a| a >= 2), "min2 ({n},{q})");
                // gauge = |det| = n ; minor = q
                assert_eq!(continuant(d), n as i64, "gauge=n ({n},{q})");
                assert_eq!(continuant(&d[1..]), q as i64, "minor=q ({n},{q})");
                // independent round-trip == n/q
                assert_eq!(minus_cf_eval(d), (n as i64, q as i64), "round-trip ({n},{q})");
                maxlen = maxlen.max(c.len);
            }
        }
        assert_eq!(pairs, 12231);
        assert_eq!(maxlen, 199);
    }

    /// Cross-language fidelity: identical chains to the Sage oracle on every pair
    /// ⇒ identical folded u64 checksum. The constant is `sage p1_checksum.sage`.
    #[test]
    fn battery_checksum_matches_sage() {
        const MUL: u64 = 1000003;
        let mut h: u64 = 0;
        let mut count = 0u32;
        for n in 2..=200u32 {
            for q in 1..n {
                if gcd_u32(n, q) != 1 {
                    continue;
                }
                count += 1;
                h = h.wrapping_mul(MUL).wrapping_add(n as u64);
                h = h.wrapping_mul(MUL).wrapping_add(q as u64);
                for &a in hj_chain(n, q).digits() {
                    h = h.wrapping_mul(MUL).wrapping_add(a as u64);
                }
            }
        }
        assert_eq!(count, 12231);
        assert_eq!(h, 7424009778405959836, "Rust battery diverged from the Sage oracle");
    }
}

/// P2 mirror — blow-up / blow-down as carry's **normalization** role (value-preserving),
/// NOT the successor. Verified independently of the Sage side (std Vec in tests).
#[cfg(test)]
mod p2 {
    use super::*;
    use std::vec::Vec;

    /// `(n,q)` represented by a (possibly non-reduced) chain: `n = K[chain]`, `q = K[chain[1:]]`.
    fn nq(chain: &[u32]) -> (i64, i64) {
        (
            continuant(chain),
            if chain.len() >= 2 { continuant(&chain[1..]) } else { 1 },
        )
    }

    /// Interior blow-up: insert a (−1)-curve on the wall between `a_i` and `a_{i+1}`.
    fn blowup(chain: &[u32], i: usize) -> Vec<u32> {
        let mut v = Vec::with_capacity(chain.len() + 1);
        v.extend_from_slice(&chain[..i]);
        v.push(chain[i] + 1);
        v.push(1);
        v.push(chain[i + 1] + 1);
        v.extend_from_slice(&chain[i + 2..]);
        v
    }

    /// Castelnuovo reduction to the canonical minimal chain (all `a_i ≥ 2`).
    fn reduce(chain: &[u32]) -> Vec<u32> {
        let mut c: Vec<u32> = chain.to_vec();
        while let Some(j) = c.iter().position(|&x| x == 1) {
            assert!(j > 0 && j < c.len() - 1, "boundary (-1)-curve: out of P2 scope");
            let mut nc = Vec::with_capacity(c.len() - 1);
            nc.extend_from_slice(&c[..j - 1]);
            nc.push(c[j - 1] - 1);
            nc.push(c[j + 1] - 1);
            nc.extend_from_slice(&c[j + 2..]);
            c = nc;
        }
        c
    }

    #[test]
    fn blowdown_preserves_nq_and_is_confluent() {
        let mut pairs = 0u32;
        for n in 2..=80u32 {
            for q in 1..n {
                if gcd_u32(n, q) != 1 {
                    continue;
                }
                pairs += 1;
                let cd = hj_chain(n, q).digits().to_vec();
                let target = (n as i64, q as i64);
                assert_eq!(nq(&cd), target);
                let mut cur = cd.clone();
                let k = 2 * cd.len();
                for step in 0..k {
                    if cur.len() < 2 {
                        break;
                    }
                    let i = step % (cur.len() - 1);
                    cur = blowup(&cur, i);
                    assert_eq!(nq(&cur), target, "blow-up changed (n,q) at ({n},{q})");
                }
                let red = reduce(&cur);
                assert_eq!(red, cd, "reduction != canonical at ({n},{q})");
                assert_eq!(nq(&red), target);
            }
        }
        assert!(pairs > 0);
    }

    /// F-carry witness: a carry-as-successor edit (bump one radix) must break `(n,q)`.
    #[test]
    fn successor_edit_breaks_nq() {
        for &(n, q) in &[(7u32, 3u32), (5, 4), (11, 7), (30, 7)] {
            let mut w = hj_chain(n, q).digits().to_vec();
            w[0] += 1;
            assert_ne!(nq(&w), (n as i64, q as i64), "successor edit preserved (n,q)");
        }
    }
}

/// P3 mirror — deformation adjacency vs the prefix relation (the H2 partial-result check).
/// Independently reproduces the Sage combinatorics: the Wahl/T-singularity tree, its
/// verification as genuine `(1/dn²)(1,dnq−1)` singularities, and its orthogonality to prefix.
#[cfg(test)]
mod p3 {
    use super::*;
    use std::collections::{HashSet, VecDeque};
    use std::vec;
    use std::vec::Vec;

    fn nq(c: &[u32]) -> (i64, i64) {
        (
            continuant(c),
            if c.len() >= 2 { continuant(&c[1..]) } else { 1 },
        )
    }
    fn prefix_related(x: &[u32], y: &[u32]) -> bool {
        let (a, b) = if x.len() <= y.len() { (x, y) } else { (y, x) };
        &b[..a.len()] == a
    }
    fn m1(c: &[u32]) -> Vec<u32> {
        let mut v = vec![2u32];
        v.extend_from_slice(&c[..c.len() - 1]);
        v.push(c[c.len() - 1] + 1);
        v
    }
    fn m2(c: &[u32]) -> Vec<u32> {
        let mut v = vec![c[0] + 1];
        v.extend_from_slice(&c[1..]);
        v.push(2);
        v
    }
    /// Is `(n,q) = nq(c)` a T-singularity `(1/dn²)(1, dnq−1)`? (the non-fabrication check)
    fn is_t(c: &[u32]) -> bool {
        let (nf, qf) = nq(c);
        let mut nt = 2i64;
        while nt * nt <= nf {
            if nf % (nt * nt) == 0 {
                let d = nf / (nt * nt);
                if (qf + 1) % nt == 0 {
                    let qp = (qf + 1) / nt;
                    if d * nt * qp - 1 == qf && gcd_i64(nt as u64, qp as u64) == 1 {
                        return true;
                    }
                }
            }
            nt += 1;
        }
        false
    }

    #[test]
    fn wahl_t_tree_is_orthogonal_to_prefix() {
        const MAXLEN: usize = 8;
        let root = vec![4u32];
        let mut seen: HashSet<Vec<u32>> = HashSet::new();
        seen.insert(root.clone());
        let mut adj: HashSet<(Vec<u32>, Vec<u32>)> = HashSet::new();
        let mut dq = VecDeque::new();
        dq.push_back(root);
        while let Some(c) = dq.pop_front() {
            if c.len() >= MAXLEN {
                continue;
            }
            for ch in [m1(&c), m2(&c)] {
                let pair = if c <= ch {
                    (c.clone(), ch.clone())
                } else {
                    (ch.clone(), c.clone())
                };
                adj.insert(pair);
                if seen.insert(ch.clone()) {
                    dq.push_back(ch);
                }
            }
        }
        assert!(seen.iter().all(|c| is_t(c)), "a generated chain is not a T-singularity");
        assert_eq!(seen.len(), 255, "T-chain count");
        assert_eq!(adj.len(), 254, "Wahl-adjacency count");
        let pref = adj.iter().filter(|(x, y)| prefix_related(x, y)).count();
        assert_eq!(pref, 0, "QG-smoothing adjacency should be orthogonal to prefix");
    }

    #[test]
    fn a_family_prefix_is_adjacency() {
        let a: Vec<Vec<u32>> = (1..=60usize).map(|k| vec![2u32; k]).collect();
        for k in 1..a.len() {
            assert!(prefix_related(&a[k], &a[k - 1]), "A_n adjacency not prefix");
        }
    }
}
