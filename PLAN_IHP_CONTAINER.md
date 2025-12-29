# Plan: IHP-Focused EDA Container

## Objetivo

Crear una versión especializada del contenedor IIC-OSIC-TOOLS enfocada exclusivamente en el PDK IHP SG13G2, que sirva para:

1. **Diseño de circuitos** - Usuarios finales diseñando con IHP
2. **Desarrollo del PDK** - Contribuidores mejorando/manteniendo el PDK
3. **Extensibilidad** - Facilitar integración de nuevas herramientas con el PDK

---

## Decisiones Clave (Definidas)

| Decisión | Elección | Justificación |
|----------|----------|---------------|
| **Imagen** | Única | Misma imagen para diseñadores y desarrolladores PDK. Permite compartir test cases |
| **Flujo Digital** | Siempre incluido | OpenROAD, yosys, ORFS, LibreLane |
| **Herramientas RF** | Mantener todas | openems, palace, qucs-s, rftoolkit |
| **Repositorio** | Este fork | Mauricio-xx/iic-osic-tools. Sin PRs al upstream |

---

## Análisis del Estado Actual

### Herramientas con Soporte Explícito IHP (8 tools)
| Herramienta | Uso | Integración IHP |
|-------------|-----|-----------------|
| ngspice | Simulación SPICE | PSP OSDI models |
| xyce | Simulación paralela | PSP Verilog-A plugins |
| magic | Layout + DRC/PEX | Bindkeys custom, tech files |
| klayout | Layout editor | DRC/LVS menus, sg13g2 tech |
| xschem | Esquemáticos | Símbolos y libs IHP |
| netgen | LVS | Setup cells IHP |
| librelane | RTL-to-GDS | sg13g2_stdcell |
| openroad | Place & Route | ORFS config IHP |

### Herramientas Actuales por Eliminar (No relevantes para IHP)
- sky130/gf180-specific configs y tests
- Herramientas redundantes o muy especializadas
- RISC-V toolchain completo (mantener solo lo esencial)
- Herramientas FPGA (nextpnr) - no aplica a ASIC IHP

---

## Arquitectura Propuesta

### Nombre del Proyecto
**`ihp-eda-tools`** o **`ihp-asic-tools`**

### Estructura de Directorios
```
ihp-eda-tools/
├── _build/
│   ├── images/
│   │   ├── base/                 # Base Ubuntu 24.04 simplificada
│   │   ├── base-dev/             # Paquetes de desarrollo
│   │   ├── pdk-ihp/              # NUEVO: PDK como imagen separada
│   │   ├── tools-core/           # Herramientas esenciales
│   │   ├── tools-digital/        # Flujo digital (opcional)
│   │   ├── tools-pdk-dev/        # NUEVO: Desarrollo de PDK
│   │   └── ihp-eda-tools/        # Imagen final
│   ├── tool_metadata.yml
│   └── docker-bake.hcl
├── _tests/
│   ├── analog/                   # Tests circuitos analógicos
│   ├── digital/                  # Tests flujo digital
│   └── pdk-validation/           # NUEVO: Tests de validación PDK
├── pdk-dev/                      # NUEVO: Herramientas desarrollo PDK
│   ├── templates/                # Templates para nuevas herramientas
│   ├── integration-tests/        # Tests de integración
│   └── docs/                     # Documentación desarrollo
└── start_*.sh
```

---

## Clasificación de Herramientas

### INCLUIDAS - Herramientas que se mantienen (~50 herramientas)

#### Esquemáticos y Layout
- `xschem` - Editor de esquemáticos
- `klayout` - Editor de layout con DRC/LVS
- `magic` - Layout con DRC/PEX integrado
- `gds3d` - Visualizador 3D
- `xcircuit` - Editor esquemáticos alternativo

#### Simulación Analógica
- `ngspice` - SPICE con OSDI (modelos PSP)
- `xyce` - SPICE paralelo con plugins Verilog-A
- `gaw3-xschem` - Visor de ondas para xschem
- `vacask` - Simulador analógico moderno
- `ngspyce` - Python bindings para ngspice
- `pyspice` - Python SPICE interface

#### Flujo Digital (RTL-to-GDS)
- `yosys` - Síntesis lógica + plugins (ghdl, slang)
- `openroad` - Place & Route engine
- `librelane` - Flow RTL-to-GDS completo
- `eqy`, `sby`, `mcy` - Verificación formal

