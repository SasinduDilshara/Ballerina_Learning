import ballerina/io;
import ballerina/http;
import ballerina/lang.'int;public function main() {
    http:Client httpClient = new ("https://api.mathjs.org");
    fork {
        worker w1 returns int {
            var response = checkpanic httpClient->get("/v4/?expr=2*3");
            return checkpanic 'int:fromString(
                checkpanic response.getTextPayload());
        }
        worker w2 returns int {
            var response = checkpanic httpClient->get("/v4/?expr=9*4");
            return checkpanic 'int:fromString(
                checkpanic response.getTextPayload());
        }
    }
    record {int w1; int w2;} result = wait {w1, w2};
    io:println("Result: ", result);
}
