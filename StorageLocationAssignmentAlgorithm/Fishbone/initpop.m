function pop = initpop(goods_num,goods_pos,popsize)
%initpop.m�����Ĺ�����ʵ��Ⱥ��ĳ�ʼ��
%popsize ��ʾȺ��Ĵ�С
%chromlength ��ʾȾɫ��ĳ��ȣ���ֵ���ĳ��ȣ������ȵĴ�Сȡ���ڱ����Ķ����Ʊ���ĳ���
pop_length=goods_num*popsize;%��Ⱥ�а����������
pop=round(rand(pop_length,goods_pos)); %��ʼ����Ⱥ��
for i=1:popsize
%     goods_death=1;
%     goods_common=1;
%     while (goods_death==1)||(goods_common==1)  %��û���ظ�λ�ú���λ�ú�����
%           goods_death=0;
%           goods_common=0;   
     for j=1:goods_num 
           goods_death=1;
           goods_common=1;
     while (goods_death==1)||(goods_common==1)  %��û���ظ�λ�ú���λ�ú�����
          goods_death=0;
          goods_common=0; 
        %%%%%%%%%%%%%%%%%%%%%%��λ����%%%%%%%%%%%%%%%%%%%%%%%%%          
%         pop_area=decodechrom(pop((i-1)*goods_num+1:i*goods_num,:),1,2);%����
          pop_row=decodechrom(pop((i-1)*goods_num+1:i*goods_num,:),3,6);%��
          pop_list=decodechrom(pop((i-1)*goods_num+1:i*goods_num,:),7,10);%��                      
 %%%%%%%%%%%%%%%%%%%%%%��ȥ���ܷŵ�λ��%%%%%%%%%%%%%%%%%%%%%%%%%
               if pop((i-1)*goods_num+j,6)==0  %������
                   if (pop_list(j)>(13-1.5*(pop_row(j)-1)))||(pop_row(j)>9)
                  goods_death=1;
                   end
               else                           %ż����
                   if (pop_list(j)>(13-1.5*pop_row(j)+1))||(pop_row(j)>9)                       
                  goods_death=1;
                  end
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
            pop((i-1)*goods_num+j,:)=round(rand(1,goods_pos));
       end    
     end   
    end
end
end

