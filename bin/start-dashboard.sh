#!/bin/bash

python src/App.py & 
APP_PID=$! 
echo "Starting Dashboard at PID $APP_PID"
#kill $APP_PID # Send SIGTER to process.
