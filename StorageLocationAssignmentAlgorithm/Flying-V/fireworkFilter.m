function pop = fireworkFilter(pop, goods_num,firework_num)
%******************���˵������ϵĸ���*****************************%
for i=1:firework_num
   for j=1:goods_num 
           goods_death=1;
           goods_common=1;
     while (goods_death==1)||(goods_common==1)  %��û���ظ�λ�ú���λ�ú�����
          goods_death=0;
          goods_common=0;  
          area=pop((i-1)*goods_num+j,1);
          row=pop((i-1)*goods_num+j,2);
          list=pop((i-1)*goods_num+j,3);
          layer=pop((i-1)*goods_num+j,4);
 %%%%%%%%%%%%%%%%%%%%%%��ȥ���ܷŵ�λ��%%%%%%%%%%%%%%%%%%%%%%%%%
           if(layer<1||layer>4)
               disp('������ʼ��ʧ��');
           end
           if(area==1||area==2)
               if (mod(row,2)==1) %���������
                    if (list>1.5*row-0.5)||row>10
                    goods_death=1;
                   end
               else                          
                    if (list>1.5*row)|| row>10  
                    goods_death=1;
                    end
               end
           elseif(area==3||area==4)    
                if (mod(row,2)==1) %���������
                   if (list>(13-1.5*(row-1)))||(row>9)
                  goods_death=1;
                   end
               else
                  if (list>(15-1.5*row))||(row>9)                      
                  goods_death=1;
                  end
                end  
           else 
               disp('������ʼ��ʧ��');
           end                                                
 %%%%%%%%%%%%%%%������λ���Ƿ������ͬλ�ã����������ͬλ������������%%%%%%%%%%%%%
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
        
%%%%%%%%%%�����������λ�û�����ͬλ��������λ��%%%%%%%%%%%%%
       if (goods_death==1)||(goods_common==1)
            pop((i-1)*goods_num+j,1)=round(rand*4);
            if pop((i-1)*goods_num+j,1)==0
            pop((i-1)*goods_num+j,1)=4;
            end
            pop((i-1)*goods_num+j,2)=round(rand*12);
            if pop((i-1)*goods_num+j,2)==0
            pop((i-1)*goods_num+j,2)=12;
            end
            pop((i-1)*goods_num+j,3)=round(rand*12);
            if pop((i-1)*goods_num+j,3)==0
            pop((i-1)*goods_num+j,3)=12;
            end       
            pop((i-1)*goods_num+j,4)=round(rand*4);
            if pop((i-1)*goods_num+j,4)==0
            pop((i-1)*goods_num+j,4)=4;
            end   
       end
     end    
  end   
end
end















