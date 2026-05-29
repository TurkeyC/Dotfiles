# 请求 Mock

拦截、Mock、修改与阻断网络请求。

## 安全约束（强制）

- 仅 Mock 完成任务所需的最小路由范围。
- 不要记录或持久化真实 `authorization`、`cookie` 或 token 值。
- 优先使用合成 payload，严禁嵌入生产密钥。
- 仅在原生 `route` 命令无法满足场景时使用 `run-code`。
- 调试完成后移除临时路由，避免污染其他测试。

## CLI 路由命令

```bash
# 使用自定义状态码进行 Mock
playwright-cli route "**/*.jpg" --status=404

# 使用 JSON body 进行 Mock
playwright-cli route "**/api/users" --body='[{"id":1,"name":"Alice"}]' --content-type=application/json

# 使用自定义 header 进行 Mock
playwright-cli route "**/api/data" --body='{"ok":true}' --header="X-Custom: value"

# 移除请求中的头部字段
playwright-cli route "**/*" --remove-header=cookie,authorization

# 查看当前生效路由
playwright-cli route-list

# 删除某条路由或全部路由
playwright-cli unroute "**/*.jpg"
playwright-cli unroute
```

## URL 模式

```
**/api/users           - 精确路径匹配
**/api/*/details       - 路径通配
**/*.{png,jpg,jpeg}    - 匹配文件扩展名
**/search?q=*          - 匹配查询参数
```

## 使用 run-code 的高级 Mock

适用于条件响应、请求体检查、响应修改或延迟场景：

所有示例都应使用占位符与合成数据（`<TOKEN>`、`<USER_ID>`）。

### 基于请求内容的条件响应

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/login', route => {
    const body = route.request().postDataJSON();
    if (body.username === 'admin') {
      route.fulfill({ body: JSON.stringify({ token: 'mock-token' }) });
    } else {
      route.fulfill({ status: 401, body: JSON.stringify({ error: 'Invalid' }) });
    }
  });
}"
```

### 修改真实响应

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/user', async route => {
    const response = await route.fetch();
    const json = await response.json();
    json.isPremium = true;
    await route.fulfill({ response, json });
  });
}"
```

### 模拟网络失败

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/offline', route => route.abort('internetdisconnected'));
}"
# 可选值：connectionrefused, timedout, connectionreset, internetdisconnected
```

### 延迟响应

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/slow', async route => {
    await new Promise(r => setTimeout(r, 3000));
    route.fulfill({ body: JSON.stringify({ data: 'loaded' }) });
  });
}"
```

## 清理

```bash
# 查看并移除临时路由
playwright-cli route-list
playwright-cli unroute
```

若需保存 Mock 输出，请按 `references/artifact-governance.md` 的规范化路径与命名规则执行。