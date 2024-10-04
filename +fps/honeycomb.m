function [xdata, ydata] = honeycomb(xlim, ylim, cell_radius, opts)
%HONEYCOMB Create data to plot a honeycomb grid.

    arguments
        xlim(1,2) double
        ylim(1,2) double = xlim
        cell_radius(1,1) double = diff(xlim)/10
        opts.N = 2
    end

    % hexagon center-to-perpendicular-edge distance
    apothum = cell_radius * cosd(30);

    % create two grids to represent the k and k+1 cell center points
    [xx_1, yy_1] = meshgrid(...
        xlim(1) : apothum*2 : xlim(2), ...
        ylim(1) : cell_radius*3 : ylim(2));
    [xx_2, yy_2] = meshgrid(...
        xlim(1) - apothum : apothum*2 : xlim(2) + apothum, ...
        ylim(1) - cell_radius*3/2 : cell_radius*3 : ylim(2) + cell_radius*3/2);

    x = vertcat(xx_1(:), xx_2(:));
    y = vertcat(yy_1(:), yy_2(:));

    [xdata, ydata] = fps.hexagon(x, y, cell_radius, ...
        'N', opts.N, ...
        'Rotation', 90);
end

