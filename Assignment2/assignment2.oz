\insert list.oz

%Task 1a
declare fun {Lex Input}
    {String.tokens Input & }
end
%{Show {Lex "1 2 + 3 *"}}


%Task 1b
declare fun {Tokenize Lexemes}
    case Lexemes of Head|Tail then
        case Head of "+" then
            operator(type:plus)|{Tokenize Tail}
        [] "-" then
            operator(type:minus)|{Tokenize Tail}
        [] "*" then
            operator(type:multiply)|{Tokenize Tail}
        [] "/" then
            operator(type:divide)|{Tokenize Tail}
        [] "p" then %Task 1d
            command(type:print)|{Tokenize Tail}
        [] "d" then %Task 1e
            command(type:duplicate)|{Tokenize Tail}
        [] "i" then %Task 1f
            command(type:flip)|{Tokenize Tail}
        [] "c" then %Task 1g
            command(type:clear)|{Tokenize Tail}
        else 
            number(Head)|{Tokenize Tail}
        end
    else
        nil
    end
end
 /*{Show {Tokenize {Lex "1 2 + 3 *"}}} - works, but returns ascii representation of numbers 
 ex. [number([49]) number([50]) operator(type:plus) number([51]) operator(type:multiply)] */


%Task 1c
declare fun {Interpret Tokens}
    fun {InterpretInternal Tokens Stack} 
        case Tokens of Head|Tail then
            case Head of number(N) then
                {InterpretInternal Tail N|Stack}
            [] operator(type:O) then
                case Stack of First|Second|Stacktail then
                    case O of plus then
                        {InterpretInternal Tail First+Second|Stacktail}
                    [] minus then
                        {InterpretInternal Tail First-Second|Stacktail}
                    [] multiply then
                        {InterpretInternal Tail First*Second|Stacktail}
                    [] divide then
                        {InterpretInternal Tail First/Second|Stacktail}
                    end
                else
                    {Show 'Error with applying operator'}
                    nil
                end
            [] command(type:C) then
                case Stack of First|Second|Stacktail then
                    case C of print then %Task 1d
                        {Show Stack}
                        {InterpretInternal Tail First|Second|Stacktail}
                    [] duplicate then %Task 1e
                        {InterpretInternal Tail First|First|Second|Stacktail}
                    [] flip then %Task 1f
                        {InterpretInternal Tail ~First|Second|Stacktail}
                    [] clear then %Task 1g
                        {InterpretInternal Tail nil}
                    end
                end
            end
        else
            Stack
        end
    end
in 
    {InterpretInternal Tokens nil}
end

%{Show {Interpret [number(1) number(2) number(3) operator(type:plus)]}} %Test 1c
%{Show {Interpret [number(1) number(2) number(3) command(type:print) operator(type:plus)]}} %Test 1d
%{Show {Interpret [number(1) number(2) number(3) operator(type:plus) command(type:duplicate)]}} %Test 1e
%{Show {Interpret [number(1) number(2) command(type:flip) number(3) operator(type:plus)]}} %Test 1f
%{Show {Interpret [number(1) number(2) number(3) operator(type:plus) command(type:clear)]}} %Test 1g

/* My implementation of the mdc program works by splitting the string that the Lex function receives. 
This string represents a calculation in postfix/RPN form. The string is split on whitespace, and the result is a list of lexemes. 
The lexemes in this list are converted to tokens, which in this case means either a number, operator or command.
The interpret function iterates through these tokens one by one and operates according to the token type, until there are
no operators or commands left. Tokens of the type number is simply added to the top of the stack, but when a token is a 
operator or command it is executed accordingly on the numbers at the top of the stack. */



%Task 2a and 2b
declare fun {ExpressionTree Tokens}
    fun {ExpressionTreeInternal Tokens ExpressionStack}
        %{Show ExpressionStack}
        case Tokens of Head|Tail then
            case Head of number(N) then
                {ExpressionTreeInternal Tail N|ExpressionStack}
            [] operator(type:O) then
                case ExpressionStack of First|Second|Stacktail then
                    {ExpressionTreeInternal Tail O(First Second)|Stacktail}
                [] _ then
                    nil
                end
            end
        else 
            ExpressionStack.1
        end
    end
in
    {ExpressionTreeInternal Tokens nil}
end

{Show {ExpressionTree [number(3) number(10) number(9) operator(type:multiply) operator(type:minus) number(7) operator(type:plus)]}}


/* Converting the postfix notation into an expression tree works using some of the same methods as the interpretor.
The tokens provided to the function is yet again traversed, and the function acts according to what type of token it encounters.
When the token in question is a number, it is simply added to the expression stack. When the token is an operator, the two
numbers at the top of the stack are used (could probably have been done with the helper functions for stacks created earlier, but
was in this case done using pattern matching) to create a new record with the numbers and the corresponding operator - and this record
is then pushed back onto the stack. When there are no more tokens to process, the finished expression stacks first and only item 
(the expression tree) is returned. */

