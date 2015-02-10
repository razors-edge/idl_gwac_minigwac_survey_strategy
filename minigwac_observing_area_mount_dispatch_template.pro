pro minigwac_observing_area_mount_dispatch_template,inputfile,mount_inputfile,star_num_inputfile,sky_mosaic_inputfile,outputfile,outputfile3,mount_num,Julian,long,deta_local,timeBJ_start,timeBJ_end

time_interval_m = 10
time_interval_h = 10. / 60.
step_num = fix( 24. / time_interval_h )
ha_pri_index = (0.05)

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec=FILE_LINES(inputfile)
array = make_array(22,maxrec-1)


openr,50,inputfile
point_lun,50,0
str = ''
readf,50,str
readf,50,array
close,50


coor_str = string(long(array[0,*]))
decdeg = long(STRMID(coor_str, 1, 3, /REVERSE_OFFSET))
radeg = long((long(coor_str) - decdeg) / 100)
BTstart = float(array[7,*])
BTend  = float(array[8,*])

t_int = (timeBJ_end-timeBJ_start)/6.0
t_1_area = 0.1

n_1 = 0
coor_n_tmp = make_array(3,maxrec-1)
for xsf = 0, maxrec-2 do begin
  if ((decdeg[xsf] eq 20) and (abs(((BTend[xsf]+BTstart[xsf])/2) - (timeBJ_start + t_int)) le 2 )) $
    or ((decdeg[xsf] eq 60) and (abs(((BTend[xsf]+BTstart[xsf])/2) - (timeBJ_start + t_int)) le 3 )) then begin
    coor_n_tmp[0,n_1] = radeg[xsf]
    coor_n_tmp[1,n_1] = decdeg[xsf]
    coor_n_tmp[2,n_1] = (timeBJ_start + (1*t_int) + (n_1 * t_1_area))
    n_1 = n_1 +1
    endif
  endfor
