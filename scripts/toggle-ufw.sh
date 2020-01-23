#!/bin/bash

ipaddr=$(ip route | grep default | awk '{print $3}')
rule="allow out on wlp2s0 to $ipaddr port 8022"

if ufw status | grep 8022 >/dev/null ; then
	ufw default allow outgoing
	ufw delete $rule
else
	ufw default reject outgoing
	ufw $rule
fi
