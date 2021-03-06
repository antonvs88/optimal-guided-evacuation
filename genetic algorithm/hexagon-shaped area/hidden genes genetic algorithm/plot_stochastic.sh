#!/bin/bash
#SBATCH -n 1
#SBATCH -t 00:10:00
#SBATCH --mem-per-cpu=2000

module load anaconda3
source activate crowd-development

python generation_vs_evactime_stochastic.py $1 $2 $3
