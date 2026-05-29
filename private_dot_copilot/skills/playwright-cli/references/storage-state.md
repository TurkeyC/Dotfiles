# 存储管理

管理 cookies、localStorage、sessionStorage 以及浏览器存储状态。

## 存储状态

保存并恢复完整浏览器状态（包括 cookies 与存储）。

默认遵循“安全优先”：
- 将状态文件视为敏感密钥文件
- 不进入版本控制系统（VCS）
- 缩短生命周期并在使用后删除

### 保存存储状态

```bash
# 保存为自动生成文件名（storage-state-{timestamp}.json）
playwright-cli state-save

# 保存为指定文件名
playwright-cli state-save my-auth-state.json

# 推荐的规范化路径与文件名
playwright-cli state-save .playwright-cli/artifacts/20260330/default/20260330-142250-default-state.json
```

### 恢复存储状态

```bash
# 从文件加载存储状态
playwright-cli state-load my-auth-state.json

# 重新打开页面以应用 cookies
playwright-cli open https://example.com
```

### 存储状态文件格式

保存文件包含：

```json
{
  "cookies": [
    {
      "name": "session_id",
      "value": "abc123",
      "domain": "example.com",
      "path": "/",
      "expires": 1735689600,
      "httpOnly": true,
      "secure": true,
      "sameSite": "Lax"
    }
  ],
  "origins": [
    {
      "origin": "https://example.com",
      "localStorage": [
        { "name": "theme", "value": "dark" },
        { "name": "user_id", "value": "12345" }
      ]
    }
  ]
}
```

## Cookies

### 列出全部 Cookies

```bash
playwright-cli cookie-list
```

### 按域名过滤 Cookies

```bash
playwright-cli cookie-list --domain=example.com
```

### 按路径过滤 Cookies

```bash
playwright-cli cookie-list --path=/api
```

### 获取指定 Cookie

```bash
playwright-cli cookie-get session_id
```

### 设置 Cookie

```bash
# 基础 cookie
playwright-cli cookie-set session abc123

# 带选项的 cookie
playwright-cli cookie-set session abc123 --domain=example.com --path=/ --httpOnly --secure --sameSite=Lax

# 带过期时间（Unix 时间戳）的 cookie
playwright-cli cookie-set remember_me token123 --expires=1735689600
```

### 删除 Cookie

```bash
playwright-cli cookie-delete session_id
```

### 清空全部 Cookies

```bash
playwright-cli cookie-clear
```

### 高级：批量 Cookie 或自定义选项

对于一次性添加多个 cookie 等复杂场景，可使用 `run-code`：

```bash
playwright-cli run-code "async page => {
  await page.context().addCookies([
    { name: 'session_id', value: 'sess_abc123', domain: 'example.com', path: '/', httpOnly: true },
    { name: 'preferences', value: JSON.stringify({ theme: 'dark' }), domain: 'example.com', path: '/' }
  ]);
}"
```

## Local Storage

### 列出全部 localStorage 项

```bash
playwright-cli localstorage-list
```

### 获取单个值

```bash
playwright-cli localstorage-get token
```

### 设置值

```bash
playwright-cli localstorage-set theme dark
```

### 设置 JSON 值

```bash
playwright-cli localstorage-set user_settings '{"theme":"dark","language":"en"}'
```

### 删除单个项

```bash
playwright-cli localstorage-delete token
```

### 清空 localStorage

```bash
playwright-cli localstorage-clear
```

### 高级：批量操作

对于一次设置多个值等复杂场景，可使用 `run-code`：

```bash
playwright-cli run-code "async page => {
  await page.evaluate(() => {
    localStorage.setItem('token', 'jwt_abc123');
    localStorage.setItem('user_id', '12345');
    localStorage.setItem('expires_at', Date.now() + 3600000);
  });
}"
```

## Session Storage

### 列出全部 sessionStorage 项

```bash
playwright-cli sessionstorage-list
```

### 获取单个值

```bash
playwright-cli sessionstorage-get form_data
```

### 设置值

```bash
playwright-cli sessionstorage-set step 3
```

### 删除单个项

```bash
playwright-cli sessionstorage-delete step
```

### 清空 sessionStorage

```bash
playwright-cli sessionstorage-clear
```

## IndexedDB

### 列出数据库

```bash
playwright-cli run-code "async page => {
  return await page.evaluate(async () => {
    const databases = await indexedDB.databases();
    return databases;
  });
}"
```

### 删除数据库

```bash
playwright-cli run-code "async page => {
  await page.evaluate(() => {
    indexedDB.deleteDatabase('myDatabase');
  });
}"
```

## 常见模式

### 复用认证状态

```bash
# 第 1 步：登录并保存状态
playwright-cli open https://app.example.com/login
playwright-cli snapshot
playwright-cli fill e1 "user@example.com"
playwright-cli fill e2 "password123"
playwright-cli click e3

# 保存已认证状态
playwright-cli state-save auth.json

# 第 2 步：稍后恢复状态，跳过登录
playwright-cli state-load auth.json
playwright-cli open https://app.example.com/dashboard
# 已登录！
```

### 保存与恢复回环

```bash
# 设置认证状态
playwright-cli open https://example.com
playwright-cli eval "() => { document.cookie = 'session=abc123'; localStorage.setItem('user', 'john'); }"

# 保存状态到文件
playwright-cli state-save my-session.json

# ... 稍后，在新会话中 ...

# 恢复状态
playwright-cli state-load my-session.json
playwright-cli open https://example.com
# Cookies 和 localStorage 已恢复！
```

## 安全说明

- 不要提交包含认证 token 的存储状态文件
- 在 `.gitignore` 中添加 `*.auth-state.json`
- 自动化完成后删除状态文件
- 对敏感数据优先使用环境变量
- 默认内存会话对敏感操作更安全
- 优先使用规范化产物路径与命名（见 `references/artifact-governance.md`）
- 默认保留期应尽量短（敏感环境建议当天清理）
