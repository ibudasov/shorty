import {APIGatewayEvent, APIGatewayProxyResult, Context} from 'aws-lambda';
import {PutObjectCommand, S3Client} from "@aws-sdk/client-s3";

export const handler = async (event: APIGatewayEvent, context: Context): Promise<APIGatewayProxyResult> => {
    let shortenUrlRequest = ShortenUrlRequest.createFromAPIGatewayEvent(event)

    try {
        return {
            statusCode: 200,
            body: JSON.stringify({
                urlShortened: await new UrlShortener().shorten(shortenUrlRequest)
            }),
        }
    } catch (err) {
        return {
            statusCode: 500,
            body: JSON.stringify({error: err}),
        }
    }
};

class ShortenUrlRequest {
    originalUrl: string

    static createFromAPIGatewayEvent(event: APIGatewayEvent): ShortenUrlRequest {
        let shortenURKRequest = new ShortenUrlRequest();

        if (event.makeItShorter === undefined) {
            throw new Error('Request body should be like this -- {"makeItShorter": "http://aws.com/"}')
        }

        shortenURKRequest.originalUrl = event.makeItShorter

        return shortenURKRequest
    }
}

class UrlShortener {
    readonly s3Client = new S3Client({region: process.env.AWS_REGION});

    public async shorten(shortenURLRequest: ShortenUrlRequest): Promise<string> {
        let shortenedUrlSlug = Math.random().toString(36).slice(2, 10);
        let command = new PutObjectCommand({
            Bucket: process.env.AWS_S3_BUCKET_NAME,
            Key: shortenedUrlSlug,
            // https://docs.aws.amazon.com/AmazonS3/latest/userguide/how-to-page-redirect.html
            WebsiteRedirectLocation: shortenURLRequest.originalUrl
        });

        await this.s3Client.send(command);

        // https://stackoverflow.com/questions/72547533/aws-s3-x-amz-website-redirect-location-not-working
        return "http://" + process.env.AWS_S3_BUCKET_NAME + ".s3-website-" + process.env.AWS_REGION + ".amazonaws.com/" + shortenedUrlSlug
    }
}
