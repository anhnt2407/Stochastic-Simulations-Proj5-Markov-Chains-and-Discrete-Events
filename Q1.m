close all; clc; clear all; T=100;Total_break = 0; time=0;
LambdaMax = 20; Nd =0; Na = 0; N = 0; Arr_time =0; Dep_time = Inf; 
while(1)
  if ((Arr_time <= Dep_time)&&(Arr_time <= T))% custmer arrives,open
       time = Arr_time; Na = Na+1; N= N+1;
       Arr_time = Generate_ArrivalTime(time);%next arrival
       if N==1 serve_time = Service_Job();%service job
       Dep_time = time + serve_time;
       Arr(Na)= time;
       end
       if (N==0) 
           Dep_time = Inf;
       end  
   elseif ((Dep_time < Arr_time)&&(Dep_time <= T))%customer departs,open
           time = Dep_time; N= N-1; Nd = Nd+1;
           if (N==0) % if all no more jobs
               Dep_time = Inf;
               break_time = rand * 0.3; %take break
               time = time + break_time;
               Total_break = Total_break + break_time;
           else % more jobs in queue
               serve_time = Service_Job();%service jobs
               Dep_time = time + serve_time; Dep(Nd)= time;
           end
   elseif ((min(Dep_time, Arr_time) > T) && (N>0)) %close,customers queued
           time = Dep_time; N= N-1; Nd = Nd+1;
           if (N==0)
           serve_time = Service_Job();
           Dep_time = time + serve_time; Dep(Nd)= time;
           end
  elseif ((min(Dep_time, Arr_time) > T) && (N==0))%close,queue empty
      break;
  end
  end
Total_break
