# FDRS EXP 73 IMAGE + CODE TEST

Display test for image rendering and fenced code blocks in the `site_data`
frontend.

Canonical source image:
`/home/billy/HiR/math_research/proofs/fdrs_formal/Sage/fdrs_exp73e_interaction_order_spectrum.png`

![Experiment 73e interaction-order spectrum](experiments/maths/fdrs-exp73-image-code-test/fdrs_exp73e_interaction_order_spectrum.png)

## Code Snippet

```python
def interaction_order_spectrum(signal, atoms, N):
    """Energy at each interaction order."""
    coeffs = haar_coefficients(signal, atoms, N)
    max_order = max(a["order"] for a in atoms)
    spectrum = {}
    for order in range(max_order + 1):
        spectrum[order] = sum(
            coeffs[ai] ** 2
            for ai, a in enumerate(atoms)
            if a["order"] == order
        )
    return spectrum
```

This page is a distribution test only. The canonical Sage script and generated
experiment artifact remain in the HiR math research tree.
