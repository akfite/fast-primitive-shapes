function fps_deathstar_example()
%FPS_DEATHSTAR_EXAMPLE Just a fun demo to illustrate usage of the FPS library.
%
%   A few notes about usage:
%
%       * each function in +fps returns data that can be passed directly to line(),
%         plot(), or plot3(); they intentionally do not do any plotting themselves
%       * the data will be an MxN array where M-1 is the number of vertices and
%         N is the number of distinct shapes to plot
%       * there are ways to make this same kind of graphic with surfaces etc, but the
%         point of this library is to enable plotting complex geometry very efficiently,
%         using only line objects
%       * for all +fps functions, you may reshape to column vectors and concatenate
%         to merge objects into a single handle
%
%           e.g.
%                   [xd1, yd1, ...] = fps(...)
%                   [xd2, yd2, ...] = fps(...)
%                   xd = [xd1(:); xd2(:)];
%                   yd = [yd1(:); yd2(:)];
%                   ...
%                   plot(xd, yd, ...)
%
%       * this example uses a lot of spherical to cartesian transforms to illustrate
%         why you might want to draw component lines with more than 2 datapoints (see
%         the optional "N" parameter in most functions)
%
%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

%% Setup params
cone_sz = 30; % deg, diameter of circle on unit sphere
clat = -20; % cone center latitude, deg
clon = 0; % cone center longitude, deg
honeycomb_cell_radius = 3; % degrees

%% Define the sphere

% create a grid all over the unit sphere to illustrate context
[grid_x, grid_y] = fps.grid(-180:5:180, -90:5:90, 1000);

% clear out the area where we'll draw the death ray
dist = sqrt((grid_x - clon).^2 + (grid_y - clat).^2);
grid_x(dist <= cone_sz/2) = nan;
grid_y(dist <= cone_sz/2) = nan;
[sphere_x,sphere_y,sphere_z] = sph2cart(grid_x(:) * pi/180, grid_y(:) * pi/180, 1);

%% Define the death ray
[circle_x, circle_y] = fps.circle(clon, clat, cone_sz/2, ...
    'N', 1000);

% create a honeycomb grid inside the circle (I know there's not actually a
% honeycomb in the Deathstar; we're just having fun here)
[honeycomb_x, honeycomb_y, xc, yc] = fps.honeycomb(...
    clon+[-1 1].*cone_sz/2, ...
    clat+[-1 1].*cone_sz/2, ...
    honeycomb_cell_radius, ...
    'N', 50); % upsample 

% the grid is a rectangle; prune points to make it fit inside the circle
dist = sqrt((honeycomb_x - clon).^2 + (honeycomb_y - clat).^2);
honeycomb_x(dist > cone_sz/2) = nan;
honeycomb_y(dist > cone_sz/2) = nan;

% create a cross at the center of each hexagon (because why not)
[plus_x, plus_y] = fps.cross(xc, yc, cone_sz/50, cone_sz/50, ...
    'N', 50, ...
    'Rotation', 45);

% again prune points outside the circle
dist = sqrt((plus_x - clon).^2 + (plus_y - clat).^2);
plus_x(dist > cone_sz/2) = nan;
plus_y(dist > cone_sz/2) = nan;

% connect the points from the center of each hexagon to the ray extending from
% the center (to create the beam-joining effect)
dist = sqrt((xc - clon).^2 + (yc - clat).^2);
xc(dist > cone_sz/2) = nan;
yc(dist > cone_sz/2) = nan;
beam_dist = 1.5;
[focus_x, focus_y, focus_z] = sph2cart(clon*pi/180, clat*pi/180, beam_dist);
focus = [focus_x focus_y focus_z];
[x,y,z] = sph2cart(xc * pi/180, yc * pi/180, 1);
[deathray_x, deathray_y, deathray_z] = fps.connect([x y z], focus);

% add a thicker green beam out the center as the main pewpew
[end_x, end_y, end_z] = sph2cart(clon*pi/180, clat*pi/180, 3*beam_dist);
[beam_x, beam_y, beam_z] = fps.connect(focus, [end_x end_y end_z]);

%% Draw the Deathstar
hfig = figure('name','+fps library demo');
colordef(hfig, 'black'); %#ok<COLORDEF>

plot3(sphere_x(:), sphere_y(:), sphere_z(:), 'color', 0.25*ones(1,3), 'clipping','off');
hold on

% merge a few data sources into a single handle (just for example)
xdata = vertcat(circle_x(:), honeycomb_x(:), plus_x(:));
ydata = vertcat(circle_y(:), honeycomb_y(:), plus_y(:));
[x,y,z] = sph2cart(xdata * pi/180, ydata * pi/180, 1);
plot3(x, y, z, 'g-', 'clipping','off');

plot3(deathray_x(:), deathray_y(:), deathray_z(:), 'g-', 'linewidth', 1, 'clipping','off');
plot3(beam_x(:), beam_y(:), beam_z(:), 'g-', 'linewidth', 3, 'clipping', 'off');

xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
axis vis3d
axis off
view(120,10)
camzoom(1.5)
rotate3d on
