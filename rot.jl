using LinearAlgebra		# Needed for I but missing in doc
using Random

function rand_lattice_rot(dim, seed=nothing)
	# Get random seed if none provided
	if isequal(seed, nothing)
		seed = rand(UInt)
	end

	# Sample random non-trivial multiple of pi/2
	Random.seed!(seed)
	theta = rand(1:3) * (π / 2)

	# Build 2-dimensional rotation by angle theta. Return if dim == 2
	c = cos(theta)
	s = sin(theta)
	rot2d = [c s; -s c]
	if dim == 2
		return round.(rot2d)
	end

	# Embed into dim dimensions
	Rot = [rot2d zeros(2, dim - 2); zeros(dim - 2, 2) Matrix(I, dim - 2, dim - 2)]

	# Permute rows and columns (by same permutation)
	Random.seed!(seed)
	new_rows = shuffle([Rot[i, :]' for i in 1:dim])
	Rot = vcat(new_rows...)

	Random.seed!(seed)
	new_cols = shuffle([Rot[:, i] for i in 1:dim])
	Rot = hcat(new_cols...)

	return round.(Rot)
end
