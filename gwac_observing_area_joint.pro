pro GWAC_observing_area_joint
close,/all
;inputfile=filepath('z001.dat',$
;root_dir='E:\Data\catalogue\RC3\')
;outputfile=filepath('RC3_distribution_Equatorial_z001',$
;root_dir='E:\Data\catalogue\RC3\')
;outputfile1=filepath('RC3_distribution_Galactic_z001',$
;root_dir='E:\Data\catalogue\RC3\')

;inputfile=filepath('z0015.dat',$
;root_dir='E:\Data\catalogue\RC3\')
;outputfile=filepath('RC3_distribution_Equatorial_z0015',$
;root_dir='E:\Data\catalogue\RC3\')
;outputfile1=filepath('RC3_distribution_Galactic_z0015',$
;root_dir='E:\Data\catalogue\RC3\')

;inputfile=filepath('z0024.dat',$
;root_dir='E:\Data\catalogue\RC3\')
;outputfile=filepath('RC3_distribution_Equatorial_z0024',$
;root_dir='E:\Data\catalogue\RC3\')
;outputfile1=filepath('RC3_distribution_Galactic_z0024',$
;root_dir='E:\Data\catalogue\RC3\')
;
;outputfile2=filepath('RC3_distribution_z0024_sortlist.txt',$
;root_dir='E:\Data\catalogue\RC3\')
;openw,120,outputfile2

outputfile=filepath('GWAC_observing_area_joint',$
root_dir='E:\WORK\GWAC\Survey_strategy')

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

;if(n_elements(inputfile) eq 0) then $
;message,'Argument FILE is underfined'
;str=''
;maxrec=linenum_multi_col(inputfile,str)
;close,60
;record={ID:'',rahor:0.0d,decdeg:0.0d,gallongdeg:0.0d,gallatitdeg:0.0d,$
;mBmag:0.0d,memag:0.0d,redshift:0.0d,hubstage:0.0d}
;data=replicate(record,maxrec)
;str=''
;openr,50,inputfile
;point_lun,50,0
;radeg = make_array(maxrec)
;decdeg = make_array(maxrec)
;;d_deg = make_array(maxrec)
;ragaladeg = make_array(maxrec)
;decgaladeg = make_array(maxrec)
;for i=0L, maxrec-1 do begin
;readf,50,str
;word = strsplit(str,/EXTRACT)
;data[i].ID = word[0]
;data[i].rahor = word[1]
;data[i].decdeg = word[2]
;data[i].gallongdeg = word[3]
;data[i].gallatitdeg = word[4]
;data[i].mBmag = word[5]
;data[i].memag = word[6]
;data[i].redshift = word[7]
;data[i].hubstage = word[8]
;
;radeg[i] = data[i].rahor / 24 * 360
;decdeg[i] = data[i].decdeg
;;print,i,radeg[i],decdeg[i]
;endfor
;close,50

;glactc,radeg,decdeg,2000,ragaladeg,decgaladeg,1, /degree
map_set,0,180,/aitoff,/horizon,/noerase
map_grid

rad_d = 6
;for m = 0,  (180/6)-1 do begin
;for n = 0,  (360/6)-1 do begin
for m = 1,  (180/12)-1 do begin
deccen = (m * 12) - 90

csize = 2
cthick = 2

alpha0_d = 0
beta0_d = deccen
beta1_d = beta0_d - rad_d
beta2_d = beta0_d + rad_d
d_deg = rad_d * sqrt(2.)
angular_distance_reverse,alpha0_d,beta0_d,alpha1_d_nag,alpha1_d_pos,beta1_d,d_deg
angular_distance_reverse,alpha0_d,beta0_d,alpha2_d_nag,alpha2_d_pos,beta2_d,d_deg

ra_interval = alpha1_d_pos - alpha1_d_nag
print, ra_interval,fix(360/ra_interval)
for n=0,fix(360/ra_interval)-1 do begin

alpha0_cen_d = (alpha0_d+(n*ra_interval))
angular_distance_reverse,alpha0_cen_d,beta0_d,alpha1_d_nag,alpha1_d_pos,beta1_d,d_deg
angular_distance_reverse,alpha0_cen_d,beta0_d,alpha2_d_nag,alpha2_d_pos,beta2_d,d_deg

oplot,[alpha0_cen_d,alpha0_cen_d],[beta0_d,beta0_d],$
psym=1,thick=5,$
color=0
;xyouts,25,30,'Observed area 1 (20130108)',charsize=1,color=0,charthick=cthick

oplot,[alpha1_d_nag,alpha1_d_pos],[beta1_d,beta1_d],$
linestyle=0,thick=5,color=3


oplot,[alpha2_d_nag,alpha2_d_pos],[beta2_d,beta2_d],$
linestyle=0,thick=5,color=3


oplot,[alpha1_d_nag,alpha2_d_nag],[beta1_d,beta2_d],$
linestyle=0,thick=5,color=3


oplot,[alpha1_d_pos,alpha2_d_pos],[beta1_d,beta2_d],$
linestyle=0,thick=5,color=3


;endif
endfor
endfor

close,/all
device,/close_file
print,'Done'
end