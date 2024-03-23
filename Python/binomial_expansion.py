# This Python program algebraically expands the powers of a binomial.
# Link to challenge: https://www.codewars.com/kata/540d0fdd3b6532e5c3000b5b/python

import regex as re
from math import factorial


def expand(s):
    k = 0
    # extract variable letter from string
    w = re.search(r"\(.*([a-z])", s).group(1)
    # extract power from string
    n = int(re.search(r".*\^([0-9]+)", s).group(1))
    # extract coefficient from string
    a = (
        1
        if s[1] == w
        else (-1 if s[1:3] == "-" + w else int(re.search(r"(-?[0-9]+).*", s).group(1)))
    )
    # extract integer from string
    b = int(re.search(r".*[a-z]\+?(-?\d+)\).*", s).group(1))
    ns = ""
    if b == 0:
        return f"{w}^{n}"
    elif n == 0:
        return "1"
    else:
        # use Binomial theorem to expand original form
        while k <= n:
            ts = f"{(b)**k*int(factorial(n)/(factorial(k)*factorial(n-k)))*(a)**(n-k)}{w}^{n-k}"
            ts = ts[:-2] if n - k == 1 else (ts[:-3] if n - k == 0 else ts)
            ns += ts if ts[0] == "-" or k == 0 else "+" + ts
            k += 1
        return ns.replace("1", "", 1) if ns[:2] == "1" + w or ns[:3] == "-1" + w else ns