#### Simulación Digital
- `iverilog` - Simulador Verilog
- `verilator` - Simulador rápido
- `ghdl` - Simulador VHDL
- `nvc` - Simulador VHDL moderno
- `gtkwave` - Visor ondas digital
- `cocotb` - Testbench Python
- `surfer` - Visor ondas moderno

#### Verificación
- `netgen` - LVS
- `cvc` - ERC (circuit validity checker)
- `covered` - Code coverage Verilog

#### RF/EM (Mantener todas)
- `openems` - Simulador EM FDTD
- `palace` - Simulador 3D EM (AWS)
- `qucs-s` - Entorno simulación RF
- `rftoolkit` - FastHenry2, FasterCap
- `gmsh` - Mesher 3D

#### PDK Development
- `openvaf` - Compilador Verilog-A → OSDI
- `adms` - Compilador Verilog-A (legacy, para Xyce)
- `charlib` - Caracterización std cells
- `lctime` - Liberty timing characterization
- `cace` - Circuit characterization engine
- `ciel` - Gestor versiones PDK

#### Utilidades Python/Scripting
- `gdsfactory` - GDS scripting Python
- `gdspy` - GDS manipulation
- `schemdraw` - Diagramas circuitos
- `pygmid` - gm/Id design methodology
- `spicelib` - SPICE file manipulation
- `hdl21`, `vlsirtools` - HDL Python libraries

#### Herramientas de Soporte
- `slang` - Parser SystemVerilog
- `surelog` - Parser SystemVerilog
- `irsim` - Switch-level simulator
- `qflow` - Conversion tools
- `abc` - Logic synthesis

### ELIMINADAS - No incluidas en imagen IHP

#### PDKs (Eliminar sky130 y gf180)
- `sky130A` PDK completo
- `gf180mcuD` PDK completo
- Tests y configs específicos de estos PDKs

#### RISC-V (No relevante para diseño IHP)
- `riscv-gnu-toolchain` - Toolchain completo
- `spike` - ISA simulator
- `riscv-pk` - Proxy kernel
- `pulp-tools` - PULP platform tools (bender, verible, sv2v)

#### FPGA (No aplica a ASIC)
- `nextpnr` - FPGA place & route
- `fpga-tools` - iCE40 toolchain

#### Redundantes/Problemas conocidos
- `pyopus` - Removido por incompatibilidades numpy
- `kactus2` - IP-XACT editor (poco usado)
- `libman` - Library manager (poco usado)
- `najaeda` - EDA algorithms (experimental)
- `openram` - Memory compiler (no IHP support)
- `padring` - Padring generator (poco usado)
- `fault` - DFT (poco usado)
- `pyuvm` - UVM Python (usar cocotb)

#### HDLs Alternativos (Simplificar)
- `veryl` - HDL moderno (experimental)
- `amaranth` - Python HDL (nicho)
- `chisel` + SBT - Scala HDL (requiere JVM pesado)

#### Otros
- `siliconcompiler` - Build system (redundante con librelane)
- `rggen` - Register generator (nicho)
- `fusesoc`, `edalize` - Package managers (nicho)

---

## Imagen Única

Una sola imagen completa para todos los usuarios (diseñadores y desarrolladores PDK).

```dockerfile
# Build layers
FROM base              # Ubuntu 24.04 + deps runtime
FROM base-dev          # + paquetes desarrollo
FROM tools-all         # Todas las herramientas (~50)
FROM pdk-ihp           # Solo IHP PDK
FROM ihp-eda-tools     # Imagen final
```

### Estimación de Tamaño

| Componente | Actual (3 PDKs) | IHP-only |
|------------|-----------------|----------|
| Base + Tools | ~15 GB | ~12 GB |
| PDKs | ~5 GB (3 PDKs) | ~1.5 GB (solo IHP) |
| **Total** | ~20 GB | ~13-14 GB |

**Reducción estimada: ~30%** (principalmente por eliminar sky130, gf180, RISC-V toolchain)

---

## Estructura para Desarrollo de PDK

### Modo PDK-Dev
El PDK se monta como volumen editable, no embebido.

```bash
# Desarrollo del PDK
./start_pdk_dev.sh --pdk-source ~/ihp-pdk-fork

# Dentro del container
/foss/pdks/ihp-sg13g2 -> montado desde host
/foss/pdk-dev/        -> herramientas de desarrollo
```

### Scripts de Integración
```
pdk-dev/
├── validate-drc.sh       # Validar reglas DRC
├── validate-lvs.sh       # Validar setup LVS
├── compile-models.sh     # Compilar Verilog-A → OSDI
├── test-simulation.sh    # Tests de simulación
├── check-symbols.sh      # Validar símbolos xschem
└── generate-docs.sh      # Generar documentación
```

