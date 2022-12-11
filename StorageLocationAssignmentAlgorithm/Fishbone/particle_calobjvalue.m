function [objvalue,average_objvalue] =particle_calobjvalue(pop,particle_num,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k)
%calobjvalue�����Ĺ�����ʵ��Ŀ�꺯���ļ���
objvalue_all=0;
pop_length=goods_num*particle_num;%��Ⱥ�а����������
% pop_area=pop(:,1);
pop_row=pop(:,2);
pop_list=pop(:,3);
pop_layer=pop(:,4);
pop_time_h=zeros(1,pop_length);%С����ֱ�����ϵ�ʱ��
pop_time_z=zeros(1,pop_length);%С�������ڻ������е���Ʒ���ڻ�λ���Զ�С�����õ�ʱ��
pop_time_v=zeros(1,pop_length);%С���ӳ����̨���е����ڻ��ܣ��Զ�С�����õ�ʱ��
pop_time=zeros(1,pop_length);%С�����˸û����ʱ��
goods_gravity=zeros(1,goods_num);%�������������
goods_gravity_all=zeros(1,particle_num);%�ܻ��������
goods_time=zeros(1,goods_num);%���������ʱ��
goods_time_all=zeros(1,particle_num);%�ܻ����ʱ��
objvalue=zeros(1,particle_num); %�����ӵ�Ŀ��ֵ
%%%%%%%%%%%%%%%������ֲ��ַ�ʽ��Ⱦɫ�壩��������%%%%%%%%%%%%%%%
for i=1:particle_num
    for j=1:goods_num
     goods_gravity(j)=goods_weight(j).*pop_layer(j+(i-1)*goods_num).*layer_height;  
     goods_gravity_all(i)=goods_gravity_all(i)+goods_gravity(j); 
    end
end

%%%%%%%%%%%%%%%������Ⱥ��ÿ�������ʱ��%%%%%%%%%%%%%%%
for i=1:pop_length          
        if   mod(pop_row(i),2)==1   %˵����������
              pop_time_v(i)=(sqrt(2)*(1+1.5*(pop_row(i)-1))*layer_width+2*layer_width)./(goods_Vv);%���1����2���������ŵ�pop_time_v 
        else   %˵����ż����    
              pop_time_v(i)=(sqrt(2)*(2+1.5*(pop_row(i)-2))*layer_width+layer_width)./(goods_Vv);%���1����2����ż���ŵ�pop_time_v 
        end
    pop_time_z(i)=(pop_list(i)-1)*layer_width./goods_Vv; %����3����4�������ڻ������е���Ʒ���ڻ�λ���Զ�С�����õ�ʱ��pop_time_z
    pop_time_h(i)=(pop_layer(i)-1)*layer_height./goods_Vy;
    pop_time(i)=(pop_time_h(i)+pop_time_v(i)+pop_time_z(i))*2;%һ������Ҫ��2    
end
%%%%%%%%%%%%%%%����������ӵ���ʱ��%%%%%%%%%%%%%%%
for i=1:particle_num
    for j=1:goods_num
     goods_time(j)=goods_frq(j).*pop_time(j+(i-1)*goods_num);  
     goods_time_all(i)=goods_time_all(i)+goods_time(j); 
    end
end
%%%%%%%%%%%%%%%����������ӵ���ʱ��%%%%%%%%%%%%%%%
for i=1:particle_num
if(k==1)
    objvalue(i)=goods_time_all(i);
    objvalue_all=objvalue_all+objvalue(i);
elseif(k==2) 
    objvalue(i)=goods_gravity_all(i);
    objvalue_all=objvalue_all+objvalue(i);
elseif(k==3)
    objvalue(i)=goods_time_all(i)*time_rate*goods_gravity_optimal_value./(goods_gravity_optimal_value+goods_time_optimal_value)+goods_gravity_all(i)*gravity_rate*goods_time_optimal_value./(goods_gravity_optimal_value+goods_time_optimal_value); %�뷨�������Լ�Ȩ�ͷ�����Ŀ���Ż�ת��Ϊ��Ŀ���Ż�
    objvalue_all=objvalue_all+objvalue(i);
end 
end
    average_objvalue=objvalue_all/particle_num;
end
