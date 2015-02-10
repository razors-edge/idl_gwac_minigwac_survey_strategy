pro Hour_angle_elevation_MINIGWAC_xinglong_web
close,/all
path = '/home/han/Web/htdocs/Mini_GWAC_Survey/idlfile/'
inputfile=filepath('sky_area_mosaic_minigwac_star_num.dat',$
root_dir = path)

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec_all=FILE_LINES(inputfile)
array = make_array(10,maxrec_all)

openr,50,inputfile
point_lun,50,0
readf,50,array
close,50

index_field_prority = where((strtrim(strtrim(string(long(array[9,*])),1))) eq '3' )
array = removerows_new(array,index_field_prority)
maxrec = n_elements(array[0,*])

record={coor:0L,coor_high1:0L,coor_high2:0L,coor_low1:0L,coor_low2:0L,$
  gal_number:0L,star_num:0L,fieldN_num:0L,fieldS_num:0L,field_priority:0L}
data=replicate(record,maxrec)

for sa = 0, maxrec-1 do begin
  data[sa].coor = long(array[0,sa])
  data[sa].coor_high1 = long(array[1,sa])
  data[sa].coor_high2 = long(array[2,sa])
  data[sa].coor_low1 = long(array[3,sa])
  data[sa].coor_low2 = long(array[4,sa])
  data[sa].gal_number = long(array[5,sa])
  data[sa].star_num = long(array[6,sa])
  data[sa].fieldN_num = long(array[7,sa])
  data[sa].fieldS_num = long(array[8,sa])
  data[sa].field_priority = long(array[9,sa])
endfor

;Calculate Julian Day, Local Sidereal time
;Ploting Upper culmination of local time
Julian = SYSTIME( /JULIAN ,/UTC )
hour=0
Julian = Julian + (hour/24.0)
;print,Julian
CALDAT,Julian,mon,day,year
print,year,mon,day
filedate = '_' + (strtrim(strtrim(string(format='(i)',year)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',mon)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',day)),1)) 
outputfile=filepath('Mini-GWAC_observing_area_map'+filedate,$
root_dir=path)
outputfile1=filepath('Mini-GWAC_observing_area_map'+filedate+'.dat',$
root_dir=path)
area_time_fig=filepath('Mini-GWAC_observing_area_time'+filedate,$
root_dir=path)

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
;loadct_plot
!p.position=0

;ploting map
;glactc,radeg,decdeg,2000,ragaladeg,decgaladeg,1, /degree
map_set,0,180,/aitoff,/horizon,/noerase
map_grid

newyear=JULDAY(1,1,year,0,0,0)
utc = Julian-newyear 
;utc_str = SYSTIME( /UTC )
;time = (utc - floor(utc)) * 24
;print,utc,time, '  ', utc_str
;GET_UTC, UTC

long = ten(117,34,28.35)
deta_local = ten(40,23,45.36)
print,Julian
local_sidereal_time,long,Julian,lst
;CT2LST, lst, long, 8, Julian
alpha_local_time = lst

cthick = 2
oplot,[alpha_local_time*15,alpha_local_time*15],[deta_local,deta_local],$
psym=1,thick=10,SYMSIZE=5,$
color=0
xyouts,alpha_local_time*15*1.01,deta_local*1.01,$
'Upper culmination of local time',charsize=1.5,color=0,charthick=cthick
;print,alpha_local_time

lat = float(deta_local)
;print,alpha_local_time,lat,long
zenith_solar_present = zenith(utc,lat,long)*180/3.1415926
hour = utc - floor(utc)
;print,zenith_solar_present,hour*24
utc_day = floor(utc)

MOONPOS,Julian,moonra,moondec
MPHASE,Julian,moonphase
print,moonra,moondec,moonphase

oplot,[moonra,moonra],[moondec,moondec],$
psym=1,thick=5,SYMSIZE=3,$
color=3
xyouts,moonra*1.01,moondec*1.01,$
'Lunar position',charsize=1,color=0,charthick=cthick


