## Argosbx一键无交互小钢炮脚本💣：极简 + 轻量 + 快速

> 本仓库为 **Scu9277** 基于甬哥 [yonggekkk/argosbx](https://github.com/yonggekkk/argosbx) 的 **fork**，在原版基础上**新增「自定义Socks/HTTP/Mixed出口代理」功能**。原版（未改动）请访问甬哥仓库。感谢甬哥的开源。

---------------------------------------

<img width="757" height="255" alt="d89e2542c513e705106371acc7fa1d33" src="https://github.com/user-attachments/assets/7d7a4678-4223-478c-afe2-d303ba0f85a4" />

---------------------------------------

#### 1、基于Sing-box + Xray + Cloudflared-Argo 三内核自动分配

#### 2、支持主流VPS系统（推荐Ubuntu系统），SSH脚本支持非root环境运行，无脑一次回车搞定

#### 3、支持各种容器系统，Docker镜像部署，公开镜像库：```ygkkk/argosbx```

#### 4、根据Sing-box与Xray不同内核，可选15种WARP出站组合，更换落地IP为WARP的IP，解锁流媒体

#### 5、客户端支持方面，各类单协议分享、clash/mihomo/singbox聚合订阅分享都可支持

#### 6、所有代理协议都无需域名（除了argo固定隧道、IP端口CDN），支持单个或多个代理协议任意组合并快速重置更换
【 已支持：Naiveproxy、Vless-xhttp-tls、AnyTLS、Any-reality、Vless-xhttp-reality-vison-enc、Vless-tcp-reality-vision、Vless-xhttp-vison-enc、Vless-ws-vision-enc、Shadowsocks-2022、Vmess-ws、Socks5、Hysteria2、Tuic、Argo临时/固定隧道支持Vless-ws-vision-enc或Vmess-ws 】

#### 7、建议配合SSH一键脚本命令生成器网页使用：https://scu9277.github.io/argosbx/

#### 8、如需要多样的功能，推荐使用VPS专用五合一脚本[Sing-box-yg](https://github.com/yonggekkk/sing-box-yg)

#### 9、Argosbx客户端推荐：

安卓手机客户端：[Nekobox-starifly版(全协议支持)](https://github.com/starifly/NekoBoxForAndroid/releases)、[V2rayNG官方版](https://github.com/2dust/v2rayNG/releases)、[Singbox官方版](https://github.com/SagerNet/sing-box/releases)、Clash/Mihomo客户端随意

电脑win客户端：[V2rayN官方版(全协议支持)](https://github.com/2dust/v2rayN/releases)、[Singbox官方版](https://github.com/SagerNet/sing-box/releases)、Clash/Mihomo客户端随意

苹果IOS客户端：小火箭Shadowrocket、Onexray、Sing-bos MT、Clash mi

注：个别协议仅支持某些客户端

---

## 🧭 自定义出口代理（Socks / Http / Mixed）

在原版基础上新增了「自定义出口代理」功能：你可以把搭建出来的所有协议的出口流量，统一走一个自定义的 **socks / http / mixed** 代理服务器（相当于“套一层上游代理”）。通过环境变量即可随时切换自定义代理、WARP 或直连三种出口。

### 一、环境变量说明（运行主脚本/agsbx 前置设置）

| 变量 | 说明 | 示例 |
| ------ | ------ | ------ |
| `proxy` | 完整代理地址（单串） | `socks://user:pass@1.2.3.4:1080`、`http://1.2.3.4:8080`、`mixed://1.2.3.4:8080` |
| `proxy_type` | 代理类型（可单独用） | `socks` / `http` / `mixed` |
| `proxy_ip` | 代理服务器 IP（可单独用） | `1.2.3.4` |
| `proxy_port` | 代理服务器端口（可单独用） | `1080` |
| `proxy_user` | 代理账号（可选） | `user` |
| `proxy_pass` | 代理密码（可选） | `pass` |
| `outmode` | 出口模式选择 | `custom`（用自定义代理）/ `warp`（用warp出口）/ `direct`（VPS本地IP直连） |
| `proxy_enable` | 关闭自定义代理 | `0` / `no` / `off` / `false` |

> `proxy` 与分项变量（`proxy_type/ip/port/user/pass`）两者都支持，可混用；分项变量优先级更高。
> **默认出口 = VPS 本地 IP 直连**。只有主动设置才会切换出口：填了代理参数＝用自定义代理；设置 `warp`（如 `warp=s`）或 `outmode=warp`＝用 WARP；`outmode=direct`＝强制直连。
> 说明：本 fork 把默认出口从“全 WARP”改为了“VPS 本地 IP 直连”，需要 WARP 时请显式指定。
>
> **启用自定义代理时，脚本会先验证该代理能否从当前主机连网**：用 `curl -x` 通过该代理访问一次，成功会显示代理出口 IP，失败则**提示并中止配置**（不写入配置、不继续安装）。若代理本身可达但测试偶发失败，可加 `proxy_nocheck=1` 跳过验证（网页里也有对应勾选）。

### 二、使用示例

```bash
# 1) 首次安装：socks 代理出口（带账号密码）
proxy=socks://user:pass@1.2.3.4:1080 outmode=custom vlpt=443 vmp=80 \
  bash <(curl -Ls https://raw.githubusercontent.com/Scu9277/argosbx/main/argosbx.sh)

# 2) 改用 http 代理出口
proxy=http://1.2.3.4:8080 outmode=custom vlpt=443 agsbx rep

# 3) 分项变量方式
proxy_type=socks proxy_ip=1.2.3.4 proxy_port=1080 proxy_user=u proxy_pass=p outmode=custom agsbx rep

# 4) 切回 warp 出口 / 强制直连
outmode=warp   agsbx rep
outmode=direct agsbx rep

# 5) 关闭自定义代理
proxy=off      agsbx rep
```

### 三、`agsbx cp` 便捷子命令

```bash
agsbx cp                       # 查看当前出口代理设置
agsbx cp proxy=socks://...     # 保存新的出口设置（之后 rep 生效）
agsbx cp proxy=off             # 关闭自定义代理
```

保存后执行 `agsbx rep` 即可让修改生效（会复用上次安装的协议与端口，不必重复传协议变量）。

> 说明：自定义代理出口会覆盖 WARP/direct 出口（三者通过 `outmode` 切换，互不冲突）。
> Mixed 类型在客户端侧统一按 SOCKS5 出口连接，兼容性最好。


------------------------------------------------------------------

* #### 如下图：一键SSH命令生成器：[点击视频教程](https://youtu.be/4u6W4c-t3oU)

<img width="726" height="741" alt="image" src="https://github.com/user-attachments/assets/622fbc56-1058-45c6-8cac-dc00bb6cf6d0" />

------------------------------------------------------------------

* #### 如下图：从此抛弃第三方独立的WARP脚本，xray+singbox双内核集成15种WARP出站组合：[点击视频教程](https://youtu.be/iywjT8fIka4)

<img width="1015" height="681" alt="e0b66a115b1cd6a5060c38cae6e45c55" src="https://github.com/user-attachments/assets/06e69e8e-f714-4ba5-a519-f09fdecb0bbf" />

----------------------------------------------------------

* #### 如下图：节点IP、端口被封依旧可用！套CDN优选5大方案三步视频教程：
  
[视频1：80系+回源cdn](https://youtu.be/RnUT1CNbCr8)

[视频2：Argo临时/固定隧道区别与设置](https://youtu.be/K35NhrNiLK8)

[视频3：黑科技80端口CDN](https://youtu.be/X8BFVyeiY9g)

<img width="1776" height="960" alt="f51af75fcc76bae7e76fe0ef5b9ecc86" src="https://github.com/user-attachments/assets/028b780d-bd48-4c79-8c60-940b3c3d1937" />

---------------------------------------------------------


#### 相关教程可参考[甬哥博客](https://ygkkk.blogspot.com/2025/08/argosb.html)，视频教程如下：

[Argosbx小钢炮脚本重大更新：加入NaiveProxy与XHTTP-TLS一键部署；XHTTP的UDP模式支持CDN优选IP](https://youtu.be/NMJIG_2N2a8)

[Argosbx一键生成SSH命令；解决IP限制、IP质量太差问题；Argo固定隧道设置要点](https://youtu.be/xHzZFP_ywLs)

[搭建代理9大问题排行榜：第4名全网99%的人被误导！第1名每个人都被折腾到爆！](https://youtu.be/pJwJBqBkcfw)

[2025年度代理协议"拉到夯"综合排名](https://youtu.be/IoFtykGXDao)

[ArgoSBX小钢炮脚本更新说明：新增VLESS ENC抗量子加密；80端口也能开启TLS加密？无需域名也能CDN优选？](https://youtu.be/X8BFVyeiY9g)

[Argo隧道代理节点终极教程：VPS+容器搭建最强CDN节点 | 无视端口IP被封 | Argo临时/固定隧道区别 | CDN优选IP加速](https://youtu.be/K35NhrNiLK8)

[ArgoSBX一键无交互小钢炮脚本💣（四）：一键SSH命令生成器发布，只要点几下，各大代理协议任你选](https://youtu.be/4u6W4c-t3oU)

[ArgoSB一键无交互小钢炮脚本💣（三）：内置15种WARP出站组合，轻松替代独立的WARP脚本](https://youtu.be/iywjT8fIka4)

[ArgoSB一键无交互小钢炮脚本💣（二）：代理节点的IP、端口被封依旧可用！ArgoSB脚本套CDN优选4大方案教程](https://youtu.be/RnUT1CNbCr8)

[ArgoSB一键无交互小钢炮脚本💣（一）：VPS/nat VPS在主协议下的应用；仅按一次回车，多协议自由搭配](https://youtu.be/CiXmttY7mhw)

----------------------------------------------------------

### 交流平台：[甬哥博客地址](https://ygkkk.blogspot.com)、[甬哥YouTube频道](https://www.youtube.com/@ygkkk)、[甬哥TG电报群组](https://t.me/+jZHc6-A-1QQ5ZGVl)、[甬哥TG电报频道](https://t.me/+DkC9ZZUgEFQzMTZl)

----------------------------------------------------------
### 感谢支持！微信打赏甬哥侃侃侃ygkkk
![41440820a366deeb8109db5610313a1](https://github.com/user-attachments/assets/e5b1f2c0-bd2c-4b8f-8cda-034d3c8ef73f)

----------------------------------------------------------
### 感谢你右上角的star🌟（欢迎给本 fork 点个 star）
[![Stargazers over time](https://starchart.cc/Scu9277/argosbx.svg)](https://starchart.cc/Scu9277/argosbx)

----------------------------------------------------------
### 声明：所有代码来源于Github社区与ChatGPT的整合

### Thanks to [zmto/vtexs](https://console.zmto.com/?affid=1558) for the sponsorship support
