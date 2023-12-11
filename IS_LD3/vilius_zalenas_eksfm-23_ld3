clear all
close all
clc

x = 0.1:(1/22):1;

d = (1 + 0.6 * sin(2 * pi * x / 0.7)) + 0.3 * sin(2 * pi * x) / 2;

c1 = 0.19091;
r1 = 0.18;
c2 = 0.87273;
r2 = 0.18;

w1 = randn(1);
w2 = randn(1);
w0 = randn(1);

eta = 0.01;

epochs = 10000;

for epoch = 1:epochs
    for i = 1:length(x)
       
        phi1 = exp(-(x(i) - c1)^2 / (2 * r1^2));
        phi2 = exp(-(x(i) - c2)^2 / (2 * r2^2));
        
        y = w1 * phi1 + w2 * phi2 + w0;

        w1 = w1 + eta * (d(i) - y) * phi1;
        w2 = w2 + eta * (d(i) - y) * phi2;
        w0 = w0 + eta * (d(i) - y);
    end
end


x2 = 0.1:(1/200):1;
y_aproksimuota = zeros(size(x2));

for i = 1:length(x2)
    
    phi1 = exp(-(x2(i) - c1)^2 / (2 * r1^2));
    phi2 = exp(-(x2(i) - c2)^2 / (2 * r2^2));
    
    y_aproksimuota(i) = w1 * phi1 + w2 * phi2 + w0;
end

figure;
plot(x, d, 'b-o');
hold on;
plot(x2, y_aproksimuota, 'r--o');
legend('Pradine funkcija', 'Aproskimuota funkcija');
grid on;
hold on;
plot(x2, y_aproksimuota, 'r--o');
legend('Pradine funkcija', 'Aproskimuota funkcija');
grid on;
