#!/bin/bash
pid=$(ps -aux | cut -f2 -d" ")
echo "$pid"