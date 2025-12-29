# Plan: IHP-Focused EDA Container

## Objetivo

Crear una versión simplificada y especializada del contenedor IIC-OSIC-TOOLS enfocada exclusivamente en el PDK IHP SG13G2, que sirva para:

1. **Diseño de circuitos** - Usuarios finales diseñando con IHP
2. **Desarrollo del PDK** - Contribuidores mejorando/manteniendo el PDK
3. **Extensibilidad** - Facilitar integración de nuevas herramientas con el PDK

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

### TIER 1: Core (Siempre incluidas) - ~15 herramientas
Esenciales para cualquier diseño IHP.

**Esquemáticos y Layout:**
- `xschem` - Editor de esquemáticos
- `klayout` - Editor de layout
- `magic` - Layout con DRC/PEX integrado
- `gds3d` - Visualizador 3D

**Simulación Analógica:**
- `ngspice` - SPICE con OSDI
- `xyce` - SPICE paralelo
- `gaw3-xschem` - Visor de ondas

**Verificación:**
- `netgen` - LVS
- `cvc` - ERC

**Utilidades:**
- `openvaf` - Compilador Verilog-A (crítico para PDK dev)
- `ciel` - Gestor versiones PDK

### TIER 2: Digital Flow (Opcional) - ~12 herramientas
Para diseño digital RTL-to-GDS.

**Síntesis:**
- `yosys` - Síntesis lógica
- `ghdl` + plugin - VHDL support
- `slang` + plugin - SystemVerilog

**Place & Route:**
- `openroad` - P&R engine
- `librelane` - Flow completo

**Simulación Digital:**
- `iverilog` - Simulador Verilog
- `verilator` - Simulador rápido
- `ghdl` / `nvc` - Simuladores VHDL
- `gtkwave` - Visor ondas digital
- `cocotb` - Testbench Python

**Verificación Formal:**
- `eqy`, `sby`, `mcy` - Formal verification suite

### TIER 3: PDK Development (Nuevo) - ~8 herramientas
Específicas para desarrollo/mantenimiento del PDK.

**Compilación de Modelos:**
- `openvaf` - Verilog-A → OSDI
- `adms` - Verilog-A legacy (para Xyce)

**Caracterización:**
- `charlib` - Caracterización std cells
- `lctime` - Liberty timing
- `cace` - Characterization engine

**Testing/Validación:**
- `pytest` - Framework testing
- `ngspyce` - Python bindings ngspice
- `pyspice` - Python SPICE interface

**Documentación:**
- `schemdraw` - Diagramas circuitos
- Scripts validación DRC/LVS

### TIER 4: Eliminadas - ~40+ herramientas
No incluidas en la imagen IHP.

**RF/EM (demasiado especializadas):**
- openems, palace, qucs-s, rftoolkit
- FastHenry2, FasterCap

**RISC-V (no relevante):**
- riscv-gnu-toolchain, spike, riscv-pk, pulp-tools

**FPGA (no ASIC):**
- nextpnr

**Redundantes o poco usadas:**
- xcircuit (usar xschem)
- pyopus (removido por incompatibilidades)
- surelog (cubierto por slang)
- covered, irsim, qflow
- kactus2, libman, najaeda
- openram, padring
- veryl, amaranth, chisel (HDLs alternativos)
- pyuvm, fault
- gdsfactory, gdspy (GDS scripting)
- pygmid, hdl21, vlsirtools
- siliconcompiler, rggen, fusesoc, edalize
- surfer (crashes conocidos)

---

## Modos de Imagen

### Opción A: Imagen Única Configurable
Una sola imagen con todo, ~8-10 GB (vs 20+ GB actual).

```dockerfile
# Layers
FROM base
FROM tools-core      # Siempre
FROM tools-digital   # Opcional via build arg
FROM tools-pdk-dev   # Opcional via build arg
FROM pdk-ihp         # PDK
```

### Opción B: Múltiples Imágenes (Recomendada)
Imágenes separadas por caso de uso.

| Imagen | Contenido | Tamaño Est. | Usuario |
|--------|-----------|-------------|---------|
| `ihp-eda:core` | Tier 1 + PDK | ~4 GB | Diseño analógico básico |
| `ihp-eda:full` | Tier 1+2 + PDK | ~8 GB | Diseño completo |
| `ihp-eda:pdk-dev` | Tier 1+3 + PDK (dev mode) | ~6 GB | Desarrolladores PDK |

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

## Beneficios de la Simplificación

| Aspecto | Actual | Propuesto |
|---------|--------|-----------|
| Tamaño imagen | ~20 GB | 4-8 GB |
| Herramientas | 70+ | 15-35 |
| PDKs | 3 | 1 (IHP) |
| Tiempo build | Horas | ~1 hora |
| Complejidad | Alta | Media |
| Foco | General | IHP específico |

---

## Fases de Implementación

### Fase 1: Fork y Limpieza (1-2 semanas)
1. Fork del repositorio
2. Eliminar PDKs sky130 y gf180
3. Eliminar herramientas Tier 4
4. Simplificar scripts de build
5. Actualizar tests (solo IHP)

### Fase 2: Reestructuración (1-2 semanas)
1. Reorganizar estructura de directorios
2. Crear sistema de tiers/layers
3. Implementar múltiples variantes de imagen
4. Actualizar documentación

### Fase 3: PDK Development Mode (1 semana)
1. Crear directorio pdk-dev/
2. Implementar scripts de validación
3. Crear templates de integración
4. Documentar workflow de desarrollo

### Fase 4: Testing y Documentación (1 semana)
1. Suite completa de tests IHP
2. CI/CD simplificado
3. Documentación usuario
4. Documentación desarrollador PDK

---

## Preguntas para Definir

1. **Nombre del proyecto**: ¿`ihp-eda-tools`, `ihp-asic-tools`, otro?

2. **Imágenes**: ¿Una imagen configurable o múltiples imágenes separadas?

3. **Flujo digital**: ¿Incluir siempre o como variante opcional?

4. **Herramientas RF**: ¿Eliminar completamente o mantener alguna?

5. **Compatibilidad**: ¿Mantener compatibilidad con scripts iic-osic-tools originales?

6. **Repositorio**: ¿Fork separado o branch en el mismo repo?

---

## Próximos Pasos

1. Validar este plan contigo
2. Definir respuestas a las preguntas anteriores
3. Crear estructura inicial del proyecto
4. Comenzar Fase 1 de implementación
