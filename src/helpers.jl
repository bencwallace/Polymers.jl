using LinearAlgebra
using SparseArrays
using Random


function rand_lattice_rot(dim::Int, seed=nothing)
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


function basis(i, dim=2)
	e = zeros(Int, dim)
	e[i] = 1
	return e
end


function intersects(array::Array{Array{Int, 1}, 1})
	return length(Set(array)) < length(array)
end
