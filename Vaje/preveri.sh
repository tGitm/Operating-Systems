#!/bin/bash
test $(whoami) = root
test $? -eq 0 && last && lastb || echo "nisi super user"