### Template para Nueva Herramienta
```
pdk-dev/templates/new-tool-integration/
├── README.md             # Guía de integración
├── tool-config.template  # Config template
├── test-cases/           # Casos de test
└── validate.sh           # Script validación
```

---

## Beneficios de la Especialización

| Aspecto | Actual (iic-osic-tools) | Propuesto (ihp-eda-tools) |
|---------|-------------------------|---------------------------|
| Tamaño imagen | ~20 GB | ~13-14 GB |
| Herramientas | 70+ | ~50 |
| PDKs | 3 | 1 (IHP) |
| Tiempo build | Varias horas | ~2 horas |
| Foco | General | IHP específico |
| Mantenimiento | Complejo | Simplificado |
| Test cases | Distribuidos | Compartidos diseño/PDK |

---

## Fases de Implementación

### Fase 1: Limpieza de PDKs y RISC-V ✅ COMPLETADA
1. ~~Fork del repositorio~~ (ya hecho - Mauricio-xx/iic-osic-tools)
2. ✅ Eliminar instalación de PDKs sky130 y gf180
3. ✅ Eliminar RISC-V toolchain completo
4. ✅ Eliminar FPGA tools (nextpnr)
5. ✅ Actualizar scripts de build

### Fase 2: Limpieza de Herramientas ✅ COMPLETADA
1. ✅ Eliminar herramientas marcadas como "ELIMINADAS"
2. ✅ Actualizar tool_metadata.yml
3. ✅ Actualizar docker-bake.hcl
4. ✅ Limpiar Dockerfile final

### Fase 3: Actualizar Tests ✅ COMPLETADA
1. ✅ Eliminar tests de sky130 y gf180
2. ✅ Mantener y renumerar tests IHP (ahora 01-07)
3. ✅ Actualizar TESTS.md
4. ✅ Eliminar ejemplos sky130/gf180 de skel

### Fase 4: PDK Development Mode ✅ COMPLETADA
1. ✅ Crear directorio pdk-dev/
2. ✅ Implementar scripts de validación (DRC, LVS, simulation, symbols)
3. ✅ Crear templates de integración
4. ✅ Script start_pdk_dev.sh

### Fase 5: Documentación ✅ COMPLETADA
1. ✅ Actualizar CLAUDE.md para ihp-eda-tools
2. Actualizar README.md (pendiente revisión)
3. Simplificar CI/CD (pendiente)
4. ✅ Documentar workflow desarrollo PDK

---

## Estado Actual

**Todas las fases principales completadas.** El contenedor está listo para:
- Diseño de circuitos con IHP SG13G2 PDK
- Desarrollo y validación del PDK
- Compartir test cases entre diseñadores y desarrolladores

Pendiente:
- Actualizar README.md principal
- Simplificar workflows de CI/CD
- Probar build completo

---

## Archivos Principales Modificados

### Build System
| Archivo | Cambio |
|---------|--------|
| `_build/images/open_pdks/` | Eliminar sky130, gf180 |
| `_build/images/riscv-gnu-toolchain/` | Eliminar |
| `_build/images/fpga-tools/` | Eliminar |
| `_build/tool_metadata.yml` | Limpiar herramientas eliminadas |
| `_build/docker-bake.hcl` | Actualizar targets |
| `_build/images/iic-osic-tools/Dockerfile` | Simplificar |

### Tests
| Archivo | Cambio |
|---------|--------|
| `_tests/01/` - `_tests/07/` | Eliminar (sky130/gf180) |
| `_tests/08/`, `_tests/09/` | Eliminar (PULP/RISC-V) |
| `_tests/13/`, `_tests/14/` | Eliminar (sky130/gf180) |
| `_tests/05/`, `_tests/10/`, `_tests/11/`, `_tests/18/` | Mantener (IHP) |

### Scripts
| Archivo | Cambio |
|---------|--------|
| `start_*.sh` | Simplificar, IHP default |
| `sak-pdk.sh` | Solo IHP (o eliminar) |
| `sak-drc.sh`, `sak-lvs.sh`, `sak-pex.sh` | Solo IHP |

---

## Próximos Pasos

1. ✅ Plan definido y aprobado
2. ✅ Fase 1: Eliminar PDKs sky130/gf180 y herramientas no-IHP
3. ✅ Fase 2: Actualizar tests
4. ✅ Fase 3: PDK Development Mode
5. ✅ Fase 4: Actualizar documentación
6. Probar build completo del contenedor
7. Actualizar README.md principal (opcional)
