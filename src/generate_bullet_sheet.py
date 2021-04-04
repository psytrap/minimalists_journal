from xml.dom import minidom
from xml import dom
import math
import re 
import copy

teiler = False

grid = 7.5
offset_x = 0.
offset_y = 0.
margin_x = 4.
margin_y = 4.
dot_size = 0.5
helligkeit = .7




svg_template = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>" + "\n"
svg_template += "<svg" + "\n"
svg_template += "   xmlns=\"http://www.w3.org/2000/svg\"" + "\n"
svg_template += "   width=\"105mm\"" + "\n"
svg_template += "   height=\"148mm\"" + "\n"
svg_template += "   viewBox=\"0 0 105 148\"" + "\n"
svg_template += "   version=\"1.1\">" + "\n"
svg_template += "</svg>" + "\n"


teiler_grid = grid / math.pi

# parameter: teiler, helligkeit, gitter, margin, versatz, datum

def onlyNumbers(string):
   return "".join( re.findall(r'\d+', string) )

#svg_template_file = "a5_template.svg"
svg_output = "bullet_sheet.svg"
svg_with_date_output = "bullet_sheet_with_date.svg"


doc = minidom.parseString(svg_template)
doc_with_date = minidom.parseString(svg_template)

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

# Dots
dots = []
for dot_y in range(dots_y):
    y = dot_y * grid
    for dot_x in range(dots_x):
        #print(start_x + x)
        x = dot_x * grid
        dots.append([start_x + x, start_y + y])

# Viertel teiler
def teiler(dots, prozent):
   dots.append([start_x + 1, start_y + prozent * effecitve_height ])
   dots.append([start_x - 1, start_y + prozent * effecitve_height ])
   dots.append([width - start_x + 1, start_y + prozent * effecitve_height ])
   dots.append([width - start_x - 1, start_y + prozent * effecitve_height ])

teiler(dots, 0.25)
teiler(dots, 0.5)
teiler(dots, 0.75)


dots_with_date = dots.copy()

#datum_x = width - (grid + start_x)
datum_grid = grid/3.
dots_datum = math.floor(3. * grid / datum_grid) + 1
datum_y = start_y + grid
print(datum_y)
# Datum rechts oben
for dot_datum in range(dots_datum):
    x = width - (start_x + datum_grid * dot_datum)
    dots_with_date.append([x, datum_y])



color = round(0xff * (1-helligkeit))
color = "#{0:0{1}x}{0:0{1}x}{0:0{1}x}".format(color, 2)
print(color)

print(len(dots))

def dotsToDoc(doc, dots):
    top_element = doc.documentElement
    for dot in dots:
        dot_element = doc.createElement("circle")
        dot_element.setAttribute("r", str(dot_size/2.))
        dot_element.setAttribute("fill", color)
        dot_element.setAttribute("cx", str(dot[0]))
        dot_element.setAttribute("cy", str(dot[1]))
        top_element.appendChild(dot_element)

dotsToDoc(doc, dots)
dotsToDoc(doc_with_date, dots_with_date)

def writeSvg(filename, doc):
    f =  open(filename, "w")
    f.write(doc.toxml())
    f.close()
    
writeSvg(svg_output, doc)
writeSvg(svg_with_date_output, doc_with_date)

doc.unlink()
doc_with_date.unlink()

