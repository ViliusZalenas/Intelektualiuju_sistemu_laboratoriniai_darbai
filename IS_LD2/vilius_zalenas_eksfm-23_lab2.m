clear all
clc
eta = 0.105;                                                               %mokymo zingsnis
x = 0.1:1/22:1;                                                            %duomenu vektorius1
y = cosh(x);                                                               %duomenu vektorius2
d = (1 + 0.6 .* sin (2 .* pi .* x .* y ./ 0.7)) + 0.3 .* y .* sin (2 .* pi .* x) / 2;%siekiama tinklo isejimo priklausomybe nuo iejimo
v = zeros(length(x));                                                      %inicializuojamas tinklo isejimo kintamasis
%--------------------------------                                          %tinklas is 4 pasleptojo sluoksnio ir vieno gulutinio neuronu
w11_1=rand(1);                                                             %inicializuojami pasleptojo sluoksnio neuronu koeficientai w ir svoriai b
w21_1=rand(1);
w31_1=rand(1);
w41_1=rand(1);
w111_1=rand(1);                                                             
w211_1=rand(1);
w311_1=rand(1);
w411_1=rand(1);


b11_1=rand(1);
b21_1=rand(1);
b31_1=rand(1);
b41_1=rand(1);
%--------------------------------                                          %inicializuojami galutinio sluoksnio neuronu koeficientai w ir svoriai b
w11_2=rand(1);
w12_2=rand(1);
w13_2=rand(1);
w14_2=rand(1);

b2_2=rand(1);

%--------------------------------      

for j = 1:100000
    for i = 1:length(x)                                                    %Isorinis ciklas uzduoda mokymo iteraciju skaiciu o vidinis ciklas kiekviena karta pereina per visus pateiktus mokymo duomenis

       v1=(w11_1*x(i))+(w111_1*y(i))+b11_1;                                %Apskaiciuojami paleptojo sluoksnio neuronu atsakai
       v2=(w21_1*x(i))+(w211_1*y(i))+b21_1;
       v3=(w31_1*x(i))+(w311_1*y(i))+b31_1;
       v4=(w41_1*x(i))+(w411_1*y(i))+b41_1;
       
       v1_sigmoidas=1/1+exp(-v1);                                          %Neuronu atsakai normalizuojami sigmoidine funkcija
       v2_sigmoidas=1/1+exp(-v2);
       v3_sigmoidas=1/1+exp(-v3);
       v4_sigmoidas=1/1+exp(-v4);
        
       v(i)=w11_2*v1_sigmoidas+w12_2*v2_sigmoidas+w13_2*v3_sigmoidas+b2_2+w41_1*v4_sigmoidas+b41_1; %Apskaiciuojamas galutinis tinklo atsakas
       
       e(i)=d(i)-v(i);                                                     %Apskaiciuojama paklaida tarp norimo (formule 5 eiluteje) ir gauto rezultato isejime

                                                                           %Skaiciuojami paklaidu gradientai, pasleptajam ir galutinaim sluoksniui formules skirtingos
       grad1_2=e(i);                                                       %Galutinio neurono gradientas priklauso nuo klaidos skaiciavimo funkcijos. Siuo atveju e(i) isvestine pagal v(i) yra vienetas, arba pats e(i)

       grad1_1= v1_sigmoidas*(1+v1_sigmoidas)*grad1_2*w11_1;               %Skaiciuojami pasleptojo sluoksnio neuronu paklaidu gradientai
       grad2_1= v2_sigmoidas*(1+v2_sigmoidas)*grad1_2*w21_1;
       grad3_1= v3_sigmoidas*(1+v3_sigmoidas)*grad1_2*w31_1;       
       grad4_1= v4_sigmoidas*(1+v4_sigmoidas)*grad1_2*w41_1;
       
       grad11_1= v1_sigmoidas*(1+v1_sigmoidas)*grad1_2*w111_1;             
       grad21_1= v2_sigmoidas*(1+v2_sigmoidas)*grad1_2*w211_1;
       grad31_1= v3_sigmoidas*(1+v3_sigmoidas)*grad1_2*w311_1;       
       grad41_1= v4_sigmoidas*(1+v4_sigmoidas)*grad1_2*w411_1;
       
       w11_2=w11_2+eta*grad1_2*v1_sigmoidas;                               %Pagal gradientus ir mokymo zingsni is pradziu atnaujinami arciausiai isejimo esantys sluoksniai (algoritmo backpropagation esme)
       w12_2=w12_2+eta*grad1_2*v2_sigmoidas; 
       w13_2=w13_2+eta*grad1_2*v3_sigmoidas; 
       w14_2=w14_2+eta*grad1_2*v4_sigmoidas; 
       
       b2_2= b2_2+eta*grad1_2;                                             %Atnaujinami ir koeficientai ir svoriai

    
        w11_1=w11_1+eta*grad1_1*x(i);                                      %Paskui atnaujinami vis arciau iejimo esanciu neuronu svoriai ir koeficientai
        w21_1=w21_1+eta*grad2_1*x(i);
        w31_1=w31_1+eta*grad3_1*x(i);
        w41_1=w41_1+eta*grad4_1*x(i);
        
        w111_1=w11_1+eta*grad11_1*y(i);                                      %Paskui atnaujinami vis arciau iejimo esanciu neuronu svoriai ir koeficientai
        w211_1=w21_1+eta*grad21_1*y(i);
        w311_1=w31_1+eta*grad31_1*y(i);
        w411_1=w41_1+eta*grad41_1*y(i);
        
        b11_1=b11_1+eta*((grad1_1*eta+grad11_1)/2)*((x(i)+y(i))/2);
        b21_1=b21_1+eta*((grad2_1*eta+grad21_1)/2)*((x(i)+y(i))/2);
        b31_1=b31_1+eta*((grad3_1*eta+grad31_1)/2)*((x(i)+y(i))/2);
        b41_1=b41_1+eta*((grad4_1*eta+grad41_1)/2)*((x(i)+y(i))/2);

    end
 end

[X,Y] = meshgrid(x,y);
figure(1)
plot3(x,y,d)
hold on
plot3(x,y,v)                                                                  %Braizoma antra priklausomybe, gauta butent is apmokto neuronu tinklo, sutapimui su norimais duomenimis didele itaka turi mokymo zingsnis
