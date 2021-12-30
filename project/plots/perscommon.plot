set term postscript eps size 10, 5 enhanced color
set output "perscommon.eps"
set title "Variance in Average Global Mood - Fixed Personality Value for All Agents (1.0)"
set ylabel "Average Global Mood"
set xlabel "Number of Interactions"
set yrange [10:25]
set xrange [0:600]

plot "perscommon.dat" using 1:2 with linespoints title "Average Global Mood"

