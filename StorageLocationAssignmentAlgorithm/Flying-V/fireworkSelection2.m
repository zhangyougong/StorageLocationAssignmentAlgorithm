function [newpop]=fireworkSelection2(pop,goods_num, popsize, bestindividual_current, fitvalue, q, generation)
%ѡ����Ʋ���������Щ������Խ�����һ����������ѡ�񷨡����������P307ҳ
originPopsize = length(pop)./goods_num;
fitvalue_max=max(fitvalue);
fitvalue_min=min(fitvalue);
for i=1:originPopsize
 fitvalue(i)= fitvalue(i)+((exp(1)-exp(q./generation))./(exp(1)+exp(q./generation)))*(fitvalue_max-fitvalue_min);
end
totalfit=sum(fitvalue); % ����Ӧ��֮��
newpop=zeros(popsize, 4);

% STEP1 ��ѱ���
newpop(1:goods_num,:) = bestindividual_current;
% STEP2 ʣ�����̶ķ�
selectionRatio=fitvalue/totalfit;%�������屻ѡ��ĸ���
if totalfit==0
    disp('error')
end   
selectionRatio1=cumsum(selectionRatio); %���fitvalue=[1 2 3 4],��cumsum(fitvalue)=[1 3 6 10]
ms=sort(rand(popsize-1,1));%��С��������  ����px��1�е�0��1֮�����������󣬲��Ҵ�С��������

fitin=1;
newin=2;
while newin<=popsize
    if(ms(newin-1))<=selectionRatio1(fitin)
        newpop((newin-1)*goods_num+1:newin*goods_num,:)=pop((fitin-1)*goods_num+1:fitin*goods_num,:);
        newin=newin+1;
    else
        fitin=fitin+1;
    end
end
end

