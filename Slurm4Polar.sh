#!/bin/bash
#SBATCH --job-name=polar-finetune-direct
#SBATCH --output=logs/finetune-direct-%j.out
#SBATCH --error=logs/finetune-direct-%j.err
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --gres=gpu:1
#SBATCH --partition=gpu-short

# No module loads needed - using host environment
export PROJECT_DIR="$HOME/polar-semeval-2026"
export VENV_PATH="${PROJECT_DIR}/<virtual_environment_name>"
export LOG_DIR="${PROJECT_DIR}/logs"
export DATE=$(date +"%Y%m%d_%H%M%S")

mkdir -p ${LOG_DIR}

# Start logging
exec > >(tee -a ${LOG_DIR}/direct_job_${SLURM_JOB_ID}_${DATE}.log) 2>&1

echo "========================================="
echo "Job ID: ${SLURM_JOB_ID}"
echo "Node: $(hostname)"
echo "Started: $(date)"
echo "Environment: Direct host execution"
echo "========================================="

# Activate virtual environment
source ${VENV_PATH}/bin/activate

echo "=== Environment Info ==="
which python
python --version
echo ""

echo "=== CUDA Check ==="
nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
python -c "import torch; print(f'PyTorch: {torch.__version__}, CUDA available: {torch.cuda.is_available()}')"
echo ""

echo "=== Package Verification ==="
python -c "import semevalpolar; print('✓ Package semevalpolar is installed')" 2>/dev/null || {
    echo "Package not found, installing..."
    pip install -e .
}
echo ""

echo "=== Starting Training ==="
cd ${PROJECT_DIR}
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512
python -m semevalpolar.finetuning.instruct.finetune

echo "========================================="
echo "Job finished at: $(date)"
echo "========================================="
