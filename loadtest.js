import http from 'k6/http';
import {sleep} from 'k6';

export const options = {
    vus: 1000,
    duration: '10s',
};
export default function () {
    const url = 'https://w9p5l9m8c9.execute-api.eu-west-1.amazonaws.com/prod';
    const payload = JSON.stringify({
        urlToShorten: 'https://bitvavo.com/en',
    });
    const params = {
        headers: {
            'Content-Type': 'application/json',
        },
    };

    http.post(url, payload, params);
}