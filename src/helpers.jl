using LinearAlgebra
using SparseArrays
using Random


"""
	rand_lattice_rot(dim[, seed])

Return a random rotation matrix of the `dim`-dimensional hypercubic lattice.
"""
function rand_lattice_rot::SparseMatrixCSC{Int, Int} end


function rand_lattice_rot(dim::Int)
	return rand_lattice_rot(dim, rand(UInt))
end


function rand_lattice_rot(dim::Int, seed::Integer)
	# Sample (cos, sin) pair for rotation by non-trivial multiple of π/2
	Random.seed!(seed)
	costheta, sintheta = rand([(0, 1), (-1, 0), (0, -1)])

	# Initialize trivial rotation matrix
	Rot = Int.(sparse(I, dim, dim))

	# Randomly insert 2-dimensional rotation into Rot
	# Equivalent to randomly permuting xy rotation matrix
	Random.seed!(seed)
	i = rand(1:dim)

	Random.seed!(seed)
	j = rand(setdiff(1:dim, i))

	Rot[i, i] = Rot[j, j] = costheta
	Rot[i, j] = sintheta
	Rot[j, i] = -sintheta

	return Rot
end


"""
	basis(i, dim=2)

Return the `i`-th element of the standard basis in `dim` dimensions.
"""
function basis(i, dim=2)
	e = zeros(Int, dim)
	e[i] = 1
	return e
end


"""
	repeats(array)

Determine whether an array contains a repeated element.
"""
function repeats(array)
	return length(Set(array)) < length(array)
end