badpnts=0
badpnts = Where( coor_n_tmp[2,*] le 0, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
IF goodcount GT 0 THEN begin
  coor_n_1 = make_array(3,goodcount)
  for efs = 0, goodcount-1 do begin
    coor_n_1[*,efs] = coor_n_tmp[*,goodpnts[efs]]
   endfor
endif
t_start_n_1 = timeBJ_start + (1*t_int)
t_end_n_1 = timeBJ_start + (1*t_int) + (n_1 * t_1_area)

n_2 = 0
coor_n_tmp = make_array(3,maxrec-1)
for xsf = 0, maxrec-2 do begin
  if ((decdeg[xsf] eq 20) and $
    (abs(((BTend[xsf]+BTstart[xsf])/2) - (timeBJ_start + (3*t_int))) le 2 )) $
    or ((decdeg[xsf] eq 60) and $
    (abs(((BTend[xsf]+BTstart[xsf])/2) - (timeBJ_start + (3*t_int))) le 3 )) $
    then begin
    coor_n_tmp[0,n_2] = radeg[xsf]
    coor_n_tmp[1,n_2] = decdeg[xsf]
    coor_n_tmp[2,n_2] = (timeBJ_start + (3*t_int) + (n_2 * t_1_area))
    n_2 = n_2 +1
    endif
  endfor
badpnts=0
badpnts = Where( coor_n_tmp[2,*] le 0, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
IF goodcount GT 0 THEN begin
  coor_n_2 = make_array(3,goodcount)
  for efs = 0, goodcount-1 do begin
    coor_n_2[*,efs] = coor_n_tmp[*,goodpnts[efs]]
   endfor
endif
t_start_n_2 = timeBJ_start + (3*t_int)
t_end_n_2 = timeBJ_start + (3*t_int) + (n_2 * t_1_area)

n_3 = 0
coor_n_tmp = make_array(3,maxrec-1)
for xsf = 0, maxrec-2 do begin
  if ((decdeg[xsf] eq 20) and $
    (abs(((BTend[xsf]+BTstart[xsf])/2) - (timeBJ_start + (5*t_int))) le 2 )) $
    or ((decdeg[xsf] eq 60) and $
    (abs(((BTend[xsf]+BTstart[xsf])/2) - (timeBJ_start + (5*t_int))) le 3 )) $
    then begin
    coor_n_tmp[0,n_3] = radeg[xsf]
    coor_n_tmp[1,n_3] = decdeg[xsf]
    coor_n_tmp[2,n_3] = (timeBJ_start + (5*t_int) + (n_3 * t_1_area))
    n_3 = n_3 +1
    endif
  endfor
badpnts=0
badpnts = Where( coor_n_tmp[2,*] le 0, badcount, $
COMPLEMENT=goodpnts, NCOMPLEMENT=goodcount)
IF goodcount GT 0 THEN begin
  coor_n_3 = make_array(3,goodcount)
  for efs = 0, goodcount-1 do begin
    coor_n_3[*,efs] = coor_n_tmp[*,goodpnts[efs]]
   endfor
endif
t_start_n_3 = timeBJ_start + (5*t_int)
t_end_n_3 = timeBJ_start + (5*t_int) + (n_3 * t_1_area)

array2=make_array(5,mount_num)
openr,50,mount_inputfile
point_lun,50,0
str=""
readf,50,str
readf,50,array2
close,50

CALDAT, Julian, Mon, D, Y, H, M, S 
PRINT, Mon, D, Y, H+8, M, S 
hourBJ = (H+8) + (M/60) 



newyear=JULDAY(1,1,Y,0,0,0)
utc = Julian-newyear 
utc_day = floor(utc)

local_sidereal_time,long,Julian,lst

m_array = make_array((mount_num)+1,step_num,/string)
m_obsed_array =  make_array(1,maxrec-1,/long)
m_obsed_num = 0
m_avail_array =  make_array(1,maxrec-1,/long)
m_avail_num = 0
FOR y = 0, mount_num-1 do begin
;FOR y = 0, 4 do begin  
  array1=make_array(2,step_num,/string)
;  print,'y',y,m_obsed_num
;  print,m_obsed_array
  for i=0, step_num-1 do begin
    timeBJ = 8.+(i*time_interval_h)
    
    timeUT = utc_day + (i*time_interval_h/24.0)
    timeUT_julian = newyear+timeUT
    local_sidereal_time,long,timeUT_julian,time_lst
    
    time_Ha = float((time_lst*15.0 -  radeg )/15.0)
    time_Ha_tmp = time_Ha
    indexx = where((time_Ha_tmp[*] gt 12.0),countx) 
    indexy = where((time_Ha_tmp[*] lt (-12.0)),county) 
    if countx gt 0 then time_Ha[indexx] = time_Ha_tmp[indexx] - 24.
    if county gt 0 then time_Ha[indexy] = time_Ha_tmp[indexy] + 24.
;    printf,100,y,'time_lst/n',time_lst,'radeg/n',radeg[11],'rah/n',radeg[11]/15.0,'time_Ha/n',time_Ha_tmp[11],time_Ha[11],'ind1',indexx,'ind2',indexy
    time_length_hour = float(array[9,*])
    gal_num = float(array[17,*])
    field_priority = float(array[21,*])
    priority = ((time_length_hour/max(time_length_hour) * 0.8) + (gal_num/max(gal_num) * 0.2)$
      -(time_Ha*ha_pri_index) + 4.0) / field_priority
    m_array[0,i] = string(timeBJ )
    array1[0,i]  = string(timeBJ )
    if y eq 0 then begin
          ;coor_str,coor_high1_str,coor_high2_str,coor_low1_str,coor_low2_str,$4
    ;time_begin_lst_str,time_end_lst_str,time_begin_bt_str,time_end_bt_str,time_length_hour_str,$9
    ;moonra_begin_str,moondec_begin_str,distance_moon_begin_str,$12
    ;moonra_end_str,moondec_end_str,distance_moon_end_str,moonphase_str,$16
    ;gal_num_str,star_num_str,fieldN_num_str,fieldS_num_str,field_priority_str 21
    ;time_Ha,priority 23 
      array_tmp = [(strtrim(strtrim(string(long(array[0,*])),1)))$
        ,(strtrim(strtrim(string(long(array[1,*])),1)))$
        ,(strtrim(strtrim(string(long(array[2,*])),1)))$
        ,(strtrim(strtrim(string(long(array[3,*])),1)))$
        ,(strtrim(strtrim(string(long(array[4,*])),1)))$
        ,(strtrim(strtrim(string(float(array[5,*])),1)))$
        ,(strtrim(strtrim(string(float(array[6,*])),1)))$
        ,(strtrim(strtrim(string(float(array[7,*])),1)))$
        ,(strtrim(strtrim(string(float(array[8,*])),1)))$
        ,(strtrim(strtrim(string(float(array[9,*])),1)))$
        ,(strtrim(strtrim(string(float(array[10,*])),1)))$
        ,(strtrim(strtrim(string(float(array[11,*])),1)))$
        ,(strtrim(strtrim(string(float(array[12,*])),1)))$
        ,(strtrim(strtrim(string(float(array[13,*])),1)))$
        ,(strtrim(strtrim(string(float(array[14,*])),1)))$
        ,(strtrim(strtrim(string(float(array[15,*])),1)))$
        ,(strtrim(strtrim(string(float(array[16,*])),1)))$
        ,(strtrim(strtrim(string(long(array[17,*])),1)))$
        ,(strtrim(strtrim(string(long(array[18,*])),1)))$
        ,(strtrim(strtrim(string(long(array[19,*])),1)))$
        ,(strtrim(strtrim(string(long(array[20,*])),1)))$
        ,(strtrim(strtrim(string(long(array[21,*])),1)))$
        ,(strtrim(strtrim(string(time_Ha),1)))$
        ,(strtrim(strtrim(string(priority),1)))]
      multicolumnsort,array_tmp,index=23,revert=1
      ary_index=where((float(array_tmp[7,*]) lt timeBJ) and (float(array_tmp[8,*]) ge timeBJ) and $
          (float(array_tmp[22,*]) ge array2[4,y]) and (float(array_tmp[22,*]) le array2[3,y])  and $
          (long(STRMID(array_tmp[0,*], 1, 3, /REVERSE_OFFSET)) ge array2[1,y]) and $
          (long(STRMID(array_tmp[0,*], 1, 3, /REVERSE_OFFSET)) le array2[2,y]),count)
;      print,'count',count
;      if timeBJ ge 19.5 and timeBJ le 21.0 then   print,y,i,timeBJ,array_tmp[0,count],count
      if count gt 0 then begin
        matched = 0    
        array1[1,i] = array_tmp[0,ary_index[0]]
        for z = 0, i-1 do begin
          if(array_tmp[0,ary_index[0]] eq array1[1,z]) and $
            (float(array_tmp[8,ary_index[0]]) ge (timeBJ + 0.5)) then begin
            array1[1,i] = array_tmp[0,ary_index[0]]
;            print,array_tmp[0,ary_index[0]],array1[1,z],array_tmp[1,ary_index[0]],array1[2,z],z,array_tmp[5,ary_index[0]],(timeBJ + 0.5)
            matched = 1
;            print,'matched'
            break
          endif
        endfor
      endif else begin
        array1[1,i] = '-36090'
      endelse
    endif else begin
      for mnt = 1, y do begin
        array_tmp = [(strtrim(strtrim(string(long(array[0,*])),1)))$
          ,(strtrim(strtrim(string(long(array[1,*])),1)))$
          ,(strtrim(strtrim(string(long(array[2,*])),1)))$
          ,(strtrim(strtrim(string(long(array[3,*])),1)))$
          ,(strtrim(strtrim(string(long(array[4,*])),1)))$
          ,(strtrim(strtrim(string(float(array[5,*])),1)))$
          ,(strtrim(strtrim(string(float(array[6,*])),1)))$
          ,(strtrim(strtrim(string(float(array[7,*])),1)))$
          ,(strtrim(strtrim(string(float(array[8,*])),1)))$
          ,(strtrim(strtrim(string(float(array[9,*])),1)))$
          ,(strtrim(strtrim(string(float(array[10,*])),1)))$
          ,(strtrim(strtrim(string(float(array[11,*])),1)))$
          ,(strtrim(strtrim(string(float(array[12,*])),1)))$
          ,(strtrim(strtrim(string(float(array[13,*])),1)))$
          ,(strtrim(strtrim(string(float(array[14,*])),1)))$
          ,(strtrim(strtrim(string(float(array[15,*])),1)))$
          ,(strtrim(strtrim(string(float(array[16,*])),1)))$
          ,(strtrim(strtrim(string(long(array[17,*])),1)))$
          ,(strtrim(strtrim(string(long(array[18,*])),1)))$
          ,(strtrim(strtrim(string(long(array[19,*])),1)))$
          ,(strtrim(strtrim(string(long(array[20,*])),1)))$
          ,(strtrim(strtrim(string(long(array[21,*])),1)))$
          ,(strtrim(strtrim(string(time_Ha),1)))$
          ,(strtrim(strtrim(string(priority),1)))]
        multicolumnsort,array_tmp,index=23,revert=1        
        m_obsed = []        
        for del_m_obsed_arr = 0, maxrec-2 do begin
          inde_del_m_obsed_arr_co = $
            where((array_tmp[0,del_m_obsed_arr] eq m_obsed_array[0,*]),cont_del_m_obsed_arr_co)
            if cont_del_m_obsed_arr_co gt 0 then begin 
                m_obsed = [m_obsed, del_m_obsed_arr]
            endif            
        endfor 
        array_tmp = removerows(array_tmp,m_obsed)
;        printf,100,y,'array_tmp',array_tmp[0,*]
        ary_index=where((float(array_tmp[7,*]) lt timeBJ) and (float(array_tmp[8,*]) ge timeBJ) and $
          (float(array_tmp[22,*]) ge array2[4,y]) and (float(array_tmp[22,*]) le array2[3,y])  and $
          (long(STRMID(array_tmp[0,*], 1, 3, /REVERSE_OFFSET)) ge array2[1,y]) and $
          (long(STRMID(array_tmp[0,*], 1, 3, /REVERSE_OFFSET)) le array2[2,y]),count)
;        printf,100,y,' count',count,array_tmp[1,*]
;      if timeBJ ge 19.5 and timeBJ le 21.0 then   print,y,i,timeBJ,array_tmp[0,count],count
        if count gt 0 then begin
          matched = 0    
          array1[1,i] = array_tmp[0,ary_index[0]]
          for z = 0, i-1 do begin
            if(array_tmp[0,ary_index[0]] eq array1[1,z]) and $
              (float(array_tmp[8,ary_index[0]]) ge (timeBJ + 0.5)) then begin
              array1[1,i] = array_tmp[0,ary_index[0]]
;              print,array_tmp[0,ary_index[0]],array1[1,z],array_tmp[1,ary_index[0]],array1[2,z],z,array_tmp[5,ary_index[0]],(timeBJ + 0.5)
              matched = 1
;              print,'matched'
              break
            endif
          endfor
        endif else begin
          array1[1,i] = '-36090'
        endelse   
;        if timeBJ ge 19.5 and timeBJ le 21.0 then begin
;          print,'m_obsed_array',m_obsed_array[0,*]
;        endif                
      endfor
    endelse
  endfor
  
  ord1 = uniq(array1[1,*])
  count_oi_arr = make_array(n_elements(ord1),/integer)
  for oi = 0, n_elements(ord1)-1 do begin
;    print,array1[1,ord1[oi]],array1[2,ord1[oi]],ord1[oi],array1[1,ord1[oi-1]+1],array1[2,ord1[oi-1]+1],ord1[oi-1]+1
    a = Where((array1[1,*] eq array1[1,ord1[oi]]),count_oi_1)
    count_oi_arr[oi] = count_oi_1
  endfor
;  print,ord1,'ord1'
;  print,count_oi_arr,'count_oi_arr'
  short_obs_time = 30 / 10
  long_obs_time = 60 / 10
  next_obs_time = 60 / 10
  last_obs_time = 60 / 10
  for ord_oi = 0, n_elements(count_oi_arr)-1 do begin
    if count_oi_arr[ord_oi] lt short_obs_time then begin
      replaced = 0
      for next_ord = ord_oi+1, n_elements(count_oi_arr)-2 do begin
;        print,'next',count_oi_arr[next_ord],ord1[next_ord-1]+1,ord1[ord_oi-1]+1,(ord1[next_ord-1]+1-ord1[ord_oi-1]+1)
        if (count_oi_arr[next_ord]) ge long_obs_time and (ord1[next_ord-1]+1 - ord1[ord_oi-1]+1 le next_obs_time) then begin
          for cor = 0, count_oi_arr[ord_oi]-1 do begin
            array1[1,ord1[ord_oi]-cor] = array1[1,ord1[next_ord]]
;            print,array1[1,ord1[ord_oi]-cor],' to be replaced with ',array1[1,ord1[next_ord]]
          endfor
          replaced = 1 
          break
        endif  
      endfor
      if replaced eq 0 then begin
        for pre_ord = ord_oi-1, 0 do begin
;          print,'pre',count_oi_arr[pre_ord],ord1[ord_oi],ord1[pre_ord],(ord1[ord_oi] - ord1[pre_ord])
          if (count_oi_arr[pre_ord]) ge long_obs_time and (ord1[ord_oi] - ord1[pre_ord] lt last_obs_time) then begin
            for cor = 0, count_oi_arr[ord_oi]-1 do begin
              array1[1,ord1[ord_oi]-cor] = array1[1,ord1[pre_ord]]            
;              print,array1[1,ord1[ord_oi]-cor],' to be replaced with ',array1[1,ord1[pre_ord]]
            endfor
            replaced = 1 
          endif 
          break 
        endfor
      endif
    endif
  endfor
  
  m_array[y+1,*] = array1[1,*]
  m_obsed_arr_ord1 = m_array[y+1,*]
  m_obsed_ord = uniq(m_obsed_arr_ord1)
  for m_o_oi = 0, n_elements(m_obsed_ord)-1 do begin
    if (m_array[y+1,m_obsed_ord[m_o_oi]] ne '-36090')  then begin
      m_obsed_array[0,m_obsed_num] = m_array[y+1,m_obsed_ord[m_o_oi]] 
      m_obsed_num = m_obsed_num + 1
    endif
  endfor
endfor

temp_mode_on_1 = 0
temp_mode_on_2 = 0
temp_mode_on_3 = 0
for z=0,n_elements(m_array[0,*])-1 do begin
  if float(m_array[0,z]) ge t_start_n_1 $
    and float(m_array[0,z]) le t_end_n_1 $
    and temp_mode_on_1 eq 0 then begin
  temp_mode_on_1 = 1
  for sfv = 0, n_1-1 do begin
  array3 = SIXTY(coor_n_1[2,sfv])
  time_hms = string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)')
  radeg1 = coor_n_1[0,sfv]
  decdeg1 = coor_n_1[1,sfv]
  case mount_num of
  1: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 '
    end
  2: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end
  3: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end  
  4: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 '
    end
  5: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end
  6: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end  
  endcase  
  endfor
  endif

  if float(m_array[0,z]) ge t_start_n_2 $
    and float(m_array[0,z]) le t_end_n_2 $
    and temp_mode_on_2 eq 0 then begin
  temp_mode_on_2 = 1
  for sfv = 0, n_2-1 do begin
  array3 = SIXTY(coor_n_2[2,sfv])
  time_hms = string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)')
  radeg1 = coor_n_2[0,sfv]
  decdeg1 = coor_n_2[1,sfv]
  case mount_num of
  1: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 '
    end
  2: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end
  3: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end  
  4: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 '
    end
  5: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end
  6: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end  
  endcase  
  endfor
  endif

  if float(m_array[0,z]) ge t_start_n_3 $
    and float(m_array[0,z]) le t_end_n_3 $
    and temp_mode_on_3 eq 0 then begin
  temp_mode_on_3 = 1
  for sfv = 0, n_3-1 do begin
  array3 = SIXTY(coor_n_3[2,sfv])
  time_hms = string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)')
  radeg1 = coor_n_3[0,sfv]
  decdeg1 = coor_n_3[1,sfv]
  case mount_num of
  1: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 '
    end
  2: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end
  3: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end  
  4: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 '
    end
  5: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end
  6: begin
    printf,120,$
    time_hms,radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',$
    radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 ',radeg1,decdeg1,' 7 '
    end  
  endcase  
  endfor
  endif
    
  if (float(m_array[0,z]) gt timeBJ_start and $
    float(m_array[0,z]) lt timeBJ_end )and $
    (float(m_array[0,z]) lt t_start_n_1 or $
    float(m_array[0,z]) gt t_end_n_1) and $
    (float(m_array[0,z]) lt t_start_n_2 or $
    float(m_array[0,z]) gt t_end_n_2) and $
    (float(m_array[0,z]) lt t_start_n_3 or $
    float(m_array[0,z]) gt t_end_n_3) $
    then begin
  array3 = SIXTY(m_array[0,z])
  time_hms = string(fix(array3[0]),fix(array3[1]),fix(array3[2]),format='(i02,":",i02,":",i02)')
