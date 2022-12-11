function pop = initpop(goods_num,goods_pos,popsize)
%initpop.m函数的功能是实现群体的初始化
%popsize 表示群体的大小
%chromlength 表示染色体的长度（二值数的长度），长度的大小取决于变量的二进制编码的长度
pop_length=goods_num*popsize;%种群中包含货物个数
pop=round(rand(pop_length,goods_pos)); %初始生成群体
for i=1:popsize
%     goods_death=1;
%     goods_common=1;
%     while (goods_death==1)||(goods_common==1)  %当没有重复位置和死位置后跳出
%           goods_death=0;
%           goods_common=0;   
     for j=1:goods_num 
           goods_death=1;
           goods_common=1;
     while (goods_death==1)||(goods_common==1)  %当没有重复位置和死位置后跳出
          goods_death=0;
          goods_common=0; 
        %%%%%%%%%%%%%%%%%%%%%%货位解码%%%%%%%%%%%%%%%%%%%%%%%%%          
%         pop_area=decodechrom(pop((i-1)*goods_num+1:i*goods_num,:),1,2);%货区
          pop_row=decodechrom(pop((i-1)*goods_num+1:i*goods_num,:),3,6);%排
          pop_list=decodechrom(pop((i-1)*goods_num+1:i*goods_num,:),7,10);%列                      
 %%%%%%%%%%%%%%%%%%%%%%除去不能放的位置%%%%%%%%%%%%%%%%%%%%%%%%%
               if pop((i-1)*goods_num+j,6)==0  %奇数排
                   if (pop_list(j)>(13-1.5*(pop_row(j)-1)))||(pop_row(j)>9)
                  goods_death=1;
                   end
               else                           %偶数排
                   if (pop_list(j)>(13-1.5*pop_row(j)+1))||(pop_row(j)>9)                       
                  goods_death=1;
                  end
               end                     
 %%%%%%%%%%%%%%%检测货物位置是否出现相同位置，如果存在相同位置则重新生成%%%%%%%%%%%%%
         if(j>1)
             for k=1:j-1
                  goods_differ1=sum(~(pop((i-1)*goods_num+j,:)==pop((i-1)*goods_num+k,:)));
                  if goods_differ1==0
                      goods_common=1;
                  end
             end
         end
         if(j<goods_num)
             for k=j+1:goods_num
                   goods_differ2=sum(~(pop((i-1)*goods_num+j,:)==pop((i-1)*goods_num+k,:))); 
                   if goods_differ2==0
                     goods_common=1;  
                   end
             end
         end              
%%%%%%%%%%如果存在致死位置或者相同位置则重生位置%%%%%%%%%%%%%
       if (goods_death==1)||(goods_common==1)
            pop((i-1)*goods_num+j,:)=round(rand(1,goods_pos));
       end    
     end   
    end
end
end

