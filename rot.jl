using LinearAlgebra		# Needed for I but missing in doc
using Random
using SparseArrays

function rand_lattice_rot(dim, seed=nothing)
	# Sample (cos, sin) pair for rotation by non-trivial multiple of π/2
	if !isequal(seed, nothing)
		Random.seed!(seed)
	end
	costheta, sintheta = rand([(0, 1), (-1, 0), (0, -1)])

	# Initialize trivial rotation matrix
	Rot = Int.(sparse(I, dim, dim))

	# Randomly insert 2-dimensional rotation into Rot
	# Equivalent to randomly permuting xy rotation matrix
	i = rand(1:dim)
	j = rand(setdiff(1:dim, i))

	Rot[i, i] = Rot[j, j] = costheta
	Rot[i, j] = sintheta
	Rot[j, i] = -sintheta

	return Rot
end
