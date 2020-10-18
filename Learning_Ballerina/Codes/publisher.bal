import ballerina/io;
import ballerina/log;
import ballerina/nats;
const string ESCAPE = "!q";

public function main() {
    string message = "";
    string subject = io:readln("Subject : ");

    nats:Connection connection = new ();
    nats:Producer producer = new (connection);
    while (message != ESCAPE) {
        message = io:readln("Message : ");

        nats:Error? result = producer->publish(subject, <@untainted>message);
        if (result is nats:Error) {
            io:println("Error occurred while producing the message.");
        } else {
            io:println("Message published successfully.");
        }
    }

    nats:Error? result = producer.close();
    if (result is nats:Error) {
        log:printError("Error occurred while closing the logical connection",
                       result);
    }

    result = connection.close();
    if (result is nats:Error) {
        log:printError("Error occurred while closing the connection", result);
    }
}
//# To run this sample, navigate to the directory that contains the
//# `.bal` file, and execute the `ballerina run` command below.
//ballerina run publisher.bal
//Subject : demo
//Message : Hello Ballerina!
//GUID m2jS6SLLefK325DWTkkwBh received for the produced message.