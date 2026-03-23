To Clone the Git Repo
======================
 cd $HOME
 git clone https://github.com/betaldavis/polar-semeval-slurm.git
 
Steps to Setup Virtual Environment and Dependencies
===================================================
cd $HOME/polar-semeval-2026
module load python/3.13.7
python3 -m venv <virtual_environment_name>
source <virtual_environment_name>/bin/activate
source <virtual_environment_name>/bin/activate
pip install --upgrade pip
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

To Define, Run & Manage Slurm
=============================
Substitue the newly created <virtual_environment_name> accordinly in the Slurm4Polar.sh, then
sbatch Slurm4Polar.sh
scontrol show job <jobid>

To See How the Slurm Job Progress  
=================================
tail -f logs/finetune-direct-%j.out
tail -f logs/finetune-direct-%j.err

To See the Completed Slurm Job Details
======================================
sacct -j <jobid> -o JobID,JobName,Partition,Account,AllocCPUS,AllocTRES,ReqMem,MaxRSS,Elapsed,State,ExitCode

To Verify the saved model
==========================
ls -la $HOME/polar-semeval-2026/predictions/instruct/final_model/
To Check file sizes
du -sh $HOME/polar-semeval-2026/predictions/instruct/final_model/

PS:-
User may test inference with the above finetuned model as required
