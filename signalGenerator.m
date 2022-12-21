fs = input('Enter sampling frequency: ');
while(fs <= 0)
    disp('Invalid input!');
    fs =input('Enter sampling frequency: ');
end
t1 = input('Enter starting time: ');
t2 = input('Enter end time: ');
while(t2 <= t1)
    disp('Invalid time!');%sprintf doesn't work
    t2 = input('Enter end time: ');
end
%gettting number of breakpoints
nb = input('Enter number of breakpoints: ');
while(nb < 0)
    disp('Invalid input!');
    nb = input('Enter number of breakpoints: ');
end
breakpoints = getBreakpoints(t1,t2,nb);
signal = [];
for i = 1:(nb+1)
    startT = breakpoints(i);
    endT = breakpoints(i+1);
    signal = drawSignal(signal,startT,endT,fs);
end
t = linspace(t1,t2,fs*(t2-t1));
plot(t,signal);
title('Signal');
disp('Do you want to perform an operation on the signal?');
op = input('1. Yes\n2. No\n');
if (op == 1)
    performOperations(t,signal);
else
    disp('Bye Bye');
end 

%function that gets the breakpoints then sorts them ascendingly

function breakpoints = getBreakpoints(t1, t2, nb)
    breakpoints = [t1, t2];
    for i = 1:nb
         fprintf('Enter Breakpoint %d: ',i);
         newB = input('');
        %validates that breakpoints are within the entered times
        while (newB <= t1) || (newB >= t2)
            fprintf('Input out of range. Please Enter a value between %d and %d\n', t1, t2);
            fprintf('Enter Breakpoint %d: ',i);
            newB = input('');
        end 
        %adding new breakpoint to the array
        breakpoints = [breakpoints(1:end) newB];
        %%disp(breakpoints);
    end
    %sorts the breakpoints in the end
    breakpoints = sort(breakpoints);  
    %disp(breakpoints);
end


%function that initializes signal

function signal = drawSignal(signal,startT,endT,fs)
    disp('Choose a signal');
    disp('1. DC Signal');
    disp('2. Ramp Signal');
    disp('3. Polynomial Signal');
    disp('4. Exponential Signal');
    disp('5. Sinusoidal Signal');
    num = input('');
    fprintf('\n');
    signalT = linspace(startT,endT,fs*(endT-startT));
    currentSignal = [];
    switch num
        case 1
            amplitude = input('Enter amplitude: ');
            currentSignal = drawDC(signalT,amplitude);
        case 2 
            slope = input('Enter slope: ');
            intercept = input('Enter intercept: ');
            currentSignal = drawRamp(signalT,slope,intercept);
        case 3
            hPower = input('Enter highest power: ');
            while(hPower <= 0)
                disp('Invalid power!');
                hPower = input('Enter highest power: ');
            end
            Coef = zeros(1,hPower);            
            j = 1;
            while(j <= hPower)
                fprintf('Enter coefficient of power %d\n',(hPower - j + 1));
                c = input('');
                Coef(j) = c;
                j = j+1;
            end
            intercept = input('Enter coefficient of power 0\n');
            Coef = [Coef intercept];
            currentSignal = drawPoly(signalT,Coef);
        case 4
            amplitude = input('Enter amplitude: ');
            exponent = input('Enter exponent: ');
            currentSignal = drawExp(signalT,amplitude,exponent);
        case 5
            amplitude = input('Enter amplitude: ');
            frequency = input('Enter frequency: ');
            while(frequency <= 0)
                disp('Invalid frequency!');
                frequency = input('Enter frequency: ');
            end
            phase = input('Enter phase: ');
            currentSignal = drawSin(signalT,amplitude,frequency,phase);
        otherwise
            disp('Invalid choice!');
    end
    fprintf('\n_________________________\n');
    signal = [signal currentSignal];
end

function dcSignal = drawDC(signalT,amplitude)
    dcSignal = 0*signalT + amplitude;
end

function rampSignal = drawRamp(signalT,slope,intercept)
    rampSignal = slope * signalT + intercept;
end

function polySignal = drawPoly(signalT,Coef)
    polySignal = polyval(Coef,signalT);
end

function expSignal = drawExp(signalT,amplitude,exponent)
    expSignal = amplitude * exp(signalT*exponent);
end

function sinSignal = drawSin(signalT,amplitude,frequency,phase)
    sinSignal = amplitude * sin(2*pi*frequency*signalT + deg2rad(phase));
end

%function that performs operations on the signal

function performOperations(t,signal)
    disp('Choose an operation');
    disp('1. Amplitude Scaling');
    disp('2. Time Reversal');
    disp('3. Time Shift');
    disp('4. Expanding the Signal');
    disp('5. Compressing the Signal');
    disp('6. Exit');
    n = input('');
    fprintf('\n');
    switch n
        case 1
            signal = ampScale(signal);
            plot(t,signal);
            title('Scaled Signal');
        case 2
            plot(-t,signal);
            title('Reversed Signal');
        case 3 
            shift = input('Enter shift: ');
            plot(t+shift,signal);%how user wants to shift the signal
            title('Shifted Signal');
        case 4
            exp = input('Enter expanding value: ');
            plot(t*exp,signal);
            title('Expanded Signal');
        case 5 
            comp = input('Enter compressing value: ');
            plot(t/comp,signal);
            title('Compressed Signal');
        case 6
            disp('Bye Bye');
        otherwise
            disp('Invalid choice!');
    end
    disp('Bye Bye');
end

function signal = ampScale(signal)
    scale = input('Enter scale value: ');
    signal = scale * signal;
end




