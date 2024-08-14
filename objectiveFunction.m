function cost = objectiveFunction(params, true_data)
    % 仿真参数和初始条件
    Fr_sim = params(1); wc_sim = params(2); C_sim = params(3); m_sim = params(4);
    tspan_sim = [0 30];
    x0_sim = [1e-3; 0; 1e-3; 0];

    % 运行仿真
    [t_sim, x_sim] = ode45(@(t, x) vdp1009_state_space(t, x, Fr_sim, wc_sim, C_sim, m_sim), tspan_sim, x0_sim);

    % 获取仿真数据和真实数据的长度
    len_true = length(true_data);
    len_sim = length(x_sim(:, 4));

    % 调整仿真数据长度与真实数据相匹配
    if len_sim > len_true
        x_sim = x_sim(1:len_true, 4);
    elseif len_sim < len_true
        % 如果仿真数据长度小于真实数据，使用插值
        t_interp = linspace(t_sim(1), t_sim(end), len_true);
        x_sim_interp = interp1(t_sim, x_sim(:, 4), t_interp, 'linear');
        x_sim = x_sim_interp;
    else
        x_sim = x_sim(:, 4);
    end

    % 计算均方误差
    mse = sum((x_sim - true_data).^2) / len_true;

    % 使用均方误差的平方作为目标函数
    cost = mean(mse.^2);  % 将均方误差的平方取平均作为评价指标
end
