% 训练数据准备
load('./0HP/12k_Drive_End_OR007@6_0_130.mat');
true_data = DE(1:41929);

% 构建状态空间模型函数
state_space_model = @(t, x, Fr, wc, C, m) vdp1009_state_space(t, x, Fr, wc, C, m);

% 构建深度学习模型
layers = [
    imageInputLayer([1, 1, 41929], 'Name', 'input')
    fullyConnectedLayer(256, 'Name', 'fc1')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(128, 'Name', 'fc2')
    reluLayer('Name', 'relu2')
    fullyConnectedLayer(1, 'Name', 'output')  % 确保输出层的名称是 'output'
    regressionLayer('Name', 'output')];

% 设置训练选项
layers = [
    imageInputLayer([1, 1, 41929], 'Name', 'input')
    fullyConnectedLayer(256, 'Name', 'fc1')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(128, 'Name', 'fc2')
    reluLayer('Name', 'relu2')
    fullyConnectedLayer(1, 'Name', 'output')  % 修改为唯一的名称，如 'output_layer'
    regressionLayer('Name', 'output_layer')];  % 修改为唯一的名称，如 'output_layer'

% 使用真实数据进行训练
X_train = reshape(true_data, [1, 1, 41929]);
Y_train = true_data;  % 确保 true_data 是训练数据的标签，标签名称应为 'output'

net = trainNetwork(X_train, Y_train, layers, options);

% 使用深度学习模型进行预测
predicted_data = predict(net, X_train);

% 使用深度学习模型的输出作为初始条件，运行状态空间模型
initial_condition = predicted_data(1);  % 取第一个预测值作为初始条件
[t_sim, x_sim] = ode45(@(t, x) state_space_model(t, x, Fr_sim, wc_sim, C_sim, m_sim), tspan_sim, initial_condition);

% 绘制结果
figure;
subplot(2, 1, 1);
plot(t_sim, x_sim(:, 4), 'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation');
hold on;
plot(t_sim, predicted_data, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Prediction');
title('y方向速度规律');
xlabel('时间');
ylabel('幅值');
legend('Location', 'Best');
grid on;

subplot(2, 1, 2);
plot(t_sim, abs(fft(x_sim(:, 4))), 'b', 'LineWidth', 1.5, 'DisplayName', 'Simulation');
hold on;
plot(t_sim, abs(fft(predicted_data)), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Prediction');
xlabel('频率');
ylabel('幅值');
legend('Location', 'Best');
grid on;
