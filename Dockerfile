FROM public.ecr.aws/lambda/python

RUN apt-get update && \
        apt-get install -y \
        unzip \
        curl \
        && apt-get clean \
        && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
        && unzip awscliv2.zip \
        && ./aws/install \
        && rm -rf \
                awscliv2.zip \
        && apt-get -y purge curl \
        && apt-get -y purge unzip

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN python3 -m pip install -r requirements.txt -t .

ADD ./lambda_function.py \
        ./

CMD [ "lambda_function.lambda_handler" ]
