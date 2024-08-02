
{include file='user/main.tpl'}
{$ssr_prefer = URL::SSRCanConnect($user, 0)}

	<main class="content">

		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">用户中心 ★ </h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="ui-card-wrap">

						<div class="col-xx-12 col-xs-6 col-lg-3">
								<div class="card user-info">
									<div class="user-info-main">
										<div class="nodemain">
											<div class="nodehead node-flex">
												<div class="nodename">帐号等级</div>
												<a href="/user/shop" class="card-tag tag-orange">升级</a>
											</div>
											<div class="nodemiddle node-flex">
												<div class="nodetype">
													{if $user->class!=0}
													<dd>VIP {$user->class}</dd>
													{else}
													<dd>普通用户</dd>
													{/if}
												</div>
											</div>
										</div>
										<div class="nodestatus">
											<div class="infocolor-red">
												<i class="icon icon-md t4-text">stars</i>
											</div>
										</div>
									</div>
									<div class="user-info-bottom">
										<div class="nodeinfo node-flex">
										{if $user->class!=0}
											<span><i class="icon icon-md">add_circle</i>邀请好友使用</span>
										{else}
										    <span><i class="icon icon-md">add_circle</i>升级解锁VIP节点</span>
										{/if}
										</div>
									</div>
								</div>
							</div>
							<div class="col-xx-12 col-xs-6 col-lg-3">
								<div class="card user-info">
									<div class="user-info-main">
										<div class="nodemain">
											<div class="nodehead node-flex">
												<div class="nodename">余额</div>
												<a href="/user/code" class="card-tag tag-green">充值</a>
											</div>
											<div class="nodemiddle node-flex">
												<div class="nodetype">
													{$user->money} $
												</div>
											</div>
										</div>
										<div class="nodestatus">
											<div class="infocolor-green">
												<i class="icon icon-md">account_balance_wallet</i>
											</div>
										</div>
									</div>
									<div class="user-info-bottom">
										<div class="nodeinfo node-flex">
											<span href="/user/shop"><i class="icon icon-md">attach_money</i>账户内可用余额</span>
										</div>
									</div>
								</div>
							</div>
							<div class="col-xx-12 col-xs-6 col-lg-3">
								<div class="card user-info">
									<div class="user-info-main">
										<div class="nodemain">
											<div class="nodehead node-flex">
												<div class="nodename">在线设备数</div>
											</div>
											<div class="nodemiddle node-flex">
												<div class="nodetype">
													{if $user->node_connector!=0}
													<dd>{$user->online_ip_count()} / {$user->node_connector}</dd>
													{else}
													<dd>{$user->online_ip_count()} / 不限制 </dd>
													{/if}
												</div>
											</div>
										</div>
										<div class="nodestatus">
											<div class="infocolor-yellow">
												<i class="icon icon-md">phonelink</i>
											</div>
										</div>
									</div>
									<div class="user-info-bottom">
										<div class="nodeinfo node-flex">
											<span><i class="icon icon-md">donut_large</i>在线连接/限制数</span>
										</div>
									</div>
								</div> 
							</div>
							<div class="col-xx-12 col-xs-6 col-lg-3">
								<div class="card user-info">
									<div class="user-info-main">
										<div class="nodemain">
											<div class="nodehead node-flex">
												<div class="nodename">端口速率</div>
											</div>
											<div class="nodemiddle node-flex">
												<div class="nodetype">
													{if $user->node_speedlimit!=0}
													<dd><code>{$user->node_speedlimit}</code>Mbps</dd>
													{else}
													<dd>无限制</dd>
													{/if}
												</div>
											</div>
										</div>
										<div class="nodestatus">
											<div class="infocolor-blue">
												<i class="icon icon-md">settings_input_component</i>
											</div>
										</div>
									</div>
									<div class="user-info-bottom">
										<div class="nodeinfo node-flex">
											<span><i class="icon icon-md">signal_cellular_alt</i>账户最高下行网速</span>
										</div>
									</div>
								</div>
							</div>

						<div class="col-xx-12 col-sm-8">


							<div class="card quickadd">
								<div class="card-main">
									<div class="card-inner margin-bottom-no">
									<div class="cardbtn-edit">
											<div class="card-heading"><i class="icon icon-md">phonelink</i> 快速添加节点</div>
											<div class="reset-flex"><span>重置订阅链接</span><a class="reset-link btn btn-brand-accent btn-flat" ><i class="icon">autorenew</i>&nbsp;</a></div>
									</div>
										<nav class="tab-nav margin-top-no">
											<ul class="nav nav-list">
												<li class="active">
													<a class="" data-toggle="tab" href="#all_windows"><i class="icon icon-lg">desktop_windows</i>&nbsp;Win</a>
												</li>
												<li>
													<a class="" data-toggle="tab" href="#all_android"><i class="icon icon-lg">android</i>&nbsp;安卓</a>
												</li>
												<li>
													<a class="" data-toggle="tab" href="#all_ios"><i class="icon icon-lg">phone_iphone</i>&nbsp;iOS</a>
												</li>
												<li>
													<a class="" data-toggle="tab" href="#all_mac"><i class="icon icon-lg">laptop_mac</i>&nbsp;Mac</a>
												</li>
												<li>
													<a class="" data-toggle="tab" href="#all_linux"><i class="icon icon-lg">dvr</i>&nbsp;Linux</a>
												</li>
												<li>
													<a class="" data-toggle="tab" href="#all_router"><i class="icon icon-lg">router</i>&nbsp;软路由</a>
												</li>
												<!-- <li>
													<a class="" data-toggle="tab" href="#all_game"><i class="icon icon-lg">videogame_asset</i>&nbsp;游戏</a>
												</li> -->
												<li >
													<a class="" data-toggle="tab" href="#all_info"><i class="icon icon-lg">info_outline</i>&nbsp;更多</a>
												</li>
											</ul>
										</nav>
										<div class="card-inner">
											<div class="tab-content">
												<div class="tab-pane fade active in " id="all_windows">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li class="active in">
																<a class="" data-toggle="tab" href="#all_v2rayn"><i class="icon icon-lg">flight_land</i>&nbsp;V2rayN ★★★★★</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_clash"><i class="icon icon-lg">flight_takeoff</i>&nbsp;Clash 停用</a>
															</li>
														</ul>
													</nav>

													<div class="tab-pane fade active in" id="all_v2rayn">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button><br></div>
														<p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b><a href="/download/v2rayN-Core.zip" class="btn-dl"><i class="material-icons">save_alt</i> 本站v6.32</a><a href="https://github.com/2dust/v2rayN/releases" class="btn-dl"><i class="material-icons">save_alt</i> 官网下载</a> ->解压->运行 <code>V2rayN.exe</code> </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>V2rayN -> 订阅分组 -> <code>订阅分组设置</code> -> 添加 -> 别名:随意 , 可选地址:(如上), 勾选启用订阅  -> 确定 
															<br> v2rayN -> 订阅分组 -><code>更新订阅(不通过代理)</code> -> (出现节点列表)  
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b> V2rayN -> 选择节点(如'香港') -> 右键点击 -> 设为活动服务器
															<br> <code>V2rayN</code> 系统代理 -> 自动配置系统代理 -> 路由 -> 绕过大陆 -> 完成</p>
														<p><span class="icon icon-lg text-white">filter_4</span><b>图文教程</b> -> <a href="/user/announcement/3" class="btn-dl">v2rayN图文教程</a></p>
														
													</div>

                                                    <div class="tab-pane fade" id="all_clash">
														<div><span class="icon icon-lg text-white">flash_auto</span> Clash新版订阅地址: </div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subconUrl}/sub?target=clash&new_name=true&url={$subUrl}/link/{$ssr_sub_token}&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FACL4SSR%2FACL4SSR%2Fmaster%2FClash%2Fconfig%2FACL4SSR_Online.ini" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subconUrl}/sub?target=clash&new_name=true&url={$subUrl}/link/{$ssr_sub_token}&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FACL4SSR%2FACL4SSR%2Fmaster%2FClash%2Fconfig%2FACL4SSR_Online.ini">复制</button><br></div>
														<p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b><a href="/download/Clash.for.Windows-0.19.8-win.7z" class="btn-dl"><i class="material-icons">save_alt</i> 本站v0.19.8</a><a href="https://github.com/Fndroid/clash_for_windows_pkg/releases" class="btn-dl"><i class="material-icons">save_alt</i> 官网下载</a> ->解压->运行 <code>Clash.exe</code> </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>Clash -> <code>Profiles</code> -> 输入订阅地址 -> <code>Download</code></p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b>Clash -> <code>System Proxy</code> -> <code>Start with Windows</code> </p>
													</div>
                                                 
												</div>

												<div class="tab-pane fade" id="all_android">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li class="active">
																<a class="" data-toggle="tab" href="#all_v2rayng"><i class="icon icon-lg">flight_land</i>&nbsp;V2rayNG ★★★★★</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_sagernet"><i class="icon icon-lg">flight_takeoff</i>&nbsp;SagerNet ★★</a>
															</li>
														</ul>
													</nav>
													
													<div class="tab-pane fade active in" id="all_v2rayng">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button></div>
														<p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b><a href="/download/v2rayNG.apk" class="btn-dl"><i class="material-icons">save_alt</i> 本站下载</a><a href="https://github.com/2dust/v2rayNG/releases" class="btn-dl"><i class="material-icons">save_alt</i> 官网下载</a> -> 安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>v2rayNG -> 左上角 -> <code>订阅设置</code> -> 右上角<code>+</code>添加订阅；v2rayNG -> 右上角 <code>+</code> ->更新订阅；</p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b>选择节点 -> 右下角 <code>图标</code> -> 弹出窗口：允许VPN(仅第一次开启出现)</p>
													</div>
													<div class="tab-pane fade" id="all_sagernet">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button></div>
														<p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b><a href="/download/SN-0.7-rc06-arm64-v8a.apk" class="btn-dl"><i class="material-icons">save_alt</i> 本站下载v0.7-rc06</a><a href="https://github.com/SagerNet/SagerNet/releases" class="btn-dl"><i class="material-icons">save_alt</i> 官网下载</a> -> 安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>SagerNet -> 左上角菜单 -> 分组 -> 右上角<code>+</code> -> <code>分组类型:订阅</code> -> 订阅链接填写 -> 保存； 自动获取节点</p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b>SagerNet -> 左上角菜单 -> 配置 ; 选择节点 -> 右下角图标 -> 允许VPN(如果出现弹窗)</p>
													</div>
													
												</div>

												<div class="tab-pane fade  " id="all_ios">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li class="active">
																<a class="" data-toggle="tab" href="#all_shadowrocket"><i class="icon icon-lg">flight_land</i>&nbsp;Shadowrocket ★★★★★</a>
															</li>
														</ul>
													</nav>
													<div class="tab-pane fade active in" id="all_shadowrocket">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button><br></div>
														<p><span class="icon icon-lg text-white">filter_1</span> <b>获取软件</b>获取软件：在<code>非国区</code>AppStore中搜索<code>shadowrocket</code>购买($2.99) -> 安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span> <b>订阅节点：</b>Shadowrocket -> 右上角 <code>+</code> -> 类型:<code>Subscribe</code> -> URL：订阅地址-> 完成</p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b>点击节点 -> 点击上方<code>未连接</code> 切换为 连接 。<small>*如遇到提示是否允许小火箭使用代理，点击ALLOW*</small></p>
														
													</div>
												</div>

												<div class="tab-pane fade  " id="all_mac">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															
															
															<li class="active">
																<a class="" data-toggle="tab" href="#all_v2rayu"><i class="icon icon-lg">flight_land</i>&nbsp;V2rayU ★★★★</a>
															</li>
															<li >
																<a class="" data-toggle="tab" href="#all_v2raya"><i class="icon icon-lg">flight_land</i>&nbsp;V2rayA ★★★</a>
															</li>
														</ul>
													</nav>
													<div class="tab-pane fade" id="all_v2raya">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button><br></div>
														<!-- <p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b> 推荐搭配 搭配 Homebrew 安装，请先安装 <a href="https://brew.sh/" >Homebrew</a>  
															<br> 下载V2rayA: <a href="">本站下载</a> 或 <a href="https://github.com/v2rayA/v2rayA/releases">官网下载</a>， 下载 -> 解压 -> 将 v2rayA文件重命名为 v2raya 并将其保存到 /usr/local/bin/
															<br> 在 /usr/local/bin/ 目录下 新建一个 sh脚本 v2raya.sh 输入如下内容：
															<code><br>#! /bin/zsh<br>
																PATH=$PATH:/usr/local/bin <br>
																# 如若是 ARM64 版本的 Homebrew 则路径应该位于 /opt/homebrew/bin 请注意替换<br>
																/usr/local/bin/v2raya --lite --log-file /tmp/v2raya.log</code>
															<br>下载 V2Ray 核心 / Xray 核心:  <code>brew install v2ray </code>
															<br> 给予可执行权限 <code>chmod 755 /usr/local/bin/v2raya; chmod 755 /usr/local/bin/v2raya.sh</code>
															<br> 如果遇到 macOS 的安全限制，那么需要运行以下命令: <code>xattr -d -r com.apple.quarantine  /usr/local/bin/*</code>
															<br> 运行 <code>/usr/local/bin/v2raya.sh</code>
															<br> 打开浏览器输入 127.0.0.1:2017 即为V2rayA的主界面
														</p> -->
														<p><span class="icon icon-lg text-white">filter_1</span><b>安装软件：</b><a href="/user/announcement/21" class="btn-dl">查看教程</a> </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>V2rayA网页 -> <code>导入</code> 填写订阅地址 -> 确定 </p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用软件：</b><a href="/user/announcement/28" class="btn-dl">查看教程</a> </p>
													</div>
													<div class="tab-pane fade active in" id="all_v2rayu">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button><br></div>
														<p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b><a href="/download/V2rayU-64.dmg" class="btn-dl"><i class="material-icons">save_alt</i> v4.25 Intel芯片版</a> <a href="/download/V2rayU-arm64.dmg" class="btn-dl"><i class="material-icons">save_alt</i> v4.25 APPLE-M芯片版</a> <a href="https://github.com/yanue/V2rayU/releases" class="btn-dl"><i class="material-icons">save_alt</i> 官网下载最新版</a>→在<code>安装界面</code>将<code>v2rayU</code>拖到<code>Applications</code>; 运行: 访达 → 应用 ，找到v2rayU→ 右键点击启动；</p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>右键状态栏v2rayU图标 -> 订阅设置/Subscribe→URL/<code>上面的订阅链接:</code>→remark/备注：<code>{$config["appName"]}</code>→add/添加 →update servers/更新；获取节点</p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b>选择节点→右键任务栏图标→GlobalMode/全局模式→Turn V2ray-Core:On → 打开浏览器使用</p>
														<p><span class="icon icon-lg text-white">filter_4</span><b>故障帮助：</b>遇到使用问题,请提交工单</p>
													</div>
												</div>

												<div class="tab-pane fade" id="all_linux">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li class="active">
																<a class="" data-toggle="tab" href="#all_v2raya_debian"><i class="icon icon-lg">flight_land</i>&nbsp;V2rayA - Debian/Ubuntu ★★★★★</a>
															</li>
															<li >
																<a class="" data-toggle="tab" href="#all_v2raya_centos"><i class="icon icon-lg">flight_land</i>&nbsp;V2rayA - Centos/RedHat ★★★</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_qv2ray"><i class="icon icon-lg">flight_takeoff</i>&nbsp;Qv2ray 停用</a>
															</li>
														</ul>
													</nav>
													
													<div class="tab-pane fade active in" id="all_v2raya_debian">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button></div>
														<!-- <p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b> 安装V2ray: <code>curl -Ls https://mirrors.v2raya.org/go.sh | sudo bash</code>
															<br> 安装后可以关掉V2ray服务，V2rayA不依赖V2ray服务，只需要V2raycore <code>sudo systemctl disable v2ray --now</code>
															<br> 安装 V2rayA : 添加公钥 <code>wget -qO - https://apt.v2raya.mzz.pub/key/public-key.asc | sudo apt-key add -</code>
															<br> 添加 V2rayA软件源： <code>echo "deb https://apt.v2raya.mzz.pub/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list</code>
															<br> 更新	<code>sudo apt update</code>
															<br> 安装 V2rayA: <code>sudo apt install v2raya</code>
															<br> 启动 V2rayA: <code>sudo systemctl start v2raya.service</code>
															<br> 设置开机自动运行： <code>sudo systemctl enable v2raya.service</code>
															<br> 打开V2rayA: 打开浏览器 输入 <code>127.0.0.1:2017</code> 请注意，V2rayA的界面是网页控制，无图形主界面。
														</p> -->
														<p><span class="icon icon-lg text-white">filter_1</span><b>安装软件：</b><a href="/user/announcement/24" class="btn-dl">查看安装教程</a> </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>使用软件：</b><a href="/user/announcement/28" class="btn-dl">查看使用教程</a> </p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>订阅节点：</b>v2rayA  -> 导入</p>
														
													</div>
													<div class="tab-pane fade  " id="all_v2raya_centos">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button></div>
														<!-- <p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b> 安装V2ray: <code>curl -Ls https://mirrors.v2raya.org/go.sh | sudo bash</code>
															<br> 安装后可以关掉V2ray服务，V2rayA不依赖V2ray服务，只需要V2raycore <code>sudo systemctl disable v2ray --now</code>
															<br> 下载RPM包 <code>cd;wget -LOk https://github.com/v2rayA/v2rayA/releases/download/v1.5.6.2/installer_redhat_x64_1.5.6.2.rpm</code>
															<br> 注意，RPM包以x64为例，如果是其他系统，请自行下载相应的rpm包：下载地址： https://github.com/v2rayA/v2rayA/releases
															<br> 安装RPM包 <code>sudo rpm -i ~/installer_redhat_x64_1.5.6.2.rpm </code>
															<br> 注意：如果您下载的包在其他路径，如/root/download/xxx，请替换路径。 如： sudo rpm -i /root/download/xxx你下载的包名字.rpm  
															<br> 启动 V2rayA: <code>sudo systemctl start v2raya.service</code>
															<br> 设置开机自动运行： <code>sudo systemctl enable v2raya.service</code>
															<br> 打开V2rayA: 打开浏览器 输入 <code>127.0.0.1:2017</code> 请注意，V2rayA的界面是网页控制，无图形主界面。
														</p> -->
														<p><span class="icon icon-lg text-white">filter_1</span><b>安装软件：</b><a href="https://v2raya.org/docs/prologue/installation/redhat/" class="btn-dl">查看教程</a> </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>使用软件：</b><a href="/user/announcement/28" class="btn-dl">查看使用教程</a> </p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>订阅节点：</b>v2rayA  -> 导入</p>
													</div>
													<div class="tab-pane fade  " id="all_qv2ray">
														<p>友情提示：Qv2ray团队已停止开发该软件。最后更新时间为2021-08-17 </p>
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button></div>
														<p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b> 使用教程请查看 <a href="http://qv2ray.net/lang/zh/getting-started/">官方教程地址</a> </p>
													</div>
												</div>

												<div class="tab-pane fade" id="all_router">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li class="active">
																<a class="" data-toggle="tab" href="#all_ssrplus"><i class="icon icon-lg">flight_land</i>&nbsp;v2rayA ★★★★★</a>
															</li>
														</ul>
													</nav>
													
													<div class="tab-pane fade active in" id="all_ssrplus">
														<p><span class="icon icon-lg text-white">filter_1</span><b>安装软件：</b><a href="/user/announcement/26" class="btn-dl">查看教程</a> </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>使用软件：</b><a href="/user/announcement/28" class="btn-dl">查看教程</a> </p>
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button></div>
														<!-- <p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b>  </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>  </p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b>  </p> -->
													</div>
												</div>

												<div class="tab-pane fade" id="all_game">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li class="active">
																<a class="" data-toggle="tab" href="#all_gameplugin"><i class="icon icon-lg">flight_land</i>&nbsp;GamePlugin ★★★★★</a>
															</li>
														</ul>
													</nav>
													
													<div class="tab-pane fade active in" id="all_gameplugin">
														<div><span class="icon icon-lg text-white">flash_auto</span> 订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}?mu=2" readonly="true"><button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">复制</button></div>
														<!-- <p><span class="icon icon-lg text-white">filter_1</span><b>获取软件：</b>  </p>
														<p><span class="icon icon-lg text-white">filter_2</span><b>订阅节点：</b>  </p>
														<p><span class="icon icon-lg text-white">filter_3</span><b>使用节点：</b>  </p> -->
													</div>
												</div>

												<div class="tab-pane fade" id="all_info">
													<p>在节点列表页面可以查看节点配置信息，您也可以手动添加节点。</p>
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li class="active">
																<a class="" data-toggle="tab" href="#all_hand"><i class="icon icon-lg">flight_land</i>&nbsp;订阅转换★</a>
															</li>
														</ul>
													</nav>
													<div class="tab-pane fade active in" id="all_hand">
														<div><span class="icon icon-lg text-white">flash_auto</span> Singbox订阅：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subconUrl}/sub?target=singbox&url={$subUrl}/link/{$ssr_sub_token}&insert=false&emoji=true&list=false&tfo=false&scv=true&fdn=false&expand=true&sort=false" readonly="true" />
														<button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subconUrl}/sub?target=singbox&url={$subUrl}/link/{$ssr_sub_token}&insert=false&emoji=true&list=false&tfo=false&scv=true&fdn=false&expand=true&sort=false">
															点击复制
														</button>
														</div>
														<br>
														<div><span class="icon icon-lg text-white">flash_auto</span> Clash订阅：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subconUrl}/sub?target=clash&url={$subUrl}/link/{$ssr_sub_token}&insert=false" readonly="true" />
														<button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subconUrl}/sub?target=clash&url={$subUrl}/link/{$ssr_sub_token}&insert=false">
															点击复制
														</button>
														</div>
														<br>
														
														<div><span class="icon icon-lg text-white">flash_auto</span> ClashR订阅：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subconUrl}/sub?target=clashr&url={$subUrl}/link/{$ssr_sub_token}&insert=false" readonly="true" />
														<button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subconUrl}/sub?target=clashr&url={$subUrl}/link/{$ssr_sub_token}&insert=false">
															点击复制
														</button>
														</div>
														<br>
														<div><span class="icon icon-lg text-white">flash_auto</span> Quan-X订阅：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subconUrl}/sub?target=quanx&url={$subUrl}/link/{$ssr_sub_token}&insert=false&emoji=true&list=false&tfo=false&scv=true&fdn=false&expand=true&sort=false" readonly="true" />
														<button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subconUrl}/sub?target=quanx&url={$subUrl}/link/{$ssr_sub_token}&insert=false&emoji=true&list=false&tfo=false&scv=true&fdn=false&expand=true&sort=false">
															点击复制
														</button>
														</div>
														<br>
														<div><span class="icon icon-lg text-white">flash_auto</span> Surfboard订阅：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subconUrl}/sub?target=surfboard&url={$subUrl}/link/{$ssr_sub_token}&insert=false&emoji=true&list=false&tfo=false&scv=true&fdn=false&expand=true&sort=false" readonly="true" />
														<button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subconUrl}/sub?target=surfboard&url={$subUrl}/link/{$ssr_sub_token}&insert=false&emoji=true&list=false&tfo=false&scv=true&fdn=false&expand=true&sort=false">
															点击复制
														</button>
														</div>
														<br>
														<div><span class="icon icon-lg text-white">flash_auto</span> 默认V2ray订阅地址：</div>
														<div class="float-clear"><input type="text" class="input form-control form-control-monospace cust-link col-xx-12 col-sm-8 col-lg-7" name="input1" readonly value="{$subUrl}/link/{$ssr_sub_token}" readonly="true" />
														<button class="copy-text btn btn-subscription col-xx-12 col-sm-3 col-lg-2" type="button" data-clipboard-text="{$subUrl}/link/{$ssr_sub_token}?mu=2">
															点击复制
														</button>
														</div>
													</div>
												</div>

												
											</div>
										</div>

									</div>

								</div>
							</div>


							<div class="card">
								<div class="card-main">
									<div class="card-inner margin-bottom-no">
                                    <p class="card-heading"> <i class="icon icon-md">notifications_active</i>公告栏 ★ </p>
										{if $ann != null}
										<p>{$ann->content}</p>
										<br/>
										<strong>查看所有公告请<a href="/user/announcement">点击这里</a></strong>
										{/if}
										{if $config["enable_admin_contact"] == 'true'}
										<p class="card-heading">管理员联系方式</p>
										{if $config["admin_contact1"]!=null}
										<p>{$config["admin_contact1"]}</p>
										{/if}
										{if $config["admin_contact2"]!=null}
										<p>{$config["admin_contact2"]}</p>
										{/if}
										{if $config["admin_contact3"]!=null}
										<p>{$config["admin_contact3"]}</p>
										{/if}
										{/if}
									</div>
								</div>
							</div>


						</div>

						<div class="col-xx-12 col-sm-4">

							<div class="card">
								<div class="card-main">
									<div class="card-inner margin-bottom-no">
										<p class="card-heading"><i class="icon icon-md">account_circle</i>账号使用情况</p>
										<dl class="dl-horizontal">


											<p><dt>等级过期时间</dt>
                                              {if $user->class_expire!="1989-06-04 00:05:00"}
											<dd><i class="icon icon-md">event</i>&nbsp;{$user->class_expire}</dd>
                                              {else}
                                              <dd><i class="icon icon-md">event</i>&nbsp;请续期</dd>
                                              {/if}
											</p>
                                          	<p><dt>等级有效期</dt>
                                              <i class="icon icon-md">event</i>
                                              <span class="label-level-expire">剩余</span>
											  <code><span id="days-level-expire"></span></code>
                                              <span class="label-level-expire">天</span>
                                            </p>

											<p><dt>帐号过期时间</dt>
											  <dd><i class="icon icon-md">event</i>&nbsp;{$user->expire_in}</dd>
                                            </p>
                                            <p><dt>账号有效期</dt>
                                              <i class="icon icon-md">event</i>
                                              <span class="label-account-expire">剩余</span>
											  <code><span id="days-account-expire"></span></code>
											  <span class="label-account-expire">天</span>
                                           </p>

											<p><dt>上次使用</dt>
                                              {if $user->lastSsTime()!="从未使用喵"}
											<dd><i class="icon icon-md">event</i>&nbsp;{$user->lastSsTime()}</dd>
                                              {else}
                                              <dd><i class="icon icon-md">event</i>&nbsp;从未使用</dd>
                                              {/if}</p>
                                            <p><dt>上次签到时间：</dt>
                                            <dd><i class="icon icon-md">event</i>&nbsp;{$user->lastCheckInTime()}</dd></p>


											<p id="checkin-msg"></p>

											{if $geetest_html != null}
												<div id="popup-captcha"></div>
											{/if}
											{if $recaptcha_sitekey != null && $user->isAbleToCheckin()}
                                                <div class="g-recaptcha" data-sitekey="{$recaptcha_sitekey}"></div>
                                            {/if}


									<div class="card-action">
										<div class="usercheck pull-left">
											{if $user->isAbleToCheckin() }

												<div id="checkin-btn">
													<button id="checkin" class="btn btn-brand btn-flat"><span class="icon">check</span>&nbsp;点我签到&nbsp;
													<div><span class="icon">screen_rotation</span>&nbsp;或者加telegram群签到</div>
													</button>
												</div>


											{else}

												<p><a class="btn btn-brand disabled btn-flat" href="#"><span class="icon">check</span>&nbsp;今日已签到</a></p>


											{/if}
										</div>
									</div>
										</dl>
									</div>

								</div>
							</div>

							<div class="card">
								<div class="card-main">
									<div class="card-inner">

										{*<div id="traffic_chart" style="height: 300px; width: 100%;"></div>

                                       <script src="/assets/js/canvasjs.min.js"> </script>
										<script type="text/javascript">
											var chart = new CanvasJS.Chart("traffic_chart",



											{
                                         theme: "light1",


												title:{
													text: "流量使用情况",
													fontFamily: "Impact",
													fontWeight: "normal"
													},
												legend:{
													verticalAlign: "bottom",
													horizontalAlign: "center"
												},
												data: [
												{
													startAngle: -15,
													indexLabelFontSize: 20,
													indexLabelFontFamily: "Garamond",
													indexLabelFontColor: "darkgrey",
													indexLabelLineColor: "darkgrey",
													indexLabelPlacement: "outside",
                                                    yValueFormatString: "##0.00\"%\"",
													type: "pie",
													showInLegend: true,
													dataPoints: [
														{if $user->transfer_enable != 0}
														{
															y: {$user->last_day_t/$user->transfer_enable*100},label: "过去已用", legendText:"过去已用 {number_format(($user->last_day_t + $user->u)/$user->transfer_enable*100,2)}% {$user->LastusedTraffic()}", indexLabel: "过去已用 {number_format(($user->last_day_t + $user->u)/$user->transfer_enable*100,2)}% {$user->LastusedTraffic()}"
														},
														{
															y: {($user->u+$user->d-$user->last_day_t)/$user->transfer_enable*100},label: "今日已用", legendText:"今日已用 {number_format(($user->d-$user->last_day_t)/$user->transfer_enable*100,2)}% {$user->TodayusedTraffic()}", indexLabel: "今日已用 {number_format(($user->d-$user->last_day_t)/$user->transfer_enable*100,2)}% {$user->TodayusedTraffic()}"
														},
														{
															y: {($user->transfer_enable-($user->u+$user->d))/$user->transfer_enable*100},label: "剩余可用", legendText:"剩余可用 {number_format(($user->transfer_enable-($user->u+$user->d))/$user->transfer_enable*100,2)}% {$user->unusedTraffic()}", indexLabel: "剩余可用 {number_format(($user->transfer_enable-($user->u+$user->d))/$user->transfer_enable*100,2)}% {$user->unusedTraffic()}"
														}
														{/if}
													]
												}
												]
											});

											chart.render();
										</script> *}

										<div class="progressbar">
	                                         <div class="before"></div>
	                                         <div class="bar tuse color3" style="width:calc({($user->transfer_enable==0)?0:($user->u+$user->d-$user->last_day_t)/$user->transfer_enable*100}%);"><span></span></div>
											 <div class="label-flex">
												<div class="label la-top"><div class="bar ard color3"><span></span></div><span class="traffic-info">今日已用</span><code class="card-tag tag-red">{$user->TodayusedTraffic()}</code></div>
											 </div>
										</div>
										<div class="progressbar">
										    <div class="before"></div>
										    <div class="bar ard color2" style="width:calc({($user->transfer_enable==0)?0:$user->last_day_t/$user->transfer_enable*100}%);"><span></span></div>
										    <div class="label-flex">
										       <div class="label la-top"><div class="bar ard color2"><span></span></div><span class="traffic-info">过去已用</span><code class="card-tag tag-orange">{$user->LastusedTraffic()}</code></div>
										    </div>
								        </div>
										<div class="progressbar">
											<div class="before"></div>
											<div class="bar remain color" style="width:calc({($user->transfer_enable==0)?0:($user->transfer_enable-($user->u+$user->d))/$user->transfer_enable*100}%);"><span></span></div>
											<div class="label-flex">
											   <div class="label la-top"><div class="bar ard color"><span></span></div><span class="traffic-info">剩余流量</span><code class="card-tag tag-green" id="remain">{$user->unusedTraffic()}</code></div>
											</div>
									   </div>


									</div>

								</div>
							</div>

								</div>
							</div>
						{include file='dialog.tpl'}

					</div>


				</div>
			</section>
		</div>
	</main>



<!-- {if empty($user->cncdn)}
<script>
alert("请设置您的 中转加速入口 加速您的网络 ");
</script>
{/if} -->



{include file='user/footer.tpl'}

<script src="/jscdn/npm/shake.js@1.2.2/shake.min.js"></script>

<script>
;(function(){
	'use strict'

	let onekeysubBTN = document.querySelectorAll('[data-onekeyfor]');
	for (let i=0;i<onekeysubBTN.length;i++) {
		onekeysubBTN[i].addEventListener('click',()=>{
			let onekeyId = onekeysubBTN[i].dataset.onekeyfor;
			AddSub(onekeyId);
		});
	}

	function AddSub(id){
		let url = document.getElementById(id).value;
		let tmp = window.btoa(url);
		tmp = tmp.substring(0,tmp.length);
		url = "sub://" + tmp + "#";
		window.location.href = url;
	}
})();
</script>

<script>

function DateParse(str_date) {
		var str_date_splited = str_date.split(/[^0-9]/);
		return new Date (str_date_splited[0], str_date_splited[1] - 1, str_date_splited[2], str_date_splited[3], str_date_splited[4], str_date_splited[5]);
}

/*
 * Author: neoFelhz & CloudHammer
 * https://github.com/CloudHammer/CloudHammer/make-sspanel-v3-mod-great-again
 * License: MIT license & SATA license
 */
