#!/bin/bash

# This is a variant to generate a 32char long string which can then be used as seed

echo "Your seed is $(openssl rand -base64 24)";