#!/usr/bin/env bash

# Add Dart to PATH
echo 'PATH="/usr/lib/dart/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Install dependencies!
cd /home/web/app
pub get