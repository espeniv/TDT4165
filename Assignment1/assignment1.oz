%Task 1
{Show 'Hello World'}
%{Browse 'Hello World'}


%Task 3a
local X Y=300 Z=30 in
    X = Y * Z 
    {Show X}
end

/*Task 3b
local X Y in
    X = "This is a string"
    thread {System.showInfo Y} end
    Y = X
end
I believe showInfo is able to print Y before it is assigned because the function is executed in a thread,
which waits for Y to be assigned a value after the thread is created(?).
I think this can be useful when prioritizing "tasks", or for achieveing concurrency in a program. 
The statement Y = X should assign Y the same value as X, i do however believe that the lecture mentioned that
it does not simply make Y point to the same location in memory as X, as with many other programming languages,
but rather fully copies the value.*/


%Task 4a
local Max in
    fun {Max Number1 Number2}
        if Number1 > Number2 then
            Number1
        else
            Number2
        end
    end
    {Show {Max 5 7}}
end

%Task 4b
local PrintGreater in
    proc {PrintGreater Number1 Number2}
        if Number1 > Number2 then
            {Show Number1}
        else
            {Show Number2}
        end
    end
    {PrintGreater 101 100}
end


%Task 5
local Circle Pi=355.0/113.0 in
    proc {Circle R} A D C in
        A = Pi * R * R
        D = 2.0 * R
        C = Pi * D
        {Show A}
        {Show D}
        {Show C}
    end
    {Circle 1.0}
end


%Task 6
declare
fun {Factorial N}
    if N == 0 then
        1
    else
        N * {Factorial N-1}
    end
end
{Show {Factorial 4}}


%Task 7a
declare
fun {Length List}
    case List of Head|Tail then
        1 + {Length Tail}
    else
        0
    end
end
{Show{Length [1 2 3 4 5 10]}}

%Task 7b
declare
fun {Take List Count}
    if{Length List} < Count then
        List
    else
        case List of Head|Tail then
            if Count > 0 then
                Head|{Take Tail Count-1}
            else
                nil
            end
        end
    end
end
{Show{Take [1 2 3 4 5] 2}}

%Task 7c
declare
fun {Drop List Count}
    if{Length List} < Count then
        nil
    else
        case List of Head|Tail then
            if Count > 1 then
                {Drop Tail Count-1}
            else
                Tail
            end
        end
    end
end
{Show {Drop [1 2 3 4 5] 3}}
{Show {Drop [1 2 3 4 5] 6}}

%Task 7d
declare
fun {Append List1 List2}
    case List1 of Head|Tail then
        Head|{Append Tail List2}
    else
        List2
    end
end
{Show {Append [1 2] [3]}}

%Task 7e
declare
fun {Member List Element}
    case List of Head|Tail then
        if Head == Element then
            true
        else
            {Member Tail Element}
        end
    else
        false
    end
end
{Show {Member [1 2 3] 2}}
{Show {Member [1 2 3] 4}}

%Task 7f
declare
fun {Position List Element} Index=0 in
    case List of Head|Tail then
        if Head == Element then
            1
        else
            1 + {Position Tail Element}
        end
    end
end
{Show {Position [1 2 'X' 4 5] 'X'}}

%All functions kept in this file for delivery purposes


%Task 8a
declare
fun {Push List Element}
    case List of Head|Tail then
        Element|Head|Tail
    else
        nil
    end
end
{Show {Push [1 2 3] 4}}

%Task 8b
declare
fun {Peek List}
    case List of Head|Tail then
        Head
    else
        nil
    end
end

{Show {Peek [1 2 3]}}
{Show {Peek [2]}}
{Show {Peek nil}}

%Task 8c
declare
fun {Pop List}
    case List of Head|Tail then
        Tail
    end
end
{Show {Pop [1 2 3 4]}}