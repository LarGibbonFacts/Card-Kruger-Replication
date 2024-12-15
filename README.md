# Card-Kruger-Replication

This R script performs an econometric analysis to evaluate the impact of a minimum wage increase in New Jersey on employment levels in the fast-food industry, using data from a study by Card and Krueger.

### Key Functions of the Script:

1. **Data Loading and Preparation**:
   - The script loads a dataset containing information on employment levels, restaurant IDs, and state/time indicators.
   - It creates binary variables (`is_nj` and `is_nov`) to indicate whether the observation corresponds to New Jersey and the post-treatment period (November), respectively.

2. **Difference-in-Differences (DiD) Calculation**:
   - The mean employment for each group (state and time period) is calculated.
   - A Difference-in-Differences (DiD) calculation is performed manually by comparing changes in mean employment between New Jersey and Pennsylvania.

3. **Regression Models**:
   - A linear regression model is fitted (`lm`) to estimate the DiD effect without fixed effects, where the interaction term (`is_nj * is_nov`) represents the treatment effect.
   - Confidence intervals for the treatment effect are computed and reported.

4. **Fixed Effects Model**:
   - A fixed-effects regression is implemented using the `plm` package to control for restaurant-specific characteristics.
   - The script extracts and compares the DiD estimate and standard errors from this model to the regression without fixed effects.

5. **Comparison of Results**:
   - The estimates from both the model without fixed effects and the fixed-effects model are compared, highlighting differences in precision.

### Purpose:
This script systematically evaluates the causal impact of the minimum wage increase on employment, with and without accounting for unobserved heterogeneity (fixed effects). It provides insights into the robustness and reliability of the DiD estimate.
