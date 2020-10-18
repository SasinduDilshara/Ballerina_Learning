import ballerina/http;

listener http:Listener helloWorldEP = new(9090);

service hello on helloWorldEP {

   resource function sayHello(http:Caller caller, http:Request request) returns error? {
       check caller->respond("Hello World!");
   }
   resource function sayBye(http:Caller caller, http:Request request) returns error? {
          check caller->respond("bye World!");
      }
}

service bye on helloWorldEP {

   resource function sayHello(http:Caller caller, http:Request request) returns error? {
       check caller->respond("bye Hello World!");
   }
   resource function sayBye(http:Caller caller, http:Request request) returns error? {
          check caller->respond("bye bye World!");
      }
}