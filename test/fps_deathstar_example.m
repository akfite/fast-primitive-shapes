function fps_example

hfig = figure;
colordef(hfig, 'black'); %#ok<COLORDEF>

cone_sz = 30; % deg, diameter
clat = -20; % cone center latitude, deg
clon = 0; % cone center longitude, deg

% define all coordinates as angles in 2d, then project onto sphere
[circle_x, circle_y] = fps.circle(clon, clat, cone_sz/2, 'N', 1000);

% create a honeycomb grid inside the circle
[honeycomb_x, honeycomb_y, xc, yc] = fps.honeycomb(...
    clon+[-1 1].*cone_sz/2, ...
    clat+[-1 1].*cone_sz/2, ...
    cone_sz/10, ...
    'N', 50);

dist = sqrt((honeycomb_x - clon).^2 + (honeycomb_y - clat).^2);
honeycomb_x(dist > cone_sz/2) = nan;
honeycomb_y(dist > cone_sz/2) = nan;

% plus-sign at the center of each hexagon
[plus_x, plus_y] = fps.cross(xc, yc, cone_sz/50, cone_sz/50, 'N', 50);

dist = sqrt((plus_x - clon).^2 + (plus_y - clat).^2);
plus_x(dist > cone_sz/2) = nan;
plus_y(dist > cone_sz/2) = nan;

% connect the points to form the death ray
dist = sqrt((xc - clon).^2 + (yc - clat).^2);
xc(dist > cone_sz/2) = nan;
yc(dist > cone_sz/2) = nan;
beam_dist = 1.5;
[focus_x, focus_y, focus_z] = sph2cart(clon*pi/180, clat*pi/180, beam_dist);
focus = [focus_x focus_y focus_z];
[x,y,z] = sph2cart(xc * pi/180, yc * pi/180, 1);
[deathray_x, deathray_y, deathray_z] = fps.connect([x y z], focus);

plot3(deathray_x(:), deathray_y(:), deathray_z(:), 'g-', 'linewidth', 1, 'clipping','off');
hold on

[end_x, end_y, end_z] = sph2cart(clon*pi/180, clat*pi/180, 3*beam_dist);
[beam_x, beam_y, beam_z] = fps.connect(focus, [end_x end_y end_z]);
plot3(beam_x(:), beam_y(:), beam_z(:), 'g-', 'linewidth', 3, 'clipping', 'off');

% combine all data sources
xdata = vertcat(circle_x(:), honeycomb_x(:), plus_x(:));
ydata = vertcat(circle_y(:), honeycomb_y(:), plus_y(:));

% map to the unit sphere
[x,y,z] = sph2cart(xdata * pi/180, ydata * pi/180, 1);

% plot in 3d
plot3(x, y, z, 'g', 'clipping','off');
hold on;

% create a grid all over the unit sphere to illustrate context
[grid_x, grid_y] = fps.grid(-180:5:180, -90:5:90, 1000);

dist = sqrt((grid_x - clon).^2 + (grid_y - clat).^2);
grid_x(dist <= cone_sz/2) = nan;
grid_y(dist <= cone_sz/2) = nan;

[xg,yg,zg] = sph2cart(grid_x(:) * pi/180, grid_y(:) * pi/180, 1);
plot3(xg(:), yg(:), zg(:), 'color', 0.25*ones(1,3), 'clipping','off');


%% Format plot
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
axis vis3d
axis off
view(120,10)
camzoom(1.5)