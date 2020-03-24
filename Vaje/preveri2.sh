#!/bin/bash
test $(whoami) = root && last && lastb || echo "Nisi sudo!"