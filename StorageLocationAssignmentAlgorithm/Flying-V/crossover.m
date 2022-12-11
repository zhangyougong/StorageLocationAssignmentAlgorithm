function [newpop] =crossover( pop,popsize,goods_num,goods_pos,fitvalue)
%����%���㽻��
%Ⱥ����ÿһ������֮�䶼��һ���ĸ���pc���棬��������������ַ�����ĳһ��λ�ã�һ�������ȷ������ʼ���ཻ����������������������еĻ�����������顣
%���ý��������п����ɸ����������Ӵ���ϳɾ��и����ʺ϶ȵĸ���
pop1=zeros(size(pop));
fitvalue1=zeros(1,popsize);
crossover_row_point=zeros(1,popsize);
crossover_list_point=zeros(1,popsize);
%***************�������***********************%
popsize_rand=popsize;%�������
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����Ӧ�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    if(rand<pc)  %���С�ڽ�����ʣ�����н��棬������ڽ�����ʣ��򱣳�ԭ��
        while (goods_death==1)||(goods_common==1) 
        goods_death=0;
        goods_common=0;
        row_point=round(rand*goods_num);%��������㣨�����꣩
        list_point=round(rand*goods_pos);%��������㣨�����꣩
            if row_point==0
               row_point=goods_num;
            end
            if list_point==0
               list_point=goods_pos;
            end  
        newpop((i-1)*goods_num+1:(i-1)*goods_num+row_point-1,:)=pop((i-1)*goods_num+1:(i-1)*goods_num+row_point-1,:);   %�����õ�һ������
        newpop((i-1)*goods_num+row_point+1:i*goods_num,:)=pop(i*goods_num+row_point+1:(i+1)*goods_num,:);
        newpop((i-1)*goods_num+row_point,1:list_point)=pop((i-1)*goods_num+row_point,1:list_point);
        newpop((i-1)*goods_num+row_point,list_point+1:goods_pos)=pop(i*goods_num+row_point,list_point+1:goods_pos);
       
        newpop( i*goods_num+1:i*goods_num+row_point-1,:)=pop(i*goods_num+1:i*goods_num+row_point-1,:);   %�����õڶ�������
        newpop( i*goods_num+row_point+1:(i+1)*goods_num,:)=pop((i-1)*goods_num+row_point+1:i*goods_num,:);
        newpop(i*goods_num+row_point,1:list_point)=pop(i*goods_num+row_point,1:list_point);
        newpop(i*goods_num+row_point,list_point+1:goods_pos)=pop((i-1)*goods_num+row_point,list_point+1:goods_pos);
     

        %%%%%%%%%%%%��齻������ڵ�һ������λ���Ƿ�����λ��%%%%%%%%%%%%%
        %%%%%%%%%%%%����λ�ý���%%%%%%%%%%%%%
        area=decodechrom(newpop((i-1)*goods_num+row_point,:),1,2);
        row=decodechrom(newpop((i-1)*goods_num+row_point,:),3,6);
        list=decodechrom(newpop((i-1)*goods_num+row_point,:),7,10);
        %%%%%%%%��ȥ���ܷŵ�λ��%%%%%%%%%%%%%
           if (area==1)||(area==2)           
               if newpop((i-1)*goods_num+row_point,6)==0   %���������
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
        %%%%%%%%%%%%��齻������ڵڶ�������λ���Ƿ�����λ��%%%%%%%%%%%%%
        %%%%%%%%%%%%����λ�ý���%%%%%%%%%%%%%
        area=decodechrom(newpop(i*goods_num+row_point,:),1,2);
        row=decodechrom(newpop(i*goods_num+row_point,:),3,6);
        list=decodechrom(newpop(i*goods_num+row_point,:),7,10);
        %%%%%%%%��ȥ���ܷŵ�λ��%%%%%%%%%%%%%
            if (area==1)||(area==2)           
               if newpop(i*goods_num+row_point,6)==0   %���������
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
        %%%%%%%%%%%%%%%��⽻����ֵĵ�һ������λ���Ƿ������ͬλ�ã����������ͬλ�������½���%%%%%%%%%%%%%
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
             
         %%%%%%%%%%%%%%%��⽻����ֵĵڶ�������λ���Ƿ������ͬλ�ã����������ͬλ�������½���%%%%%%%%%%%%%  
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
                        
       %%%%%%%%%%����ڽ�����������λ�û�����ͬλ�������½���%%%%%%%%%%%%%
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

