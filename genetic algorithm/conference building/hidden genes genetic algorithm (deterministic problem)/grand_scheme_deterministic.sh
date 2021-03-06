#!/bin/bash
# The optimal workflow is to run 1*40=40 separate array jobs.
# To test the algorithm we try different settings.
BATCH_SIZE=1
PARTS=1
SIMULATIONS_PART=300 # usually 40
# Data of one generation
POPULATION=300 # usually 40
SCENARIOS=1
# It should hold BATCH_SIZE*SIMULATIONS_PART*PARTS = POPULATION*SCENARIOS
START_GENERATION=74
END_GENERATION=82
# Bash-files for genetic algorithm
INITIALIZATION="initialize.sh"
EVALUATION="genetic_algorithm_deterministic.sh"
COLLECTION="gather_results_deterministic.sh"
PLOT="plot_deterministic.sh"
# Check that the code below is correct, when you change PARTS
I=${START_GENERATION}
while [ ${I} -le ${END_GENERATION} ]; do
  if [ ${I} -eq ${START_GENERATION} ]
  then
    if [ ${I} -eq "0" ]
    then
      #JOBID0=$(sbatch ${INITIALIZATION} ${POPULATION} ${SCENARIOS})
      JOBIDA=$(sbatch --array=0-$((${SIMULATIONS_PART}-1)) ${EVALUATION} ${I})
      #JOBIDA=$(sbatch --dependency=afterany:${JOBID0:20:8} --array=0-$((${SIMULATIONS_PART}-1)) ${EVALUATION} ${I})
      JOBID=$(sbatch --dependency=afterany:${JOBIDA:20:8} ${COLLECTION} ${JOBIDA:20:8} ${I} ${POPULATION})
    else
      JOBIDA=$(sbatch --array=0-$((${SIMULATIONS_PART}-1)) ${EVALUATION} ${I})
      JOBID=$(sbatch --dependency=afterany:${JOBIDA:20:8} ${COLLECTION} ${JOBIDA:20:8} ${I} ${POPULATION})
    fi
  else
    JOBID2A=$(sbatch --dependency=afterany:${JOBID:20:8} --array=0-$((${SIMULATIONS_PART}-1)) ${EVALUATION} ${I})
    JOBID=$(sbatch --dependency=afterany:${JOBID2A:20:8} ${COLLECTION} ${JOBIDA:20:8} ${I} ${POPULATION})
  fi
  let I=${I}+1
done
~          