;  print,time_hms
  case mount_num of
  1: begin
    decdeg1 = float(STRMID(m_array[1,z], 1, 3, /REVERSE_OFFSET))
    radeg1 = float((long(m_array[1,z]) - decdeg1) / 100)
    if m_array[1,z] eq '-36090' then begin
      radeg1 = -360.0
      decdeg1 = -90.0
      endif
    printf,120,$
    time_hms,radeg1,decdeg1,' 1 '
    oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
    psym=1,thick=1,SYMSIZE=1,$
    color=1
    end
  2: begin
    decdeg1 = long(STRMID(m_array[1,z], 1, 3, /REVERSE_OFFSET))
    radeg1 = long((long(m_array[1,z]) - decdeg1) / 100)
    if m_array[1,z] eq '-36090' then begin
      radeg1 = -360.0
      decdeg1 = -90.0
      endif
    decdeg2 = long(STRMID(m_array[2,z], 1, 3, /REVERSE_OFFSET))
    radeg2 = long((long(m_array[2,z]) - decdeg2) / 100)
    if m_array[2,z] eq '-36090' then begin
      radeg2 = -360.0
      decdeg2 = -90.0
      endif
    printf,120,$
    time_hms,radeg1,decdeg1,' 1 ',radeg2,decdeg2,' 1 '
    end
  3: begin
    decdeg1 = long(STRMID(m_array[1,z], 1, 3, /REVERSE_OFFSET))
    radeg1 = long((long(m_array[1,z]) - decdeg1) / 100)
    if m_array[1,z] eq '-36090' then begin
      radeg1 = -360.0
      decdeg1 = -90.0
      endif
    decdeg2 = long(STRMID(m_array[2,z], 1, 3, /REVERSE_OFFSET))
    radeg2 = long((long(m_array[2,z]) - decdeg2) / 100)
    if m_array[2,z] eq '-36090' then begin
      radeg2 = -360.0
      decdeg2 = -90.0
      endif
    decdeg3 = long(STRMID(m_array[3,z], 1, 3, /REVERSE_OFFSET))
    radeg3 = long((long(m_array[3,z]) - decdeg3) / 100)
    if m_array[3,z] eq '-36090' then begin
      radeg3 = -360.0
      decdeg3 = -90.0
      endif
    printf,120,$
    time_hms,radeg1,decdeg1,' 1 ',radeg2,decdeg2,' 1 ',radeg3,decdeg3,' 1 '
    end  
  4: begin
    decdeg1 = long(STRMID(m_array[1,z], 1, 3, /REVERSE_OFFSET))
    radeg1 = long((long(m_array[1,z]) - decdeg1) / 100)
    if m_array[1,z] eq '-36090' then begin
      radeg1 = -360.0
      decdeg1 = -90.0
      endif
    decdeg2 = long(STRMID(m_array[2,z], 1, 3, /REVERSE_OFFSET))
    radeg2 = long((long(m_array[2,z]) - decdeg2) / 100)
    if m_array[2,z] eq '-36090' then begin
      radeg2 = -360.0
      decdeg2 = -90.0
      endif
    decdeg3 = long(STRMID(m_array[3,z], 1, 3, /REVERSE_OFFSET))
    radeg3 = long((long(m_array[3,z]) - decdeg3) / 100)
    if m_array[3,z] eq '-36090' then begin
      radeg3 = -360.0
      decdeg3 = -90.0
      endif
    decdeg4 = long(STRMID(m_array[4,z], 1, 3, /REVERSE_OFFSET))
    radeg4 = long((long(m_array[4,z]) - decdeg4) / 100)
    if m_array[4,z] eq '-36090' then begin
      radeg4 = -360.0
      decdeg4 = -90.0
      endif
    printf,120,$
    time_hms,radeg1,decdeg1,' 1 ',radeg2,decdeg2,' 1 ',radeg3,decdeg3,' 1 ',radeg4,decdeg4,' 1 '
    end
  5: begin
    decdeg1 = long(STRMID(m_array[1,z], 1, 3, /REVERSE_OFFSET))
    radeg1 = long((long(m_array[1,z]) - decdeg1) / 100)
    if m_array[1,z] eq '-36090' then begin
      radeg1 = -360.0
      decdeg1 = -90.0
      endif
    decdeg2 = long(STRMID(m_array[2,z], 1, 3, /REVERSE_OFFSET))
    radeg2 = long((long(m_array[2,z]) - decdeg2) / 100)
    if m_array[2,z] eq '-36090' then begin
      radeg2 = -360.0
      decdeg2 = -90.0
      endif
    decdeg3 = long(STRMID(m_array[3,z], 1, 3, /REVERSE_OFFSET))
    radeg3 = long((long(m_array[3,z]) - decdeg3) / 100)
    if m_array[3,z] eq '-36090' then begin
      radeg3 = -360.0
      decdeg3 = -90.0
      endif
    decdeg4 = long(STRMID(m_array[4,z], 1, 3, /REVERSE_OFFSET))
    radeg4 = long((long(m_array[4,z]) - decdeg4) / 100)
    if m_array[4,z] eq '-36090' then begin
      radeg4 = -360.0
      decdeg4 = -90.0
      endif
    decdeg5 = long(STRMID(m_array[5,z], 1, 3, /REVERSE_OFFSET))
    radeg5 = long((long(m_array[5,z]) - decdeg5) / 100)
    if m_array[5,z] eq '-36090' then begin
      radeg5 = -360.0
      decdeg5 = -90.0
      endif
    printf,120,$
    time_hms,radeg1,decdeg1,' 1 ',radeg2,decdeg2,' 1 ',radeg3,decdeg3,' 1 ',radeg4,decdeg4,' 1 ',radeg5,decdeg5,' 1 '
    end
  6: begin
    decdeg1 = float(STRMID(m_array[1,z], 1, 3, /REVERSE_OFFSET))
    radeg1 = float((long(m_array[1,z]) - decdeg1) / 100)
    if m_array[1,z] eq '-36090' then begin
      radeg1 = -360.
      decdeg1 = -90.
      endif
    decdeg2 = float(STRMID(m_array[2,z], 1, 3, /REVERSE_OFFSET))
    radeg2 = float((long(m_array[2,z]) - decdeg2) / 100)
    if m_array[2,z] eq '-36090' then begin
      radeg2 = -360.
      decdeg2 = -90.
      endif
    decdeg3 = float(STRMID(m_array[3,z], 1, 3, /REVERSE_OFFSET))
    radeg3 = float((long(m_array[3,z]) - decdeg3) / 100)
    if m_array[3,z] eq '-36090' then begin
      radeg3 = -360.
      decdeg3 = -90.
      endif
    decdeg4 = float(STRMID(m_array[4,z], 1, 3, /REVERSE_OFFSET))
    radeg4 = float((long(m_array[4,z]) - decdeg4) / 100)
    if m_array[4,z] eq '-36090' then begin
      radeg4 = -360.
      decdeg4 = -90.
      endif
    decdeg5 = float(STRMID(m_array[5,z], 1, 3, /REVERSE_OFFSET))
    radeg5 = float((long(m_array[5,z]) - decdeg5) / 100)
    if m_array[5,z] eq '-36090' then begin
      radeg5 = -360.
      decdeg5 = -90.
      endif
    decdeg6 = float(STRMID(m_array[6,z], 1, 3, /REVERSE_OFFSET))
    radeg6 = float((long(m_array[6,z]) - decdeg6) / 100)
    if m_array[6,z] eq '-36090' then begin
      radeg6 = -360.
      decdeg6 = -90.
      endif
    printf,120,$
    time_hms,radeg1,decdeg1,' 1 ',radeg2,decdeg2,' 1 ',radeg3,decdeg3,' 1 ',radeg4,decdeg4,' 1 ',radeg5,decdeg5,' 1 ',radeg6,decdeg6,' 1 '
    
    oplot,[float(radeg1),float(radeg1)],[float(decdeg1),float(decdeg1)],$
    psym=1,thick=1,SYMSIZE=1,$
    color=1  
    oplot,[float(radeg2),float(radeg2)],[float(decdeg2),float(decdeg2)],$
    psym=1,thick=1,SYMSIZE=1,$
    color=2
    oplot,[float(radeg3),float(radeg3)],[float(decdeg3),float(decdeg3)],$
    psym=1,thick=1,SYMSIZE=1,$
    color=3
    oplot,[float(radeg4),float(radeg4)],[float(decdeg4),float(decdeg4)],$
    psym=1,thick=1,SYMSIZE=1,$
    color=0
    oplot,[float(radeg5),float(radeg5)],[float(decdeg5),float(decdeg5)],$
    psym=1,thick=1,SYMSIZE=1,$
    color=5 
    oplot,[float(radeg6),float(radeg6)],[float(decdeg6),float(decdeg6)],$
    psym=1,thick=1,SYMSIZE=1,$
    color=6 
    
    end  
  endcase  
  endif
