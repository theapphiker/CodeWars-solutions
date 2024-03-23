# This Python program accepts an array of intervals, and returns the sum of all the interval lengths.
# Link to challenge: https://www.codewars.com/kata/52b7ed099cdc285c300001cd


def sum_of_intervals(a):
    l = []
    t = 0
    a.sort(key=lambda x: x[0])
    for i in range(len(a)):
        if l != []:
            if a[i][0] > max(l):
                t += max(l) - min(l)
                l = []
        l.extend([a[i][0], a[i][1]])
    t += max(l) - min(l)
    return t
