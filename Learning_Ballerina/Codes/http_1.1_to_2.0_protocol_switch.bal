import ballerina/http;
import ballerina/log;
http:Client http2serviceClientEP = new ("http://localhost:7090", {httpVersion: "2.0"});

@http:ServiceConfig {
    basePath: "/http11Service"
}
service http11Service on new http:Listener(9090) {
    @http:ResourceConfig {
        path: "/"
    }
    resource function http11Resource(http:Caller caller,
                                     http:Request clientRequest) {
        var clientResponse = http2serviceClientEP->forward("/http2service",
                                                        clientRequest);

        http:Response response = new;
        if (clientResponse is http:Response) {
            response = clientResponse;
        } else {
            response.statusCode = 500;
            response.setPayload(<string>clientResponse.detail()?.message);
        }

        var result = caller->respond(response);
        if (result is error) {
           log:printError("Error occurred while sending the response",
               err = result);
        }

    }
}
listener http:Listener http2serviceEP = new (7090,
    config = {httpVersion: "2.0"});

@http:ServiceConfig {
    basePath: "/http2service"
}
service http2service on http2serviceEP {
    @http:ResourceConfig {
        path: "/"
    }
    resource function http2Resource(http:Caller caller,
                                    http:Request clientRequest) {
        http:Response response = new;
        json msg = {"response": {"message": "response from http2 service"}};
        response.setPayload(msg);

        var result = caller->respond(response);
        if (result is error) {
            log:printError("Error occurred while sending the response",
                err = result);
        }
    }
}

//# To start the services, navigate to the directory that contains the
//# `.bal` file and use the `ballerina run` command below.
//ballerina run http_1.1_to_2.0_protocol_switch.bal
//[ballerina/http] started HTTP/WS listener 0.0.0.0:7090
//[ballerina/http] started HTTP/WS listener 0.0.0.0:9090
//curl http://localhost:9090/http11Service
//{"response":{"message":"response from http2 service"}}