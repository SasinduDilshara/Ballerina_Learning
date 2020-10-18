import ballerina/http;
import ballerina/io;
import ballerina/log;
@http:ServiceConfig {
    basePath: "/hello"
}
service httpService on new http:Listener(9090) {
    @http:ResourceConfig {
        path: "/world",
        methods: ["POST"]
    }
    resource function httpResource(http:Caller caller, http:Request req) {
        http:Response resp = new;
        var payload = req.getTextPayload();
        if (payload is error) {
            log:printError("Error sending message", payload);
            resp.setPayload("Error in payload");
            resp.statusCode = 500;
        } else {
            io:println(payload);
            resp.setPayload(string `HTTP POST received: ${<@untainted>payload}`);
        }

        var err = caller->respond(resp);
        if (err is error) {
            log:printError("Error in responding", err);
        }
    }
    @http:ResourceConfig {
        webSocketUpgrade: {
            upgradePath: "/ws",  //Websocket related Path   :      //localhost:9090/hello/ws
            upgradeService: wsService
        }
    }
    resource function upgrader(http:Caller caller, http:Request req) {

    }
}
service wsService = @http:WebSocketServiceConfig {subProtocols: ["xml, json"]
                                         ,idleTimeoutInSeconds: 20} service {

    resource function onOpen(http:WebSocketCaller caller) {
        io:println("New WebSocket connection: " + caller.getConnectionId());
    }
    resource function onText(http:WebSocketCaller caller, string text) {
        io:println(text);
        var err = caller->pushText(text);
        if (err is error) {
            log:printError("Error sending message", err);
        }
    }
    resource function onIdleTimeout(http:WebSocketCaller caller) {
        io:println("Idle timeout: " + caller.getConnectionId());
    }
};
//# To start the service, navigate to the directory that contains the
//# `.bal` file and use the `ballerina run` command below.
//ballerina run http_to_websocket_upgrade.bal
//# To check the sample, use the Chrome or Firefox JavaScript console and run the commands given below. <br>
//# Change "xml" to another sub protocol to observe the behavior of the WebSocket server.
//# This WebSocket sample is configured to have two endpoints.
//var ws = new WebSocket("ws://localhost:9090/hello/ws", "xml", "my-protocol");
//ws.onmessage = function(frame) {console.log(frame.data)};
//ws.onclose = function(frame) {console.log(frame)};
//# Send messages.
//ws.send("hello world");
//#Use the cURL command  below to call the HTTP resource.
//curl -H "Content-Type: text/plain" -X POST -d 'Hello World!!' 'http://localhost:9090/hello/world'