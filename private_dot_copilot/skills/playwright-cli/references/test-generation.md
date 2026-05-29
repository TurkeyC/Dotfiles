# 测试代码生成

在你与浏览器交互时自动生成 Playwright 测试代码。

## 安全约束（强制）

- 仅使用测试账号与合成数据。
- 保存测试代码前，将密钥替换为占位符（`<EMAIL>`、`<PASSWORD>`、`<TOKEN>`）。
- 不要提交包含真实凭据、cookies 或会话值的生成代码。
- 生成产物应最小化，仅保留测试所需文件。

## 工作原理

你通过 `playwright-cli` 执行的每个动作都会生成对应的 Playwright TypeScript 代码。
这些代码会出现在输出中，可直接复制到测试文件。

## 示例工作流

```bash
# 启动会话
playwright-cli open https://example.com/login

# 获取快照查看元素
playwright-cli snapshot
# 输出示例：e1 [textbox "Email"], e2 [textbox "Password"], e3 [button "Sign In"]

# 填充表单字段 - 自动生成代码
playwright-cli fill e1 "user@example.com"
# 已运行的 Playwright 代码：
# await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');

playwright-cli fill e2 "password123"
# 已运行的 Playwright 代码：
# await page.getByRole('textbox', { name: 'Password' }).fill('password123');

playwright-cli click e3
# 已运行的 Playwright 代码：
# await page.getByRole('button', { name: 'Sign In' }).click();
```

## 组装测试文件

将生成代码整理进 Playwright 测试：

```typescript
import { test, expect } from '@playwright/test';

test('login flow', async ({ page }) => {
  // 来自 playwright-cli 会话的生成代码：
  await page.goto('https://example.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill('<EMAIL>');
  await page.getByRole('textbox', { name: 'Password' }).fill('<PASSWORD>');
  await page.getByRole('button', { name: 'Sign In' }).click();

  // 补充断言
  await expect(page).toHaveURL(/.*dashboard/);
});
```

## 最佳实践

### 1. 使用语义化定位器

生成代码会尽可能使用基于 role 的定位器，通常更稳健：

```typescript
// 生成写法（推荐：语义化）
await page.getByRole('button', { name: 'Submit' }).click();

// 不推荐（脆弱：CSS 选择器）
await page.locator('#submit-btn').click();
```

### 2. 录制前先探索

先获取快照了解页面结构，再执行录制动作：

```bash
playwright-cli open https://example.com
playwright-cli snapshot
# 检查元素结构
playwright-cli click e5
```

### 3. 手动补充断言

生成代码主要覆盖动作，不会自动补全断言。请在测试中手动添加 expectation：

```typescript
// 生成动作
await page.getByRole('button', { name: 'Submit' }).click();

// 手动断言
await expect(page.getByText('Success')).toBeVisible();
```

### 4. 提交前脱敏

- 提交前扫描测试文件中的潜在密钥。
- 相关证据产物仅保存在规范化目录。
- 按 `references/artifact-governance.md` 执行清理策略。
