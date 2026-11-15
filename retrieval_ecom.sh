#!/bin/zsh -e
#SBATCH --account=csedui00041
#SBATCH --partition=csedu-prio,csedu
#SBATCH --qos=csedu-small
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=15G
#SBATCH --time=1:00:00
#SBATCH --output=logs/retrieval-%j.out
#SBATCH --error=logs/retrieval-%j.err

BASE=/vol/csedu-nobackup/course/I00041_informationretrieval/users/$USER
SHARED=/vol/csedu-nobackup/course/I00041_informationretrieval/shared/trqa
cd $BASE/total-recall-qa
source .venv/bin/activate

export HF_HOME=$BASE/hf_cache
export PYTHONBUFFERED=1

python c5_task_evaluation/run_evalution.py \
--pipeline retrieval \
--dataset synthetic_ecommerce --subset test \
--dataset_file dataset/TRQA/E-Commerce/test/queries_ecommerce_test.jsonl \
--qrel_file dataset/TRQA/E-Commerce/test/trec_qrels_ecommerce_test.txt \
--retriever spladepp \
--index_dir corpus_datasets/corpus \
--corpus_path $SHARED/data/ecommerce/corpus_ecommerce_rewritten.jsonl \
--retrieval_eval_ks 3 10 100 1000 \
--output_dir $BASE/results/ecommerce_test/retrieval_spladepp_run1 \
--run run1
