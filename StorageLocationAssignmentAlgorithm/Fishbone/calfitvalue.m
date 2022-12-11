function [fitvalue,average_fitvalue] =calfitvalue(objvalue,popsize)
fitvalue=zeros(1,popsize);
fitvalue_all=0;
for i=1:popsize
      fitvalue(i)=1./objvalue(i);
%     fitvalue(i)=1./(objvalue(i)+1);
     fitvalue_all=fitvalue_all+fitvalue(i);
end
     average_fitvalue=fitvalue_all./popsize;
end

