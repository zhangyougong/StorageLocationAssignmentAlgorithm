function pop_v=particle_initv(goods_num,goods_pos,particle_num)%随机产生粒子群的初始速度
pop_length=goods_num*particle_num;%种群中包含货物个数
pop_v=zeros(pop_length,goods_pos);%初始化粒子速度
for i=1:pop_length  %初始化速度(速度为连续变量，不是离散的）
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
for i=1:pop_length   %改变正负号
    for j=1:4
    if rand<0.5
        pop_v(i,j)=-pop_v(i,j);
    end
    end
end
end


















