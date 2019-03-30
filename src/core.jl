import Base: length, getindex, Set, setfield!, copy, lastindex, iterate, setindex!
import LinearAlgebra: norm

include("helpers.jl")


struct Polymer
	steps::Int
	dim::Int
	data::Array{Array{Int, 1}, 1}

	# ------------------------------- Inner constructors ------------------------------- #

	"""
		Polymer(polymer::Polymer)

	Return a copy of `polymer`.
	"""
	function Polymer(polymer::Polymer)
		return new(polymer.steps, polymer.dim, copy(polymer.data))
	end

	"""
		Polymer(polymer::Polymer, indices::UnitRange{Int})

	Return the sub-polymer of `Polymer` indexed by `indices`.
	"""
	function Polymer(polymer::Polymer, indices::UnitRange{Int})
		new_polymer_data = polymer.data[UnitRange(indices[1]+1, indices[end]+1)]
		return new(length(indices)-1, polymer.dim, new_polymer_data)
	end

	"""
		Polymer(steps, dim)

	Return a `Polymer` initialized as a straight line.
	"""
	function Polymer(steps::Int, dim::Int=2)
		new(steps, dim, [i * basis(1, dim) for i in 0:steps])
	end

	"""
		Polymer(polymer, step, Rot)

	Return the polymer obtained by pivoting `polymer` via rotation matrix `Rot` at `step`.
	"""
	function Polymer(polymer::Polymer, step::Int, Rot::AbstractMatrix{Int})
		steps = length(polymer)
		point = polymer[step]		# Pivot point

		init_segment = Set(polymer[0:step])
		new_polymer = copy(polymer)

		# Try to parallelize this
		for i in step+1:steps
			new_point = point + Rot * (polymer[i] - point)
			if new_point in init_segment
				return polymer
			end

			# Note change of index
			new_polymer[i] = new_point
		end

		return new_polymer
	end

	"""
		Polymer(data)

	Return the `Polymer` constructed manually from `data` if this is a valid `Polymer`.

	# Warning
	This constructor should generally be avoided when performance is an issue, as it
	validates `data` by checking for possible intersections or a potential dimension
	mismatch (the latter verification is especially slow).
	"""
	function Polymer(data::Array{Array{Int, 1}, 1})
		if repeats(data)
			error("Polymer cannot have intersections.")
		end

		try
			hcat(data...)
		catch x
			throw(DimensionMismatch("monomers must have equal dimension"))
		end

		steps = length(data) - 1
		dim = length(data[1])

		return new(steps, dim, data)
	end

	function Polymer(steps::Int, dim::Int, data::Array{Array{Int, 1}, 1})
		return Polymer(data)
	end
end


# --------------------------------- Outer constructors --------------------------------- #

"""
	stairs(steps, dim)

Return a `Polymer` initialized as a (planar) staircase.
"""
function stairs(steps, dim=2)
	horizontal = [Int(ceil(i / 2)) * basis(1, dim) for i=0:steps]
	vertical = [Int(floor(i / 2)) * basis(2, dim) for i=0:steps]

	return Polymer(horizontal + vertical)
end


"""
	bridge(steps, dim)

Return a `Polymer` initialized as Markovian self-avoiding bridge.
"""
function bridge(steps, dim=2)
	e = [basis(i, dim) for i=1:dim]
	options = [e..., -e[dim]]

	summands = Array{Array{Int, 1}}(undef, steps+1)
	summands[1] = zeros(Int, dim)

	for i=2:steps+1
		valid = false
		candidate = nothing
		while !valid
			candidate = rand(options)
			if candidate == e[1] || candidate != -summands[i-1]
				valid = true
			end
		end
		summands[i] = candidate
	end

	output = Array{Array{Int, 1}}(undef, steps+1)
	output[1] = summands[1]
	for i=2:steps+1
		output[i] = summands[i] + output[i-1]
	end

	return Polymer(output)
end

# -------------------------------- Basic polymer methods -------------------------------- #

function length(polymer::Polymer)
	return polymer.steps
end


function lastindex(polymer::Polymer)
	return length(polymer)
end

function getindex(polymer::Polymer, index::Int)
	return polymer.data[index+1]
end


function getindex(polymer::Polymer, indices::UnitRange{Int})
	return Polymer(polymer, indices)
end


function setindex!(polymer::Polymer, value, index::Int)
	polymer.data[index+1] = value
end


function copy(polymer::Polymer)
	return Polymer(polymer)
end


function Set(polymer::Polymer)
	return Set(polymer.data)
end


# ------------------------------ Other polymer properties ------------------------------ #

function dist(polymer::Polymer)
	return norm(polymer[end])
end
