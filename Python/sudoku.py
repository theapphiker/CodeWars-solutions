# This method validates an 'NxN' Sudoku data structure. Link to challenge: https://www.codewars.com/kata/540afbe2dc9f615d5e000425
import numpy as np


class Sudoku:
    def __init__(self, data):
        self.data = data

    def is_valid(self):
        arr = np.array(self.data, dtype=object)
        # check that data structure is an 'NxN' valid shape
        if len(arr.shape) == 1 or len(set(arr.shape)) != 1:
            return False
        else:
            n = int(arr.shape[0] ** 0.5)
            for i in range(0, arr.shape[0], n):
                for i2 in range(0, arr.shape[0], n):
                    # check that each square of the sudoku data structure contains valid answers
                    if len(set(arr[i : i + n, i2 : i2 + n].flatten())) != arr.shape[0]:
                        return False
                    # check that only digits are present in the sudoku data structure
                    elif (
                        all(
                            [
                                str(e).isdigit()
                                for e in arr[i : i + n, i2 : i2 + n].flatten()
                            ]
                        )
                        == False
                    ):
                        return False
                    # check that digits are greater than or equal to 1 and less than or equal to N
                    elif (
                        all(
                            [
                                1 <= e <= arr.shape[0]
                                for e in arr[i : i + n, i2 : i2 + n].flatten()
                            ]
                        )
                        == False
                    ):
                        return False
        return True
