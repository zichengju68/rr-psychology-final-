# rr-psychology-final · 对 Christensen 等（2019）的计算可复现性检验

> 《R 编程语言及其在心理学研究中的运用》期末作业 — 独立完成，全程「有人引导的 AI 协作」。
>
> **复现文献**：Christensen, A. P., Cotter, K. N., & Silvia, P. J. (2019). Reopening openness to experience: A network analysis of four openness to experience inventories. *Journal of Personality Assessment, 101*(6), 574–588. https://doi.org/10.1080/00223891.2018.1467428
>
> **原始数据 / 代码（OSF）**：https://osf.io/954a7/overview

---

## 一句话结论

在 R 4.5.2 下复现了原文的网络分析（TMFG + walktrap）与三批样本组间比较（MANOVA）。**采用原文方法的推断统计 14 项全部「完全一致」（δ = 0%），5 个统计推论全部一致；网络结构逐题一致率 92.8%、10 个分面一对一全部还原。** 唯一差异是新版 `igraph` 使 walktrap 自动社区数由 10 变 8（版本敏感性），用 `cut_at(no=10)` 强切回 10 即对齐。结论：该文献计算可复现性高。

| 检验 | 结果 |
|---|---|
| 推断统计结果可复现性 | 14 / 14 完全一致（δ = 0%） |
| 统计推论一致性 | 5 / 5 一致（100%） |
| 网络社区结构逐题一致率 | 128 / 138 = 92.8% |
| 样本量复现 | 802 / 176 / 108 / 518（完全一致） |
| 唯一差异 | igraph 版本致社区数 10→8（可控，强切回 10 对齐） |

---

## 📂 目录导览

所有交付物都在 [`Reopening Openness to Experience/`](<Reopening Openness to Experience/>) 文件夹下。

| | 内容 | 位置 | 说明 |
|---|---|---|---|
| 📄 | **可复现性报告** | [`可复现性报告/`](<Reopening Openness to Experience/可复现性报告/>) | 主交付物 `对Christensen等(2019)研究结果的计算可复现性检验报告.docx`，按指南附录撰写，含 8 张结果表 |
| 📊 | **汇报 PPT** | [`ppt/`](<Reopening Openness to Experience/ppt/>) | `复现汇报.pptx`（汇报用幻灯片）；`build_ppt.py` 为生成脚本 |
| 💻 | **复现代码** | [`r code/`](<Reopening Openness to Experience/r code/>) | `Reopening Openness to Experience.R` = 原作者原始脚本；`Reopening Openness to Experience.R副本.R` = 本人复现代码（在原作者基础上做了修改）；`复现脚本_8社区分支.R` = Claude Code 编写的 8 社区稳健性分支；`注释.R` = 本人复现笔记（遇到的问题、思路与总结） |
| 🖼️ | **图片** | [`图片/`](<Reopening Openness to Experience/图片/>) | `我的输出图片/` = 本人复现产出（网络图 PDF + 过程截图）；`Claude输出的图片/` = 8 社区分支输出 PNG |

### 其余材料

| | 内容 | 位置 |
|---|---|---|
| 📑 | 对照表 | [`表格/`](<Reopening Openness to Experience/表格/>) — `可复现性检验_表格汇总.xlsx`（文献信息 / 描述统计 / 推断统计 / 结果评级 / 推论一致 / 原因分析） |
| 🎙️ | 逐字稿 | [`逐字稿/`](<Reopening Openness to Experience/逐字稿/>) — 汇报演讲稿 |
| 🧮 | 复现输出 | [`复现输出/`](<Reopening Openness to Experience/复现输出/>) — MANOVA / 网络分析结果 txt + 8 社区分支笔记 |
| 📦 | 数据 | [`data/`](<Reopening Openness to Experience/data/>) — OSF 公开的处理后数据（.sav / .csv，详见下方数据说明） |
| 🗂️ | 过程与记忆 | [`元文件/`](<Reopening Openness to Experience/元文件/>) — `CLAUDE.md` 项目记忆、复现思路 / 计划、进度追踪表 |

> 📖 更详细的研究背景、方法范围与复现步骤，见子文件夹内的 [完整 README](<Reopening Openness to Experience/README.md>)。

---

## 原文研究简介

开放性（Openness to Experience）是大五人格维度之一，但其低阶分面（facet）结构长期存在争议——四套主流量表对它的切分各不相同。原文把四套量表（NEO-PI-3、BFAS、HEXACO-100、Woo 等 2014）共 **138 道题**当作节点、题目相关当作边，用 **TMFG** 构建稀疏平面网络、用 **walktrap** 社区检测识别分面，得到 **10 个分面 / 3 个高阶方面**（体验、智力、思想开放），并比较四套量表的概念覆盖。结论：四套量表测同一大构念但覆盖极不均衡，Woo 量表覆盖最广最均衡。

## 复现范围

- **已复现**：① 网络结构（TMFG + walktrap → 10 分面 / 3 方面）；② 四套量表概念覆盖（Figure 1/2、SI 3–6）；③ 三批样本组间比较（MANOVA + Box's M，SI 7）。
- **未复现**：④ facet 信度与相关（原文 Table 3，Rasch 信度）——需 Rasch 建模、超出课程统计方法范围，不计入百分误差。
- **扩展**：以新版 igraph 原生 8 社区重跑作稳健性检查，核心结论稳健。

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

## 数据说明

原文**未公开原始数据**（原始清洗在 SPSS 完成），OSF 仅提供**处理后数据**，本研究合规使用、未修改样本量。如需引用或再分发，请遵循原作者与 OSF（https://osf.io/954a7/overview）的相关条款。数据亦内置于 R 包 `NetworkToolbox` 的 `openness` 数据集。

## 关于 AI 协作

本次复现全程借助 AI（Claude / Claude Code）协作：用 `CLAUDE.md` 作为项目记忆、用进度表拆解任务、由 AI 协助编写与调试代码、排查报错。**分析方向、结果取舍与正确性判断由本人主导，AI 输出一律以原文报告值为标尺逐项核验后采信**——属「有人引导的 AI 协作」，而非完全由 AI 生成。

---

*作者：独立完成（文献研读、代码复现、报告与 PPT 制作）。*
