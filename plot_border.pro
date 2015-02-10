pro plot_border,ra,dec,sky_mosaic_inputfile,color
coor = long(long(ra)*100+long(dec))
maxrec=FILE_LINES(sky_mosaic_inputfile)
array = make_array(6,maxrec,/long)

openr,20,sky_mosaic_inputfile
point_lun,20,0
readf,20,array
close,20

index = where((coor eq array[0,*]),count)
if count eq 1 then begin 
  coor_high1 = array[1,index[0]]
  dec_high = STRMID(coor_high1, 1, 3, /REVERSE_OFFSET)
  ra_high1 = (coor_high1 - dec_high) / 100
  coor_high2 = array[2,index[0]]
  dec_high = STRMID(coor_high2, 1, 3, /REVERSE_OFFSET)
  ra_high2 = (coor_high2 - dec_high) / 100
  coor_low1 = array[3,index[0]]
  dec_low = STRMID(coor_low1, 1, 3, /REVERSE_OFFSET)
  ra_low1 = (coor_low1 - dec_low) / 100
  coor_low2 = array[4,index[0]]
  dec_low = STRMID(coor_low2, 1, 3, /REVERSE_OFFSET)
  ra_low2 = (coor_low2 - dec_low) / 100
;  print,ra,dec,ra_low1,ra_low2,ra_high1,ra_high2
  
  thick = 5
  oplot,[ra,ra],[dec,dec],$
  psym=1,thick=thick,SYMSIZE=1.5,$
  color=color
  ra_str = (strtrim(strtrim(string(format='(i)',ra)),1))
  dec_str = (strtrim(strtrim(string(format='(i)',dec)),1))
  xyouts,ra-6,dec-4,$
  ra_str,charsize=1.5,color=0,charthick=2
  xyouts,ra-6,dec-9,$
  dec_str,charsize=1.5,color=0,charthick=2
  if ra_high1 le ra_low1 and ra_high2 ge ra_low2 and  ra_high1 le ra_high2 and ra_low2 ge ra_low1  then begin
  oplot,[ra_low1,ra_high1],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low2,ra_high2],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_high1,ra_high2],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low1,ra_low2],[dec_low,dec_low],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  endif 
  if ra_high1 le ra_low1 and ra_high2 ge ra_low2 and  ra_high2 le ra_high1 and ra_low2 ge ra_low1  then begin
  oplot,[ra_low1,ra_high1],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low2,ra_high2],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[0,ra_high2],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_high1,360],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low1,ra_low2],[dec_low,dec_low],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  endif
  if ra_high1 le ra_low1 and ra_high2 ge ra_low2 and  ra_high2 le ra_high1 and ra_low2 le ra_low1  then begin
  oplot,[ra_low1,ra_high1],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low2,ra_high2],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[0,ra_high2],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_high1,360],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[0,ra_low2],[dec_low,dec_low],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low1,360],[dec_low,dec_low],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  endif
  if  (ra_high1 gt ra_low1) and (ra_high2 ge ra_low2) then begin
  oplot,[ra_low1,(ra_high1-360.)],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low1+360.,ra_high1],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low2,ra_high2],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[0,ra_high2],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_high1,360],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low1,ra_low2],[dec_low,dec_low],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color  
  endif
  if  (ra_high1 lt ra_low1) and (ra_high2 lt ra_low2) then begin
  oplot,[ra_low1,ra_high1],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low2,(ra_high2+360.)],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low2-360.,ra_high2],[dec_low,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[0,ra_high2],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_high1,360],[dec_high,dec_high],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  oplot,[ra_low1,ra_low2],[dec_low,dec_low],$
  linestyle=1,thick=thick,SYMSIZE=1.5,$
  color=color
  endif   
endif
end