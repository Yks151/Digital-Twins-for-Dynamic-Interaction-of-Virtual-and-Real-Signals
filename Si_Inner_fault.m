clc; clear all;
tspan = [0 30];
bc = [1e-3; 0; 1e-3; 0; 0; 0; 0; 0; 0];
[t, x] = ode45(@Inner_fault, tspan, bc);
subplot(2, 1, 1);
plot(t, x(:, 4));
title('y方向速度规律');
xlabel('时间');
ylabel('幅值');
grid on;
fs = 1500; T = 1/fs;
N = length(x(:, 4));
n = 0:N-1;
f = n*fs/N;
X1 = fft(x(:, 4));
subplot(2, 1, 2);
plot(f, abs(X1));
xlabel('频率');
ylabel('幅值');
axis([0 30 0 400000]);
grid on;