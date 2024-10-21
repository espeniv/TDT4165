%Task 7a
declare
fun {Length List}
    case List of Head|Tail then
        1 + {Length Tail}
    else
        0
    end
end

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
%Task 7d
declare
fun {Append List1 List2}
    case List1 of Head|Tail then
        Head|{Append Tail List2}
    else
        List2
    end
end

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

%Task 8a
declare
fun {Push List Element}
    case List of Head|Tail then
        Element|Head|Tail
    else
        nil
    end
end

%Task 8b
declare
fun {Peek List}
    case List of Head|Tail then
        Head
    else
        nil
    end
end

%Task 8c
declare
fun {Pop List}
    case List of Head|Tail then
        Tail
    else
        nil
    end
end