function CountDown() {
    var levelExpire = DateParse("{$user->class_expire}");
    var accountExpire = DateParse("{$user->expire_in}");
    var nowDate = new Date();
    var a = nowDate.getTime();
    var b = levelExpire - a;
    var c = accountExpire - a;
    var levelExpireDays = Math.floor(b/(24*3600*1000));
    var accountExpireDays = Math.floor(c/(24*3600*1000));
    if (levelExpireDays < 0 || levelExpireDays > 315360000000) {
        document.getElementById('days-level-expire').innerHTML = "感谢您使用本站";
        for (var i=0;i<document.getElementsByClassName('label-level-expire').length;i+=1){
            document.getElementsByClassName('label-level-expire')[i].style.display = 'none';
        }
    } else {
        document.getElementById('days-level-expire').innerHTML = levelExpireDays;
    }
    if (accountExpireDays < 0 || accountExpireDays > 315360000000) {
        document.getElementById('days-account-expire').innerHTML = "感谢您使用本站";
        for (var i=0;i<document.getElementsByClassName('label-account-expire').length;i+=1){
            document.getElementsByClassName('label-account-expire')[i].style.display = 'none';
        }
    } else {
        document.getElementById('days-account-expire').innerHTML = accountExpireDays;
    }
}
</script>

