include("..\\src\\HiBitSet.jl")

using .HiBitSets

a = HiBitSet{UInt8, 3}([1,4,6,8])
b = HiBitSet{UInt8, 3}([9,4,6,2])

println(a)
println(intersect!(a,b))