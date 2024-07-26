%% setup
n_trials = 1;
n_objects = unique(ceil(logspace(0, 4, 100)));

%% run sim
clear dt_*
dt_onehandle = nan(numel(n_objects), n_trials);
dt_multhandle = nan(numel(n_objects), n_trials);

hfig = figure;
ax = axes('parent',hfig);

for trial = 1:n_trials
    fprintf('Trial %d of %d:\n', trial, n_trials);
    for run = 1:numel(n_objects)
        n = n_objects(run);
        fprintf('\tn = %d\n', n);
        
        % create the data to plot
        [xd,yd] = fps.square(rand(n,1), rand(n,1), 1);

        % multiple handles (plot in loop to simulate how we usually call line)
        cla(ax);
        dt = 0;
        for i = 1:n
            xdata = xd(:,i);
            ydata = yd(:,i);

            t = tic;
            line(ax, xdata, ydata);
            dt = dt + toc(t);
        end
        dt_multhandle(run, trial) = dt;
    
        % one handle
        cla(ax);

        t = tic;
        line(ax, xd(:), yd(:));
        dt = toc(t);
        dt_onehandle(run, trial) = dt;

        pause(1e-6);
    end
end

delete(hfig);

%% plot results

hfig = figure;
ax = axes('Parent',hfig, 'YScale', 'log', 'XScale', 'log', 'NextPlot','add');

h_multi = plot(ax, n_objects, median(dt_multhandle, 2), '.-');
h_one = plot(ax, n_objects, median(dt_onehandle, 2), '.-');

grid(ax,'on');
box(ax,'on');
title(ax,'time to plot n rectangles');
xlabel('number of rectangles in plot');
ylabel('time to plot (sec)');
legend([h_multi h_one], {'multiple handles','one handle'});
