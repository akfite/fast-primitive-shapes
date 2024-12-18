# fast primitive shapes (+fps)

Think of this library as a way to vectorize your MATLAB plots.  It allows you to create the data for multiple shapes simultaneously in a form that exploits the "NaN trick"--a quirk of MATLAB's rendering pipeline that treats NaNs as line breaks in the plot.  This effectively allows you to draw many shapes at once using a single line object, which makes the GPU rendering of your plots significantly faster (see [benchmark](#benchmark) section).

These functions can be used for general plotting, but they really shine in cases where plots need to show a ton of data and/or where the plot is interactive in an app.

This library requires `R2020b` or higher for full functionality.

## Examples

### [Death Star](./test/fps_deathstar_example.m) (advanced  example)

Let's start with a rather complex scene to get a feel for what you can do with these functions in practice.  The demo uses the `+fps` library to draw the entire scene using only 4 line objects in total (and it could easily be reduced to 3).

![](doc/deathstar.png)

**Demo takeaways:**
- if you're drawing multiple separate lines with the same format, you can simplify and vectorize your code with `+fps` functions
- you can make multiple calls to `+fps` functions to generate a set of different shapes, then concatenate them as column vectors to plot as a single line object
- while not really a shape, `fps.connect` is a quick way to draw lines connecting sets of points `P1` and `P2` (this was used to draw all the small laser beams)
- any shape can be upsampled with the optional `N` argument; this changes the number of points per line from 2 to whatever you desire.  in the Death Star example I use this to define upsampled shapes in spherical coordinates, and then transform them to cartesian to be plotted.  without the upsampling the shapes would get mangled.  it also allows for visually-exact clipping of the hexagon grid with the enclosing circle.

### Overview of the basics with [fps.circle](./+fps/circle.m)

First, use one of the`+fps` functions to define the data to be plotted:

```
radius = 0.5;
[x, y] = meshgrid(1:10);
[xdata, ydata] = fps.circle(x(:), y(:), radius);
```
Let's take a look at what we get: 

![](doc/workspace.jpg)

Our meshgrid of x & y points results in a 10x10 grid, or 100 points in total.  Calling [fps.circle](+fps/circle.m) on those arrays will request the data required to plot 100 circles.  In `xdata` and `ydata`, that's why they both have 100 columns; each column encodes the data for a separate circle.  The rows index the datapoints that compose each circle.  They each have 102 elements because by default `fps.circle` uses a [regular polygon](./+fps/regular_polygon.m) with 100 sides, with an extra vertex to close the shape and a `NaN` at the end as the line break.

If these arrays are passed as-is to `plot` or `line`, it works similarly to plotting the shapes one-by-one in a loop; i.e. MATLAB iterates over each column and plots them as a separate object.  This is effectively the same as calling `plot` in a loop, which is slow both because of the repeated calls to `plot` and because it results in a separate line object added to the axis for each circle.  It looks like this:
```
% slow!
plot(xdata, ydata)
```

![](doc/circles_multi.png)

But, if we want to take advantage of the power of these functions, we'll need to reshape `xdata` and `ydata` to column vectors using the `colon` operator.  This will interleave `NaN`s between the shapes, which will result in all of the shapes plotted under a single handle--much faster!

```
% fast!
plot(xdata(:), ydata(:))
```
![](doc/circles_one.png)

## Benchmark

Running the included script [fps_benchmark.m](./test/fps_benchmark.m), we can see why keeping the number of handles plotted to a minimum is important for performance.  Note I ran this with 15 trials and took the median, but the included script has `n_trials`=1.

![](doc/benchmark.png)
