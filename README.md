Self-reported PhD Stipends 
========================================================

This repository contains an analysis of self-reported PhD stipends data from phdstipends.com, available on Kaggle (https://www.kaggle.com/datasets/paultimothymooney/phd-stipends).

Building the Docker Container
================================

To construct the Docker container, use the following command. This builds the Docker image using your current user ID  and a specific group ID, which helps in managing file permissions effectively.
 
```
docker build . --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=1234 -t my_image .
```
 
This command creates a Docker image named `my_image` that is customized to your user and group settings.

Starting the Docker Container
================================

Start the Docker container with this command:
```
docker run --rm -v $(pwd):/home/rstudio/work -p 8788:8787 -it my_image
```

After executing this command, the development environment can be accessed by visiting `http://localhost:8788` in your web browser. When you first run the `docker run` command, a password for the development environment is automatically generated. If you prefer to set your own password, you can do so; otherwise, the system will provide one for you.

What to Look At
===============

There is a report on how the details of the results.

You can run the phony target:
```
make Report.html
```

And this will build the report.


