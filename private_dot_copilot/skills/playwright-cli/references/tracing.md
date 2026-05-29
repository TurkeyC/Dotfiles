# Tracing（链路追踪）

采集详细执行追踪用于调试与分析。追踪包含 DOM 快照、截图、网络活动与控制台日志。

## 安全警告

追踪产物可能包含敏感数据（cookies、认证头、请求/响应体、页面内容）。
仅在调试确有必要时开启 tracing，并尽量缩短保留周期。

## 基础用法

```bash
# 开始录制 trace
playwright-cli tracing-start

# 执行动作
playwright-cli open https://example.com
playwright-cli click e1
playwright-cli fill e2 "test"

# 停止录制 trace
playwright-cli tracing-stop

# 将输出移动/重命名到规范化产物路径
# .playwright-cli/artifacts/<YYYYMMDD>/<session>/<YYYYMMDD-HHMMSS>-<session>-trace.zip
```

## Trace 输出文件

开始 tracing 后，Playwright 会创建 `traces/` 目录并生成多个文件：

### `trace-{timestamp}.trace`

**动作日志** - 主 trace 文件，包含：
- 每个执行动作（click、fill、navigation）
- 每个动作前后的 DOM 快照
- 每一步截图
- 时间信息
- 控制台消息
- 源码位置

### `trace-{timestamp}.network`

**网络日志** - 完整网络活动：
- 全部 HTTP 请求与响应
- 请求头与请求体
- 响应头与响应体
- 时序信息（DNS、connect、TLS、TTFB、download）
- 资源体积
- 失败请求与错误

### `resources/`

**资源目录** - 缓存资源：
- 图片、字体、样式、脚本
- 用于回放的响应体
- 重建页面状态所需资源

## Trace 会捕获什么

| 类别 | 详情 |
|------|------|
| **Actions（动作）** | 点击、填充、悬停、键盘输入、导航 |
| **DOM** | 每步动作前后的完整 DOM 快照 |
| **Screenshots（截图）** | 每一步的视觉状态 |
| **Network（网络）** | 所有请求、响应、头、体、时序 |
| **Console（控制台）** | 全部 console.log / warn / error |
| **Timing（时序）** | 每个操作的精确耗时 |

## 使用场景

### 调试失败动作

```bash
playwright-cli tracing-start
playwright-cli open https://app.example.com

# 这次点击失败了，为什么？
playwright-cli click e5

playwright-cli tracing-stop
# 打开 trace 查看点击发生时的 DOM 状态
```

### 分析性能

```bash
playwright-cli tracing-start
playwright-cli open https://slow-site.com
playwright-cli tracing-stop

# 查看网络瀑布图定位慢资源
```

### 采集证据

```bash
# 为文档记录完整用户流程
playwright-cli tracing-start

playwright-cli open https://app.example.com/checkout
playwright-cli fill e1 "4111111111111111"
playwright-cli fill e2 "12/25"
playwright-cli fill e3 "123"
playwright-cli click e4

playwright-cli tracing-stop
# Trace 可还原完整事件序列
```

## Trace vs Video vs Screenshot

| 特性 | Trace | Video | Screenshot |
|------|-------|-------|------------|
| **格式** | `.trace` 文件 | `.webm` 视频 | `.png/.jpeg` 图片 |
| **DOM 检查** | 支持 | 不支持 | 不支持 |
| **网络细节** | 支持 | 不支持 | 不支持 |
| **逐步回放** | 支持 | 连续回放 | 单帧 |
| **文件体积** | 中等 | 较大 | 较小 |
| **最适场景** | 调试 | 演示 | 快速取证 |

## 最佳实践

### 1. 在问题出现前就开始追踪

```bash
# 覆盖完整流程，而不只失败步骤
playwright-cli tracing-start
playwright-cli open https://example.com
# ... 导致问题的全部步骤 ...
playwright-cli tracing-stop
```

### 2. 清理旧 trace

Trace 可能占用大量磁盘空间：

```bash
# 删除 7 天前的 traces
find .playwright-cli/traces -mtime +7 -delete

# 敏感任务建议在规范化产物目录中当天清理
find .playwright-cli/artifacts -type f -name "*trace*" -mtime +0 -delete
```

## 限制

- Trace 会给自动化执行带来额外开销
- 大型 trace 会占用较多磁盘空间
- 某些动态内容可能无法完全回放
