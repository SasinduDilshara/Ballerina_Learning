import ballerina/io;
import ballerina/java.jdbc;
import ballerina/sql;function simpleQuery(jdbc:Client jdbcClient) {
    io:println("------ Start Simple Query -------");
    stream<record{}, error> resultStream =
        jdbcClient->query("Select * from Customers");
    error? e = resultStream.forEach(function(record {} result) {
        io:println("Full Customer details: ", result);
        io:println("Customer first name: ", result["FIRSTNAME"]);
        io:println("Customer last name: ", result["LASTNAME"]);
    });
    if (e is error) {
        io:println("ForEach operation on the stream failed!");
        io:println(e);
    }    io:println("------ End Simple Query -------");
}function countRows(jdbc:Client jdbcClient) {
    io:println("------ Start Count Total Rows -------");
    stream<record{}, error> resultStream =
        jdbcClient->query("Select count(*) as total from Customers");
    record {|record {} value;|}|error? result = resultStream.next();
    if (result is record {|record {} value;|}) {
        io:println("Total rows in customer table : ", result.value["TOTAL"]);
    } else if (result is error) {
        io:println("Next operation on the stream failed. ", result);
    } else {
        io:println("Customer table is empty");
    }
    error? e = resultStream.close();    io:println("------ End Count Total Rows -------");
}
type Customer record {|
    int customerId;
    string lastName;
    string firstName;
    int registrationId;
    float creditLimit;
    string country;
|};function typedQuery(jdbc:Client jdbcClient) {
    io:println("------ Start Query With Type Description -------");
    stream<record{}, error> resultStream =
        jdbcClient->query("Select * from Customers", Customer);
    stream<Customer, sql:Error> customerStream =
        <stream<Customer, sql:Error>>resultStream;
    error? e = customerStream.forEach(function(Customer customer) {
        io:println(customer);
    });
    if (e is error) {
        io:println(e);
    }    io:println("------ End Query With Type Description -------");
}
function initializeTable(jdbc:Client jdbcClient) returns sql:Error? {
    sql:ExecutionResult result =
        check jdbcClient->execute("DROP TABLE IF EXISTS Customers");
    result = check jdbcClient->execute("CREATE TABLE IF NOT EXISTS Customers(" +
        "customerId INTEGER NOT NULL IDENTITY, firstName  VARCHAR(300)," +
        "lastName  VARCHAR(300), registrationID INTEGER, creditLimit DOUBLE," +
        "country  VARCHAR(300), PRIMARY KEY (customerId))");
    result = check jdbcClient->execute("INSERT INTO Customers (firstName," +
        "lastName,registrationID,creditLimit,country) VALUES ('Peter', " +
        "'Stuart', 1, 5000.75, 'USA')");
    result = check jdbcClient->execute("INSERT INTO Customers (firstName, " +
        "lastName,registrationID,creditLimit,country) VALUES ('Dan', 'Brown'," +
        "2, 10000, 'UK')");
}public function main() {
    jdbc:Client|sql:Error jdbcClient = new ("jdbc:h2:file:./target/customers",
        "rootUser", "rootPass");    if (jdbcClient is jdbc:Client) {
        sql:Error? err = initializeTable(jdbcClient);
        if (err is sql:Error) {
            io:println("Customer table initialization failed!", err);
        } else {
            simpleQuery(jdbcClient);
            countRows(jdbcClient);
            typedQuery(jdbcClient);            io:println("Queried the database successfully!");
        }
        sql:Error? e = jdbcClient.close();    } else {
        io:println("Initialization failed!!");
        io:println(jdbcClient);
    }
}
