function particles = predictParticles(particles, wc, C, m, dt)
    for j = 1:size(particles, 1)
        particles(j, :) = vdp1009_state_space(0, particles(j, :), 0, wc, C, m);
    end
end