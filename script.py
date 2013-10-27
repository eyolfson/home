#!/usr/bin/env python
import os

data = [('notmuch/config', '.notmuch-config')]

git_dir = os.path.dirname(os.path.abspath(__file__))
home_dir = os.environ['HOME']

if __name__ == '__main__':
    print('\033[34mRunning script.py...\033[m')
