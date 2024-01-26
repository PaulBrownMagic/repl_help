% Predicates for REPL help and information to aid development.

help(Obj::Predicate/Arity) :-
	% Print the predicate definitions
	guard_object_(Obj),
	guard_predicate_(Obj, Predicate/Arity),
	functor(Term, Predicate, Arity),
	ignore(help_(scope, Obj, Term, Predicate, Arity)),
	ignore(help_(mode, Obj, Term, Predicate, Arity)),
	ignore(help_(info, Obj, Term, Predicate, Arity)).

dir(Obj) :-
	% Print out all the current predicates for an Object
	guard_object_(Obj),
	findall(Predicate, Obj::current_predicate(Predicate), Predicates),
	format('~n~q~n~n', [Predicates]).

% Rest of code is private
%
% % Guards
guard_object_(Obj) :-
	current_object(Obj), !.
guard_object_(Obj) :-
	throw(error(existance_error(object, Obj))).

guard_predicate_(Obj, Predicate) :-
	Obj::current_predicate(Predicate), !.
guard_predicate_(_Obj, Predicate) :-
	throw(error(existance_error(predicate_declaration, Predicate))).

% % Help info printers
help_(scope, Obj, Term, Predicate, Arity) :-
	relaxed_predicate_property_(Obj, Term, scope(Scope)),
	format('~n:- ~w(~q/~d).~n', [Scope, Predicate, Arity]).
help_(mode, Obj, Term, _Predicate, _Arity) :-
	relaxed_predicate_property_(Obj, Term, mode(Args, Resp)),
	format(':- ~q.~n', [mode(Args, Resp)]).
help_(info, Obj, Term, Predicate, Arity) :-
	relaxed_predicate_property_(Obj, Term, info([Info|Infos])),
	format(':- info(~q/~d, [~n', [Predicate, Arity]),
	write_infos_(Infos, Info),
	format(']).~n~n', []).

% % Make predicate_property/2 fail instead of throw
relaxed_predicate_property_(Obj, Term, Property) :-
	catch(
		Obj::predicate_property(Term, Property),
		error(domain_error(predicate_property, _Term), _),
		fail
	).

% % Write out individual info/2 information
write_infos_([], Info) :-
	Info =.. [Functor, Arg],
	format('    ~q is ~q~n', [Functor, Arg]).
write_infos_([Next|Rest], Info) :-
	Info =.. [Functor, Arg],
	format('    ~q is ~q,~n', [Functor, Arg]),
	write_infos_(Rest, Next).
