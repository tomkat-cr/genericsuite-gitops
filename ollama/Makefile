# .DEFAULT_GOAL := local
.PHONY: help ollama_run ollama_stop ollama_install ollama_update ollama_open ollama_close open_ollama_port_to_lan stable_diffusion_run stable_diffusion_install watch_gpu webui_run webui_stop webui_install webui_update webui_update_watchtower webui_open webui_close
SHELL := /bin/bash

# General Commands
help:
	cat Makefile

# Ollama commands: run|stop|install|update|open|close|open_ollama_port_to_lan

ollama_run:
	bash run_ollama.sh run

ollama_stop:
	bash run_ollama.sh stop

ollama_install:
	bash run_ollama.sh install

ollama_update:
	bash run_ollama.sh update

ollama_open:
	bash run_ollama.sh open

ollama_close:
	bash run_ollama.sh close

open_ollama_port_to_lan:
	bash open_ollama_port_to_lan.sh

# Stable Diffusion commands: run|install

stable_diffusion_run:
	bash run_stable_diffusion.sh

stable_diffusion_install:
	bash install_stable_diffusion.sh


# Watch GPU commands: watch_gpu

watch_gpu:
	bash watch_gpu.sh

# Open WebUI commands: run|stop|install|update|update_watchtower|open|close

webui_run:
	bash run_webui.sh run

webui_stop:
	bash run_webui.sh stop

webui_install:
	bash run_webui.sh install

webui_update:
	bash run_webui.sh update

webui_update_watchtower:
	bash run_webui.sh update_watchtower

webui_open:
	bash run_webui.sh open

webui_close:
	bash run_webui.sh close
