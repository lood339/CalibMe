clear
close all

load('noisy_observation.mat');

x = pixel_noise_level_all;
y = angular_mean_std(:,1);
err = angular_mean_std(:,2);
figure; 
yyaxis left;
errorbar(x,y,err);
ylim([0, 0.1]);
set(gca, 'FontSize', 16);
xlabel('Noise \sigma (pixels)', 'FontSize', 24);
ylabel('Rotation error (degrees)', 'FontSize', 24);

yyaxis right;
y = fl_mean_std(:,1);
err = fl_mean_std(:,2);
errorbar(x, y, err, '--');
ylim([0, 5]);
ylabel('Focal length error (pixels)', 'FontSize', 24);

h_legend = legend('Rotation error', 'Focal length error', 'Location', 'northwest');
set(h_legend,'FontSize',18);

%set(gcf, 'PaperPosition',[0 0 9 6]);
%print(gcf, '-depsc2', '-loose', 'myeps.eps')


