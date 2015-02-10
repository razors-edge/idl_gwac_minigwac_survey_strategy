pro sky_area_mosaic_minigwac_web
;,homepath
homepath = 'E:\xampp\htdocs\Mini_GWAC_Survey\idlfile\'
close,/all
inputfile=filepath('z0015_deccut.dat',$
root_dir='E:\Data\catalogue\RC3\')

outputfile=filepath('sky_area_mosaic_minigwac.dat',$
root_dir=homepath)
outputfile1=filepath('sky_area_mosaic_minigwac',$
root_dir=homepath)

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec=FILE_LINES(inputfile)
array=make_array(8,maxrec)
;print,maxrec,'m'

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile1 + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

;ploting map
;glactc,radeg,decdeg,2000,ragaladeg,decgaladeg,1, /degree
;map_set,0,180,/aitoff,/horizon,/noerase
;map_grid
xrange0=0
xrange1=360
yrange0=-30
yrange1=90

plot,[0,0],$
[0,0],$
psym=1,thick=5,$
color=0,$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='RA',$
ytitle='DEC',$
XCHARSIZE=1,$
YCHARSIZE=1,$
xrange=[xrange0,xrange1],yrange=[yrange0,yrange1], $
position=[0.1,0.1,0.9,1],/noerase,/nodata

str=''
openr,50,inputfile
point_lun,50,0
for i=0L, maxrec-1 do begin
readf,50,str
word = strsplit(str,/EXTRACT)
array[0,i]= word[1]
array[1,i]= word[2]
array[2,i]= word[3]
array[3,i]= word[4]
array[4,i]= word[5]
array[5,i]= word[6]
array[6,i]= word[7]
array[7,i]= word[8]
endfor
close,50

openw,120,outputfile,width=3000
;for i=0, 17 do begin
for j=0, 1 do begin
dec = j*40.0 + 20.0
dec_high = dec + 20
dec_low = dec - 20
ind = 3.1415926 / 180.0
dec_radian=dec  * ind
ra_interval = 20.0 / cos(dec_radian)
dec_high_radian = dec_high  * ind
ra_high_interval = 20.0 / cos(dec_high_radian)
dec_low_radian = dec_low  * ind
ra_low_interval = 20.0 / cos(dec_low_radian)
s = fix(360. / ra_interval)
for i=0, s do begin
ra =i*ra_interval+(ra_interval/2.)
index = where(((array[0,*]*15.0 ge (ra-(ra_interval/2.))) and (array[0,*]*15.0 lt (ra+(ra_interval/2.))) $
and (array[1,*] ge (dec-20)) and (array[1,*] le (dec+20))), count)
;where is faster than for looping 
ra_high1 = ra - (ra_high_interval/2.)
if ra_high1 lt 0 then ra_high1 = 360. + ra_high1
ra_high2 = ra + (ra_high_interval/2.)
if ra_high2 gt 360 then ra_high2 = ra_high2 - 360.
ra_low1 = ra - (ra_low_interval/2.)
if ra_low1 lt 0 then ra_low1 = 360. + ra_low1
ra_low2 = ra + (ra_low_interval/2.)
if ra_low2 gt 360 then ra_low2 = ra_low2 - 360.
coor = long(long(ra)*100+long(dec))
coor_high1 = long(long(ra_high1)*100+long(dec_high))
coor_high2 = long(long(ra_high2)*100+long(dec_high))
coor_low1 = long(long(ra_low1)*100+long(dec_low))
coor_low2 = long(long(ra_low2)*100+long(dec_low))
print,coor,coor_high1,coor_high2,coor_low1,coor_low2,count
printf,120,coor,coor_high1,coor_high2,coor_low1,coor_low2,count

thick = 5
oplot,[ra,ra],[dec,dec],$
psym=1,thick=thick,SYMSIZE=1.5,$
color=1
ra_str = (strtrim(strtrim(string(format='(i)',ra)),1))
dec_str = (strtrim(strtrim(string(format='(i)',dec)),1))
xyouts,ra-6,dec-4,$
'RA '+ra_str,charsize=0.5,color=0,charthick=cthick
xyouts,ra-6,dec-6,$
'DEC '+dec_str,charsize=0.5,color=0,charthick=cthick
oplot,[0,360],[dec_high,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=1
oplot,[0,360],[dec_low,dec_low],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=1
if ra_high1 le ra_low1 and ra_high2 ge ra_low2  then begin
oplot,[ra_low1,ra_high1],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=2
oplot,[ra_low2,ra_high2],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=3
endif 
if  (ra_high1 gt ra_low1) and (ra_high2 ge ra_low2) then begin
oplot,[ra_low1,(ra_high1-360.)],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=2
oplot,[ra_low1+360.,ra_high1],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=2
oplot,[ra_low2,ra_high2],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=3
endif
if  (ra_high1 lt ra_low1) and (ra_high2 lt ra_low2) then begin
oplot,[ra_low1,ra_high1],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=2
oplot,[ra_low2,(ra_high2+360.)],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=3
oplot,[ra_low2-360.,ra_high2],[dec_low,dec_high],$
linestyle=1,thick=thick,SYMSIZE=1.5,$
color=3
endif

endfor
endfor

device,/close_file
cgPS2Raster, outputfile1 + '.ps', /JPEG,/PORTRAIT

close,/all
device,/close_file
print,'Done'
end