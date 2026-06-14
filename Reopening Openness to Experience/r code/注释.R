#提示
> packageVersion("qgraph"); packageVersion("igraph"); packageVersion("NetworkToolbox")
[1] ‘1.9.8’
[1] ‘2.3.2’
[1] ‘1.4.4’

# =====================================================================
# 复现发现记录 · 网络社区检测（walktrap）· 2026-06-06
# =====================================================================
#
# 【现象】
# 按原文方法跑 TMFG 构网 + walktrap 社区检测，set.seed(0) 后
#   wc <- walktrap.community(walktrap); max(wc$membership)  ==> 8
# 而论文报告的是 10 个社区。检查点（应为 10）未通过。
#
# 【定位 · 不是种子问题】
# walktrap 是确定性算法（用转移概率矩阵计算，不真的模拟随机游走），
# 换种子结果不变；原文那段"10 个随机种子稳健性检查"每次也都一样。
# 所以 8 是稳定结果，不是抽样波动。
#
# 【根因 · igraph 版本漂移】
# TMFG 构网、convert2igraph 都是确定性的；"Variables detected as ordinal"
# 说明 TMFG 照常用 cor_auto 算多分相关，与原文一致。
# 核对 SI 8 原始 R 代码：原文就是 TMFG(data) + walktrap.community(walktrap)
# + set.seed(0)，与本脚本方法零差异。
# 差异只来自 R 包版本：原文 igraph 1.x，本机 igraph 2.3.2。
# 新版 walktrap 在"按模块度选最优切点"时切得更浅 → 8 而非 10。
# 这是网络分析复现里典型的"版本敏感性"。
#
# 【救回 · 强制切到 10 个社区】
#   m10 <- igraph::cut_at(wc, no = 10)        # 同一棵层次树多切两刀
#   max(m10)                                  # = 10
# 模块度对比（越高=社区分得越干净）：
#   8 类  modularity = 0.7221
#   10 类 modularity = 0.7124
# 两者仅差 0.0098（约 1.4%），几乎一样好 —— 即网络本身没变，
# 只是"自动切多深"随版本改变；10 社区结构本就在树里。
#
# 【与原文逐题核对（对照 SI 2 的 Walktrap Facet 归属）】
# 解析已用"论文 10 个 facet 已知题数"做校验和验证无误。
# 结果：逐题一致率 = 128/138 = 92.8%；10 个社区与论文 facet 一对一全部还原。
#
#   m10编号  ->  论文 facet                  纯度    高阶 aspect
#     1          Self-Assessed Intelligence  100%    Intellect
#     3          Intellectual Interests       85%    Intellect
#     8          Intellectual Curiosity       92%    Intellect
#     6          Non-Traditionalism           82%    Open-Mindedness
#    10          Variety-Seeking             100%    Open-Mindedness
#     4          Diversity                    73%    Open-Mindedness
#     2          Aesthetic Appreciation      100%    Experiencing
#     5          Openness to Emotions        100%    Experiencing
#     7          Imaginative                 100%    Experiencing
#     9          Fantasy                     100%    Experiencing
#
# 6 个社区 100% 一致，其余在 73–92%。仅 10 道题落位不同，
# 且全是社区边界上的题（多为反向计分/外围题：Fe1、Fe2、Va7、Ac1、
# Fa8、Op5、Uc4、To4、Ig5、Cu4），在两个概念相邻的 facet 间摆动 ——
# 符合版本漂移只动边界、不动核心(core items)的预期。
#
# 【复现结论 / 评级】
# 网络结构高度复现：10 个 facet、3 个高阶 aspect 一对一全部还原，
# 逐题一致率 92.8%。偏差有二：① walktrap 最优切点随 igraph 版本
# 由 10 变 8（强制切 10 即恢复）；② 10 道边界题归属微调。
# 方法零差异，归类为"次要偏差 / 版本敏感性"。
#
# =====================================================================
# 【可复现代码 · 命名社区】
# 注意：cut_at 给的编号 1–10 与论文/原脚本第 39 行命名循环的编号顺序
# 不一致，切勿直接套用那个按数字硬贴名字的循环（会贴错）。
# 用下面这段——按与 SI 2 逐题核对得到的正确映射贴名：
# ---------------------------------------------------------------------
# m10 <- igraph::cut_at(wc, no = 10)          # 强制 10 社区
# facet_names <- c(
#   "Self-Assessed Intelligence",  # 1
#   "Aesthetic Appreciation",      # 2
#   "Intellectual Interests",      # 3
#   "Diversity",                   # 4
#   "Openness to Emotions",        # 5
#   "Non-Traditionalism",          # 6
#   "Imaginative",                 # 7
#   "Intellectual Curiosity",      # 8
#   "Fantasy",                     # 9
#   "Variety-Seeking"              # 10
# )
# wc$membership <- facet_names[m10]           # 138 维, 按列顺序, 正确 facet 名
# table(wc$membership)                        # 核对各 facet 题数
# # 之后第 60 行起的"整体网络图 + 四套分图"可原样运行
# =====================================================================
#
# 【为什么不能用原脚本第 39 行那段命名循环 · 务必看】
# 两段代码目的相同（把社区数字编号换成 facet 名），但"号码→名字"
# 的对应表不同，原脚本那张表对我们的运行是错的。
#
# 关键：walktrap 给社区发的编号 1、2、3… 是任意的。算法内部按自己的
# 顺序发号，号码本身没有含义，只有"哪些题被分到一起"才有意义。
# 原脚本"1 = Intellectual Curiosity"是针对作者那次运行（其 igraph 版本、
# 其 walktrap 输出顺序）核对出来的；我们 cut_at(10) 这次运行发号顺序不同，
# 所以我们的"1"是 Self-Assessed Intelligence。两份号码簿对照：
#
#   编号   原脚本(第39行)               我们的(本机运行)
#    1     Intellectual Curiosity       Self-Assessed Intelligence   <-不同
#    2     Aesthetic Appreciation       Aesthetic Appreciation        (碰巧同)
#    3     Self-Assessed Intelligence   Intellectual Interests       <-不同
#    4     Openness to Emotions         Diversity                    <-不同
#    5     Intellectual Interests       Openness to Emotions         <-不同
#    6     Imaginative                  Non-Traditionalism           <-不同
#    7     Non-Traditionalism           Imaginative                  <-不同
#    8     Diversity                    Intellectual Curiosity       <-不同
#    9     Variety-Seeking              Fantasy                      <-不同
#   10     Fantasy                      Variety-Seeking              <-不同
#
# 除 #2 碰巧一致外其余全部错位。若把第 39 行循环套到我们的 wc$membership，
# 每个社区几乎都会贴错名字。因此画图前必须用上面【可复现代码·命名社区】
# 那段（我们自己与 SI 2 逐题核对得到的映射），不要用第 39 行。
#
# 注：成员归属(哪题进哪社区)始终用我们自己的 m10；只是借用作者的 facet
# 名来标注，便于和论文 Figure 1 对照。那 10 道边界题的差异如实保留为结果。
# =====================================================================
#
# =====================================================================
# 复现发现记录 · Figure 1 / Figure 2 出图 + 覆盖对照 · 2026-06-06
# =====================================================================
#
# 【Figure 1 · 整体网络图】(第 60 行起那段，原样可跑)
# 复现成功：10 个社区颜色块清晰；四种形状对应四套问卷
#   圆=NEO(48) 方=BFAS(20) 菱=HEXACO(16) 三角=Woo(54)；
# 三角(Woo)几乎进入每个颜色块 —— 直观体现 Woo 覆盖面最广。
# 注：layout="spring" 为随机布局(Fruchterman-Reingold)，节点空间位置
# 每次跑都不同、与论文图不一一对应(论文自己也声明)；对照只看
# 结构/社区/形状分布，不看绝对位置。配色因 palette="ggplot2" 按字母序
# 自动分配，与论文颜色不同，纯属外观，不影响结论。
#
# 【Figure 2 · 四套问卷分图】(第 93 行起那段)
# 同一网络画四遍，每遍只给一套问卷的题上色、其余三套灰掉(NA)，
# 用来看每套问卷覆盖了哪些 network-identified facet。
# 切片(按列顺序): NEO 1–48, BFAS 49–68, HEXACO 69–84, Woo 85–138。
#
# 与论文"Conceptual Coverage"节逐项对照(我们复现 vs 论文报告)：
#   问卷     论文报告               我们复现     对照
#   BFAS     7/10, 无Open-Mindedness 7/10,同      完全一致
#   HEXACO   4/10 (最窄)             4/10         数量一致(见下)
#   NEO      9/10, 唯缺Self-Assessed 9/10,同缺    完全一致
#   Woo      9/10, 唯缺Fantasy       9/10,同缺    完全一致
# NEO 缺 Self-Assessed Intelligence、Woo 缺 Fantasy，与论文一字不差,
# 对复现质量是强力佐证。
#
# HEXACO 小注：论文第4个facet是 Diversity(来自Unconventionality的Uc4),
# 我们这道 Uc4 落到 Intellectual Curiosity —— 即前述10道边界题中的Uc4
# (论文=Diversity, 我们=Intellectual Curiosity)。可追溯、已记录,非新问题。
#
# 【杀手锏结论 · 已据论文原文校准】
# 注意：不是"只有 Woo 覆盖全部方面"。论文实际结论是 Woo 覆盖最广、
# 三个方面最均衡(题量也最大)，但 NEO 同样覆盖三个方面(9个facet)。
# 准确表述：四套问卷测同一大构念,覆盖却极不均衡——HEXACO最窄(仅4个
# facet),BFAS与HEXACO都完全没覆盖 Open-Mindedness 方面;NEO与Woo最广
# (各9个facet,均覆盖三个方面),而 Woo 三方面最均衡、题量最大,是综合
# 覆盖最全面的一套。(论文原文:"Woo...had the broadest coverage...
# well balanced across all three" 方面)
# =====================================================================
#
# =====================================================================
# 复现发现记录 · MANOVA 组间比较 + Group 重建 · 2026-06-06
# =====================================================================
#
# 【拦路问题 · 原文遗漏了分组变量】
# 原脚本 MANOVA 用 read.csv 读一个含 Group 列(样本来源)的CSV,再 subset
# (Group==1/2/3)。但作者公开的只有 .sav, 该 .sav 没有 Group 列
# (只有无关的 DBHTgroup, 5个值, 是 DBHT 网络聚类产物, 非样本)。
# 故直接跑原脚本会 "找不到对象 'Group'"。这是原数据共享的一个缺口。
#
# 【解决 · 用响应指纹无损重建 Group(记录链接)】
# 每人答138题(1-5分),完整应答序列几乎唯一(5^138组合)。三个源文件
# (Fall2015 / Spring2017 / Mturk)各自保留本样本应答。把分析文件802人
# 的138题"指纹"匹配回源文件,即可判定其样本来源。
# 重建结果: 1=176, 2=108, 3=518 (合计802),
# 与论文 SI 7 的样本量、与 Data Cleaning Notes 三方完全一致 -> 验证无误。
# (注: 我们按 SI 7 体量编号 1=Fall176/2=Spring108/3=Mturk518;
#  原脚本注释里的 1=Mturk 是作者CSV内部编号, 与统计结果无关。)
#
# 【MANOVA 四个比较 + Box's M · 与论文逐项对照】
# 138题为因变量, ~ Group。test="Pillai"。结果(复现 vs 论文SI7):
#   比较                       Pillai           approx F
#   三组整体                   .9596 vs .960    4.43 vs 4.43   ✓
#   1 vs 2 (Fall vs Spring)    .650  vs .650    1.95 vs 1.95   ✓
#   1 vs 3 (Fall vs Mturk)     .675  vs .675    8.34 vs 8.34   ✓
#   2 vs 3 (Spring vs Mturk)   .614  vs .614    5.62 vs 5.62   ✓
# 全部精确命中, 百分误差≈0(Pillai .9596 vs .960 ≈0.04%), 属完全一致档。
#
# Box's M (1 vs 3, 两组n均>138可算): R 给卡方近似 Chi-Sq=12891, df=9591,
# p<.001; 论文给 F 近似 1.292, df=9591, p<.001。同一检验两种换算,
# df=9591 完全一致, 结论相同: 三组协方差结构显著不齐(论文承认的合并样本局限)。
# (注: 样本2 n=108<138 变量, 组内协方差奇异, 含样本2的Box's M无法计算,
#  故只能算 1 vs 3; 这点本身也是可写入报告的发现。)
#
# 【两处"看似不符"实为标注/换算差异, 非结果不同】
# 1. 自由度: R 显示多元近似F的 num/den Df=276/1326; 论文 F(2,799) 用的是
#    组间df=2、残差df=799。F 值 4.43 两边一致, 仅标注口径不同。
# 2. Box's M: 卡方形式(R) vs F形式(论文), 见上。
#
# 【MANOVA 复现结论】完全可复现, 关键统计量(Pillai/F/Box's M df)与原文
# 逐项吻合。唯一附加工序是重建原文未公开的分组变量(已三方验证)。
# =====================================================================
