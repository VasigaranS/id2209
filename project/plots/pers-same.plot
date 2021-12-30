set term postscript eps size 10, 5 enhanced color
set output "pers-same.eps"
set title "Variance in Average Global Mood - Fixed Personality Values per Agent Type"
set ylabel "Average Global Mood"
set xlabel "Number of Interactions"
set yrange [10:35]
set xrange [0:650]

plot "pers-same.dat" using 1:2 with linespoints title "Average Global Mood"

