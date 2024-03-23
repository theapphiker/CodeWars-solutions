# This Python class is used to calculate the amount that a user will progress through a ranking system similar to the one Codewars uses.
# Link to challenge: https://www.codewars.com/kata/51fda2d95d6efda45e00004e/python


class User:
    r = [-8, -7, -6, -5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6, 7, 8]

    def __init__(self):
        self.rank = -8
        self.progress = 0

    def inc_progress(self, p):
        if p not in User.r:
            raise ValueError
        elif p == self.rank:
            self.progress += 3
        elif p == User.r[User.r.index(self.rank) - 1] and p != 8:
            self.progress += 1
        elif p > self.rank:
            self.progress += 10 * ((User.r.index(p) - User.r.index(self.rank)) ** 2)
        while self.progress >= 100 and self.rank != 8:
            self.progress -= 100
            self.rank = User.r[User.r.index(self.rank) + 1]
        if self.rank == 8:
            self.progress = 0
