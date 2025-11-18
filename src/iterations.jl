Base.@propagate_inbounds function Base.iterate(hb::HiBitSet{T}, state=(0,1)) where T
    layer = hb.layers[1]
    bitpos, bitset = state
    usize = sizeof(T) * 8

    while bitset <= length(layer)
        bits = layer[bitset] >> bitpos

        if bits != 0
            gap = trailing_zeros(bits)
            next_bitpos = bitpos + gap + 1
            cond = next_bitpos < usize
            next_state = (next_bitpos*cond, bitset+cond)
            return ((bitset-1)*usize + bitpos + gap, next_state)
        end

        bitset += 1
        bitpos = 0
    end

    return nothing
end


function Base.collect(hb::HiBitSet)
	res = Int[]
	for e in hb
		push!(res, e)
	end

	return res
end