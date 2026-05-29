# Typst 数学公式全量对照（面向 LaTeX 用户）

基于 Typst 官方 math 模块与 `for-latex-users` 指南整理。

## 文档时效声明

- 本文档对应官方参考页可见的 `Math` Definitions 清单（19 项）。
- 本文档的“19 项”仅指公式函数模块，不代表符号总量。
- 符号总量请参考官方 `sym` 页面（远超函数模块数量）：`https://typst.app/docs/reference/symbols/sym/`。
- 最近一次核对：Typst changelog 顶部版本为 `0.14.2`，且 `reference/math` 定义项与本文一致。
- 若后续 Typst 新增数学 API，请优先更新本节“总览”与对应映射条目。

符号迁移请配合：`references/typst-symbols-and-shorthands.md`。

## 0. 总览

Typst math 核心模块（19 项）：
- `accent`, `attach`, `binom`, `cancel`, `cases`, `class`, `equation`, `frac`, `lr`, `mat`, `op`, `primes`, `roots`, `sizes`, `stretch`, `styles`, `underover`, `variants`, `vec`

## 1. 语法模式与基础差异

| 场景 | LaTeX | Typst | 说明 |
|---|---|---|---|
| 行内公式 | `$x^2$` | `$x^2$` | 相同 |
| 块级公式 | `\[ x^2 \]` 或 `equation` | `$ x^2 $` | Typst 通过 `$` 内首尾空白判定块级 |
| 多字符文本 | `\text{if}` | `"if"` | Typst 数学模式中用双引号 |
| 插入代码值 | `\text{}` 或宏 | `$ #x < 10 $` | Typst 用 `#` 引入代码表达式 |

## 2. 分式与根式

| 目标 | LaTeX | Typst（推荐） | 备注 |
|---|---|---|---|
| 分式 | `\frac{a+b}{c}` | `(a+b)/c` 或 `frac(a+b, c)` | Typst 可直接 `/` 生成分式 |
| 行内斜分式风格 | `\tfrac` 等 | `#set math.frac(style: "skewed")` | `style` 支持 `vertical/skewed/horizontal` |
| 平方根 | `\sqrt{x}` | `sqrt(x)` | |
| n 次根 | `\sqrt[3]{x}` | `root(3, x)` | |

## 3. 上下标、极限、连写撇号

| 目标 | LaTeX | Typst | 备注 |
|---|---|---|---|
| 上标/下标 | `x_i^2` | `x_i^2` | 基本一致 |
| 多项下标 | `x_{a\to b}` | `x_(a -> b)` | Typst 用 `()` 包组 |
| 强制 scripts | `\nolimits` 等 | `scripts(sum)_1^2` | |
| 强制 limits | `\limits` | `limits(A)_1^2` | |
| 连续撇号 | `f'''` | `f'''` 或 `primes(3)` | Typst 自动分组撇号 |

## 4. 矩阵、向量、分段

| 目标 | LaTeX | Typst | 备注 |
|---|---|---|---|
| 矩阵 | `\begin{bmatrix}...\end{bmatrix}` | `mat(...; ...)` | 列 `,`；行 `;` |
| 矩阵定界符 | `pmatrix/bmatrix` | `mat(delim: "[", ...)` | 单字符可自动推断另一侧 |
| 增广矩阵 | `array` + 竖线 | `mat(augment: #2, ...)` | 支持 `hline/vline/stroke` |
| 列向量 | `\begin{pmatrix}a\\b\end{pmatrix}` | `vec(a, b)` | 向量分量容器 |
| 分段函数 | `\begin{cases}...\end{cases}` | `cases(...)` | 分支用 `,`；可用 `&` 对齐 |

## 5. 定界符（括号、范数、取整）

| 目标 | LaTeX | Typst | 备注 |
|---|---|---|---|
| 自动缩放括号 | `\left( ... \right)` | 直接写匹配括号 | Typst 默认自动缩放 |
| 手动控制缩放 | `\left/\right` + trick | `lr(..., size: #120%)` | 可精确控制尺寸 |
| 中间分隔符 | `\middle|` | `mid(|)` | 与最近 `lr` 组联动 |
| 绝对值/范数 | `\lvert x\rvert`, `\lVert x\rVert` | `abs(x)`, `norm(x)` | |
| 下取整/上取整 | `\lfloor x\rfloor`, `\lceil x\rceil` | `floor(x)`, `ceil(x)` | |

