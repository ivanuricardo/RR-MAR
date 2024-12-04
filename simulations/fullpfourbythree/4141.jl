using DrWatson
@quickactivate "RR-MAR"
using TensorToolbox, Statistics, Random, LinearAlgebra, CommonFeatures, Latexify, ProgressBars, DelimitedFiles

Random.seed!(20230408)

sims = 1000
dimvals = [4, 3]
ranks = [4, 1, 4, 1]
r̄ = [4, 3, 4, 3]


maxiters = 500
tucketa = 1e-03
ϵ = 1e-03
gscale = 4
maxeigen = 0.9
snr = 0.7
p = 1
pmax = 3

smallaic = fill(NaN, 5, sims)
smallbic = fill(NaN, 5, sims)
medaic = fill(NaN, 5, sims)
medbic = fill(NaN, 5, sims)

burnin = 50
smallobs = 100 + burnin
medobs = 500 + burnin

folder = "savedsims"

A, G, U1, U2, U3, U4, U5 = generatetuckercoef(dimvals, ranks, p; gscale, maxeigen)
# sort(abs.(eigen(makecompanion(tenmat(A, row=[1, 2]))).values), rev=true)

avgmediters = fill(NaN, sims)
avgsmalliters = fill(NaN, sims)

Threads.@threads for s in ProgressBar(1:sims)
    medmar = simulatetuckerdata(dimvals, ranks, medobs; A, p, snr)
    medmar = medmar.data[:, :, (burnin+1):end]
    medicest = fullinfocrit(medmar, pmax, r̄; maxiters, tucketa, ϵ)
    medaic[:, s] .= medicest.aicval[1:5]
    medbic[:, s] .= medicest.bicval[1:5]
    avgmediters[s] = mean(filter(!isnan, medicest.regiters))

    smallmar = simulatetuckerdata(dimvals, ranks, smallobs; A, p, snr)
    smallmar = smallmar.data[:, :, (burnin+1):end]
    smallicest = fullinfocrit(smallmar, pmax, r̄; maxiters, tucketa, ϵ)
    smallaic[:, s] .= smallicest.aicval[1:5]
    smallbic[:, s] .= smallicest.bicval[1:5]
    avgsmalliters[s] = mean(filter(!isnan, smallicest.regiters))

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

smallaicstats = simstats(smallaic[1:4, :], ranks, sims)
smallbicstats = simstats(smallbic[1:4, :], ranks, sims)

medaicstats = simstats(medaic[1:4, :], ranks, sims)
medbicstats = simstats(medbic[1:4, :], ranks, sims)

avgrank = hcat(smallaicstats.avgval, smallbicstats.avgval,
    medaicstats.avgval, medbicstats.avgval)

stdrank = hcat(smallaicstats.stdval, smallbicstats.stdval,
    medaicstats.stdval, medbicstats.stdval)

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

smallaiclag = simstats(smallaic[5, :], p, sims)
smallbiclag = simstats(smallbic[5, :], p, sims)

medaiclag = simstats(medaic[5, :], p, sims)
medbiclag = simstats(medbic[5, :], p, sims)

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

################################################################################

println("Average lag for small size (p, AIC): ", smallaiclag.avgval)
println("Average lag for small size (p, BIC): ", smallbiclag.avgval)

println("Freq. Correct for small size (p, AIC): ", smallaiclag.freqcorrect)
println("Freq. Correct for small size (p, BIC): ", smallbiclag.freqcorrect)

println("Average lag for medium size (p): ", medaiclag.avgval)
println("Average lag for medium size (p): ", medbiclag.avgval)

println("Freq. Correct for medium size (p): ", medaiclag.freqcorrect)
println("Freq. Correct for medium size (p): ", medbiclag.freqcorrect)

