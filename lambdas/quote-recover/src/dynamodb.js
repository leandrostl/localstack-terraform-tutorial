const { DynamoDBClient, QueryCommand } = require("@aws-sdk/client-dynamodb");
const { Marshaller } = require("@aws/dynamodb-auto-marshaller");

const client = new DynamoDBClient({ endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566` })
const marshaller = new Marshaller();
exports.getQuote = async (author) => {
    const quotes = await client.send(
        new QueryCommand({
            TableName: "Quotes",
            KeyConditionExpression: "author = :a",
            ExpressionAttributeValues: {
                ":a": { S: author }
            }
        }));

    return quotes.Items.map(quote => marshaller.unmarshallItem(quote));
};