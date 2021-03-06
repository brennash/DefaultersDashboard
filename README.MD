# Introduction
The Tax Defaulters Dashboard is a simple Python Flask application which summarises and displays the various tax judgements and penalties 
over the previous few years by the Tax and Customs department of the Republic of Ireland. Since the data is recorded as PDFs the text 
must be extracted via OCR using the Tesseract library. 


## Setting up GitHub Access
You need to setup the SSH keys to clone down the repo. To do that first you need to generate some SSH keys and share them with GitHub. 

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

## Installation
No data is actually stored by the application, so you first need to download the appropriate datasets from the revenue authorities. To 
speed this task up a bit, there's a BASH script located in the '''bin''' directory called '''download-data.sh''' which should retrieve
the data and place it in the data sub-folder in the project. 

```
	# Install the basics first
	sudo apt-get update
	sudo apt-get install git python-minimal virtualenv ghostscript tesseract-ocr poppler-utils

        # Clone the repository from GitHub
	git clone git@github.com:brennash/DefaultersDashboard.git

	# Go into the repository
        cd DefaultersDashboard

        # Setup your virtual environment
        virtualenv venv
        . venv/bin/activate

        # Install the python libraries needed
        pip install Flask openpyxl unidecode regex requests

        # The PDF reader
        brew install poppler

        # Download the data
        ./bin/download-data.sh

        # Start the dashboard running on port 1798
        ./bin/start-dashboard.sh
```

If you've already downloaded the data, then you only need to run, 

```
	./bin/start-dashboard.sh
```

This will start the dashboard application, parse the data (if available) and then can be access using your web-browser on 

```
	http://localhost:1798
```


### Stopping the application
```
	./bin/stop-dashboard.sh
```

## Operation


# Supporting Libraries
The dashboard relies on a number of supporting JavaScript and CSS libraries, which are included in the 
distribution to speed up deployment. The links to these required libraries are below. 

https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css
https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js
https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js
