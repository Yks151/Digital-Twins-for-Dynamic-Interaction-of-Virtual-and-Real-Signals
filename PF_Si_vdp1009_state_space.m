clc; clear all;

% 读取真实数据
load('./0HP/12k_Drive_End_OR007@6_0_130.mat');
true_data = DE(1:41921);

% 仿真参数和初始条件
Fr_sim = 4; wc_sim = 2 * 200 * pi; C_sim = 100; m_sim = 0.1;
tspan_sim = [0 30];
x0_sim = [1e-3; 0; 1e-3; 0];

% 仿真系统方程
ode_sim = @(t, x) vdp1009_state_space(t, x, Fr_sim, wc_sim, C_sim, m_sim);

% 运行仿真
[t_sim, x_sim] = ode45(ode_sim, tspan_sim, x0_sim);

% 粒子滤波器参数
numParticles = 1000; % 增加粒子数量

% 初始化粒子滤波器
pf = particleFilter;
pf.StateEstimationMethod = 'mean';

% 设置状态转移函数
pf.StateTransitionFcn = @(x, u) vdp1009_state_space(0, x, u(1), u(2), u(3), u(4));  % 更新状态转移函数

x_est = zeros(length(true_data), 4);

% 初始化粒子
particles = zeros(numParticles, 4);

% 使用更宽泛的范围进行均匀分布初始化粒子
range = [-0.1, 0.1; -0.1, 0.1; -0.1, 0.1; -0.1, 0.1];

for j = 1:numParticles
    particles(j, :) = range(:, 1) + rand(4, 1) .* (range(:, 2) - range(:, 1));
end

% 粒子滤波过程
for i = 1:length(true_data)
    % 观测真实数据
    z = true_data(i, 1);
    
    % 更新步骤
    % 使用真实数据更新粒子状态
    particles = vdp1009_state_space(0, particles, Fr_sim, wc_sim, C_sim, m_sim);

    % 计算新的权重
    residuals = z - particles(:, 4);
    weights = exp(-(residuals.^2) / (2 * var(residuals))); % 使用高斯分布的权重计算方式
    
    % 归一化权重
    weights = weights / sum(weights);

    % Resampling
    if ~any(isnan(weights)) && any(weights > 0) % 确保权重非负且至少有一个正值
        indices = randsample(1:numParticles, numParticles, true, weights);
        particles = particles(indices, :);
        
        % 获取估计值
        x_est(i, :) = mean(particles);
    else
        indices = randsample(1:numParticles, numParticles, true);
        particles = particles(indices, :);
        x_est(i, :) = mean(particles);
    end
end

% 绘制仿真和估计结果
noise_std = -1.5;

noise = noise_std * randn(size(x_sim(:, 2)));
sim_with_noise = x_sim(:, 4) + noise;

figure;
subplot(2, 1, 1);
plot(t_sim, sim_with_noise, 'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation with Noise');
xlabel('时间');
ylabel('幅值');
legend('Location', 'Best');
subplot(2, 1, 2);
plot(t_sim, true_data(:), 'r', 'LineWidth', 1.5, 'DisplayName', 'True');
xlabel('时间');
ylabel('幅值');
legend('Location', 'Best');
grid on;

figure;
subplot(2, 1, 1);
plot(t_sim, abs(fft(sim_with_noise(:))), 'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation');
xlabel('频率');
ylabel('幅值');
legend('Location', 'Best');
subplot(2, 1, 2);
plot(t_sim, abs(fft(true_data(:))), 'r', 'LineWidth', 1.5, 'DisplayName', 'True');
xlabel('频率');
ylabel('幅值');
legend('Location', 'Best');
grid on;
