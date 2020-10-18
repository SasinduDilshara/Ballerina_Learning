import ballerina/io;
import ballerina/http;
public function main() {
    io:println("Worker execution started");

    worker w1 {
        http:Client httpClient = new ("https://api.mathjs.org");
        var response = httpClient->get("/v4/?expr=2*3");
        if response is http:Response {
            io:println("Worker 1 response: ", response.getTextPayload());
        }
    }

    worker w2 {
        http:Client httpClient = new ("https://api.mathjs.org");
        var response = httpClient->get("/v4/?expr=5*7");
        if response is http:Response {
            io:println("Worker 2 response: ", response.getTextPayload());
        }
    }
    worker w3 {
        http:Client httpClient = new ("https://ballerina.io");
        var response = httpClient->get("/swan-lake/learn/by-example/workers.html");
        if response is http:Response {
            io:println("Worker 2 response: ", response.getTextPayload());
        }
    }
    _ = wait {w1, w2,w3};

    io:println("Worker execution finished");
}
