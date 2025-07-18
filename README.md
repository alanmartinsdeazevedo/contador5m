# Relógio Digital 2 Minutos - VHDL

## Descrição
Projeto de um relógio digital em VHDL que conta até 2 minutos (00:00 a 01:59), desenvolvido para placa DE2 Cyclone II. O sistema exibe o tempo no formato MM:SS em displays de 7 segmentos.

## Arquitetura do Sistema

```
                    ┌─────────────────────────────────────────────────────────────┐
                    │                    PRINCIPAL                                │
                    │                                                             │
    CLK (50MHz) ────┤                                                             │
                    │   ┌─────────────────────────────────────────────────────────┤
                    │   │                                                         │
                    │   │  ┌─────────────┐    ┌─────────────┐                    │
                    │   │  │   Divisor   │    │  Contador   │                    │
                    │   │  │Frequência   │    │ 0-119 seg   │                    │
                    │   │  │50MHz→1Hz    │    │ (2 minutos) │                    │
                    │   │  └─────────────┘    └─────────────┘                    │
                    │   │                            │                           │
                    │   │       ┌────────────────────┼────────────────────┐      │
                    │   │       │                    │                    │      │
                    │   │       ▼                    ▼                    ▼      │
                    │   │  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
                    │   │  │  Seg U  │    │  Seg D  │    │  Min U  │    │  Min D  │
                    │   │  │ (0-9)   │    │ (0-5)   │    │ (0-9)   │    │ (0-1)   │
                    │   │  └─────────┘    └─────────┘    └─────────┘    └─────────┘
                    │   │       │             │             │             │      │
                    │   │       ▼             ▼             ▼             ▼      │
                    │   │ ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐  │
                    │   │ │Decod7seg│   │Decod7seg│   │Decod7seg│   │Decod7seg│  │
                    │   │ │         │   │         │   │         │   │         │  │
                    │   │ └─────────┘   └─────────┘   └─────────┘   └─────────┘  │
                    │   │       │             │             │             │      │
                    │   └───────┼─────────────┼─────────────┼─────────────┼──────┤
                    │           │             │             │             │      │
                    └───────────┼─────────────┼─────────────┼─────────────┼──────┘
                                │             │             │             │
                                ▼             ▼             ▼             ▼
                             HEX0          HEX1          HEX2          HEX3
                          (Seg Unid)    (Seg Dez)     (Min Unid)    (Min Dez)
```

## Componentes do Sistema

### 1. **principal.vhd** (Módulo Principal)
- Entidade top-level do sistema
- Integra divisor de frequência e lógica de contagem
- Gerencia conversão para formato MM:SS
- Instancia decodificadores para displays

### 2. **Decod7segmentos.vhd**
- Decodificador BCD para display de 7 segmentos
- Converte valores 0-9 para padrão de segmentos
- Configurado para displays anodo comum (DE2 padrão)

### 3. **Divisor de Frequência Integrado**
- Divisor interno que converte 50MHz para 1Hz
- Contador de 24.999.999 ciclos por transição
- Gera clock de 1 segundo para contagem

## Funcionamento

### Estrutura do Contador
- **Formato**: MM:SS (Minutos:Segundos)
- **Range**: 00:00 até 01:59 (2 minutos)
- **Reset**: Automático ao atingir 02:00

### Lógica de Contagem
1. **Contador Principal**: Incrementa de 0 a 119 (120 segundos = 2 minutos)
2. **Conversão MM:SS**:
   - Minutos = contador ÷ 60
   - Segundos = contador mod 60
3. **Separação Dígitos**:
   - Unidade = valor mod 10
   - Dezena = valor ÷ 10

### Sequência de Contagem
```
00:00 → 00:01 → 00:02 → ... → 00:59 → 01:00 → 01:01 → ... → 01:59 → 00:00
```

