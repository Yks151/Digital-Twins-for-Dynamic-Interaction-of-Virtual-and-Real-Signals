clc;clear all;

% 读取真实数据
load('./0HP/12k_Drive_End_OR007@6_0_130.mat');
true_data = DE(1:41921);

% 优化参数
options = optimset('fminsearch');
options.Display = 'iter';
options.Algorithm = 'quasi-newton';

% 初始猜测
initial_guess = [4, 2 * 200 * pi, 100, 0.1];

% 设置参数范围
lb = [0, 0, 0, 0];
ub = [Inf, Inf, Inf, Inf];
tspan_sim = [0, 30]; % 设置仿真时间范围
x0_sim = [0; 0; 0; 0]; % 为仿真的初始条件定义一个起始值
t_sim = linspace(0, 30, 100); % 使用 100 个时间步

% 优化过程
optimal_params = fminsearch(@(params) objectiveFunction(params, true_data), initial_guess, options);

% 最优参数
Fr_optimal = optimal_params(1);
wc_optimal = optimal_params(2);
C_optimal = optimal_params(3);
m_optimal = optimal_params(4);

% 运行仿真
[t_sim_optimal, x_sim_optimal] = ode45(@(t, x) vdp1009_state_space(t, x, Fr_optimal, wc_optimal, C_optimal, m_optimal), tspan_sim, x0_sim);

% 绘制结果
% 在每次迭代中记录目标函数值
cost_history = [];

% 设置优化选项
options = optimset('Display', 'iter');

% 进行优化，并记录每次迭代的函数值
[optimal_params, cost, exitflag, output] = fminsearch(@(params) objectiveFunction(params, true_data), initial_guess, options);
cost_history = [cost_history; cost];

% 可视化优化过程中函数值的变化
figure;
plot(cost_history, 'LineWidth', 1.5);
xlabel('Iteration');
ylabel('Cost');
title('Cost Function Trend during Optimization');
grid on;

figure;
subplot(2, 1, 1);
plot(t_sim_optimal, x_sim_optimal(:, 4), 'b', 'LineWidth', 1.5, 'DisplayName', 'Optimized Simulation');
hold on;
plot(t_sim, true_data, 'r', 'LineWidth', 1.5, 'DisplayName', 'True Data');
xlabel('Time');
ylabel('Amplitude');
legend('Location', 'Best');
grid on;

subplot(2, 1, 2);
fft_sim_optimal = abs(fft(x_sim_optimal(:, 4)));
fft_true_data = abs(fft(true_data));
plot(t_sim_optimal, fft_sim_optimal, 'b', 'LineWidth', 1.5, 'DisplayName', 'Optimized Simulation');
hold on;
plot(t_sim, fft_true_data, 'r', 'LineWidth', 1.5, 'DisplayName', 'True Data');
xlabel('Frequency');
ylabel('Amplitude');
legend('Location', 'Best');
grid on;
