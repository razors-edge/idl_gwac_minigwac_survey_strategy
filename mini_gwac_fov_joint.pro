pro mini_gwac_fov_joint,cen1_ra,cen1_dec,vertex1_ra1,vertex1_dec1,vertex1_ra2,vertex1_dec2,rotation1,cen2_ra,cen2_dec,vertex2_ra1,vertex2_dec1,vertex2_ra2,vertex2_dec2,rotation2
close,/all

;ploting map
;glactc,radeg,decdeg,2000,ragaladeg,decgaladeg,1, /degree
map_set,0,180,/aitoff,/horizon,/noerase
map_grid

oplot,[cen1_ra,cen1_ra],[cen1_dec,cen1_dec],$
psym=1,thick=3,SYMSIZE=1,$
color=2
label = (strtrim(strtrim(string(format='(i)',cen1_ra)),1)+','+$
strtrim(strtrim(string(format='(i)',cen1_dec)),1))
xyouts,cen1_ra*0.97,cen1_dec*1.01,$
label,charsize=0.6,color=0,charthick=cthick

rotate_ra = cen1_ra * (1+cos(rotation1*!PI/180.0))
rotate_dec = cen1_ra * (1+sin(rotation1*!PI/180.0))
oplot,[cen1_ra,vertex1_ra2],[vertex1_dec1,vertex1_dec2],$
linestyle=0,thick=5,color=3


oplot,[vertex1_ra1,vertex1_ra2],[vertex1_dec1,vertex1_dec1],$
linestyle=0,thick=5,color=3
oplot,[vertex1_ra1,vertex1_ra2],[vertex1_dec2,vertex1_dec2],$
linestyle=0,thick=5,color=3
oplot,[vertex1_ra1,vertex1_ra1],[vertex1_dec1,vertex1_dec2],$
linestyle=0,thick=5,color=3
oplot,[vertex1_ra2,vertex1_ra2],[vertex1_dec1,vertex1_dec2],$
linestyle=0,thick=5,color=3


label = (strtrim(strtrim(string(format='(i)',vertex1_ra1)),1)+','+$
strtrim(strtrim(string(format='(i)',vertex1_dec1)),1))
xyouts,vertex1_ra1*0.97,vertex1_dec1*1.01,$
label,charsize=0.6,color=0,charthick=cthick

label = (strtrim(strtrim(string(format='(i)',vertex1_ra2)),1)+','+$
strtrim(strtrim(string(format='(i)',vertex1_dec2)),1))
xyouts,vertex1_ra2*0.97,vertex1_dec2*1.01,$
label,charsize=0.6,color=0,charthick=cthick



xyouts,5,0,'0',charsize=csize,color=0,charthick=cthick
xyouts,180,0,'180',charsize=csize,color=0,charthick=cthick
xyouts,330,0,'360',charsize=csize,color=0,charthick=cthick
xyouts,180,80,'N',charsize=csize,color=0,charthick=cthick
xyouts,180,-90,'S',charsize=csize,color=0,charthick=cthick
xyouts,90,-40,'Equatorial coordinate system',charsize=csize,color=0,charthick=cthick
device,/close_file
print,'Done'
end