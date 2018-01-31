-module(mafiapp_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([init_per_suite/1, end_per_suite/1, all/0]).
-export([add_service_between_friends/1, find_friend_by_name/1]).


all() -> [add_service_between_friends, find_friend_by_name].

init_per_suite(Config) ->
  DatabaseDir = ?config(db_dir, Config),
  application:set_env(mnesia, dir, DatabaseDir),
  mafiapp:install([node()]),
  application:start(mnesia),
  application:start(mafiapp),
  Config.

end_per_suite(_Config) ->
  application:stop(mnesia),
  ok.

add_service_between_friends(_Config) ->
  ok = mafiapp:add_friend("Don Corleone", [], [boss], boss),
  ok = mafiapp:add_friend("Roman Telichkin", [{email, "job@telichk.in"}], [python, javascript, elixir], programming),
  ok = mafiapp:add_service("Roman Telichkin", "Don Corleone", {31, 01, 2018}, "Wrote this program"),

  {error, unknown_friend} = mafiapp:add_service("Name1", "Name2", {01, 01, 1970}, "Description").

find_friend_by_name(_Config) ->
  Name = "DHH",
  ContactList = [],
  InfoList = [storytelling, ruby, basecamp],
  Expertise = entrepreneur,

  ok = mafiapp:add_friend(Name, ContactList, InfoList, Expertise),

  {Name, ContactList, InfoList, Expertise, _Services} = mafiapp:find_friend_by_name(Name),

  UnknownFriend = make_ref(),
  undefined = mafiapp:find_friend_by_name(UnknownFriend).
