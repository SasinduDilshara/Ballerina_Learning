import ballerina/io;
public function main() {
    byte a = 12;
    io:println(a);

    byte[] arr1 = [5, 24, 56, 243];

    byte[] arr2 = base16 `aeeecdefabcd12345567888822`;

    byte[] arr3 = base64 `aGVsbG8gYmFsbGVyaW5hICEhIQ==`;

    io:println(arr1.length());
    io:println(arr1[1]);
    io:println(arr2.length());
    io:println(arr2[2]);
    io:println(arr3.length());
    io:println(arr3[3]);
    byte[][] arr4 = [[1, 2, 3], [23, 45, 117, 213], [45, 3, 254, 65, 78, 99]];
    io:println(arr4.length());
    io:println(arr4[2].length());
}