function pop = fireworkInitpop(goods_num,goods_pos,firework_num)
% fireworkInitpop.m�����Ĺ�����ʵ��Ⱥ��ĳ�ʼ��
pop_length=goods_num*firework_num; %��Ⱥ�а����������
pop=zeros(pop_length,goods_pos); %��ʼ����Ⱥ��
for i=1:pop_length  %��ʼ����Ⱥ
   pop(i,1)=round(rand*4);
   if pop(i,1)==0
       pop(i,1)=4;
   end
   pop(i,2)=round(rand*12);
   if pop(i,2)==0
       pop(i,2)=12;
   end
   pop(i,3)=round(rand*12);
   if pop(i,3)==0
       pop(i,3)=12;
   end       
   pop(i,4)=round(rand*4);
   if pop(i,4)==0
       pop(i,4)=4;
   end   
end
pop = fireworkFilter(pop, goods_num, firework_num);
end
















