%Team 9
%Module 2 Project


%% Import data from text file (This code section generated using Matlab's import functionality)
% Auto-generated by MATLAB on 17-Oct-2019 14:34:39

% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 17);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["schedule_date", "schedule_season", "schedule_week", "schedule_playoff", "team_home", "score_home", "score_away", "team_away", "team_favorite_id", "spread_favorite", "over_under_line", "stadium", "stadium_neutral", "weather_temperature", "weather_wind_mph", "weather_humidity", "weather_detail"];
opts.VariableTypes = ["datetime", "double", "double", "categorical", "categorical", "double", "double", "categorical", "string", "double", "string", "categorical", "categorical", "double", "double", "double", "string"];
opts = setvaropts(opts, 1, "InputFormat", "MM/dd/yyyy");
opts = setvaropts(opts, [9, 11, 17], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [4, 5, 8, 9, 11, 12, 13, 17], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

fn = "/spreadspoke_scores.csv";

% Import the data
game_data = readtable(fn, opts);

disp("Game data imported");
%% Clear temporary variables
clear opts



%Look only at games from 2018
r = find(game_data.schedule_season<2019);
filtered = game_data(r,:);
r = find(filtered.schedule_season>2015);
filtered = filtered(r, :);

%Change the color of the point based on how hot the weather was for that game
%Red = Temperature about 70 degrees
%Blue = Temperature at or below 70 degrees
%Set default value of the color to be blue
colors = ones(height(filtered),3);
red = [1 0 0];
blue = [0 0 1];

%Modifies the color value depending on the game time temperature using a for loop and conditional statements
for c = 1:height(filtered)
    if filtered(c,:).weather_temperature > 70
        colors(c,:) = red;
    else
        colors(c,:) = blue;
    end
end

total_score = filtered.score_home + filtered.score_away;
over_under = str2double(filtered.over_under_line);

%gscatter(over_under, total_score, colors, 'rb','.', 25);
scatter(over_under, total_score, 50, colors, 'filled');

hold on;
%refline(1, 0);
lobf = polyfit(over_under, total_score, 1);
x = linspace(35, 65);
y = polyval(lobf, x);

title("Total Score Versus Over-Under Bet");
ylabel("Total Score");
xlabel("Over-Under Bet");

%Shortcut way to display the legend with the two colors
h = zeros(3, 1);
h(1) = scatter(NaN,NaN, 50, [0 0 1],'filled');
h(2) = scatter(NaN,NaN, 50, [1 0 0],'filled');
h(3) = plot(x,y);
m = lobf(1);
b = lobf(2);
ll = sprintf('y = %.2fx + %.2f', m,b);
legend(h, 'Above 70°','Below 70°', ll, 'Position', [.85 .7 .1 .2]);

