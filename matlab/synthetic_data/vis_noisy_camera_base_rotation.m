clear
close all

load('noisy_camera_base_rotation.mat')

x = angle_noise_level * 180/pi;
y = angular_mean_std(:,1);
err = angular_mean_std(:,2);
figure; 
yyaxis left;
errorbar(x,y,err);
ylim([0, 1.4]);
set(gca, 'FontSize', 16);
xlabel('Camera base rotation noise \sigma (degrees)', 'FontSize', 24);
ylabel('Rotation error (degrees)', 'FontSize', 24);

yyaxis right;
y = fl_mean_std(:,1);
err = fl_mean_std(:,2);
errorbar(x, y, err, '--');
ylim([0, 5]);
ylabel('Focal length error (pixels)', 'FontSize', 24);
xlim([0, 1.2]);

h_legend = legend('Rotation error', 'Focal length error', 'Location', 'northwest');
set(h_legend,'FontSize',18);

%set(gcf, 'PaperPosition',[0 0 9 6]);
%print(gcf, '-depsc2', '-loose', 'myeps.eps')


