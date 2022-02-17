const dynamodb = require('./src/dynamodb')
const { okResponse, errorResponse } = require("./src/response");

exports.handler = async (event, context, callback) => {
    const { queryStringParameters } = event;
    try {
        const quotes = await dynamodb.getQuote(queryStringParameters.author);
        const message = okResponse(quotes);
        callback(null, message);
    } catch (error) {
        const message = errorResponse(`Could not retrieve data: ${error}`);
        callback(null, message);
    }
}
