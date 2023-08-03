import {APIGatewayEvent, APIGatewayProxyResult, Context} from 'aws-lambda';
import {PutObjectCommand, S3Client} from "@aws-sdk/client-s3";

export const handler = async (event: APIGatewayEvent, context: Context): Promise<APIGatewayProxyResult> => {

    // console.log("=============================");
    // console.log(`Event: ${JSON.stringify(event, null, 2)}`);
    // console.log(`Context: ${JSON.stringify(context, null, 2)}`);
    // console.log("=============================");
    let randomSlug = Math.random().toString(36).slice(2, 7);

    // ============================================================================

    const client = new S3Client({});

    const main = async () => {
        const command = new PutObjectCommand({
            Bucket: "shorty-prod-storage",
            Key: randomSlug,
            Body: "+",
            WebsiteRedirectLocation: event.makeItShorter
        });

        try {
            const response = await client.send(command);
            console.log(`⛔️ ${JSON.stringify(response, null, 2)}`);
        } catch (err) {
            console.error(err);
        }
    };


    // ============================================================================


    return {
        statusCode: 200,
        body: JSON.stringify({
            urlToShorten: event.makeItShorter,
            urlShortened: "https://shorty-prod-storage.s3.eu-west-1.amazonaws.com/" + randomSlug
        }),
    };
};