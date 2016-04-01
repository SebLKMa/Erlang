-module(tail_recursion).
-export([sum/1]).

% tail-recursive sum
sum(List) -> sum_accu(List, 0).

% Sum is a accumulator
sum_accu([], Sum) -> Sum;
sum_accu([Head|Tail], Sum) -> sum_accu(Tail, Head+Sum).




