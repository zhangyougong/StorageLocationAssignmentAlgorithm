function [upperBound] = getUpperBound(assignment, listIndex)
%   此处提供详细说明
 area = assignment(1);
 row = assignment(2);
 list = assignment(3);
 layer = assignment(4);
 if(listIndex == 1)   %% 区域上限
     upperBound = 4;
 elseif(listIndex == 2)  %% 排上限
     if(area==1||area==2)
         upperBound = 10;
     else
         upperBound = 9;
     end
 elseif(listIndex == 3)  %% 列上限
     if(area==1||area==2)
         if (mod(row,2)==1) %检查奇数排
             upperBound = 1.5*row-0.5;
         else                          
             upperBound = 1.5*row;
         end
     else   
         if (mod(row,2)==1) %检查奇数排
             upperBound = 13-1.5*(row-1);
         else
             upperBound = 15-1.5*row;
         end
     end
 else
     upperBound = 4;
end