night_number = 288 ; every 5 munitues.
night_time = make_array(night_number)
zenith_solar_daily = make_array(night_number)
observing_time_alpha_local_lst = make_array(night_number)
observing_time_night_lst = make_array(night_number)
observing_time_night = make_array(night_number)
observing_time_julian = make_array(night_number,/double)
for k=0, night_number-1 do begin
;night_time[k] = float(utc_day + (night_time[k].radeg/15.0/24.0))
night_time[k] = utc_day + (k*5.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 100 then begin
observing_time_julian[k] = newyear+night_time[k]
;print,k,night_time[k],zenith_solar_daily[k],Julian,observing_time_julian
local_sidereal_time,long,observing_time_julian[k],observing_time_lst
;print,observing_time_lst
;CT2LST, observing_time_lst, long, 8, observing_time_julian
observing_time_alpha_local_lst[k] = observing_time_lst
;print,observing_time_alpha_local_lst[k]
observing_time_night_lst[k]=observing_time_alpha_local_lst[k]*15
observing_time_night[k] = (k*5.0/60.0/24.0)
;print,k,observing_time_night_lst[k]
endif
;;print,observing_time_alpha_local_lst[k]
endfor

badpnts=0
badpnts = Where( observing_time_night_lst Le 0, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
IF goodcount GT 0 THEN observing_time_night_lst = observing_time_night_lst[goodpnts]
IF goodcount GT 0 THEN observing_time_night = observing_time_night[goodpnts]
IF goodcount GT 0 THEN observing_time_julian = observing_time_julian[goodpnts]
;print,observing_time_night_lst
maxrec1=n_elements(observing_time_night_lst)
;print,maxrec1,'m1'

;openw,90,outputfile1,width=2000
for k=0, maxrec1-1 do begin
;printf,90,observing_time_night_lst[k],lat
oplot,[observing_time_night_lst[k],observing_time_night_lst[k]],$
[deta_local,deta_local],$
psym=1,thick=3,SYMSIZE=1.5,$
color=2
;print,k,observing_time_night_lst[k]
endfor
;close,90

;openw,80,outputfile2,width=2000
array=make_array(5,maxrec*maxrec1)
m=0
for j=0, maxrec-1 do begin
for k=0, maxrec1-1 do begin
decdeg = STRMID(data[j].coor, 1, 3, /REVERSE_OFFSET)
radeg = (data[j].coor - decdeg) / 100
;print,radeg,decdeg
angular_distance,radeg,decdeg,observing_time_night_lst[k],$
lat,distance_d

glactc,radeg,decdeg,2000,gl_deg,gb_deg,1, /degree
angular_distance,radeg,decdeg,moonra,moondec,distance_moon
;if abs(gb_deg) ge 20 and distance_d lt 62.0 and distance_moon gt 20 then begin
if moonphase gt 0.5 then begin
dis_2_moon = 30.0
endif else begin
dis_2_moon = 20.0
endelse
;if abs(gb_deg) ge 20 and distance_d lt 62.0 and distance_moon gt dis_2_moon then begin
if distance_d lt 62.0 and distance_moon gt dis_2_moon then begin
array[0,m]=radeg
array[1,m]=decdeg
array[2,m]=observing_time_night_lst[k]
array[3,m]=lat
array[4,m]=observing_time_julian[k]
m=m+1
;printf,80,data[j].radeg,data[j].decdeg,observing_time_night_lst[k],lat
;print,data[j].radeg,data[j].decdeg,observing_time_night_lst[k],lat
;break
endif
endfor
endfor
;close,80
badpnts=0
goodcount=0
goodpnts=0
badpnts = Where( array[0,*] Le 0 and array[1,*] Le 0 and $
array[2,*] Le 0 and array[3,*] Le 0, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
IF goodcount GT 0 THEN array = array[*,goodpnts]
;multicolumnsort,array,index=0,revert=0
maxrec2=n_elements(array[0,*])
;print,maxrec2,'m2'
;print,array
;help,array

;openw,80,outputfile3,width=2000
array1=make_array(16,maxrec*maxrec1)
m=0
for j=0, maxrec-1 do begin
for k=0, maxrec1-1 do begin
decdeg = STRMID(data[j].coor, 1, 3, /REVERSE_OFFSET)
radeg = (data[j].coor - decdeg) / 100
angular_distance,radeg,decdeg,observing_time_night_lst[k],$
lat,distance_d
glactc,radeg,decdeg,2000,gl_deg,gb_deg,1, /degree
angular_distance,radeg,decdeg,moonra,moondec,distance_moon
;if abs(gb_deg) ge 20 and distance_d lt 62.0 and distance_moon gt dis_2_moon then begin
if distance_d lt 62.0 and distance_moon gt dis_2_moon then begin
array1[0,m]=radeg
array1[1,m]=decdeg
array1[2,m]=observing_time_night_lst[k]
array1[3,m]=lat
array1[4,m]=observing_time_night[k]
array1[5,m]=observing_time_julian[k]
array1[6,m]=data[j].coor
array1[7,m]=data[j].coor_high1
array1[8,m]=data[j].coor_high2
array1[9,m]=data[j].coor_low1
array1[10,m]=data[j].coor_low2
array1[11,m]=data[j].gal_number
array1[12,m]=data[j].star_num
array1[13,m]=data[j].fieldN_num
array1[14,m]=data[j].fieldS_num
array1[15,m]=data[j].field_priority
m=m+1
;printf,80,data[j].radeg,data[j].decdeg,observing_time_night_lst[k],lat
;print,data[j].radeg,data[j].decdeg,observing_time_night_lst[k],lat
break
endif
endfor
endfor
;close,80
badpnts=0
goodcount=0
goodpnts=0
badpnts = Where(array1[0,*] Le 0 and array1[1,*] Le 0 and $
array1[2,*] Le 0 and array1[3,*] Le 0, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
IF goodcount GT 0 THEN array1 = array1[*,goodpnts]
multicolumnsort,array1,index=0,revert=0
maxrec3=n_elements(array1[0,*])
array2=make_array(15,maxrec3)
array2[0,*]=array1[0,*] ;radeg
array2[1,*]=array1[1,*] ;decdeg
array2[2,*]=array1[2,*] ;observing time night lst
array2[3,*]=array1[2,*] ;observing time night lst
array2[4,*]=array1[2,*] ;observing time night lst
array2[5,*]=array1[6,*] ;coor
array2[6,*]=array1[7,*] ;coor high 1 (west)
array2[7,*]=array1[8,*] ;coor high 2 (east)
array2[8,*]=array1[9,*] ;coor low 1 (west)
array2[9,*]=array1[10,*] ;coor low 2 (east)
array2[10,*]=array1[11,*] ;galaxy number
array2[11,*]=array1[12,*] ;star number
array2[12,*]=array1[13,*] ;star number in north field
array2[13,*]=array1[14,*] ;star number in south field
array2[14,*]=array1[15,*] ;priority 
                          ;(1 both two fields have , 
                          ; 2 one of two field has large number of stars
                          ; 3 both two fields have large number of stars)

openw,120,outputfile1,width=3000
printf,120,('coor, coor_h1, coor_h2, coor_l1, coor_l2, time begin(lst),'+$
' end(lst), time begin(BT), end(BT), Length hour'+$
' monra bg, mondec bg, mondistance bg, ra end, dec end,'+$
' distance end, moonphase, gal num,'+$
' star num, fieldN num, fieldS num, field priority')

for x=0, maxrec3-1 do begin
for y=0, maxrec2-1 do begin
if array[0,y] eq array1[0,x] and  array[1,y] eq array1[1,x] then begin
array2[3,x] = array[2,y] < array2[2,x]
array2[4,x] = array[2,y] > array2[4,x]
if array2[2,x] gt array2[3,x] then begin
array2[4,x] = array2[3,x] + 360.
endif
endif
endfor
;print,array2[*,x],(array1[4,x])*24.0+8.0,(array1[4,x]+(array2[4,x]-array2[2,x])/360.)*24.0+8.0

julian_begin = array1[5,x]
MPHASE,julian_begin,moonphase
MOONPOS,julian_begin,moonra_begin,moondec_begin
angular_distance,array2[0,x],array2[1,x],moonra_begin,$
moondec_begin,distance_moon_begin

julian_end = array1[5,x]+((array2[4,x]-array2[2,x])/360.)
MOONPOS,julian_end,moonra_end,moondec_end
angular_distance,array2[0,x],array2[1,x],moonra_end,$
moondec_end,distance_moon_end

if ((array2[4,x] gt array2[2,x])) then begin
fmt = '(a5,3x,a5,4x,a5,4x,a5,4x,a5,5x,a,6x,a,5x,a,6x,a,6x,a,4x,a,4x,a,6x,a,4x'+$
',a,2x,a,6x,a,6x,a,7x,a,5x,a,6x,a,6x,a,10x,a)'
coor_str = (strtrim(strtrim(string(format='(i)',array2[5,x])),1))
coor_high1_str = (strtrim(strtrim(string(format='(i)',array2[6,x])),1))
coor_high2_str = (strtrim(strtrim(string(format='(i)',array2[7,x])),1))
coor_low1_str = (strtrim(strtrim(string(format='(i)',array2[6,x])),1))
coor_low2_str = (strtrim(strtrim(string(format='(i)',array2[7,x])),1))
coor_low2_str = (strtrim(strtrim(string(format='(i)',array2[7,x])),1))
time_begin_lst_str = (strtrim(strtrim(string(format='(f8.4)',array2[2,x])),1))
time_end_lst_str = (strtrim(strtrim(string(format='(f8.4)',array2[4,x])),1))
time_begin_bt_str = (strtrim(strtrim(string(format='(f8.4)',array1[4,x]*24.0+8.0)),1))
time_end_bt_str = (strtrim(strtrim(string(format='(f8.4)',$
  (array1[4,x]+(array2[4,x]-array2[2,x])/360.)*24.0+8.0)),1))
time_length_hour_str = (strtrim(strtrim(string(format='(f5.2)',$
  ((array1[4,x]+(array2[4,x]-array2[2,x])/360.)*24.0+8.0) - (array1[4,x]*24.0+8.0))),1))  
  print,time_length_hour_str,((array1[4,x]+(array2[4,x]-array2[2,x])/360.)*24.0+8.0)-(array1[4,x]*24.0+8.0)
moonra_begin_str = (strtrim(strtrim(string(format='(f8.4)',moonra_begin)),1))
moondec_begin_str = (strtrim(strtrim(string(format='(f8.4)',moondec_begin)),1))
distance_moon_begin_str = (strtrim(strtrim(string(format='(f8.4)',distance_moon_begin)),1))
moonra_end_str = (strtrim(strtrim(string(format='(f8.4)',moonra_end)),1))
moondec_end_str = (strtrim(strtrim(string(format='(f8.4)',moondec_end)),1))
distance_moon_end_str = (strtrim(strtrim(string(format='(f8.4)',distance_moon_end)),1))
moonphase_str = (strtrim(strtrim(string(format='(f4.2)',moonphase)),1))
gal_num_str = (strtrim(strtrim(string(format='(i)',array2[10,x])),1))
star_num_str = (strtrim(strtrim(string(format='(i)',array2[11,x])),1))
fieldN_num_str = (strtrim(strtrim(string(format='(i)',array2[12,x])),1))
fieldS_num_str = (strtrim(strtrim(string(format='(i)',array2[13,x])),1))
field_priority_str = (strtrim(strtrim(string(format='(i)',array2[14,x])),1))
printf,120,coor_str,coor_high1_str,coor_high2_str,coor_low1_str,coor_low2_str,$
time_begin_lst_str,time_end_lst_str,time_begin_bt_str,time_end_bt_str,time_length_hour_str,$
moonra_begin_str,moondec_begin_str,distance_moon_begin_str,$
moonra_end_str,moondec_end_str,distance_moon_end_str,moonphase_str,$
gal_num_str,star_num_str,fieldN_num_str,fieldS_num_str,field_priority_str,$
format=fmt

thick = 5
oplot,[array2[0,x],array2[0,x]],[array2[1,x],array2[1,x]],$
psym=1,thick=thick,SYMSIZE=1.5,$
color=1
ind = 3.1415926 / 180.0
dec_radian= array2[1,x]  * ind
ra_interval = 3.0 / cos(dec_radian)
;print,array2[1,x],cos(dec_radian),ra_interval
xyouts,array2[0,x]+ra_interval,array2[1,x],(strtrim(strtrim(string(format='(i)',x)),1)),charsize=1.5,charthick = 2
endif

endfor
close,120
;device,/close_file
;cgPS2Raster, outputfile + '.ps', /JPEG,/PORTRAIT
;device,/close_file
;cgPS2Raster, area_time_fig+'.ps', /JPEG,/PORTRAIT

minigwac_observing_area_time,outputfile1,area_time_fig

close,/all
device,/close_file
print,'Done'
end
