%Task 1a
declare QuadraticEquation in
    local RealSol X1 X2 in
    %Equations/calculations provided
    proc {QuadraticEquation A B C ?RealSol ?X1 ?X2} Discriminant Sqrt in %The syntax here enables us to "retrieve" the values of RealSol, X1 and X2 from the procedure, even though there are no explicit returns/its not a function
        Discriminant = B * B - 4.0*A*C
        RealSol = Discriminant >= 0.0
        if RealSol then
            Sqrt = {Float.sqrt Discriminant}
            X1 = (~B+Sqrt)/(2.0*A)
            X2 = (~B-Sqrt)/(2.0*A)
        end
    end
    %Task 1b
    {QuadraticEquation 2.0 1.0 ~1.0 RealSol X1 X2}
    {Show RealSol}
    {Show X1}
    {Show X2}
    % A = 2, B = 1 C = -1 results in X1 = 0.5 and X2 = -1.0
    % A = 2, B = 1 C = 2 results in no real solutions (RealSol = false)
end

%Task 1c
/* Procedural abstractions are in this example useful when there is several different values u want to return, (or an unknown/conditional amount of values),
and you do not want to have to return a data structure to contain the different values, you can rather assign them directly. */

%Task 1d
/* The difference between a procedure and a function is that a procedure does not return a value explicitly, as opposed to a function, but would
rather have to assign a value to a variable as with QuadraticEquation.*/



%Task 2 - Function named in favor of new Sum in task 3
declare SumOld in
    local List in
        fun {SumOld List}
            case List of Head|Tail then
                Head + {SumOld Tail} %Changed from the original Length function
            else
                0
            end
        end
    {Show {SumOld [1 2 3 4 5]}}
end


%Task 3a & 3b
declare Rightfold in
    local List Op U Sum Length in
        fun {Rightfold List Op U}
            case List of Head|Tail then %Pattern matching the provided list
                {Op Head {Rightfold Tail Op U}} %The key here is that the function Op is applied to the Head and the recursive call of Rightfold on the tail, with the Op function being provided when the function is called
            else
                U %Return the neutral element for the operation at end, which should be 0 for sum and length, but e.g. 1 for multiplication (1 + 1 + 0 = 2 which is correct, 1 * 1 * 0 = 0 is incorrect, needs to be changed to 1 in this example)
            end
        end

    %Task 3c
    fun {Sum List}
        {Rightfold List fun {$ X Y} X + Y end 0} %Summarize the elements encountered (X + Y), neutral element 0
    end

    fun {Length List}
        {Rightfold List fun {$ X Y} 1 + Y end 0} %Increment by 1 for each element encountered (1 + Y), neutral element 0
    end

    {Show {Sum [1 2 3 4 5 6]}}
    {Show {Length [1 2 3 4 5 6]}}
end

%Task 3d
/*For addition and multiplication it does not matter if the function is implemented as LeftFold or RightFold, as the order of the elements does not matter when adding or multiplying them together,
and paranthesis can basically be removed when working exclusively with these operations (addition and multiplication can not be mixed within an expression for this to be true). For operations like subtraction this is not the case,
so it becomes relevant whether the function is a right or left fold.*/

%Task 3e
/* An answer to this was kind of provided in the comments for the function. When using RightFold to implement the product
of a list of elements, the proper value of U would be 1, as that is the neutral element regarding multiplication, as it 
does not modify the result of the calculation in question. */



%Task 4
declare Quadratic in
    local A B C in
        fun {Quadratic A B C}
            fun {QuadraticCalculation X} %Quadratic returns this function with A, B and C defined in the original function call
                A*X*X + B*X + C %Provided quadratic equation, X provided (in addition to A, B and C) as the function is called
            end
        in
            QuadraticCalculation
        end
        {Show {{Quadratic 3 2 1} 2}}
end



%Task 5a
declare LazyNumberGenerator in
    local StartValue in
        fun {LazyNumberGenerator StartValue}
            StartValue|fun {$} {LazyNumberGenerator StartValue + 1} end %Explanation in 5b
        end
        {Show {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1}
    end

%Task 5b
/* The function returns a list that contains a startvalue and a function that calls the function again with an incremented startvalue.
Accessing the second element in the list, essentially calling the inner anonymous function, enables us to increment this value and list on demand, only making it as long as needed.
As every value needs a seperate function call i believe that this method in many cases will be too resource heavy and inefficient to use, depending on the situation. */



%Task 6a
/* Tail recursion is defined as a recursive function in which the recursive call is the last statement that is executed by the function. With tail recursion the final answer is calculated
by the last call of the function. If it is not a tail recursion then we need the results from all the function calls to calculate the correct return. My Sum function from Task 2 is therefore not tail recursive. */

%Tail recursive function for sum
declare TailSum in 
    local List TailSumInternal in
        fun {TailSum List}
            fun {TailSumInternal List Acc} %Helper function that includes an accumulator.
                case List of Head|Tail then
                    {TailSumInternal Tail Head + Acc} %This enables tail recursion, as the accumulator is updated with the sum of the head, and then passed on to the next recursive call.
                else
                    Acc %The Accumulated value is returned when the list is empty.
                end
            end
            {TailSumInternal List 0}
        end
    {Show {TailSum [1 2 3 4 5 6 7]}}
end

%Task 6b
/* The benefit of tail recursion is that the function does not need to keep track of the previous calls of the function to compute the correct value.
This is a benefit when it comes to resource management, as the previous calls do not need to be tracked in the call stack, thus freeing up memory. */

%Task 6c
/* The benfit of tail recursion for a given language is dependant on whether the language and its compiler/interpreter supports it. This relates directly to the previous question,
as in if a language is able to detect that certain parts of its memory can be freed up due to tail recursiveness. The inclusion of this kind of optimization varies from language to language. */