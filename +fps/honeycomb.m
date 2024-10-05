function [xdata, ydata, x, y] = honeycomb(xlim, ylim, cell_radius, opts)
%HONEYCOMB Create data to plot a honeycomb grid.
%
%   Usage:
%
%       [xdata, ydata] = fps.HONEYCOMB(xlim, ylim, radius, opts...)
%       [xdata, ydata, xcenter, ycenter] = fps.HONEYCOMB(____)
%
%   Inputs:
%
%       xlim, ylim <1x2 double>
%           - the x and y limits of the grid to generate
%           - the lower-left corner will be the center of the first hexagon
%             in the honeycombat
%
%       radius <1x1 double>
%           - the radius of the circle that circumscribes each honeycomb cell
%
%
%   Inputs (optional param-value pairs):
%
%       'N' (=2) <1x1 uint32>
%           - the number of points used to draw each line in each hexagon
%           - this is mainly useful if the data will undergo some
%             user-defined transformation, such as spherical to cartesian
%             (see test/fps_example.m for an example)
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each hexagon, with a NaN as the last element
%           - you can use these arrays directly with plot() and line(), however
%             take note of the difference in how to make the call:
%
%                   plot(xdata, ydata)        -->   multiple line objects (slow)
%                   plot(xdata(:), ydata(:))  -->   single line object    (fast)
%
%           - the data is provided as a matrix (i.e. prior to flushing with (:))
%             so that the user has the flexibility to apply transformations, or
%             just to plot as multiple objects as some applications require
%
%       xcenter, ycenter <numeric vectors>
%           - the center point of each hexagon that was plotted
%
%   Example:
%
%       [xdata, ydata] = fps.honeycomb([1 30], [1 10], .5);
%
%       figure;
%       plot(xdata(:), ydata(:));
%       grid on
%       daspect([1 1 1])
%       xlim([1 30])
%       ylim([1 10]);
%
%   See also: FPS.HEXAGON

    arguments
        xlim(1,2) double
        ylim(1,2) double
        cell_radius(1,1) double
        opts.N(1,1) uint32 = 2
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
        'Rotation', -90);
end

