#!/bin/bash
ps  -eo comm,%cpu,%mem --no-headers --sort=-%cpu | head -n 3 | tr -s " " | tr '.' ','