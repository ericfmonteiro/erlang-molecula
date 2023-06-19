-module(molecula).
-export([start/0, loop/0, hydrogen/2, oxygen/2, combine/3]).

start() ->
    loop().

hydrogen(Id, Pid) ->
    timer:sleep(rand:uniform(20000) + 10000),
    io:format("Molecule H~w created~n", [Id]),
    Pid ! {hydrogen, Id}.

oxygen(Id, Pid) ->
    timer:sleep(rand:uniform(20000) + 10000),
    io:format("Molecule O~w created~n", [Id]),
    Pid ! {oxygen, Id}.

loop() ->
    Pid = self(),
    PidH = spawn(molecula, hydrogen, [1, Pid]),
    PidH2 = spawn(molecula, hydrogen, [2, Pid]),
    PidO = spawn(molecula, oxygen, [1, Pid]),
    combine(PidH, PidH2, PidO).

combine(PidH, PidH2, PidO) ->
    io:format("Waiting for molecules to be combined...~n"),
    receive
        {hydrogen, H} ->
            io:format("Received hydrogen: H~w from process ~w ~n", [H, PidH]),
            receive
                {hydrogen, H2} ->
                    io:format("Received hydrogen: H~w from process ~w ~n", [H2, PidH2]),
                    receive
                        {oxygen, O1} ->
                            io:format("Received oxygen: O~w from process ~w ~n", [O1, PidO]),
                            io:format("Combination: H~w + H~w + O~w~n~n", [H, H2, O1])
                    end
            end
    end,
    loop().
