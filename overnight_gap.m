clear;
data = readtable('2.xls','ReadVariableNames' ,1,'FileType','spreadsheet');
close = data{:,'close'};
open = data{:,'open'};
time  = data{:,'Var1'};
%plot(data{:,'Var1'},data{:,'close'})
n=length(close);
ret = zeros(n);
interret = zeros(n);
gapret = zeros(n);
cumret=zeros(n);
cumgap=zeros(n);
cumin=zeros(n);
for i = 1:(n-1)
    ret(i) = log(close(i+1)/close(i));
    interret(i) = log(close(i+1)/open(i+1));
    gapret(i) = log(open(i+1)/close(i));
    cumgap(i+1) = cumgap(i)+gapret(i);
    cumin(i+1) = cumin(i)+interret(i);
    cumret(i+1) = cumret(i)+ret(i);
end
annualret = (cumret(n)-1)^13;
%plot
figure;
subplot(1,2,1);
plot(time,cumgap ) 
hold on;
plot(time,cumin) 
hold on;
plot(time,cumret ) 
legend('gap', 'interday', 'log return');
title('Subplot 1: hs300 return')
%????
cap=ones(n);
for i = 1:(n-1)
    %interret(i) = log(close(i+1)/open(i+1))*(cap/2);   
    %cumret(i+1) = cumret(i)+interret(i);
    cap(i+1) = cap(i)/2*(1+(close(i+1)/open(i+1)));
    
end
%figure;
subplot(1,2,2);
plot(time,cap) 
title('Subplot 2: hs300 half cap return')