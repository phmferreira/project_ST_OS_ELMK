function [RMSE, NRMSE, MAPE, SMAPE] = calc_errors(target, output)

RMSE = sqrt(mse(target - output));

t_max = max(target);
t_min = min(target);
range_t = t_max - t_min;

NRMSE = RMSE/range_t;

MAPE = NaN;

if all(target != 0)

    E = target - output;
    RE = E./target;
    PE = RE;
    APE = abs(PE);
    MAPE = mean(APE);

endif

E = target - output;
AE = abs(E);
den = abs(target) + abs(output);
%den = abs(target + output);
SMAPE = 2 * mean(AE./den);

endfunction
