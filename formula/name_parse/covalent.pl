:- module(covalent,[covalent//3,sub_general//2]).
:- set_prolog_flag(double_quotes,chars).



%%% Covalent Compounds %%%

covalent([Sym1,Sym2|Rest],Rest,Formula) --> covalent(Formula), {Formula = [[Sym1,_],[Sym2,_]]}.
covalent([Sym1,Sym2,Sym3|Rest],Rest,Formula) --> covalent(Formula), {Formula = [[Sym1,_],[Sym2,_],[Sym3,_]]}.

covalent(Formula) --> alk(Formula).
covalent(Formula) --> alcohol(Formula).

covalent(Formula) --> systematic_covalent(Formula).


%%% Systematic Naming for Covalent %%%

systematic_covalent([[Sym1,Num1],[Sym2,Num2]]) --> 
	covalent_part(nonmetal,Sym1,sub_first,Num1), 
	" ", 
	covalent_part(nonmetal_ide,Sym2,sub_general,Num2) xx covalent_part_2.

covalent_part(SymGoal,Sym,NumGoal,Num) --> 
	{fwd_flag(Num,Hack)}, 
	call(NumGoal,Num,Letter), 
	call(SymGoal,Sym,Matched,_), 
	(
		{double_vowel_test(Letter,Matched)}; 
		fwd_stop(Hack,vowel_required)
	).

covalent_part(SymGoal,Sym,NumGoal,Num) --> 
	{fwd_flag(Num,Hack)}, 
	call(NumGoal,Num,Letter) xx num_prefix, Letter,
       	call(SymGoal,Sym,Matched,_),
	(
		\+ {double_vowel_test(Letter,Matched)}; 
		fwd_stop(Hack,vowel_omit)
	).

%%% Some unfortunately required common routines %%%

fwd_flag(Num,Flag) :- var(Num) -> Flag = yes; Flag = no.

double_vowel_test(Letter,Matched) :-
	Letter = "" -> true;
	Matched = [H|_],
	(H = 'a'; H = 'o').

fwd_stop(Flag,Error) --> {Flag = yes} -> syntax_stop(covalent:Error).

%%% Covalent numbering prefixes %%%

sub_first(Num,Letter) --> num_sub(Num,Letter), !.
/* CORRECTOR: remove if unecessary */
sub_first(Num,_) --> {var(Num)},  ("mono"; "mon"), syntax_stop(covalent:corrector_first_no_mono), !.
sub_first(1,"") --> "", !.

sub_general(Num,Letter) --> num_sub(Num,Letter).
sub_general(1,"o") --> "mon".
%! sub_general(Num,_) --> {var(Num)}, "", syntax_stop(corrector_prefix_required).

num_sub(2,[]) --> "di".
num_sub(3,[]) --> "tri".
num_sub(4,"a") --> "tetr".
num_sub(5,"a") --> "pent".
num_sub(6,"a") --> "hex".
num_sub(7,"a") --> "sept".
num_sub(8,"a") --> "oct".
num_sub(9,"a") --> "non".
num_sub(10,"a") --> "dec".


%%% Alkanes, Alkenes and Alcohols %%%

alk([["C",Num],["H",HydroNum]]) --> num_alk(Num), alk_type(Num,HydroNum) xx unknown_organic.

alk_type(Num,HydroNum) -->  "ane",
	{
	HydroNum is 2 * Num + 2
	}.


alk_type(Num,HydroNum) --> "ene",
	{
	HydroNum is 2 * Num
	}.

alcohol([["C",Num],["H",HydroNum],["O",1]]) --> num_alk(Num), "anol",
	{
	HydroNum is 2 * Num + 2
	}.


%%% Their numbering system %%%

num_alk(1) --> "meth".
num_alk(2) --> "eth".
num_alk(3) --> "prop".
num_alk(4) --> "but".

num_alk(5) --> "pent".
num_alk(6) --> "hex".
num_alk(7) --> "sept".
num_alk(8) --> "oct".
num_alk(9) --> "non".
num_alk(10) --> "dec".



%%%%% GUIDANCE FOR ERROR CODES %%%%%



guidance_errcode(num_prefix,alpha,
	'The number prefix you have entered is not valid. Therefore, the highlighted component cannot be processed.
	 Using mono for 1 *is* required for the second part of a covalent compound name.
 	 
 	e.g <tetra>chloride, <mon>oxide but not just oxide or <5>oxide'
).

guidance_errcode(covalent_part_2,alpha,
	'The highlighted component cannot be processed because the element name you have entered is not valid.
	 Please re-check the spelling of the non-metal and ensure you are using the -ide ending.'
 ).

guidance_errcode(vowel_required,alpha,
	'You must use the full number prefix, including the last vowel because the name of the element does not start with an a or o.
	 
	e.g. <tetra>chloride, <tri>iodide, not tet*rc*hloride or t*ri*odide.'
).

guidance_errcode(vowel_omit,alpha,
	'You must skip the last vowel of the number prefix, because the name of the element starts with an a or o.

	e.g. <pent>oxide, <mon>oxide, not pent*ao*xide and mon*oo*xide.'
).

/*!
guidance_errcode(peroxide,alpha,
	'The only per- supported by the covalent parser is peroxide, meaning O2. Sorry.'
).
*/

guidance_errcode(corrector_first_no_mono,_,
	'The number prefix mono-, for 1 is *not* used for the first part of the covalent compound name.
	 Simply remove it.

 	 e.g. carbon <mono>xide, not <mono>carbon <mono>xide.'
 ).

guidance_errcode(unknown_organic,alpha,
	'The system does not support the type of organic compound you are entering. Sorry.
	 Hey, at least we figured out you were entering something organic, right!?'
 ).
