#!/bin/bash
FINAL_GENERATION=60
POPULATION=40
SAMPLES=30
SEEDS="generate_seeds.sh"
INITIALIZATION="initialize.sh"
EVALUATION="genetic_algorithm_stochastic.sh"
COLLECTION="gather_results_stochastic.sh"
PLOT="plot_stochastic.sh"
# Comment these if continuing the metaheuristic
JOBIDX=$(sbatch ${SEEDS} ${POPULATION} ${SAMPLES}) 
JOBID0=$(sbatch --dependency=afterany:${JOBIDX:20:8} ${INITIALIZATION} ${POPULATION} ${SAMPLES})
# If continuing the heuristic, set I correspondingly
I=0
while [ ${I} -le ${FINAL_GENERATION} ]; do
  # If continuing, remember to put the correct value in the if clause below
  if [ ${I} -eq "0" ]
  then
    # Comment line below if continuing, and uncomment the line below that.
    JOBIDA=$(sbatch --dependency=afterany:${JOBID0:20:8} --array=0-299 ${EVALUATION} ${I} 0)
    #JOBIDA=$(sbatch --array=0-299 ${EVALUATION} ${I} 0)
    JOBIDB=$(sbatch --dependency=afterany:${JOBIDA:20:8} --array=0-299 ${EVALUATION} ${I} 1)
    JOBIDC=$(sbatch --dependency=afterany:${JOBIDB:20:8} --array=0-299 ${EVALUATION} ${I} 2)
    JOBIDD=$(sbatch --dependency=afterany:${JOBIDC:20:8} --array=0-299 ${EVALUATION} ${I} 3)
    JOBID=$(sbatch --dependency=afterany:${JOBIDD:20:8} ${COLLECTION} ${JOBIDA:20:8} ${JOBIDB:20:8} ${JOBIDC:20:8} ${JOBIDD:20:8} ${I} ${POPULATION} ${SAMPLES})
  #elif [ ${I} -eq ${FINAL_GENERATION} ]
  #then
  #  JOBIDEND1A=$(sbatch --dependency=afterany:${JOBID:20:8} --array=0-299 ${EVALUATION} ${I} 0)
  #  JOBIDEND1B=$(sbatch --dependency=afterany:${JOBIDEND1A:20:8} --array=0-299 ${EVALUATION} ${I} 1)
  #  JOBIDEND1C=$(sbatch --dependency=afterany:${JOBIDEND1B:20:8} --array=0-299 ${EVALUATION} ${I} 2)
  #  JOBIDEND1D=$(sbatch --dependency=afterany:${JOBIDEND1C:20:8} --array=0-299 ${EVALUATION} ${I} 3)
  #  JOBIDEND2=$(sbatch --dependency=afterany:${JOBIDEND1D:20:8} ${COLLECTION} ${JOBIDEND1A:20:8} ${JOBIDEND1B:20:8} ${JOBIDEND1C:20:8} ${JOBIDEND1D:20:8} ${I} ${POPULATION} ${SAMPLES})
  #  # Run the plotting only for the final round
  #  #JOBIDEND3=$(sbatch --dependency=afterany:${JOBIDEND2:20:8} ${PLOT} ${FINAL_GENERATION} ${POPULATION} ${SAMPLES})
  else
    JOBID2A=$(sbatch --dependency=afterany:${JOBID:20:8} --array=0-299 ${EVALUATION} ${I} 0)
    JOBID2B=$(sbatch --dependency=afterany:${JOBID2A:20:8} --array=0-299 ${EVALUATION} ${I} 1)
    JOBID2C=$(sbatch --dependency=afterany:${JOBID2B:20:8} --array=0-299 ${EVALUATION} ${I} 2)
    JOBID2D=$(sbatch --dependency=afterany:${JOBID2C:20:8} --array=0-299 ${EVALUATION} ${I} 3)
    JOBID=$(sbatch --dependency=afterany:${JOBID2D:20:8} ${COLLECTION} ${JOBID2A:20:8} ${JOBID2B:20:8} ${JOBID2C:20:8} ${JOBID2D:20:8} ${I} ${POPULATION} ${SAMPLES})
  fi
  let I=${I}+1
done
