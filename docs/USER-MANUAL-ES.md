# Manual de Usuario IHP-EDA-Tools

Manual completo para diseñadores de circuitos integrados utilizando el contenedor Docker IHP-EDA-Tools con el PDK IHP SG13G2.

---

## Tabla de Contenidos

1. [Introduccion](#1-introduccion)
2. [Instalacion y Configuracion](#2-instalacion-y-configuracion)
3. [Modos de Operacion](#3-modos-de-operacion)
4. [Flujo de Diseno Analogico](#4-flujo-de-diseno-analogico)
5. [Flujo de Diseno Digital](#5-flujo-de-diseno-digital)
6. [Catalogo de Herramientas](#6-catalogo-de-herramientas)
7. [Scripts de Utilidad (SAK)](#7-scripts-de-utilidad-sak)
8. [Sistema de Testcases](#8-sistema-de-testcases)
9. [Solucion de Problemas](#9-solucion-de-problemas)
10. [Referencia Rapida](#10-referencia-rapida)

---

## 1. Introduccion

### 1.1 Que es IHP-EDA-Tools?

**IHP-EDA-Tools** es un contenedor Docker que proporciona un entorno completo de herramientas EDA (Electronic Design Automation) de codigo abierto, optimizado exclusivamente para el PDK IHP SG13G2.

**Caracteristicas principales:**
- Mas de 50 herramientas EDA preinstaladas y configuradas
- PDK IHP SG13G2 listo para usar
- Soporte para diseno analogico y digital
- Flujo RTL-to-GDS completo con LibreLane
- Entorno reproducible entre diferentes maquinas

### 1.2 PDK IHP SG13G2

El PDK (Process Design Kit) IHP SG13G2 es un proceso BiCMOS de 130nm SiGe:C desarrollado por IHP Microelectronics en Alemania.

**Caracteristicas del proceso:**
- Tecnologia: 130nm SiGe:C BiCMOS
- Transistores HBT de alta frecuencia
- MOSFET de 1.2V y 3.3V
- Resistencias y capacitores de precision
- Inductores integrados

**Componentes del PDK:**
- Modelos PSP OSDI para ngspice
- Plugins Verilog-A para Xyce
- Reglas DRC/LVS para KLayout
- Simbolos para xschem
- Archivos de tecnologia para Magic
- Soporte para OpenROAD/LibreLane

### 1.3 Contenedor Docker vs Instalacion Local

| Aspecto | Docker | Instalacion Local |
|---------|--------|-------------------|
| **Tiempo de configuracion** | Minutos | Horas/Dias |
| **Reproducibilidad** | Alta | Variable |
| **Actualizaciones** | Automaticas | Manuales |
| **Aislamiento** | Completo | Ninguno |
| **Espacio en disco** | ~20 GB | Variable |
| **Rendimiento grafico** | Ligeramente menor | Nativo |

### 1.4 Requisitos del Sistema

**Minimos:**
- CPU: x86_64 (Intel/AMD)
- RAM: 8 GB
- Disco: 25 GB libres
- Sistema Operativo: Windows 10+, macOS 11+, o Linux

**Recomendados:**
- CPU: 4+ nucleos
- RAM: 16 GB o mas
- Disco: SSD con 50 GB libres
- GPU: Compatible con OpenGL (para renderizado acelerado)

---

## 2. Instalacion y Configuracion

### 2.1 Instalacion de Docker

#### Linux (Ubuntu/Debian)

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias
sudo apt install -y ca-certificates curl gnupg

# Agregar repositorio oficial de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Permitir uso sin sudo (requiere reinicio de sesion)
sudo usermod -aG docker $USER
newgrp docker
```

#### macOS

1. Descargar Docker Desktop:
   - **Intel**: https://desktop.docker.com/mac/main/amd64/Docker.dmg
   - **Apple Silicon**: https://desktop.docker.com/mac/main/arm64/Docker.dmg

2. Abrir el archivo `.dmg` y arrastrar Docker a Aplicaciones
3. Iniciar Docker Desktop desde Aplicaciones
4. Aceptar los terminos y esperar la inicializacion

#### Windows

1. Descargar Docker Desktop: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe

2. Ejecutar el instalador y seguir el asistente

3. **Importante:** Habilitar WSL 2:
   ```powershell
   # En PowerShell como Administrador
   wsl --install
   wsl --update
   ```

4. Reiniciar el sistema

5. Iniciar Docker Desktop

### 2.2 Descargar la Imagen

```bash
# Desde GitHub Container Registry (recomendado)
docker pull ghcr.io/mauricio-xx/ihp-eda-tools:latest

# O desde Docker Hub
docker pull mauricio-xx/ihp-eda-tools:latest
```

**Nota:** La primera descarga puede tardar varios minutos dependiendo de la velocidad de internet (~4 GB comprimido).

### 2.3 Clonar el Repositorio

```bash
git clone --depth=1 https://github.com/mauricio-xx/ihp-eda-tools.git
cd ihp-eda-tools
```

> **Nota:** Este proyecto es un fork optimizado de [iic-osic-tools](https://github.com/iic-jku/iic-osic-tools)
> desarrollado originalmente por Harald Pretl y el equipo de JKU. Agradecemos su excelente trabajo
> que sirvio como base para esta version enfocada en IHP.

### 2.4 Directorio de Disenos

Por defecto, el contenedor monta el directorio `~/eda/designs` en `/foss/designs` dentro del contenedor.

```bash
# Crear directorio (si no existe)
mkdir -p ~/eda/designs

# O usar un directorio personalizado
export DESIGNS=/ruta/a/mis/disenos
```

**Importante:** Todos los archivos de diseno deben estar dentro de este directorio para ser accesibles desde el contenedor.

### 2.5 Variables de Entorno

| Variable | Valor por Defecto | Descripcion |
|----------|-------------------|-------------|
| `DESIGNS` | `$HOME/eda/designs` | Directorio de disenos montado |
| `DOCKER_USER` | `hpretl` | Usuario del repositorio Docker |
| `DOCKER_IMAGE` | `ihp-eda-tools` | Nombre de la imagen |
| `DOCKER_TAG` | `latest` | Etiqueta de la imagen |
| `WEBSERVER_PORT` | `80` | Puerto para noVNC (modo VNC) |
| `VNC_PORT` | `5901` | Puerto VNC directo |

---

## 3. Modos de Operacion

IHP-EDA-Tools soporta cuatro modos de operacion segun las necesidades del usuario.

### 3.1 Modo VNC (Recomendado para principiantes)

Proporciona un escritorio XFCE completo accesible desde el navegador web.

**Iniciar:**
```bash
./start_vnc.sh
```

**Acceder:**
- Abrir navegador en: http://localhost
- Contrasena por defecto: `abc123`

**Ventajas:**
- Funciona en cualquier sistema operativo
- No requiere configuracion adicional
- Escritorio completo con administrador de archivos

**Desventajas:**
- Renderizado mas lento que X11 nativo
- Requiere mas recursos del sistema

**Personalizar contrasena:**
```bash
VNC_PW=mi_contrasena ./start_vnc.sh
```

### 3.2 Modo X11 (Recomendado para rendimiento)

Renderiza las ventanas directamente en el escritorio del host.

**Iniciar:**
```bash
./start_x.sh
```

**Ventajas:**
- Renderizado grafico nativo (mas rapido)
- Mejor integracion con el escritorio
- Copiar/pegar entre contenedor y host

**Requisitos adicionales:**

**Linux:**
- Servidor X11 funcionando (instalado por defecto en la mayoria de distribuciones)

**macOS:**
- Instalar XQuartz: https://www.xquartz.org
- En XQuartz Preferencias > Seguridad: Habilitar "Allow connections from network clients"

**Windows:**
- WSL 2 con WSLg (Windows 10 Build 19044+ o Windows 11)

### 3.3 Modo Shell (Para usuarios avanzados)

Acceso directo a la linea de comandos sin interfaz grafica.

**Iniciar:**
```bash
./start_shell.sh
```

**Caracteristicas:**
- Ejecuta como root por defecto
- Ideal para scripts automatizados
- Minimo uso de recursos

**Ejemplo de uso:**
```bash
./start_shell.sh
# Dentro del contenedor:
ngspice -b /foss/designs/mi_circuito.spice
```

### 3.4 Comparacion de Modos

| Caracteristica | VNC | X11 | Shell |
|----------------|-----|-----|-------|
| Interfaz grafica | Si | Si | No |
| Rendimiento grafico | Medio | Alto | N/A |
| Facilidad de uso | Alta | Media | Baja |
| Integracion con host | Baja | Alta | Media |
| Uso de recursos | Alto | Medio | Bajo |
| Requiere config. extra | No | Si* | No |

*Excepto en Linux con X11 nativo

---

## 4. Flujo de Diseno Analogico

### 4.1 Resumen del Flujo

```
Especificacion
     |
     v
Captura Esquematica (xschem)
     |
     v
Simulacion SPICE (ngspice/xyce)
     |
     v
Diseno de Layout (KLayout/Magic)
     |
     v
Verificacion DRC (sak-drc.sh)
     |
     v
Verificacion LVS (sak-lvs.sh)
     |
     v
Extraccion de Parasiticos (sak-pex.sh)
     |
     v
Post-Layout Simulation
     |
     v
Tapeout
```

### 4.2 Captura Esquematica con xschem

xschem es el editor de esquematicos principal para diseno analogico con IHP.

**Iniciar xschem:**
```bash
xschem
```

**Configurar PDK:**
```bash
# En el archivo ~/.xschemrc o en la terminal antes de abrir xschem
source sak-pdk-script.sh ihp-sg13g2
```

**Acceder a simbolos IHP:**
- Menu: File > Open Library
- Navegar a: `$PDK_ROOT/ihp-sg13g2/libs.tech/xschem/`

**Simbolos disponibles:**
| Categoria | Ejemplos |
|-----------|----------|
| MOSFET | sg13_lv_nmos, sg13_lv_pmos, sg13_hv_nmos, sg13_hv_pmos |
| HBT | npn13G2, npn13G2L, npn13G2V |
| Resistencias | res_rppd, res_rsil |
| Capacitores | cap_cmim |
| Inductores | inductor2 |

**Atajos utiles:**
| Tecla | Accion |
|-------|--------|
| `i` | Insertar simbolo |
| `w` | Dibujar cable |
| `c` | Copiar |
| `m` | Mover |
| `q` | Propiedades del objeto |
| `Ctrl+S` | Guardar |
| `Netlist` | Generar netlist para simulacion |

### 4.3 Simulacion con ngspice

ngspice es el simulador SPICE principal, con soporte para modelos PSP OSDI del PDK IHP.

**Simulacion por lotes:**
```bash
ngspice -b mi_circuito.spice -o resultado.log
```

**Simulacion interactiva:**
```bash
ngspice mi_circuito.spice
```

**Ejemplo de netlist basico:**
```spice
* Ejemplo NMOS IV Curve - IHP SG13G2
.lib cornerMOSlv.lib mos_tt

* Parametros
.param vds_max = 1.2
.param vgs_max = 1.2

* Fuentes
Vds drain 0 DC 0
Vgs gate 0 DC 0

* Dispositivo bajo prueba
XM1 drain gate 0 0 sg13_lv_nmos W=1u L=0.13u ng=1

* Analisis DC
.dc Vds 0 'vds_max' 0.01 Vgs 0 'vgs_max' 0.2

* Control
.control
run
plot -i(Vds)
wrdata output.csv -i(Vds)
.endc

.end
```

**Tipos de analisis:**
| Comando | Descripcion |
|---------|-------------|
| `.dc` | Barrido DC |
| `.ac` | Analisis AC (frecuencia) |
| `.tran` | Transitorio (tiempo) |
| `.noise` | Analisis de ruido |
| `.op` | Punto de operacion |

### 4.4 Visualizacion de Formas de Onda

**gaw3 (integrado con xschem):**
- Se abre automaticamente desde xschem
- Menu: Simulation > Waveform Viewer

**gtkwave (para digitales y mixto):**
```bash
gtkwave archivo.vcd
```

**surfer (moderno, con limitaciones):**
```bash
surfer archivo.vcd
```

### 4.5 Diseno de Layout

#### KLayout (Recomendado)

```bash
klayout
```

**Cargar tecnologia IHP:**
- Menu: File > Reader Options > Layout > Technology: ihp-sg13g2

**Capas principales IHP SG13G2:**
| Capa | Proposito |
|------|-----------|
| Activ | Area activa |
| GatPoly | Polisilicio (gates) |
| Metal1-5 | Capas de metal |
| Via1-4 | Vias entre metales |

#### Magic

```bash
magic -T ihp-sg13g2
```

### 4.6 Verificacion DRC

**Usando el script SAK:**
```bash
sak-drc.sh -k mi_layout.gds -w ./output
```

**Parametros:**
- `-k <archivo>`: Archivo GDS de entrada
- `-w <directorio>`: Directorio de trabajo/salida
- `-t <top>`: Celda top (opcional)

**Salida:**
- Archivo `.lyrdb`: Reporte de errores para KLayout
- Archivo `.log`: Log de ejecucion

### 4.7 Verificacion LVS

**Usando el script SAK:**
```bash
sak-lvs.sh -s mi_esquematico.sch -l mi_layout.gds -w ./output
```

**Parametros:**
- `-s <archivo>`: Esquematico (xschem)
- `-l <archivo>`: Layout (GDS)
- `-w <directorio>`: Directorio de trabajo

### 4.8 Extraccion de Parasiticos (PEX)

```bash
sak-pex.sh -l mi_layout.gds -w ./output
```

### 4.9 Tutorial: Caracterizacion IV de NMOS

Este tutorial demuestra el flujo basico de simulacion analogica.

**1. Crear directorio de trabajo:**
```bash
mkdir -p ~/eda/designs/nmos-test
cd ~/eda/designs/nmos-test
```

**2. Crear netlist (nmos_iv.spice):**
```spice
* NMOS IV Curve - IHP SG13G2
.lib cornerMOSlv.lib mos_tt

Vds drain 0 DC 0
Vgs gate 0 DC 0

XM1 drain gate 0 0 sg13_lv_nmos W=1u L=0.13u ng=1

.dc Vds 0 1.2 0.01 Vgs 0 1.2 0.2

.control
run
plot -i(Vds) title 'NMOS IV Curves'
.endc

.end
```

**3. Ejecutar simulacion:**
```bash
ngspice nmos_iv.spice
```

**4. Ver resultados:**
- La ventana de graficos mostrara las curvas IV del NMOS
- Cada curva representa un valor diferente de Vgs

---

## 5. Flujo de Diseno Digital

### 5.1 Resumen del Flujo RTL-to-GDS

```
Codigo RTL (Verilog/VHDL)
     |
     v
Sintesis Logica (Yosys)
     |
     v
Floorplanning (OpenROAD)
     |
     v
Placement (OpenROAD)
     |
     v
Clock Tree Synthesis (OpenROAD)
     |
     v
Routing (OpenROAD)
     |
     v
Verificacion DRC/LVS
     |
     v
GDSII Final
```

### 5.2 Codificacion RTL

**Ejemplo Verilog (counter.v):**
```verilog
// counter.v - Contador de 32 bits
module counter #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else if (enable)
            count <= count + 1;
    end
endmodule
```

### 5.3 Sintesis con Yosys

**Sintesis basica:**
```bash
yosys -p "read_verilog counter.v; synth -top counter; write_json counter.json"
```

**Script Yosys completo:**
```tcl
# synth.tcl
read_verilog counter.v
hierarchy -top counter
proc; opt; fsm; opt; memory; opt
techmap; opt
dfflibmap -liberty $::env(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ.lib
abc -liberty $::env(PDK_ROOT)/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ.lib
clean
write_verilog -noattr counter_synth.v
```

### 5.4 Flujo RTL-to-GDS con LibreLane

LibreLane es el flujo RTL-to-GDS recomendado para IHP SG13G2.

**Configuracion del proyecto (config.json):**
```json
{
  "design": "counter",
  "verilog_files": ["counter.v"],
  "pdk": "ihp-sg13g2",
  "std_cell_library": "sg13g2_stdcell",
  "clock_port": "clk",
  "clock_period": 10.0,
  "die_area": [0, 0, 100, 100],
  "core_area": [10, 10, 90, 90]
}
```

**Ejecutar LibreLane:**
```bash
# Configurar entorno
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell

# Ejecutar flujo
librelane --manual-pdk config.json
```

**Archivos de salida:**
- `runs/<run>/results/final/gds/counter.gds` - Layout final
- `runs/<run>/reports/` - Reportes de timing, area, potencia

### 5.5 Simulacion Digital

**Icarus Verilog:**
```bash
iverilog -o sim counter.v counter_tb.v
vvp sim
gtkwave dump.vcd
```

**Verilator (mas rapido):**
```bash
verilator --cc --exe --build counter.v counter_tb.cpp
./obj_dir/Vcounter
```

### 5.6 Verificacion Formal

**SymbiYosys (sby):**
```bash
sby -f counter.sby
```

**Archivo .sby:**
```
[options]
mode prove
depth 20

[engines]
smtbmc z3

[script]
read -formal counter.v
prep -top counter

[files]
counter.v
```

### 5.7 Tutorial: Contador RTL-to-GDS

**1. Preparar archivos:**
```bash
mkdir -p ~/eda/designs/counter-test
cd ~/eda/designs/counter-test
```

**2. Crear counter.v** (codigo anterior)

**3. Crear config.json** (configuracion anterior)

**4. Ejecutar flujo:**
```bash
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell
librelane --manual-pdk config.json
```

**5. Ver resultado:**
```bash
klayout runs/*/results/final/gds/counter.gds
```

---

## 6. Catalogo de Herramientas

### 6.1 Captura Esquematica y Layout

| Herramienta | Descripcion | Comando |
|-------------|-------------|---------|
| xschem | Editor de esquematicos | `xschem` |
| klayout | Editor/visor de layout | `klayout` |
| magic | Layout con DRC/PEX | `magic` |
| gds3d | Visor 3D de GDS | `gds3d` |
| xcircuit | Editor alternativo | `xcircuit` |

### 6.2 Simulacion Analogica

| Herramienta | Descripcion | Comando |
|-------------|-------------|---------|
| ngspice | Simulador SPICE | `ngspice` |
| xyce | SPICE paralelo | `Xyce` |
| gaw3 | Visor de ondas (xschem) | `gaw` |
| qucs-s | Entorno de simulacion RF | `qucs-s` |

### 6.3 Simulacion Digital

| Herramienta | Descripcion | Comando |
|-------------|-------------|---------|
| iverilog | Simulador Verilog | `iverilog` |
| verilator | Simulador rapido | `verilator` |
| ghdl | Simulador VHDL | `ghdl` |
| nvc | Compilador VHDL moderno | `nvc` |
| gtkwave | Visor de ondas | `gtkwave` |
| surfer | Visor moderno | `surfer` |
| digital | Simulador logico educativo | `digital` |

### 6.4 Sintesis y P&R

| Herramienta | Descripcion | Comando |
|-------------|-------------|---------|
| yosys | Sintesis logica | `yosys` |
| openroad | Motor P&R | `openroad` |
| librelane | Flujo RTL-to-GDS | `librelane` |
| abc | Sintesis secuencial | `abc` |

### 6.5 Verificacion

| Herramienta | Descripcion | Comando |
|-------------|-------------|---------|
| netgen | LVS | `netgen` |
| cvc | ERC | `cvc_rv` |
| covered | Cobertura Verilog | `covered` |
| eqy | Equivalencia | `eqy` |
| sby | Verificacion formal | `sby` |
| mcy | Cobertura mutaciones | `mcy` |

### 6.6 RF y Electromagnetismo

| Herramienta | Descripcion | Comando |
|-------------|-------------|---------|
| openems | Simulador EM FDTD | `openems` |
| palace | Simulador EM 3D | `palace` |
| qucs-s | Simulacion RF | `qucs-s` |
| FastHenry2 | Inductancia | `fasthenry` |
| FasterCap | Capacitancia | `fastercap` |

### 6.7 Desarrollo de PDK

| Herramienta | Descripcion | Comando |
|-------------|-------------|---------|
| openvaf | Compilador Verilog-A | `openvaf` |
| charlib | Caracterizacion celdas | `charlib` |
| cace | Motor de caracterizacion | `cace` |
| ciel | Gestor de PDKs | `ciel` |

---

## 7. Scripts de Utilidad (SAK)

Los scripts SAK (Swiss Army Knife) simplifican tareas comunes de verificacion.

### 7.1 sak-drc.sh - Verificacion DRC

**Uso:**
```bash
sak-drc.sh -k <archivo.gds> [-t <top_cell>] [-w <directorio>]
```

**Parametros:**
| Parametro | Descripcion |
|-----------|-------------|
| `-k` | Archivo GDS de entrada |
| `-t` | Celda top (detectada automaticamente si no se especifica) |
| `-w` | Directorio de trabajo (defecto: directorio actual) |

**Ejemplo:**
```bash
sak-drc.sh -k mi_layout.gds -w ./drc_output
```

### 7.2 sak-lvs.sh - Verificacion LVS

**Uso:**
```bash
sak-lvs.sh -s <esquematico.sch> -l <layout.gds> [-w <directorio>]
```

**Ejemplo:**
```bash
sak-lvs.sh -s mi_amp.sch -l mi_amp.gds -w ./lvs_output
```

### 7.3 sak-pex.sh - Extraccion de Parasiticos

**Uso:**
```bash
sak-pex.sh -l <layout.gds> [-w <directorio>]
```

### 7.4 sak-pdk-script.sh - Configuracion de PDK

**Uso:**
```bash
source sak-pdk-script.sh <pdk> [standard_cell_library]
```

**Ejemplos:**
```bash
# Configurar PDK IHP para analogico
source sak-pdk-script.sh ihp-sg13g2

# Configurar PDK IHP para digital
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell
```

**Variables configuradas:**
- `PDK` - Nombre del PDK
- `PDKPATH` - Ruta completa al PDK
- `STD_CELL_LIBRARY` - Biblioteca de celdas estandar
- `KLAYOUT_PATH` - Ruta de tecnologia KLayout
- `SPICE_USERINIT_DIR` - Directorio de inicializacion ngspice

### 7.5 sak-clean.sh - Limpieza

Elimina archivos temporales de simulacion y verificacion:
```bash
sak-clean.sh
```

### 7.6 sak-layconv.sh - Conversion de Layout

Convierte entre formatos GDS, OASIS, etc.:
```bash
sak-layconv.sh input.gds output.oas
```

### 7.7 sak-vlint.sh - Linting de Verilog

Verifica estilo y errores en codigo Verilog:
```bash
sak-vlint.sh mi_modulo.v
```

---

## 8. Sistema de Testcases

### 8.1 Que son los Testcases?

Los testcases son ejemplos reproducibles de diseno que sirven para:
- Aprender flujos de diseno con IHP SG13G2
- Validar la configuracion del PDK
- Compartir disenos entre la comunidad

### 8.2 Estructura de Testcases

```
testcases/
├── gold-reference/     # Ejemplos oficiales
│   ├── analog/
│   │   └── nmos-iv-curve/
│   └── digital/
│       └── counter-rtl2gds/
├── validation/         # Tests de PDK
└── contributed/        # Contribuciones
```

### 8.3 CLI iic-testcase

**Listar testcases:**
```bash
# Todos
iic-testcase list

# Por categoria
iic-testcase list --category gold-reference

# Por tipo
iic-testcase list --type simulation
```

**Ver informacion:**
```bash
iic-testcase info gold-reference/analog/nmos-iv-curve
```

**Ejecutar testcase:**
```bash
iic-testcase run gold-reference/analog/nmos-iv-curve
```

**Validar resultados:**
```bash
iic-testcase validate gold-reference/analog/nmos-iv-curve
```

### 8.4 Crear Testcase Propio

**Inicializar:**
```bash
iic-testcase init mi-amplificador --template analog-simulation
```

**Estructura creada:**
```
mi-amplificador/
├── testcase.yaml    # Metadatos
├── run.sh           # Script de ejecucion
├── inputs/          # Archivos de entrada
└── README.md        # Documentacion
```

**Verificar estructura:**
```bash
iic-testcase verify mi-amplificador/
```

### 8.5 Testcases Disponibles

| Testcase | Tipo | Descripcion |
|----------|------|-------------|
| `gold-reference/analog/nmos-iv-curve` | simulation | Curvas IV de NMOS |
| `gold-reference/digital/counter-rtl2gds` | rtl2gds | Flujo digital completo |
| `validation/drc/klayout-invocation` | drc | Validacion entorno DRC |
| `validation/lvs/netgen-invocation` | lvs | Validacion entorno LVS |

---

## 9. Solucion de Problemas

### 9.1 Problemas de Docker

**Error: "permission denied"**
```bash
# En Linux, agregar usuario al grupo docker
sudo usermod -aG docker $USER
# Cerrar sesion y volver a entrar
```

**Error: "Cannot connect to Docker daemon"**
```bash
# Verificar que Docker este corriendo
sudo systemctl start docker
# O en Docker Desktop, iniciar la aplicacion
```

**Espacio insuficiente**
```bash
# Limpiar imagenes y contenedores no usados
docker system prune -a
```

### 9.2 Problemas de Graficos

**Pantalla negra en modo VNC**
- Esperar unos segundos - el escritorio tarda en cargar
- Refrescar el navegador
- Verificar que el puerto 80 no este en uso

**xschem se congela en macOS**
- Usar version especifica de XQuartz
- Evitar periodos de inactividad largos
- Mantener `htop` corriendo en terminal secundaria

**Error OpenGL**
```bash
# Dentro del contenedor
export LIBGL_ALWAYS_INDIRECT=0
```

**Surfer se cierra inesperadamente**
- Problema conocido con drivers OpenGL
- Usar gtkwave como alternativa

### 9.3 Problemas de Simulacion

**ngspice: "model not found"**
```bash
# Verificar configuracion de PDK
source sak-pdk-script.sh ihp-sg13g2
echo $SPICE_USERINIT_DIR
```

**Error de convergencia**
- Reducir paso de tiempo en `.tran`
- Agregar `.options reltol=1e-4`
- Verificar condiciones iniciales

### 9.4 Problemas de LibreLane

**Error: "PDK not found"**
```bash
# Configurar PDK antes de ejecutar
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell
```

**Timing violations**
- Aumentar periodo de reloj
- Reducir densidad de colocacion
- Revisar fanout de celdas

### 9.5 Problemas por Plataforma

#### Windows

| Problema | Solucion |
|----------|----------|
| WSLg no disponible | Actualizar WSL: `wsl --update` |
| xschem crashes frecuentes | Usar VcXsrv version 64.1.17.2.0 |
| Archivos con permisos incorrectos | Usar `/foss/designs` en vez de `/mnt/c/` |

#### macOS

| Problema | Solucion |
|----------|----------|
| XQuartz no conecta | Habilitar conexiones de red en preferencias |
| Crasheo por inactividad | Mantener actividad en terminal (ejecutar `htop`) |
| VirtioFS lento | Deshabilitar en Docker Desktop settings |

#### Linux

| Problema | Solucion |
|----------|----------|
| Docker Desktop X11 | Instalar `socat` para forwarding |
| Permisos en /dev/dri | Agregar usuario al grupo `video` |
| Wayland no funciona | Usar X11 o instalar XWayland |

---

## 10. Referencia Rapida

### 10.1 Comandos Esenciales

```bash
# Iniciar contenedor
./start_vnc.sh          # Modo VNC (navegador)
./start_x.sh            # Modo X11 (nativo)
./start_shell.sh        # Modo shell

# Configurar PDK
source sak-pdk-script.sh ihp-sg13g2

# Herramientas principales
xschem                  # Esquematicos
klayout                 # Layout
ngspice mi_sim.spice    # Simulacion
librelane config.json   # RTL-to-GDS

# Verificacion
sak-drc.sh -k layout.gds
sak-lvs.sh -s sch.sch -l layout.gds

# Testcases
iic-testcase list
iic-testcase run gold-reference/analog/nmos-iv-curve
```

### 10.2 Variables de Entorno Importantes

| Variable | Valor Tipico | Descripcion |
|----------|--------------|-------------|
| `PDK` | `ihp-sg13g2` | PDK activo |
| `PDKPATH` | `/foss/pdks/ihp-sg13g2` | Ruta al PDK |
| `TOOLS` | `/foss/tools` | Directorio de herramientas |
| `DESIGNS` | `/foss/designs` | Directorio de disenos |
| `PDK_ROOT` | `/foss/pdks` | Raiz de PDKs |

### 10.3 Rutas Importantes

| Ruta | Contenido |
|------|-----------|
| `/foss/tools/` | Herramientas EDA instaladas |
| `/foss/pdks/ihp-sg13g2/` | PDK IHP SG13G2 |
| `/foss/designs/` | Directorio de trabajo (montado) |
| `/foss/examples/` | Ejemplos incluidos |
| `/foss/testcases/` | Sistema de testcases |
| `/headless/` | Configuracion del entorno |

### 10.4 Atajos de Teclado

**xschem:**
| Tecla | Accion |
|-------|--------|
| `i` | Insertar simbolo |
| `w` | Dibujar cable |
| `c` | Copiar |
| `m` | Mover |
| `Del` | Eliminar |
| `q` | Propiedades |
| `Ctrl+S` | Guardar |

**KLayout:**
| Tecla | Accion |
|-------|--------|
| `i` | Insertar instancia |
| `r` | Dibujar rectangulo |
| `p` | Dibujar poligono |
| `m` | Mover |
| `Space` | Seleccionar |
| `F2` | Zoom fit |

### 10.5 Enlaces Utiles

- **PDK IHP**: https://github.com/IHP-GmbH/IHP-Open-PDK
- **iic-osic-tools**: https://github.com/iic-jku/iic-osic-tools
- **ngspice**: http://ngspice.sourceforge.net
- **xschem**: https://github.com/StefanSchippers/xschem
- **KLayout**: https://www.klayout.de
- **LibreLane**: https://github.com/librelane/librelane
- **OpenROAD**: https://theopenroadproject.org

---

## Licencia

Este manual esta licenciado bajo Apache-2.0.

SPDX-License-Identifier: Apache-2.0

---

*Manual generado para IHP-EDA-Tools - Version 2025.01*
