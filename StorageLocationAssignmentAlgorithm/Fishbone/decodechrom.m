function pop2 = decodechrom(pop,start_point,end_point )
%decodechrom( pop,spoint,length)��Ⱦɫ�壨�����Ʊ��룩ת��Ϊʮ������ %�Ѿ�������û����
%start_point��ʼ�����
%end_point��ֹ�����
%pop��������
pop1=pop(:,start_point:end_point);
[px,py]=size(pop1);
for i=1:py
    pop1(:,i)=2^(py-i)*pop1(:,i);
end
pop2=sum(pop1,2);
for i=1:px
    pop2(i)=pop2(i)+1;
end
end

