# Load necessary libraries
library(data.table)
library(plm)  # For fixed effects models

# Load the data
data <- fread("ECON_418-518_Exam_3_Data.csv")

# Create indicator columns
data[, `:=` (is_nov = time_period == "Nov", is_nj = state == 1)]

# Calculate mean total employment for each group
mean_emp <- data[, .(mean_total_emp = mean(total_emp)), by = .(is_nj, is_nov)]
print(mean_emp)

# (iii) Difference-in-Differences calculation without lm()
mean_nj_nov <- mean_emp[is_nj == 1 & is_nov == TRUE, mean_total_emp]
mean_nj_feb <- mean_emp[is_nj == 1 & is_nov == FALSE, mean_total_emp]
mean_pa_nov <- mean_emp[is_nj == 0 & is_nov == TRUE, mean_total_emp]
mean_pa_feb <- mean_emp[is_nj == 0 & is_nov == FALSE, mean_total_emp]

diff_nj <- mean_nj_nov - mean_nj_feb
diff_pa <- mean_pa_nov - mean_pa_feb
did_effect <- diff_nj - diff_pa

cat("\nDifference-in-Differences Calculation (Without lm):\n")
cat("  NJ (Nov - Feb):", diff_nj, "\n")
cat("  PA (Nov - Feb):", diff_pa, "\n")
cat("  DiD Effect:", did_effect, "\n")

# (iv) Using lm() for DiD
model_did <- lm(total_emp ~ is_nj * is_nov, data = data)
summary_did <- summary(model_did)

# Adjust interaction term name to match the model's output
interaction_name <- "is_njTRUE:is_novTRUE"

# Check if the interaction term exists and extract the coefficients
if (interaction_name %in% rownames(summary_did$coefficients)) {
  did_coeff <- coef(summary_did)[interaction_name, "Estimate"]
  did_se <- coef(summary_did)[interaction_name, "Std. Error"]
  
  # Calculate confidence intervals
  ci_lower <- did_coeff - 1.96 * did_se
  ci_upper <- did_coeff + 1.96 * did_se
  
  cat("\nRegression Model Without Fixed Effects:\n")
  cat("  Estimate (DiD):", did_coeff, "\n")
  cat("  Standard Error:", did_se, "\n")
  cat("  95% CI: [", ci_lower, ", ", ci_upper, "]\n")
} else {
  cat("\nInteraction term not found in the regression model.\n")
}

# (vii) Add fixed effects using plm
plm_model <- plm(total_emp ~ is_nj * is_nov, data = data, index = "restaurant_id", model = "within")
summary_plm <- summary(plm_model)

# Extract interaction term from plm
did_coeff_fe <- summary_plm$coefficients["is_njTRUE:is_novTRUE", "Estimate"]
did_se_fe <- summary_plm$coefficients["is_njTRUE:is_novTRUE", "Std. Error"]
ci_lower_fe <- did_coeff_fe - 1.96 * did_se_fe
ci_upper_fe <- did_coeff_fe + 1.96 * did_se_fe

cat("\nRegression Model With Fixed Effects:\n")
cat("  Estimate (DiD):", did_coeff_fe, "\n")
cat("  Standard Error:", did_se_fe, "\n")
cat("  95% CI: [", ci_lower_fe, ", ", ci_upper_fe, "]\n")

# Comparison of estimates
cat("\nComparison of Estimates:\n")
cat("  Without Fixed Effects (Estimate):", did_coeff, "\n")
cat("  Without Fixed Effects (95% CI): [", ci_lower, ", ", ci_upper, "]\n")
cat("  With Fixed Effects (Estimate):", did_coeff_fe, "\n")
cat("  With Fixed Effects (95% CI): [", ci_lower_fe, ", ", ci_upper_fe, "]\n")