endfor

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile3 + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

xrange0=0
xrange1=360
yrange0=-10
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
xrange=[xrange0,xrange1],yrange=[yrange0,yrange1], $
position=[0.1,0.1,0.9,1],/noerase,/nodata

;oplot,[hourBJ,hourBJ],[yrange0,yrange1],color=1,thick=3

for r=1,mount_num do begin
color_num=r
if color_num eq 4 then color_num = 0
mount_label='Mount ' + (strtrim(strtrim(string(r)),1))
xyouts,r * 40,-8,$
mount_label,charsize=1,color=color_num,charthick=cthick
endfor

cthick = 1.8
csize = 0.8
case mount_num of
1: begin
  m_obsed_ord_ma1 = uniq(m_array[1,*])
  for m_o_oi_ma1 = 0, n_elements(m_obsed_ord_ma1)-1 do begin
    if m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]] ne '-36090' then begin
;      print,m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]
      decdeg1 = float(STRMID(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]], 1, 3, /REVERSE_OFFSET))
      radeg1 = float((long(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]) - decdeg1) / 100)
      oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=1
      label = (strtrim(strtrim(string(format='(i)',radeg1)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg1)),1))
      xyouts,radeg1-15,decdeg1+2,$
      label,charsize=csize,color=1,charthick=cthick      
    endif
  endfor
  end
