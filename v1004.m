clc;clear all; %��Ȧ����
tspan = [0 100];
bc=[1e-3 0 1e-3 0];
[t,x]=ode45('vdp1004',tspan,bc);
subplot(2,1,1)
plot(t,x(:,1),'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation')
title('x����λ�ƹ���')
xlabel('ʱ��')
ylabel('��ֵ')
grid on
fs=1500;T=1/fs;
N=length(x(:,1));
n=0:N-1;
f=n*fs/N;
X1=fft(x(:,1));
subplot(2,1,2)
plot(f,abs(X1),'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation')
xlabel('Ƶ��')
ylabel('��ֵ')
axis([0 50 0 3500])
grid on