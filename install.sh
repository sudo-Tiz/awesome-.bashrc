#!/bin/bash

mv ~/.bashrc ~/.bashrc.original 
mv ~/.bash_prompt ~/.bash_prompt.original 
wget -q https://github.com/sudo-Tiz/awesome-.bashrc/-/raw/main/.bashrc -P ~
wget -q https://github.com/sudo-Tiz/awesome-.bashrc/-/raw/main/.bash_prompt -P ~