# 本机验证

2026-09-10，macOS，本机已有 Apple Development 证书。所有签名命令由代理执行，没有要求用户复制构建命令；没有读取私钥或修改钥匙串访问控制。

| 项目 | cap | minibridge |
| --- | --- | --- |
| 项目定位 | 显式 `--project` | 当前工作目录，不传 `--project` |
| 产物发现 | 自动找到 Cap.app | 自动找到 MiniBridge.app |
| 首次从 ad-hoc 转开发签名 | 通过 | 通过 |
| 配置驱动重建并签名 | 通过 | 通过 |
| 完整包严格验证 | 通过 | 通过 |
| 新产物满足旧安装版的身份要求 | 通过 | 通过 |
| 重建后的 CDHash | 改变 | 相同，Swift 增量构建未改变内容 |
| 安装位置 | ~/Applications/Cap.app | ~/Applications/MiniBridge.app |
| 启动 | 已启动；读到总览窗口 | 已启动；确认安装版进程持续运行 |
| UI 验证 | 通过 | 电脑控制工具反复返回 native pipe closed，未完成界面验证 |

cap 的首次重建因搬目录后保留旧 Swift 模块缓存而失败。插件正确终止，没有替换已经签好的安装版。执行 `swift package clean` 清理该项目的构建缓存后，重建成功。给 cap 的构建脚本补充了 `--build` 模式，构建测试不提前关闭旧 App；MiniBridge 已有该模式。

两个项目各保存一份 `.ai-sign.json`，不写死个人证书。它们的原有打包脚本生成 dist 中间产物，插件将开发签名后的完整 App 放到配置的 Applications 路径；运行测试使用后者。

脚本测试 9 项全部通过：证书连续性与多证书歧义、产物发现与依赖排除、配置拒绝错误键和 shell 字符串、拒绝覆盖其他 Bundle ID、构建参数不执行 shell 插值、原地重签及改版本后的身份校验、全新未签构建对照已安装身份、签名校验失败保留原文件、嵌套 helper 与 entitlements/hardened runtime 保留。其中 4 项使用临时编译的真实 Mach-O 与本机开发证书，其余验证选择与执行边界。

Plugin Creator 的插件校验和 Skill Creator 的技能校验均通过；插件通过个人市场安装并启用，安装后的脚本与源码一致。安装缓存中的脚本已实际执行。

以上不包含 TCC 移动宗卷授权跨重建保留测试，也不包含公证或公开分发测试。签名及身份的分项结果见 [results.json](results.json)。
