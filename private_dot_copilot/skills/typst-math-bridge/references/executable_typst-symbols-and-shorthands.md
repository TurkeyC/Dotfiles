# Typst 符号体系与 Shorthand（面向 LaTeX 迁移）

> 关键澄清：`math` 的 19 个 Definitions 是“公式函数模块”；`sym` 才是“海量命名符号库”。

## 1. 权威来源与优先级

1. 官方总览：`https://typst.app/docs/reference/symbols/`
2. 官方符号库：`https://typst.app/docs/reference/symbols/sym/`
3. 官方 symbol 语义：`https://typst.app/docs/reference/foundations/symbol/`
4. LaTeX 对照速查：`https://qwinsi.github.io/tex2typst-webapp/cheat-sheet.html`

本 skill 内已内置全量索引文件：
- `references/sym-full-index.txt`
- 规范格式：每行一个 symbol 名称（UTF-8 文本），便于 agent 检索、去重与自动比对。

规则：迁移任务中，先看官方，再看第三方对照表。

## 2. 你必须知道的核心机制

### 2.1 `sym` 与数学模式

- 普通文本中：`#sym.arrow.r`
- 数学模式中：可直接写 `$arrow.r$`
- 一些符号支持 shorthand：`$->$`、`$=>$`、`$<=>$`

### 2.2 点修饰符（variant）

- 符号通过点链表达变体：如 `arrow.r.double.long`。
- 典型族：`arrow.*`、`subset.*`、`eq.*`、`gt.*`、`lt.*`、`integral.*`。

### 2.3 `dif` / `Dif`

- `dif` / `Dif` 在 math 中是特殊定义（不仅是字符，还影响间距和样式）。
- 积分中建议 `integral ... dif x` 而不是手写 `d x`。

## 3. 符号域迁移策略

按域批量迁移，避免逐条硬背。

1. Greek：`alpha beta Gamma Delta ...`
2. Arrows：`arrow.r`、`arrow.l.r.double.long`、`harpoon.*`
3. Relations：`eq.not`、`lt.eq`、`gt.eq.not`、`equiv`
4. Sets & logic：`in`、`subset.eq`、`forall`、`exists.not`、`and`、`or`
5. Operators：`sum`、`product`、`integral`、`integral.double`、`partial`
6. Delimiters：`paren.*`, `bracket.*`, `brace.*`, `chevron.*`

## 4. 常见 LaTeX → Typst 速查（代表性）

| LaTeX | Typst |
|---|---|
| `\\alpha` | `alpha` |
| `\\varepsilon` | `epsilon` |
| `\\phi` | `phi.alt` |
| `\\varphi` | `phi` |
| `\\to` / `\\rightarrow` | `arrow.r` 或 `->` |
| `\\Rightarrow` | `arrow.r.double` 或 `=>` |
| `\\Longleftrightarrow` | `arrow.l.r.double.long` |
| `\\in` | `in` |
| `\\notin` | `in.not` |
| `\\subseteq` | `subset.eq` |
| `\\nsubseteq` | `subset.eq.not` |
| `\\leq` | `lt.eq` 或 `<=` |
| `\\geq` | `gt.eq` 或 `>=` |
| `\\neq` | `eq.not` 或 `!=` |
| `\\sum` | `sum` |
| `\\prod` | `product` |
| `\\int` | `integral` |
| `\\iint` | `integral.double` |
| `\\iiint` | `integral.triple` |
| `\\oint` | `integral.cont` |

> 上表是“高频代表”；完整集合应以 `sym` 官方页实时查询为准。

## 5. 符号密集任务的执行模板

1. 抽取输入中的 LaTeX 宏（尤其 `\\...` 符号宏）。
2. 分组映射到 Typst 符号域。
3. 先给 `sym` 命名版，再补 shorthand（如存在）。
4. 对无一对一映射项，标注“近似替代 + 原因”。
5. 最后返回一份“可直接粘贴”的 Typst 公式。

## 6. 防过时与质量控制

- 每次声称“完整覆盖”前，先检查 `symbols/sym` 页面是否新增命名项。
- 第三方对照（如 tex2typst cheat sheet）可用于补充迁移经验，但冲突时以官方为准。
- 不要在未核验时使用“全部/完全”等绝对措辞。

## 7. 全量索引使用约束

1. “全量符号”任务必须读取 `references/sym-full-index.txt`。
2. 输出映射表时，若用户要求完整，需以该索引为全集，不得仅输出常见子集。
3. 若发现官网新增符号，先更新索引文件再给出最终回答。
