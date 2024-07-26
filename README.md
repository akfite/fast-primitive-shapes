# fast primitive shapes (fps)

MATLAB plots get slow when bogged down with lots of objects drawn
into an axis.  One way to speed things up is to interleave `NaN`s with
your plotted data, which MATLAB interprets as a line break in the plot.
This allows you to plot multiple shapes under the same handle (i.e. the
same call to `line`, `plot`, `plot3`, etc) if you format your data to
take advantage of this trick.

This library provides functions that exploit this trick so that you don't
have to deal with reformatting your data to take advantage of this speedup.

## Examples

### fps.circle

First, we use `fps` functions to define the data to be plotted:

```
radius = 0.5;
[x, y] = meshgrid(1:10);
[xdata, ydata] = fps.circle(x(:), y(:), radius);
```

Then we can choose to either plot each shape (circle) as its own handle (which is relatively slow):
```
plot(xdata, ydata)
```

![](doc/circles_multi.png?raw=true)

But in most cases, if we want to take advantage of the power of this library we'll need to flush `xdata` and `ydata` to a column vector.  This will interleave `NaN`s between the shapes, allowing us to plot everything as one line object 🚀:

```
plot(xdata(:), ydata(:))
```
![](doc/circles_one.png?raw=true)