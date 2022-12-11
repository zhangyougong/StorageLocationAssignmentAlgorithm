function [explode_radius, explode_num] = fireworksRadius(fitvalue, popsize)
   fitvalue = 1./fitvalue;
   a = 0.001;  %%%% 爆炸数目限制因子
   b = 0.999;
   explode_radius = zeros(1, popsize);
   explode_num = zeros(1, popsize);
   Er = popsize;
   En = popsize;
   Fmax = max(fitvalue);
   Fmin = min(fitvalue);
   for i=1:popsize
      explode_radius(i)= Er*(fitvalue(i) - Fmin + eps)/(sum(fitvalue) - popsize* Fmin + eps);  %%%% 爆炸半径 
      explode_num(i)= En*(Fmax - fitvalue(i) + eps)/(popsize * Fmax - sum(fitvalue) + eps);   %%%% 爆炸数目
      if(explode_num(i) < a* En)
          explode_num(i) = round(a* En);
      elseif(explode_num(i) > b* En) 
          explode_num(i) = round(b* En);  
      else
          explode_num(i) = round(explode_num(i)); 
      end
   end
end

