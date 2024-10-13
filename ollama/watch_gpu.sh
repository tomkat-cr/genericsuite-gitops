#!/bin/bash
# File: ollama/watch_gpu.sh
# "Watch" GPU Performance in Linux
# 2024-10-13 | CR

# Reference:
# https://ntck.co/ep_401

watch -n 0.5 nvidia-smi
