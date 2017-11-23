-module(test).
-export([start/0, send1/0, send2/0, send3/0, send4/0]).

-spec start() -> any().
start() ->
    %apns:connect(token, my_first_connection).
    apns:connect(cert, my_first_connection).

-spec send1() -> any().
send1() ->
    Device = <<"b787c7145d8ab0e95b405120b8b5be6fb0f2f4955c847e3b4c94684168536ac4">>,
    Notification = #{aps => #{alert => <<"you have a message">>}},
    apns:push_notification(my_first_connection, Device, Notification).

-spec send2() -> any().
send2() ->
    %%Device = <<"5c503518b35345d659f10c1a0999a011f219c61d5dd53718695c5886">>,
    Device = <<"98cbff6f2ebd5c0f872c735a941d69a9b041957a0ce30c70209895134f85cc2f">>,
    io:format("~p Device", [Device]),
    Notification = #{aps => #{alert => <<"you have a message">>}},
    apns:push_notification(my_first_connection, Device, Notification).

%% langxw
-spec send3() -> any().
send3() ->
    Device = <<"9ddb2fed5c503518b35345d659f10c1a0999a011f219c61d5dd53718695c5886">>,
    io:format("~p Device", [Device]),
    lager:debug("~p Device", [Device]),
    Notification = #{aps => #{alert => <<"you sonhave a message">>, sound => <<"bingbong.aiff">>}},      
    apns:push_notification(my_first_connection, Device, Notification).

-spec send4() -> any().
send4() ->
    Device = <<"9ddb2fed5c503518b35345d659f10c1a0999a011f219c61d5dd53718695c5886">>,
    Alert = <<"you sonhave a message">>,
    cowboy_apns:send(Device, Alert).