2: begin
  m_obsed_ord_ma1 = uniq(m_array[1,*])
  for m_o_oi_ma1 = 0, n_elements(m_obsed_ord_ma1)-1 do begin
    if m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]] ne '-36090' then begin
;      print,m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]
      decdeg1 = float(STRMID(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]], 1, 3, /REVERSE_OFFSET))
      radeg1 = float((long(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]) - decdeg1) / 100)
      oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=1
      label = (strtrim(strtrim(string(format='(i)',radeg1)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg1)),1))
      xyouts,radeg1-15,decdeg1+2,$
      label,charsize=csize,color=1,charthick=cthick      
    endif
  endfor
  m_obsed_ord_ma2 = uniq(m_array[2,*])
  for m_o_oi_ma2 = 0, n_elements(m_obsed_ord_ma2)-1 do begin
    if m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]] ne '-36090' then begin
;      print,m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]
      decdeg2 = float(STRMID(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]], 1, 3, /REVERSE_OFFSET))
      radeg2 = float((long(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]) - decdeg1) / 100)
      oplot,[radeg2,radeg2],[decdeg2,decdeg2 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=2
      label = (strtrim(strtrim(string(format='(i)',radeg2)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg2)),1))
      xyouts,radeg2-15,decdeg2+2,$
      label,charsize=csize,color=2,charthick=cthick      
    endif
  endfor  
  end
