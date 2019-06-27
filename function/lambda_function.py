import boto3
import logging
import sys
import os


# Log level
logger = logging.getLogger(__name__)

if os.environ.get('LOG_LEVEL') is None:
    logger.setLevel(logging.DEBUG)
else:
    logger.setLevel(logging.os.environ['LOG_LEVEL'])


def lambda_handler(event, context):
    # Lambda code goes here
    logger.info("starting")


if __name__ == "__main__":
    event = ''
    context = []
    session = boto3.Session(profile_name='mm', region_name='eu-west-2')

    # Logger
    channel = logging.StreamHandler(sys.stdout)
    channel.setFormatter(logging.Formatter('%(asctime)s\t%(levelname)s\t%(name)s\t%(message)s'))
    logger.addHandler(channel)

    lambda_handler(event, context)