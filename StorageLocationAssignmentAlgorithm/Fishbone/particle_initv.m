function pop_v=particle_initv(goods_num,goods_pos,particle_num)%�����������Ⱥ�ĳ�ʼ�ٶ�
pop_length=goods_num*particle_num;%��Ⱥ�а����������
pop_v=zeros(pop_length,goods_pos);%��ʼ�������ٶ�
for i=1:pop_length  %��ʼ���ٶ�(�ٶ�Ϊ����������������ɢ�ģ�
   pop_v(i,1)=(rand*1);
   if pop_v(i,1)==0
       pop_v(i,1)=1;
   end
   pop_v(i,2)=(rand*3);
   if pop_v(i,2)==0
       pop_v(i,2)=3;
   end
   pop_v(i,3)=(rand*3);
   if pop_v(i,3)==0
       pop_v(i,3)=3;
   end       
   pop_v(i,4)=(rand*1);
   if pop_v(i,4)==0
       pop_v(i,4)=1;
   end   
end
for i=1:pop_length   %�ı�������
    for j=1:4
    if rand<0.5
        pop_v(i,j)=-pop_v(i,j);
    end
    end
end
end


















