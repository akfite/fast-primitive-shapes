# fast primitive shapes (fps)

MATLAB plots get slow when bogged down with lots of objects drawn
into an axis.  One way to speed things up is to interleave `NaN`s with
your plotted data, which MATLAB interprets as a line break in the plot.
This allows you to plot multiple shapes under the same handle (i.e. the
same call to `line`, `plot`, `plot3`, etc) if you format your data to
take advantage of this trick.

This library provides functions that exploit this trick so that you don't
have to deal with reformatting your data to take advantage of this speedup.

##