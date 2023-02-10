#!/bin/bash

cat ~/.bashrc | egrep "alias ll='ls -l'" || echo "alias ll='ls -l'" >> ~/.bashrc 
cat ~/.bashrc | egrep "alias la='ls -la'" || echo "alias la='ls -la'" >> ~/.bashrc
cat ~/.bashrc | egrep "alias l='ls'" || echo "alias l='ls'" >> ~/.bashrc