3: begin
  m_obsed_ord_ma1 = uniq(m_array[1,*])
  for m_o_oi_ma1 = 0, n_elements(m_obsed_ord_ma1)-1 do begin
    if m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]] ne '-36090' then begin
;      print,m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]
      decdeg1 = float(STRMID(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]], 1, 3, /REVERSE_OFFSET))
      radeg1 = float((long(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]) - decdeg1) / 100)
      oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=1
      label = (strtrim(strtrim(string(format='(i)',radeg1)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg1)),1))
      xyouts,radeg1-15,decdeg1+2,$
      label,charsize=csize,color=1,charthick=cthick      
    endif
  endfor
  m_obsed_ord_ma2 = uniq(m_array[2,*])
  for m_o_oi_ma2 = 0, n_elements(m_obsed_ord_ma2)-1 do begin
    if m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]] ne '-36090' then begin
;      print,m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]
      decdeg2 = float(STRMID(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]], 1, 3, /REVERSE_OFFSET))
      radeg2 = float((long(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]) - decdeg2) / 100)
      oplot,[radeg2,radeg2],[decdeg2,decdeg2 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=2
      label = (strtrim(strtrim(string(format='(i)',radeg2)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg2)),1))
      xyouts,radeg2-15,decdeg2+2,$
      label,charsize=csize,color=2,charthick=cthick      
    endif
  endfor 
  m_obsed_ord_ma3 = uniq(m_array[3,*])
  for m_o_oi_ma3 = 0, n_elements(m_obsed_ord_ma3)-1 do begin
    if m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]] ne '-36090' then begin
;      print,m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]
      decdeg3 = float(STRMID(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]], 1, 3, /REVERSE_OFFSET))
      radeg3 = float((long(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]) - decdeg3) / 100)
      oplot,[radeg3,radeg3],[decdeg3,decdeg3 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=3
      label = (strtrim(strtrim(string(format='(i)',radeg3)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg3)),1))
      xyouts,radeg3-15,decdeg3+2,$
      label,charsize=csize,color=3,charthick=cthick      
    endif
  endfor  
  end
4: begin
  m_obsed_ord_ma1 = uniq(m_array[1,*])
  for m_o_oi_ma1 = 0, n_elements(m_obsed_ord_ma1)-1 do begin
    if m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]] ne '-36090' then begin
;      print,m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]
      decdeg1 = float(STRMID(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]], 1, 3, /REVERSE_OFFSET))
      radeg1 = float((long(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]) - decdeg1) / 100)
      oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=1
      label = (strtrim(strtrim(string(format='(i)',radeg1)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg1)),1))
      xyouts,radeg1-15,decdeg1+2,$
      label,charsize=csize,color=1,charthick=cthick      
    endif
  endfor
  m_obsed_ord_ma2 = uniq(m_array[2,*])
  for m_o_oi_ma2 = 0, n_elements(m_obsed_ord_ma2)-1 do begin
    if m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]] ne '-36090' then begin
;      print,m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]
      decdeg2 = float(STRMID(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]], 1, 3, /REVERSE_OFFSET))
      radeg2 = float((long(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]) - decdeg2) / 100)
      oplot,[radeg2,radeg2],[decdeg2,decdeg2 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=2
      label = (strtrim(strtrim(string(format='(i)',radeg2)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg2)),1))
      xyouts,radeg2-15,decdeg2+2,$
      label,charsize=csize,color=2,charthick=cthick      
    endif
  endfor 
  m_obsed_ord_ma3 = uniq(m_array[3,*])
  for m_o_oi_ma3 = 0, n_elements(m_obsed_ord_ma3)-1 do begin
    if m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]] ne '-36090' then begin