## 6. 对齐与多行推导

| 目标 | LaTeX | Typst | 备注 |
|---|---|---|---|
| 多行对齐 | `align` 环境 + `&` + `\\` | 在一个块级 `$ ... $` 中用 `&` 和 `\\` | Typst 不需要 `align` 环境 |
| 注释列 | `&& \text{...}` | `&& "..."` | 多个 `&` 形成交替左右对齐列 |

示例：

```typst
$ (3x + y) / 7 &= 9 && "given" \
  3x + y &= 63 & "multiply by 7" \
  x &= 21 - y/3 & "divide by 3" $
```

## 7. 算子、重音、上下包围、划消

| 目标 | LaTeX | Typst | 备注 |
|---|---|---|---|
| 文本算子 | `\operatorname{foo}` | `op("foo")` | 预置了 `sin, cos, lim, max...` |
| 重音 | `\hat{x}`, `\vec{x}` | `hat(x)` / `accent(x, hat)` / `arrow(x)` | |
| 上下横线 | `\overline{x}` | `overline(x)` / `underline(x)` | |
| 上下大括号注释 | `\overbrace{x}^{...}` | `overbrace(x, ... )` / `underbrace(x, ...)` | |
| 划消 | `\cancel{x}` | `cancel(x)` | 支持 `cross` / `angle` / `stroke` |

## 8. 字体变体与数学样式

| 目标 | LaTeX | Typst | 备注 |
|---|---|---|---|
| 黑板粗体 | `\mathbb{R}` | `bb(R)` 或 `RR` | |
| 花体 | `\mathcal{L}` | `cal(L)` | |
| 手写体 | `\mathscr{L}` | `scr(L)` | 依赖字体支持 |
| 哥特体 | `\mathfrak{g}` | `frak(g)` | |
| 无衬线/等宽 | `\mathsf`, `\mathtt` | `sans(...)`, `mono(...)` | |
| 粗体/正体/斜体 | `\mathbf`, `\mathrm`, `\mathit` | `bold(...)`, `upright(...)`, `italic(...)` | |

## 9. 尺寸与布局强制

| 目标 | LaTeX | Typst | 备注 |
|---|---|---|---|
| 强制 displaystyle | `\displaystyle` | `display(...)` | |
| 强制 textstyle | `\textstyle` | `inline(...)` | |
| 强制 scriptstyle | `\scriptstyle` | `script(...)` | |
| 二级脚本尺寸 | `\scriptscriptstyle` | `sscript(...)` | |

## 10. 典型迁移模板

### 10.1 align 环境迁移

LaTeX:
```latex
\begin{align}
a+b &= c \\
d+e &= f
\end{align}
```

Typst:
```typst
$ a+b &= c \
  d+e &= f $
```

### 10.2 matrix 环境迁移

LaTeX:
```latex
\begin{bmatrix}
1 & 2 \\
3 & 4
\end{bmatrix}
```

Typst:
```typst
$ mat(delim: "[", 1, 2; 3, 4) $
```

### 10.3 cases 环境迁移

LaTeX:
```latex
f(x)=\begin{cases}
1, & x>0 \\
0, & x\le 0
\end{cases}
```

Typst:
```typst
$ f(x) = cases(
  1 & "if" x > 0,
  0 & "if" x <= 0,
) $
```

## 11. 高频错误与修复

1. **残留 LaTeX 命令**
   - 错：`$ \frac{a}{b} $`
   - 对：`$ frac(a, b) $` 或 `$ a/b $`

2. **把 `\left`/`\right` 生搬硬套**
   - Typst 默认自动缩放，通常不需要。

3. **忘记 `mat` 的 `;` 是换行**
   - 错：`mat(1,2,3,4)`（只有一行）
   - 对：`mat(1,2;3,4)`

4. **多字符文本未加引号**
   - 错：`$ x if x > 0 $`
   - 对：`$ x "if" x > 0 $`

5. **块级公式没写成块级**
   - 需要首尾空白：`$ ... $`（内部首尾有空白）
