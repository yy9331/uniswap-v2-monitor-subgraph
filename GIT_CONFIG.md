# Git 配置说明

## 🎯 **主要配置**

### 编辑器设置
```bash
# 设置Cursor为默认编辑器
git config --global core.editor "code --wait"
```

**说明**：
- `code --wait` - 使用Cursor编辑器，`--wait`参数确保Git等待编辑器关闭后才继续
- 适用于：`git commit`、`git rebase -i`、`git merge`等需要编辑器的操作

### 默认分支设置
```bash
# 设置默认分支为main
git config --global init.defaultBranch main
```

### Pull策略设置
```bash
# 设置pull时使用merge而不是rebase
git config --global pull.rebase false
```

## 🚀 **Git别名配置**

### 常用别名
```bash
# 状态查看
git config --global alias.st status

# 分支切换
git config --global alias.co checkout

# 分支管理
git config --global alias.br branch
```

### 使用示例
```bash
# 查看状态
git st

# 切换分支
git co feature-branch

# 查看分支
git br
```

## 📝 **交互式Rebase使用Cursor**

### 基本用法
```bash
# 交互式rebase最近3个提交
git rebase -i HEAD~3
```

### 常用操作
在Cursor编辑器中，你可以：

1. **修改提交信息**：
   ```
   pick abc1234 第一个提交
   reword def5678 第二个提交  # 修改这行
   pick ghi9012 第三个提交
   ```

2. **合并提交**：
   ```
   pick abc1234 第一个提交
   squash def5678 第二个提交  # 合并到上一个
   pick ghi9012 第三个提交
   ```

3. **删除提交**：
   ```
   pick abc1234 第一个提交
   # drop def5678 第二个提交  # 注释掉这行
   pick ghi9012 第三个提交
   ```

4. **重新排序**：
   ```
   pick ghi9012 第三个提交  # 调整顺序
   pick abc1234 第一个提交
   pick def5678 第二个提交
   ```

## 🔧 **高级配置**

### 设置用户信息（如果需要）
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 设置默认编辑器（临时）
```bash
# 为当前项目设置编辑器
git config core.editor "code --wait"

# 为特定文件类型设置编辑器
git config --global core.editor "code --wait"
```

## 📋 **配置验证**

### 查看所有配置
```bash
git config --global --list
```

### 查看特定配置
```bash
git config --global --get core.editor
git config --global --get alias.st
```

## 🎨 **Cursor编辑器优势**

1. **语法高亮** - Git rebase文件有语法高亮
2. **自动补全** - 智能提示
3. **多光标编辑** - 快速修改多行
4. **撤销/重做** - 更好的编辑体验
5. **搜索替换** - 快速查找和替换

## ⚠️ **注意事项**

1. **确保Cursor已安装** - 确保`code`命令可用
2. **等待编辑器关闭** - `--wait`参数确保Git等待
3. **保存文件** - 在Cursor中编辑完成后记得保存
4. **关闭编辑器** - 关闭Cursor窗口后Git才会继续

## 🚀 **使用示例**

```bash
# 1. 查看当前状态
git st

# 2. 添加文件
git add .

# 3. 提交（使用Cursor编辑提交信息）
git commit

# 4. 交互式rebase（使用Cursor编辑）
git rebase -i HEAD~3

# 5. 推送到远程
git push origin main
```

现在你可以享受使用Cursor编辑器进行Git操作的流畅体验了！🎯 