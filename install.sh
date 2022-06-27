#!/bin/bash

mv ~/.bashrc ~/.bashrc.original 
mv ~/.bash_prompt ~/.bash_prompt.original 
wget -q https://raw.githubusercontent.com/sudo-Tiz/awesome-.bashrc/master/.bashrc -P ~
wget -q https://raw.githubusercontent.com/sudo-Tiz/awesome-.bashrc/master/.bash_prompt -P ~