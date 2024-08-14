% % 滚子故障
clc; clear all;
tspan=[0 30];
bc=[1e-3 0 1e-3 0];
[t,x]=ode45('vdp1009',tspan,bc);
subplot(2,1,1)
plot(t,x(:,4),'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation')
title('y方向速度规律')
xlabel('时间')
ylabel('幅值')
grid on
fs=5000;T=1/fs;
N=length(x(:,4));
n=0:N-1;
f=n*fs/N;
X1=fft(x(:,4));
subplot(2,1,2)
plot(f,abs(X1),'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation')
xlabel('频率')
ylabel('幅值')
axis([0 30 0 2.1e5])
grid on