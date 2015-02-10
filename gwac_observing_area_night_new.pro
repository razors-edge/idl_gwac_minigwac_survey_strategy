pro GWAC_observing_area_night_new
close,/all
inputfile=filepath('z0024_galalaticut.dat',$
root_dir='E:\Data\catalogue\RC3\')
inputfile1=filepath('Mini-GWAC_observing_area_statistic.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile=filepath('Mini-GWAC_observing_area_night_M1',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile1=filepath('Mini-GWAC_observing_area_night_M1.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile2=filepath('Mini-GWAC_observing_area_night_rank_M1.dat',$
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
maxrec=FILE_LINES(inputfile)
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

;loading data
if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
maxrec1=FILE_LINES(inputfile1)
record1={alpha0_cen_d:0.0d,beta0_d:0.0d,alpha1_d_nag:0.0d,alpha1_d_pos:0.0d,$
beta_low:0.0d,alpha2_d_nag:0.0d,alpha2_d_pos:0.0d,beta_high:0.0d,count:0L}
data1=replicate(record1,maxrec1)
str=''
openr,50,inputfile1
point_lun,50,0
readf,50,data1
;for i=0L, maxrec1-1 do begin
;print,i,data1[i].alpha0_cen_d,data1[i].beta0_d,data1[i].count
;endfor
close,50

openw,120,outputfile2,width=3000

;ploting map
;glactc,radeg,decdeg,2000,ragaladeg,decgaladeg,1, /degree
map_set,0,180,/aitoff,/horizon,/noerase
map_grid

;ploting RC3 data
oplot,radeg,decdeg,$
;oplot,ragaladeg,decgaladeg,$
psym=1,thick=0.01,$
color=0

;Calculate Julian Day, Local Sidereal time
;Ploting Upper culmination of local time
Julian = SYSTIME( /JULIAN ,/UTC )
Julian = Julian + 0.5
print,Julian
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
;print,Julian
local_sidereal_time,long,Julian,lst
;CT2LST, lst, long, 8, Julian
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

night_number = 288 ; every 5 munitues.
night_time = make_array(night_number)
zenith_solar_daily = make_array(night_number)
observing_time_alpha_local = make_array(night_number)
for k=0, night_number-1 do begin
night_time[k] = float(utc_day + (k*5./60./24.))
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
;print,k,night_time[k],zenith_solar_daily[k]
if zenith_solar_daily[k] gt 100 then begin
observing_time_julian = newyear+night_time[k]
;print,k,night_time[k],zenith_solar_daily[k],Julian,observing_time_julian
local_sidereal_time,long,observing_time_julian,observing_time_lst
;CT2LST, observing_time_lst, long, 8, observing_time_julian
observing_time_alpha_local[k] = observing_time_lst
;print,observing_time_alpha_local[k]
oplot,[observing_time_alpha_local[k]*15,observing_time_alpha_local[k]*15],[deta_local,deta_local],$
psym=1,thick=1,SYMSIZE=1,$
color=2
endif
;print,observing_time_alpha_local[k]
endfor


bad = where( observing_time_alpha_local LE 0, Nbad)
;remove,0,observing_time_alpha_local 
if Nbad GT 0 then begin
remove, bad, observing_time_alpha_local
endif
;help,observing_time_alpha_local
;print,observing_time_alpha_local

oplot,[observing_time_alpha_local*15,observing_time_alpha_local*15],[deta_local,deta_local],$
psym=1,thick=3,SYMSIZE=1,$
color=2

;A mini-gwac mount VOF is 20 degrees in ra and 40 degrees in dec
dec_interval = indgen(2) * 40
rad_d = 10
east_ra = make_array(2)
west_ra = make_array(2)
;from 40 degree north latitude to 90 degree north pole, there
; are 2 steps, the interval of 40 degrees between each two steps
for z=0,2-1 do begin
;the observable area is larger toward north, so 
; the ra_step is wider at north
;for example, the observable area is doubled when going 
;each 40 degrees to the north.

beta0_d = deta_local + dec_interval[z] + 20 
beta1_d = beta0_d - (rad_d*2)
beta2_d = beta0_d + (rad_d*2)

;observing 4 hours to the east at dawn
east_ra[z] = ( max(observing_time_alpha_local) + ( 4 * ( z + 1) )) * 15 
;observing 1 hours to the west at dust
west_ra[z] = ( min(observing_time_alpha_local) - ( 1 * ( z + 1) ) )* 15
;print,east_ra[z],west_ra[z],beta0_d,beta1_d,beta2_d

if z ne 1 then begin
if east_ra[z] le 360.0 and west_ra[z] ge 0.0 then begin
east = east_ra[z]
west = west_ra[z]
;print,east,west,beta0_d,beta1_d,beta2_d
count = 0
index = where(((data1.alpha0_cen_d ge west) and (data1.alpha0_cen_d lt east) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif
;print,'case1'
endif

if east_ra[z] gt 360.0 and west_ra[z] ge 0.0 then begin
east = east_ra[z] - 360.0
west = west_ra[z]
;print,east,west,beta0_d,beta1_d,beta2_d
count=0
index = where(((data1.alpha0_cen_d ge west) and (data1.alpha0_cen_d lt 360.) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif

count=0
index = where(((data1.alpha0_cen_d ge 0) and (data1.alpha0_cen_d lt east) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif
;print,'case2'
endif

if east_ra[z] lt 360.0 and west_ra[z] lt 0.0 then begin
east = east_ra[z]
west = west_ra[z] + 360.0
;print,east,west,beta0_d,beta1_d,beta2_d
count=0
index = where(((data1.alpha0_cen_d ge 0) and (data1.alpha0_cen_d lt east) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif

count=0
index = where(((data1.alpha0_cen_d ge west) and (data1.alpha0_cen_d lt 360) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif
;print,'case3'
endif

endif
endfor



;print enveloping line of survey area
oplot,east_ra,dec_interval+deta_local,$
linestyle=0,thick=4,color=1
oplot,west_ra,dec_interval+deta_local,$
linestyle=0,thick=2,color=1


dec_interval = indgen(3)*40
east_ra = make_array(3)
west_ra = make_array(3)
for z=0,3-1 do begin
beta0_d = deta_local - dec_interval[z] - 20
beta1_d = beta0_d - (rad_d*2)
beta2_d = beta0_d + (rad_d*2)
step = 4 - (dec_interval[z])*0.05
east_ra[z] = ( max(observing_time_alpha_local) + step )*15
west_ra[z] = ( min(observing_time_alpha_local) -1 )*15
;print,east_ra[z],west_ra[z],beta0_d,beta1_d,beta2_d
if z ne 2 then begin
if east_ra[z] le 360.0 and west_ra[z] ge 0.0 then begin
east = east_ra[z]
west = west_ra[z]
;print,east,west,beta0_d,beta1_d,beta2_d
count = 0
index = where(((data1.alpha0_cen_d ge west) and (data1.alpha0_cen_d lt east) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif
;print,'case1'
endif

if east_ra[z] gt 360.0 and west_ra[z] ge 0.0 then begin
east = east_ra[z] - 360.0
west = west_ra[z]
;print,east,west,beta0_d,beta1_d,beta2_d
count=0
index = where(((data1.alpha0_cen_d ge west) and (data1.alpha0_cen_d lt 360.) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif

count=0
index = where(((data1.alpha0_cen_d ge 0) and (data1.alpha0_cen_d lt east) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif
;print,'case2'
endif

if east_ra[z] lt 360.0 and west_ra[z] lt 0.0 then begin
east = east_ra[z]
west = west_ra[z] + 360.0
;print,east,west,beta0_d,beta1_d,beta2_d
count=0
index = where(((data1.alpha0_cen_d ge 0) and (data1.alpha0_cen_d lt east) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif

count=0
index = where(((data1.alpha0_cen_d ge west) and (data1.alpha0_cen_d lt 360) $
and (data1.beta0_d ge beta1_d) and (data1.beta0_d le beta2_d)), count)
;where is faster than for looping 
if count gt 0 then begin
;print,count,index
;print,'count',count,index
;print,'data',data1[index].count
for x = 0, count-1 do begin
printf,120,data1[index[x]].alpha0_cen_d,data1[index[x]].beta0_d,$
data1[index[x]].alpha1_d_nag,data1[index[x]].alpha1_d_pos,$
data1[index[x]].beta_low,data1[index[x]].alpha2_d_nag,data1[index[x]].alpha2_d_pos,$
data1[index[x]].beta_high,data1[index[x]].count
endfor
endif
;print,'case3'
endif

endif
endfor



;print enveloping line of survey area
;print,dec_interval[2],deta_local,east_ra[2],west_ra[2],deta_local-dec_interval[2]
oplot,east_ra,deta_local-dec_interval,$
linestyle=0,thick=4,color=1
oplot,west_ra,deta_local-dec_interval,$
linestyle=0,thick=4,color=1
;oplot,[west_ra[2],east_ra[2]],[deta_local-dec_interval[2],$
;deta_local-dec_interval[2]],$
;linestyle=0,thick=4,color=1
oplot,[east_ra[2],west_ra[2]],[deta_local-dec_interval[2],$
deta_local-dec_interval[2]],$
linestyle=0,thick=4,color=1

close,120


maxrec2 = FILE_LINES(outputfile2)
openr,120,outputfile2
rc3_statistic = make_array(9,maxrec2)
readf,120,rc3_statistic
close,120

multicolumnsort,rc3_statistic,index=[8],revert=[8]
;print,rc3_statistic
openw,121,outputfile2,width=3000
printf,121,rc3_statistic
close,121

;for o=0, 23 do begin
;oplot,[rc3_statistic[0,o],rc3_statistic[0,o]],$
;[rc3_statistic[1,o],rc3_statistic[1,o]],$
;psym=1,thick=5,SYMSIZE=3,$
;color=color
;endfor

o=0
for t=0,1 do begin
color = t+1
for s=0, 5 do begin
o = o+1
oplot,[rc3_statistic[0,o],rc3_statistic[0,o]],$
[rc3_statistic[1,o],rc3_statistic[1,o]],$
psym=1,thick=5,SYMSIZE=3,$
color=color
;print,rc3_statistic[0,o],rc3_statistic[1,o]

;oplot,[rc3_statistic[2,o],rc3_statistic[3,o]],$
;[rc3_statistic[4,o],rc3_statistic[4,o]],$
;linestyle=0,thick=5,color=color
;oplot,[rc3_statistic[5,o],rc3_statistic[6,o]],$
;[rc3_statistic[7,o],rc3_statistic[7,o]],$
;linestyle=0,thick=5,color=color
;oplot,[rc3_statistic[2,o],rc3_statistic[5,o]],$
;[rc3_statistic[4,o],rc3_statistic[7,o]],$
;linestyle=0,thick=5,color=color
;oplot,[rc3_statistic[3,o],rc3_statistic[6,o]],$
;[rc3_statistic[4,o],rc3_statistic[7,o]],$
;linestyle=0,thick=5,color=color
;;print,t,rc3_statistic[8,o],rc3_statistic[0,o],rc3_statistic[1,o]
endfor
endfor

xyouts,5,0,'0',charsize=csize,color=0,charthick=cthick
xyouts,180,0,'180',charsize=csize,color=0,charthick=cthick
xyouts,330,0,'360',charsize=csize,color=0,charthick=cthick
xyouts,180,80,'N',charsize=csize,color=0,charthick=cthick
xyouts,180,-90,'S',charsize=csize,color=0,charthick=cthick
xyouts,90,-40,'Equatorial coordinate system',charsize=csize,color=0,charthick=cthick
;xyouts,90,-50,'z < 0.01',charsize=csize,color=0,charthick=cthick
;xyouts,90,-50,'z < 0.015',charsize=csize,color=0,charthick=cthick
xyouts,90,-50,'z < 0.024',charsize=csize,color=0,charthick=cthick

close,120
close,/all
device,/close_file
print,'Done'
end