pro minigwac_observing_area_total
close,/all

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

inputfile=filepath('Mini-GWAC_observing_area_time'+filedate+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
mount_inputfile=filepath('mount_coverage.txt',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile=filepath('Mini-GWAC_observing_area_list'+filedate+'',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile1=filepath('Mini-GWAC_observing_area_list'+filedate+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
;outputfile2=filepath('Mini-GWAC_observing_area_list1.dat',$
;root_dir='E:\WORK\GWAC\survey_strategy\')
;openw,110,outputfile2,width=3000
mount_num = 6

long = ten(117,34,28.35)
deta_local = ten(40,23,45.36)
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
for k=0, night_number-1 do begin
timeBJ = 8.+(k*10./60.)
night_time[k] = utc_day + (k*5.0/60.0/24.0)
zenith_solar_daily[k] = zenith(night_time[k],lat,long)*180/3.1415926
if zenith_solar_daily[k] gt 90 and zenith_solar_daily[k] lt 100 then begin
observing_time_julian[k] = newyear+night_time[k]
local_sidereal_time,long,observing_time_julian[k],observing_time_lst
observing_time_alpha_local_lst[k] = observing_time_lst
observing_time_night_lst[k]=observing_time_alpha_local_lst[k]*15
observing_time_night[k] = (k*5.0/60.0/24.0)
print,k,observing_time_alpha_local_lst[k],observing_time_night[k]
endif
endfor

minigwac_observing_area_list,inputfile,mount_inputfile,outputfile,outputfile1,mount_num,Julian,long,deta_local


close,/all
device,/close_file
print,'Done'
end