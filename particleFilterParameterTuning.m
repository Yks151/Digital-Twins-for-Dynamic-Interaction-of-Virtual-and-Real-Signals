function [x_est, P_est] = particleFilterParameterTuning(true_data, wc_sim, C_sim, m_sim, num_particles)
    % 参数估计
    n = length(true_data);
    dt = 1;

    % 粒子滤波
    particles = randn(num_particles, 4);
    weights = ones(num_particles, 1) / num_particles;

    for i = 2:n
        % 预测步骤
        particles = predictParticles(particles, wc_sim, C_sim, m_sim, dt);

        % 似然计算
        likelihoods = calculateLikelihoods(particles, true_data(i), wc_sim);

        % 权重更新
        
        weights = weights .* likelihoods;
        weights = weights / sum(weights);
        weights = max(weights, eps); % 防止权重全部为零，加入一个小的正值

        % 重采样
        indices = randsample(1:num_particles, num_particles, true, weights);
        particles = particles(indices, :);
        weights = ones(num_particles, 1) / num_particles;

        % 估计状态
        x_est(i, :) = mean(particles);
        P_est(i, :, :) = cov(particles);
    end
end