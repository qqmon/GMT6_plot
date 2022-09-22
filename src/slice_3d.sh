#!/bin/bash


######make the irregular 3d object(in red color)
gmt grdmask -R0/4/0/4 -I0.01 -N2000/NaN/NaN -G1.grd <<EOF
2 0
2 2
4 2
4 0
EOF
gmt grd2xyz 1.grd |awk '$3==2000{print $1,$2}' |gmt grdtrack -Gseamount.grd > test.xyz
gmt xyz2grd test.xyz -R0/4/0/4 -I0.01 -Gtest.grd


######make the 2d map attachted to the 3d object
gmt project -C2/0 -E2/2 -G0.001 |awk '{print $1,$2}' | gmt grdtrack -Gseamount.grd |awk '{print $2,$3} END{print 2,-3500}' | gmt grdmask -R0/2/-3500/-2500 -I0.01/1 -NNaN/NaN/100 -Gyz.grd #grd in yx plane 

gmt project -C2/2 -E4/2 -G0.001 |awk '{print $1,$2}' | gmt grdtrack -Gseamount.grd |awk '{print $1,$3} END{print 2,-3500}' | gmt grdmask -R2/4/-3500/-2500 -I0.01/1 -NNaN/NaN/100 -Gxz.grd #grd in xx plane


#####plot begin####
gmt set FORMAT_GEO_MAP ddd.xxxxF
gmt begin map png
gmt grd2cpt test.grd -Cseis -T0/200/20 -H > 1.cpt
gmt grdview test.grd  -R1.5/2.5/1.5/2.5/-3500/-2500 -JX4c/4c  -JZ3c -p135/45 -Bxa1 -Bya1 -Bz100+l"Topo(m)" -BSEwnZ -C1.cpt -Qi
gmt grdimage yz.grd -JX4c/3c -JZ4c -R1.5/2.5/-3500/-2500/1.5/2.5 -px135/45/2 -C1.cpt -Q
gmt grdimage xz.grd -JX4c/3c -JZ4c -R1.5/2.5/-3500/-2500/1.5/2.5 -py135/45/2 -C1.cpt -Q
gmt end show

##rm

rm -rf 1.grd 2.grd test* gmt* xz.grd yz.grd 1.cpt
