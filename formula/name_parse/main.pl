:- module(name_parse,[name//3,nonmetal//3,nonmetal_ide//3,charge_check/2,charge_check/3]).
:- set_prolog_flag(double_quotes,chars). 
:- use_module(ionic).
:- use_module(covalent).



%%%%% LOAD ERROR GUIDANCE FROM SUB-MODULES %%%%%

guidance_errcode(ErrCode,Type,Message) :- ionic:guidance_errcode(ErrCode,Type,Message).
guidance_errcode(ErrCode,Type,Message) :- oxyanion:guidance_errcode(ErrCode,Type,Message).
guidance_errcode(ErrCode,Type,Message) :- covalent:guidance_errcode(ErrCode,Type,Message).


%%% Common testing subroutines %%%

nonmetal(Sym,Name,Charge) --> element(Sym,Name), {charge_check(nonmetal,Sym,Charge)}.

nonmetal_ide(Sym,Base,Charge) --> 
	element_base(Sym,Base), 
	({charge_check(nonmetal,Sym,Charge)}; syntax_stop(nonmetal_charge)),
	("ide"; syntax_stop(ide)).

	
/** charge_check(+Type,+Sym,?Charge) is semidet.
 ** charge_check(+Type,+Sym) is semidet.

Tests whether a given symbol is a nonmetal or metal. This is used in parsers to ensure that the user supplies a two nonmetals in the systematic_covalent parser or that a compound consists of a metal and a nonmetal in the ionic parser, for example.

It can also return the charge, because we need it to do the test anyway.

@vague	Type
@arg	Type	The type of element/polyatomic group Sym is supposed to be.	(nonmetal or metal).
@arg	Sym	An element/polyatomic groups symbol/internal formula.	Ag
@arg	Charge	An ionic charge or list of charges for an element or polyatomic ion	-1, [2,3], etc.
@todo	Include a test that verifies that Charge is really a Charge of a polyatomic group.

 */

charge_check(nonmetal,Sym,Charge) :-
        charge(Sym,Charge),
	\+ is_list(Charge),
        Charge =< 0.

charge_check(metal,Sym,Charge) :-
        charge(Sym,Charge),
	!,
        (is_list(Charge); Charge > 0),
        !.

charge_check(Type,Sym) :- charge_check(Type,Sym,_).



%%%%% ERROR GUIDANCE FOR COMMON ROUTINES %%%%%



guidance_errcode(nonmetal,alpha,
	'The highlighted component is not a valid non-metal ide.
	 NOTE: It is possible that the non-metal is missing from the database.'
 ).

guidance_errcode(nonmetal,_,
	'You have entered the highlighted extraneous characters instead of a valid non-metal ide.'
).

guidance_errcode(nonmetal_charge,alpha,
	'You have entered a metal, but it does not make sense here. 
	 Ionic compounds are formed from a metal and a non-metal (or a cation and anion).
 	 Covalent compounds are formed from two non-metals.'
 ).

guidance_errcode(ide,alpha,
	'The non-metal you have entered must end in "ide". This error is easy to fix: just change the junk you have entered (highlighted) to ide!
	 Ionic compounds are in the form: metal non-metalide
	 e.g. sodium chlor<ide>
	 NOTE: If the compound you are entering is ionic, you may have misspelled the name of a negative ion instead.

	 Covalent compounds are in the form non-metal non-metalide
	 e.g hydrogen monox<ide>'
 ).


%%% Pure substances %%%

pure(Sym,Rest,Formula) --> diatomic(Sym,Rest,Formula).
pure(Sym,Rest,Formula) --> single_element(Sym,Rest,Formula).

diatomic([Sym|Rest],Rest,[[Sym,2]]) --> element(Sym,_), {diatomic(Sym)}.
single_element([Sym|Rest],Rest,[[Sym,1]]) --> element(Sym,_).


%%% Combined parser %%%

name(Sym,Rest,Formula) --> retained(Sym,Rest,Formula).
name(Sym,Rest,Formula) --> ionic(Sym,Rest,Formula).
name(Sym,Rest,Formula) --> covalent(Sym,Rest,Formula).
name(Sym,Rest,Formula) --> pure(Sym,Rest,Formula).
name(Sym,Rest,Formula) --> common(Sym,Rest,Formula).


%%%%% ERROR GUIDANCE COMMON TO ALL NAME PARSERS %%%%%



guidance_unparsed([],
	'The program has processed the entire chemical name you have entered but has not found a required component.
	 Please check that you are not missing anything.

 	 The first missing component is '
 ).


guidance_errcode(fail,alpha,
	'The chemical name you are entering (starting with the highlighted component) does not conform to any known naming rules.
	 Please check that you are correctly following one of these rules:

	 1. Ionic: metal non-metalide
	 e.g sodium chloride

	 2. Acid: hydro (if it does not contain oxygen) non-metal suffix acid
	 e.g. hydrosulfuric acid

	 3. Covalent: non-metal non-metalide
	 e.g. dihydrogen monoxide

	 4. Some hydrocarbons: prefix ane/ene/anol
	 e.g. methane

	 NOTE: The program does not support any other naming conventions, yet. Sorry.

 	 If you can get your input to follow one of these conventions, as briefly described, 
	 the program will be able to give you more detailed help.
 ').

guidance_errcode(fail,nil,
	'If you do not enter anything, what are we supposed to do, here?'
).

guidance_errcode(fail,_,
 	'Remove any extraneous characters from highlighted component.'
).

guidance_errcode(none,white,
	'The program only supports compounds in two parts, with support for hydrates. Sorry.
	 Here is a brief summary of the supported rules:

	 1. Ionic: metal non-metalide
	 e.g sodium chloride

	 2. Acid: hydro (if it does not contain oxygen) non-metal suffix acid
	 e.g. hydrosulfuric acid

	 3. Covalent: non-metal non-metalide
	 e.g. dihydrogen monoxide

	 4. Some hydrocarbons: prefix ane/ene/anol
	 e.g. methane').

 guidance_errcode(none,alpha,
 	'Your input would be a valid chemical compound name if it was not for the highlighted characters on the end. 
	 If they are spurious, please remove them.
 	 
 	 Otherwise, you may have to correct your formula, or the program may not support the naming convention you are using.'
 ).

guidance_errcode(_,_,
	'You have probably entered some spurious characters. Remove them or correct them.'
).
