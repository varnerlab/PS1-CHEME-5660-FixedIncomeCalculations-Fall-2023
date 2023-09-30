# PS1-CHEME-5660-FixedIncomeCalculations-Fall-2023
The objective of `PS1` is to familiarize students with computing the prices of Treasury Bills, Notes, and Bonds and to compare simulations of the change in the prices of these instruments with the five theorems proposed by Malkiel:

* [Malkiel, B. G. (1962). Expectations, Bond Prices, and the Term Structure of Interest Rates. The Quarterly Journal of Economics, 76(2), 197–218. https://doi.org/10.2307/1880816](https://www.jstor.org/stable/1880816https://www.jstor.org/stable/1880816)

Malkiel proposed five theorems that govern the price of fixed-income debt securities, e.g., Treasury Bills, Notes, and Bonds, as a function of the duration and yield values. In `PS1`, let's simulate Theorem 5:
> The higher the coupon carried by the bond, the smaller the percentage price fluctuation for a given change in yield

### Team
List the members of your team here.

## Problem Statement
We selected a `T = 30-year` United States Treasury bond that was auctioned off on `08/10/23` and issued on `08/15/2023` that had the following characteristics:
* The `T = 30 year` bond had an interest rate of `0.04125`, a yield of `0.04189` and a price per $100 face value of `98.912672`.

Simulate the price of the bond for the next for $\pm~20\% changes in the coupoun rate and yeild. Does the simulation support Theorem 5?

### Implementation
The implementation of the simulation is in the the `main(...)` function in the `Submit.jl` file. To execute the simulation, Start [Julia]() from the command line (in the directory where the `Submit.jl` file is located):

```zsh
julia --project=.
```

Once the Julia REPL starts, execute the following command:

```julia
include("Submit.jl")
```

Your job is to complete the implementation of the `main(...)` function in the `Submit.jl` file, and analyze the results.