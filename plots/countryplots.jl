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
xticks = Dates.datetime2unix.(datetimes)
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

axint1 = Axis(fig[1, 1], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axint1, xticks, matdata[1, 1, :], color=:blue, label="IR")
text!(axint1, counposition, abs(maximum(matdata[1, 1, :])) + 0.25, text=countries[1], align=(:right, :top), fontsize=fontsize)
text!(axint1, indposition, -1, text=indicators[1], align=(:left, :bottom), fontsize=fontsize)
axint1.yticks = -0.9:0.45:1.2

for i in 2:5
    axint = Axis(fig[1, i], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
    lines!(axint, xticks, matdata[1, i, :], color=:blue, label="IR")
    text!(axint, counposition, abs(maximum(matdata[1, i, :])) + 0.25, text=countries[i], align=(:right, :top), fontsize=fontsize)
    axint.yticks = -0.9:0.45:1.2
end

################################################################################

axgdp1 = Axis(fig[2, 1], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axgdp1, xticks, matdata[2, 1, :], color=:blue, label="GDP")
text!(axgdp1, indposition, -0.02, text="GDP", align=(:left, :bottom), fontsize=fontsize)
axgdp1.yticks = -0.04:0.01:0.02

axgdp2 = Axis(fig[2, 2], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axgdp2, xticks, matdata[2, 2, :], color=:blue, label="GDP")
axgdp2.yticks = -0.04:0.01:0.02

axgdp3 = Axis(fig[2, 3], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axgdp3, xticks, matdata[2, 3, :], color=:blue, label="GDP")
axgdp3.yticks = -0.04:0.02:0.02

axgdp4 = Axis(fig[2, 4], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axgdp4, xticks, matdata[2, 4, :], color=:blue, label="GDP")
axgdp4.yticks = -0.04:0.01:0.02

axgdp5 = Axis(fig[2, 5], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axgdp5, xticks, matdata[2, 5, :], color=:blue, label="GDP")
axgdp5.yticks = -0.04:0.01:0.02

################################################################################

axprod1 = Axis(fig[3, 1], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axprod1, xticks, matdata[3, 1, :], color=:blue, label="GDP")
text!(axprod1, indposition, -0.07, text="PROD", align=(:left, :bottom), fontsize=fontsize)
axprod1.yticks = -0.15:0.03:0.05

axprod2 = Axis(fig[3, 2], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axprod2, xticks, matdata[3, 2, :], color=:blue, label="GDP")
axprod2.yticks = -0.15:0.03:0.05

axprod3 = Axis(fig[3, 3], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axprod3, xticks, matdata[3, 3, :], color=:blue, label="GDP")
axprod3.yticks = -0.15:0.05:0.05

axprod4 = Axis(fig[3, 4], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axprod4, xticks, matdata[3, 4, :], color=:blue, label="GDP")
axprod4.yticks = -0.15:0.03:0.05

axprod5 = Axis(fig[3, 5], xticks=(xticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axprod5, xticks, matdata[3, 5, :], color=:blue, label="GDP")
axprod5.yticks = -0.15:0.03:0.06

################################################################################

axcpi1 = Axis(fig[4, 1], xticks=(xticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axcpi1, xticks, matdata[4, 1, :], color=:blue, label="CPI")
text!(axcpi1, 8.2e8, 0.007, text="CPI", align=(:left, :bottom), fontsize=fontsize)
axcpi1.yticks = -0.02:0.01:0.04

axcpi2 = Axis(fig[4, 2], xticks=(xticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axcpi2, xticks, matdata[4, 2, :], color=:blue, label="CPI")
axcpi2.yticks = -0.02:0.01:0.04

axcpi3 = Axis(fig[4, 3], xticks=(xticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axcpi3, xticks, matdata[4, 3, :], color=:blue, label="CPI")
axcpi3.yticks = -0.02:0.01:0.04

axcpi4 = Axis(fig[4, 4], xticks=(xticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axcpi4, xticks, matdata[4, 4, :], color=:blue, label="CPI")
axcpi4.yticks = -0.02:0.01:0.04

axcpi5 = Axis(fig[4, 5], xticks=(xticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axcpi5, xticks, matdata[4, 2, :], color=:blue, label="CPI")
axcpi5.yticks = -0.02:0.01:0.04

fig
