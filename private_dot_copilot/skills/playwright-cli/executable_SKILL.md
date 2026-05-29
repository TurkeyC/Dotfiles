---
name: playwright-cli
description: 自动化浏览器交互、测试网页并处理 Playwright 测试任务。
allowed-tools: Bash(playwright-cli:*)
---

# 使用 playwright-cli 进行浏览器自动化

## 强制安全护栏

对每个任务默认应用以下规则：

1. **优先使用最安全模式**
	- 默认使用内存会话。
	- 除非用户明确要求持久化，否则不要使用 `--persistent` 或 `--profile`。
2. **将密钥视为高危敏感数据**
	- 在命令/示例中不要输入真实账号凭据、API Key 或 Token。
	- 使用占位符，例如 `<EMAIL>`、`<PASSWORD>`、`<TOKEN>`。
3. **最小化代码执行面**
	- 优先使用内置命令（`click`、`fill`、`route`、`snapshot`），而不是 `run-code` 和 `eval`。
	- 仅在原生命令无法完成任务时才使用 `run-code`。
4. **禁止未授权数据外传**
	- 不要将抓取的页面数据、cookie、存储状态或 trace 载荷发送到第三方端点。
5. **任务结束必须清理**
	- 关闭会话，并删除仅为当前任务生成的临时产物。

## 产物策略（默认最小化）

仅在流程确实需要或用户明确要求时生成文件。

- 临时查看优先使用不带 `--filename` 的 `snapshot`。
- 除非调试需要，否则不要录制 video/trace。
- 需要长期保留的产物统一保存到规范化根目录：

```bash
.playwright-cli/artifacts/<YYYYMMDD>/<session>/
```

- 文件名统一采用规范格式：

```bash
<YYYYMMDD-HHMMSS>-<session>-<purpose>.<ext>
```

示例：
- `20260330-141530-default-login-trace.zip`
- `20260330-141612-auth-state.json`
- `20260330-141700-checkout-video.webm`

完整策略与清理规则见：[references/artifact-governance.md](references/artifact-governance.md)

## 快速开始

```bash
# 打开新的浏览器
playwright-cli open
# 导航到目标页面
playwright-cli goto https://playwright.dev
# 使用 snapshot 中的 ref 与页面交互
playwright-cli click e15
playwright-cli type "page.click"
playwright-cli press Enter
# 截图（较少使用，通常 snapshot 更常见）
playwright-cli screenshot
# 关闭浏览器
playwright-cli close
```

## 命令

### 核心

```bash
playwright-cli open
# open and navigate right away
playwright-cli open https://example.com/
playwright-cli goto https://playwright.dev
playwright-cli type "search query"
playwright-cli click e3
playwright-cli dblclick e7
playwright-cli fill e5 "user@example.com"
playwright-cli drag e2 e8
playwright-cli hover e4
playwright-cli select e9 "option-value"
playwright-cli upload ./document.pdf
playwright-cli check e12
playwright-cli uncheck e12
playwright-cli snapshot
playwright-cli snapshot --filename=after-click.yaml
playwright-cli eval "document.title"
playwright-cli eval "el => el.textContent" e5
playwright-cli dialog-accept
playwright-cli dialog-accept "confirmation text"
playwright-cli dialog-dismiss
playwright-cli resize 1920 1080
playwright-cli close
```

### 导航

```bash
playwright-cli go-back
playwright-cli go-forward
playwright-cli reload
```

### 键盘

```bash
playwright-cli press Enter
playwright-cli press ArrowDown
playwright-cli keydown Shift
playwright-cli keyup Shift
```

### 鼠标

```bash
playwright-cli mousemove 150 300
playwright-cli mousedown
playwright-cli mousedown right
playwright-cli mouseup
playwright-cli mouseup right
playwright-cli mousewheel 0 100
```

### 保存为

```bash
playwright-cli screenshot
playwright-cli screenshot e5
playwright-cli screenshot --filename=page.png
playwright-cli pdf --filename=page.pdf
```

### 标签页

```bash
playwright-cli tab-list
playwright-cli tab-new
playwright-cli tab-new https://example.com/page
playwright-cli tab-close
playwright-cli tab-close 2
playwright-cli tab-select 0
```

### 存储

```bash
playwright-cli state-save
playwright-cli state-save auth.json
playwright-cli state-load auth.json

# Cookie
playwright-cli cookie-list
playwright-cli cookie-list --domain=example.com
playwright-cli cookie-get session_id
playwright-cli cookie-set session_id abc123
playwright-cli cookie-set session_id abc123 --domain=example.com --httpOnly --secure
playwright-cli cookie-delete session_id
playwright-cli cookie-clear

# LocalStorage
playwright-cli localstorage-list
playwright-cli localstorage-get theme
playwright-cli localstorage-set theme dark
playwright-cli localstorage-delete theme
playwright-cli localstorage-clear

# SessionStorage
playwright-cli sessionstorage-list
playwright-cli sessionstorage-get step
playwright-cli sessionstorage-set step 3
playwright-cli sessionstorage-delete step
playwright-cli sessionstorage-clear
```

