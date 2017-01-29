#!/bin/bash
PS=$(ps ax | sed s/^' '*// | grep python | grep App.py | cut -d' ' -f1)
echo "Killing process ID now $PS"
kill $PS
