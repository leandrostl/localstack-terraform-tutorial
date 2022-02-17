const { DynamoDBClient, PutItemCommand } = require("@aws-sdk/client-dynamodb");
const { Marshaller } = require("@aws/dynamodb-auto-marshaller");


const client = new DynamoDBClient({ endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566` });
const marshaller = new Marshaller();
exports.save = (quote) => client.send(new PutItemCommand({
    TableName: "Quotes",
    Item: marshaller.marshallItem(quote)
}));