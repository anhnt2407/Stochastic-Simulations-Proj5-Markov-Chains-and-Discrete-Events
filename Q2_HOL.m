clc;clear all;N = 1000; n1 = 0.9; n2 = 0.9; flag1 = 0; flag2 = 0;
packetnum_line1 = 0;packetnum_line2= 0;buffer_line1 = 0;buffer_line2 = 0;
P1 =zeros(1,N);P2 =zeros(1,N);Pswitch1 =zeros(1,N);Pswitch2 = zeros(1,N);
Num_packets = zeros(1,N); Buff1 = zeros(1,N); Buff2 = zeros(1,N);
p1no = 0; p2no = 0; k = 1;
for i = 1:N
    packet_switched = 0; X = 1; Y = 1; nopacket_flag = 0;
    P1(i) = rand;  P2(i) = rand;
    if (P1(i) < n1) %packet at line 1
        packetnum_line1 = packetnum_line1 + 1;
        Pswitch1(i) = rand;  
    else nopacket_flag = 1;
    end
    if (P2(i) < n2) %packet at line 2
        packetnum_line2 = packetnum_line2 + 1;
        Pswitch2(i) = rand;
    else nopacket_flag = 1;
    end
    if (Pswitch1(i) < 0.75)  Pswitch1(i) = 0;
    else Pswitch1(i) = 1;
    end
    if (Pswitch2(i) < 0.25) Pswitch2(i) = 0;
    else Pswitch2(i) = 1;
    end
    if(i>1)
        if(flag1 == 1)   %if conflict has occured
            Pswitch2(i)=Pswitch2(i-1);
            if ( buffer_line2 == 0 ), flag1 = 0; end
        end
        if(flag2 == 1)       
            Pswitch1(i)=Pswitch1(i-1);
            if ( buffer_line1 == 0 ), flag2 = 0; end
        end
    end
    if ((Pswitch1(i) == 1 && Pswitch2(i) == 0) || (Pswitch1(i) == 0 && ...
            Pswitch2(i) == 1) || nopacket_flag)%for states 01,10,no packet
        packet_switched = packet_switched + ...
            packetnum_line1 + packetnum_line2; X = 0; Y = 0;
    else %for states 00 and 11
        contention = rand;
        if(contention < 0.5)
           buffer_line2 = buffer_line2 + 1;
           packet_switched = packet_switched + 1;
           if (buffer_line1 > 0), buffer_line1 = buffer_line1 - 1; end 
           flag1 = 1; X = 0;
        else
           buffer_line1 = buffer_line1 + 1;
           packet_switched = packet_switched + 1;
           if (buffer_line2 > 0), buffer_line2 = buffer_line2 - 1; end 
           flag2 = 1; Y = 0;
        end
    end
    Num_packets(i) = packet_switched;
    if(packetnum_line1*packetnum_line2 == 1)
        Eff_switch(k) = Num_packets(i)/(packetnum_line1 + ...
        packetnum_line2);  %2 packets should be switched everytime
        k = k + 1;
    end
    Buff1(i) = buffer_line1; Buff2(i) = buffer_line2;
    p1no = p1no + packetnum_line1 - X;%packets at output 1
    packetnum_line1 = 0;
    p2no = p2no + packetnum_line2 - Y;%packets at output 2
    packetnum_line2 = 0;
end
M = @(Eff_switch) mean(Eff_switch);
bootstrap_ci = bootci(100, M, Eff_switch)
Mean_switched = mean(Num_packets)
Mean_Buffer1 = mean(Buff1)
Mean_Buffer2 = mean(Buff2)
Total_packets_switched = p1no + p2no;
figure(1);histogram(Buff1); figure(2);histogram(Buff2);
figure(3);histogram(Num_packets);
