#!/usr/bin/env bash

# Use libtcmalloc [https://github.com/google/tcmalloc] for better memory management
TCMALLOC="$(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1)"
export LD_PRELOAD="${TCMALLOC}"

# Serve the API and don't shutdown the container
if [ "$SERVE_API_LOCALLY" == "true" ]; then
    echo "[COMFYUI WORKER] Starting ComfyUI"
    python /comfyui/main.py --disable-auto-launch --disable-metadata --listen &
    echo "[COMFYUI WORKER] Starting RunPod handler"
    python -u /rp_handler.py --rp_serve_api --rp_api_host=0.0.0.0
else
    echo "[COMFYUI WORKER]: Starting ComfyUI"
    python /comfyui/main.py --disable-auto-launch --disable-metadata &
    echo "[COMFYUI WORKER]: Starting RunPod handler"
    python -u /rp_handler.py
fi