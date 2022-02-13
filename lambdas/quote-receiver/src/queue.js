const { SQSClient, SendMessageCommand } = require("@aws-sdk/client-sqs");

const client = new SQSClient({ endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566` })

exports.send = quote =>
    client.send(new SendMessageCommand({
        DelaySeconds: 10,
        MessageBody: quote,
        QueueUrl: process.env.SQS_URL
    }));