### Mapeamento de Displays
- **HEX3**: Dezena dos minutos (0-1)
- **HEX2**: Unidade dos minutos (0-9)
- **HEX1**: Dezena dos segundos (0-5)
- **HEX0**: Unidade dos segundos (0-9)

## Sinais de Entrada/Saída

### Entradas
- `CLK`: Clock principal da placa (50MHz - Pino N2)

### Saídas
- `HEX0[6:0]`: Display unidade dos segundos (Pinos AF10-V13)
- `HEX1[6:0]`: Display dezena dos segundos (Pinos V20-AB24)
- `HEX2[6:0]`: Display unidade dos minutos (Pinos AB23-Y24)
- `HEX3[6:0]`: Display dezena dos minutos (Pinos Y23-W24)

## Implementação na DE2 Cyclone II

### Recursos Utilizados
- **Device**: EP2C35F672C6
- **Clock**: 50MHz interno
- **Displays**: 4 x 7-segmentos anodo comum
- **Lógica**: Contadores e divisores por inteiros

### Características Técnicas
- **Frequência**: 50MHz → 1Hz via divisor integrado
- **Contagem**: Automática sem reset manual
- **Precisão**: 1 segundo exato
- **Ciclo**: 2 minutos (120 segundos)

## Arquivos do Projeto

```
contador5m/
├── principal.vhd              # Módulo principal (TOP-LEVEL)
├── Decod7segmentos.vhd        # Decodificador 7 segmentos
├── unidade2.qpf               # Projeto Quartus II
├── unidade2.qsf               # Configurações e pinagem
└── README.md                  # Esta documentação
```

## Compilação e Síntese

### Passos para Compilação
1. Abrir `unidade2.qpf` no Quartus II
2. Verificar TOP_LEVEL_ENTITY = `principal`
3. Executar Analysis & Synthesis
4. Executar Fitter (Place & Route)
5. Gerar arquivo de programação (.sof)

### Programação da FPGA
1. Conectar cabo USB-Blaster à DE2
2. Abrir Quartus II Programmer
3. Carregar arquivo `.sof` gerado
4. Programar dispositivo

## Teste e Verificação

### Funcionamento Esperado
- **Inicialização**: Display mostra 00:00
- **Contagem**: Incrementa automaticamente a cada segundo
- **Sequência**: 00:00 → 00:01 → ... → 01:59 → 00:00
- **Reset**: Automático ao completar 2 minutos

### Validação dos Displays
- ✅ **HEX0**: Conta 0→9 repetidamente (unidade segundos)
- ✅ **HEX1**: Conta 0→5 a cada 10 segundos (dezena segundos)
- ✅ **HEX2**: Conta 0→9 a cada minuto (unidade minutos)
- ✅ **HEX3**: Conta 0→1 a cada 10 minutos (dezena minutos)

### Tempo de Ciclo
- **Ciclo completo**: 2 minutos (120 segundos)
- **Precisão**: ±1 segundo (baseado em crystal 50MHz)

## Apresentação para a Professora

### Pontos Principais
1. **Implementação funcional** de relógio digital em VHDL
2. **Arquitetura otimizada** com divisor de frequência integrado
3. **Displays 7-segmentos** funcionando corretamente
4. **Contagem automática** de 2 minutos com reset
5. **Pinagem configurada** para placa DE2 Cyclone II

### Demonstração Prática
- Ligar a placa DE2
- Mostrar displays iniciando em 00:00
- Observar contagem automática
- Demonstrar reset ao atingir 01:59→00:00

### Arquivos para Entrega
- `principal.vhd` - Código principal
- `Decod7segmentos.vhd` - Decodificador
- `unidade2.qpf` - Projeto Quartus
- `unidade2.qsf` - Configurações
- `README.md` - Documentação completa

## Conclusão

O projeto implementa com sucesso um relógio digital de 2 minutos usando VHDL para FPGA Cyclone II. A arquitetura é otimizada, funcional e atende aos requisitos propostos, demonstrando domínio dos conceitos de design digital e programação em VHDL.