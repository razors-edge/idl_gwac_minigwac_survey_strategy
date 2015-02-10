pro widgetname_event,event
print,'Event detected'

widget_control,event.top,get_uvalue=infoptr
info = *infoptr

widget_control, event.id ,get_uvalue=widget
help,widget

if(widget eq 'Text') or (widget eq 'OK') then begin
widget_control, info.text,get_value=name
info.name=name
info.status = 'OK'
endif else begin
info.name=''
info.status = 'Cancel'
endelse

*infoptr=info

widget_control,event.top,/destroy

end

pro widgetname_cleanup,id

print,'Cleaning up'

widget_control,id,get_uvalue=infoptr
info = *infoptr

result={name:info.name,status:info.status}
*infoptr=result
end

pro widgetname,name,status

print,'Creating widgets'
device,get_screen_size=screen_size
xoffset = screen_size[0]/3
yoffset = screen_size[1]/3
;print,xoffset,yoffset
tlb=widget_base(column=1,title='Name',$
xoffset = xoffset, yoffset=yoffset, tlb_frame_attr=1)

tbase = widget_base(tlb,row=1)
label = widget_label(tbase,value='Enteryour name:')
text = widget_text(tbase,uvalue='Text',/editable)

bbase = widget_base(tlb,row=1,/align_center)
bsize = 75
butta = widget_button(bbase,value='OK',$
uvalue = 'OK',xsize=bsize)
butta = widget_button(bbase, value='Cancel', $
uvalue = 'Cancel', xsize=bsize)

widget_control,tlb,/realize

info = {text:text,name:"",status:'Cancel'}
infoptr = ptr_new(info)
help,infoptr
widget_control,tlb,set_uvalue=infoptr

xmanager,'widgetname',tlb,cleanup='widgetname_cleanup'

result = *infoptr
ptr_free, infoptr
name=result.name
status=result.status
help,text

end