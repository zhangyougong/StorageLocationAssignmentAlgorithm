function [newpop] =crossover( pop,popsize,goods_num,goods_pos,fitvalue)
%交叉%单点交叉
%群体中每一个个体之间都以一定的概率pc交叉，即两个个体从自字符串的某一个位置（一般是随机确定）开始互相交换，这类似生物进化过程中的基因分裂与重组。
%利用交叉我们有可能由父代个体在子代组合成具有更高适合度的个体
pop1=zeros(size(pop));
fitvalue1=zeros(1,popsize);
crossover_row_point=zeros(1,popsize);
crossover_list_point=zeros(1,popsize);
%***************随机排序***********************%
popsize_rand=popsize;%随机排序
for i=1:popsize
    j=round(rand*popsize_rand);  
    if j==0
    j=popsize_rand;
    end
    popsize_rand=popsize-i;
    pop1((i-1)*goods_num+1:i*goods_num,:)=pop((j-1)*goods_num+1:j*goods_num,:);
    fitvalue1(i)=fitvalue(j);
    fitvalue(j)=[];
    pop((j-1)*goods_num+1:j*goods_num,:)=[];   
end
pop=pop1;
fitvalue=fitvalue1;
newpop=pop;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%自适应变异概率%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fitvalue_sum=sum(fitvalue);
fitvalue_avg=fitvalue_sum/popsize;
fitvalue_max=max(fitvalue);
pc1=1;
pc2=1;
for i=1:2:popsize
    fitvalue_big=max(fitvalue(i),fitvalue(i+1));
%     if fitvalue_max==fitvalue_avg
%         pc=pc1;
%     else
        if  (fitvalue_big>=fitvalue_avg)
          pc=pc1*(fitvalue_max-fitvalue_big)./(fitvalue_max-fitvalue_avg);
        else 
          pc=pc2;
        end       
