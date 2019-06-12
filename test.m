clear;
data = readtable('data.xlsx','ReadVariableNames' ,1,'FileType','spreadsheet');
hso = str2double(data{296:2219,2}); %296
hsc = str2double(data{296:2219,3});
zzo = str2double(data{296:2219,4});
zzc = str2double(data{296:2219,5});
o300 = str2double(data{296:2219,6}); %2
c300 = str2double(data{296:2219,7});
o500 = str2double(data{296:2219,8}); %1213
c500 = str2double(data{296:2219,9}); 
name=["hs300","zz500","future 300","future 500"];
op=[hso, zzo, o300, o500];
cl=[hsc zzc c300 c500];
%ti= {data{296:2219,1};data{296:2219,1};data{2:2219,1};data{1213:2219,1}};

for j = 1:4
    if j == 4
        time=datetime(data{1213:2219,1});
    else 
        time=datetime(data{296:2219,1});
    end
    a=name(j);
    close=rmmissing(cl(:,j));
    open=rmmissing(op(:,j));
    %time=ti(j);
    n=length(close);
    ret = zeros(n,1);
    interret = zeros(n,1);
    gapret = zeros(n,1);
    cumret=zeros(n,1);
    cumgap=zeros(n,1);
    cumin=zeros(n,1);
    for i = 1:(n-1)
        ret(i) = log(close(i+1)/close(i));
        interret(i) = log(close(i+1)/open(i+1));
        gapret(i) = log(open(i+1)/close(i));
        cumgap(i+1) = cumgap(i)+gapret(i);
        cumin(i+1) = cumin(i)+interret(i);
        cumret(i+1) = cumret(i)+ret(i);
    end
    %annualret = (cumret(n)-1)^13;
    %plot
    figure;
    subplot(1,2,1);
    plot(time,cumgap ) 
    hold on;
    plot(time,cumin) 
    hold on;
    plot(time,cumret ) 
    legend('gap', 'interday', 'log return');
    title(['Subplot 1: ',a ,' return'])
    
    if j==1 || j==2 %half cap
        cap=ones(n,1);
        noFee=ones(n,1);
        for i = 1:(n-1)
            noFee(i+1) = noFee(i)/2*(1+(open(i+1)/close(i)));
            cap(i+1) = cap(i)/2*(1+(open(i+1)/close(i)*(1-0.002)));
        end
        annualret = (cap(n))^(250/n)-1;
        annualret;
        %figure;
        subplot(1,2,2);
        plot(time,cap)
        hold on;
        plot(time,noFee)
        legend('with fee', 'no fee');
        title(['Subplot 2: ',a,' half cap return'])
    
    else %future high open
        ret2=zeros(n,1);
        cumret2=ones(n,1);
        for i = 1:(n-1)
            ret2(i) = (close(i)/open(i))*(1-0.00025*2);   
            cumret2(i+1) = cumret2(i)*ret2(i);
        end
        annualret = (cumret2(n))^(250/n)-1;
        annualret;
        %figure;
        subplot(1,2,2);
        plot(time,cumret2) 
        title(['Subplot 2: ',a,' futures return'])
    end
end