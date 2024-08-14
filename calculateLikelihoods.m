function likelihoods = calculateLikelihoods(particles, observation, wc_sim)
    % 在这里根据真实数据的统计学特征计算似然性
    simulated_data = zeros(size(particles, 1), 1);
    for j = 1:size(particles, 1)
        v_temp = vdp1009_state_space(0, particles(j, :), 0, wc_sim, 0, 0); % 使用当前粒子的参数估计观察数据
        simulated_data(j) = v_temp(4); % 提取速度值
    end

    % 计算目标函数
    target_min = min(simulated_data);
    target_max = max(simulated_data);
    target_mean = mean(simulated_data);
    target_periodicity = calculatePeriodicity(simulated_data);

    % 计算似然性
    likelihoods = exp(-abs(simulated_data - observation)) .* ...
                  exp(-abs(target_min - min(observation))) .* ...
                  exp(-abs(target_max - max(observation))) .* ...
                  exp(-abs(target_mean - mean(observation))) .* ...
                  exp(-abs(target_periodicity - calculatePeriodicity(observation)));
end