;      print,m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]
      decdeg3 = float(STRMID(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]], 1, 3, /REVERSE_OFFSET))
      radeg3 = float((long(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]) - decdeg3) / 100)
      oplot,[radeg3,radeg3],[decdeg3,decdeg3 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=3
      label = (strtrim(strtrim(string(format='(i)',radeg3)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg3)),1))
      xyouts,radeg3-15,decdeg3+2,$
      label,charsize=csize,color=3,charthick=cthick      
    endif
  endfor  
  m_obsed_ord_ma4 = uniq(m_array[4,*])
  for m_o_oi_ma4 = 0, n_elements(m_obsed_ord_ma4)-1 do begin
    if m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]] ne '-36090' then begin
;      print,m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]]
      decdeg4 = float(STRMID(m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]], 1, 3, /REVERSE_OFFSET))
      radeg4 = float((long(m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]]) - decdeg4) / 100)
      oplot,[radeg4,radeg4],[decdeg4,decdeg4],$
      psym=1,thick=1,SYMSIZE=1,$
      color=0
      label = (strtrim(strtrim(string(format='(i)',radeg4)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg4)),1))
      xyouts,radeg4-15,decdeg4+2,$
      label,charsize=csize,color=0,charthick=cthick      
    endif
  endfor
  end
5: begin
  m_obsed_ord_ma1 = uniq(m_array[1,*])
  for m_o_oi_ma1 = 0, n_elements(m_obsed_ord_ma1)-1 do begin
    if m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]] ne '-36090' then begin
;      print,m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]
      decdeg1 = float(STRMID(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]], 1, 3, /REVERSE_OFFSET))
      radeg1 = float((long(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]) - decdeg1) / 100)
      oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=1
      label = (strtrim(strtrim(string(format='(i)',radeg1)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg1)),1))
      xyouts,radeg1-15,decdeg1+2,$
      label,charsize=csize,color=1,charthick=cthick      
    endif
  endfor
  m_obsed_ord_ma2 = uniq(m_array[2,*])
  for m_o_oi_ma2 = 0, n_elements(m_obsed_ord_ma2)-1 do begin
    if m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]] ne '-36090' then begin
;      print,m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]
      decdeg2 = float(STRMID(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]], 1, 3, /REVERSE_OFFSET))
      radeg2 = float((long(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]) - decdeg2) / 100)
      oplot,[radeg2,radeg2],[decdeg2,decdeg2 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=2
      label = (strtrim(strtrim(string(format='(i)',radeg2)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg2)),1))
      xyouts,radeg2-15,decdeg2+2,$
      label,charsize=csize,color=2,charthick=cthick      
    endif
  endfor 
  m_obsed_ord_ma3 = uniq(m_array[3,*])
  for m_o_oi_ma3 = 0, n_elements(m_obsed_ord_ma3)-1 do begin
    if m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]] ne '-36090' then begin
;      print,m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]
      decdeg3 = float(STRMID(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]], 1, 3, /REVERSE_OFFSET))
      radeg3 = float((long(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]) - decdeg3) / 100)
      oplot,[radeg3,radeg3],[decdeg3,decdeg3 ],$
      psym=1,thick=1,SYMSIZE=1,$
      color=3
      label = (strtrim(strtrim(string(format='(i)',radeg3)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg3)),1))
      xyouts,radeg3-15,decdeg3+2,$
      label,charsize=csize,color=3,charthick=cthick      
    endif
  endfor  
  m_obsed_ord_ma4 = uniq(m_array[4,*])
  for m_o_oi_ma4 = 0, n_elements(m_obsed_ord_ma4)-1 do begin
    if m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]] ne '-36090' then begin
;      print,m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]]
      decdeg4 = float(STRMID(m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]], 1, 3, /REVERSE_OFFSET))
      radeg4 = float((long(m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]]) - decdeg4) / 100)
      oplot,[radeg4,radeg4],[decdeg4,decdeg4],$
      psym=1,thick=1,SYMSIZE=1,$
      color=0
      label = (strtrim(strtrim(string(format='(i)',radeg4)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg4)),1))
      xyouts,radeg4-15,decdeg4+2,$
      label,charsize=csize,color=0,charthick=cthick      
    endif
  endfor
  m_obsed_ord_ma5 = uniq(m_array[5,*])
  for m_o_oi_ma5 = 0, n_elements(m_obsed_ord_ma5)-1 do begin
    if m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]] ne '-36090' then begin
;      print,m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]]
      decdeg5 = float(STRMID(m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]], 1, 3, /REVERSE_OFFSET))
      radeg5 = float((long(m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]]) - decdeg5) / 100)
      oplot,[radeg5,radeg5],[decdeg5,decdeg5],$
      psym=1,thick=1,SYMSIZE=1,$
      color=5
      label = (strtrim(strtrim(string(format='(i)',radeg5)),1)+','+$
      strtrim(strtrim(string(format='(i)',decdeg5)),1))
      xyouts,radeg5-15,decdeg5+2,$
      label,charsize=csize,color=5,charthick=cthick      
    endif
  endfor
  end 
6: begin
  m_obsed_ord_ma1 = uniq(m_array[1,*])
  for m_o_oi_ma1 = 0, n_elements(m_obsed_ord_ma1)-1 do begin
    if m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]] ne '-36090' then begin
;      print,m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]
      decdeg1 = float(STRMID(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]], 1, 3, /REVERSE_OFFSET))
      radeg1 = float((long(m_array[1,m_obsed_ord_ma1[m_o_oi_ma1]]) - decdeg1) / 100)
;      oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
;      psym=1,thick=1,SYMSIZE=1,$
;      color=1
;      label = (strtrim(strtrim(string(format='(i)',radeg1)),1)+','+$
;      strtrim(strtrim(string(format='(i)',decdeg1)),1))
;      xyouts,radeg1-15,decdeg1+2,$
;      label,charsize=csize,color=1,charthick=cthick 
      plot_border,radeg1,decdeg1,sky_mosaic_inputfile,1   
    endif
  endfor
  m_obsed_ord_ma2 = uniq(m_array[2,*])
  for m_o_oi_ma2 = 0, n_elements(m_obsed_ord_ma2)-1 do begin
    if m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]] ne '-36090' then begin
