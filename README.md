# REPL Help

A couple of utility tools to aid in development by pretty-printing information
to the REPL.

## Loading

``` logtalk
{repl_help(loader)}.
```

## Use

Ensure the JSON library is loaded: `{json(loader)}`.

Find all the predicates for a current object at once:

``` logtalk
?- dir(json).

[generate/2,parse/2].

true.
```

Get information about a predicate:

``` logtalk
?- help(json::generate/2).

:- public(generate/2).
:- mode(generate(+compound,++term),one_or_error).
:- info(generate/2, [
    comment is 'Generates the content using the representation specified in the first argument (``codes(List)``, ``stream(Stream)``, ``file(Path)``, ``chars(List)``, or ``atom(Atom)``) for the term in the second argument. Fails if this term cannot be processed.',
    argnames is ['Sink','Term']
]).

true.

```

If you try to get information about an object or predicate that does not exist
an error will be thrown.
