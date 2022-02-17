const dynamodb = require('./src/dynamodb')

exports.handler = (event) => {
    event.Records.forEach(record => {
        const { body } = record;
        dynamodb.save(JSON.parse(body))
            .then(data => { console.log(`Quote successfully recorded in ${data.ConsumedCapacity?.TableName} table.`); })
            .catch(error => { console.log("Error trying to record quote to database:", error); })
    });
}
