function [newpop]=fireworkSelection(pop,goods_num, popsize, bestindividual_current)
%ѡ����Ʋ���������Щ������Խ�����һ����������ѡ�񷨡����������P307ҳ
originPopsize = length(pop)./goods_num;
distance = zeros(originPopsize, 1);
for i = 1: originPopsize
    for j = 1: originPopsize
       distance(i) = distance(i) + dist_E(pop((i-1)*goods_num+1: i*goods_num, :), pop((j-1)*goods_num+1: j*goods_num, :));
    end
end

totalDistance=sum(distance); % ����Ӧ��֮��
newpop=zeros(popsize, 4);

% STEP1 ��ѱ���
newpop(1:goods_num,:) = bestindividual_current;
% STEP2 ʣ�����̶ķ�
selectionRatio=distance/totalDistance;%�������屻ѡ��ĸ���
if totalDistance==0
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

