# Given an n x n array, this Python program returns the array elements arranged from outermost elements to the middle element, traveling clockwise.
# Link to challenge: https://www.codewars.com/kata/521c2db8ddc89b9b7a0000c1/python

import numpy as np


def snail(snail_map):
    if len(snail_map) * len(snail_map[0]) in [0, 1]:
        return list(snail_map[0])
    else:
        sm = np.array(snail_map)
        t = list(
            np.concatenate(
                [
                    sm[0],
                    sm[1 : len(sm) - 1, -1],
                    sm[-1][::-1],
                    sm[1 : len(sm) - 1, 0][::-1],
                ]
            )
        )
        if len(t) == (len(sm) * len(sm[0])):
            return t
        else:
            return t + snail(list(sm[1 : len(sm) - 1, 1 : len(sm[0]) - 1]))
