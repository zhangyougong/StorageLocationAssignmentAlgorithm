function [newpop] = mutation(pop,popsize,goods_num,fitvalue)
%变异
%变异是指父代中每个个体的每一位都以概率pm翻转，即由1变为0，或者由0变为1。
%遗传算法的变异特性可以使求解过程随机搜索到解可能存在的整个空间，因此可以在一定程度上求得全局最优解。
newpop=pop;
mutation_row_point=zeros(1,popsize);
mutation_list_place=zeros(1,popsize);
mutation_list_point=zeros(1,popsize);
fitvalue_sum=sum(fitvalue);
fitvalue_avg=fitvalue_sum/popsize;
fitvalue_max=max(fitvalue);
pm1=0.5;
pm2=0.5;
for i=1:popsize
%     if fitvalue_max==fitvalue_avg
%         pm=pm1;
%     else
       if  (fitvalue(i)>=fitvalue_avg)
           pm=pm1*(fitvalue_max-fitvalue(i))./(fitvalue_max-fitvalue_avg);
       elseif fitvalue(i)<fitvalue_avg
           pm=pm2;
       end
%     end   
    goods_death=1;
    goods_common=1;
    if(rand<pm)
       while (goods_death==1)||(goods_common==1) 
       goods_death=0;
       goods_common=0;
       row_point=round(rand*goods_num); %产生变异点（行坐标）
       list_place=round(rand*4);%产生变异位置（列位置）
            if row_point==0
               row_point=goods_num;
            end
            if list_place==0
               list_place=4;
            end   
            
         %%%%%%%%%%%%个体变异%%%%%%%%%%%%%    
         %%%%%%%%%%%%货物位置解码%%%%%%%%%%%%%   
        area=decodechrom(newpop((i-1)*goods_num+row_point,:),1,2);
        row=decodechrom(newpop((i-1)*goods_num+row_point,:),3,6);
        list=decodechrom(newpop((i-1)*goods_num+row_point,:),7,10); 
        layer=decodechrom(newpop((i-1)*goods_num+row_point,:),11,12);
           if (list_place==1)||(list_place==4)
                if list_place==1
                    start_point=1;
                    end_point=2;
                    list_point=area;%赋初值
                    while(list_point==area)
                    list_point=round(rand*4);
                    if list_point==0
                        list_point=4;
                    end
                    end                 
                else
                    start_point=11;
                    end_point=12;
                    list_point=layer;%赋初值
                    while(list_point==layer)
                    list_point=round(rand*4);
                    if list_point==0
                        list_point=4;
                    end
                    end
                end
                        switch list_point
                            case 1
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 0];
                            case 2
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 1];
                            case 3
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 0];
                            case 4
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 1];   
                        end
                 
            else  %变异排数或者列数
                if list_place==2
                    start_point=3;
                    end_point=6;
                    list_point=row;%赋初值
                    while(list_point==row)
                       list_point=round(rand*16);
                       if list_point==0
                          list_point=16;
                       end
                    end                 
                else
                    start_point=7;
                    end_point=10;
                    list_point=list;%赋初值
                    while(list_point==list)
                      list_point=round(rand*16);
                      if list_point==0
                         list_point=16;
                      end
                    end
                end
                    %%%%%%%%%%%%找变异对象%%%%%%%%%%%%%                  
                        switch list_point
                            case 1
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 0 0 0];
                            case 2
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 0 0 1];
                            case 3
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 0 1 0];
                            case 4 
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 0 1 1];
                            case 5
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 1 0 0];
                            case 6
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 1 0 1];
                            case 7
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 1 1 0];
                            case 8
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[0 1 1 1];
                            case 9
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 0 0 0];
                            case 10 
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 0 0 1];
                            case 11
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 0 1 0];
                            case 12
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 0 1 1];                                
                            case 13
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 1 0 0];
                            case 14
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 1 0 1];
                            case 15
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 1 1 0];
                            case 16 
                                newpop((i-1)*goods_num+row_point,start_point:end_point)=[1 1 1 1];                             
                        end   
           end
       
        %%%%%%%%%%%%检查变异点所在货物位置是否是死位置%%%%%%%%%%%%%
        %%%%%%%%%%%%货物位置解码%%%%%%%%%%%%%
        area=decodechrom(newpop((i-1)*goods_num+row_point,:),1,2);
        row=decodechrom(newpop((i-1)*goods_num+row_point,:),3,6);
        list=decodechrom(newpop((i-1)*goods_num+row_point,:),7,10);
        %%%%%%%%除去不能放的位置%%%%%%%%%%%%%
%         if (area==1)||(area==2)           
%              if(row<=10)&&(list>row)
%                 goods_death=1;
%              elseif (row==11)&&(list>14)        
%                 goods_death=1;
%                  elseif row>=11
%                 goods_death=1;
%              end
%         else
%              if(row<=12)&&(list>13-row)
%                 goods_death=1;
%              elseif row>12
%                 goods_death=1;
%              end
%         end 
%         
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
        %%%%%%%%%%%%%%%检测变异出现的货物位置是否出现相同位置，如果存在相同位置则重新变异%%%%%%%%%%%%%
        if row_point>1
             for k=1:row_point-1
                  goods_differ1=sum(~(newpop((i-1)*goods_num+row_point,:)==newpop((i-1)*goods_num+k,:)));
                  if goods_differ1==0
                      goods_common=1;
                  end
             end
        end
        if  row_point<goods_num
             for k=row_point+1:goods_num
                   goods_differ2=sum(~(newpop((i-1)*goods_num+row_point,:)==newpop((i-1)*goods_num+k,:))); 
                   if goods_differ2==0
                     goods_common=1;  
                   end
             end
        end
          
        %%%%%%%%%%如果在变异点存在致死位置或者相同位置则重新变异%%%%%%%%%%%%%       
        if (goods_death==1)||(goods_common==1) 
          newpop((i-1)*goods_num+row_point,:)=pop((i-1)*goods_num+row_point,:);
        end     
       end
     mutation_row_point(1,i)=row_point;
     mutation_list_place(1,i)=list_place;
     mutation_list_point(1,i)=list_point;
    end
end
%     mutation_row_point
%     mutation_list_place
%     mutation_list_point
end

