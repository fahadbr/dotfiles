#!/bin/bash

plugin_dir=${HOME}/.tmux/plugins/tpm

if [[ ! -d ${plugin_dir} ]]; then
	git clone https://github.com/tmux-plugins/tpm ${plugin_dir} && \
		${plugin_dir}/bin/install_plugins
fi
