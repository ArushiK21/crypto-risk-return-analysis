%% Digital Finance – GARCH–EVT VaR for Top 5 DEX Tokens
% Workflow:
% 1) Import Loss Distribution for the 5 DEX tokens
% 2) Generate Time Series Plots
% 3) ARCH Test and ACF/PACF Plots (Step 5)
% 4) AR(1)-GARCH(1,1) Estimation and Residual Diagnostics (Step 6)
% 5) EVT on Standardized Residuals (POT Method - GPD) and Diagnostics (Step 7)
% 6) Final VaR/ES Calculation and Export to Excel
%
% Requirements: Econometrics Toolbox (for GARCH)
% Note: Does NOT require Statistics Toolbox for EVT (uses local estimation)

clear;
close all;
clc;

disp('=== STARTING GARCH-EVT RISK ANALYSIS WITH FIGURES ===');

%% CONFIGURATION
excelFile = 'DEX Data Database.xlsx';

% Sheet names (Must match Excel exactly)
sheetNames = { ...
    'Curve DAO USD', ...
    'Uniswap USD', ...
    'PancakeSwap USD', ...
    'Pendle USD', ...
    'Raydium USD'};

% Short names for output files (no spaces)
asset_names = { ...
    'CurveDAO', ...
    'Uniswap', ...
    'PancakeSwap', ...
    'Pendle', ...
    'Raydium'};

num_assets = numel(sheetNames);

% Table for final results
Results_Table = table();
rowNames = {'VaR95'; 'VaR97'; 'VaR99'; 'VaR99_9'; ...
            'ES95';  'ES97';  'ES99';  'ES99_9'};

% Create folder for figures if it doesn't exist
if ~exist('Paper_Figures', 'dir')
    mkdir('Paper_Figures');
end

