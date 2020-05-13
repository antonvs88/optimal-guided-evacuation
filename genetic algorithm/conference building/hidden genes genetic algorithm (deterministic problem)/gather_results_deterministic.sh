#!/bin/bash
#SBATCH -n 1
#SBATCH -t 00:10:00
#SBATCH --mem-per-cpu=2000

module load anaconda3
source activate crowd-development

echo $1
echo $2
echo $3
python selection_deterministic.py $1 $2 $3
#rm *.out
