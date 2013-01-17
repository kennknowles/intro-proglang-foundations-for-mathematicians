% An introduction to foundations of programming languages for non-logician Mathematicians
% Kenneth Knowles
% 2013

Prologue
========

I have had many conversations with mathematicians
about what it is I and my colleagues actually study,
and it turns out that our way of approaching the
definition of syntax and relations is often quite
alien to mathematicians in more traditional fields.
This is likely because we started as programmers,
computer scientists, or logicians, and have been so
engaged with the material for so long that a huge
number of conventions are taken for granted.

Often the issues are small, like the distinction
between concrete syntax (letters on a page) and
abstract syntax (trees of symbols). Sometime the
issues are classical, such as clearly distinguishing
metavariables from syntax (an issue which I am not prepared to
tackle). And sometimes things are entirely nontrivial
and the flaws are a real oversight by programming
language texts that take for granted results that we
no longer even remember: That recursive definitions of
syntax actually define a language, that a collection
of typing rules actually defines a nontrivial relation,
that $\bot$ must always be considered.

I will progress from the most trivial and quite quickly
get into serious matters. Feel free to skip introductory
sections if their content is familiar to you; it will not
hinder later discussion. If your background is already
in programming languages, this exposition will seem
very curious. Enjoy it. If you background is as a programmer
without any programming language theory, it may seem
lunatic. Enjoy the weirdness that this underlies
every line of code you write.

So, with great thanks to my closest mathematician
friends for inspiring this essay, I embark on an 
explanation of the foundations of programming languages 
that closely resembles what finally ends up written
on napkins in bars the world over.

Syntax
======

_Syntax_ in programming languages is always a tree. When
I refer to "the expression" $4 \times 5$ I always mean this
tree with a central node labeled $\times$ and two children
label $4$ and $5$, respectively.

(TODO: picture)

These expressions can be nested arbitrarily. Here
are drawings of $1 + 2 * 3$ and $(4 + 7) \times 5$.
Note that parentheses do not occur in abstract 
syntax -- they are helpful instructions for how
to construct the tree.

(TODO: pictures)

I will not draw any more trees after this section, 
but let me conclude with one more expression
and a diagram of its syntax tree.

$$
\sum_{n=1}^\infty \frac{1}{n}
$$

(TODO: picture)

Constructing the language of arithmetic expressions
===================================================

The usual way of defining a language is via
a recursive _grammar_ for the syntax. I will
abstain from using a grammar and will instead
directly write the equation for which it stands.

The language (i.e. set) $\mathcal{E}$ of arithmetic expressions built from
natural numbers and, to be clear about what is a made-up
symbol, the operators $\oplus$ and $\otimes$. It must
satisfy this defining equation:

---------------  -----  ----------  --------------------------------------------------------
  $\mathcal{E}$    =                $\mathbb{N}$
                          $\cup$    $\{ e_1 \otimes e_2 \mid e_1, e_2 \in \mathcal{E}\}$
                          $\cup$    $\{ e_1 \oplus e_2 \mid e_1, e_2 \in \mathcal{E}\}$
---------------  -----  ----------  --------------------------------------------------------

Now there is a proof burden that this equation has a solution and that the
solution is unique. To demonstrate it has a solution without digressing into
general theories of when such equations do, I will present a concrete solution in this case.

Define $\mathcal{E}_n$ according to these rules:

-------------------------  -----  ----------  -------------------------------------------------------------
          $\mathcal{E}_0$    =                $\emptyset$
      $\mathcal{E}_{n+1}$    =                $\mathcal{E}_n$
                                    $\cup$    $\mathbb{N}$
                                    $\cup$    $\{ e_1 \otimes e_2 \mid e_1, e_2 \in \mathcal{E}_n\}$
                                    $\cup$    $\{ e_1 \oplus e_2 \mid e_1, e_2 \in \mathcal{E}_n\}$
-------------------------  -----  ----------  -------------------------------------------------------------

Now let $\mathcal{E}$ be the union of these for all $n \in \mathbb{N}$ or, equivalently,
the limit of the series. That this sequence has a limit is yet another proof obligation
and one which I will not pursue. In part because I think the idea of such a limit is
absurd and simply inaccurate language covering up the fact that any particular
discussion we have only discusses terms up to a finite (but arbitrary) depth.

We may also generate the syntax as the least fixed point of the function $\mathcal{F}$, which
is just a re-writing of the above argument to factor out the _generating function_ of the
language (my term? Maybe. Best to only use it among friends).

-------------------------  -----  ----------  ---------------------------------------------------
         $\mathcal{F}(S)$    =                $S$
                                    $\cup$    $\mathbb{N}$
                                    $\cup$    $\{ e_1 \otimes e_2 \mid e_1, e_2 \in S\}$
                                    $\cup$    $\{ e_1 \oplus e_2 \mid e_1, e_2 \in S\}$
--------------------  -----  ----------  ---------------------------------------------------

Now that we have a set of terms built, including such thrillers as .... what do we do with it?
We give it a meaning in one of two ways.

The first way is to provide a meaning function $Nat : \mathcal{E} \rightarrow \mathbb{N}$.
This will look a lot like the identity function, because this language is so simple:

----------------------------------  -----  ----------------
                          $Nat(n)$    =    $n$
                $Nat(m \otimes n)$    =    $m \times n$
                 $Nat(m \oplus n)$    =    $m +\ n$
