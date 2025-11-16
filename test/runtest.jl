include("..\\src\\HiBitSet.jl")

using .HiBitSets
using BenchmarkTools

A, B = rand(1:999, 100), rand(1:999, 100)

# Example usage (uncomment to test):

out = HiBitSets.HiBitSet(1000)
hb = HiBitSets.HiBitSet(A,1000)
#push!(hb, 10); push!(hb, 12); push!(hb, 99)
hb2 = HiBitSets.HiBitSet(B,1000)
#push!(hb2, 12); push!(hb2, 50)
println(HiBitSets.intersect_to_vector(hb, hb2))

c = Set(A)
d = Set(B)

@btime intersect!($out, $hb,$hb2)
@btime intersect!($c,$d)

@btime contains($hb, 1)
@btime in($c, 1)

#println(intersect!(a,b))
#println(intersect!(c,d))