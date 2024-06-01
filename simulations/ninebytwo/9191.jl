using DrWatson
@quickactivate "RR-MAR"
using TensorToolbox, Statistics, Random, LinearAlgebra, CommonFeatures, Latexify, ProgressBars, DelimitedFiles

Random.seed!(20230408)

sims = 1000
dimvals = [9, 2]
ranks = [9, 1, 9, 1]
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

A, G, U1, U2, U3, U4, U5 = generatetuckercoef(dimvals, ranks, p; gscale, maxeigen)
# sort(abs.(eigen(makecompanion(tenmat(A, row=[1, 2]))).values), rev=true)

avgmediters = []
avgsmalliters = []

Threads.@threads for s in ProgressBar(1:sims)
    medmar = simulatetuckerdata(dimvals, ranks, medobs; A, p, snr)
    medmar = medmar.data[:, :, (burnin+1):end]
    medicest = infocrit(medmar, p; r̄, maxiters, tucketa, ϵ)
    medaic[:, s] .= medicest.aic[1:4]
    medbic[:, s] .= medicest.bic[1:4]
    push!(avgmediters, mean(filter(!isnan, medicest.ictable[7, :])))

    smallmar = simulatetuckerdata(dimvals, ranks, smallobs; A, p, snr)
    smallmar = smallmar.data[:, :, (burnin+1):end]
    smallicest = infocrit(smallmar, p; r̄, maxiters, tucketa, ϵ)
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

latexmatrix = latexify(round.(results', digits=2))
filepath = "final.txt"
# Write the matrix to a file with a custom delimiter
open(filepath, "w") do file
    write(file, latexmatrix)
end

statmat = results'

println("Average iterations for small: ", mean(avgsmalliters))
println("Average iterations for medium: ", mean(avgmediters))

println("Average rank for small size (AIC): ", statmat[1, 1:4])
println("Average rank for small size (BIC): ", statmat[2, 1:4])

println("Average rank for medium size (AIC): ", statmat[3, 1:4])
println("Average rank for medium size (BIC): ", statmat[4, 1:4])

println("Std. Dev rank for small size (AIC): ", statmat[1, 5:8])
println("Std. Dev rank for small size (BIC): ", statmat[2, 5:8])

println("Std. Dev rank for medium size (AIC): ", statmat[3, 5:8])
println("Std. Dev rank for medium size (BIC): ", statmat[4, 5:8])

println("Freq. Correct for small size (AIC): ", statmat[1, 13:16])
println("Freq. Correct for small size (BIC): ", statmat[2, 13:16])

println("Freq. Correct for medium size (AIC): ", statmat[3, 13:16])
println("Freq. Correct for medium size (BIC): ", statmat[4, 13:16])


