import ballerina/http;
import ballerina/lang.'int;
import ballerina/io;
public function main() {
    worker w1 {
        int w1val = checkpanic calculate("2*3");
        w1val -> w2;
        int w2val = <- w2;
        io:println("[w1] Message from w2: ", w2val);
        w1val ->> w3;
        w2val -> w3;
        checkpanic flush w3;
    }
    worker w2 {
        int w2val = checkpanic calculate("17*5");
        int w1val = <- w1;
        io:println("[w2] Message from w1: ", w1val);
        w1val + w2val -> w1;
    }
    worker w3 {
        int|error w1val = <- w1;
        int|error w2val = <- w1;
        io:println("[w3] Messages from w1: ", w1val, ", ", w2val);
    }
    wait w1;
}function calculate(string expr) returns int|error {
    http:Client httpClient = new ("https://api.mathjs.org");
    var response = check httpClient->get(string `/v4/?expr=${expr}`);
    return check 'int:fromString(check <@untainted> response.getTextPayload());
}
