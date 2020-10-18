import ballerina/config;
import ballerina/http;
import ballerina/log;
http:ListenerConfiguration helloWorldEPConfig = {
    secureSocket: {
        keyStore: {
            path: config:getAsString("b7a.home") +
                  "/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        }
    }
};

listener http:Listener helloWorldEP = new (9095, config = helloWorldEPConfig);

@http:ServiceConfig {
    basePath: "/hello"  // Starting Path
}
service helloWorld on helloWorldEP {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/" //Base path/this_path
    }
    resource function sayHello(http:Caller caller, http:Request req) {
        var result = caller->respond("Hello World!");
        if (result is error) {
            log:printError("Error in responding ", result);
        }
    }

    @http:ResourceConfig {
            methods: ["GET"],
            path: "/a/" //Base path/this_path
        }
        resource function sayAgainHello(http:Caller caller, http:Request req) {
            var result = caller->respond("Hello World!");
            if (result is error) {
                log:printError("Error in responding ", result);
            }
        }
}