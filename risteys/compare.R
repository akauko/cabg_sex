library(dplyr)
library(readr)
library(knitr)
library(tidyr)

fileone <- commandArgs(trailingOnly = T)[1]
filetwo <- commandArgs(trailingOnly = T)[2]

if (!file.exists(fileone) || !file.exists(filetwo)) {
	message("Usage: summary.R <file> <file>")
	quit()
}	


dsetone <- readr::read_csv(fileone) %>% mutate(file = "one")
dsettwo <- readr::read_csv(filetwo) %>% mutate(file = "two")

rbind(dsetone, dsettwo) %>%
	filter(is.na(lag_hr)) %>%
	select(prior, outcome, lag_hr, prior_coef, file) %>% 
	mutate(prior_coef = exp(prior_coef),
		prior = strtrim(prior, 15),
		outcome = strtrim(outcome, 15)) %>%
	group_by(file) %>% 
	mutate(grouped_id = row_number()) %>%
	spread(file, prior_coef) %>%
	kable
