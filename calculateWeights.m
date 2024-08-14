function weights = calculateWeights(particles, observation, wc_sim)
    % 计算每个粒子的似然性
    likelihoods = calculateLikelihoods(particles, observation, wc_sim);

    % 归一化似然性为权重
    weights = likelihoods / sum(likelihoods);
end
