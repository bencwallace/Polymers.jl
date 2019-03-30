import Base: length, getindex, Set, setfield!, copy, lastindex, iterate, setindex!
import LinearAlgebra: norm

include("helpers.jl")


struct Polymer
	steps::Int
	dim::Int
	data::Array{Array{Int, 1}, 1}

	# Inner constructors

	# Copy constructor
	function Polymer(polymer::Polymer)
		return new(polymer.steps, polymer.dim, copy(polymer.data))
	end

	# Sub-polymer constructor
	function Polymer(polymer::Polymer, indices::UnitRange{Int})
		new_polymer_data = polymer.data[UnitRange(indices[1]+1, indices[end]+1)]
		return new(length(indices)-1, polymer.dim, new_polymer_data)
	end

	# Line constructor
	function Polymer(steps::Int, dim::Int=2)
		new(steps, dim, [i * basis(1, dim) for i in 0:steps])
	end

	# Pivot constructor
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

	# Manual constructor
	function Polymer(data::Array{Array{Int, 1}, 1})
		if intersects(data)
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
end


# Outer constructors

function stairs(steps, dim=2)
	horizontal = [Int(ceil(i / 2)) * basis(1, dim) for i=0:steps]
	vertical = [Int(floor(i / 2)) * basis(2, dim) for i=0:steps]

	return Polymer(horizontal + vertical)
end


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

# Basic polymer methods

function length(polymer::Polymer)
	return polymer.steps
end

function iterate(polymer::Polymer)
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


# Other polymer properties

function dist(polymer::Polymer)
	return norm(polymer[end])
end
