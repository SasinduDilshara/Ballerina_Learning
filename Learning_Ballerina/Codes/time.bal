import ballerina/io;
import ballerina/time;public function main() returns error? {
    time:Time time = time:currentTime();
    int currentTimeMills = time.time;
    io:println("Current system time in milliseconds: ", currentTimeMills);
io:println("Created Time: ", time:toString(time));
    time:Time timeCreated = check time:createTime(2017, 3, 28, 23, 42, 45,
        554, "America/Panama");
    io:println("Created Time: ", time:toString(timeCreated));
    time:Time t1 = check time:parse("2017-06-26T09:46:22.444-0500",
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    io:println("Parsed Time: ", time:toString(t1));
    string customTimeString = check time:format(time, "yyyy-MM-dd-E");
    io:println("Current system time in custom format: ", customTimeString);
    int year = time:getYear(time);
    io:println("Year: ", year);
    int month = time:getMonth(time);
    io:println("Month: ", month);
    int day = time:getDay(time);
    io:println("Day: ", day);
    int hour = time:getHour(time);
    io:println("Hour: ", hour);
    int minute = time:getMinute(time);
    io:println("Minute: ", minute);
    int second = time:getSecond(time);
    io:println("Second: ", second);
    int milliSecond = time:getMilliSecond(time);
    io:println("Millisecond: ", milliSecond);
    string weekday = time:getWeekday(time);
    io:println("Weekday: ", weekday);
    [year, month, day] = time:getDate(time);
    io:println("Date: ", year, ":", month, ":", day);
    [hour, minute, second, milliSecond] = time:getTime(time);
    io:println("Time: ", hour, ":", minute, ":", second, ":", milliSecond);
    time:Time tmAdd = time:addDuration(time, 1, 1, 0, 0, 0, 1, 0);
    io:println("After adding a duration: ", time:toString(tmAdd));
    time:Time tmSub = time:subtractDuration(time, 1, 1, 0, 0, 0, 1, 0);
    io:println("After subtracting a duration: ", time:toString(tmSub));
    time:Time t2 = check time:createTime(2017, 3, 28, 23, 42, 45, 554,
        "America/Panama");
    io:println("Before converting the time zone: ", time:toString(t2));
    time:Time t3 = check time:toTimeZone(t2, "Asia/Colombo");
    io:println("After converting the time zone: ", time:toString(t3));
}
