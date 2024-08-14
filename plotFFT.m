function plotFFT(y, Fs, color, label)
    N = length(y);
    f = (-N/2:N/2-1) * Fs / N;
    y = fftshift(y);
    plot(f, y, color, 'LineWidth', 1.5, 'DisplayName', label);
    xlabel('频率 (Hz)');
    ylabel('幅值');
    legend('Location', 'Best');
end