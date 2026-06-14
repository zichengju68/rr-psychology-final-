# CLAUDE.md · 复现项目作战须知（给 RStudio 里的 Claude Code）

> 本文件是项目级记忆，Claude Code 在本项目开工时会自动加载。
> 配套总控面板（进度/里程碑/风险）：`D:\R语言\期末大作业\进度追踪_R语言诺曼底登陆_v1.md`
> **老师/学院的评分标准原文（Word，以此为准）**：
> `D:\R语言\R4Psy（fork下的克隆人）\心理学院R编程语言课程可重复检验指南(2025版).docx`
> （同目录另有 2024《量化版》，仅供参考；一切以 **2025 版** 为准。本 CLAUDE.md 第三节是该指南的提炼，如与原文冲突，以原文 Word 为准。）
> 最后更新：2026-06-04（v1.1，已对齐学院指南）

---

## 一、这是什么项目

心理学院《R 编程语言》课程期末作业：对一篇已发表论文做**计算可复现性检验**——用原文的数据+方法，在 R 里重现原文报告的关键结果，并量化一致程度。

- **被复现论文**：*Reopening Openness to Experience: A Network Analysis of Four Openness to Experience Inventories*（JPA，已接收）
- **原文方法**：网络分析（TMFG 构网 + walktrap 社区检测）+ MANOVA 组间比较
- **数据**：`data/Openness Network_Items.csv`（网络分析，约 138 列：NEO 48 + BFAS 20 + HEXACO 16 + Woo 54）；`data/Openness Only_ANALYSIS FILE.sav`（MANOVA，含 Group 1/2/3）
- **原始脚本**：`r code/Reopening Openness to Experience.R`（219 行）
- **论文与补充材料**：`post-review manuscript/*.pdf`
- **执行模式**：单人完成（本人 + Claude Code 协作）。硬截止 **2026-06-11 18:30 课堂汇报**。

---

## 二、最高原则（本人 2026-06-04 拍板）

> **一切以"能复现原文献"为最优先。** 其它所有补充项都给复现让路，绝不挤占复现和汇报准备的时间。

排序：**跑通原文方法（网络分析 + MANOVA）> 描述统计对比 > （有时间）PE 评级 > 表格 > 创新方法 > 正式报告（本轮不做）。**

---

## 三、复现要做到什么程度（学院标准要点）

1. **先描述统计，后推断统计**：先算样本 N / Mean / SD 并与原文对比，确认样本本身无误，再做推断统计。
2. **用原文方法复现**：网络分析 + MANOVA，力求关键图、社区结构、统计量与论文一致。
3. **量化一致程度（PE，本项目列为"有时间再做"）**：
   - 百分误差 **PE = |原文报告值 − 复现值| / |原文报告值| × 100%**
   - 三级评级：完全一致(0%) / 次要偏差(0%<PE<10%) / 主要偏差(≥10%)；另记舍入误差、无法复现。
   - 推论一致性：原文 p 与复现 p 是否落在 α=0.05 **同侧**。

---

## 四、各项的执行定位（照此把握轻重）

| 项 | 定位 | 怎么做 |
|---|---|---|
| 跑通原文方法 | ✅ 必做·最高优先 | 见第五节 |
| 描述统计对比 | ✅ 必做 | 排在推断统计前，比 N/Mean/SD |
| PE 评级 | 🟡 补充选做 | 复现稳了、有时间再算，不作门槛 |
| 各种表格 | 🟡 条件项 | 看情况补，优先服务复现与汇报 |
| 创新方法（补课程统计方法） | 🟡 选做 bonus | 有余力再做，绝不挤占复现时间 |
| 正式检验报告 | ⬜ 本轮不做 | 终点为 PPT + 逐字稿 |
| 假设/数据集记录 | 🟢 轻量做 | 记录选了哪些假设+理由、变量类型与编码 |

---

## 五、给 Claude Code 的具体行动指引

**第一步 · 代码体检与修 bug**
- `install.packages(qgraph)` / `install.packages(igraph)` 缺引号 → 改为 `install.packages("qgraph")`、`install.packages("igraph")`。
- `read.csv(file.choose())` 改成写死相对路径，做成可一键运行的脚本（建议另存为 `repro/` 下的清洁版，**不要改原始 `r code/` 里的脚本**）。
- 确认 `NetworkToolbox` 能装（CRAN 可能已归档，备选 `devtools::install_github("AlexChristensen/NetworkToolbox")`，再不行评估 `EGAnet`）。

**第二步 · 数据准备**
- 读入 `Openness Network_Items.csv`，核对维度与列顺序（NEO 48 + BFAS 20 + HEXACO 16 + Woo 54 = 138；形状向量与社区切片都依赖这个顺序）。
- 用 `haven` 读 `Openness Only_ANALYSIS FILE.sav`，确认 Group 变量及其标签含义。

**第三步 · 描述统计（必做）**
- 算样本 N / Mean / SD，与论文报告值对比，记录差异。

**第四步 · 原文方法复现（最高优先）**
- TMFG 构网 → `convert2igraph` + walktrap 社区检测 → 10 个随机种子稳健性检查 → 确认社区数 = 10 并命名 → 画整体网络图 + 四套问卷分图。
- MANOVA：三组比较 + Box's M（`biotools::boxM`），核对统计量与论文。

**第五步 · 有余力再做**
- PE 评级、规定表格、创新方法（用课程内统计方法对同一假设另做一遍）。

---

## 六、纪律

- **原始数据和原始脚本只读不改**（`data/`、`r code/`、`post-review manuscript/` 等）。所有新产物放到新建目录（如 `repro/`、`assets/charts/`）。
- 复现脚本写清中文注释，遵循课程 workflow，做到可一键运行。
- 进度变化同步回 `..\进度追踪_R语言诺曼底登陆_v1.md`。