<script>

$(function(){
	new Clipboard('.copy-text');
});

$(".copy-text").click(function () {
	$("#result").modal();
	$("#msg").html("已拷贝订阅链接，请您继续接下来的操作。");
});
$(function(){
	new Clipboard('.reset-link');
});

$(".reset-link").click(function () {
	$("#result").modal();
	$("#msg").html("已重置您的订阅链接，请变更或添加您的订阅链接！");
	window.setTimeout("location.href='/user/url_reset'", {$config['jump_delay']});
});

 {if $user->transfer_enable-($user->u+$user->d) == 0}
window.onload = function() {
    $("#result").modal();
    $("#msg").html("您的流量已经用完或账户已经过期了，如需继续使用，请进入商店选购新的套餐~");
};
 {/if}

{if $geetest_html == null}

var checkedmsgGE = '<p><a class="btn btn-brand disabled btn-flat waves-attach" href="#"><span class="icon">check</span>&nbsp;已签到</a></p>';
window.onload = function() {
    var myShakeEvent = new Shake({
        threshold: 15
    });

    myShakeEvent.start();
  	CountDown()

    window.addEventListener('shake', shakeEventDidOccur, false);

    function shakeEventDidOccur () {
		if("vibrate" in navigator){
			navigator.vibrate(500);
		}

        $.ajax({
                type: "POST",
                url: "/user/checkin",
                dataType: "json",{if $recaptcha_sitekey != null}
                data: {
                    recaptcha: grecaptcha.getResponse()
                },{/if}
                success: function (data) {
                    if (data.ret) {
					$("#checkin-msg").html(data.msg);
					$("#checkin-btn").html(checkedmsgGE);
					$("#result").modal();
					$("#msg").html(data.msg);
					$('#remain').html(data.traffic);
					$('.bar.remain.color').css('width',(data.unflowtraffic-({$user->u}+{$user->d}))/data.unflowtraffic*100+'%');
				} else {
					$("#result").modal();
					$("#msg").html(data.msg);
				}
                },
                error: function (jqXHR) {
					$("#result").modal();
                    $("#msg").html("发生错误：" + jqXHR.status);
                }
            });
    }
};


