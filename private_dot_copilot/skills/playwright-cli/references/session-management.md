# 浏览器会话管理

并发运行多个彼此隔离的浏览器会话，并支持状态持久化。

默认遵循“安全优先”：
- 优先使用内存会话。
- 仅在明确需要时使用 `--persistent` / `--profile`。
- 任务结束后删除陈旧会话数据。

## 命名浏览器会话

使用 `-s` 参数隔离浏览器上下文：

```bash
# 浏览器 1：认证流程
playwright-cli -s=auth open https://app.example.com/login

# 浏览器 2：公共浏览（独立 cookies、存储）
playwright-cli -s=public open https://example.com

# 命令按会话隔离
playwright-cli -s=auth fill e1 "user@example.com"
playwright-cli -s=public snapshot
```

## 浏览器会话隔离属性

每个浏览器会话彼此独立：
- Cookies
- LocalStorage / SessionStorage
- IndexedDB
- Cache
- 浏览历史
- 打开的标签页

## 浏览器会话命令

```bash
# 列出所有浏览器会话
playwright-cli list

# 停止某个浏览器会话（关闭浏览器）
playwright-cli close                # 停止默认会话浏览器
playwright-cli -s=mysession close   # 停止命名会话浏览器

# 停止所有浏览器会话
playwright-cli close-all

# 强制终止所有守护进程（处理僵尸/卡死进程）
playwright-cli kill-all

# 删除浏览器会话用户数据（profile 目录）
playwright-cli delete-data                # 删除默认会话数据
playwright-cli -s=mysession delete-data   # 删除命名会话数据
```

## 环境变量

通过环境变量设置默认会话名：

```bash
export PLAYWRIGHT_CLI_SESSION="mysession"
playwright-cli open example.com  # 自动使用 "mysession"
```

## 常见模式

### 并发抓取

```bash
#!/bin/bash
# 并发抓取多个站点

# 启动所有浏览器
playwright-cli -s=site1 open https://site1.com &
playwright-cli -s=site2 open https://site2.com &
playwright-cli -s=site3 open https://site3.com &
wait

# 分别采集快照
playwright-cli -s=site1 snapshot
playwright-cli -s=site2 snapshot
playwright-cli -s=site3 snapshot

# 清理
playwright-cli close-all
```

### A/B 测试会话

```bash
# 测试不同用户体验
playwright-cli -s=variant-a open "https://app.com?variant=a"
playwright-cli -s=variant-b open "https://app.com?variant=b"

# 对比
playwright-cli -s=variant-a screenshot
playwright-cli -s=variant-b screenshot
```

### 持久化 Profile

默认情况下，浏览器 profile 仅驻留内存。使用 `open` 的 `--persistent` 参数可将 profile 持久化到磁盘：

```bash
# 使用持久化 profile（自动生成位置）
playwright-cli open https://example.com --persistent

# 使用自定义目录的持久化 profile
playwright-cli open https://example.com --profile=/path/to/profile
```

## 默认浏览器会话

省略 `-s` 时，命令将作用于默认浏览器会话：

```bash
# 下列命令都使用同一个默认会话
playwright-cli open https://example.com
playwright-cli snapshot
playwright-cli close  # 停止默认会话浏览器
```

## 浏览器会话配置

打开会话时可指定配置项：

```bash
# 使用配置文件启动
playwright-cli open https://example.com --config=.playwright/my-cli.json

# 指定浏览器
playwright-cli open https://example.com --browser=firefox

# 启用 headed 模式
playwright-cli open https://example.com --headed

# 使用持久化 profile
playwright-cli open https://example.com --persistent
```

## 最佳实践

### 1. 使用语义化会话名

```bash
# GOOD: 目的清晰
playwright-cli -s=github-auth open https://github.com
playwright-cli -s=docs-scrape open https://docs.example.com

# AVOID: 泛化命名
playwright-cli -s=s1 open https://github.com
```

### 2. 始终清理

```bash
# 完成后停止浏览器
playwright-cli -s=auth close
playwright-cli -s=scrape close

# 或一次性全部停止
playwright-cli close-all

# 若浏览器无响应或出现僵尸进程
playwright-cli kill-all
```

`kill-all` 会强制终止全部会话，仅应作为最后手段。

### 3. 删除陈旧浏览器数据

```bash
# 删除旧会话数据以释放磁盘空间
playwright-cli -s=oldsession delete-data
```
