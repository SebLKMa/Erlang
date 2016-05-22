%% test1:test() to run all test

-module(test1).

-include_lib("eunit/include/eunit.hrl"). % unit test framework, contains test/0

-import(tree_list,
         [treeToList/1, listToTree/1, tree0/0, tree1/0]).

leaf_test() ->
  ?assertEqual(tree0(), listToTree(treeToList(tree0()))).

leaf_value_test() ->
  ?assertEqual([2,ant], treeToList(tree0())).

leaf_negative_test() ->
  ?assertError(badarg, listToTree([1,ant])).

node_test() ->
  ?assertEqual(tree1(), listToTree(treeToList(tree1()))).

node_value_test() ->
  ?assertEqual([11,8,2,cat,5,2,dog,2,emu,2,fish], treeToList(tree1())).

node_negative_test() ->
  ?assertError(badarg, listToTree([8,6,2,cat,2,dog,emu,fish])).



