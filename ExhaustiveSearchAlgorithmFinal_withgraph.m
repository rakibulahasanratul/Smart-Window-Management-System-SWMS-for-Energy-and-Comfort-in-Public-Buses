% Load df_final from the CSV file
df_final = readtable('df_final.csv');

% Print the height of df_final to verify the number of time steps
fprintf('Total number of time steps: %d\n', height(df_final));

% Initialize an empty table to store all results
all_results = [];

% Perform calculations for each time step
for t = 1:height(df_final)
    fprintf('Processing time step %d of %d\n', t, height(df_final));
    % Calculate the selection for the current time step
    selected_combination = calculate_selection_for_df_final(df_final, t);
    
    % Add the current time step to the selected combination table
    selected_combination.TimeStep = t;
    
    % Append the current selected combination to the overall results
    all_results = [all_results; selected_combination];
end

% Save the combined results to a new CSV file
timestamp = datestr(now, 'yyyymmdd_HHMMSS');
filename = ['df_final_selected_comb_table_' timestamp '.csv'];
writetable(all_results, filename);

fprintf('Combined results saved to %s\n', filename);

% Set font size and line width for plots
fontSize = 16;
lineWidth = 2;
axisFontSize = 16;

% Plot U over time steps
figure;
plot(all_results.TimeStep, all_results.U, 'DisplayName', 'U', 'Color', 'b','LineWidth', lineWidth);
legend;
title('Combined objective function U : thermal comfort and energy efficiency', 'FontSize', 20);
xlabel('Time Step', 'FontSize', 20);
ylabel('Value', 'FontSize', 20);
set(gca, 'FontSize', axisFontSize);

% Plot U1 (Fuel Consumption) over time steps
figure;
plot(all_results.TimeStep, all_results.U1_fuel_Consumption, 'DisplayName', 'U1 Fuel Consumption', 'Color', 'b','LineWidth', lineWidth);
legend;
title('Fuel Consumption (U1) over Time Steps', 'FontSize', fontSize);
xlabel('Time Step', 'FontSize', fontSize);
ylabel('Fuel Consumption (U1)', 'FontSize', fontSize);
set(gca, 'FontSize', axisFontSize);

% Plot PMV over time steps with specified colors and line thickness
figure;
plot(all_results.TimeStep, df_final.LeftPMV, 'DisplayName', 'Left side', 'Color', [0 0.5 0], 'LineWidth', lineWidth);
hold on;
plot(all_results.TimeStep, df_final.RightPMV, 'DisplayName', 'Right Side', 'Color', 'r', 'LineWidth', lineWidth);
plot(all_results.TimeStep, all_results.U2_Comfort, 'DisplayName', 'ESA Optimization', 'Color','b' , 'LineWidth', lineWidth); % Dark green color
yline(-1, '--', 'Lower Limit', 'Color', 'k', 'LineWidth', lineWidth);
yline(1, '--', 'Upper Limit', 'Color', 'k', 'LineWidth', lineWidth);
legend;
title('Thermal comfort level comparison: U2', 'FontSize', fontSize);
xlabel('Time Step', 'FontSize', fontSize);
ylabel('PMV', 'FontSize', fontSize);
set(gca, 'FontSize', axisFontSize);

% Plot the number of windows ON over time steps
figure;
plot(all_results.TimeStep, all_results.WindowON, 'DisplayName', 'Total','Color', 'b', 'LineWidth', lineWidth);
legend;
title('Number of Windows ON: Total', 'FontSize', fontSize);
xlabel('Time Step', 'FontSize', fontSize);
ylabel('Count', 'FontSize', fontSize);
set(gca, 'FontSize', axisFontSize);

% Plot the number of windows ON on each side over time steps
figure;
plot(all_results.TimeStep, all_results.LeftWindowON, 'DisplayName', 'Left Side', 'Color', 'b', 'LineWidth', lineWidth);
hold on;
plot(all_results.TimeStep, all_results.RightWindowON, 'DisplayName', 'Right Side', 'Color', 'r', 'LineWidth', lineWidth);
legend;
title('Number of Windows ON: ESA Optimization', 'FontSize', fontSize);
xlabel('Time Step', 'FontSize', fontSize);
ylabel('Count', 'FontSize', fontSize);
set(gca, 'FontSize', axisFontSize);

