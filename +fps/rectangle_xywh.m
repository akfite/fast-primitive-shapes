function [xdata, ydata] = rectangle_xywh(xywh, opts)
%RECTANGLE_XYWH Create bounding boxes from x, y, width, height vectors.
%
%   Usage:
%
%       [xdata, ydata] = FPS.RECTANGLE_XYWH(xywh, opts...)
%
%   Inputs:
%
%       xywh <Nx4 numeric>
%           - bounding box coordinate vectors as [x0 y0 width height]
%
%   Inputs (optional param-value pairs):
%
%       'N' (=2) <1x1 uint32>
%           - the number of points used to draw each line in the rectangle
%           - this is mainly useful if the data will undergo some
%             user-defined transformation, such as spherical to cartesian
%             (see test/fps_deathstar_example.m for an example)
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each rectangle, with a NaN as the last element
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
%   Examples:
%
%       [xd, yd] = fps.rectangle_xywh(reshape(1:40,[],4))
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.RECTANGLE

    arguments
        xywh(:,4) double
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
    end

    % default x,y are at x_min and y_min (top-left corner)
    x = xywh(:,1);
    y = xywh(:,2);

    % x, y radius
    xr = xywh(:,3)./2;
    yr = xywh(:,4)./2;

    % center point
    cx = x + xr;
    cy = y + yr;

    [xdata, ydata] = fps.rectangle(cx, cy, xr, yr, 'N', opts.N);

end

