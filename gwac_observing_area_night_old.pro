pro GWAC_observing_area_night_old
close,/all
inputfile=filepath('z0024.dat',$
root_dir='E:\Data\catalogue\RC3\')
inputfile1=filepath('z0024_redshift_rank.dat',$
root_dir='E:\Data\catalogue\RC3\')
outputfile=filepath('GWAC_observing_area_night',$
root_dir='E:\WORK\GWAC\survey_strategy\')

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

;loading data
if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={ID:'',rahor:0.0d,decdeg:0.0d,gallongdeg:0.0d,gallatitdeg:0.0d,$
mBmag:0.0d,memag:0.0d,redshift:0.0d,hubstage:0.0d}
data=replicate(record,maxrec)
str=''
openr,50,inputfile
point_lun,50,0
radeg = make_array(maxrec)
decdeg = make_array(maxrec)
;d_deg = make_array(maxrec)
ragaladeg = make_array(maxrec)
decgaladeg = make_array(maxrec)
for i=0L, maxrec-1 do begin
readf,50,str
word = strsplit(str,/EXTRACT)
data[i].ID = word[0]
data[i].rahor = word[1]
data[i].decdeg = word[2]
data[i].gallongdeg = word[3]
data[i].gallatitdeg = word[4]
data[i].mBmag = word[5]
data[i].memag = word[6]
data[i].redshift = word[7]
data[i].hubstage = word[8]

radeg[i] = data[i].rahor / 24 * 360
decdeg[i] = data[i].decdeg
;print,i,radeg[i],decdeg[i]
endfor
close,50

;ploting map
;glactc,radeg,decdeg,2000,ragaladeg,decgaladeg,1, /degree
map_set,0,180,/aitoff,/horizon,/noerase
map_grid

;ploting RC3 data
oplot,radeg,decdeg,$
;oplot,ragaladeg,decgaladeg,$
psym=1,thick=0.1,$
color=1

;RC3 galaxies redshift statistic
rad_d = 6
record1={racen:0.0d,deccen:0.0d,num:0L}
maxrec1=linenum_multi_col(inputfile1,str)
close,60
rc3_statistic=replicate(record1,maxrec1)
openr,70,inputfile1
point_lun,70,0
readf,70,rc3_statistic
for m=0L, maxrec1-1 do begin
print,rc3_statistic[m]
endfor
close,70


;j = 0
;for m = 0,  (180/5)-1 do begin
;for n = 0,  (360/5)-1 do begin
;;for m = 1,  (2)-1 do begin
;;for n = 1,  (2)-1 do begin
;deccen = (m * 5) - 90
;racen = (n * 5) 
;;rc3_statistic[j].racen = racen
;;rc3_statistic[j].deccen = deccen
;
;; declination range
;dec0 = (deccen-rad_d) > (-90.0)
;dec1 = (deccen+rad_d) < (+90.0)
;
;; RA range (overly conservative)
;  maxdec = abs(dec0) > abs(dec1)
;  cosd0 = cos(maxdec/!radeg)
;
;  IF cosd0 GT rad_d/180. THEN BEGIN 
;     ra0 = ((racen-rad_d/cosd0) + 360) MOD 360
;     ra1 = ((racen+rad_d/cosd0) + 360) MOD 360
;  ENDIF ELSE BEGIN 
;     ra0 = 0.
;     ra1 = 360.
;  ENDELSE
  
;index = where(((radeg ge ra0) and (radeg lt ra1) and (decdeg ge dec0) and (decdeg le dec1)), count)
;;where is faster than for looping 
;if(count gt 0) then begin
;num = 0L
;for p = 0L, count-1 do begin
;angular_distance,racen,deccen,radeg[index[p]],decdeg[index[p]],d_deg
;;print,racen,ra0,ra1,deccen,dec0,dec1,radeg[index[p]],decdeg[index[p]],d_deg
;if d_deg le rad_d then begin
;num=num+1
;endif
;endfor
;rc3_statistic[j].num = num
;endif
;j = j + 1
;endfor
;endfor

;;ploting the top 70 areas of most density of galaxies
;index_num = REVERSE(sort(rc3_statistic.num))
;for k=0, maxrec1-1 do begin
;;printf,120,(k+1),rc3_statistic[index_num[k]].racen,rc3_statistic[index_num[k]].deccen,rc3_statistic[index_num[k]].num
;if k lt 70 then begin
;;print,rc3_statistic[index_num[k]]
;;oplot,[rc3_statistic[index_num[k]].racen,rc3_statistic[index_num[k]].racen],[rc3_statistic[index_num[k]].deccen,rc3_statistic[index_num[k]].deccen],$
;;psym=1,thick=2,$
;;color=3
;;title_area = 'Area top'+string(k+1)
;title_area = string(k+1)
;;xyouts,rc3_statistic[index_num[k]].racen,(rc3_statistic[index_num[k]].deccen-3),title_area,charsize=1,color=0,charthick=2
;endif
;endfor


;Calculate Julian Day, Local Sidereal time
;Ploting Upper culmination of local time
Julian = SYSTIME( /JULIAN ,/UTC )
CALDAT,Julian,mon,day,year
;print,year,mon,day
newyear=JULDAY(1,1,year,0,0,0)
utc = Julian-newyear 
;utc_str = SYSTIME( /UTC )
;time = (utc - floor(utc)) * 24
;print,utc,time, '  ', utc_str
;GET_UTC, UTC

long = ten(117,34,28.35)
deta_local = ten(40,23,45.36)
local_sidereal_time,Julian,lst
alpha_local_time = lst

oplot,[alpha_local_time*15,alpha_local_time*15],[deta_local,deta_local],$
psym=1,thick=10,SYMSIZE=5,$
color=0
xyouts,alpha_local_time*15*1.01,deta_local*1.01,$
'Upper culmination of local time',charsize=1,color=0,charthick=cthick

;ploting local declination
x = indgen(360)
y = make_array(360,value=deta_local)
oplot,x,y,$
linestyle=0,thick=2,color=0

lat = float(deta_local)
;print,alpha_local_time,lat,long
zenith_solar_present = zenith(utc,lat,long)*180/3.1415926

utc_day = floor(utc)
;print,utc,deta_local,zenith_solar_present
csize = 2
cthick = 2

night_time = make_array(288)
zenith_solar_daily = make_array(288)
observing_time_alpha_local = make_array(288)
for k=0, 287 do begin
night_time[k] = float(utc_day + (k*5./60./24.))
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 100 then begin
observing_time_julian = newyear+night_time[k]
;print,k,night_time[k],zenith_solar_daily[k],Julian,observing_time_julian
local_sidereal_time,observing_time_julian,observing_time_lst
observing_time_alpha_local[k] = observing_time_lst
;print,observing_time_alpha_local[k]
oplot,[observing_time_alpha_local[k]*15,observing_time_alpha_local[k]*15],[deta_local,deta_local],$
psym=1,thick=1,SYMSIZE=1,$
color=2
endif
endfor

;help,observing_time_alpha_local
bad = where( observing_time_alpha_local LE 0, Nbad)
;remove,0,observing_time_alpha_local 
if Nbad GT 0 then begin
remove, bad, observing_time_alpha_local
endif
;help,observing_time_alpha_local
;print,observing_time_alpha_local

;oplot,[observing_time_alpha_local*15,observing_time_alpha_local*15],[deta_local,deta_local],$
;psym=1,thick=1,SYMSIZE=1,$
;color=2

dec_interval = indgen(5)*12
east_ra = make_array(5)
west_ra = make_array(5)
for y=0,5-1 do begin
step = (dec_interval[y])*0.2 + 4
east_ra[y] = ( max(observing_time_alpha_local) + step )*15
west_ra[y] = ( min(observing_time_alpha_local) -1 )*15

rad_d = 6
deccen = deta_local+dec_interval[y]
alpha0_d = west_ra[y]
beta0_d = deccen
beta1_d = beta0_d - rad_d
beta2_d = beta0_d + rad_d
d_deg = rad_d * sqrt(2.)
angular_distance_reverse,alpha0_d,beta0_d,alpha1_d_nag,alpha1_d_pos,beta1_d,d_deg
angular_distance_reverse,alpha0_d,beta0_d,alpha2_d_nag,alpha2_d_pos,beta2_d,d_deg
ra_interval = alpha1_d_pos - alpha1_d_nag
;print, ra_interval,fix(360/ra_interval)
for n=0,fix((east_ra[y]-west_ra[y])/ra_interval) do begin
alpha0_cen_d = (alpha0_d+(n*ra_interval))
glactc,alpha0_cen_d,beta0_d,2000,gl_deg,gb_deg,1, /degree
if abs(gb_deg) ge 20 then begin
angular_distance_reverse,alpha0_cen_d,beta0_d,alpha1_d_nag,alpha1_d_pos,beta1_d,d_deg
angular_distance_reverse,alpha0_cen_d,beta0_d,alpha2_d_nag,alpha2_d_pos,beta2_d,d_deg
;oplot,[alpha0_cen_d,alpha0_cen_d],[beta0_d,beta0_d],$
;psym=1,thick=5,$
;color=3
;oplot,[alpha1_d_nag,alpha1_d_pos],[beta1_d,beta1_d],$
;linestyle=0,thick=5,color=3
;oplot,[alpha2_d_nag,alpha2_d_pos],[beta2_d,beta2_d],$
;linestyle=0,thick=5,color=3
;oplot,[alpha1_d_nag,alpha2_d_nag],[beta1_d,beta2_d],$
;linestyle=0,thick=5,color=3
;oplot,[alpha1_d_pos,alpha2_d_pos],[beta1_d,beta2_d],$
;linestyle=0,thick=5,color=3
endif
endfor

endfor

oplot,east_ra,dec_interval+deta_local,$
linestyle=0,thick=2,color=1
oplot,west_ra,dec_interval+deta_local,$
linestyle=0,thick=2,color=1

dec_interval = indgen(6)*12
east_ra = make_array(6)
west_ra = make_array(6)
for y=0,6-1 do begin
step = 4 - (dec_interval[y])*0.05
east_ra[y] = ( max(observing_time_alpha_local) + step )*15
west_ra[y] = ( min(observing_time_alpha_local) -1 )*15

rad_d = 6
deccen = deta_local-dec_interval[y]
alpha0_d = west_ra[y]
beta0_d = deccen
beta1_d = beta0_d - rad_d
beta2_d = beta0_d + rad_d
d_deg = rad_d * sqrt(2.)
angular_distance_reverse,alpha0_d,beta0_d,alpha1_d_nag,alpha1_d_pos,beta1_d,d_deg
angular_distance_reverse,alpha0_d,beta0_d,alpha2_d_nag,alpha2_d_pos,beta2_d,d_deg
ra_interval = alpha1_d_pos - alpha1_d_nag
;print, ra_interval,fix(360/ra_interval)
for n=0,fix((east_ra[y]-west_ra[y])/ra_interval) do begin
alpha0_cen_d = (alpha0_d+(n*ra_interval))
glactc,alpha0_cen_d,beta0_d,2000,gl_deg,gb_deg,1, /degree
if abs(gb_deg) ge 20 then begin
angular_distance_reverse,alpha0_cen_d,beta0_d,alpha1_d_nag,alpha1_d_pos,beta1_d,d_deg
angular_distance_reverse,alpha0_cen_d,beta0_d,alpha2_d_nag,alpha2_d_pos,beta2_d,d_deg
;oplot,[alpha0_cen_d,alpha0_cen_d],[beta0_d,beta0_d],$
;psym=1,thick=5,$
;color=3
;oplot,[alpha1_d_nag,alpha1_d_pos],[beta1_d,beta1_d],$
;linestyle=0,thick=5,color=3
;oplot,[alpha2_d_nag,alpha2_d_pos],[beta2_d,beta2_d],$
;linestyle=0,thick=5,color=3
;oplot,[alpha1_d_nag,alpha2_d_nag],[beta1_d,beta2_d],$
;linestyle=0,thick=5,color=3
;oplot,[alpha1_d_pos,alpha2_d_pos],[beta1_d,beta2_d],$
;linestyle=0,thick=5,color=3

;if 
;
;endif

endif
endfor
endfor

oplot,east_ra,deta_local-dec_interval,$
linestyle=0,thick=2,color=1
oplot,west_ra,deta_local-dec_interval,$
linestyle=0,thick=2,color=1

;oplot,[west_ra[5],east_ra[5]],[deta_local-dec_interval[5],deta_local-dec_interval[5]],$
oplot,[180,east_ra[5]],[deta_local-dec_interval[5],deta_local-dec_interval[5]],$
linestyle=0,thick=2,color=1
oplot,[west_ra[5],180],[deta_local-dec_interval[5],deta_local-dec_interval[5]],$
linestyle=0,thick=2,color=1
print,east_ra[5],west_ra[5],deta_local-dec_interval[5]





xyouts,5,0,'0',charsize=csize,color=0,charthick=cthick
xyouts,180,0,'180',charsize=csize,color=0,charthick=cthick
xyouts,330,0,'360',charsize=csize,color=0,charthick=cthick
xyouts,180,80,'N',charsize=csize,color=0,charthick=cthick
xyouts,180,-90,'S',charsize=csize,color=0,charthick=cthick
xyouts,90,-40,'Equatorial coordinate system',charsize=csize,color=0,charthick=cthick
;xyouts,90,-50,'z < 0.01',charsize=csize,color=0,charthick=cthick
;xyouts,90,-50,'z < 0.015',charsize=csize,color=0,charthick=cthick
xyouts,90,-50,'z < 0.024',charsize=csize,color=0,charthick=cthick


close,/all
device,/close_file
print,'Done'
end