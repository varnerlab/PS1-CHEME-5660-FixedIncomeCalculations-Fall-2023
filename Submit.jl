# include required packages, etc``
include("Include.jl")


function main()::Array{Float64, 2}

    # initialize -
    coupoun_bond_index = 5; # index of the coupon we are interested in CUSIP: 912810TT5 30-Year
    discount_model = DiscreteCompoundingModel(); # discount model bounds are componded discretely semi-annually
    number_of_samples = 3; # number of perturbation samples
    β₁ = 0.8; # lower perturbation bound
    β₂ = 1.2; # upper perturbation bound
    β = range(β₁, stop = β₂, length = number_of_samples) |> collect; # array of perturbation values
    bonds_dataset = MyTreasuryBondsDataSet(); # load the bonds data set
    results_array = zeros(number_of_samples, 3); # initialize the results array

    # build and populate the bond model: this holds the nominal bond data -
    nominal_coupon_bond_model = build(MyUSTreasuryCouponSecurityModel, (
        par = 100, λ = 2, 
        T = bonds_dataset[coupoun_bond_index, Symbol("Security Term")] |> String |> securityterm,
        rate = bonds_dataset[coupoun_bond_index, Symbol("High Yield")], # this is the yield to maturity, i.e., the discount rate
        coupon = bonds_dataset[coupoun_bond_index, Symbol("Interest Rate")], # this is the coupon rate
    )) |> discount_model;

    # nominal price -
    nominal_price = nominal_coupon_bond_model.price;

    # main loop
    for i ∈ eachindex(β)
        
        β_value_outer = β[i];
        copy_of_nominal_coupon_bond_model = deepcopy(nominal_coupon_bond_model);
        copy_of_nominal_coupon_bond_model.coupon = nominal_coupon_bond_model.coupon * β_value_outer;
        
        for j ∈ eachindex(β)

            β_value_inner = β[j];
            copy_of_nominal_coupon_bond_model.rate = nominal_coupon_bond_model.rate * β_value_inner;
            pertubed_price = copy_of_nominal_coupon_bond_model |> discount_model |> x-> x.price;
            results_array[i, j] = (pertubed_price - nominal_price) / nominal_price;
        end
    end

    # return -
    return results_array;
end

# run the main method, store the results in the simulation_results_array -
simulation_results_array = main();
