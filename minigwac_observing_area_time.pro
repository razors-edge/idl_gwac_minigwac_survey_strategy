pro minigwac_observing_area_time,inputfile,outputfile
close,/all

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec=FILE_LINES(inputfile)
array=make_array(22,maxrec-1)

openr,50,inputfile
point_lun,50,0
str=''
readf,50,str
readf,50,array

;coor_str,coor_high1_str,coor_high2_str,coor_low1_str,coor_low2_str,$4
;time_begin_lst_str,time_end_lst_str,time_begin_bt_str,time_end_bt_str,time_length_hour_str,$9
;moonra_begin_str,moondec_begin_str,distance_moon_begin_str,$12
;moonra_end_str,moondec_end_str,distance_moon_end_str,moonphase_str,$16
;gal_num_str,star_num_str,fieldN_num_str,fieldS_num_str,field_priority_str21

coor = long(array[0,*])
decdeg = STRMID(string(coor), 1, 3, /REVERSE_OFFSET)
radeg = string((coor - fix(decdeg)) / 100)
print,radeg,decdeg

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
;loadct_plot
!p.position=0

xrange0=8
xrange1=8+24
yrange0=-1
yrange1=maxrec+2

plot,[0,0],$
[0,0],$
psym=1,thick=5,$
color=0,$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='Beijing Time (8:00 AM - 32:00)',$
XCHARSIZE=1,$
xrange=[xrange0,xrange1],yrange=[yrange0,yrange1], $
position=[0.1,0.1,0.9,1],/noerase,/nodata

long = ten(117,34,28.35)
deta_local = ten(40,23,45.36)
Julian = SYSTIME( /JULIAN ,/UTC )
CALDAT, Julian, M, D, Y, H, M, S 
PRINT, M, D, Y, H+8, M, S 
hour = (H+8) + (M/60)
oplot,[hour,hour],[yrange0,yrange1],color=1,thick=5
m=0

for i=0,maxrec-2 do begin
x0 = array[7,i]
y0 = i
ylength = 0.5 
RECTANGLE,x0,y0,array[9,i],ylength,$
fill=1,fcolor=2,thick=5,$
color = 2

cthick = 1.5
label = (strtrim(strtrim(radeg[i]+','+decdeg[i]),1))
print,label
xyouts,x0-2.8,y0*1.01,$
label,charsize=0.8,color=0,charthick=cthick
endfor

close,/all
device,/close_file
end
