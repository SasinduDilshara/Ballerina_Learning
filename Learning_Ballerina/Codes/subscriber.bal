import ballerina/log;
import ballerina/nats;
nats:Connection connection = new;

listener nats:Listener subscription = new (connection);

@nats:SubscriptionConfig {
    subject: "demo"
}
service demo on subscription {

    resource function onMessage(nats:Message msg, string data) {
        log:printInfo("Received message : " + data);
    }

    resource function onError(nats:Message msg, nats:Error err) {
        log:printError("Error occurred in data binding", err);
    }
}
//# To run this sample, navigate to the directory that contains the
//# `.bal` file, and execute the `ballerina run` command below.
//ballerina run subscriber.bal
//Received message : Hello Ballerina!