"""
This file contains some helper functions for testing
Provided by CS 61C staff
"""

import dumbpy as dp
import numc as nc
import numpy as np
import hashlib, struct
from typing import Union, List
import operator
import time

"""
Global vars
"""
num_samples = 1000
decimal_places = 6
func_mapping = {
    "add": operator.add,
    "sub": operator.sub,
    "mul": operator.mul,
    "neg": operator.neg,
    "abs": operator.abs,
    "pow": operator.pow
}
"""
Returns a dumbpy matrix and a numc matrix with the same data
"""
def dp_nc_matrix(*args, **kwargs):
    if len(kwargs) > 0:
        return dp.Matrix(*args, **kwargs), nc.Matrix(*args, **kwargs)
    else:
        return dp.Matrix(*args), nc.Matrix(*args)

"""
Returns a random dumbpy matrix and a random numc matrix with the same data
seed, low, and high are optional
"""
def rand_dp_nc_matrix(rows, cols, seed=0):
    return dp.Matrix(rows, cols, rand=True, seed=seed), nc.Matrix(rows, cols, rand=True, seed=seed)


"""
Returns whether the given dumbpy matrix dp_mat is equal to the numc matrix nc_mat
This function allows a reasonable margin of( floating point errors
"""
def cmp_dp_nc_matrix(dp_mat: dp.Matrix, nc_mat: nc.Matrix):
    return rand_md5(dp_mat) == rand_md5(nc_mat)

"""
Test if numc returns the correct result given an operation and some matrices.
If speed_up is set to True, returns the speedup as well
"""
def compute(dp_mat_lst: List[Union[dp.Matrix, int]],
    nc_mat_lst: List[Union[nc.Matrix, int]], op: str):
    f = func_mapping[op]
    nc_start, nc_end, dp_start, dp_end = None, None, None, None
    nc_result, dp_result = None, None
    assert(op in list(func_mapping.keys()))
    if op == "neg" or op == "abs":
        assert(len(dp_mat_lst) == 1)
        assert(len(nc_mat_lst) == 1)
        nc_start = time.time()
        nc_result = f(nc_mat_lst[0])
        nc_end = time.time()

        dp_start = time.time()
        dp_result = f(dp_mat_lst[0])
        dp_end = time.time()
    else:
        assert(len(dp_mat_lst) > 1)
        assert(len(nc_mat_lst) > 1)
        nc_start = time.time()
        nc_result = nc_mat_lst[0]
        for mat in nc_mat_lst[1:]:
            nc_result = f(nc_result, mat)
        nc_end = time.time()

        dp_start = time.time()
        dp_result = dp_mat_lst[0]
        for mat in dp_mat_lst[1:]:
            dp_result = f(dp_result, mat)
        dp_end = time.time()
    # Check for correctness
    is_correct = cmp_dp_nc_matrix(nc_result, dp_result)
    return is_correct, (dp_end - dp_start) / (nc_end - nc_start)

"""
Print speedup
"""
def print_speedup(speed_up):
    print("Speed up is:", speed_up)

"""
Generate a md5 hash by sampling random elements in nc_mat
"""
def rand_md5(mat: Union[dp.Matrix, nc.Matrix]):
    np.random.seed(1)
    m = hashlib.md5()
    if len(mat.shape) > 1:
        rows, cols = mat.shape
        total_cnt = mat.shape[0] * mat.shape[1]
        if total_cnt < num_samples:
            for i in range(rows):
                for j in range(cols):
                    m.update(struct.pack("f", round(mat[i][j], decimal_places)))
        else:
            for _ in range(num_samples):
                i = np.random.randint(rows)
                j = np.random.randint(cols)
                m.update(struct.pack("f", round(mat[i][j], decimal_places)))
    else:
        total_cnt = mat.shape[0]
        if total_cnt < num_samples:
            for i in range(total_cnt):
                m.update(struct.pack("f", round(mat[i], decimal_places)))
        else:
            for _ in range(num_samples):
                i = np.random.randint(total_cnt)
                m.update(struct.pack("f", round(mat[i], decimal_places)))
    return m.digest()
