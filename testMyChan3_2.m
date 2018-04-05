% 测试最佳布设高度
% myChan3 定位误差随距离的变化

% 基站数目
BSN = 5;

% 各个基站的位置
BS = [ 0, 10*sqrt(3), 15*sqrt(3), 5*sqrt(3), 20*sqrt(3);
       0,         0,        15,          15,          0;
%       10,         10,        10,         10,         10]; 
       0,          0,         0,          0,          0]; 
BS = BS(:,1:BSN);

% 画出基站的位置
plot3(BS(1,:), BS(2,:), BS(3,:), 'rs', 'markersize',7, 'Markerfacecolor','r');
axis equal;
grid on;
hold on;

% MS的一系列实际位置
MS = [5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5;
      5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5;
      0,  -2,  -4,  -6,  -8, -10, -12, -14, -16, -18, -20, -22];
nPoints = length(MS);
% MS = [5, 5, -10]';
% nPoints = 1;

% 噪声方差
Noise = 0.1;
% 每个测试点的测试次数
times = 1000;

Xs = [];

for i = 1:nPoints
    % 各个BS与MS的实际距离
    for k = 1: BSN
        R0(k) = sqrt((BS(1,k) - MS(1,i))^2 + (BS(2,k) - MS(2, i))^2 + (BS(3,k) - MS(3, i))^2); 
    end
    % 随机加噪声
    for j = 1:times
        % R=R_{i,1},是加上了噪声后，BSi与BS1到MS的距离差，在实际使用中应该由 TDOA * c算得
        for k = 1: BSN-1
            R(k) = R0(k+1) - R0(1) + Noise * randn(1); 
        end
        X = myChan3(BSN, BS, R);
        Xs = [Xs, X];        
    end
end

plot3(Xs(1,:), Xs(2,:), Xs(3,:), '.');
plot3(MS(1,:), MS(2,:), MS(3,:), '^', 'markersize', 4, 'Markerfacecolor','y', 'markeredgecolor','k');
legend('Base Station', 'calculated location', 'real location');

[XsRow, XsCol] = size(Xs);
RMSE = zeros(1, nPoints);
for ii = 1: XsCol
    jj = fix((ii - 1) / times) + 1;
%     % 若计算三维定位误差
%     RMSE(1, jj) = RMSE(1, jj) + (Xs(1, ii) - MS(1, jj)) ^ 2 + (Xs(2, ii) - MS(2, jj)) ^ 2 + (Xs(3, ii) - MS(3, jj)) ^ 2;
    % 若计算平面误差
    RMSE(1, jj) = RMSE(1, jj) + (Xs(1, ii) - MS(1, jj)) ^ 2 + (Xs(2, ii) - MS(2, jj)) ^ 2 ;
end
RMSE = sqrt(RMSE ./ times);

% 画y坐标轴上一系列点的定位误差
figure;
plot(MS(3, :), RMSE, '-o');
xlabel('MS height(m)');
ylabel('location error(RMSE) (m)');
grid on;
title('定位误差随高度的变化');


    

