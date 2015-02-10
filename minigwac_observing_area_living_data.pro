pro minigwac_observing_area_living_data,inputfile,outputfile
close,/all

;Calculate Julian Day, Local Sidereal time
Julian = SYSTIME( /JULIAN ,/UTC )
hour=0
Julian = Julian + (hour/24.0)
CALDAT,Julian,mon,day,year
filedate = '_' + (strtrim(strtrim(string(format='(i)',year)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',mon)),1)) + $
'_' + (strtrim(strtrim(string(format='(i)',day)),1)) 

openr,50,inputfile
point_lun,50,0
str = ''
readf,50,str
close,50
num_col = n_elements(STRSPLIT(str,/EXTRACT))
time = TEN((STRSPLIT(str,/EXTRACT))[0])
num_mnt = ( num_col - 1 ) / 3.
maxrec=FILE_LINES(inputfile)


case num_mnt of
1: data = make_array(4,maxrec)
2: data = make_array(7,maxrec)
3: data = make_array(10,maxrec)
4: data = make_array(13,maxrec)
5: data = make_array(16,maxrec)
6: data = make_array(19,maxrec)
endcase

openr,50,inputfile
point_lun,50,0
coor = make_array(num_mnt,maxrec,/long)
coor1 = make_array(num_mnt,maxrec,/long)
for i = 0, maxrec-1 do begin  
readf,50,str
time = TEN((STRSPLIT(str,/EXTRACT))[0])
data[0,i] = time
for j = 1, num_col-1 do begin
  data[j,i] = (STRSPLIT(str,/EXTRACT))[j]
endfor
for k = 0, num_mnt-1 do begin
coor[k,i] = long(long(data[k*3+1,i])*100+long(data[k*3+2,i]))
endfor
endfor
close,50 

num_field = 0
for k = 0, num_mnt-1 do begin
  ord = uniq(coor[k,*])
  for oi = 0, n_elements(ord)-1 do begin
    if coor[k,ord[oi]] ne 0 and coor[k,ord[oi]] ne -36090 then begin
;    print,coor[k,ord[oi]]
    num_field = num_field + 1
    endif
  endfor
endfor

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
yrange1= num_field + 2

CALDAT, Julian, Mon, D, Y, H, M, S 
PRINT, Mon, D, Y, H+8, M, S 
hourBJ = (H+8) + (M/60) 

plot,[0,0],$
[0,0],$
psym=1,thick=5,$
color=0,$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='Beijing Time (' + (strtrim(strtrim(string(format='(i)',Mon)),1)) + $
'/' + (strtrim(strtrim(string(format='(i)',D)),1)) + $
'/' + (strtrim(strtrim(string(format='(i)',Y)),1)) + ', 8:00 AM - 32:00)',$
XCHARSIZE=1,$
xrange=[xrange0,xrange1],yrange=[yrange0,yrange1], $
position=[0.1,0.1,0.9,1],/noerase,/nodata

oplot,[hourBJ,hourBJ],[yrange0,yrange1],color=1,thick=3

num_field_1 = 0
oi_rd = 0
for k = 0, num_mnt-1 do begin
  
  color_num=k+1
  cthick = 1.5
  if color_num eq 4 then color_num = 0
  mount_label='Mount ' + (strtrim(strtrim(string(k+1)),1))
  xyouts,9,yrange1-k-1,$
  mount_label,charsize=1.5,color=color_num,charthick=cthick
  
  ord = uniq(coor[k,*])
  
  for oi = 0, n_elements(ord)-1 do begin
    if coor[k,ord[oi]] ne 0 and coor[k,ord[oi]] ne -36090 then begin
    decdeg = STRMID(coor[k,ord[oi]], 1, 3, /REVERSE_OFFSET)
    radeg = (coor[k,ord[oi]] - decdeg) / 100
    label = (strtrim(strtrim(string(format='(i)',radeg)),1)+','+$
    strtrim(strtrim(string(format='(i)',decdeg)),1))
    xyouts,15,num_field_1-0.1,$
    label,charsize=1.2,color=color_num,charthick=cthick
    num_field_1 = num_field_1 + 1
    for i=0, maxrec-1 do begin
      coor1[k,i] = long(long(data[k*3+1,i])*100+long(data[k*3+2,i]))
      if coor1[k,i] eq coor[k,ord[oi]] then begin
        oplot,[data[0,i],data[0,i]],[oi_rd,oi_rd],$
        psym=1,thick=1,SYMSIZE=1,$
        color=color_num
      endif    
    endfor
    oi_rd = oi_rd + 1
    endif
  endfor
endfor

device,/close_file
;cgPS2Raster, outputfile+'.ps', /JPEG,/PORTRAIT
;http://www.astronomy.ohio-state.edu/~assassin/transients.html
;crts survey

close,/all
end