$(document).ready(function () {
	$("#checkin").click(function () {
		$.ajax({
			type: "POST",
			url: "/user/checkin",
			dataType: "json",{if $recaptcha_sitekey != null}
            data: {
                recaptcha: grecaptcha.getResponse()
            },{/if}
			success: function (data) {
				if (data.ret) {
					$("#checkin-msg").html(data.msg);
					$("#checkin-btn").html(checkedmsgGE);
					$("#result").modal();
					$("#msg").html(data.msg);
					$('#remain').html(data.traffic);
					$('.bar.remain.color').css('width',(data.unflowtraffic-({$user->u}+{$user->d}))/data.unflowtraffic*100+'%');
				} else {
					$("#result").modal();
					$("#msg").html(data.msg);
				}
			},
			error: function (jqXHR) {
				$("#result").modal();
				$("#msg").html("发生错误：" + jqXHR.status);
			}
		})
	})
})


{else}


window.onload = function() {
    var myShakeEvent = new Shake({
        threshold: 15
    });

    myShakeEvent.start();

    window.addEventListener('shake', shakeEventDidOccur, false);

    function shakeEventDidOccur () {
		if("vibrate" in navigator){
			navigator.vibrate(500);
		}

        c.show();
    }
};



var handlerPopup = function (captchaObj) {
	c = captchaObj;
	captchaObj.onSuccess(function () {
		var validate = captchaObj.getValidate();
		$.ajax({
			url: "/user/checkin", // 进行二次验证
			type: "post",
			dataType: "json",
			data: {
				// 二次验证所需的三个值
				geetest_challenge: validate.geetest_challenge,
				geetest_validate: validate.geetest_validate,
				geetest_seccode: validate.geetest_seccode
			},
			success: function (data) {
				if (data.ret) {
					$("#checkin-msg").html(data.msg);
					$("#checkin-btn").html(checkedmsgGE);
					$("#result").modal();
					$("#msg").html(data.msg);
					$('#remain').html(data.traffic);
					$('.bar.remain.color').css('width',(data.unflowtraffic-({$user->u}+{$user->d}))/data.unflowtraffic*100+'%');
				} else {
					$("#result").modal();
					$("#msg").html(data.msg);
				}
			},
			error: function (jqXHR) {
				$("#result").modal();
				$("#msg").html("发生错误：" + jqXHR.status);
			}
		});
	});
	// 弹出式需要绑定触发验证码弹出按钮
	//captchaObj.bindOn("#checkin")
	// 将验证码加到id为captcha的元素里
	captchaObj.appendTo("#popup-captcha");
	// 更多接口参考：http://www.geetest.com/install/sections/idx-client-sdk.html
};

initGeetest({
	gt: "{$geetest_html->gt}",
	challenge: "{$geetest_html->challenge}",
	product: "popup", // 产品形式，包括：float，embed，popup。注意只对PC版验证码有效
	offline: {if $geetest_html->success}0{else}1{/if} // 表示用户后台检测极验服务器是否宕机，与SDK配合，用户一般不需要关注
}, handlerPopup);



{/if}



</script>
{if $recaptcha_sitekey != null}<script src="https://recaptcha.net/recaptcha/api.js" async defer></script>{/if}
