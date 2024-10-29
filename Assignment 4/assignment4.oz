%All function calls are commented out because the assignment relies on threads, resulting in strange print and run orders, remove comment symbol(s) to run individual functions - note that 4a and 4b runs infinitely 

%Task 1a
/* 
local A=10 B=20 C=30 in
    {System.show C}
    thread
        {System.show A}
        {Delay 100}
        {System.show A * 10}
    end
    thread
        {System.show B}
        {Delay 100}
        {System.show B * 10}S
    end
    {System.show C * 100}
end 
*/
%The output after running the code on my machine is 30, 3000, 10, 20, 200, 100 in that order


%Task 1b
/* The code starts out sequentially, and first prints C, it then initializes two threads regarding A and B, but continues sequentially
to the last line, printing C * 100, which i assume is done by the scheduler while the two threads are being created. The threads for A and B are then executed
concurrently, which results in A being printed (the first thread that got started in the sequence), then all of the B-threads code is
excuted before A-thread is finished. I find it weird that this is the order of execution, as both threads have a delay, yet it does not flip-flop
back to A-thread after B's first print. I assume this happens because of the specifics of how  the scheduler is implemented in oz, probably prioritizing finishing
up/waiting for the current thread if all threads have a block/delay. With a different scheduler i believe it would be possible to have a very different result. */


%Task 1c
/* 
local A B C in
    thread
        A = 2
        {System.show A}
    end
    thread
        B = A * 10
        {System.show B}
    end
    C = A + B
    {System.show C}
end 
*/
%The output after running the code on my machine is 2, 20, 22 in that order

%Task 1d
/* The execution of this code is decided by the fact that two of the threads (consider the outer part of the code a seperate thread), is dependent on variables
being assigned in other threads. The thread assigning B is dependant on the first thread that assigns A being finished, and the outer thread is dependant on both
A and B being assigned to be able to calculate C. This results in the current order, and this order of the thread execution can not be changed. (Some scheduling implementation 
could probably force e.g. C = A + B to execute earlier, but it would obviously lead to an error.) */



declare ShowStream Enumerate GenerateOdd ListDivisorsOf ListPrimesUntil LazyEnumerate Primes in
    local List Start End in

        %Provided to print a stream as its being built
        proc {ShowStream List}
            case List of _|Tail then
                {Show List.1}
                thread {ShowStream Tail} end
            else
                skip
            end
        end
        

        %Task 2a
        fun {Enumerate Start End}
            if Start > End then
                nil
            else 
                Start | thread {Enumerate Start+1 End} end
            end
        end
        %{ShowStream {Enumerate 1 5}} 
        %Shows 1, 2, 3, 4, 5, as expected

        
        %Task 2b
        fun {GenerateOdd Start End} Stream in
            thread Stream = {Enumerate Start End} end
            case Stream of H|T then
                if H mod 2 == 1 then
                    %Only add to the result stream if the number is odd
                    H | thread {GenerateOdd Start+1 End} end
                else
                    {GenerateOdd Start+1 End}
                end
            else
                nil
            end
        end
        %{ShowStream {GenerateOdd 1 10}}
        %Output is 1, 3, 5, 7, 9 as expected
        %{ShowStream {GenerateOdd 4 4}}
        %No output, as expected

        
        %Task 2c
        %{Show {Enumerate 1 5}}
        %{Show {GenerateOdd 1 5}}
        /* Output for both of the statements is 1|_<optimized> (occasionally also 1|2|_<optimized>), this is caused by the fact that both of the 
        functions create streams asynchronously, and the streams to be displayed are therefore not finished when we call Show (and in the "eyes" 
        of the program/scheduler the streams may never be, as streams can be infinite). In short, _<optimized> is a placeholder. */

        

        %Task 3a
        fun {ListDivisorsOf Number} EnumStream Result FilterStream in
            %Enum from 1 up to number, for all possible divisors
            thread EnumStream = {Enumerate 1 Number} end
            fun {FilterStream Stream}
                case Stream of H|T then
                    if Number mod H == 0 then
                        %Only add to the result stream if the number is a divisor
                        H | thread {FilterStream T} end
                    else
                        {FilterStream T}
                    end
                else
                    nil
                end
            end
            thread Result = {FilterStream EnumStream} end
            Result
        end
        %{ShowStream {ListDivisorsOf 21}}
        %Output is 1, 3, 7, 21, as expected

        
        %Task 3b
        fun {ListPrimesUntil N} EnumStream Result FilterStream in
            %Primes start at 2, so enum from 2 to N
            thread EnumStream = {Enumerate 2 N} end
            fun {FilterStream Stream}
                case Stream of H|T then
                    %Use the stream from ListDivisorsOf from last task
                    %If the number returns only 1 and itself from the stream result of ListDivisorsOf it is a prime
                    if {ListDivisorsOf H} == 1|H|nil then
                        H | thread {FilterStream T} end
                    else
                        {FilterStream T}
                    end
                else
                    nil
                end
            end
            thread Result = {FilterStream EnumStream} end
            Result
        end
        %{ShowStream {ListPrimesUntil 20}}
        %Output is 2, 3, 5, 7, 11, 13, 17, 19 as expected



        %Task 4a
        fun lazy {LazyEnumerate} LazyEnumerateHelper in
            %Helper function used to track the current number, as outer function takes no arguments
            fun lazy {LazyEnumerateHelper Start}
                Start | thread {LazyEnumerateHelper Start+1} end
            end
            %Always starts at 1 with this implementation
            {LazyEnumerateHelper 1}
        end
        %{ShowStream {LazyEnumerate}}
        %Generates incrementing numbers infinitely
        

        %Task 4b
        fun lazy {Primes} EnumStream Result FilterStream in
            %Use LazyEnumerate to generate numbers lazily
            thread EnumStream = {LazyEnumerate} end
            fun lazy {FilterStream Stream}
                case Stream of H|T then
                    %Logic is the same as in ListPrimesUntil
                    if {ListDivisorsOf H} == 1|H|nil then
                        H | thread {FilterStream T} end
                    else
                        {FilterStream T}
                    end
                else
                    nil
                end
            end
            thread Result = {FilterStream EnumStream} end
            Result
        end
        %{ShowStream {Primes}}
        %Generates primes infinitely
end
