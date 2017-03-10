% Function to generate arrival time
function Arr_time = Generate_ArrivalTime(time)
LambdaMax=20;
while(1)
    time = time - (1/LambdaMax)* log(rand);
    t = time; t = mod(t,10);
    if (t <=5) Lambda_t = 3*t + 4;
    else Lambda_t = -3*t + 34;
    end
    if (rand <= (Lambda_t/LambdaMax))
        Arr_time = time;
        break;  
    end
end


