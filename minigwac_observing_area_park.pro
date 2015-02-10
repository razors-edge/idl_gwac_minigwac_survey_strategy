pro minigwac_observing_area_park,k,mount_num,newyear,night_time,timeBJ
;,long,deta_local
;observing_time_julian = newyear+night_time
;local_sidereal_time,long,observing_time_julian,observing_time_lst
;observing_time_alpha_local_lst = observing_time_lst
;observing_time_night_lst=observing_time_alpha_local_lst*15
;observing_time_night = (k*5.0/60.0/24.0)
;timeBJ_hms=d2dms(timeBJ)
;;print,k,' ',timeBJ_hms,float(observing_time_alpha_local_lst*15.0),deta_local


observing_time_alpha_local_lst = '     -360.000'
timeBJ_hms=d2dms(timeBJ)
deta_local = '     -90.0000'
;case mount_num of
;1: printf,120,$
;timeBJ_hms,$
;observing_time_alpha_local_lst,deta_local,' 3 '
;2: printf,120,$
;timeBJ_hms,$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 '
;3: printf,120,$
;timeBJ_hms,$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
;observing_time_alpha_local_lst,deta_local,' 3 '
;4: printf,120,$
;timeBJ_hms,$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 '
;5: printf,120,$
;timeBJ_hms,$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
;observing_time_alpha_local_lst,deta_local,' 3 '
;6: printf,120,$
;timeBJ_hms,$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
;observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 '
;endcase
printf,120,$
timeBJ_hms,$
observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 ',$
observing_time_alpha_local_lst,deta_local,' 3 ',observing_time_alpha_local_lst,deta_local,' 3 '

end
