function periodicity = calculatePeriodicity(data)
    % 计算周期性的函数
    fft_data = fft(data);
    periodicity = sum(abs(fft_data(2:end))); % 忽略直流分量
end