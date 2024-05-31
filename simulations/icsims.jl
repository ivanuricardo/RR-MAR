using TensorToolbox, Statistics, Random, LinearAlgebra, CommonFeatures, Latexify, ProgressBars, DelimitedFiles

Random.seed!(20230408)

sims = 1000
dimvals = [9, 2]
ranks = [9, 2, 9, 2]
r̄ = [9, 2, 9, 2]


maxiters = 500
tucketa = 1e-03
ϵ = 1e-03
gscale = 4
maxeigen = 0.9
snr = 0.7
p = 1

smallaic = fill(NaN, 4, sims)
smallbic = fill(NaN, 4, sims)
medaic = fill(NaN, 4, sims)
medbic = fill(NaN, 4, sims)

burnin = 50
smallobs = 100 + burnin
medobs = 500 + burnin

folder = "savedsims"
# function filter_matrix(m)
#     nan_columns = [any(isnan, m[:, col]) for col in eachindex(axes(m, 2))]
#     return m[:, .!nan_columns]
# end
#
# nanmed = fill(NaN, 4, 371)
# nansmall = fill(NaN, 4, 372)
#
# medaic = readdlm("./savedsims/medaic357.csv", ',', Float64, header=false)
# filtered_medaic = filter_matrix(medaic)
# medaic = [filtered_medaic nanmed]
#
# smallaic = readdlm("./savedsims/smallaic357.csv", ',', Float64, header=false)
# filtered_smallaic = filter_matrix(smallaic)
# smallaic = [filtered_smallaic nansmall]
#
# medbic = readdlm("./savedsims/medbic357.csv", ',', Float64, header=false)
# filtered_medbic = filter_matrix(medbic)
# medbic = [filtered_medbic nanmed]
#
# smallbic = readdlm("./savedsims/smallbic357.csv", ',', Float64, header=false)
# filtered_smallbic = filter_matrix(smallbic)
# smallbic = [filtered_smallbic nansmall]
#
# A, G, U1, U2, U3, U4, U5 = generatetuckercoef(dimvals, ranks, p; gscale, maxeigen)
A, stabit, ρ = generatevarcoef(dimvals[1] * dimvals[2], p; coefscale=0.3)
# sort(abs.(eigen(makecompanion(tenmat(A, row=[1, 2]))).values), rev=true)

avgmediters = []
avgsmalliters = []

@time Threads.@threads for s in ProgressBar(1:sims)
    # medmar = simulatetuckerdata(dimvals, ranks, medobs; A, p, snr)
    medvar = simulatevardata(dimvals[1] * dimvals[2], p, medobs; snr, A=A)
    meddata = medvar.data[:, (burnin+1):end]
    medmar = matten(meddata, [1, 2], [3], [dimvals[1], dimvals[2], (medobs - burnin)])
    # medicest = infocrit(medmar.data, p, r̄, maxiters, tucketa, 1e-03)
    medicest = infocrit(medmar, p, r̄, maxiters, tucketa, 1e-03)
    medaic[:, s] .= medicest.aic[1:4]
    medbic[:, s] .= medicest.bic[1:4]
    push!(avgmediters, mean(filter(!isnan, medicest.ictable[7, :])))

    # smallmar = simulatetuckerdata(dimvals, ranks, smallobs; A, p, snr)
    smallvar = simulatevardata(dimvals[1] * dimvals[2], p, smallobs; snr, A=A)
    smalldata = smallvar.data[:, (burnin+1):end]
    smallmar = matten(smalldata, [1, 2], [3], [dimvals[1], dimvals[2], (smallobs - burnin)])
    # smallicest = infocrit(smallmar.data, p, r̄, maxiters, tucketa, ϵ)
    smallicest = infocrit(smallmar, p, r̄, maxiters, tucketa, 1e-03)
    smallaic[:, s] .= smallicest.aic[1:4]
    smallbic[:, s] .= smallicest.bic[1:4]
    push!(avgsmalliters, mean(filter(!isnan, smallicest.ictable[7, :])))

    smallaicpath = joinpath(pwd(), folder, "smallaic$s.csv")
    smallbicpath = joinpath(pwd(), folder, "smallbic$s.csv")
    medaicpath = joinpath(pwd(), folder, "medaic$s.csv")
    medbicpath = joinpath(pwd(), folder, "medbic$s.csv")
    if !isdir(folder)
        mkdir(folder)
    end
    writedlm(smallaicpath, smallaic, ',')
    writedlm(smallbicpath, smallbic, ',')
    writedlm(medaicpath, medaic, ',')
    writedlm(medbicpath, medbic, ',')

    GC.gc()
end

# @time Threads.@threads for s in ProgressBar(1:sims)
#     medmar = simulatetuckerdata(dimvals, ranks, medobs, A, p, snr)
#     if s > 629
#         medicest = infocrit(medmar.data, p, r̄, maxiters, tucketa, ϵ)
#         medaic[:, s] .= medicest.AIC[1:4]
#         medbic[:, s] .= medicest.BIC[1:4]
#         push!(avgmediters, mean(filter(!isnan, medicest.ictable[7, :])))
#     end
#
#     smallmar = simulatetuckerdata(dimvals, ranks, smallobs, A, p, snr)
#     if s > 628
#         smallicest = infocrit(smallmar.data, p, r̄, maxiters, tucketa, ϵ)
#         smallaic[:, s] .= smallicest.AIC[1:4]
#         smallbic[:, s] .= smallicest.BIC[1:4]
#         push!(avgsmalliters, mean(filter(!isnan, smallicest.ictable[7, :])))
#     end
#
#     smallaicpath = joinpath(pwd(), folder, "smallaic$s.csv")
#     smallbicpath = joinpath(pwd(), folder, "smallbic$s.csv")
#     medaicpath = joinpath(pwd(), folder, "medaic$s.csv")
#     medbicpath = joinpath(pwd(), folder, "medbic$s.csv")
#     if !isdir(folder)
#         mkdir(folder)
#     end
#     writedlm(smallaicpath, smallaic, ',')
#     writedlm(smallbicpath, smallbic, ',')
#     writedlm(medaicpath, medaic, ',')
#     writedlm(medbicpath, medbic, ',')
#
#     GC.gc()
# end

smallaicstats = simstats(smallaic, ranks, sims)
smallbicstats = simstats(smallbic, ranks, sims)

medaicstats = simstats(medaic, ranks, sims)
medbicstats = simstats(medbic, ranks, sims)

avgrank = hcat(smallaicstats.avgrank, smallbicstats.avgrank,
    medaicstats.avgrank, medbicstats.avgrank)

stdrank = hcat(smallaicstats.stdrank, smallbicstats.stdrank,
    medaicstats.stdrank, medbicstats.stdrank)

lowerrank = hcat(smallaicstats.freqlow, smallbicstats.freqlow,
    medaicstats.freqlow, medbicstats.freqlow)

correctrank = hcat(smallaicstats.freqcorrect, smallbicstats.freqcorrect,
    medaicstats.freqcorrect, medbicstats.freqcorrect)

highrank = hcat(smallaicstats.freqhigh, smallbicstats.freqhigh,
    medaicstats.freqhigh, medbicstats.freqhigh)

results = vcat(avgrank, stdrank, lowerrank, correctrank, highrank)

latexmatrix = latexify(round.(results', digits=3))
filepath = "final.txt"
# Write the matrix to a file with a custom delimiter
open(filepath, "w") do file
    write(file, latexmatrix)
end

println("Average iterations for small: ", mean(avgsmalliters))
println("Average iterations for medium: ", mean(avgmediters))


