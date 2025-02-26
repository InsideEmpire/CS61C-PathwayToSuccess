from utils import *
from unittest import TestCase

"""
For each operation, you should write tests to test  on matrices of different sizes.
Hint: use dp_mc_matrix to generate dumbpy and numc matrices with the same data and use
      cmp_dp_nc_matrix to compare the results
"""
class TestAdd(TestCase):
    def test_small_add(self):
        # TODO: YOUR CODE HERE
        dp_mat1, nc_mat1 = rand_dp_nc_matrix(2, 2, seed=0)
        dp_mat2, nc_mat2 = rand_dp_nc_matrix(2, 2, seed=1)
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "add")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_add(self):
        # TODO: YOUR CODE HERE
        pass

    def test_large_add(self):
        # TODO: YOUR CODE HERE
        pass

class TestSub(TestCase):
    def test_small_sub(self):
        # TODO: YOUR CODE HERE
        dp_mat1, nc_mat1 = rand_dp_nc_matrix(2, 2, seed=0)
        dp_mat2, nc_mat2 = rand_dp_nc_matrix(2, 2, seed=1)
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "add")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_sub(self):
        # TODO: YOUR CODE HERE
        pass

    def test_large_sub(self):
        # TODO: YOUR CODE HERE
        pass

class TestAbs(TestCase):
    def test_small_abs(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        is_correct, speed_up = compute([dp_mat], [nc_mat], "abs")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_abs(self):
        # TODO: YOUR CODE HERE
        pass

    def test_large_abs(self):
        # TODO: YOUR CODE HERE
        pass

class TestNeg(TestCase):
    def test_small_neg(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        is_correct, speed_up = compute([dp_mat], [nc_mat], "neg")
        self.assertTrue(is_correct)
        print_speedup(speed_up)
    def test_medium_neg(self):
        # TODO: YOUR CODE HERE
        pass

    def test_large_neg(self):
        # TODO: YOUR CODE HERE
        pass

class TestMul(TestCase):
    def test_small_mul(self):
        # TODO: YOUR CODE HERE
        dp_mat1, nc_mat1 = rand_dp_nc_matrix(2, 2, seed=0)
        dp_mat2, nc_mat2 = rand_dp_nc_matrix(2, 2, seed=1)
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "mul")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_mul(self):
        # TODO: YOUR CODE HERE
        pass

    def test_large_mul(self):
        # TODO: YOUR CODE HERE
        pass

class TestPow(TestCase):
    def test_small_pow(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        is_correct, speed_up = compute([dp_mat, 3], [nc_mat, 3], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_pow(self):
        # TODO: YOUR CODE HERE
        pass

    def test_large_pow(self):
        # TODO: YOUR CODE HERE
        pass

class TestGet(TestCase):
    def test_get(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        rand_row = np.random.randint(dp_mat.shape[0])
        rand_col = np.random.randint(dp_mat.shape[1])
        self.assertEqual(round(dp_mat[rand_row][rand_col], decimal_places),
            round(nc_mat[rand_row][rand_col], decimal_places))

class TestSet(TestCase):
    def test_set(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        rand_row = np.random.randint(dp_mat.shape[0])
        rand_col = np.random.randint(dp_mat.shape[1])
        self.assertEquals(round(dp_mat[rand_row][rand_col], decimal_places),
            round(nc_mat[rand_row][rand_col], decimal_places))

class TestShape(TestCase):
    def test_shape(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        self.assertTrue(dp_mat.shape == nc_mat.shape)
