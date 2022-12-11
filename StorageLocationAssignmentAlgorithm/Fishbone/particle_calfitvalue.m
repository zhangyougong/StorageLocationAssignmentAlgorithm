function [fitvalue,average_fitvalue,bestfit_all,bestparticle,pop_fitvalue,particle_fitvalue,particle_best_generation] =particle_calfitvalue(pop,goods_num,bestparticle,particle_best_generation,pop_fitvalue,particle_fitvalue,objvalue,particle_num,q)
fitvalue=zeros(1,particle_num);
fitvalue_all=0;
for i=1:particle_num
     fitvalue(i)=1./objvalue(i); %计算当代各个粒子的适应度值
     pop_fitvalue(i,q)=fitvalue(i);%更新种群中每个个体的适应度值
     fitvalue_all=fitvalue_all+fitvalue(i);%累加当代适应度
end
for i=1:particle_num
     particle_fitvalue(i)=max(pop_fitvalue(i,:));%更新各个粒子历代最大适应值
     if fitvalue(i)==particle_fitvalue(i)  %如果粒子的历史最大适应值等于粒子的当代适应值，说明当代的粒子是历史最好的粒子，那么用当代的粒子替换历史最好粒子。
        particle_best_generation((i-1)*goods_num+1:i*goods_num,:)=pop((i-1)*goods_num+1:i*goods_num,:);  
     end
end
     average_fitvalue=fitvalue_all./particle_num; %计算适应度均值
     bestfit_all=max(particle_fitvalue);%更新历代粒子群最大适应值
for i=1:particle_num
     if  fitvalue(i)==bestfit_all
         bestparticle=pop((i-1)*goods_num+1:i*goods_num,:); 
     end
     %更新粒子群历代最大适应值
end     

end


