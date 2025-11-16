#################################################################################################################
########################################################### CORE ################################################
#################################################################################################################

export HiBitSet
export intersect

mutable struct HiBitSet{T,N} <: AbstractHiBitSet
	layers::NTuple{N,Vector{UInt64}}
	data::Vector{T}

	## Constructors

	HiBitSet{T,N}() where {T<:Any, N} = new{T,N}(ntuple(i -> zeros(UInt64, (sizeof(T)*8)^(i-1)), Val(N)), Vector{T}(undef, (sizeof(T)*8)^N))
	HiBitSet{T,N}(A::Vector) where {T,N} = begin
		hb = HiBitSet{T,N}()
		append!(hb, A)
		return hb
	end
end

################################################### HELPERS #####################################################

_position_info(hb::HiBitSet{T,N}, n) where {T,N} = begin 
    usize = sizeof(T)*8
    (n ÷ usize, n % usize)
end
function Base.append!(hb::HiBitSet{T, N}, A) where {T,N}
	usize = sizeof(T)*8
	for a in A
		i,j = _position_info(hb, a)
		hb.data[i*usize + j+1] = a

	    for k in N:-1:1
	    	v = hb.layers[k]
	    	v[i+1] |= one(T) << j
	    	i, j = _position_info(hb, i+1)
	    end
	end
end

function Base.intersect!(hb1::HiBitSet{T,N}, hb2::HiBitSet{T,N}) where {T,N}
	test_layer = Int[1]
	to_scan = NTuple{2,Int}[(1,1)]
	inter = T[]
	usize = sizeof(T)*8

	for i in Base.OneTo(N)
		result = NTuple{2,Int}[]
		for (_,s) in to_scan
			match = hb1.layers[i][s] & hb2.layers[i][s]

			iszero(match) && continue
			basepos = trailing_zeros(match)

			while match != 0
				npos = trailing_zeros(match)
				push!(result, (s,basepos))
				match >>= npos+1
				basepos += npos
			end
		end

		to_scan = result
	end

	for (k,s) in to_scan
		push!(inter, hb1.data[k*(usize)+s+1])
	end

	return inter
end
