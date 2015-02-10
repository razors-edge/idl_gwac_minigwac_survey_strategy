pro sorttest,index=index,revert=revert 

if(not keyword_set(index)) then index = [1,2]
if(not keyword_set(revert)) then revert=0

col0 = findgen(20)
col1 = [ 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4 ]
col2 = [ 2, 2, 2, 3, 5, 4, 3, 2, 2, 2, 4, 3, 3, 3, 5, 4, 4, 3, 3, 1 ] 
col3 = [ 8, 7, 6, 5, 4, 3, 2, 1, 8, 7, 6, 5, 4, 3, 2, 1, 8, 7, 6, 5 ]

data = [ transpose(col0),transpose(col1),transpose(col2),transpose(col3) ]

print,'Calling multisort with INDEX=',index,'   REVERT=',revert
multicolumnsort,data,index=index,revert=revert

for i=0,n_elements(data(0,*))-1 do $
    print,fix(data(0,i)),data(1,i),data(2,i),data(3,i)

print

return
end