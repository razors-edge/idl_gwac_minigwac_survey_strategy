pro local_sidereal_time_back,long,Julian,lst
;long = ten(117,34,28.35)
print,long
;Julian = SYSTIME( /JULIAN ,/UTC ) 
print,Julian
;CT2LST, lst, long, 8,ten(15,53), 30, 07, 2008
CT2LST, lst, long, 8, Julian
;print,lst
lst_h = SIXTY(lst)
;print,lst_h
end