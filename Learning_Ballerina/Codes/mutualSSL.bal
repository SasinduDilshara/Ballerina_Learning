import ballerina/config;
import ballerina/http;
import ballerina/log;
http:ListenerConfiguration helloWorldEPConfig = {
    secureSocket: {
        keyStore: {
            path: config:getAsString("b7a.home") +
                  "/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: config:getAsString("b7a.home") +
                  "/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        },

        protocol: {
            name: "TLS",
            versions: ["TLSv1.2", "TLSv1.1"]
        },

        ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"],

        sslVerifyClient: "require"
    }
};

listener http:Listener helloWorldEP = new (9095, helloWorldEPConfig);

@http:ServiceConfig {
    basePath: "/hello"
}
service helloWorld on helloWorldEP {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    resource function sayHello(http:Caller caller, http:Request req) {
        var result = caller->respond("Successful");
        if (result is error) {
            log:printError("Error in responding", result);
        }
    }
}