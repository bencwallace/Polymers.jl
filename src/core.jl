import Base: length, getindex, Set, setfield!, copy, lastindex, iterate, setindex!
import LinearAlgebra: norm

include("helpers.jl")


struct Polymer
	steps::Int
	dim::Int
	pt2idx::Dict{Vector{Int}, Set{Int}}
	data::Array{Vector{Int}, 1}

	# ------------------------------- Inner constructors ------------------------------- #

	"""
		Polymer(polymer::Polymer)

	Return a copy of `polymer`.
	"""
	Polymer(polymer::Polymer) = new(polymer.steps, polymer.dim, deepcopy(polymer.pt2idx), copy(polymer.data))

	"""
		Polymer(steps, dim)

	Return a `Polymer` initialized as a straight line.
	"""
	Polymer(steps::Int, dim::Int=2) =
		new(steps, dim, Dict(i * basis(1, dim) => Set(i) for i in 0:steps), [i * basis(1, dim) for i in 0:steps])

	"""
		Polymer(data)

	Return the `Polymer` constructed manually from `data` if this is a valid `Polymer`.

	# Warning
	This constructor should generally be avoided when performance is an issue, as it
	validates `data` by checking for possible intersections or a potential dimension
	mismatch (the latter verification is especially slow).
	"""
	function Polymer(data::Array{Vector{Int}, 1})
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
		pt2idx = Dict(pt => i for (i, pt) in enumerate(data))

		return new(steps, dim, pt2idx, data)
	end

	Polymer(steps::Int, dim::Int, data::Array{Vector{Int}, 1}) = Polymer(data)
end

function self_avoiding(polymer)
	for i in 1:length(polymer)
		for j in i+1:length(polymer)
			if polymer[i] == polymer[j]
				return false
			end
		end
	end
	return true
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

	summands = Array{Vector{Int}}(undef, steps+1)
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

	output = Array{Vector{Int}}(undef, steps+1)
	output[1] = summands[1]
	for i=2:steps+1
		output[i] = summands[i] + output[i-1]
	end

	return Polymer(output)
end

# -------------------------------- Basic polymer methods -------------------------------- #

length(polymer::Polymer) = polymer.steps


lastindex(polymer::Polymer) = length(polymer)


getindex(polymer::Polymer, index::Int) = polymer.data[index+1]


function setindex!(polymer::Polymer, value, index::Int)
	s = get(polymer.pt2idx, polymer.data[index+1], Set())
	pop!(s, index + 1, nothing)
	if isempty(s)
		delete!(polymer.pt2idx, polymer.data[index+1])
	end
	polymer.data[index+1] = value
	if value in keys(polymer.pt2idx)
		push!(polymer.pt2idx[value], index + 1)
	else
		polymer.pt2idx[value] = Set([index + 1])
	end
end


copy(polymer::Polymer) = Polymer(polymer)


# ------------------------------ Other polymer properties ------------------------------ #

"""
	dist(polymer)

Return the end-to-end distance of `polymer`.
"""
dist(polymer::Polymer) = norm(polymer[end])
