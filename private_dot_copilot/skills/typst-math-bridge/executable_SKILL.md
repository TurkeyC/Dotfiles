---
name: typst-math-bridge
description: 全面指导 Typst 数学公式编写与 LaTeX 迁移对照。只要用户提到 Typst 公式、数学排版、LaTeX 转 Typst、公式报错修复、矩阵/分段/多行对齐/符号写法，就应优先使用本技能，即使用户没有明确说“用 skill”。
---

# Typst Math Bridge

用于让 AI agent 在 Typst 数学公式场景中“写得对、改得稳、解释得清”，并且覆盖**函数语法 + 符号体系（sym/shorthand/variant）**。

## 版本锚点与时效性

- 本技能以 Typst 官方文档 `0.14.2` 时代的 `Math` 与 `Symbols` 为基线。
- 若用户显式提到“新版本/最新版/刚更新”，不要直接沿用旧结论，先执行“漂移检查流程”。

### 漂移检查流程（必须）

1. 检查官网 `https://typst.app/docs/changelog/` 的最新版本号。
2. 检查 `https://typst.app/docs/reference/math/` 的 Definitions 列表。
3. 检查 `https://typst.app/docs/reference/symbols/sym/` 与 `https://typst.app/docs/reference/symbols/`。
4. 将官网列表与本地覆盖列表比对：
   - 若一致：继续回答，并声明“基于当前官网清单已对齐”。
   - 若不一致：先告知差异项，再临时按官网新增项补充规则。

## 你要解决的问题

用户常见需求：
- 把 LaTeX 公式迁移到 Typst。
- 在 `.typ` 文档中新增或修复公式。
- 对齐多行推导、矩阵、分段函数、上下标与定界符。
- 把大量 LaTeX 符号（箭头/关系/集合/逻辑/积分/希腊字母）迁移为 Typst 符号命名。
- 避免 Typst/LaTeX 语法混用导致编译错误。

## 先做什么（强制顺序）

1. 判断用户目标是：新写公式 / LaTeX 迁移 / 修错 / 讲解。
2. 读取本技能参考：
   - `references/typst-vs-latex-math.md`（完整对照）
   - `references/typst-math-checklist.md`（快速检查）
   - `references/typst-symbols-and-shorthands.md`（符号体系与速查）
   - `references/sym-full-index.txt`（官方 `sym` 页面自动提取的全量符号索引）
3. 输出前执行一次“语法自检”，重点检查：
   - 是否误用了 `\\begin`、`\\frac`、`\\left` 等 LaTeX 命令。
   - 是否正确使用 `$...$`（行内）与 `$ ... $`（块级）。
   - 是否在 Typst 数学调用里正确使用 `,` 与 `;`。
   - 符号是否优先采用官方 `sym` 命名或合法 shorthand，而不是硬写 LaTeX 宏。
4. 若本次任务涉及“最新版确认”，先输出当前能力边界：
   - 已覆盖到的官方版本；
   - 是否检测到新增/变更 API。

## 核心规则（必须遵守）

1. **禁止直接输出 LaTeX 环境语法**
   - 不要写 `\\begin{align}`、`\\end{matrix}`、`\\text{}`、`\\left`/`\\right`。
   - 使用 Typst 对应方式：`$...$`、`mat(...)`、`"文本"`、自动定界符缩放或 `lr(...)`。

2. **公式模式规则**
   - 行内公式：`$x^2$`
   - 块级公式：`$ x^2 $`（首尾留空白）

3. **多字符文本/变量规则**
   - 数学中多字符说明文字用双引号：`$ x "if" x > 0 $`
   - 单字母变量直接写；如需代码值插入，用 `#`：`$ #x < 10 $`

4. **分式、根式、上下标优先 Typst 原生写法**
   - 分式：`(a+b)/c` 或 `frac(a+b, c)`
   - 根式：`sqrt(x)`、`root(3, x)`
   - 上下标：`x_i^2`，多项下标用括号：`x_(a -> b)`

5. **矩阵/分段参数分隔规则**
   - `mat`：列用 `,`，行用 `;`
   - `cases`：每个分支用 `,` 分隔，可用 `&` 做分支内对齐

6. **定界符规则**
   - Typst 默认会自动缩放匹配定界符。
   - 要阻止缩放，用转义：`\(` `\)` `\{` `\}`。
   - 需要手动控制时用 `lr(...)`。

7. **多行与对齐规则**
   - 用 `\\` 换行、`&` 对齐。
   - 多个 `&` 会形成交替左右对齐列。

8. **可访问性规则（关键公式建议）**
   - 对核心块级公式优先使用 `#math.equation(alt: "...", block: true, $ ... $)`。

9. **符号系统规则（新增）**
   - 明确区分：`Math Definitions` 是函数模块；`sym` 是海量命名符号库。
   - 当用户要求“全量符号/完整映射”时，必须以 `references/sym-full-index.txt` 为基准，不可只列常见子集。
   - 在数学模式下优先用符号名（如 `arrow.r.double.long`、`subset.eq.not`）或 shorthand（如 `=>`, `<=>`, `->`）。
   - 需要变体时使用点修饰符链（modifier 顺序不敏感，以官方 `symbol` 规则为准）。
   - 无对应命名符号时可退回 Unicode 直输，并说明兼容性。

## 推荐工作流

### A. LaTeX → Typst 迁移
1. 先识别 LaTeX 构造类型（align/matrix/cases/frac/sqrt/op/left-right/symbol macro）。
2. 用对照表替换为 Typst 构造。
3. 清除残留反斜杠命令。
4. 给出“迁移后 Typst 版 + 关键差异解释”。

### B. Typst 公式修错
1. 定位报错附近公式。
2. 先查 3 类高频错误：
   - `$` 边界与块级空白；
   - `#` 用错上下文；
   - `mat/cases` 的分隔符（`,`/`;`）。
3. 用最小改动修复，并说明改动原因。

### C. 新建公式
1. 先选结构（分式/矩阵/分段/多行推导）。
2. 优先原生简洁语法，再考虑函数形式。
3. 提供可复制片段，必要时附一行行内与一行块级版本。

### D. 符号密集迁移（新增）
1. 先按符号域分组：Greek / Arrow / Relation / Set / Logic / Operator。
2. 对每组优先给 `sym` 命名（可附 shorthand）。
3. 对不存在的一对一映射，给出最接近替代并显式标注“近似替代”。

## 输出模板

默认按以下结构回复（可精简但不要缺关键内容）：

1. `Typst 结果`：直接可用的公式/代码片段。
2. `LaTeX 对照`：仅在用户关心迁移时提供。
3. `关键差异`：列 2-4 条最容易踩坑点。
4. `可选增强`：编号、alt 文本、样式统一（如有必要）。

## 高风险误区（必须回避）

- 把 Typst 当 LaTeX 方言，继续输出 `\\...` 命令。
- 在代码上下文中滥用 `#`，或在需要代码值插入时漏掉 `#`。
- 错把 Typst 的 `()` 分组与可见圆括号混为一谈（分式中会影响显示）。
- 把 `mat` 行列分隔写反。
- 忽略 `sym` 命名与修饰符体系，只给少量“常见符号”映射。

## 参考资料

- 主对照：`references/typst-vs-latex-math.md`
- 快速清单：`references/typst-math-checklist.md`
- 符号专章：`references/typst-symbols-and-shorthands.md`
- 全量索引：`references/sym-full-index.txt`（当前提取规模约 1158 项）
