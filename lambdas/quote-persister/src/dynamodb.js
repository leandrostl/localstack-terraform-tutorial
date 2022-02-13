const { DynamoDBClient, PutItemCommand } = require("@aws-sdk/client-dynamodb");

const client = new DynamoDBClient({ endpoint: `http://${process.env.LOCALSTACK_HOSTNAME}:4566` })

exports.save = ({ author, quote, movie, year }) =>
    client.send(new PutItemCommand({
        TableName: "Quotes",
        Item: {
            "Author": {
                S: author
            },
            "quote": {
                S: quote
            },
            "movie": {
                S: movie
            },
            "year": {
                N: year
            }
        }
    }));