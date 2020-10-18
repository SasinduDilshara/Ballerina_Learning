import ballerina/io;
type Person record {
    string name;
    int age;
};
type Employee record {
    string name;
    int age;
    int empNo;
};
type Department record {
    string code;
};
public function main() {
    Employee employee = {name: "Jane Doe", age: 25, empNo: 1};
    Person person = <Person>employee;
    io:println("Person Name: ", person.name);
    io:println("Person Age: ", person.age);

    Employee employeeTwo = <Employee>person;
    io:println("Employee Name: ", employeeTwo.name);
    io:println("Employee Age: ", employeeTwo.age);

    anydata value = 100;
    int i = <int>value;
    io:println("Integer Value: ", i);

    float f = <float>value;
    io:println("Converted Float Value: ", f);

    float|boolean u = <float|boolean>value;
    io:println("Converted Float Value: ", u);

    value = employee;

    Department department = <Department>value;
}