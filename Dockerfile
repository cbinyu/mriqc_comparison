###   Start by creating a "builder"   ###
# We'll compile all needed packages in the builder, and then
# we'll just get only what we need for the actual APP

ARG MRIQC_VERSION=0.15.2
ARG BASE_PYTHON_VERSION=3.7
ARG DEBIAN_VERSION=buster

# Use an official mriqc image as parent image
FROM poldracklab/mriqc:${MRIQC_VERSION} as builder

# Install mriqc_comparison
RUN pip install mriqc_comparison>=1.1
#COPY [".", "/tmp/mriqc_comparison"]
#RUN cd /tmp/mriqc_comparison && \
#    pip install . && \
#    cd / && rm -rf /tmp/mriqc_comparison

# Get rid of unneeded folders:
# (They are not needed for our APP):
ENV PYTHON_LIB_PATH=/usr/local/miniconda/lib/python*/
RUN rm -r /usr/lib/ants \
        /usr/lib/git* \
        /usr/lib/gcc \
        /usr/lib/node_modules \
        /usr/lib/fsl \
        /usr/lib/python3.5 \
        /usr/lib/python2.7 \
        /usr/local/miniconda/pkgs && \
    rm -fr ${PYTHON_LIB_PATH}/site-packages/xgboost \
        ${PYTHON_LIB_PATH}/site-packages/nibabel \
        ${PYTHON_LIB_PATH}/site-packages/sympy \
        ${PYTHON_LIB_PATH}/site-packages/scipy \
        ${PYTHON_LIB_PATH}/site-packages/skimage \
        ${PYTHON_LIB_PATH}/site-packages/statsmodels \
        ${PYTHON_LIB_PATH}/site-packages/notebook \
        ${PYTHON_LIB_PATH}/site-packages/babel \
        ${PYTHON_LIB_PATH}/site-packages/PyQt5 \
        ${PYTHON_LIB_PATH}/site-packages/dipy \
        ${PYTHON_LIB_PATH}/site-packages/sklearn \
        ${PYTHON_LIB_PATH}/site-packages/matplotlib \
        ${PYTHON_LIB_PATH}/site-packages/nipy \
        ${PYTHON_LIB_PATH}/site-packages/sphinx \
        ${PYTHON_LIB_PATH}/site-packages/lxml \
        ${PYTHON_LIB_PATH}/site-packages/networkx \
        ${PYTHON_LIB_PATH}/site-packages/nitime \
        ${PYTHON_LIB_PATH}/site-packages/sqlalchemy \
        ${PYTHON_LIB_PATH}/site-packages/pywt \
        ${PYTHON_LIB_PATH}/site-packages/h5py \
        ${PYTHON_LIB_PATH}/site-packages/nilearn \
        ${PYTHON_LIB_PATH}/site-packages/jedy \
        ${PYTHON_LIB_PATH}/site-packages/pygments \
        ${PYTHON_LIB_PATH}/site-packages/IPython
							
								
#############

###  Now, get a new machine with only the essentials  ###

FROM python:${BASE_PYTHON_VERSION}-slim-${DEBIAN_VERSION} as Application

# This makes the BASE_PYTHON_VERSION available inside this stage
ARG BASE_PYTHON_VERSION
ENV BASE_PYTHON_LIB_PATH=/usr/local/miniconda/lib/python${BASE_PYTHON_VERSION}
ENV APP_PYTHON_LIB_PATH=/usr/local/lib/python${BASE_PYTHON_VERSION}

COPY --from=builder ./${BASE_PYTHON_LIB_PATH}/       ${APP_PYTHON_LIB_PATH}/
COPY --from=builder ./usr/local/bin/           /usr/local/bin/

#ENTRYPOINT ["/bin/bash"]

