import sys

# PROGRAMA CRIADO PARA APLICAR TRANSPARENCIA AOS ARQUIVOS .DATA

if (len(sys.argv) < 2):
    print("Uso: python transparency.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

with open(filename, "r") as f:
    lines = f.readlines()

for linha in range(0, len(lines)):
    lines[linha] = lines[linha].replace("255", "199")

with open(filename, "w") as f:
    f.writelines(lines)