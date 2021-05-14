#!/bin/bash
ps -eo cmd,%cpu,%mem  --sort=-%cpu | head -n 4
