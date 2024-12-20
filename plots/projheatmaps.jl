using DrWatson
@quickactivate

using CodecBzip2
using TensorToolbox, CommonFeatures, RData, LinearAlgebra, Statistics, Makie, Dates
using CairoMakie

matdata = load(datadir("globaldata.jld2"), "matdata");

maxiter = 500
tucketa = 1e-03
ϵ = 1e-03

tuckest = tuckerreg(matdata, [3, 1, 4, 3]; eta=tucketa, maxiter, p=1, ϵ)

cendata = matdata .- mean(matdata, dims=3)
origy, lagy = tlag(cendata, 1);
predfacs = ttm(ttm(lagy, tuckest.U[3]', 1), tuckest.U[4]', 2)

################################################################################

titlesize = 25
xlabsize = 15
xticksize = 15
ylabsize = 15
yticksize = 15

fig = Figure(backgroundcolor=:transparent, size=(1200, 375));
countries = ["USA", "CAN", "DEU", "FRA", "GBR"]
inds = ["IR", "GDP", "PROD", "CPI"]

ax1 = Axis(fig[1, 1], title="Resp: Indicators", titlesize=titlesize, xticks=(1:length(inds), inds), yticks=(1:length(inds), inds), xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticksize=yticksize, yreversed=true)
ax1.yticks = (1:length(inds), inds)
ax1.xticks = (1:length(inds), inds)

heatmap!(ax1, tuckest.U[1] * tuckest.U[1]', colormap=:PuBu)
hm1 = heatmap(tuckest.U[1] * tuckest.U[1]', colormap=:PuBu);

Colorbar(fig[2, 1], hm1.plot, vertical=false)

ax2 = Axis(fig[1, 2], title="Resp: Countries", xticks=(1:length(countries), countries), yticks=(1:length(countries), countries), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticksize=yticksize, yreversed=true)
ax2.yticks = (1:length(countries), countries)
ax2.xticks = (1:length(countries), countries)

heatmap!(ax2, tuckest.U[2] * tuckest.U[2]', colormap=:PuBu)
hm1 = heatmap(tuckest.U[2] * tuckest.U[2]', colormap=:PuBu);

Colorbar(fig[2, 2], hm1.plot, vertical=false, ticks=[0.18, 0.21, 0.24, 0.27])

ax3 = Axis(fig[1, 3], title="Pred: Indicators", xticks=(1:length(inds), inds), yticks=(1:length(inds), inds), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticksize=yticksize, yreversed=true)
ax3.yticks = (1:length(inds), inds)
ax3.xticks = (1:length(inds), inds)

heatmap!(ax3, tuckest.U[3] * tuckest.U[3]', colormap=:PuBu)
hm4 = heatmap(tuckest.U[3] * tuckest.U[3]', colormap=:PuBu);

Colorbar(fig[2, 3], hm4.plot, vertical=false)

ax4 = Axis(fig[1, 4], title="Pred: Countries", xticks=(1:length(countries), countries), yticks=(1:length(countries), countries), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticksize=yticksize, yreversed=true)
ax4.yticks = (1:length(countries), countries)
ax4.xticks = (1:length(countries), countries)

heatmap!(ax4, tuckest.U[4] * tuckest.U[4]', colormap=:PuBu)
hm3 = heatmap(tuckest.U[4] * tuckest.U[4]', colormap=:PuBu);

Colorbar(fig[2, 4], hm3.plot, vertical=false)

fig
