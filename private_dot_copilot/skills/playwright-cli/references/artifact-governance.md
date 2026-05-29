# 产物治理

面向“安全优先”的生成文件治理规则。

## 目标

1. 最小化产物生成数量。
2. 规范化存储位置与命名。
3. 防止敏感数据泄露。
4. 保证可确定的清理流程。

## 默认策略

- 除非调试/取证需要或用户明确要求，否则不生成文件。
- 优先内存工作流：
  - 会话不使用 `--persistent`
  - 非必要不启用 trace/video
- 任何产物中都不要保存真实密钥。

## 标准产物根目录

统一使用单一根目录：

```bash
.playwright-cli/artifacts/<YYYYMMDD>/<session>/
```

其中：
- `<YYYYMMDD>` 为 UTC 日期
- `<session>` 为浏览器会话名（省略时默认 `default`）

## 文件名规范化

统一格式：

```bash
<YYYYMMDD-HHMMSS>-<session>-<purpose>.<ext>
```

规则：
- 仅使用 UTC 时间戳
- `purpose` 使用小写短词并以连字符分隔
- 扩展名按产物类型固定

示例：
- `20260330-142000-default-home-snapshot.yaml`
- `20260330-142101-auth-login-trace.zip`
- `20260330-142250-auth-state.json`
- `20260330-142320-checkout-video.webm`

## 按类型推荐映射

- Snapshot: `...-snapshot.yaml`
- Storage state: `...-state.json`
- Trace: `...-trace.zip`
- Video: `...-video.webm`
- Screenshot: `...-screenshot.png`
- PDF: `...-page.pdf`

## 数据分级

默认将以下数据视为敏感：
- cookies
- localStorage/sessionStorage 值
- 请求/响应头与请求/响应体
- 包含用户数据的页面 HTML/DOM 快照
- 控制台/网络日志

## Git 卫生

将以下模式加入 `.gitignore`：

```gitignore
.playwright-cli/artifacts/
*.auth-state.json
*.state.json
*.trace
*.network
*.webm
```

## 清理

### 任务结束强制清理

1. 关闭会话：

```bash
playwright-cli close-all
```

2. 删除一次性调试产生的临时产物：

```bash
find .playwright-cli/artifacts -type f -mmin +120 -delete
```

3. 可选：删除空目录：

```bash
find .playwright-cli/artifacts -type d -empty -delete
```

## 保留期建议

- 仅保留当前调试周期必需的产物。
- 默认保留目标：少于 7 天。
- 敏感环境建议当天删除。
