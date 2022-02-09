const { SQSClient, SendMessageCommand } = require("@aws-sdk/client-sqs");

const client = new SQSClient({ endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566` })

exports.send = async (input) => {
    console.log("--> Hostname: ", process.env.LOCALSTACK_HOSTNAME);
    const params = {
        DelaySeconds: 10,
        MessageBody: input,
        QueueUrl: process.env.SQS_URL
    };
    
    const command = new SendMessageCommand(params);
    const data = await client.send(command)
    console.log("--> Success, MessageId: ", data.MessageId)
    return data.MessageId
}
