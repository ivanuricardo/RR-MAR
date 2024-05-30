using DataFrames, XLSX, CommonFeatures, Statistics, TensorToolbox, LinearAlgebra, PlotlyJS

datamatrix = XLSX.readdata("data/reguib_northcentral.xlsx", "Sheet1!A2:S459")

nodates = Float64.(datamatrix[:, 2:end])

unpermuted = reshape(nodates, (458, 2, 9))
tensordata = permutedims(unpermuted, (2, 3, 1))
matdata = tenmat(tensordata, col=3)

r̄ = [2, 9, 2, 9]
maxiters = 500
tucketa = 1e-03
ϵ = 1e-03
p = 3

# origy, lagy = tlag(tensordata, 1)
#
# tuckerest = tuckerreg(tensordata, [2, 9, 1, 9], tucketa, maxiters, 1, ϵ)

icranks = fullinfocrit(tensordata, p, r̄; maxiters, tucketa, ϵ)
aic = icranks.aic[1:4]
aicp = icranks.aic[end]
bic = icranks.bic[1:4]
bicp = icranks.bic[end]
hqc = icranks.hqc[1:4]
hqcp = icranks.hqc[end]
@info "AIC selects ranks $aic with $aicp lags."
@info "BIC selects ranks $bic with $bicp lags."
@info "AIC selects ranks $hqc with $hqcp lags."
