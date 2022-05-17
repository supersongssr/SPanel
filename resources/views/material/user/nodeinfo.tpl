


{include file='user/header_info.tpl'}


{$ssr_prefer = URL::SSRCanConnect($user, $mu)}




	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">节点信息</h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner">
				<div class="ui-card-wrap">
					<div class="row">
						<div class="col-lg-12 col-sm-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner">
										<p class="card-heading">注意！</p>
										<p>配置文件以及二维码请勿泄露！</p>
									</div>

								</div>
							</div>
						</div>


						<div class="col-lg-12 col-sm-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner">
										<p class="card-heading">配置信息</p>
										<div class="tab-content">

											<nav class="tab-nav">
												<ul class="nav nav-list">
													<li {if $ssr_prefer}class="active"{/if}>
														<a class="" data-toggle="tab" href="#ssr_info"><i class="icon icon-lg">airplanemode_active</i>&nbsp;ShadowsocksR</a>
													</li>
													<li {if !$ssr_prefer}class="active"{/if}>
														<a class="" data-toggle="tab" href="#ss_info"><i class="icon icon-lg">flight_takeoff</i>&nbsp;Shadowsocks</a>
													</li>
												</ul>
											</nav>
											<div class="tab-pane fade {if $ssr_prefer}active in{/if}" id="ssr_info">
												
													{$ssr_item = URL::getItem($user, $node, $mu, $relay_rule_id, 0)}
													<p>服务器地址：{$ssr_item['address']}<br>
													服务器端口：{$ssr_item['port']}<br>
													加密方式：{$ssr_item['method']}<br>
													密码：{$ssr_item['passwd']}<br>
													协议：{$ssr_item['protocol']}<br>
													协议参数：{$ssr_item['protocol_param']}<br>
													混淆：{$ssr_item['obfs']}<br>
													混淆参数：{$ssr_item['obfs_param']}<br></p>
												
											</div>
											<div class="tab-pane fade {if !$ssr_prefer}active in{/if}" id="ss_info">
												
													{$ss_item = URL::getItem($user, $node, $mu, $relay_rule_id, 1)}
													<p>服务器地址：{$ss_item['address']}<br>
													服务器端口：{$ss_item['port']}<br>
													加密方式：{$ss_item['method']}<br>
													密码：{$ss_item['passwd']}<br>
													混淆：{$ss_item['obfs']}<br>
													混淆参数：{$ss_item['obfs_param']}<br></p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="col-lg-12 col-sm-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner">
										<p class="card-heading">配置Json</p>

										<nav class="tab-nav">
											<ul class="nav nav-list">
												<li {if $ssr_prefer}class="active"{/if}>
													<a class="" data-toggle="tab" href="#ssr_json"><i class="icon icon-lg">airplanemode_active</i>&nbsp;ShadowsocksR</a>
												</li>
												<li {if !$ssr_prefer}class="active"{/if}>
													<a class="" data-toggle="tab" href="#ss_json"><i class="icon icon-lg">flight_takeoff</i>&nbsp;Shadowsocks</a>
												</li>
											</ul>
										</nav>
										<div class="tab-pane fade {if $ssr_prefer}active in{/if}" id="ssr_json">
											
												
												<pre>
{
    "server": "{$ssr_item['address']}",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "timeout": 300,
    "workers": 1,
    "server_port": {$ssr_item['port']},
    "password": "{$ssr_item['passwd']}",
    "method": "{$ssr_item['method']}",
    "obfs": "{$ssr_item['obfs']}",
    "obfs_param": "{$ssr_item['obfs_param']}",
    "protocol": "{$ssr_item['protocol']}",
    "protocol_param": "{$ssr_item['protocol_param']}"
}
                                               </pre>
												
											
										</div>
										<div class="tab-pane fade {if !$ssr_prefer}active in{/if}" id="ss_json">
											
											<pre>
{
		"server": "{$ss_item['address']}",
		"local_address": "127.0.0.1",
		"local_port": 1080,
		"timeout": 300,
		"workers": 1,
		"server_port": {$ss_item['port']},
		"password": "{$ss_item['passwd']}",
		"method": "{$ss_item['method']}",
		"plugin": "{URL::getJsonObfs($ss_item)}"
}
</pre>
											
										</div>

									</div>

								</div>
							</div>
						</div>

						<div class="col-lg-12 col-sm-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner">
										<p class="card-heading">配置链接</p>

										<nav class="tab-nav">
											<ul class="nav nav-list">
												<li {if $ssr_prefer}class="active"{/if}>
													<a class="" data-toggle="tab" href="#ssr_url"><i class="icon icon-lg">airplanemode_active</i>&nbsp;ShadowsocksR</a>
												</li>
												<li {if !$ssr_prefer}class="active"{/if}>
													<a class="" data-toggle="tab" href="#ss_url"><i class="icon icon-lg">flight_takeoff</i>&nbsp;Shadowsocks</a>
												</li>
											</ul>
										</nav>
										<div class="tab-pane fade {if $ssr_prefer}active in{/if}" id="ssr_url">
											
												<p><a href="{URL::getItemUrl($ssr_item, 0)}"/>Android 手机上用默认浏览器打开点我就可以直接添加了(给 ShadowsocksR APP)</a></p>
												<p><a href="{URL::getItemUrl($ssr_item, 0)}"/>iOS 上用 Safari 打开点我就可以直接添加了(给 Shadowrocket)</a></p>
											
										</div>
										<div class="tab-pane fade {if !$ssr_prefer}active in{/if}" id="ss_url">
											
												<p><a href="{URL::getItemUrl($ss_item, 1)}"/>Android 手机上用默认浏览器打开点我就可以直接添加了(给 Shadowsocks)</a></p>
												<p><a href="{URL::getItemUrl($ss_item, 1)}"/>iOS 上用 Safari 打开点我就可以直接添加了(给 Shadowrocket)</a></p>
										
										</div>
									</div>

								</div>
							</div>
						</div>

						<div class="col-lg-12 col-sm-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner">
										<p class="card-heading">配置二维码</p>


										<nav class="tab-nav">
											<ul class="nav nav-list">
												<li {if $ssr_prefer}class="active"{/if}>
													<a class="" data-toggle="tab" href="#ssr_qrcode"><i class="icon icon-lg">airplanemode_active</i>&nbsp;ShadowsocksR</a>
												</li>
												<li {if !$ssr_prefer}class="active"{/if}>
													<a class="" data-toggle="tab" href="#ss_qrcode"><i class="icon icon-lg">flight_takeoff</i>&nbsp;Shadowsocks</a>
												</li>
											</ul>
										</nav>
										<div class="tab-pane fade {if $ssr_prefer}active in{/if}" id="ssr_qrcode">
											
												<div class="text-center">
													<div id="ss-qr-n" class="qr-center"></div>
												</div>
											
										</div>
										<div class="tab-pane fade {if !$ssr_prefer}active in{/if}" id="ss_qrcode">
											
												<nav class="tab-nav">
													<ul class="nav nav-list">
														<li class="active">
															<a class="" data-toggle="tab" href="#ss_qrcode_normal"><i class="icon icon-lg">android</i>&nbsp;其他平台</a>
														</li>
														<li>
															<a class="" data-toggle="tab" href="#ss_qrcode_win"><i class="icon icon-lg">desktop_windows</i>&nbsp;Windows</a>
														</li>
													</ul>
												</nav>
												<div class="tab-pane fade active in" id="ss_qrcode_normal">
													<div class="text-center">
														<div id="ss-qr" class="qr-center"></div>
													</div>
												</div>
												<div class="tab-pane fade" id="ss_qrcode_win">
													<div class="text-center">
														<div id="ss-qr-win" class="qr-center"></div>
													</div>
												</div>
											
										</div>
									</div>

								</div>
							</div>
						</div>



					</div>
				</div>
			</section>
		</div>
	</main>







{include file='user/footer.tpl'}


<script src="/jscdn/gh/davidshimjs/qrcodejs@gh-pages/qrcode.min.js"></script>
<script>
	{if URL::SSCanConnect($user, $mu)}
    var text_qrcode = '{URL::getItemUrl($ss_item, 1)}',
        text_qrcode_win = '{URL::getItemUrl($ss_item, 2)}';

    var qrcode1 = new QRCode(document.getElementById("ss-qr"),{ correctLevel: 3 }),
        qrcode2 = new QRCode(document.getElementById("ss-qr-win"),{ correctLevel: 3 });
	

    qrcode1.clear();
    qrcode1.makeCode(text_qrcode);
    qrcode2.clear();
    qrcode2.makeCode(text_qrcode_win);
	{/if}

	{if URL::SSRCanConnect($user, $mu)}
    var text_qrcode2 = '{URL::getItemUrl($ssr_item, 0)}';
    var qrcode3 = new QRCode(document.getElementById("ss-qr-n"),{ correctLevel: 3 });
    qrcode3.clear();
    qrcode3.makeCode(text_qrcode2);
	{/if}


</script>
