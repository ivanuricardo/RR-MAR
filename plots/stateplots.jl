using DrWatson
@quickactivate

using TensorToolbox, CommonFeatures, XLSX, LinearAlgebra, Makie, Dates
using CairoMakie

statedata = XLSX.readdata("data/reguib_northcentral.xlsx", "Sheet1!A2:S459")

start_date = Date(1982, 1, 1)
end_date = Date(2020, 2, 1)

monthly_dates = collect(start_date:Dates.Month(1):end_date)
date_times = DateTime.(string.(monthly_dates), "yyyy-mm-dd")
ticks = Dates.datetime2unix.(date_times)
labels = Dates.format.(date_times, "Y")
adjlabels = map(x -> x[3:end], labels)  # Takes only last 2 characters of year
adjlabels .= string.("'", adjlabels)
nolabels = fill("", length(adjlabels))

titlesize = 25
xlabsize = 13
xticksize = 13
ylabsize = 13
yticksize = 13
fig = Figure(backgroundcolor=:transparent, size=(1200, 350));
qstep = 110
indices = ["CI", "LI"]
states = ["IA", "IL", "IN", "MI", "MN", "ND", "OH", "SD", "WI"]
stateposition = 1.55e9
indposition = 4.3e8

axci1 = Axis(fig[1, 1], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axci1, ticks, statedata[:, (2)], color=:blue, label="CI")
text!(axci1, stateposition, abs(maximum(statedata[:, 2])) + 0.5, text=states[1], align=(:right, :top))
text!(axci1, indposition, -1, text="CI", align=(:left, :bottom))

for i in 2:9
    axci = Axis(fig[1, i], xticks=(ticks[1:qstep:end], nolabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
    lines!(axci, ticks, statedata[:, (2*i)], color=:blue, label="CI")
    text!(axci, stateposition, abs(maximum(statedata[:, 2*i])) + 0.5, text=states[i], align=(:right, :top))
end

axli1 = Axis(fig[2, 1], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
lines!(axli1, ticks, statedata[:, 3], color=:blue, label="LI")
text!(axli1, indposition, -1.8, text="LI", align=(:left, :bottom))

for i in 2:9
    axli = Axis(fig[2, i], xticks=(ticks[1:qstep:end], adjlabels[1:qstep:end]), titlesize=titlesize, xlabelsize=xlabsize, xticklabelsize=xticksize, ylabelsize=ylabsize, yticklabelsize=yticksize)
    lines!(axli, ticks, statedata[:, (2*i+1)], color=:blue, label="LI")
end

fig
