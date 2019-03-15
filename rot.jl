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
	Rot = sparse(Diagonal(ones(dim)))

	# Randomly insert 2-dimensional rotation into Rot
	# Equivalent to randomly permuting xy rotation matrix
	i = rand(1:dim)
	j = rand(setdiff(1:dim, i))

	Rot[i, i] = Rot[j, j] = costheta
	Rot[i, j] = sintheta
	Rot[j, i] = -sintheta

	return Rot
end


# Deprecated due to efficient implementation of sparse matrix above
function fast_rand_lattice_rot(vector, seed=nothing)
	vector = copy(vector)

	if !isequal(seed, nothing)
		Random.seed!(seed)
	end

	# Sample random plane of rotation
	dim = length(vector)
	i = rand(1:dim)
	j = rand(setdiff(1:dim, i))

	# Sample random non-trivial planar rotation (3 options)
	rot = rand(1:3)
	temp = vector[i]

	if rot == 1
		vector[i] = -vector[i]
		vector[j] = -vector[j]
	elseif rot == 2
		vector[i] = vector[j]
		vector[j] = -temp
	else
		vector[i] = -vector[j]
		vector[j] = temp
	end

	return vector
end
