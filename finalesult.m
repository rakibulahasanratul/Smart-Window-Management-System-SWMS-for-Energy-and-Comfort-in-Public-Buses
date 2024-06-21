% Load the data
data = readtable('finalresult.csv');

% Extract time steps
time_steps = data.Time_Step;

% Extract U values
Type1_U = data.Type1_U;
Type2_U = data.Type2_U;
Type3_U = data.Type3_U;
Type4_U = data.Type4_U;

% Extract U1 values
Type1_U1 = data.Type1_U1;
Type2_U1 = data.Type2_U1;
Type3_U1 = data.Type3_U1;
Type4_U1 = data.Type4_U1;

% Extract U2 values
Type1_U2 = data.Type1_U2;
Type2_U2 = data.Type2_U2;
Type3_U2 = data.Type3_U2;
Type4_U2 = data.Type4_U2;

% Extract Totalwindow values
Type1_Totalwindow = data.Type1_Totalwindow;
Type2_Totalwindow = data.Type2_Totalwindow;
Type3_Totalwindow = data.Type3_Totalwindow;
Type4_Totalwindow = data.Type4_Totalwindow;

% Plot settings
line_width = 2;
font_size = 16;
axis_line_width = 1;

% Define valid colors
colors = {'blue', 'red', [0, 0.5, 0], 'magenta','cyan', 'yellow', 'black'};

% Plot timestep vs U
figure;
plot(time_steps, Type1_U, 'LineWidth', line_width, 'Color', colors{1});
hold on;
plot(time_steps, Type2_U, 'LineWidth', line_width, 'Color', colors{2});
plot(time_steps, Type3_U, 'LineWidth', line_width, 'Color', colors{3});
plot(time_steps, Type4_U, 'LineWidth', line_width, 'Color', colors{4});
title('Time Step vs U (Combined objective function)', 'FontSize', font_size);
xlabel('Time Step', 'FontSize', font_size);
ylabel('U Values', 'FontSize', font_size);
legend({'Type1', 'Type2', 'Type3', 'Type4'}, 'FontSize', font_size);
grid on;
set(gca, 'LineWidth', axis_line_width, 'FontSize', font_size);

% Plot timestep vs U1
figure;
plot(time_steps, Type1_U1, 'LineWidth', line_width, 'Color', colors{1});
hold on;
plot(time_steps, Type2_U1, 'LineWidth', line_width, 'Color', colors{2});
plot(time_steps, Type3_U1, 'LineWidth', line_width, 'Color', colors{3});
plot(time_steps, Type4_U1, 'LineWidth', line_width, 'Color', colors{4});
title('Time Step vs U1 (Fuel Consumption)', 'FontSize', font_size);
xlabel('Time Step', 'FontSize', font_size);
ylabel('U1 Values', 'FontSize', font_size);
legend({'Type1 (21%)', 'Type2 (13%)', 'Type3 (11%)', 'Type4(18%)'}, 'FontSize', font_size);
grid on;
set(gca, 'LineWidth', axis_line_width, 'FontSize', font_size);

% Plot timestep vs U2
figure;
plot(time_steps, Type1_U2, 'LineWidth', line_width, 'Color', colors{1});
hold on;
plot(time_steps, Type2_U2, 'LineWidth', line_width, 'Color', colors{2});
plot(time_steps, Type3_U2, 'LineWidth', line_width, 'Color', colors{3});
plot(time_steps, Type4_U2, 'LineWidth', line_width, 'Color', colors{4});
title('Time Step vs U2 (Passenger Comfort)', 'FontSize', font_size);
xlabel('Time Step', 'FontSize', font_size);
ylabel('U2 Values', 'FontSize', font_size);
legend({'Type1', 'Type2', 'Type3', 'Type4'}, 'FontSize', font_size);
grid on;
set(gca, 'LineWidth', axis_line_width, 'FontSize', font_size);

% Plot timestep vs Totalwindow
figure;
plot(time_steps, Type1_Totalwindow, 'LineWidth', line_width, 'Color', colors{1});
hold on;
plot(time_steps, Type2_Totalwindow, 'LineWidth', line_width, 'Color', colors{2});
plot(time_steps, Type3_Totalwindow, 'LineWidth', line_width, 'Color', colors{3});
plot(time_steps, Type4_Totalwindow, 'LineWidth', line_width, 'Color', colors{4});
title('Time Step vs Total Window ON', 'FontSize', font_size);
xlabel('Time Step', 'FontSize', font_size);
ylabel('Total Window Values', 'FontSize', font_size);
legend({'Type1', 'Type2', 'Type3', 'Type4'}, 'FontSize', font_size);
grid on;
set(gca, 'LineWidth', axis_line_width, 'FontSize', font_size);
