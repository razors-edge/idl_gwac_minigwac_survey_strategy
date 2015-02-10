pro minigwac_observing_area_list_new
;,inputfile,mount_num,Julian,long,deta_local
Julian = SYSTIME( /JULIAN ,/UTC )
hour=0
Julian = Julian + (hour/24.0)
CALDAT,Julian,mon,day,year

long = float(ten(117,34,28.35))
deta_local = float(ten(40,23,45.36))
lat = float(deta_local)
newyear=JULDAY(1,1,year,0,0,0)
utc = Julian-newyear
utc_day = floor(utc)

filedate = '_' + (strtrim(strtrim(string(format='(i)',year)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',mon)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',day)),1))
inputfile=filepath('Mini-GWAC_observing_area_time'+filedate+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')

mount_num = 6

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec=FILE_LINES(inputfile)
array=make_array(8,maxrec)
array1=make_array(mount_num+1,144)
area_id=indgen(maxrec)

openr,50,inputfile
point_lun,50,0
readf,50,array
multicolumnsort,array,index=7,revert=1
close,50

for x = 0, maxrec-1 do begin
cthick = 1.5
label = (strtrim(strtrim(string(format='(i)',array[0,x])),1)+','+$
strtrim(strtrim(string(format='(i)',array[1,x])),1))
xyouts,15,x-0.1,$
label,charsize=1.2,color=0,charthick=cthick
endfor

for i=0, 24*6-1 do begin
timeBJ = 8.+(i*10./60.)

timeUT = utc_day + (i*10.0/60.0/24.0)
timeUT_julian = newyear+timeUT
local_sidereal_time,long,timeUT_julian,time_lst

time_Ha = (time_lst*15.0 -  array[0,*] )/15.0 ; calculate the hour angle
timeUT_day = utc_day + (i*10.0/60.0/24.0) 
zenith_solar_daily = zenith(timeUT_day,lat,long)*180/3.1415926 ; calculate the zenith of sun

if zenith_solar_daily gt 100.0 then begin
indexx = where((time_Ha[*] gt 12.0),countx) 
if countx gt 0 then begin
time_Ha[indexx] = -1 * (24.0 - time_Ha[indexx] )
endif
indexy = where((time_Ha[*] lt (-12.0)),county) 
if county gt 0 then begin
time_Ha[indexy] = time_Ha[indexy] + 24.0
endif

timeBJ_stamp = (strtrim(strtrim(string(timeBJ)),1))
strreplace,timeBJ_stamp,'.','h'
outputfile_time=filepath('timeBJ_'+timeBJ_stamp+'.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\time_files\')
openw,110,outputfile_time,width=1000

for x = 0, maxrec-1 do begin
if ((time_Ha[x] gt (-5.0)) and (time_Ha[x] lt (6.0) )) then begin
printf,110,timeBJ,time_lst,array[0,x],array[1,x],time_Ha[x]
print,timeBJ,time_lst,zenith_solar_daily,array[0,x],array[1,x],time_Ha[x]
endif  
endfor

close,110

endif

endfor

close,/all
;device,/close_file
print,'Done'
end