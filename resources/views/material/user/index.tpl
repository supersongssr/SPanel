
{include file='user/main.tpl'}
{$ssr_prefer = URL::SSRCanConnect($user, 0)}

	<main class="content">

		<div class="content-header ui-content-header">
			<div class="container">
				<!-- song -->
				<h1 class="content-heading">用户中心 ★ {$baseUrl}</h1>
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
													{if $user->class>2}
													<dd>VIP {$user->class}</dd>
													{else}
													<dd>免费公益</dd>
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
										{if $user->class>2}
											<span><i class="icon icon-md">add_circle</i>捐赠用户，邀请返利</span>
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
													{$user->money} 捐赠
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
											<span><i class="icon icon-md">donut_large</i>在线设备/设备限制数</span>
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

							<div class="card">
								<div class="card-main">
									<div class="card-inner margin-bottom-no">
                                    <p class="card-heading"> <i class="icon icon-md">notifications_active</i>公告栏 ★ {$baseUrl}</p>
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


							<div class="card quickadd">
								<div class="card-main">
									<div class="card-inner margin-bottom-no">
									<div class="cardbtn-edit">
											<div class="card-heading"><i class="icon icon-md">phonelink</i> 快速添加节点 ★ 技术支持提交工单</div><br>
											<div class="reset-flex"><span>重置订阅链接</span><a class="reset-link btn btn-brand-accent btn-flat" ><i class="icon">autorenew</i>&nbsp;</a></div>
											<p>☆本站支持SS 、SR 、V.2 同时使用。<br><code>☆V.2</code>：支持多种协议tcp/udp/mkcp支持。<br>备注：本站v.2采用多采用 mKCP/udp提高速度，但udp/mkcp可能会被部分地区运营商 Qos 限速。<br><code>☆SR</code>：tcp协议，支持伪装、破限速，最新chain协议。<br><code>☆SSD</code>：最新ahead加密支持！订阅支持！</p>
									</div>
										<nav class="tab-nav margin-top-no">
											<ul class="nav nav-list">
												<li >
													<a class="" data-toggle="tab" href="#all_ssr"><i class="icon icon-lg">airplanemode_active</i>&nbsp;SR ★★★★</a>
												</li>
												<li >
													<a class="" data-toggle="tab" href="#all_ss"><i class="icon icon-lg">flight_takeoff</i>&nbsp;SS/SD ★</a>
												</li>
												<li class="active">
													<a class="" data-toggle="tab" href="#all_v2ray"><i class="icon icon-lg">flight_land</i>&nbsp;V.2 ★★★★★</a>
												</li>
											</ul>
										</nav>
										<div class="card-inner">
											<div class="tab-content">
												<div class="tab-pane fade" id="all_ssr">
													{$pre_user = URL::cloneUser($user)}

													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li >
																<a class="" data-toggle="tab" href="#all_ssr_windows"><i class="icon icon-lg">desktop_windows</i>&nbsp;Windows</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ssr_mac"><i class="icon icon-lg">laptop_mac</i>&nbsp;MacOS</a>
															</li>
                                                          <li>
																<a class="" data-toggle="tab" href="#all_ssr_linux"><i class="icon icon-lg">dvr</i>&nbsp;Linux</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ssr_ios"><i class="icon icon-lg">phone_iphone</i>&nbsp;iOS</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ssr_android"><i class="icon icon-lg">android</i>&nbsp;Android</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ssr_router"><i class="icon icon-lg">router</i>&nbsp;路由器</a>
															</li>
                                                          <li>
																<a class="" data-toggle="tab" href="#all_ssr_game"><i class="icon icon-lg">videogame_asset</i>&nbsp;游戏端</a>
															</li>
             												<li class="active">
																<a class="" data-toggle="tab" href="#all_ssr_info"><i class="icon icon-lg">info_outline</i>&nbsp;连接信息</a>
															</li>
														</ul>
													</nav>

													<div class="tab-pane fade active in" id="all_ssr_windows">
	                                                        {$user = URL::getSSRConnectInfo($pre_user)}
															{$ssr_url_all = URL::getAllUrl($pre_user, 0, 0)}
															{$ssr_url_all_mu = URL::getAllUrl($pre_user, 1, 0)}
															<p><span class="icon icon-lg text-white">flash_auto</span> ★SR订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><br></p>
															<p><span class="icon icon-lg text-white">filter_1</span><a href="/ssr-download/ssr-win.zip"> 点击下载SR</a> 或者<a href="/ssr-download/ssrr-win.zip"> 或者SR（SR升级版，但是不支持在安装有360 百度的电脑上运行）</a>，解压至任意磁盘并运行</a></p>
															<p><span class="icon icon-lg text-white">filter_2</span> 任务栏右下角右键纸飞机图标->服务器订阅->SR服务器订阅设置，将订阅链接设置为下面的地址，确定之后再更新SR服务器订阅（绕过代理）</p>
															<p> <span class="icon icon-lg text-white">filter_3</span> 然后选择一个合适的服务器，代理规则选“绕过局域网和大陆”，然后即可上网</p>
															<p><span class="icon icon-lg text-white">filter_4</span> 备用导入节点方法：点击<a class="copy-text" data-clipboard-text="{$ssr_url_all_mu}">这个</a>，然后右键小飞机->从剪贴板复制地址</p>
	                                                       <p><a href="/user/tutorial">点击这里查看Windows傻瓜式教程</a></p>
													</div>
													<div class="tab-pane fade" id="all_ssr_mac">
														<p><span class="icon icon-lg text-white">flash_auto</span> ★SR订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><br></p>
														<p><span class="icon icon-lg text-white">filter_1</span><a href="/ssr-download/ssr-mac.dmg"> 点击下载</a>，并打开</p>
                                                 	    <p><span class="icon icon-lg text-white">filter_2</span> 把S***socksX拖入到Finder的应用程序列表(Applications)</p>
                                                  		<p><span class="icon icon-lg text-white">filter_3</span> 打开Launchapad里的S***socksX</p>
                                                  		<p><span class="icon icon-lg text-white">filter_4</span> 菜单栏的纸飞机图标-服务器-服务器订阅填入以下订阅地址，更新后出现您的节点</p>
                                                      <p><span class="icon icon-lg text-white">filter_5</span> 菜单栏的纸飞机图标-打开s***socks</p>
                                                      <p><a href="/user/tutorial">点击这里查看Mac傻瓜式教程</a></p>
													</div>
                                                  <div class="tab-pane fade" id="all_ssr_linux">
                                                      <p><a href="/user/tutorial">点击这里查看Linux傻瓜式教程</a></p>
													  <p><span class="icon icon-lg text-white">flash_auto</span> ★SR订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><br></p>
													</div>
													<div class="tab-pane fade" id="all_ssr_ios">
														<p><span class="icon icon-lg text-white">flash_auto</span> ★SR订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><br></p>
														<p><span class="icon icon-lg text-white">filter_1</span> 在 Safari 中<a class="btn-dl" href="itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/xcxnig/ssr-download/master/potatso-lite.plist"><i class="material-icons">save_alt</i> 点击安装 Potatso Lite</a></p>
														<p><span class="icon icon-lg text-white">filter_2</span> 打开 Potatso Lite，点击添加代理，点击右上角的 + 号，选择“订阅”，名字任意填写，开启自动更新，URL填写订阅地址并保存即可</p>
														<hr>
														<p><span class="icon icon-lg text-white">filter_1</span> iOS端需要用爱思助手来安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span> <a href="/ssr-download/Shadowrocket_2.1.12.ipa" target="_blank">点击此处</a>下载iOS客户端的ipa安装文件</p>
                                                      	<p><span class="icon icon-lg text-white">filter_3</span>  <a href="https://www.i4.cn/news_detail_3339.html" target="_blank">点击此处</a>查看爱思助手安装ipa文件教程</p>
														<p><span class="icon icon-lg text-white">filter_4</span> 打开Shadowrocket，点击右上角<span class="icon icon-lg text-white">add</span>，添加类型为<code>Subscribe</code>，URL填写订阅地址即可自动更新节点</p>
														
                                                      <p><a href="/user/tutorial">点击这里查看iOS傻瓜式教程</a></p>
													</div>
													<div class="tab-pane fade" id="all_ssr_android">
														<p><span class="icon icon-lg text-white">flash_auto</span> ★SR订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><br></p>
														<p><span class="icon icon-lg text-white">filter_1</span>点击下载<a href="/ssr-download/ssr-android.apk"> SR </a> 或 <a href="/ssr-download/ssrr-android.apk"> SRR </a> 并安装</p>
                                                      	<p><span class="icon icon-lg text-white">filter_2</span> 打开App，点击右下角的<span class="icon icon-lg text-white">add</span>号图标</p>
                                                        <p><span class="icon icon-lg text-white">filter_3</span> 添加/升级 SR订阅</p>
                                                          <p><span class="icon icon-lg text-white">filter_4</span> 添加订阅地址，输入以下订阅地址后确定</p>
                                                      	<p><span class="icon icon-lg text-white">filter_5</span> 订阅出现系统自带的与{$config["appName"]}，请把系统自带的无效订阅左滑删除（自带影响订阅更新速度）</p>
                                                       	<p><span class="icon icon-lg text-white">filter_6</span> 点击确定并升级</p>
                                                      	<p><span class="icon icon-lg text-white">filter_7</span> 点击选择任意节点， 路由选择：略过区域网路以及中国大陆</p>
                                                        <p><span class="icon icon-lg text-white">filter_8</span> 点击右上角的纸飞机图标即可连接</p>
														<p><span class="icon icon-lg text-white">filter_9</span> 备用导入节点方法：在手机上默认浏览器中点击<a href="{$ssr_url_all_mu}">这个链接（单端口多用户）</a>，然后点击确定</p>
														
                                                      <p><a href="/user/tutorial">点击这里查看Android傻瓜式教程</a></p>
													</div>
													<div class="tab-pane fade" id="all_ssr_router">
														<p><span class="icon icon-lg text-white">flash_auto</span> ★SR订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><br></p>
													<p>梅林：</p>
													<p><span class="icon icon-lg text-white">filter_1</span><a href="https://github.com/hq450/fancyss_history_package" class="btn-dl"><i class="material-icons">save_alt</i> 进入下载页面 </a> 下载“科学上网”插件</p>
                                                      <p><span class="icon icon-lg text-white">filter_2</span> 进入路由器管理页面->系统管理->勾选“Format JFFS partition at next boot”和“Enable JFFS custom scripts and configs”->应用本页面设置，重启路由器</p>
                                                        <p><span class="icon icon-lg text-white">filter_3</span> 进入路由器管理页面->软件中心->离线安装，上传插件文件进行安装</p>
                                                          <p><span class="icon icon-lg text-white">filter_4</span> 进入“科学上网”插件->更新管理，将下方的订阅地址复制粘贴进去，点击“保存并订阅”</p>
                                                      <p><span class="icon icon-lg text-white">filter_5</span> 账号设置->节点选择，选择一个节点，打开“科学上网”开关->保存&应用</p>
                                                       <p>padavan：</p>
                                                      <p><span class="icon icon-lg text-white">filter_1</span> 进入路由器管理页面->扩展功能->Shadowsocks</p>
                                                        <p><span class="icon icon-lg text-white">filter_2</span> 将下方的订阅地址填入“ssr服务器订阅”，点击“更新”</p>
														<p><span class="icon icon-lg text-white">filter_3</span> 选择需要的节点（右方勾选）->应用主SS->打开上方的开关</p>
														
													</div>
                                                    <div class="tab-pane fade" id="all_ssr_game">
                                                    	<p><span class="icon icon-lg text-white">flash_auto</span> ★SR订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=1?max=17" ><br></p>
														 <p><span class="icon icon-lg text-white">filter_1</span><a href="/ssr-download/SSTap.7z" class="btn-dl"><i class="material-icons">save_alt</i> 点击下载SSTap</a>，并安装</p>
                                                       <p><span class="icon icon-lg text-white">filter_2</span> 期间会安装虚拟网卡，请点击允许或确认</p>
                                                       <p><span class="icon icon-lg text-white">filter_3</span> 打开桌面程序SSTap</p>
                                                       <p><span class="icon icon-lg text-white">filter_4</span> 齿轮图标-SSR订阅-SSR订阅管理添加以下订阅链接即可</p>
                                                       <p><span class="icon icon-lg text-white">filter_5</span> 更新后选择其中一个节点闪电图标测试节点-测试UDP转发...通过!（UDP通过即可连接并开始游戏），如测试不通过，点击齿轮图标设置DNS，推荐谷歌DNS</p>
														
                                                      <p><a href="/user/tutorial">点击这里查看游戏客户端傻瓜式教程</a></p>
													</div>
                                                  <div class="tab-pane fade" id="all_ssr_info">
														{$user = URL::getSSRConnectInfo($pre_user)}
														{$ssr_url_all = URL::getAllUrl($pre_user, 0, 0)}
														{$ssr_url_all_mu = URL::getAllUrl($pre_user, 1, 0)}
														<!-- 
														{if URL::SSRCanConnect($user)}
													-->
														<dl class="dl-horizontal">
                                                          <p><dt><code>优先导入普通端口，如果普通端口无法使用再导入单端口</code></dt></p>
															<p><dt>端口</dt>
															<dd>{$user->port}</dd></p>
															<p><dt>密码</dt>
															<dd>{$user->passwd}</dd></p>
															<p><dt>自定义加密</dt>
															<dd>{$user->method}</dd></p>
															<p><dt>自定义协议</dt>
															<dd>{$user->protocol}</dd></p>
															<p><dt>自定义混淆</dt>
															<dd>{$user->obfs}</dd></p>
															<p><dt>自定义混淆参数</dt>
															<dd>{$user->obfs_param}</dd></p>
														</dl>
														<!--
														{else}
															<p>您好，您目前的 加密方式，混淆，或者协议设置在 ShadowsocksR 客户端下无法连接。请您选用 Shadowsocks 客户端来连接，或者到 资料编辑 页面修改后再来查看此处</p>
															<p>同时, ShadowsocksR 单端口多用户的连接不受您设置的影响,您可以在此使用相应的客户端进行连接~</p>
															<p>请注意，在当前状态下您的 SSR 订阅链接已经失效，您无法通过此种方式导入节点</p>
														{/if}
													-->
													</div>
												</div>

												<div class="tab-pane fade " id="all_ss">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li >
																<a class="" data-toggle="tab" href="#all_ss_windows"><i class="icon icon-lg">desktop_windows</i>&nbsp;Windows</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ss_mac"><i class="icon icon-lg">laptop_mac</i>&nbsp;MacOS</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ss_ios"><i class="icon icon-lg">laptop_mac</i>&nbsp;iOS</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ss_android"><i class="icon icon-lg">android</i>&nbsp;Android</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_ss_router"><i class="icon icon-lg">router</i>&nbsp;路由器</a>
															</li>
															<li class="active">
																<a class="" data-toggle="tab" href="#all_ss_info"><i class="icon icon-lg">info_outline</i>&nbsp;连接信息</a>
															</li>
														</ul>
													</nav>
													<div class="tab-pane fade  active in" id="all_ss_info">
														{$user = URL::getSSConnectInfo($pre_user)}
														{$ss_url_all_mu = URL::getAllUrl($pre_user, 1, 1)}
														{$ss_url_all = URL::getAllUrl($pre_user, 0, 2)}														
														{$ssd_url_all =URL::getAllSSDUrl($user)}
														<!-- 
														{if URL::SSCanConnect($user)}
													-->
														<dl class="dl-horizontal">
															<p>各个节点的地址请到节点列表查看！</p>
															<p><dt>端口</dt>
															<dd>{$user->port}</dd></p>
															<p><dt>密码</dt>
															<dd>{$user->passwd}</dd></p>
															<p><dt>自定义加密</dt>
															<dd>{$user->method}</dd></p>
															<p><dt>自定义混淆</dt>
															<dd>{$user->obfs}</dd></p>
															<p><dt>自定义混淆参数</dt>
															<dd>{$user->obfs_param}</dd></p>
														</dl>
														<!-- 
														{else}
															<p>您好，您目前的 加密方式，混淆，或者协议设置在 SS 客户端下无法连接。请您选用 SSR 客户端来连接，或者到 资料编辑 页面修改后再来查看此处</p>
															<p>同时, Shadowsocks 单端口多用户的连接不受您设置的影响,您可以在此使用相应的客户端进行连接~</p>
														{/if}
													-->
													</div>
													<div class="tab-pane fade" id="all_ss_windows">
														<p><span class="icon icon-lg text-white">flash_auto</span> SS订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=3" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=3" ><br></p>
														<p><span class="icon icon-lg text-white">filter_1</span><a href="/ssr-download/ssd-win.7z" class="btn-dl"><i class="material-icons">save_alt</i> 点击下载 SSD</a>，解压至任意磁盘并运行</p>
														<p><span class="icon icon-lg text-white">filter_2</span> 任务栏右下角右键纸飞机图标->服务器订阅->SSD服务器订阅设置，将订阅链接设置订阅地址，确定之后再更新SSD服务器订阅</p>
														<p><span class="icon icon-lg text-white">filter_3</span> 然后选择一个合适的服务器，代理规则选“绕过局域网和大陆”，然后即可上网</p>
														<p><span class="icon icon-lg text-white">filter_4</span> 备用导入节点方法：<a class="copy-text btn-dl" data-clipboard-text='{$ssd_url_all}'><i class="material-icons icon-sm">how_to_vote</i>点我复制链接</a>，然后右键小飞机->从剪贴板复制地址</p>
														
													</div>
													<div class="tab-pane fade" id="all_ss_mac">
														<p><span class="icon icon-lg text-white">filter_1</span><a href="/ssr-download/ss-mac.zip" class="btn-dl"><i class="material-icons">save_alt</i> 点击下载 ShadowsocksX-NG</a>，并安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span> <a class="copy-text btn-dl" data-clipboard-text='{$ss_url_all}'><i class="material-icons icon-sm">how_to_vote</i>点我复制链接</a>，然后右击托盘小飞机图标->从剪贴板导入服务器配置链接</p>
														<p><span class="icon icon-lg text-white">filter_3</span> 再次右击托盘小飞机图标->服务器，选择一个服务器即可上网</p>
													</div>
													<div class="tab-pane fade" id="all_ss_ios">													
													<p><span class="icon icon-lg text-white">filter_1</span> 在 Safari 中<a class="btn-dl" href="itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/xcxnig/ssr-download/master/potatso-lite.plist"><i class="material-icons">save_alt</i> 点击安装 Potatso Lite</a></p>
														<p><span class="icon icon-lg text-white">filter_2</span> 打开 Potatso Lite，点击添加代理，点击右上角的 + 号，打开<a href="/user/node">节点列表</a>，点开自己需要的节点详情，自行导入节点</p>
														<hr>
														<p><span class="icon icon-lg text-white">filter_1</span> iOS端需要用爱思助手来安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span> <a href="/ssr-download/Shadowrocket_2.1.12.ipa" target="_blank">点击此处</a>下载iOS客户端的ipa安装文件</p>
                                                      	<p><span class="icon icon-lg text-white">filter_3</span>  <a href="https://www.i4.cn/news_detail_3339.html" target="_blank">点击此处</a>查看爱思助手安装ipa文件教程</p>
														<p><span class="icon icon-lg text-white">filter_4</span> 打开<a href="/user/node">节点列表</a>，点开自己需要的节点详情，自行导入节点</p>
													</div>
													<div class="tab-pane fade" id="all_ss_android">
														<p><span class="icon icon-lg text-white">flash_auto</span> SS订阅：<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=3" ><input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=3" ><br></p>
														<p><span class="icon icon-lg text-white">filter_1</span><a href="/ssr-download/ssd-android.apk" class="btn-dl"><i class="material-icons">save_alt</i> 点击下载 SSD</a>，<a href="/ssr-download/ss-android-obfs.apk" class="btn-dl"><i class="material-icons">save_alt</i> 点击下载 SS 混淆插件</a></p>
														<p><span class="icon icon-lg text-white">filter_2</span> 安装后，在手机上点击复制下方的订阅链接</a></p>
														<p><span class="icon icon-lg text-white">filter_3</span> 打开 ShadowsocksD 客户端，点击右上角的“加号”，选择“添加订阅”，将剪贴板中的内容粘贴进去，点击“OK”，稍等片刻即可看见订阅的节点</p>
														
													</div>
													<div class="tab-pane fade" id="all_ss_router">
														<p>梅林：</p>
													<p><span class="icon icon-lg text-white">filter_1</span><a href="https://github.com/hq450/fancyss_history_package" class="btn-dl"><i class="material-icons">save_alt</i> 进入下载页面 </a> 下载“科学 上网”插件</p>
                                                      <p><span class="icon icon-lg text-white">filter_2</span> 进入路由器管理页面->系统管理->勾选“Format JFFS partition at next boot”和“Enable JFFS custom scripts and configs”->应用本页面设置，重启路由器</p>
                                                        <p><span class="icon icon-lg text-white">filter_3</span> 进入路由器管理页面->软件中心->离线安装，上传插件文件进行安装</p>
                                                          <p><span class="icon icon-lg text-white">filter_4</span> 进入“科学上网”插件->节点管理，手动添加节点，打开“科学上网”开关->保存&应用</p>
                                                       <p>padavan：</p>
                                                      <p><span class="icon icon-lg text-white">filter_1</span> 进入路由器管理页面->扩展功能->Shadowsocks</p>
														<p><span class="icon icon-lg text-white">filter_2</span> 手动添加需要的节点并勾选->应用主SS->打开上方的开关</p>
													</div>
												</div>

												<div class="tab-pane fade active in" id="all_v2ray">
													<nav class="tab-nav margin-top-no">
														<ul class="nav nav-list">
															<li >
																<a class="" data-toggle="tab" href="#all_v2ray_windows"><i class="icon icon-lg">desktop_windows</i>&nbsp;Windows</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_v2ray_ios"><i class="icon icon-lg">laptop_mac</i>&nbsp;iOS</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_v2ray_android"><i class="icon icon-lg">android</i>&nbsp;Android</a>
															</li>
															<li>
																<a class="" data-toggle="tab" href="#all_v2_mac"><i class="icon icon-lg">laptop_mac</i>&nbsp;MacOS</a>
															</li>
															<li class="active">
																<a class="" data-toggle="tab" href="#all_v2ray_info"><i class="icon icon-lg">info_outline</i>&nbsp;连接信息</a>
															</li>
														</ul>
													</nav>
													<div class="tab-pane fade" id="all_v2ray_windows">
														{$v2_url_all = URL::getAllVMessUrl($user)}
														<p><span class="icon icon-lg text-white">filter_1</span>假如您的电脑为64位，请<a href="/ssr-download/v2ray_x64.zip">下载64位版</a>，否则请<a href="/ssr-download/v2ray_x86.zip">下载32位版</a>，下载后解压，运行程序<code>v.2rayN.exe</code></p>
														<p><span class="icon icon-lg text-white">filter_2</span> 双击任务栏右下角V.2RayN图标->订阅->订阅设置->添加->填入下方的地址，点击确定</p>
														<p><span class="icon icon-lg text-white">filter_3</span> 再次点击订阅->更新订阅，右击任务栏右下角V2RayN图标->启动Http代理</p>
														<p><span class="icon icon-lg text-white">filter_4</span> 自行选择“Http代理模式”和“服务器”</p>
														<p> 也可以使用ClashX进行连接，<a href="/ssr-download/Clash-Windows.7z" class="btn-dl"><i class="material-icons">save_alt</i> 点击下载 ClashX</a></p>
														<span class="icon icon-lg text-white">flash_auto</span> 
														V.2 All Vmess链接：
														<br><textarea>{$v2_url_all}</textarea><br>
														V.2 RSS订阅地址：
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=2"/>
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=2"/>
														</p>
													</div>
													<div class="tab-pane fade" id="all_v2ray_ios">
														<p><span class="icon icon-lg text-white">filter_1</span> 推荐安装：在非国区AppStore中搜索<code>kitsunebi</code>下载安装 </p>
														<p><span class="icon icon-lg text-white">filter_1</span> 或者安装：小火箭（不支持本站kcp节点）需要用爱思助手来安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span> <a href="/ssr-download/Shadowrocket_2.1.12.ipa" target="_blank">点击此处</a>下载iOS客户端的ipa安装文件</p>
                                                      	<p><span class="icon icon-lg text-white">filter_3</span>  <a href="https://www.i4.cn/news_detail_3339.html" target="_blank">点击此处</a>查看爱思助手安装ipa文件教程</p>
														<p><span class="icon icon-lg text-white">filter_4</span> 打开 Shadowrocket，点击右上角的 + 号，类型选择“Subscribe”，URL填写以下地址并点击右上角完成即可。或使用<a href="javascript:void(0);" class="btn-dl" style="margin-left: 5px;" data-onekeyfor="v2sub"><i class="material-icons icon-sm">how_to_vote</i>小火箭一键订阅</a> </p>
														<span class="icon icon-lg text-white">flash_auto</span> 
														V.2 All Vmess链接：
														<br><textarea>{$v2_url_all}</textarea><br>
														V.2 RSS订阅地址：
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=2"/>
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=2"/>
														</p>
													</div>
													<div class="tab-pane fade" id="all_v2ray_android">
														<p><span class="icon icon-lg text-white">filter_1</span><a href="/ssr-download/v2rayng.apk" class="btn-dl"><i class="material-icons">save_alt</i> 点击下载 V.2RayNG</a>并安装</p>
														<p><span class="icon icon-lg text-white">filter_2</span> 点击左上角菜单按钮展开菜单->订阅设置->点击右上角“+”，URL填写以下地址并点击右上角“√”保存</p>
														<p><span class="icon icon-lg text-white">filter_3</span> 回到软件主界面->点击右上角“更多”按钮->更新订阅</p>
														<p><span class="icon icon-lg text-white">filter_4</span> 选择一个节点，点击右下角按钮订阅</p>
														<span class="icon icon-lg text-white">flash_auto</span> 
														V.2 All Vmess链接：
														<br><textarea>{$v2_url_all}</textarea><br>
														V.2 RSS订阅地址：
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=2"/>
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=2"/>
														</p>
													</div>
													<div class="tab-pane fade" id="all_v2_mac">
                                                      <p><a href="https://233blog.com/post/25/" target="_blank">点此查看MAC详细使用教程</a></p>
														<p><a href="/ssr-download/V2RayX.app.zip">下载</a>，解压，将 V2RayX.app 复制到 程序 文件夹，然后点击网站内菜单---节点列表，点击您想要添加的节点名称，在V2RayX里添加
														<br></p>
														<p>
														<span class="icon icon-lg text-white">flash_auto</span> 
														V.2 All Vmess链接：
														<br><textarea>{$v2_url_all}</textarea><br>
														V.2 RSS订阅地址：
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=2"/>
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=2"/>
                                                      	</p>
													</div>
													<div class="tab-pane fade active in" id="all_v2ray_info">
														
														<p>
														<span class="icon icon-lg text-white">flash_auto</span> 
														V.2 All Vmess链接：
														<br><textarea>{$v2_url_all}</textarea><br>
														V.2 RSS订阅地址：
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$subUrl}/link/{$ssr_sub_token}?mu=2"/>
														<input type="text" class="input form-control form-control-monospace" name="input1" value="{$baseUrl}/link/{$ssr_sub_token}?mu=2"/>
														</p>
														<br>
														</div>
													</div>
												</div>
											</div>
										</div>

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
                                              <dd><i class="icon icon-md">event</i>&nbsp;不过期</dd>
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
													<div><span class="icon">screen_rotation</span>&nbsp;或者加本站TG群快速签到</div>
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
															y: {$user->last_day_t/$user->transfer_enable*100},label: "过去已用", legendText:"过去已用 {number_format($user->last_day_t/$user->transfer_enable*100,2)}% {$user->LastusedTraffic()}", indexLabel: "过去已用 {number_format($user->last_day_t/$user->transfer_enable*100,2)}% {$user->LastusedTraffic()}"
														},
														{
															y: {($user->u+$user->d-$user->last_day_t)/$user->transfer_enable*100},label: "今日已用", legendText:"今日已用 {number_format(($user->u+$user->d-$user->last_day_t)/$user->transfer_enable*100,2)}% {$user->TodayusedTraffic()}", indexLabel: "今日已用 {number_format(($user->u+$user->d-$user->last_day_t)/$user->transfer_enable*100,2)}% {$user->TodayusedTraffic()}"
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







{include file='user/footer.tpl'}

<script src="https://cdn.jsdelivr.net/npm/shake.js@1.2.2/shake.min.js"></script>

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
        document.getElementById('days-level-expire').innerHTML = "无限期";
        for (var i=0;i<document.getElementsByClassName('label-level-expire').length;i+=1){
            document.getElementsByClassName('label-level-expire')[i].style.display = 'none';
        }
    } else {
        document.getElementById('days-level-expire').innerHTML = levelExpireDays;
    }
    if (accountExpireDays < 0 || accountExpireDays > 315360000000) {
        document.getElementById('days-account-expire').innerHTML = "无限期";
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