function selected_combination = calculate_selection_for_df_final(df_final, t)
    % Number of windows
    num_windows = 12;

    % Generate all possible combinations
    combinations = dec2bin(0:(2^num_windows - 1)) - '0';

    % Initialize arrays to store the count of zeros and ones
    num_combinations = size(combinations, 1);
    zeros_count = zeros(num_combinations, 1);
    ones_count = zeros(num_combinations, 1);
    left_zeros_count = zeros(num_combinations, 1);
    left_ones_count = zeros(num_combinations, 1);
    right_zeros_count = zeros(num_combinations, 1);
    right_ones_count = zeros(num_combinations, 1);

    % Constants for mu calculation
    N_total = 12; % Total number of windows
    N_total_left = 6; % Total number of left side windows
    N_total_right = 6; % Total number of right side windows
    SHGC_off = 0.68; % Solar heat gain coefficient when windows are off
    SHGC_on = 0.60; % Solar heat gain coefficient when windows are on

    % Constants for power calculation
    P_sw_base = 2.979; % in Watts
    delta_k = 300; % time step in seconds

    % Constants for HVAC consumption calculation
    E_HVAC_base = 1.6; % HVAC base energy in Watts

    % Constants for U1 calculation
    c_fs = 165; % Fuel consumption rate of standard diesel engine g/kW/h
    rho = 836; % Density of fuel g/L
    c_gallon = 3.78541; % Conversion factor from liters to gallons

    % Initialize arrays to store power consumption
    window_power_consumption = zeros(num_combinations, 1);
    left_window_power_consumption = zeros(num_combinations, 1);
    right_window_power_consumption = zeros(num_combinations, 1);

    % Initialize arrays to store SHGC calculations
    mu_total = zeros(num_combinations, 1);
    mu_left = zeros(num_combinations, 1);
    mu_right = zeros(num_combinations, 1);

    % Initialize arrays to store HVAC and total energy consumption
    HVAC_consumption = zeros(num_combinations, 1);
    total_energy_consumption = zeros(num_combinations, 1);

    % Initialize arrays to store additional calculations
    total_energy_consumption_kwh = zeros(num_combinations, 1);
    U1 = zeros(num_combinations, 1);

    % Count zeros and ones and calculate power consumption and SHGC for each combination
    for i = 1:num_combinations
        zeros_count(i) = sum(combinations(i, :) == 0);
        ones_count(i) = sum(combinations(i, :) == 1);
        left_zeros_count(i) = sum(combinations(i, 1:6) == 0);
        left_ones_count(i) = sum(combinations(i, 1:6) == 1);
        right_zeros_count(i) = sum(combinations(i, 7:12) == 0);
        right_ones_count(i) = sum(combinations(i, 7:12) == 1);

        % Calculate power consumption
        window_power_consumption(i) = ((zeros_count(i) * 0 + ones_count(i) * P_sw_base) * delta_k) / 3600;
        left_window_power_consumption(i) = ((left_zeros_count(i) * 0 + left_ones_count(i) * P_sw_base) * delta_k) / 3600;
        right_window_power_consumption(i) = ((right_zeros_count(i) * 0 + right_ones_count(i) * P_sw_base) * delta_k) / 3600;

        % Calculate SHGC
        x = combinations(i, :);
        x_left = combinations(i, 1:6);
        x_right = combinations(i, 7:12);

        mu_total(i) = (N_total * SHGC_off - sum(x * SHGC_on + (1 - x) * SHGC_off)) / (N_total * SHGC_off);
        mu_left(i) = (N_total_left * SHGC_off - sum(x_left * SHGC_on + (1 - x_left) * SHGC_off)) / (N_total_left * SHGC_off);
        mu_right(i) = (N_total_right * SHGC_off - sum(x_right * SHGC_on + (1 - x_right) * SHGC_off)) / (N_total_right * SHGC_off);

        % Calculate HVAC consumption and total energy consumption
        HVAC_consumption(i) = E_HVAC_base * delta_k * (1 - mu_total(i));
        total_energy_consumption(i) = HVAC_consumption(i) + window_power_consumption(i);

        % Calculate additional columns
        total_energy_consumption_kwh(i) = total_energy_consumption(i) / 1000;
        U1(i) = (total_energy_consumption_kwh(i) * c_fs / rho) / c_gallon;
    end

    % Extract necessary columns from df_final for the current time step
    left_PMV = (left_ones_count * df_final.LeftPMV(t) + left_zeros_count * df_final.PMV(t)) / N_total_left;
    right_PMV = (right_ones_count * df_final.RightPMV(t) + right_zeros_count * df_final.PMV(t)) / N_total_right;

    % Calculate U2_Comfort and U
    U2_Comfort = (left_PMV + right_PMV) / 2;
    alpha1 = 0.8;
    alpha2 = 0.2;
    U = alpha1 * U2_Comfort - alpha2 * U1;

    % Apply selection logic
    selection = repmat('N', num_combinations, 1);
    valid_indices = find(left_PMV > -1 & left_PMV < 1 & ...
                         right_PMV > -1 & right_PMV < 1 & ...
                         HVAC_consumption > 0 & HVAC_consumption < 480 & ...
                         window_power_consumption > 0 & window_power_consumption < 3);

    if ~isempty(valid_indices)
        % Select the combination with the maximum U
        [~, max_index] = max(U(valid_indices));
        selected_index = valid_indices(max_index);
        selection(selected_index) = 'Y';

        % Randomly choose one if there are multiple valid selections
        if numel(selected_index) > 1
            selection(selected_index(2:end)) = 'N';
        end
    else
        % If no feasible solution is found, select the first combination as 'Y'
        selection(1) = 'Y';
    end

    % Create a table to display the combinations with counts, power consumption, SHGC, and selection
    comb_table = array2table([(1:num_combinations)' combinations], ...
        'VariableNames', ['Combination', arrayfun(@(x) sprintf('Window%d', x), 1:num_windows, 'UniformOutput', false)]);
    comb_table.WindowOFF = zeros_count;
    comb_table.WindowON = ones_count;
    comb_table.LeftWindowOFF = left_zeros_count;
    comb_table.LeftWindowON = left_ones_count;
    comb_table.RightWindowOFF = right_zeros_count;
    comb_table.RightWindowON = right_ones_count;
    comb_table.TotalWindowPowerConsumption = window_power_consumption;
    comb_table.LeftWindowPowerConsumption = left_window_power_consumption;
    comb_table.RightWindowPowerConsumption = right_window_power_consumption;
    comb_table.mu_total = mu_total;
    comb_table.mu_left = mu_left;
    comb_table.mu_right = mu_right;
    comb_table.HVACConsumption = HVAC_consumption;
    comb_table.TotalEnergyConsumption = total_energy_consumption;
    comb_table.TotalEnergyConsumption_kWH = total_energy_consumption_kwh;
    comb_table.U1_fuel_Consumption = U1;
    comb_table.LeftsidePMV = left_PMV;
    comb_table.RightsidePMV = right_PMV;
    comb_table.U2_Comfort = U2_Comfort;
    comb_table.U = U;
    comb_table.Selection = selection;

    % Extract only the selected combination
    selected_combination = comb_table(selection == 'Y', :);
end