;      print,m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]
      decdeg2 = float(STRMID(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]], 1, 3, /REVERSE_OFFSET))
      radeg2 = float((long(m_array[2,m_obsed_ord_ma2[m_o_oi_ma2]]) - decdeg2) / 100)
;      oplot,[radeg2,radeg2],[decdeg2,decdeg2 ],$
;      psym=1,thick=1,SYMSIZE=1,$
;      color=2
;      label = (strtrim(strtrim(string(format='(i)',radeg2)),1)+','+$
;      strtrim(strtrim(string(format='(i)',decdeg2)),1))
;      xyouts,radeg2-15,decdeg2+2,$
;      label,charsize=csize,color=2,charthick=cthick      
      plot_border,radeg2,decdeg2,sky_mosaic_inputfile,2
    endif
  endfor 
  m_obsed_ord_ma3 = uniq(m_array[3,*])
  for m_o_oi_ma3 = 0, n_elements(m_obsed_ord_ma3)-1 do begin
    if m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]] ne '-36090' then begin
;      print,m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]
      decdeg3 = float(STRMID(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]], 1, 3, /REVERSE_OFFSET))
      radeg3 = float((long(m_array[3,m_obsed_ord_ma3[m_o_oi_ma3]]) - decdeg3) / 100)
;      oplot,[radeg3,radeg3],[decdeg3,decdeg3 ],$
;      psym=1,thick=1,SYMSIZE=1,$
;      color=3
;      label = (strtrim(strtrim(string(format='(i)',radeg3)),1)+','+$
;      strtrim(strtrim(string(format='(i)',decdeg3)),1))
;      xyouts,radeg3-15,decdeg3+2,$
;      label,charsize=csize,color=3,charthick=cthick 
      plot_border,radeg3,decdeg3,sky_mosaic_inputfile,3     
    endif
  endfor  
  m_obsed_ord_ma4 = uniq(m_array[4,*])
  for m_o_oi_ma4 = 0, n_elements(m_obsed_ord_ma4)-1 do begin
    if m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]] ne '-36090' then begin
;      print,m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]]
      decdeg4 = float(STRMID(m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]], 1, 3, /REVERSE_OFFSET))
      radeg4 = float((long(m_array[4,m_obsed_ord_ma4[m_o_oi_ma4]]) - decdeg4) / 100)
;      oplot,[radeg4,radeg4],[decdeg4,decdeg4],$
;      psym=1,thick=1,SYMSIZE=1,$
;      color=0
;      label = (strtrim(strtrim(string(format='(i)',radeg4)),1)+','+$
;      strtrim(strtrim(string(format='(i)',decdeg4)),1))
;      xyouts,radeg4-15,decdeg4+2,$
;      label,charsize=csize,color=0,charthick=cthick
      plot_border,radeg4,decdeg4,sky_mosaic_inputfile,0      
    endif
  endfor
  m_obsed_ord_ma5 = uniq(m_array[5,*])
  for m_o_oi_ma5 = 0, n_elements(m_obsed_ord_ma5)-1 do begin
    if m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]] ne '-36090' then begin
;      print,m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]]
      decdeg5 = float(STRMID(m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]], 1, 3, /REVERSE_OFFSET))
      radeg5 = float((long(m_array[5,m_obsed_ord_ma5[m_o_oi_ma5]]) - decdeg5) / 100)
;      oplot,[radeg5,radeg5],[decdeg5,decdeg5],$
;      psym=1,thick=1,SYMSIZE=1,$
;      color=5
;      label = (strtrim(strtrim(string(format='(i)',radeg5)),1)+','+$
;      strtrim(strtrim(string(format='(i)',decdeg5)),1))
;      xyouts,radeg5-15,decdeg5+2,$
;      label,charsize=csize,color=5,charthick=cthick 
      plot_border,radeg5,decdeg5,sky_mosaic_inputfile,5     
    endif
  endfor
  m_obsed_ord_ma6 = uniq(m_array[6,*])
  for m_o_oi_ma6 = 0, n_elements(m_obsed_ord_ma6)-1 do begin
    if m_array[6,m_obsed_ord_ma6[m_o_oi_ma6]] ne '-36090' then begin
;      print,m_array[6,m_obsed_ord_ma6[m_o_oi_ma6]]
      decdeg6 = float(STRMID(m_array[6,m_obsed_ord_ma6[m_o_oi_ma6]], 1, 3, /REVERSE_OFFSET))
      radeg6 = float((long(m_array[6,m_obsed_ord_ma6[m_o_oi_ma6]]) - decdeg6) / 100)
;      oplot,[radeg6,radeg6],[decdeg6,decdeg6],$
;      psym=1,thick=1,SYMSIZE=1,$
;      color=6
;      label = (strtrim(strtrim(string(format='(i)',radeg6)),1)+','+$
;      strtrim(strtrim(string(format='(i)',decdeg6)),1))
;      xyouts,radeg5-15,decdeg6+2,$
;      label,charsize=csize,color=6,charthick=cthick 
      plot_border,radeg6,decdeg6,sky_mosaic_inputfile,6     
    endif
  endfor
  end 
;  decdeg1 = float(STRMID(m_array[1,z], 1, 3, /REVERSE_OFFSET))
;  radeg1 = float((long(m_array[1,z]) - decdeg1) / 100)
;  if m_array[1,z] eq '-36090' then begin
;    radeg1 = -360.0
;    decdeg1 = -90.0
;    endif
;  printf,120,$
;  time_hms,radeg1,decdeg1,' 1 '
;  oplot,[radeg1,radeg1],[decdeg1,decdeg1 ],$
;  psym=1,thick=1,SYMSIZE=1,$
;  color=1
;  end
;2: begin
; 
endcase  

device,/close_file
cgPS2Raster, outputfile3+'.ps', /JPEG,/PORTRAIT

end

