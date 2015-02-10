pro survey_widget_tool_test
tlb = widget_base(  title = 'test'  $
, tlb_frame_attr=1 $
, column = 2  $
;, row = 3 $
,  mbar = mbar $
, XOFFSET = 100,YOFFSET = 100)

filemenu = widget_button(mbar, value='File')
fileopt1 = widget_button(filemenu, value='Open')
fileopt2 = widget_button(filemenu, value='Save')
fileopt3 = widget_button(filemenu, value='Exit',/separator)
editmenu = widget_button(mbar,value='Edit')

main = widget_base(tlb,column=2,frame=1)

block1 = widget_base(main,column=1)

menu = widget_base(block1,row=2,frame=1)

iconbase = widget_base(menu, row=1,/frame)
subdir = 'resource/bitmaps'
mapfile = filepath('open.bmp',subdir=subdir)
iconopt1=widget_button(iconbase,value=mapfile,/bitmap)
mapfile= filepath('save.bmp',subdir=subdir)
iconopt2=widget_button(iconbase,value=mapfile,/bitmap)

buttsize = 60
buttbase = widget_base(menu, row=1)
buttopt1 = widget_button(buttbase,value='OK', $
xsize= buttsize)
buttopt2 = widget_button(buttbase,value='Cancel', $
xsize= buttsize)

selections=['Selection 1','Selection 2','Selection 3']
buttbase = widget_droplist(menu,value=selections,title='Selections'$ 
, XOFFSET = 110)

toolbase = widget_base(block1, row=3,$
frame = 3)

label = widget_label(toolbase $
, /ALIGN_LEFT,/DYNAMIC_RESIZE $
, /TRACKING_EVENTS $
, value = 'only for the single line' $
;,a = uvalue(value)$
;,group_leader =  
;, frame = 3 $
;, XOFFSET = 10,XSIZE = 400 $
;, YOFFSET = 10, YSIZE = 100 $
;,SCR_XSIZE = 500, SCR_YSIZE = 300$
;,/SENSITIVE $
;,/MAP $
;, tlb_frame_attr=1
)

buttbase = widget_base(toolbase, row=1, /exclusive)
buttopt1 = widget_button(buttbase,value='On')
buttopt2 = widget_button(buttbase,value='Off')
buttbase = widget_base(toolbase, row=3, /nonexclusive)
buttopt1 = widget_button(buttbase,value='Lettuce')
buttopt2 = widget_button(buttbase,value='Tomato')
buttopt3 = widget_button(buttbase,value='Mustard')


setbase = widget_base(block1, row=3)
width = 200
buttbase = widget_base(setbase, row=2)
slider1 = widget_slider(buttbase,value=0,min=-90,max=90,$
title='Latitude',xsize=width)
slider2 = widget_slider(buttbase,value=180,min=0,max=360,$
title='Longtitude',xsize=width)

buttbase = widget_base(setbase, row=2)
lable=widget_label(buttbase,value='Vector of strctures')
record ={lat:45.0,lon:89.0$
,altitude:20500.0,heading:245.0}
data = replicate(record,100)
names=tag_names(data)
table1=widget_table(buttbase,value=data,$
x_scroll_size=4,y_scroll_size=4,$
column_labels=names,/editable)


label2 = widget_label(setbase,value='Multi line text widget')
value=['Text line 1','Text line 2', 'Text line 3']
text=widget_text(setbase,value=value,ysize=3,/editable)

block2 = widget_base(main, column=1)
plotbase= widget_base(block2, row=2, frame=2)
draw1=widget_draw(plotbase,xsize=400,ysize=300$
,x_scroll_size=400,y_scroll_size=300)
draw2=widget_draw(plotbase,xsize=400,ysize=300$
,x_scroll_size=400,y_scroll_size=280)

widget_control, tlb, /realize

widget_control, draw1,get_value=winid1
widget_control, draw2,get_value=winid2

wset,winid1
plot,sin(findgen(200)*0.1)
wset,winid2
shade_surf,dist(32),charsize=1.5

result = dialog_message('Close the Window?',$ 
/question, $
title='Window', /default_no)

;close,/all
;device,/close_file
print,'Done'
end