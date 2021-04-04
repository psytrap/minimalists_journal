from xml.dom import minidom
from xml import dom
import math
import re 
import copy

grid = 7.5
offset_x = 0.
offset_y = 0.
margin_x = 4.
margin_y = 3.
dot_size = 0.5
helligkeit = .7

teiler_grid = grid / math.pi

# parameter: teiler, helligkeit, gitter, margin, versatz, datum, viertelteiler

def onlyNumbers(string):
   return "".join( re.findall(r'\d+', string) )

svg_template_file = "a5_template.svg"
svg_output = "a5_punktiert.svg"

doc = minidom.parse(svg_template_file)

top_element = doc.documentElement
print(top_element.toxml())
width = top_element.getAttribute("width")
height = top_element.getAttribute("height")
print("width:", width,"","height:", height)

width = float( onlyNumbers(width) )
height = float( onlyNumbers(height) )


effective_width = width - 2 * margin_x
dots_x = math.floor( effective_width / grid ) + 1

effecitve_height = height - 2 * margin_y
dots_y = math.floor( effecitve_height / grid ) + 1

print("width:", width,"" ,"height:", height, "", "grid_x:", grid * (dots_x-1), "", "grid_y:", grid * (dots_y-1) )

start_x = ( width  - grid * (dots_x - 1) ) / 2
start_y = ( height - grid * (dots_y - 1) ) / 2

print("start_x:", start_x,"" ,"start_y:", start_y)

"""
Grid
"""
dots = []
for dot_y in range(dots_y):
    y = dot_y * grid
    for dot_x in range(dots_x):
        #print(start_x + x)
        x = dot_x * grid
        dots.append([start_x + x, start_y + y])

"""
Teiler
"""
# y halbe
middle_y = height/2.
dots_teiler = math.floor(effective_width/teiler_grid) + 1
start_teiler = ( width  - teiler_grid * (dots_teiler - 1) ) / 2

for dot_teiler in range(dots_teiler):
    teiler = dot_teiler * teiler_grid
    dots.append([start_teiler + teiler, middle_y])

datum_grid = grid/3.
datum_x = width - (2 * grid + start_x)
dots_datum = math.floor(3. * grid / datum_grid) + 1

"""
Datum dots
"""
datum_y = start_y + grid * math.floor(float(dots_y - 1) / 2.)
print(datum_y)
for dot_datum in range(dots_datum):
    y = height - (start_y + (datum_grid * dot_datum))
    dots.append([datum_x, y])
for dot_datum in range(dots_datum):
    y = datum_y - (datum_grid * dot_datum)
    dots.append([datum_x, y])


"""
viertel Teiler
"""
for viertel in range(3):
    y = height/4. * (viertel + 1)
    if viertel == 1:
        continue
    dots.append([margin_x, y])
    dots.append([margin_x + grid/5.	, y])
    dots.append([width - margin_x, y])
    dots.append([width - margin_x - grid/5., y])
for viertel in range(3):
    x = width/4. * (viertel + 1)
    dots.append([x, height/2. + grid/10.])
    dots.append([x, height/2. - grid/10.])
for viertel in range(3):
    x = width/4. * (viertel + 1)
    dots.append([x, margin_y])
    dots.append([x, margin_y + grid/5.])
    dots.append([x, height - margin_y])
    dots.append([x, height - margin_y - grid/5.])
   



color = round(0xff * (1-helligkeit))
color = "#{0:0{1}x}{0:0{1}x}{0:0{1}x}".format(color, 2)
print(color)

for dot in dots:
    dot_element = doc.createElement("circle")
    dot_element.setAttribute("r", str(dot_size/2.))
    dot_element.setAttribute("fill", color)
    dot_element.setAttribute("cx", str(dot[0]))
    dot_element.setAttribute("cy", str(dot[1]))
    top_element.appendChild(dot_element)






f =  open(svg_output, "w")
f.write(doc.toxml())
f.close()

doc.unlink()

