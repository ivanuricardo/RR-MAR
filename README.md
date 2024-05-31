# Reduced Rank Matrix Autoregressive Models: A Medium $N$ Approach

This code base contains code for the paper "Reduced Rank Autoregressive Models: A Medium $N$ Approach" by Alain Hecq, Ivan Ricardo, and Ines Wilms.
Here you will find replication code for the simulations and most of the tables and figures in the main paper.
This is all possible through the use of the [Julia programming language](https://julialang.org/) and the [DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/) package.
In short, this Github repository is a Julia project that holds all dependencies required to run the scripts in the paper.

To (locally) reproduce this project, do the following:

0. Download this code base.
1. Open a Julia console and do:
   ```
   julia> using Pkg
   julia> Pkg.add("DrWatson") # install globally, for using `quickactivate`
   julia> Pkg.activate("path/to/this/project")
   julia> Pkg.instantiate()
   ```

This will install all necessary packages for you to be able to run the scripts and
everything should work out of the box, including correctly finding local paths.

You may notice that most scripts start with the commands:
```julia
using DrWatson
@quickactivate "RR-MAR"
```
which auto-activate the project and enable local path handling from DrWatson.

## Simulations
> [!WARNING]  
> Running all simulations will take a dreadfully long amount of time!
> We recommend only running one simulation at a time and to parallelize the computations as much as you can.

We include two different scenarios for the simulations in the paper.
Each of these scenarios contains four different simulations, making a total of eight simulation studies.

First, make sure you are in the project root directory.
To run a desired simulation, simply type 
```bash
julia -t 999 simulations/pathtosimulation.jl
```
and replace `999` with however many threads you would like to parallelize over.
Similarly, replace `pathtosimulation.jl` with the desired simulation you would like to run.

For instance, if you would like to run the simulation that uses a $9 \times 2$ matrix valued time series with ranks $(1,1,1,1)$ over 7 threads, simply type
```bash
julia -t 7 simulations/ninebytwo/1111.jl
```
and the simulation will start.

## Empirical Illustration

