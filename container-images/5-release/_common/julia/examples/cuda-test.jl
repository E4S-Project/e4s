using CUDA
using Test
N = 2^20
x_d = CUDA.fill(1.0f0, N)
y_d = CUDA.fill(2.0f0, N)
function gpu_add1!(y, x)
    for i = 1:length(y)
        @inbounds y[i] += x[i]
    end
    return nothing
end
fill!(y_d, 2)
@cuda gpu_add1!(y_d, x_d)
@show @test all(Array(y_d) .== 3.0f0)