%% === LOOP THROUGH ASSETS ===
for i = 1:num_assets
    
    current_sheet = sheetNames{i};
    current_asset = asset_names{i};
    
    fprintf('\n---------------------------------------------------------\n');
    fprintf('ANALYZING ASSET %d/%d: %s\n', i, num_assets, current_asset);
    
    %% 1. Data Import
    try
        opts = detectImportOptions(excelFile, 'Sheet', current_sheet);
        opts.VariableNamingRule = 'preserve';
        data_table = readtable(excelFile, opts);
        
        % Retrieve Date and Price for the first plot
        if ismember('Date', data_table.Properties.VariableNames)
            dates = data_table.Date;
        elseif ismember('Data', data_table.Properties.VariableNames)
            dates = data_table.Data;
        else
            % Generate dummy dates if missing
            dates = (1:height(data_table))'; 
        end
        
        % Retrieve Prices (assume column 'Price' or 2nd column)
        if ismember('Price', data_table.Properties.VariableNames)
            prices = data_table.Price;
        else
            prices = data_table{:, 2};
        end

        % Retrieve Loss Distribution
        if ismember('Loss Distribution', data_table.Properties.VariableNames)
            loss_col = data_table.('Loss Distribution');
        elseif ismember('LossDistribution', data_table.Properties.VariableNames)
            loss_col = data_table.LossDistribution;
        else
            loss_col = data_table{:, end};
        end
        
        % Clean data (remove NaNs and align lengths)
        idx = ~isnan(loss_col);
        losses = loss_col(idx);
        
        % Align dates and prices to the length of losses (usually n-1)
        if length(dates) > length(losses)
            dates = dates(end-length(losses)+1:end);
            prices = prices(end-length(losses)+1:end);
        end
        
    catch ME
        fprintf('IMPORT ERROR for %s: %s\n', current_sheet, ME.message);
        continue;
    end
    
    if numel(losses) < 100
        fprintf('ERROR: Insufficient data for %s.\n', current_asset);
        continue;
    end
    
    X_t = losses; 
    
    %% --- FIGURE 1: Price History and Log Returns ---
    f1 = figure('Visible','off');
    subplot(2,1,1);
    plot(dates, prices, 'LineWidth', 1); 
    title(['Historical Price - ' current_asset]); 
    grid on; ylabel('Price ($)'); axis tight;
    
    subplot(2,1,2);
    % Plot negative of losses to show actual returns
    plot(dates, -X_t, 'Color', [0.8500 0.3250 0.0980]); 
    title(['Logarithmic Returns - ' current_asset]); 
    grid on; ylabel('Log Return'); axis tight;
    
    saveas(f1, ['Paper_Figures/1_TimeSeries_' current_asset '.png']);
    close(f1);
    
    
    %% 2. ARCH Test and ACF/PACF Plots
    [h_arch, p_arch] = archtest(X_t, 'Lags', 10);
    if h_arch
        fprintf('ARCH Test: Volatility Clustering DETECTED (p=%.4f). GARCH required.\n', p_arch);
    else
        fprintf('ARCH Test: NO Volatility Clustering detected (p=%.4f). Using GARCH regardless.\n', p_arch);
    end
    
    %% --- FIGURE 2: ACF and PACF of Raw Data ---
    f2 = figure('Visible','off');
    subplot(2,1,1); 
    autocorr(X_t); 
    title(['ACF of Returns (Squared) - ' current_asset]);
    
    subplot(2,1,2); 
    parcorr(X_t); 
    title(['PACF of Returns (Squared) - ' current_asset]);
    
    saveas(f2, ['Paper_Figures/2_ACF_PACF_Raw_' current_asset '.png']);
    close(f2);
    
    
    %% 3. GARCH Estimation
    % Model: AR(1) for mean, GARCH(1,1) for variance
    Mdl = arima('ARLags', 1, 'Variance', garch(1,1));
    
    try
        [EstMdl, ~, ~] = estimate(Mdl, X_t, 'Display', 'off');
        [res, V] = infer(EstMdl, X_t);
        stdres = res ./ sqrt(V); % z_t (Standardized Residuals)
        
        [Y_fcst, ~, V_fcst] = forecast(EstMdl, 1, 'Y0', X_t);
        mu_next = Y_fcst;
        sigma_next = sqrt(V_fcst);
        
        %% --- FIGURE 3: Residual Diagnostics ---
        f3 = figure('Visible','off');
        subplot(3,1,1); 
        plot(stdres); 
        title(['Standardized Residuals - ' current_asset]); 
        axis tight; grid on;
        
        subplot(3,1,2); 
        autocorr(stdres.^2); 
        title('ACF of Squared Residuals');
        
        subplot(3,1,3); 
        qqplot(stdres); 
        title('QQ-Plot of Residuals (vs Normal)');
        
        saveas(f3, ['Paper_Figures/3_Residual_Diagnostics_' current_asset '.png']);
        close(f3);
        
    catch ME
        fprintf('GARCH ESTIMATION ERROR for %s: %s\n', current_asset, ME.message);
        continue;
    end
    
    %% 4. EVT on Residuals and Diagnostic Figures
    fprintf('Estimating EVT on standardized residuals...\n');
    
    confs = [0.95, 0.97, 0.99, 0.999];
    results_z = zeros(2, 4);
    
    try
        % Call local EVT function (with figure saving)
        evt_out = evt_pot_analysis(stdres, confs, current_asset);
        results_z = evt_out; 
    catch ME
        fprintf('EVT ERROR for %s: %s\n', current_asset, ME.message);
        continue;
    end
    
    %% 5. Final VaR/ES Calculation
    % Formula: VaR_final = mu + sigma * VaR_residual
    VaR_finali = mu_next + sigma_next * results_z(1, :)';
    ES_finali  = mu_next + sigma_next * results_z(2, :)';
    
    col_data = [VaR_finali; ES_finali];
    Results_Table.(current_asset) = col_data;
    
end

%% === FINAL OUTPUT ===
Results_Table.Properties.RowNames = rowNames;

fprintf('\n\n=========================================================\n');
fprintf('              FINAL RESULTS (VaR & ES)                \n');
fprintf('=========================================================\n');
disp(Results_Table);

outfile = 'DEX_Final_Results.xlsx';
writetable(Results_Table, outfile, 'WriteRowNames', true);
fprintf('\nResults saved to: %s\n', outfile);
fprintf('All figures saved in folder "Paper_Figures".\n');


