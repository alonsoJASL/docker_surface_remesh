FROM ubuntu:18.04

LABEL maintainer="jsolislemus <j.solislemus@kcl.ac.uk>"

SHELL [ "/bin/bash", "-c"]

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 curl git libgfortran4 libxt6 libgl1-mesa-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /data && mkdir /code && mkdir /tempfiles

RUN git clone --recurse-submodules -j8 https://github.com/alonsoJASL/docker_surface_remesh.git /code

ENV HOME /home/surf_remesh

# install miniconda
ENV MINICONDA_VERSION latest
ENV CONDA_DIR $HOME/miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tempfiles/miniconda.sh
RUN chmod +x /tempfiles/miniconda.sh && \
    /tempfiles/miniconda.sh -b -p $CONDA_DIR

# make non-activate conda commands available
ENV PATH=$CONDA_DIR/bin:$PATH

# make conda activate command available from /bin/bash --login shells
RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.profile

# make conda activate command available from /bin/bash --interative shells
RUN conda init bash

# create a project directory inside user home
ENV PROJECT_DIR $HOME/app
RUN mkdir $PROJECT_DIR
WORKDIR /data

# build the conda environment
ENV ENV_PREFIX $PROJECT_DIR/env
RUN conda update --name base --channel defaults conda

RUN conda create -n pylat python=3.6 -y

RUN conda install -c conda-forge vtk=8.1 -n pylat -y && \
    conda install -c conda-forge numpy -n pylat -y && \
    conda install -c conda-forge scipy -n pylat -y && \
    conda install -c conda-forge networkx -n pylat -y && \
    conda install -c conda-forge numba -n pylat -y && \
    conda install -c conda-forge trimesh -n pylat -y && \
    conda install -c conda-forge matplotlib -n pylat -y && \
    conda clean --all --yes

COPY /code/docker/entrypoint.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/entrypoint.sh

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
