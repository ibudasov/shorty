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
            body: JSON.stringify({error: "Sorry, things went wrong"}),
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
    // BEWARE: it is not the bucket URL. It becomes available after the bucket is enabled as a wabsite
    // https://stackoverflow.com/questions/72547533/aws-s3-x-amz-website-redirect-location-not-working
    readonly s3WebsiteUrl = "http://shorty-prod-storage.s3-website-eu-west-1.amazonaws.com/";
    readonly s3BucketName = "shorty-prod-storage";
    readonly s3BucketRegion = "eu-west-1";
    readonly s3Client = new S3Client({region: this.s3BucketRegion});

    public async shorten(shortenURLRequest: ShortenUrlRequest): Promise<string> {
        let shortenedUrlSlug = Math.random().toString(36).slice(2, 10);

        let command = new PutObjectCommand({
            Bucket: this.s3BucketName,
            Key: shortenedUrlSlug,
            // https://docs.aws.amazon.com/AmazonS3/latest/userguide/how-to-page-redirect.html
            WebsiteRedirectLocation: shortenURLRequest.originalUrl
        });

        await this.s3Client.send(command);

        return this.s3WebsiteUrl + shortenedUrlSlug
    }
}
