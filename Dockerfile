# This dockerfile is for Centaur dotfiles
# VERSION 1.0.0
# Author: Yuchao Shen
# Command format: Instruction [arguments / command] ..

# Base image to use
FROM ubuntu

# Maintainer:
MAINTAINER Yuchao Shen syc2673@gmail.com

# Commands to update the image
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common

# Install 
RUN apt-get update
RUN apt-get install -y wget curl sudo git zsh nvim
RUN sh -c "$(wget https://github.com/shenyuchao/dotfiles/raw/master/install.sh -O -)"

ENV TERM xterm-256color
WORKDIR /root
