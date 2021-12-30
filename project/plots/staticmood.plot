set term postscript eps size 10, 5 enhanced color
set output "staticmood.eps"
set title "Variance in Average Global Mood - Fixed Mood Values for All Agents"
set ylabel "Average Global Mood"
set xlabel "Number of Interactions"
set yrange [8:21]
set xrange [0:520]

plot "staticmood.dat" using 1:2 with linespoints title "Average Global Mood"

