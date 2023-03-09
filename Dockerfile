FROM python:3.7-slim-buster
# 6.4

# RUN apt-get install -y bazel-bootstrap

WORKDIR /opt/ml_api

ARG PIP_EXTRA_INDEX_URL
ENV FLASK_APP=run.py \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    WORKDIR=/opt/ml_api

# Install neural_network_model from local folder
ADD ./packages/neural_network_model ${WORKDIR}/
RUN apt update && apt-get install -y gcc g++ python3-dev && pip install numpy>=1.13.3 scipy && pip install -e ${WORKDIR}

# Install requirements, including from Gemfury
ADD ./packages/ml_api ${WORKDIR}/

RUN pip install -r /opt/ml_api/requirements.txt


# Create the user that will run the app
RUN adduser --disabled-password --gecos '' ml-api-user
RUN chmod +x ${WORKDIR}/run.sh
RUN chown -R ml-api-user:ml-api-user ./

USER ml-api-user

EXPOSE 5000

CMD ["bash", "./run.sh"]