### 网络

```bash
playwright-cli route "**/*.jpg" --status=404
playwright-cli route "https://api.example.com/**" --body='{"mock": true}'
playwright-cli route-list
playwright-cli unroute "**/*.jpg"
playwright-cli unroute
```

### 开发者工具

```bash
playwright-cli console
playwright-cli console warning
playwright-cli network
playwright-cli run-code "async page => await page.context().grantPermissions(['geolocation'])"
playwright-cli tracing-start
playwright-cli tracing-stop
playwright-cli video-start
playwright-cli video-stop video.webm
```

## open 参数
```bash
# 创建会话时指定浏览器
playwright-cli open --browser=chrome
playwright-cli open --browser=firefox
playwright-cli open --browser=webkit
playwright-cli open --browser=msedge
# 通过扩展连接浏览器
playwright-cli open --extension

# 使用持久化 profile（默认是内存 profile）
playwright-cli open --persistent
# 使用自定义目录的持久化 profile
playwright-cli open --profile=/path/to/profile

# 使用配置文件启动
playwright-cli open --config=my-config.json

# 关闭浏览器
playwright-cli close
# 删除默认会话的用户数据
playwright-cli delete-data
```

## 快照

每次命令执行后，playwright-cli 都会提供当前浏览器状态快照。

```bash
> playwright-cli goto https://example.com
### Page
- Page URL: https://example.com/
- Page Title: Example Domain
### Snapshot
[Snapshot](.playwright-cli/page-2026-02-14T19-22-42-679Z.yml)
```

你也可以按需执行 `playwright-cli snapshot` 生成快照。

如果不提供 `--filename`，会按时间戳自动创建新快照文件。默认建议自动命名，仅当该产物需要作为工作流结果保留时再使用 `--filename=`。

## 元素定位

默认使用 snapshot 中的 ref 与页面元素交互。

```bash
# 获取带 ref 的 snapshot
playwright-cli snapshot

# 使用 ref 进行交互
playwright-cli click e15
```

你也可以使用 CSS 或 role 选择器（例如在用户明确要求时）。

```bash
# CSS 选择器
playwright-cli click "#main > button.submit"

# role 选择器
playwright-cli click "role=button[name=Submit]"

# 组合 CSS 与 role 选择器
playwright-cli click "#footer >> role=button[name=Submit]"
```

## 浏览器会话

```bash
# 创建名为 "mysession" 的新浏览器会话，并启用持久化 profile
playwright-cli -s=mysession open example.com --persistent
# 同样支持手动指定 profile 目录（仅在明确要求时使用）
playwright-cli -s=mysession open example.com --profile=/path/to/profile
playwright-cli -s=mysession click e6
playwright-cli -s=mysession close  # 停止指定会话浏览器
playwright-cli -s=mysession delete-data  # 删除该持久化会话的用户数据

playwright-cli list
# 关闭所有浏览器
playwright-cli close-all
# 强制结束所有浏览器进程
playwright-cli kill-all
```

## 安装

该 skill 以“加固模式 + 最小工具权限”运行，预期系统已预装全局 `playwright-cli` 可执行文件。

```bash
playwright-cli --version
```

如果缺少 `playwright-cli`，请在本 skill 执行范围外完成安装/升级。

```bash
npm install -g @playwright/cli@X.Y.Z
```

请固定为受控批准版本（`X.Y.Z`），在受控环境中避免使用 `latest`。

## 示例：表单提交

```bash
playwright-cli open https://example.com/form
playwright-cli snapshot

playwright-cli fill e1 "user@example.com"
playwright-cli fill e2 "password123"
playwright-cli click e3
playwright-cli snapshot
playwright-cli close
```

## 示例：多标签页流程

```bash
playwright-cli open https://example.com
playwright-cli tab-new https://example.com/other
playwright-cli tab-list
playwright-cli tab-select 0
playwright-cli snapshot
playwright-cli close
```

## 示例：使用开发者工具调试

```bash
playwright-cli open https://example.com
playwright-cli click e4
playwright-cli fill e7 "test"
playwright-cli console
playwright-cli network
playwright-cli close
```

```bash
playwright-cli open https://example.com
playwright-cli tracing-start
playwright-cli click e4
playwright-cli fill e7 "test"
playwright-cli tracing-stop
playwright-cli close
```

## 专项任务

* **运行与调试 Playwright 测试** [references/playwright-tests.md](references/playwright-tests.md)
* **请求 Mock** [references/request-mocking.md](references/request-mocking.md)
* **运行 Playwright 代码** [references/running-code.md](references/running-code.md)
* **浏览器会话管理** [references/session-management.md](references/session-management.md)
* **存储状态（cookies、localStorage）** [references/storage-state.md](references/storage-state.md)
* **测试代码生成** [references/test-generation.md](references/test-generation.md)
* **Tracing（链路追踪）** [references/tracing.md](references/tracing.md)
* **视频录制** [references/video-recording.md](references/video-recording.md)
* **产物治理（最小化 + 规范化）** [references/artifact-governance.md](references/artifact-governance.md)
