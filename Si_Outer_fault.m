% 清除 MATLAB 工作区域并运行仿真
clc; clear all;

tspan = [0 30]; % 更新时间范围
bc = [1e-3; 0; 1e-3; 0; 0; 0; 0; 0; 0]; % 更新初始条件
[t, x] = ode45(@(t, x) Outer_fault(t, x), tspan, bc); % 注意这里的函数句柄 @(t, x) vdp1004(t, x)
% 绘制结果等
subplot(2,1,1);
plot(t, x(:, 1));
title('x方向位移规律');
xlabel('时间');
ylabel('幅值');
grid on;
fs = 1500; T = 1 / fs;
N = length(x(:, 1));
n = 0:N - 1;
f = n * fs / N;
X1 = fft(x(:, 1));
subplot(2,1,2);
plot(f, abs(X1));
xlabel('频率');
ylabel('幅值');
axis([0 30 0 3500]);
grid on;
