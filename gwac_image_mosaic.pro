pro GWAC_image_mosaic
close,/all
;inputfile=filepath('z0024.dat',$
;root_dir='E:\Data\catalogue\RC3\')
outputfile=filepath('GWAC_image_mosaic',$
root_dir='E:\tmp_pool\survey_strategy\')
outputfile1=filepath('GWAC_image_mosaic.dat',$
root_dir='E:\tmp_pool\survey_strategy\')

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0
openw,80,outputfile1,width=3000

;glactc,radeg,decdeg,2000,ragaladeg,decgaladeg,1, /degree
map_set,0,180,/aitoff,/horizon,/noerase
map_grid


printf,80,'Mount RA,   ','M DEC, ','Camera1 RA, C1 DEC,  ','Camera2 RA, C2 DEC,  ','Camera3 RA, C3 DEC,  ','Camera4 RA, C4 DEC '
csize = 0.6
cthick = 1
camera1_ra_d = make_array(181)
camera2_ra_d = make_array(181)
camera3_ra_d = make_array(181)
camera4_ra_d = make_array(181)
camera1_dec_d = make_array(181)
;camera2_dec_d = make_array(181)
for j=-90, 90 do begin
i = j+90
;print,i
dec_cen = j
ra_cen = 150
rad_d = 6
d_deg = rad_d * sqrt(2.)
;camera1_dec_d = dec_cen - rad_d
;camera2_dec_d = dec_cen + rad_d
;d_deg = rad_d * 1.
camera1_dec_d[i] = dec_cen - rad_d
;camera2_dec_d[i] = dec_cen + rad_d
angular_distance_reverse,ra_cen,dec_cen,ra1,ra2,camera1_dec_d[i],d_deg
;angular_distance_reverse,ra_cen,dec_cen,camera3_ra_d,camera4_ra_d,camera2_dec_d,d_deg
;angular_distance_reverse,ra_cen,dec_cen,camera3_ra_d,camera4_ra_d,camera2_dec_d,d_deg

;angular_distance,ra_cen,dec_cen,camera1_ra_d,camera1_dec_d,a1_deg
;angular_distance,camera1_ra_d,camera1_dec_d,camera2_ra_d,camera1_dec_d,a2_deg
;angular_distance,camera1_ra_d,camera1_dec_d,camera3_ra_d,camera2_dec_d,a3_deg
;angular_distance,camera1_ra_d,camera1_dec_d,camera4_ra_d,camera2_dec_d,a4_deg

;print,ra_cen,dec_cen,camera1_ra_d,a1_deg,camera2_ra_d,a2_deg,camera1_dec_d,camera3_ra_d,a3_deg,camera4_ra_d,a4_deg,camera2_dec_d,d_deg

camera1_ra_d[i]=ra1
camera2_ra_d[i]=ra2
print,camera1_ra_d[i],camera2_ra_d[i]
print,ra_cen,dec_cen,camera1_ra_d[i],camera2_ra_d[i],camera1_dec_d[i],d_deg

printf,80,ra_cen-ra_cen, dec_cen,camera1_ra_d[i]-ra_cen,camera1_dec_d[i],camera2_ra_d[i]-ra_cen,camera1_dec_d[i]

oplot,[camera1_ra_d[i],camera1_ra_d[i]],[camera1_dec_d[i],camera1_dec_d[i]],$
psym=1,thick=8,$
color=1

;oplot,[camera3_ra_d,camera3_ra_d],[camera2_dec_d,camera2_dec_d],$
;psym=1,thick=8,$
;color=3

endfor

for j=-90, 90 do begin
dec_cen = j
i = j+90
if (dec_cen mod 25) eq 0 then begin
oplot,[ra_cen,ra_cen],[dec_cen,dec_cen],$
psym=1,thick=8,$
color=0

oplot,[camera1_ra_d[i],camera1_ra_d[i]],[camera1_dec_d[i],camera1_dec_d[i]],$
psym=1,thick=5,color=1
angular_distance_reverse,camera1_ra_d,camera1_dec_d,camera1_ra1_d_nag,camera1_ra1_d_pos,camera1_dec_d-rad_d,d_deg
;angular_distance_reverse,camera1_ra_d,camera1_dec_d+rad_d,camera1_ra2_d_nag,camera1_ra2_d_pos,camera1_dec_d+rad_d,d_deg
oplot,[camera1_ra1_d_nag,camera1_ra1_d_pos],[camera1_dec_d-rad_d,camera1_dec_d-rad_d],$
linestyle=0,thick=2,color=3
oplot,[camera1_ra2_d_nag,camera1_ra2_d_pos],[camera1_dec_d+rad_d,camera1_dec_d+rad_d],$
linestyle=1,thick=2,color=3
oplot,[camera1_ra1_d_nag,camera1_ra2_d_nag],[camera1_dec_d-rad_d,camera1_dec_d+rad_d],$
linestyle=0,thick=2,color=3
oplot,[camera1_ra1_d_pos,camera1_ra2_d_pos],[camera1_dec_d-rad_d,camera1_dec_d+rad_d],$
linestyle=1,thick=2,color=3
xyouts,camera1_ra_d,camera1_dec_d,'C1',charsize=csize,color=0,charthick=cthick

oplot,[camera2_ra_d[i],camera2_ra_d[i]],[camera1_dec_d[i],camera1_dec_d[i]],$
psym=1,thick=5,color=2
;angular_distance_reverse,camera2_ra_d,camera1_dec_d,camera2_ra1_d_nag,camera2_ra1_d_pos,camera1_dec_d-rad_d,d_deg
;angular_distance_reverse,camera2_ra_d,camera1_dec_d+rad_d,camera2_ra2_d_nag,camera2_ra2_d_pos,camera1_dec_d+rad_d,d_deg
;oplot,[camera2_ra1_d_nag,camera2_ra1_d_pos],[camera1_dec_d-rad_d,camera1_dec_d-rad_d],$
;linestyle=0,thick=2,color=3
;oplot,[camera2_ra2_d_nag,camera2_ra2_d_pos],[camera1_dec_d+rad_d,camera1_dec_d+rad_d],$
;linestyle=1,thick=2,color=3
;oplot,[camera2_ra1_d_nag,camera2_ra2_d_nag],[camera1_dec_d-rad_d,camera1_dec_d+rad_d],$
;linestyle=1,thick=2,color=3
;oplot,[camera2_ra1_d_pos,camera2_ra2_d_pos],[camera1_dec_d-rad_d,camera1_dec_d+rad_d],$
;linestyle=0,thick=2,color=3
;xyouts,camera2_ra_d,camera1_dec_d,'C2',charsize=csize,color=0,charthick=cthick

oplot,[camera1_ra_d[i+(2*rad_d)],camera1_ra_d[i+(2*rad_d)]],[camera1_dec_d[i+(2*rad_d)],camera1_dec_d[i+(2*rad_d)]],$
psym=1,thick=5,color=3
;angular_distance_reverse,camera3_ra_d,camera2_dec_d,camera3_ra1_d_nag,camera3_ra1_d_pos,camera2_dec_d-rad_d,d_deg
;angular_distance_reverse,camera3_ra_d,camera2_dec_d+rad_d,camera3_ra2_d_nag,camera3_ra2_d_pos,camera2_dec_d+rad_d,d_deg
;oplot,[camera3_ra1_d_nag,camera3_ra1_d_pos],[camera2_dec_d-rad_d,camera2_dec_d-rad_d],$
;linestyle=1,thick=2,color=3
;oplot,[camera3_ra2_d_nag,camera3_ra2_d_pos],[camera2_dec_d+rad_d,camera2_dec_d+rad_d],$
;linestyle=0,thick=2,color=3
;oplot,[camera3_ra1_d_nag,camera3_ra2_d_nag],[camera2_dec_d-rad_d,camera2_dec_d+rad_d],$
;linestyle=0,thick=2,color=3
;oplot,[camera3_ra1_d_pos,camera3_ra2_d_pos],[camera2_dec_d-rad_d,camera2_dec_d+rad_d],$
;linestyle=1,thick=2,color=3
;xyouts,camera3_ra_d,camera2_dec_d,'C3',charsize=csize,color=0,charthick=cthick

oplot,[camera2_ra_d[i+(2*rad_d)],camera2_ra_d[i+(2*rad_d)]],[camera1_dec_d[i+(2*rad_d)],camera1_dec_d[i+(2*rad_d)]],$
psym=1,thick=5,color=4
;angular_distance_reverse,camera4_ra_d,camera2_dec_d,camera4_ra1_d_nag,camera4_ra1_d_pos,camera2_dec_d-rad_d,d_deg
;angular_distance_reverse,camera4_ra_d,camera2_dec_d+rad_d,camera4_ra2_d_nag,camera4_ra2_d_pos,camera2_dec_d+rad_d,d_deg
;oplot,[camera4_ra1_d_nag,camera4_ra1_d_pos],[camera2_dec_d-rad_d,camera2_dec_d-rad_d],$
;linestyle=1,thick=2,color=3
;oplot,[camera4_ra2_d_nag,camera4_ra2_d_pos],[camera2_dec_d+rad_d,camera2_dec_d+rad_d],$
;linestyle=0,thick=2,color=3
;oplot,[camera4_ra1_d_nag,camera4_ra2_d_nag],[camera2_dec_d-rad_d,camera2_dec_d+rad_d],$
;linestyle=1,thick=2,color=3
;oplot,[camera4_ra1_d_pos,camera4_ra2_d_pos],[camera2_dec_d-rad_d,camera2_dec_d+rad_d],$
;linestyle=0,thick=2,color=3
;xyouts,camera4_ra_d,camera2_dec_d,'C4',charsize=csize,color=0,charthick=cthick

endif
endfor

xyouts,5,0,'0',charsize=csize,color=0,charthick=cthick
xyouts,180,0,'180',charsize=csize,color=0,charthick=cthick
xyouts,330,0,'360',charsize=csize,color=0,charthick=cthick
xyouts,180,80,'N',charsize=csize,color=0,charthick=cthick
xyouts,180,-90,'S',charsize=csize,color=0,charthick=cthick
xyouts,90,-40,'Equatorial coordinate system',charsize=csize,color=0,charthick=cthick
;xyouts,90,-50,'z < 0.01',charsize=csize,color=0,charthick=cthick
;xyouts,90,-50,'z < 0.015',charsize=csize,color=0,charthick=cthick
;xyouts,90,-50,'z < 0.024',charsize=csize,color=0,charthick=cthick

close,80
close,/all
device,/close_file
print,'Done'
end