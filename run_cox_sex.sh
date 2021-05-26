#!/bin/bash

source myvenv/bin/activate
export INPUT_PHENOTYPES="data/FINNGEN_PHENOTYPES.txt"
export INPUT_DENSE_FEVENTS="data/dense_first_events.csv"
export INPUT_PAIRS="data/filtered_pairs_CABG.csv"
export INPUT_DEFINITIONS="data/Endpoint_definitions_FINNGEN_ENDPOINTS.tsv"
export INPUT_INFO="data/FINNGEN_MINIMUM_DATA.txt"

export EXCLUDE_MALES=0
export EXCLUDE_FEMALES=0

# OUTPUT FILES
export OUTPUT="results_CABG_$(date +%Y%m%d)_nofemales=${EXCLUDE_FEMALES}_nomales=${EXCLUDE_MALES}.out"
export TIMINGS="results_CABG_$(date +%Y%m%d)_nofemales=${EXCLUDE_FEMALES}_nomales=${EXCLUDE_MALES}.time"
export LOGS="results_CABG_$(date +%Y%m%d)_nofemales=${EXCLUDE_FEMALES}_nomales=${EXCLUDE_MALES}.log"

rm -f $OUTPUT $TIMINGS

python3 pipeline/surv_analysis.py >$LOGS 2>&1

