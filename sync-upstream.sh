#!/bin/bash
# =============================================================
# 一键同步上游(yonggekkk/argosbx)到本 fork，并保留本地出口代理功能
#   用法:  bash sync-upstream.sh
#   说明:   拉取上游最新 -> 判断是否有更新 -> 合并(保留本地功能) -> 推送
#           若合并有冲突，手工解决后执行: git add 冲突文件 && git commit && git push origin main
# =============================================================
set -e
cd "$(dirname "$0")"

echo "==> 拉取上游(upstream: yonggekkk/argosbx)..."
git fetch upstream --quiet

if git merge-base --is-ancestor upstream/main HEAD; then
  echo "✔ 上游无新提交（你的 fork 已在最新上游之上），无需合并。"
  exit 0
fi

echo "==> 检测到上游有新提交，开始合并（保留本地出口代理功能）..."
if git merge upstream/main; then
  echo "✔ 合并成功（无冲突）。"
else
  echo ""
  echo "!!! 合并遇到冲突 !!!"
  echo "  通常集中在 argosbx.sh 的 customproxy() / xrsbout() 附近。"
  echo "  请编辑冲突文件，保留你的出口代理功能后："
  echo "    git add <冲突文件>"
  echo "    git commit"
  echo "    bash sync-upstream.sh"
  echo ""
  echo "  若你的功能被上游覆盖丢失，可重放补丁："
  echo "    git apply /Users/scu/Downloads/1/argosbx-exit-proxy.patch && git commit && git push origin main"
  exit 1
fi

echo "==> 推送到你的 fork(origin/main)..."
git push origin main
echo "✔ 同步完成，本地出口代理功能已保留。"
