clc;clear all; %外圈损伤
tspan = [0 100];
bc=[1e-3 0 1e-3 0];
[t,x]=ode45('vdp1004',tspan,bc);
subplot(2,1,1)
plot(t,x(:,1),'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation')
title('x方向位移规律')
xlabel('时间')
ylabel('幅值')
grid on
fs=1500;T=1/fs;
N=length(x(:,1));
n=0:N-1;
f=n*fs/N;
X1=fft(x(:,1));
subplot(2,1,2)
plot(f,abs(X1),'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation')
xlabel('频率')
ylabel('幅值')
axis([0 50 0 3500])
grid on