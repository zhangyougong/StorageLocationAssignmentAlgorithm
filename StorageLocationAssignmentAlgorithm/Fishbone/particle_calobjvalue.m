function [objvalue,average_objvalue] =particle_calobjvalue(pop,particle_num,goods_num,goods_Vv,goods_Vy,layer_height,layer_width,goods_frq,goods_weight,time_rate,gravity_rate,goods_gravity_optimal_value,goods_time_optimal_value,k)
%calobjvalue函数的功能是实现目标函数的计算
objvalue_all=0;
pop_length=goods_num*particle_num;%种群中包含货物个数
% pop_area=pop(:,1);
pop_row=pop(:,2);
pop_list=pop(:,3);
pop_layer=pop(:,4);
pop_time_h=zeros(1,pop_length);%小车竖直方向上的时间
pop_time_z=zeros(1,pop_length);%小车从所在货架运行到货品所在货位，自动小车所用的时间
pop_time_v=zeros(1,pop_length);%小车从出入库台运行到所在货架，自动小车所用的时间
pop_time=zeros(1,pop_length);%小车搬运该货物的时间
goods_gravity=zeros(1,goods_num);%单个货物的重心
goods_gravity_all=zeros(1,particle_num);%总货物的重心
goods_time=zeros(1,goods_num);%单个货物的时间
goods_time_all=zeros(1,particle_num);%总货物的时间
objvalue=zeros(1,particle_num); %各粒子的目标值
%%%%%%%%%%%%%%%计算各种布局方式（染色体）的总重心%%%%%%%%%%%%%%%
for i=1:particle_num
    for j=1:goods_num
     goods_gravity(j)=goods_weight(j).*pop_layer(j+(i-1)*goods_num).*layer_height;  
     goods_gravity_all(i)=goods_gravity_all(i)+goods_gravity(j); 
    end
end

%%%%%%%%%%%%%%%计算种群中每个物体的时间%%%%%%%%%%%%%%%
for i=1:pop_length          
        if   mod(pop_row(i),2)==1   %说明是奇数排
              pop_time_v(i)=(sqrt(2)*(1+1.5*(pop_row(i)-1))*layer_width+2*layer_width)./(goods_Vv);%求出1区和2区，奇数排的pop_time_v 
        else   %说明是偶数排    
              pop_time_v(i)=(sqrt(2)*(2+1.5*(pop_row(i)-2))*layer_width+layer_width)./(goods_Vv);%求出1区和2区，偶数排的pop_time_v 
        end
    pop_time_z(i)=(pop_list(i)-1)*layer_width./goods_Vv; %求在3区和4区，所在货架运行到货品所在货位，自动小车所用的时间pop_time_z
    pop_time_h(i)=(pop_layer(i)-1)*layer_height./goods_Vy;
    pop_time(i)=(pop_time_h(i)+pop_time_v(i)+pop_time_z(i))*2;%一个来回要乘2    
end
%%%%%%%%%%%%%%%计算各个粒子的总时间%%%%%%%%%%%%%%%
for i=1:particle_num
    for j=1:goods_num
     goods_time(j)=goods_frq(j).*pop_time(j+(i-1)*goods_num);  
     goods_time_all(i)=goods_time_all(i)+goods_time(j); 
    end
end
%%%%%%%%%%%%%%%计算各个粒子的总时间%%%%%%%%%%%%%%%
for i=1:particle_num
if(k==1)
    objvalue(i)=goods_time_all(i);
    objvalue_all=objvalue_all+objvalue(i);
elseif(k==2) 
    objvalue(i)=goods_gravity_all(i);
    objvalue_all=objvalue_all+objvalue(i);
elseif(k==3)
    objvalue(i)=goods_time_all(i)*time_rate*goods_gravity_optimal_value./(goods_gravity_optimal_value+goods_time_optimal_value)+goods_gravity_all(i)*gravity_rate*goods_time_optimal_value./(goods_gravity_optimal_value+goods_time_optimal_value); %入法——线性加权和法，多目标优化转化为单目标优化
    objvalue_all=objvalue_all+objvalue(i);
end 
end
    average_objvalue=objvalue_all/particle_num;
end
