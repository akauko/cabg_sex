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
	filter(is.na(lag_hr)) %>%
	select(prior, outcome, nindivs_prior_outcome, sexprior_pval,prior_coef, prior_pval) %>%
	mutate(prior_coef = exp(prior_coef),
		prior = strtrim(prior, 10),
		outcome = strtrim(outcome, 10)) %>%
	arrange(desc(nindivs_prior_outcome)) %>% 
	kable
