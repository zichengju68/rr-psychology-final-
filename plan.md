# 期末作业：心理学论文复现计划

> R 语言期末作业：复现一篇 psychology 文章的数据、分析、图、表

## 项目目标

完整复现一篇 psychology 文章的 **数据 → 分析 → 图 → 表**，最终产出：

- 🎤 口头汇报 slides（10–15 分钟）
- 📦 配套材料：可重跑的 Rmd 报告 + 干净数据 + 代码包

## 4 周时间线

### 📖 第 1 周：吃透原文 + 拿数据 + 跑通环境

| Day | 任务 | 产出 |
|-----|------|------|
| 1 | 通读原文 1 遍 | 笔记：研究问题、假设、关键变量 |
| 2 | 精读 + 看 supplementary | 一句话讲清"这文章在做什么" |
| 3 | 从 OSF/期刊网站下载数据和代码 | `data/` + 原作者脚本 |
| 4 | 整理 codebook（变量清单） | `codebook.md` |
| 5 | 配置 R 环境 | `sessionInfo()` 截图 |
| 6 | 尝试跑通原作者代码 | 看哪些能跑、哪些会断 |
| 7 | 周回顾 + 写 README | 项目结构图 |

### 🔧 第 2 周：数据复现

| Day | 任务 | 产出 |
|-----|------|------|
| 8–9 | 数据清洗 | `01_clean_data.R` |
| 10 | 样本筛选（exclusion criteria） | 验证 N 对得上原文 |
| 11 | 关键变量构造 | `02_construct_vars.R` |
| 12 | 描述统计 | 跟原文 Table 1 对比 |
| 13–14 | 复现 Table 1 | 数字一一对得上 |

### 📊 第 3 周：分析与图表复现

| Day | 任务 | 产出 |
|-----|------|------|
| 15 | 主分析模型 | `03_main_analysis.R` |
| 16 | 复现 Table 2、3… | β、SE、p 值一致 |
| 17–18 | 复现 Figure 1、2…（ggplot2） | PNG/PDF |
| 19 | 稳健性检验 | 补充结果 |
| 20 | 数字对照表 | 你 vs 原文 |
| 21 | 缓冲日 | 处理疑难 |

### 🎤 第 4 周：汇报准备

| Day | 任务 | 产出 |
|-----|------|------|
| 22 | 写 Rmd 报告主体 | `report.Rmd` |
| 23 | knit 出 html | `report.html` |
| 24–25 | 制作 slides（xaringan / ioslides） | `slides.Rmd` |
| 26 | 演练第 1 次（计时） | 时长 + 卡壳点 |
| 27 | 修改 slides + 演练第 2 次 | 流畅度提升 |
| 28 | 最终演练 + 整理交付包 | 项目压缩包 |

## 风险点 & 应对

| 风险 | 概率 | 应对 |
|------|------|------|
| 原作者只放部分数据 | 高 | Day 3 之前发现，必要时换论文 |
| 原作者用 SPSS/Stata | 高 | 用 `haven` 包读，或自己重写 |
| 数字差一点点 | 中 | 报告中说明"复现至 ±0.01" |
| 数字差很多 | 中 | 检查 exclusion、编码、模型 spec |
| 汇报超时 | 中 | 提前演练 2 次 |

## 推荐工具

- **数据读取**：`haven`（SPSS/Stata）、`readxl`、`readr`
- **数据处理**：`tidyverse`、`janitor`
- **统计**：`broom`、`emmeans`、`performance`
- **报告**：`knitr`、`kableExtra`、`gtsummary`
- **slides**：`xaringan`、`ioslides`

## 最终交付物清单

- [ ] `data/` — 原始数据 + 处理后数据
- [ ] `code/` — 4 个分阶段 R 脚本
- [ ] `output/tables/` — 所有 Table
- [ ] `output/figures/` — 所有 Figure
- [ ] `report.Rmd` / `report.html`
- [ ] `slides.Rmd` / `slides.html`
- [ ] `reproducibility_check.md` — 你的数字 vs 原文数字对照
- [ ] `README.md` — 项目说明 + 怎么跑
