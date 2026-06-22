# 对 Christensen 等（2019）的计算可复现性检验

> 《R 编程语言及其在心理学研究中的运用》期末作业 · 计算可复现性检验
>
> 复现文献：**Christensen, A. P., Cotter, K. N., & Silvia, P. J. (2019). Reopening openness to experience: A network analysis of four openness to experience inventories. _Journal of Personality Assessment, 101_(6), 574–588.** https://doi.org/10.1080/00223891.2018.1467428
>
> 原始数据 / 代码（OSF）：https://osf.io/954a7/overview

---

## 一句话结论

在 R 4.5.2 下、全程借助 AI（Claude）协作，复现了原文的网络分析与组间比较。**采用原文方法的推断统计 14 项结果全部「完全一致」（δ = 0%），5 个统计推断推论全部一致；网络结构逐题一致率 92.8%、10 个分面一对一全部还原。** 唯一差异是新版 `igraph` 使 walktrap 自动社区数由 10 变 8（版本敏感性），`cut_at(no=10)` 强切回 10 即对齐。该文献计算可复现性高。

| 检验 | 结果 |
|---|---|
| 推断统计结果可复现性 | 14 / 14 完全一致（δ = 0%） |
| 推论一致性 | 5 / 5 一致（100%） |
| 网络社区结构逐题一致率 | 128 / 138 = 92.8% |
| 样本量复现 | 802 / 176 / 108 / 518（完全一致） |
| 唯一差异 | igraph 版本致社区数 10→8（可控，强切回 10 对齐） |

---

## 目录导览

| 内容 | 位置 |
|---|---|
| 📄 **可复现性报告** | [`可复现性报告/对Christensen等(2019)研究结果的计算可复现性检验报告.docx`](可复现性报告/) |
| 📊 **汇报 PPT** | [`ppt/复现汇报.pptx`](ppt/) |
| 💻 **复现代码** | [`r code/`](r%20code/) 内含四个文件：`Reopening Openness to Experience.R`（**原作者**原始脚本）、`Reopening Openness to Experience.R副本.R`（**我的**复现代码，在原作者脚本基础上做了修改）、`复现脚本_8社区分支.R`（**Claude Code 编写**的 8 社区稳健性分支）、`注释.R`（**我的复现笔记**：过程中遇到的问题、解决思路与总结） |
| 🖼️ **图片** | [`图片/`](图片/)（自产网络图 PDF：整体网络图、量表各自网络图、四套分图；及复现过程截图）、[`复现输出/`](复现输出/)（8 社区分支 PNG + 结果 txt） |
| 📑 **对照表** | [`表格/可复现性检验_表格汇总.xlsx`](表格/)（表1 文献信息、表2 描述统计、表5 推断统计、表7 结果评级、表8 推论一致、表10 原因分析） |
| 🎙️ **逐字稿** | [`逐字稿/`](逐字稿/) |
| 📦 **数据** | [`data/`](data/)（处理后数据；原始数据见 OSF，详见下方「数据说明」） |
| 🗂️ **过程与记忆** | [`元文件/`](元文件/)（`CLAUDE.md` 项目记忆、进度追踪表，记录 AI 协作过程） |

---

## 原文研究简介

开放性（Openness to Experience）是大五人格维度之一，但其低阶分面（facet）结构长期存在争议，四套主流量表对它的切分各不相同。原文把四套量表（NEO-PI-3、BFAS、HEXACO-100、Woo 等人 2014）共 **138 道题**当作节点、题目相关当作边，用 **TMFG** 构建稀疏平面网络、用 **walktrap** 社区检测识别分面，得到 **10 个分面 / 3 个高阶方面**（体验、智力、思想开放），并比较四套量表的概念覆盖。结论：四套量表测同一大构念但覆盖极不均衡，Woo 覆盖最广最均衡。

---

## 复现方法与范围

- **已复现**：① 网络结构（TMFG + walktrap → 10 分面 / 3 方面）；② 四套量表概念覆盖（Figure 1/2、SI 3–6）；③ 三批样本组间比较（MANOVA + Box's M，SI 7）。
- **未复现**：④ facet 信度与相关（原文 Table 3，Rasch 信度）——需 Rasch 建模、超出课程统计方法范围，未纳入复现选取、不计入百分误差。
- **扩展**：以新版 igraph 原生 8 社区重跑作稳健性检查（`r code/复现脚本_8社区分支.R`），核心结论稳健。

## 运行环境

```
R 4.5.2
NetworkToolbox 1.4.4   # 已从 CRAN 归档，需从 GitHub 安装：
                       # devtools::install_github("AlexChristensen/NetworkToolbox")
qgraph 1.9.8
igraph 2.3.2           # ⚠️ 版本敏感：新版 walktrap 自动社区数=8，需 cut_at(no=10) 切回 10
haven                  # 读取 .sav
biotools               # Box's M 检验
```

## 如何复现

1. 安装上述程序包（NetworkToolbox 从 GitHub 装）。
2. `setwd()` 到本仓库根目录。
3. 运行我的复现代码 `r code/Reopening Openness to Experience.R副本.R`：依次完成 TMFG 构网 → walktrap 社区检测（`cut_at(no=10)` 强切 10）→ 按 SI 2 逐题核对命名 → 出 Figure 1/2 → MANOVA + Box's M（含用 138 题响应指纹重建分组变量 Group）。
4. 复现过程中遇到的问题、解决思路与总结，记在 `r code/注释.R`（笔记）中；8 社区稳健性分支见 `r code/复现脚本_8社区分支.R`（Claude Code 编写）。

## 数据说明

原文**未公开原始数据**（原始清洗在 SPSS 完成），OSF 仅提供**处理后数据**，本研究合规使用处理后数据，未修改样本量。`data/` 下的数据来自原文公开材料；如需引用或再分发，请遵循原作者与 OSF 的相关条款，并优先从 OSF（https://osf.io/954a7/overview）获取。数据亦内置于 R 包 `NetworkToolbox` 的 `openness` 数据集。

## 关于 AI 协作

本次复现全程借助 AI 工具（Claude / Claude Code）协作：用 `CLAUDE.md` 作为项目记忆、用进度表拆解任务、由 AI 协助编写与调试代码、排查报错。**分析方向、结果取舍与正确性判断由本人主导，AI 输出一律以原文报告值为标尺逐项核验后采信**——属「有人引导的 AI 协作」，而非完全由 AI 生成。

---

*作者：独立完成（文献研读、代码复现、报告与 PPT 制作）。*
