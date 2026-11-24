#!/bin/bash -e
#SBATCH --job-name=gen_ecom_smoke
#SBATCH --account=csedui00041
#SBATCH --partition=csedu
#SBATCH --gres=gpu:rtx_2080_ti:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=logs/gen-%j.out
#SBATCH --error=logs/gen-%j.err

BASE=/vol/csedu-nobackup/course/I00041_informationretrieval/users/$USER
cd "$BASE/total-recall-qa"
mkdir -p logs

source .venv/bin/activate
export HF_HOME="$BASE/hf_cache"
export PYTHONUNBUFFERED=1

echo "Starting generation smoke test on $(hostname) using GPU: $CUDA_VISIBLE_DEVICES"

python c5_task_evaluation/run_evaluation.py \
  --pipeline generation \
  --dataset synthetic_ecommerce \
  --subset test \
  --dataset_file dataset/TRQA/E-Commerce/test/queries_ecommerce_test.jsonl \
  --qrel_file dataset/TRQA/E-Commerce/test/trec_qrels_ecommerce_test.txt \
  --corpus_path corpus_datasets/corpus/corpus_ecommerce_rewritten.jsonl \
  --model Qwen/Qwen2.5-7B-Instruct \
  --generation_method single_retrieval \
  --retriever spladepp \
  --retrieval_results_file ../results/ecommerce_test/retrieval_spladepp_run1/evaluation_results.txt \
  --output_dir ../results/ecommerce_test/gen_qwen_single_spladepp_smoke \
  --num_workers 1 \
  --limit 2 \
  --run single_spladepp_smoke

echo "Job finished successfully."