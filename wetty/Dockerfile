FROM decinho13/nodeubuntu:node

# update system
RUN apt-get update

ARG user=term
ARG passwd=term
ARG uid=2000
ARG gid=2000
ENV USER=$user
ENV PASSWD=$passwd
ENV UID=$uid
ENV GID=$gid
RUN groupadd $USER && \
    useradd --create-home --no-log-init -g $USER $USER && \
    usermod -aG sudo $USER && \
    echo "$PASSWD:$PASSWD" | chpasswd && \
    chsh -s /bin/bash $USER && \
    # Replace 2000 with your user/group id
    usermod  --uid $UID $USER && \
    groupmod --gid $GID $USER


### ROS and Gazebo Installation
# Install other utilities
RUN apt-get update && \
    apt-get install -y vim \
    tmux \
    git

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
    apt-get update && apt-get install -y ros-kinetic-desktop-full && \
    apt-get install -y python-rosinstall && \
    rosdep init

# Setup ROS
USER $USER
RUN rosdep fix-permissions && rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

###Tensorflow Installation
# Install pip
USER root
RUN apt-get install -y wget python3-pip python-dev libgtk2.0-0 unzip libblas-dev liblapack-dev libhdf5-dev && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py

USER root
RUN pip3 install keras==2.2.4 matplotlib pandas scipy h5py testresources scikit-learn tensorflow

ADD . /app
WORKDIR /app

ENV WETTY_PORT=3000

RUN apt-get install bash openssh-client openssh-server python make g++ procps -y \
    && npm install

EXPOSE ${WETTY_PORT}

EXPOSE 8888

EXPOSE 22

USER root

CMD ["bin/entrypoint.sh"]
