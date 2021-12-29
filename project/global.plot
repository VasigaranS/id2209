set term postscript eps size 10, 5 enhanced color
set output "global.eps"
set title "Variance in Average Global Mood"
set ylabel "Average Global Mood"
set xlabel "Number of Interactions"
set yrange [5:25]
set xrange [0:520]

plot "global.dat" using 1:2 with linespoints title "Number of Interactions"

