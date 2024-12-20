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

###############################################

startdate = Date(1996, 4, 1)
enddate = Date(2019, 12, 31)

quarterlydates = collect(startdate:Dates.Quarter(1):enddate)
datetimes = DateTime.(string.(quarterlydates), "yyyy-mm-dd")
ticks = Dates.datetime2unix.(datetimes)
labels = Dates.format.(datetimes, "Y")
adjlabels = map(x -> x[3:end], labels)  # Takes only last 2 characters of year
adjlabels .= string.("'", adjlabels)

###############################################

titlesize = 25
xlabsize = 20
xticksize = 20
fig = Figure(backgroundcolor=:transparent, size=(1000, 350));
qstep = 30

ax1 = Axis(fig[1, 1], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), title="IR", titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize);
lines!(ax1, ticks, predfacs[4, 1, 1, :], color=:blue, label="Factor 1")
lines!(ax1, ticks, -predfacs[4, 2, 1, :], color=:red, label="Factor 2")
lines!(ax1, ticks, -predfacs[4, 3, 1, :], color=:green, label="Factor 3")

ax2 = Axis(fig[1, 2], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), title="GDP", titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize);
lines!(ax2, ticks, predfacs[1, 1, 1, :], color=:blue, label="Factor 1")
lines!(ax2, ticks, -predfacs[1, 2, 1, :], color=:red, label="Factor 2")
lines!(ax2, ticks, -predfacs[1, 3, 1, :], color=:green, label="Factor 3")

ax3 = Axis(fig[1, 3], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), title="PROD", titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize);
lines!(ax3, ticks, predfacs[3, 1, 1, :], color=:blue, label="Factor 1")
lines!(ax3, ticks, -predfacs[3, 2, 1, :], color=:red, label="Factor 2")
lines!(ax3, ticks, -predfacs[3, 3, 1, :], color=:green, label="Factor 3")

ax4 = Axis(fig[1, 4], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), title="CPI", titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize);
lines!(ax4, ticks, predfacs[2, 1, 1, :], color=:blue, label="Factor 1")
lines!(ax4, ticks, -predfacs[2, 2, 1, :], color=:red, label="Factor 2")
lines!(ax4, ticks, -predfacs[2, 3, 1, :], color=:green, label="Factor 3")

fig[2, :] = Legend(fig, ax1; orientation=:horizontal, halign=:center, valign=:bottom, framevisible=false, labelsize=20)

fig
