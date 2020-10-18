import ballerina/http;
import ballerina/log;service sample on new http:Listener(9090) {    @http:ResourceConfig {
        methods: ["GET"],
        path: "/path/{foo}"
    }
    resource function params(http:Caller caller, http:Request req,
                                string foo) {
        var bar = req.getQueryParamValue("bar");
        map<any> pathMParams = req.getMatrixParams("/sample/path");
        var a = <string>pathMParams["a"];
        var b = <string>pathMParams["b"];
        string pathMatrixStr = string `a=${a}, b=${b}`;
        map<any> fooMParams = req.getMatrixParams("/sample/path/" + foo);
        var x = <string>fooMParams["x"];
        var y = <string>fooMParams["y"];
        string fooMatrixStr = string `x=${x}, y=${y}`;
        json matrixJson = {"path": pathMatrixStr, "foo": fooMatrixStr};
        json responseJson = {
            "pathParam": foo,
            "queryParam": bar,
            "matrix": matrixJson
        };
        http:Response res = new;
        res.setJsonPayload(<@untainted>responseJson);
        var result = caller->respond(res);        if (result is error) {
            log:printError("Error when responding", result);
        }
    }
}
