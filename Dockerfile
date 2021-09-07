ARG APP_DIR="/app"

FROM public.ecr.aws/lambda/python

COPY requirements.txt ./

RUN python3 -m pip install -r requirements.txt -t .

ARG APP_DIR

COPY .${APP_DIR}/lambda_function.py ./

CMD [ "lambda_function.lambda_handler" ]