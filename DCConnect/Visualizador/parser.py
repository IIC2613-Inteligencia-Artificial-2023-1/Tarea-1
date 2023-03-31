import sys
import json
import re

def parse_clingo_output():
    content = sys.stdin.read()
    print(content)

    # Extract grid size
    x_values = set()
    y_values = set()

    for x in re.findall(r'columna\((\d+)\)', content):
        x_values.add(int(x))

    for y in re.findall(r'fila\((\d+)\)', content):
        y_values.add(int(y))

    grid_size = (max(x_values), max(y_values))

    # Extract camino rules
    camino_pattern = re.compile(r'camino\(\s*(\w+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)')
    caminos = camino_pattern.findall(content)
    print(caminos)

    # Start-end rules 
    start_end_pattern = re.compile(r'color\(\s*(\w+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)')
    start_end = start_end_pattern.findall(content)

    # Lo pasamos a lista, ordenamos y agregamos si es inicio o final
    start_end = [list(elem) for elem in start_end]
    start_end.sort(key=lambda x: x[0])
    for i in range(len(start_end)):
        if i%2 == 0: # si es inicio
            start_end[i].append(1)
        elif i%2 == 1: # si es final
            start_end[i].append(2)
         

    # Create a list of lines from the caminos
    lines = []
    for color, y1, x1, y2, x2 in caminos:
        x1, y1, x2, y2 = int(x1) - 1, int(y1) - 1, int(x2) - 1, int(y2) - 1

        lines.append([x1, y1, color, 0])
        lines.append([x2, y2, color, 0])

    new_lines = []
    for elem in lines:
        if elem not in new_lines:
            new_lines.append(elem)
    lines = new_lines



    found = 0
    for start_end_pos in start_end:
        color0 = start_end_pos[0]
        y0 = int(start_end_pos[1]) - 1
        x0 = int(start_end_pos[2]) - 1
        pos = start_end_pos[3]
        

        for line in lines:
            
            [x, y , color, _] = line
            if x == x0 and y == y0 and color == color0:
                found = 1
                line[3] = pos
        
    # esto es en caso de que no hayan caminos que conecten las posiciones iniciales a algún lado
    if found==0:

        print("OJO: no parece haber caminos que incluyan las posiciones iniciales o finales")
        print("Se agregarán de todas formas a partir de los átomos color(c, y, x)")
        for start_end_pos in start_end:
            color0 = start_end_pos[0]
            y0 = int(start_end_pos[1]) - 1
            x0 = int(start_end_pos[2]) - 1
            pos = start_end_pos[3]
            lines.append([x0, y0, color0, pos])


    

    # Creamos el JSON
    json_data = {
        "gridSize": max(grid_size),
        "lines": lines
    }

    return json_data

def write_json_file(json_data, output_file):
    with open(output_file, 'w') as file:
        json.dump(json_data, file, indent=2)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: clingo x.lp | python clingo_parser.py <json_output_file>")
        sys.exit(1)

    json_output_file = sys.argv[1]

    json_data = parse_clingo_output()
    write_json_file(json_data, json_output_file)