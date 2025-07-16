# Relógio Digital 2 Minutos - VHDL

## Descrição
Projeto de um relógio digital em VHDL que conta até 2 minutos (00:00 a 01:59), desenvolvido para placa Cyclone II.

## Arquitetura do Sistema

```
                    ┌─────────────────────────────────────────────────────────────┐
                    │                    Relogio2Min                             │
                    │                                                             │
    CLK ────────────┤                                                             │
    RST ────────────┤              ┌─────────────────────────────────────────────┼─── HEX0 (Seg U)
                    │              │                                             ├─── HEX1 (Seg D)
                    │              │                                             ├─── HEX2 (Min U)
                    │              │                                             ├─── HEX3 (Min D)
                    │              │                                             │
                    │   ┌────────────────────────────────────────────────────────┤
                    │   │                                                        │
                    │   │  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
                    │   │  │  Seg U  │    │  Seg D  │    │  Min U  │    │  Min D  │
                    │   │  │ (0-9)   │    │ (0-5)   │    │ (0-9)   │    │ (0-1)   │
                    │   │  └─────────┘    └─────────┘    └─────────┘    └─────────┘
                    │   │       │             │             │             │
                    │   │       ▼             ▼             ▼             ▼
                    │   │  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
                    │   │  │Registr. │    │Registr. │    │Registr. │    │Registr. │
                    │   │  │4 bits   │    │4 bits   │    │4 bits   │    │4 bits   │
                    │   │  └─────────┘    └─────────┘    └─────────┘    └─────────┘
                    │   │       │             │             │             │
                    │   │       ▼             ▼             ▼             ▼
                    │   │  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
                    │   │  │Somador  │    │Somador  │    │Somador  │    │Somador  │
                    │   │  │4 bits   │    │4 bits   │    │4 bits   │    │4 bits   │
                    │   │  └─────────┘    └─────────┘    └─────────┘    └─────────┘
                    │   │       │             │             │             │
                    │   │       ▼             ▼             ▼             ▼
                    │   │  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
                    │   │  │Clear U  │    │Clear D  │    │Clear U  │    │Clear D  │
                    │   │  │(= 10)   │    │(= 6)    │    │(= 10)   │    │(= 2)    │
                    │   │  └─────────┘    └─────────┘    └─────────┘    └─────────┘
                    │   │                                                         │
                    │   └─────────────────────────────────────────────────────────┤
                    │                                                             │
                    │   ┌─────────┐                                               │
                    │   │   DF    │ ← Divisor de Frequência                       │
                    │   │ (1 Hz)  │                                               │
                    │   └─────────┘                                               │
                    │                                                             │
                    └─────────────────────────────────────────────────────────────┘
```

## Componentes do Sistema

### 1. **FlipFlopD.vhd**
- Flip-flop tipo D com clock e clear assíncrono
- Base para todos os registradores do sistema

### 2. **RegistradorCargaParalela.vhd**
- Registrador de 4 bits com carga paralela
- Utiliza array de FlipFlops tipo D
- Permite carregamento paralelo de dados

### 3. **SomadorCompleto.vhd**
- Somador completo de 1 bit (fornecido pela professora)
- Implementa: S = A ⊕ B ⊕ Cin, Cout = (A·B) + (A·Cin) + (B·Cin)

### 4. **Somador4bits.vhd**
- Somador de 4 bits usando cascata de SomadorCompleto
- Realiza incremento (+1) nos contadores

### 5. **CircuitoClearU.vhd**
- Detecta quando unidade = 10 (1010)
- Gera sinal de clear para resetar contador

### 6. **CircuitoClearD.vhd**
- Detecta quando dezena = 2 (0010) para minutos
- Detecta quando dezena = 6 (0110) para segundos
- Implementa limite de 2 minutos

### 7. **Decod7segmentos.vhd**
- Decodificador BCD para display de 7 segmentos
- Converte valores 0-9 para padrão de segmentos

### 8. **DF.vhd**
- Divisor de frequência para gerar clock de 1 Hz
- Divide clock da placa (50MHz) por 50.000.000

## Funcionamento

### Estrutura do Contador
- **Formato**: MM:SS (Minutos:Segundos)
- **Range**: 00:00 até 01:59
- **Reset**: Automático ao atingir 02:00

### Sequência de Contagem
1. **Segundos Unidade (0-9)**: Incrementa a cada segundo
2. **Segundos Dezena (0-5)**: Incrementa quando unidade vai de 9→0
3. **Minutos Unidade (0-9)**: Incrementa quando segundos vão de 59→00
4. **Minutos Dezena (0-1)**: Incrementa quando min. unidade vai de 9→0

### Lógica de Reset
- Cada contador possui seu próprio circuito de clear
- Reset automático quando atinge limite máximo:
  - Unidades: 10 → 0
  - Dezenas segundos: 6 → 0
  - Dezenas minutos: 2 → 0 (reset geral)

## Sinais de Entrada/Saída

### Entradas
- `CLK`: Clock principal da placa (50MHz)
- `RST`: Reset manual do sistema

### Saídas
- `HEX0`: Display unidade dos segundos (0-9)
- `HEX1`: Display dezena dos segundos (0-5)
- `HEX2`: Display unidade dos minutos (0-9)
- `HEX3`: Display dezena dos minutos (0-1)

## Implementação na Cyclone II

### Recursos Utilizados
- FlipFlops tipo D para armazenamento
- Lógica combinacional para somadores
- Decodificadores para displays
- Divisor de frequência por contador

### Características
- Sincronização por clock único
- Reset assíncrono
- Contagem automática
- Display em tempo real
- Reinício automático em 2 minutos

## Arquivos do Projeto

```
contador5m/
├── FlipFlopD.vhd              # Flip-flop tipo D
├── RegistradorCargaParalela.vhd # Registrador 4 bits
├── SomadorCompleto.vhd        # Somador completo 1 bit
├── Somador4bits.vhd           # Somador 4 bits
├── CircuitoClearU.vhd         # Clear unidades
├── CircuitoClearD.vhd         # Clear dezenas
├── Decod7segmentos.vhd        # Decodificador display
├── DF.vhd                     # Divisor frequência
├── Relogio2Min.vhd            # Módulo principal
├── unidade2.qpf               # Projeto Quartus
└── unidade2.qsf               # Configurações Quartus
```

## Compilação e Síntese

1. Abrir projeto no Quartus II
2. Definir Relogio2Min como top-level entity
3. Configurar pinos para Cyclone II
4. Executar compilação completa
5. Programar FPGA

## Teste e Verificação

- Verificar contagem sequencial: 00:00 → 00:01 → ... → 01:59 → 00:00
- Testar reset manual
- Confirmar funcionamento dos displays
- Validar temporização de 1 segundo