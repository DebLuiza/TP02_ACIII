# Processador RISC-V Pipeline de 5 Estágios

Este repositório contém a implementação de um processador **RISC-V de 32 bits** com pipeline de 5 estágios (IF, ID, EX, MEM, WB). O foco do projeto foi o tratamento de Hazards de Controle e de Dados para garantir a integridade da execução e a otimização do desempenho.

## 👥 Integrantes do Grupo
* **Arthur Carvalho Rodrigues**
* **Débora Luiza de Paula Silva**
* **Gustavo Henrique Rodrigues de Castro**
* **Mariana Almeida Mendonça**

---

## 🛠️ Implementações Realizadas

### 1. Correção de Hazard de Controle (BEQ)
* **Problema:** A `BranchUnit` calculava o endereço de destino incorretamente e não realizava o *flush* (limpeza) das instruções carregadas indevidamente após um desvio.
* **Solução:** Ajuste da lógica para `branch_target = pc_ex + branch_imm` e ativação do sinal de *flush* quando o desvio é tomado.

### 2. Resolução de Hazards de Dados (Software)
* **Abordagem:** Inserção manual de **3 NOPs** no código assembly.
* **Descoberta:** Identificamos que o simulador não divide o ciclo de escrita e leitura no estágio **Write-Back (WB)**. Por isso, o dado escrito só fica disponível no ciclo seguinte, exigindo uma bolha extra para estabilização.

### 3. Otimização via Hardware (Forwarding & Hazard Detection)
* **Forwarding Unit:** Encaminha dados dos estágios MEM e WB diretamente para a ALU, eliminando a necessidade de NOPs em operações aritméticas.
* **Hazard Detection Unit:** Detecta conflitos de *Load-Use* e injeta automaticamente um *stall* de 1 ciclo quando o dado provém da memória.

---

## 📊 Comparativo de Desempenho

| Métrica | Solução via Software (NOPs) | Solução via Hardware (Final) |
| :--- | :---: | :---: |
| **Ciclos Totais** | 26 | **15** |
| **CPI Final** | 3.71 | **2.14** |
| **Bypasses (Forwarding)** | 0 | **6** |
| **Stalls Automáticos** | 0 | **1** |

---

## 🧠 Transparência e Uso de IA
O desenvolvimento contou com o suporte do modelo **Gemini Pro 3.1**, utilizado como tutor para depuração de hardware e análise de métricas seguindo a metodologia *Spec-Driven Development*.

* **Evidência de Uso:** O histórico completo das interações e logs de simulação está disponível no arquivo [`testeChatGemini.pdf`](./testeChatGemini.pdf) neste repositório.

## 💻 Ferramentas Utilizadas
* **Linguagem:** Verilog
* **Simulador:** Icarus Verilog
* **Visualizador:** GTKWave