%% ========================================================================
% LOCAL FUNCTION: EVT POT ANALYSIS WITH FIGURES
% ========================================================================
function out_matrix = evt_pot_analysis(z, confidence_levels, assetName)
    
    % 1. Isolate Right Tail (Positive values)
    z = z(:);
    pos_z = z(z > 0);
    
    % 2. Threshold Selection (90th percentile)
    u = quantile(pos_z, 0.90);
    
    % 3. Excesses
    excesses = pos_z(pos_z > u) - u;
    Nu = length(excesses);
    N = length(pos_z);
    
    if Nu < 10
        error('Too few data points in tail.');
    end
    
    % 4. GPD Estimation (Maximum Likelihood)
    nll = @(params) gpd_negloglike(params, excesses);
    start_vals = [0.1, std(excesses)];
    params_opt = fminsearch(nll, start_vals, optimset('Display','off'));
    
    xi = params_opt(1);
    sigma = params_opt(2);
    
    %% --- FIGURE 4: EVT Diagnostics (Mean Excess, QQ, PP, Tail) ---
    f_evt = figure('Visible','off');
    
    % A. Mean Excess Plot
    subplot(2,2,1);
    u_grid = linspace(min(pos_z), quantile(pos_z,0.98), 50);
    me_vals = zeros(size(u_grid));
    for k=1:length(u_grid)
        exc = pos_z(pos_z > u_grid(k)) - u_grid(k);
        me_vals(k) = mean(exc);
    end
    plot(u_grid, me_vals, 'b.-'); 
    grid on; title('Mean Excess Plot'); xlabel('Threshold u');
    
    % B. QQ-Plot GPD
    subplot(2,2,2);
    X_sorted = sort(excesses);
    n = length(X_sorted);
    p_emp = ((1:n)-0.5)/n;
    q_theo = (sigma/xi) * ((1-p_emp).^(-xi) - 1);
    plot(q_theo, X_sorted, 'o', 'MarkerSize', 4); hold on;
    plot(q_theo, q_theo, 'r--', 'LineWidth', 1.5); 
    title('QQ-Plot GPD'); grid on; xlabel('Theoretical Quantiles'); ylabel('Empirical');
    
    % C. PP-Plot GPD
    subplot(2,2,3);
    F_theo = 1 - (1 + xi*X_sorted/sigma).^(-1/xi);
    plot(F_theo, p_emp, 'o', 'MarkerSize', 4); hold on;
    plot([0 1], [0 1], 'r--', 'LineWidth', 1.5);
    title('PP-Plot GPD'); grid on; xlabel('Theoretical Prob'); ylabel('Empirical Prob');
    
    % D. Log-Log Tail Plot
    subplot(2,2,4);
    % Log-Log of Survival Function (1-CDF)
    p_surv_emp = 1 - p_emp; 
    loglog(X_sorted, p_surv_emp, 'bo', 'MarkerSize', 4); hold on;
    % Theoretical GPD line
    x_line = linspace(min(X_sorted), max(X_sorted), 100);
    y_line = (1 + xi*x_line/sigma).^(-1/xi); 
    loglog(x_line, y_line, 'r--', 'LineWidth', 1.5);
    title('Tail Plot (Log-Log)'); grid on;
    
    saveas(f_evt, ['Paper_Figures/4_EVT_Diagnostics_' assetName '.png']);
    close(f_evt);
    % ---------------------------------------------------------
    
    % 5. Calculate VaR/ES
    out_matrix = zeros(2, length(confidence_levels));
    for j = 1:length(confidence_levels)
        p = confidence_levels(j);
        term = ((N/Nu) * (1-p))^(-xi);
        var_z = u + (sigma/xi) * (term - 1);
        es_z = (var_z + sigma - xi*u) / (1-xi);
        if (1-xi) <= 0, es_z = NaN; end
        out_matrix(1, j) = var_z;
        out_matrix(2, j) = es_z;
    end
end

function nLL = gpd_negloglike(theta, x)
    xi = theta(1); sigma = theta(2);
    if sigma <= 0 || any(1 + xi*x/sigma <= 0)
        nLL = Inf; return;
    end
    n = length(x);
    if abs(xi) < 1e-6
        nLL = n*log(sigma) + sum(x)/sigma;
    else
        nLL = n*log(sigma) + (1 + 1/xi) * sum(log(1 + xi*x/sigma));
    end
end