----------------------------------  -----  ----------------

Now we induce an equivalence relation $\sim$ on $\mathcal{E}$ by pulling
back across $Nat$, identifying all elements in the inverse image
of any natural number.

The reverse method of constructing a meaning for these expressions is by
axiomatizing the relation $\simeq$:

----------------------------  ----------  --------------------------------------------
                $n \oplus 0$   $\simeq$   $n$
            $n \oplus (m+1)$   $\simeq$   $(n+1) \oplus m$
               $n \otimes 0$   $\simeq$   $0$
           $n \otimes (m+1)$   $\simeq$   $n \oplus (n \otimes m)$
----------------------------  ----------  --------------------------------------------

Exactly what constitutes a good axiomatization is a worthy subject of discussion.
It is not necessarily the case that you want to axiomatize to the point where 
$\mathcal{E}/\simeq$ is equivalent to $\mathbb{N}$! In fact, our willingness
to write $Nat$ so straightforwardly was somewhat ill-conceived without these
axioms to say what structure we thought any such function should preserve!


Constructing the $\lambda$-calculus
===================================

The core of all programming language theory is the
$\lambda$-calculus. It is a syntax designed to model
the _abstraction_ of a term into a variable, from which
we can define a function, and the _application_ of
a function to an argument.

To construct the lambda calculus we posit a countably infinite set of variables
$\mathcal{X}$. We could choose $\mathbb{N}$ or the set of string of roman
characters, but since mathematicians always seem to find a name for a new
variable when they need one, let us leave the set abstract.


Now we define the $\lambda$-calculus, $\Lambda$, as the least fixed point of the
following generator function:

-------------------------  -----  ----------  ---------------------------------------------------
         $\mathcal{F}(S)$    =                $S$
                                    $\cup$    $\mathcal{X}$
                                    $\cup$    $\{ \lambda x . e \mid x \in \mathcal{X}, e \in S \}$
                                    $\cup$    $\{ e_1 ~ e_2 \mid e_1, e_2 \in S \}$
--------------------  -----  ----------  ---------------------------------------------------

The last term in the syntax is the application of $e_1$ to $e_2$, a syntax tree that looks like this:

What do we do with a variable? Well, we probably replace it with a value.
This may seem pedantic, but let us establish a notation for this operation
(on syntax)

------------------- ---------  -------------   -----------------  ----------------------
    $[x \mapsto e]$    $:$     $\mathcal{X}$     $\rightarrow$     $\Lambda$
                                   $x$            $\mapsto$        $e$
                                 $y \neq x$       $\mapsto$        $y$
------------------- ---------  -------------   --------------  --------------------

This corresponds syntactically to "grafting" the argument tree in everywhere that
the variable previously occurred.

(TODO: pic)

(I lied about not drawing any more)

So now we have a set that contains terms like (examples)... what can we do with it?

In this case, a suitable carrier for a semantic function was an interesting
question; it is much easier to start with an equational axiomatization.

--------------------------------  ----------  --------------------------------------------
       $(\lambda x . e_1) ~ e_2$   $\simeq$   $[x \mapsto e_2]~e_1$
--------------------------------  ----------  --------------------------------------------

The result of a function application should be considered equivalent to the
body of the function with its variable replaced by the argument.

(TODO: pic)

Now, if we want to find a carrier that preserves this structure, we must consider
the attributes it must enjoy. Traditional it is called $\mathcal{D}$ and let us
call the morphism mapping into it $Fun$.

We need to talk about free variables and how we require a total
function $E$ (the "environment") from free variables to values.

----------------------------------  -----  ----------------------------------------------------
                       $Fun(E, x)$    =    $E(x)$
               $Fun(E, e_1 ~ e_2)$    =    $Fun(E, e_1) ~ Fun(E, e_2)$
            $Fun(E, \lambda x. e)$    =    $f$ such that $f(d) = Fun(E \circ [x \mapsto d], e)$
                                           for all $d \in \mathcal{D}$
----------------------------------  -----  ----------------------------------------------------

Note that the last equation implies that $\mathcal{D} \rightarrow \mathcal{D}$ must be
entirely contained within $\mathcal{D}$. More subtly, the second equation implies an injection
from $\mathcal{D}$ into $\mathcal{D} \rightarrow \mathcal{D}$. So the two must be equal
or at least isomorphic in some suitable sense.

Digression: Higher-Order Abstract Syntax
----------------------------------------

Considering the results of the above section, There is another way to define 
the $\lambda$-calculus by leveraging the function space at the _meta_ level.

-------------------------  -----  ----------  ---------------------------------------------------
         $\mathcal{F}(S)$    =                $S$
                                    $\cup$    $\mathcal{X}$
                                    $\cup$    $\{ \lambda f \mid f \in S \rightarrow S \}$
                                    $\cup$    $\{ e_1 ~ e_2 \mid e_1, e_2 \in S \}$
--------------------  -----  ----------  ---------------------------------------------------

This introduces a whole host of foundational concerns. 

Adding Types (and Categories)
=============================

Things get much more structured when types are included... (typed lambda operators)

Digression: Typed Higher-Order Abstract Syntax
----------------------------------------------

More of the same.

Further Reading
===============

Here are some of my favorite works that connect the
foundations of programming languages with bits from
other fields of mathematics.


 - Proofs and Types
 - Synthetic Topology


