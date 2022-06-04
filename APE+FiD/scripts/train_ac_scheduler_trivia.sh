#!/bin/bash

HOME=$(pwd)

TRIVIA_DATA="${HOME}/data/preprocessed_data/trivia"

## Copy the entire data folder to avoid corrupting the original data files (an issue in Colab)
#TMP_DATA=$(mktemp -d -t data-XXXXXXXXXX)
#cp -r $TRIVIA_DATA/* $TMP_DATA
#echo "Finished copying data from ${TRIVIA_DATA} to ${TMP_DATA}"
#TRIVIA_DATA=$TMP_DATA
##md5sum $TRIVIA_DATA/*

DATA="trivia"
NOW=$(date '+%Y%m%d-%H-%M-%S')
CKPT="${HOME}/checkpoints"

MODEL=$1
SIZE=$2
BSZ=$3
ACC=$4
LR=$5
DISC=$6

N_CTX=$7
BUDGET=$8
COST=$9
TYPE=${10}
EMBED=${11}
HID=${12}
K=5
EXTRA=${@:13}
echo $EXTRA

NAME="acfid-${SIZE}-${DATA}_scheduler_${NOW}"

python3 FiD/train_ac_scheduler.py \
  --model_path $MODEL \
  --train_data_path $TRIVIA_DATA/trivia_dpr_train.json \
  --dev_data_path $TRIVIA_DATA/trivia_dpr_dev.json \
  --dev_data_size 2000 \
  --model_size $SIZE \
  --per_gpu_batch_size $BSZ \
  --gradient_accumulation_steps $ACC \
  --n_context $N_CTX \
  --name "${NAME}" \
  --checkpoint_dir $CKPT \
  --lr $LR \
  --log_freq 10 \
  --eval_freq 100 \
  --save_freq 100 \
  --total_step 5000 \
  --is_master \
  --freeze_fid_params \
  --freeze_has_answer_heads \
  --scheduler_type $TYPE \
  --scheduler_n_context $N_CTX \
  --scheduler_embed_size $EMBED \
  --scheduler_hidden_size $HID \
  --budget $BUDGET \
  --num_passages_retained $K \
  --step_cost $COST \
  --discount $DISC \
  --use_rl_loss \
  $EXTRA
# --fp16
# --checkpointing_encoder

#rm -fr $TRIVIA_DATA
