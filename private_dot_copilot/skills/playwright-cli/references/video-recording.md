# 视频录制

将浏览器自动化会话录制为视频，用于调试、文档或验证。输出格式为 WebM（VP8/VP9 编码）。

## 安全警告

视频可能捕获屏幕上的敏感数据（PII、token、内部 URL）。仅在必要时录制。

## 基础录制

```bash
# 开始录制
playwright-cli video-start

# 执行动作
playwright-cli open https://example.com
playwright-cli snapshot
playwright-cli click e1
playwright-cli fill e2 "test input"

# 停止并保存
playwright-cli video-stop demo.webm

# 推荐的规范化路径与文件名
playwright-cli video-stop .playwright-cli/artifacts/20260330/default/20260330-142320-default-video.webm
```

## 最佳实践

- 录制窗口要短，且限定在任务作用域内。
- 调试结束后立即删除临时录制文件。
- 敏感环境下的录制文件不要提交到仓库。

### 1. 使用描述性文件名

```bash
# 文件名包含上下文信息
playwright-cli video-stop recordings/login-flow-2024-01-15.webm
playwright-cli video-stop recordings/checkout-test-run-42.webm
```

## Tracing vs Video

| 特性 | Video | Tracing |
|------|-------|---------|
| 输出 | WebM 文件 | Trace 文件（可在 Trace Viewer 中查看） |
| 展示内容 | 可视化录制 | DOM 快照、网络、控制台、动作 |
| 适用场景 | 演示、文档 | 调试、分析 |
| 体积 | 更大 | 更小 |

## 限制

- 录制会给自动化执行带来轻微开销
- 大体积录制文件会占用较多磁盘空间
