pro minigwac_star_number_sum
close,/all
inputfile=filepath('sky_area_mosaic_minigwac.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')
inputfile1=filepath('star_number.txt',$
root_dir='E:\WORK\GWAC\survey_strategy\')
outputfile=filepath('sky_area_mosaic_minigwac_star_num.dat',$
root_dir='E:\WORK\GWAC\survey_strategy\')

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec=FILE_LINES(inputfile)
record={coor:0L,coor_high1:0L,coor_high2:0L,coor_low1:0L,coor_low2:0L,gal_number:0L}
data=replicate(record,maxrec)

openr,50,inputfile
point_lun,50,0
readf,50,data
close,50

if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
maxrec1=FILE_LINES(inputfile1)
record1={radeg:0.0d,decdeg:0.0d,number:0L}
data1=replicate(record1,maxrec1)

openr,50,inputfile1
point_lun,50,0
readf,50,data1
close,50
maximun_star = 250000
openw,80,outputfile,width=2000
for k=0, (maxrec1/2) -1 do begin
  racen = data1[k*2].radeg
  deccen = (data1[k*2].decdeg + data1[k*2+1].decdeg)/2.
  number = (data1[k*2].number + data1[k*2+1].number)
  coor = long(long(racen)*100+long(deccen))
  index = where((data.coor eq coor),count)
  if count gt 0 then begin
    if (data1[k*2].number lt maximun_star and data1[k*2+1].number lt maximun_star ) then $
      field_priority = 1
    if (data1[k*2].number ge maximun_star or data1[k*2+1].number ge maximun_star ) then $
      field_priority = 2
    if (data1[k*2].number ge maximun_star and data1[k*2+1].number ge maximun_star ) then $
      field_priority = 3   
    printf,80,data[index].coor,data[index].coor_high1,data[index].coor_high2,$
      data[index].coor_low1,data[index].coor_low2,data[index].gal_number,number,$
      data1[k*2].number,data1[k*2+1].number,field_priority
    print,coor,field_priority
  endif
  endfor

close,80
close,/all
print,'Done'  
end