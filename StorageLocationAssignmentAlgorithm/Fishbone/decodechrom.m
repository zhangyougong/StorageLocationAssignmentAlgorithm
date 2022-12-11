function pop2 = decodechrom(pop,start_point,end_point )
%decodechrom( pop,spoint,length)将染色体（二进制编码）转化为十进制数 %已经检查过，没问题
%start_point起始解码点
%end_point终止解码点
%pop解码数组
pop1=pop(:,start_point:end_point);
[px,py]=size(pop1);
for i=1:py
    pop1(:,i)=2^(py-i)*pop1(:,i);
end
pop2=sum(pop1,2);
for i=1:px
    pop2(i)=pop2(i)+1;
end
end

