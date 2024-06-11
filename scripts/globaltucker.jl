using DrWatson
@quickactivate "RR-MAR"
using CodecBzip2
using TensorToolbox, CommonFeatures, RData, LinearAlgebra, Statistics

matdata = load(datadir("globaldata.jld2"), "matdata");

r̄ = [4, 5, 4, 5]
maxiters = 500
tucketa = 1e-03
ϵ = 1e-03
pmax = 3

icranks = fullinfocrit(matdata, pmax, r̄; maxiters, tucketa, ϵ)
aic = icranks.aic[1:4]
aicp = icranks.aic[end]
bic = icranks.bic[1:4]
bicp = icranks.bic[end]
hqc = icranks.hqc[1:4]
hqcp = icranks.hqc[end]
@info "AIC selects ranks $aic with $aicp lags."
@info "BIC selects ranks $bic with $bicp lags."
@info "HQ selects ranks $hqc with $hqcp lags."

