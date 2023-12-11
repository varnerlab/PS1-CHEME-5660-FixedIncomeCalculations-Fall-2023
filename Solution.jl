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

    # TODO: main loop. You need to loop over the perturbation values and compute the price of the bond, 
    # store the percentage changes in the price in the results array.
    for i ∈ eachindex(β)

        # crate a copy of the nominal bond model -
        bond_model_copy = deepcopy(nominal_coupon_bond_model);

        # update the coupon rate -
        bond_model_copy.coupon = (nominal_coupon_bond_model.coupon) * β[i];

        for j ∈ eachindex(β)

            # update the yeild -
            bond_model_copy.rate = (nominal_coupon_bond_model.rate) * β[j];

            # compute the price -
            new_price = bond_model_copy |> discount_model |> x-> x.price;

            # compute the percentage change in the price, and store -
            results_array[i,j] = ((new_price - nominal_price) / nominal_price)*100;
        end
    end

    # return -
    return results_array;
end

# run the main method, store the results in the simulation_results_array -
simulation_results_array = main();

# build a pretty table to display the results -
(R,C) = size(simulation_results_array)
pretty_table_data = Array{Any,2}(undef, R, C+1)

# first col holds labels -
for i ∈ 1:R
    if (i == 1)
        pretty_table_data[i,1] = "-20% coupon";
    elseif (i == 3)
        pretty_table_data[i,1] = "+20% coupon";
    else
        pretty_table_data[i,1] = "nominal coupon";
    end
end

for i = 1:R
    for j = 1:C
        pretty_table_data[i,j+1] = simulation_results_array[i,j]
    end
end

header_data = (["", "-20% yield", "nominal yield", "+20% yield"])
pretty_table(pretty_table_data, header=header_data)
