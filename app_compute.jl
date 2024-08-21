import Pkg; 

Pkg.add("DataFrames")
Pkg.add("JSON")
Pkg.add("CSV")

using CSV
using DataFrames
using JSON

# default values in third argument of get
Idx1 = get(ENV, "Idx1", "[100,200,300]")
Idx2 = get(ENV, "Idx2", "[1,2]")

Index1 = parse.(Int, split(chop(Idx1, head=1),','))
Index2 = parse.(Int, split(chop(Idx2, head=1),','))

index1_df = repeat(Index1, inner = length(Index2))
index2_df = repeat(Index2, outer = length(Index1)) 

df = DataFrame(Index1 = index1_df, Index2=index2_df)

function price(x,y)
    x .* y .+ sqrt(x)  
end

df = transform(df, [:Index1, :Index2] => ByRow(price) => :price)

ENV["RESULTS"] = json(df)


# define the path and filename
ENV["RESULTS_FILE"] = joinpath(@__DIR__,"output.csv")

# write the file to the path defined above, using the df object
CSV.write(ENV["RESULTS_FILE"], df)
