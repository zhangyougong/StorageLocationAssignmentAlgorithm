function [fitvalue,average_fitvalue,bestfit_all,bestparticle,pop_fitvalue,particle_fitvalue,particle_best_generation] =particle_calfitvalue(pop,goods_num,bestparticle,particle_best_generation,pop_fitvalue,particle_fitvalue,objvalue,particle_num,q)
fitvalue=zeros(1,particle_num);
fitvalue_all=0;
for i=1:particle_num
     fitvalue(i)=1./objvalue(i); %���㵱���������ӵ���Ӧ��ֵ
     pop_fitvalue(i,q)=fitvalue(i);%������Ⱥ��ÿ���������Ӧ��ֵ
     fitvalue_all=fitvalue_all+fitvalue(i);%�ۼӵ�����Ӧ��
end
for i=1:particle_num
     particle_fitvalue(i)=max(pop_fitvalue(i,:));%���¸����������������Ӧֵ
     if fitvalue(i)==particle_fitvalue(i)  %������ӵ���ʷ�����Ӧֵ�������ӵĵ�����Ӧֵ��˵����������������ʷ��õ����ӣ���ô�õ����������滻��ʷ������ӡ�
        particle_best_generation((i-1)*goods_num+1:i*goods_num,:)=pop((i-1)*goods_num+1:i*goods_num,:);  
     end
end
     average_fitvalue=fitvalue_all./particle_num; %������Ӧ�Ⱦ�ֵ
     bestfit_all=max(particle_fitvalue);%������������Ⱥ�����Ӧֵ
for i=1:particle_num
     if  fitvalue(i)==bestfit_all
         bestparticle=pop((i-1)*goods_num+1:i*goods_num,:); 
     end
     %��������Ⱥ���������Ӧֵ
end     

end


