library(dplyr)
library(readr)
library(knitr)

file <- commandArgs(trailingOnly = T)[1]

if (!file.exists(file)) {
	message("Usage: summary.R <file>")
	quit()
}	


dset <- readr::read_csv(file)

dset %>% 
	#filter(is.na(lag_hr)) %>%
	select(prior, outcome, lag_hr, nobservations, nevents, nindivs_prior_outcome, sex_coef, sex_pval, sexprior_pval, prior_coef, prior_pval) %>% 
	mutate(prior_coef = exp(prior_coef),
		prior = strtrim(prior, 10),
		outcome = strtrim(outcome, 10)) %>%
	#mutate_if(is.numeric, ~sprintf("%.2f", .x)) %>%
	arrange(prior_pval) %>% 
	kable
