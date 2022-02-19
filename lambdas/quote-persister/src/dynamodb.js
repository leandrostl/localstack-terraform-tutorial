const { DynamoDBClient, BatchWriteItemCommand } = require("@aws-sdk/client-dynamodb");
const { Marshaller } = require("@aws/dynamodb-auto-marshaller");


const client = new DynamoDBClient({ endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566` });
const marshaller = new Marshaller();
exports.save = (quotes) => client.send(new BatchWriteItemCommand({
    RequestItems: {
        "Quotes": quotes
            .map(quote => marshaller.marshallItem(quote))
            .map(item => new Object({ PutRequest: { Item: item } }))
    }
}));