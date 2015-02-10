pro minigwac_observing_area_list_old,inputfile,mount_inputfile,outputfile,outputfile1,mount_num,Julian,long,deta_local

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec=FILE_LINES(inputfile)
array=make_array(8,maxrec)
array1=make_array(mount_num+1,144)
;mount_id=make_array(6,3)
area_id=indgen(maxrec)

openr,50,inputfile
point_lun,50,0
readf,50,array
multicolumnsort,array,index=7,revert=1
;printf,110,array
;help,array
close,50

array2=make_array(5,mount_num)
openr,50,mount_inputfile
point_lun,50,0
str=""
readf,50,str
readf,50,array2
close,50

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

;xrange0=min(array[4,*])-1
;xrange1=max(array[5,*])+1
;yrange0=-2
;yrange1=maxrec+2

xrange0=8
xrange1=8+24
yrange0=-1
yrange1=maxrec+2

;YVAL = [-20,20,60]

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

newyear=JULDAY(1,1,Y,0,0,0)
utc = Julian-newyear 
utc_day = floor(utc)

local_sidereal_time,long,Julian,lst
;print,lst


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
;print,timeBJ,time_lst

time_Ha = (time_lst*15.0 -  array[0,*] )/15.0
indexx = where((time_Ha[*] gt 12.0),countx) 
time_Ha[indexx] = time_Ha[indexx] - 24.
indexy = where((time_Ha[*] lt (-12.0)),county) 
time_Ha[indexy] = time_Ha[indexy] + 24.

msa = array[0,*]/15
;array[7,*] = array[7.0 ,*] * time_Ha[*] * (-1) / 10.
;multicolumnsort,array,index=7,revert=1
;ary_index=where((timeBJ ge array[4,*]) and (timeBJ lt array[5,*]) ,count)
ary_index=where((timeBJ ge array[4,*]) and (timeBJ lt array[5,*]) and $
    (time_Ha[*] ge -6) and (time_Ha[*] le 5) ,count)

ary_index = ary_index
;print,timeBJ,time_lst,msa[ary_index],ary_index
;print,timeBJ,time_lst,time_Ha[ary_index],ary_index
;printf,110,timeBJ,time_lst,msa[ary_index],ary_index
;printf,110,timeBJ,time_lst,time_Ha[ary_index],ary_index

array1[0,i] = timeBJ 
if count gt 0 then begin
if count ge mount_num then begin
x = mount_num
endif else begin
x = count
endelse
for j=0, x-1 do begin
array1[j+1,i] = ary_index[j] + 1
endfor
for k=x,mount_num-1 do begin
array1[k+1,i] = 255
endfor
endif
;print,'d',array1[*,i]
endfor


badpnts=0
case mount_num of
1: badpnts = Where( array1[1,*] Le 0  $
, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
2: badpnts = Where( array1[1,*] Le 0 and array1[2,*] Le 0 $
, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
3: badpnts = Where( array1[1,*] Le 0 and array1[2,*] Le 0 $
and array1[3,*] Le 0 $
, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
4:badpnts = Where( array1[1,*] Le 0 and array1[2,*] Le 0 $
and array1[3,*] Le 0 and array1[4,*] Le 0 $
, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
5:badpnts = Where( array1[1,*] Le 0 and array1[2,*] Le 0 $
and array1[3,*] Le 0 and array1[4,*] Le 0 $
and array1[5,*] Le 0 $
, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
6:badpnts = Where( array1[1,*] Le 0 and array1[2,*] Le 0 $
and array1[3,*] Le 0 and array1[4,*] Le 0 $
and array1[5,*] Le 0 and array1[6,*] Le 0 $
, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
endcase
IF goodcount GT 0 THEN array1 = array1[*,goodpnts]
maxrec1=n_elements(array1[0,*])


for m=1, maxrec1-1 do begin
match_id=make_array(mount_num+1)
unmatch_id=make_array(mount_num+1)
match_id[0] = array1[0,m]
unmatch_id[0] = 0
for p=1, mount_num do begin
match_key=0
for q=1, mount_num do begin
if array1[p,m] eq array1[q,m-1] then begin
match_id[q] = array1[q,m-1]
match_key=1
endif
endfor
if match_key eq 0 then begin
unmatch_id[p] = array1[p,m]
endif
endfor
match_index = where(match_id eq 0, match_count)
unmatch_index = where(unmatch_id ne 0, unmatch_count)
if unmatch_count gt 0 then begin
for s=0,match_count-1 do begin
match_id[match_index[s]] = unmatch_id[unmatch_index[s]]
endfor
endif
;printf,110,array1[*,m]
array1[*,m] = match_id
endfor

cthick = 2
for n=1, maxrec1-1 do begin
array1[*,n] = array1[*,n] - 1
array1[0,n] = array1[0,n] + 1
abc = n_elements(array1[*,n])
array2 = make_array(mount_num*2)
for xz=1, abc-1 do begin
;  print,xz,abc,fix(array1[xz,n]),array1[xz,n]
  if fix(array1[xz,n]) eq 254 then begin
  array2[(xz-1)*2] = -360.
  array2[((xz-1)*2)+1] = -90
  endif else begin
  array2[(xz-1)*2] = array[0,fix(array1[xz,n])]
  array2[((xz-1)*2)+1] = array[1,fix(array1[xz,n])]
  endelse
  endfor
array3 = SIXTY(array1[0,n])

case mount_num of
1: printf,120,$
string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)'),$
array2[0],array2[1]
2: printf,120,$
string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)'),$
array2[0],array2[1],array2[2],array2[3]
3: printf,120,$
string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)'),$
array2[0],array2[1],array2[2],array2[3],array2[4],array2[5]
4:printf,120,$
string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)'),$
array2[0],array2[1],array2[2],array2[3],array2[4],array2[5],array2[6],array2[7]
5:printf,120,$
string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)'),$
array2[0],array2[1],array2[2],array2[3],array2[4],array2[5],array2[6],array2[7],array2[8],array2[9]
6:printf,120,$
string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)'),$
array2[0],array2[1],array2[2],array2[3],array2[4],array2[5],array2[6],array2[7],array2[8],array2[9],array2[10],array2[11]
endcase

endfor

close,120

case mount_num of

1: readcol,outputfile1,array_date,array_mount1_ra,array_mount1_dec
2: readcol,outputfile1,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec
3: readcol,outputfile1,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec,array_date,array_mount1_ra,array_mount1_dec
4: readcol,outputfile1,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec  
5: readcol,outputfile1,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec,array_date,array_mount1_ra,array_mount1_dec
6: readcol,outputfile1,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec,array_date,array_mount1_ra,array_mount1_dec$
  ,array_date,array_mount1_ra,array_mount1_dec  
endcase

for r=1,mount_num do begin
  
color_num=r
if color_num eq 4 then color_num = 0
oplot,[array1[0,n],array1[0,n]],[array1[r,n],array1[r,n]],$
psym=1,thick=1,SYMSIZE=1,$
color=color_num
mount_label='Mount ' + (strtrim(strtrim(string(r)),1))
xyouts,9,10+r,$
mount_label,charsize=1.5,color=color_num,charthick=cthick

endfor


device,/close_file
end