import ballerina/io;
import ballerina/java.jdbc;
import ballerina/sql;function initializeClients() returns sql:Error? {
    jdbc:Client jdbcClient1 = check new ("jdbc:h2:file:./target/sample1");
    io:println("Simple JDBC client created.");
    jdbc:Client jdbcClient2 = check new ("jdbc:h2:file:./target/sample2",
        "rootUser", "rootPass");
    io:println("JDBC client with user/password created.");
    jdbc:Options h2Options = {
        datasourceName: "org.h2.jdbcx.JdbcDataSource",
        properties: {"loginTimeout": "2000"}
    };
    jdbc:Client jdbcClient3 = check new ("jdbc:h2:file:./target/sample3",
        "rootUser", "rootPass", h2Options);
    io:println("JDBC client with database options created.");
    sql:ConnectionPool connPool = {
        maxOpenConnections: 5,
        maxConnectionLifeTimeInSeconds: 2000.0,
        minIdleConnections: 5    };
    jdbc:Client jdbcClient4 = check new ("jdbc:h2:file:./target/sample4",
        "rootUser", "rootPass", h2Options, connPool);
    io:println("JDBC client with connection pool created.");
    jdbc:Client jdbcClient5 = check new (url = "jdbc:h2:file:./target/sample5",
        user = "rootUser", password = "rootPass", options = h2Options,
        connectionPool = connPool);
    jdbc:Client jdbcClient6 = check new (url = "jdbc:h2:file:./target/sample6",
        connectionPool = connPool);
    io:println("JDBC client with optional params created.");
    check jdbcClient1.close();
    check jdbcClient2.close();
    check jdbcClient3.close();
    check jdbcClient4.close();
    check jdbcClient5.close();
    check jdbcClient6.close();}public function main() {
    sql:Error? err = initializeClients();    if (err is sql:Error) {
        io:println("Error occurred, initialization failed!", err);
    } else {
        io:println("Sample executed successfully!");
    }
}
