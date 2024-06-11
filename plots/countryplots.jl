using DrWatson
@quickactivate

using CodecBzip2
using TensorToolbox, CommonFeatures, RData, LinearAlgebra, Statistics, Makie, Dates
using CairoMakie

matdata = load(datadir("globaldata.jld2"), "matdata");

startdate = Date(1996, 1, 1)
enddate = Date(2019, 12, 31)

quarterlydates = collect(startdate:Dates.Quarter(1):enddate)
datetimes = DateTime.(string.(quarterlydates), "yyyy-mm-dd")
ticks = Dates.datetime2unix.(datetimes)
labels = Dates.format.(datetimes, "Y")
adjlabels = map(x -> x[3:end], labels)  # Takes only last 2 characters of year
adjlabels .= string.("'", adjlabels)
nolabels = fill("", length(adjlabels))

titlesize = 25
xlabsize = 13
xticksize = 13
ylabsize = 13
yticksize = 13
fontsize = 12
fig = Figure(backgroundcolor=:transparent, size=(800, 500));
qstep = 22
indicators = ["IR", "GDP", "PROD", "CPI"]
countries = ["USA", "CAN", "DEU", "FRA", "GBR"]
indposition = 8.2e8
counposition = 1.6e9

axint1 = Axis(fig[1, 1], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axint1, ticks, matdata[1, 1, :], color=:blue, label="IR")
text!(axint1, counposition, abs(maximum(matdata[1, 1, :])) + 0.25, text=countries[1], align=(:right, :top), fontsize=fontsize)
text!(axint1, indposition, -1, text=indicators[1], align=(:left, :bottom), fontsize=fontsize)

for i in 2:5
    axint = Axis(fig[1, i], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
    lines!(axint, ticks, matdata[1, i, :], color=:blue, label="IR")
    text!(axint, counposition, abs(maximum(matdata[1, i, :])) + 0.25, text=countries[i], align=(:right, :top), fontsize=fontsize)
end

axgdp1 = Axis(fig[2, 1], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axgdp1, ticks, matdata[2, 1, :], color=:blue, label="GDP")
text!(axgdp1, indposition, -0.02, text="GDP", align=(:left, :bottom), fontsize=fontsize)

for i in 2:5
    axgdp = Axis(fig[2, i], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
    lines!(axgdp, ticks, matdata[2, i, :], color=:blue, label="GDP")
end

axprod1 = Axis(fig[3, 1], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axprod1, ticks, matdata[3, 1, :], color=:blue, label="GDP")
text!(axprod1, indposition, -0.07, text="PROD", align=(:left, :bottom), fontsize=fontsize)

for i in 2:5
    axprod = Axis(fig[3, i], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
    lines!(axprod, ticks, matdata[3, i, :], color=:blue, label="GDP")
end

axcpi1 = Axis(fig[4, 1], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axcpi1, ticks, matdata[4, 1, :], color=:blue, label="CPI")
text!(axcpi1, 8.2e8, 0.007, text="CPI", align=(:left, :bottom), fontsize=fontsize)

for i in 2:5
    axcpi = Axis(fig[4, i], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
    lines!(axcpi, ticks, matdata[4, i, :], color=:blue, label="CPI")
end

fig
