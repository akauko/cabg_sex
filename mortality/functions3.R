
extract_glm <- function(vars, fits, exposure){
  
  lapply(vars, function(var){
    
    fit<-fits[[var]]
    outcome <-  fit$formula[[2]] %>% as.character
    cases <- fit$data %>%
      group_by_at(c(outcome, exposure)) %>%
      summarise(n=n()) %>%
      pivot_wider(names_from = c(eval(exposure),eval(outcome)), values_from = n) %>%
      rename(N_controls ="0_0", n_controls = "0_1", N_cases = "1_0", n_cases = "1_1") %>%
      select(n_cases, N_cases, n_controls, N_controls)
    coefs <- cbind( exp(coef(fit)), exp(confint(fit)), summary(fit)$coefficients[,4] )  %>% 
      `colnames<-`(c("odds", "low", "high", "Pval")) %>%
      as.data.frame() %>%
      subset(rownames(.) == exposure)
    varnames <-  matrix(var, dimnames=list(NULL, "Variable"))
    cbind(varnames, cases, coefs)
    
  }) %>% setNames(vars) %>%
    do.call(rbind,.) %>%
    as_tibble() #%>%
    #mutate(Odds = str_glue("{odds} ({low}-{high})")) %>% 
    #select(Variable, Cases, Controls, Odds, Pval)
  
}

prettyfy_reg_table <- function(mytable){
  
  mytable %>%
    mutate_at(c("odds", "low", "high"), round, 2) %>%
    mutate( Pval = as.character(signif(Pval, 2))) %>%
    mutate(Odds = str_glue("{odds} ({low}-{high})"),
           `n/N cases` = str_glue("{n_cases}/{N_cases}"),
           `n/N controls` = str_glue("{n_controls}/{N_controls}")) %>%
    rename(`P-value` = Pval) %>%
    select(Years, `n/N cases`, `n/N controls`, Odds, `P-value`) 
}


my.kable <- function(mytable){
  
  mytable %>%
    knitr::kable() %>%
    kable_classic() %>%
    row_spec(0,bold=TRUE)
    

}
