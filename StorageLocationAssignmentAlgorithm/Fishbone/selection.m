function [newpop]=selection(pop,fitvalue,popsize,goods_num,q,generation )
%ѡ����Ʋ���������Щ������Խ�����һ����������ѡ�񷨡����������P307ҳ
fitvalue2=zeros(1,popsize);
fitvalue_max=max(fitvalue);
fitvalue_min=min(fitvalue);
for i=1:popsize
 fitvalue2(i)=fitvalue(i)+((exp(1)-exp(q./generation))./(exp(1)+exp(q./generation)))*(fitvalue_max-fitvalue_min);
end
fitvalue=fitvalue2;
totalfit=sum(fitvalue);%����Ӧ��֮��
newpop=zeros(size(pop));
fitvalue1=fitvalue;
fitvalue1=fitvalue1/totalfit;%�������屻ѡ��ĸ���
if totalfit==0
    disp('error')
end   
fitvalue1=cumsum(fitvalue1); %���fitvalue=[1 2 3 4],��cumsum(fitvalue)=[1 3 6 10]
ms=sort(rand(popsize,1));%��С��������  ����px��1�е�0��1֮�����������󣬲��Ҵ�С��������
fitin=1;
newin=1;
while newin<popsize+1
    if(ms(newin))<=fitvalue1(fitin)
        newpop((newin-1)*goods_num+1:newin*goods_num,:)=pop((fitin-1)*goods_num+1:fitin*goods_num,:);
        newin=newin+1;
    else
        fitin=fitin+1;
    end
end
end

