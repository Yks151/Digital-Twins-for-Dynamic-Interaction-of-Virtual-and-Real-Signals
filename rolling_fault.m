function dx = rolling_fault(t, x)
    % 新增参数
    b = 3e-1; cd = 1; ri = 30; ro = 42; d = 12; Dm = 72; alfa = 0; kin = 1000; kout = 1500;
    k = (1 / ((1 + kin)^3/2 + (1 + kout)^3/2))^3/2;
    ws = 2 * pi * 1000; wc = 2 * 200 * pi;
    dfai = b / d; C = 100;
    lami = ri - sqrt(ri - b/2);
    lamo = ro - sqrt(ro - b/2);
    wb = Dm / (2 * d * cosd(alfa)) * (1 - (d * cosd(alfa) / Dm)^2) * ws;
    u = 1e-3; Z = 8;
    Fx = 0; Fy = 0; m = 0.1; Fr = 80;

    if cd < lami
        lam = cd;
    else
        lam = lamo;
    end

    if dfai < pi
        no = floor(wb * t / (2 * pi));
    else
        no = floor(wb * t / (2 * pi)) - 1;
    end

    if (2 * no + 1) * pi + pi / 4 <= wb <= (2 * no + 1) * pi + dfai + pi / 4
        beita = 1;
    else
        beita = 0;
    end

    % 新增自由度
    dx = zeros(9, 1);
    dx(1) = x(2);
    dx(2) = (Fr * cosd(wc * t) - Fx - C * x(2)) / m;
    dx(3) = x(4);
    dx(4) = (Fr * sind(wc * t) - Fy - C * x(3)) / m;

    % 新增非线性项和自由度
    for i = 1:Z
        sita = 2 * pi * (i - 1) / Z;
        deta = x(1) * cosd(sita) + x(3) * sind(sita) - u - beita * lam;
        if deta > 0
            Fj = k * deta^1.5;
        else
            Fj = 0;
        end
        sum1 = Fj * cosd(sita);
        sum2 = Fj * sind(sita);
        Fx = Fx + sum1;
        Fy = Fy + sum2;
    end

    dx(5) = x(6);
    dx(6) = (Fr * cosd(wc * t) - Fx - C * x(6)) / m;
    dx(7) = x(8);
    dx(8) = (Fr * sind(wc * t) - Fy - C * x(7)) / m;

    dx(9) = (x(5) - x(6)) / 10; % 新的自由度

end