%     end 
    goods_death=1;
    goods_common=1;
    if(rand<pc)  %如果小于交叉概率，则进行交叉，如果大于交叉概率，则保持原样
        while (goods_death==1)||(goods_common==1) 
        goods_death=0;
        goods_common=0;
        row_point=round(rand*goods_num);%产生交叉点（行坐标）
        list_point=round(rand*goods_pos);%产生交叉点（列坐标）
            if row_point==0
               row_point=goods_num;
            end
            if list_point==0
               list_point=goods_pos;
            end  
        newpop((i-1)*goods_num+1:(i-1)*goods_num+row_point-1,:)=pop((i-1)*goods_num+1:(i-1)*goods_num+row_point-1,:);   %交叉获得第一个个体
        newpop((i-1)*goods_num+row_point+1:i*goods_num,:)=pop(i*goods_num+row_point+1:(i+1)*goods_num,:);
        newpop((i-1)*goods_num+row_point,1:list_point)=pop((i-1)*goods_num+row_point,1:list_point);
        newpop((i-1)*goods_num+row_point,list_point+1:goods_pos)=pop(i*goods_num+row_point,list_point+1:goods_pos);
       
        newpop( i*goods_num+1:i*goods_num+row_point-1,:)=pop(i*goods_num+1:i*goods_num+row_point-1,:);   %交叉获得第二个个体
        newpop( i*goods_num+row_point+1:(i+1)*goods_num,:)=pop((i-1)*goods_num+row_point+1:i*goods_num,:);
        newpop(i*goods_num+row_point,1:list_point)=pop(i*goods_num+row_point,1:list_point);
        newpop(i*goods_num+row_point,list_point+1:goods_pos)=pop((i-1)*goods_num+row_point,list_point+1:goods_pos);
     

        %%%%%%%%%%%%检查交叉点所在第一个货物位置是否是死位置%%%%%%%%%%%%%
        %%%%%%%%%%%%货物位置解码%%%%%%%%%%%%%
        area=decodechrom(newpop((i-1)*goods_num+row_point,:),1,2);
        row=decodechrom(newpop((i-1)*goods_num+row_point,:),3,6);
        list=decodechrom(newpop((i-1)*goods_num+row_point,:),7,10);
        %%%%%%%%除去不能放的位置%%%%%%%%%%%%%
           if (area==1)||(area==2)           
               if newpop((i-1)*goods_num+row_point,6)==0   %检查奇数排
                   if (list>(1.5*row-0.5))||(row>10)
                   goods_death=1;
                   end
               else   
                   if (list>1.5*row)||(row>10)
                   goods_death=1;
                   end
               end
           else
               if  newpop((i-1)*goods_num+row_point,6)==0  
                   if (list>(13-1.5*(row-1)))||(row>9)
                   goods_death=1;
                   end
               else
                  if (list>(15-1.5*row))||(row>9)                       
                  goods_death=1;
                  end
               end  
           end  
        %%%%%%%%%%%%检查交叉点所在第二个货物位置是否是死位置%%%%%%%%%%%%%
        %%%%%%%%%%%%货物位置解码%%%%%%%%%%%%%
        area=decodechrom(newpop(i*goods_num+row_point,:),1,2);
        row=decodechrom(newpop(i*goods_num+row_point,:),3,6);
        list=decodechrom(newpop(i*goods_num+row_point,:),7,10);
        %%%%%%%%除去不能放的位置%%%%%%%%%%%%%
            if (area==1)||(area==2)           
               if newpop(i*goods_num+row_point,6)==0   %检查奇数排
                   if (list>(1.5*row-0.5))||(row>10)
                   goods_death=1;
                   end
               else   
                   if (list>1.5*row)||(row>10)
                   goods_death=1;
                   end
               end
           else
               if  newpop(i*goods_num+row_point,6)==0  
                   if (list>(13-1.5*(row-1)))||(row>9)
                   goods_death=1;
                   end
               else
                  if (list>(15-1.5*row))||(row>9)                       
                  goods_death=1;
                  end
               end  
           end  
        %%%%%%%%%%%%%%%检测交叉出现的第一个货物位置是否出现相同位置，如果存在相同位置则重新交叉%%%%%%%%%%%%%
        if(row_point>1)
             for k=1:row_point-1
                  goods_differ1=sum(~(newpop((i-1)*goods_num+row_point,:)==newpop((i-1)*goods_num+k,:)));
                  if goods_differ1==0
                      goods_common=1;
                  end
             end
        end
        if(row_point<goods_num)
             for k=row_point+1:goods_num
                   goods_differ2=sum(~(newpop((i-1)*goods_num+row_point,:)==newpop((i-1)*goods_num+k,:))); 
                   if goods_differ2==0
                     goods_common=1;  
                   end
             end
        end
             
         %%%%%%%%%%%%%%%检测交叉出现的第二个货物位置是否出现相同位置，如果存在相同位置则重新交叉%%%%%%%%%%%%%  
         if(row_point>1)
             for k=1:row_point-1
                  goods_differ1=sum(~(newpop(i*goods_num+row_point,:)==newpop(i*goods_num+k,:)));
                  if goods_differ1==0
                      goods_common=1;
                  end
             end
         end
         if(row_point<goods_num)
             for k=row_point+1:goods_num
                   goods_differ2=sum(~(newpop(i*goods_num+row_point,:)==newpop(i*goods_num+k,:))); 
                   if goods_differ2==0
                     goods_common=1;  
                   end
             end  
         end   
                        
       %%%%%%%%%%如果在交叉点存在致死位置或者相同位置则重新交叉%%%%%%%%%%%%%
              if (goods_death==1)||(goods_common==1)
           newpop((i-1)*goods_num+1:i*goods_num,:)=pop((i-1)*goods_num+1:i*goods_num,:);   
           newpop(i*goods_num+1:(i+1)*goods_num,:)=pop(i*goods_num+1:(i+1)*goods_num,:); 
              end
        end 
     crossover_row_point(1,i)=row_point;
     crossover_list_point(1,i)=list_point;
    end
end
%    crossover_row_point
%    crossover_list_point
end

