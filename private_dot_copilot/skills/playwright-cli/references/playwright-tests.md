# 运行 Playwright 测试

要运行 Playwright 测试，可使用 `npx playwright test` 命令，或通过包管理器脚本运行。为避免自动打开交互式 HTML 报告，可设置环境变量 `PLAYWRIGHT_HTML_OPEN=never`。

为保证安全并最小化产物：
- 优先使用测试账号与合成数据。
- 除非调试确有需要，否则不要全局开启 trace/video。
- 生成的报告与产物应使用规范化路径保存，并在排查完成后清理。

```bash
# 运行全部测试
PLAYWRIGHT_HTML_OPEN=never npx playwright test

# 通过自定义 npm 脚本运行全部测试
PLAYWRIGHT_HTML_OPEN=never npm run special-test-command
```

# 调试 Playwright 测试

要调试失败用例，像平常一样运行 Playwright，但设置环境变量 `PWPAUSE=cli`。该命令会在失败点暂停测试，并输出调试说明。

**重要**：请将命令在后台运行，并持续检查输出，直到出现 "Debugging Instructions"。

出现调试说明后，使用 `playwright-cli` 探查页面。调试说明中会包含浏览器名称，你应在 `playwright-cli` 中使用该名称附加到测试页面。

```bash
# 运行测试
PLAYWRIGHT_HTML_OPEN=never PWPAUSE=cli npx playwright test
# ...

# 探查页面并在需要时交互
playwright-cli --session=test open --attach=test-worker-abcdef
playwright-cli --session=test snapshot
playwright-cli --session=test click e14
```

在你探查并定位修复方案期间，让测试进程保持后台运行。修复完成后，停止后台测试进程。

你通过 `playwright-cli` 执行的每个动作，都会生成对应的 Playwright TypeScript 代码。
这些代码会出现在输出中，可直接复制进测试文件。多数情况下，你需要更新某个 locator 或 expectation；也可能是应用本身的缺陷，请结合上下文判断。