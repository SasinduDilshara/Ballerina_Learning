import ballerina/io;
import ballerina/log;
function process(io:ReadableCharacterChannel sc,
                 io:WritableCharacterChannel dc) returns @tainted error? {
    string intermediateCharacterString = " my name is ";
    string greetingText = check sc.read(5);
    string name = check sc.read(15);
    var writeCharResult = check dc.write(greetingText, 0);
    var writeCharResult1 = check dc.write(intermediateCharacterString, 0);
    var writeCharResult2 = check dc.write(name, 1);
    return;
}
function closeRc(io:ReadableCharacterChannel ch) {
    var cr = ch.close();
    if (cr is error) {
        log:printError("Error occurred while closing the channel: ", cr);
    }
}
function closeWc(io:WritableCharacterChannel ch) {
    var cr = ch.close();
    if (cr is error) {
        log:printError("Error occurred while closing the channel: ", cr);
    }
}public function main() returns error? {
    io:ReadableByteChannel readableFieldResult =
                                check io:openReadableFile("sample.txt");
    io:ReadableCharacterChannel sourceChannel =
                                new (readableFieldResult, "UTF-8");
    io:WritableByteChannel writableFileResult =
                check io:openWritableFile("sampleResponse.txt");
    io:WritableCharacterChannel destinationChannel =
                                new (writableFileResult, "UTF-8");
    io:println("Started to process the file.");
    var result = process(sourceChannel, destinationChannel);
    if (result is error) {
        log:printError("error occurred while processing chars ", result);
    } else {
        io:println("File processing complete.");
    }
    closeRc(sourceChannel);
    closeWc(destinationChannel);
}
