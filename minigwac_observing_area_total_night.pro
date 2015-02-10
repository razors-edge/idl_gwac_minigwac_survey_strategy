pro minigwac_observing_area_total_night
close,/all

;Calculate Julian Day, Local Sidereal time
;Ploting Upper culmination of local time
Julian = SYSTIME( /JULIAN ,/UTC )
hour=0
Julian = Julian + (hour/24.0)
CALDAT,Julian,mon,day,year
print,year,mon,day
filedate = '_' + (strtrim(strtrim(string(format='(i)',year)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',mon)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',day)),1)) 

inputfile=filepath('Mini-GWAC_observing_area_map'+filedate+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
print,inputfile
mount_inputfile=filepath('mount_coverage.txt',$
root_dir='E:\WORK\GWAC\survey_strategy\')
star_num_inputfile=filepath('star_number.txt',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile=filepath('Mini-GWAC_observing_area_list'+filedate+'',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile1=filepath('Mini-GWAC_observing_area_list'+filedate+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile2=filepath('Mini-GWAC_observing_timelog'+filedate+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile3=filepath('Mini-GWAC_observing_test'+filedate+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
openw,100,outputfile3,width=3000
openw,110,outputfile2,width=3000
mount_num = 6

long = float(ten(117,34,28.35))
deta_local = float(ten(40,23,45.36))
lat = float(deta_local)
newyear=JULDAY(1,1,year,0,0,0)
utc = Julian-newyear
zenith_solar_present = zenith(utc,lat,long)*180/3.1415926
hour = utc - floor(utc)
utc_day = floor(utc)

openw,120,outputfile1,width=1000
;printf,120,$
;string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)'),$
;array2[0],array2[1],' 0 '


night_number = 288 ; every 5 munitues.
night_time = make_array(night_number)
zenith_solar_daily = make_array(night_number)
observing_time_alpha_local_lst = make_array(night_number)
observing_time_night_lst = make_array(night_number)
observing_time_night = make_array(night_number)
observing_time_julian = make_array(night_number,/double)



;if zenith_solar_daily[k] gt 90 and zenith_solar_daily[k] lt 92.0 and timeBJ lt 24 then begin


home = 0
for k=0, night_number-1 do begin
timeBJ = 8.+(k*5./60.)
night_time[k] = utc_day + (k*5.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 93 and zenith_solar_daily[k] lt 96 and timeBJ lt 24 then begin
timeBJ_hms=d2dms(timeBJ)
printf,110,timeBJ_hms,'  ',2
home = 1
endif
if home eq 1 then break
endfor

dark_expo = 0
for k=0, night_number-1 do begin
timeBJ = 8.+(k*5./60.)
night_time[k] = utc_day + (k*5.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 96 and zenith_solar_daily[k] lt 99 and timeBJ lt 24 then begin
minigwac_observing_area_dark,k,mount_num,newyear,night_time[k],timeBJ
timeBJ_hms=d2dms(timeBJ)
printf,110,timeBJ_hms,'  ',5
dark_expo = 1
endif
if dark_expo eq 1 then break
endfor

obse_mode = 0
for k=0, night_number/2-1 do begin
timeBJ = 8.+(k*10./60.)
night_time[k] = utc_day + (k*10.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 100 then begin
timeBJ_start = timeBJ
timeBJ_hms=d2dms(timeBJ)
printf,110,timeBJ_hms,'  ',1
obse_mode = 1
endif
if obse_mode eq 1 then break
endfor 

obse_mode = 0
for k=0, night_number/2-1 do begin
timeBJ = 8.+(k*10./60.)
night_time[k] = utc_day + (k*10.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 100 and zenith_solar_daily[k] lt 102 and timeBJ ge 24.0 then begin
timeBJ_end = timeBJ
timeBJ_hms=d2dms(timeBJ)
printf,110,timeBJ_hms,'  ',1
obse_mode = 1
endif
if obse_mode eq 1 then break
endfor 

;minigwac_observing_area_list,inputfile,mount_inputfile,outputfile,outputfile1,mount_num,Julian,long,deta_local
;minigwac_observing_area_list_new,inputfile,mount_num,Julian,long,deta_local
minigwac_observing_area_mount_dispatch,inputfile,mount_inputfile,star_num_inputfile,mount_num,Julian,long,deta_local,timeBJ_start,timeBJ_end

dark_expo = 0
for k=0, night_number-1 do begin
timeBJ = 8.+(k*10./60.)
night_time[k] = utc_day + (k*10.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 95 and zenith_solar_daily[k] lt 97 and timeBJ gt 24 then begin
  timeBJ_hms=d2dms(timeBJ)
printf,110,timeBJ_hms,'  ',5
minigwac_observing_area_dark,k,mount_num,newyear,night_time[k],timeBJ
dark_expo = 1
endif
if dark_expo eq 1 then break
endfor

park = 0
for k=0, night_number-1 do begin
timeBJ = 8.+(k*10./60.)
night_time[k] = utc_day + (k*10.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 92 and zenith_solar_daily[k] lt 94 and timeBJ gt 24 then begin
timeBJ_hms=d2dms(timeBJ)
printf,110,timeBJ_hms,'  ',3
park = 1
endif
if park eq 1 then break
endfor


off = 0
for k=0, night_number-1 do begin
timeBJ = 8.+(k*10./60.)
night_time[k] = utc_day + (k*10.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 90 and zenith_solar_daily[k] lt 92 and timeBJ gt 24 then begin
timeBJ_hms=d2dms(timeBJ)
printf,110,timeBJ_hms,'  ',0
off = 1
endif
if off eq 1 then break
endfor


close,/all
;device,/close_file
print,'Done'
end