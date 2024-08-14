function z_pred = myMeasurementFcn(x)
    % 计算模型输出
    [~, x_sim] = ode45(@(t, x) vdp1009_state_space(t, x, Fr_sim, wc_sim, C_sim, m_sim), t_sim, x, odeset('RelTol', 1e-9, 'AbsTol', 1e-9));

    % 提取模拟数据的最大值、最小值、平均值和周期性特征
    max_sim = max(x_sim(:, 4));
    min_sim = min(x_sim(:, 4));
    mean_sim = mean(x_sim(:, 4));
    fft_sim = abs(fft(x_sim(:, 4)));

    % 返回这些特征
    z_pred = [max_sim; min_sim; mean_sim; fft_sim];
end
