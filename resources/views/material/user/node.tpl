{include file='user/main.tpl'}

<script src="/jscdn/gh/SuicidalCat/canvasjs.js@v2.3.1/canvasjs.min.js"></script>
<script src="/jscdn/npm/jquery@3.3.1.js"></script>
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>

<main class="content">
	<div class="content-header ui-content-header">
		<div class="container">
			<h1 class="content-heading">节点列表</h1>
		</div>
	</div>

	<div class="container">
		<section class="content-inner margin-top-no">
			<div class="ui-card-wrap">
				<div class="row">
					<div class="col-lg-12 col-sm-12 nodelist">
							
							<!--- <div class="ui-switch node-switch">
								<div class="card">
									<div class="card-main">
										<div class="card-inner ui-switch">
											<div class="switch-btn" id="switch-cards"><a href="#" onclick="return false"><i class="mdui-icon material-icons">apps</i></a></div>
											<div class="switch-btn" id="switch-table"><a href="#" onclick="return false"><i class="mdui-icon material-icons">dehaze</i></a></div>
										</div>
									</div>
								</div>
							</div> -->
						
                    <div class="node-cardgroup" style="display: grid;">
                        {$class=-1}
						{foreach $nodes as $node}
						{if $node['node_class']!=$class}
							{$class=$node['node_class']}
							{if !$node@first}</div>{/if}
							<div class="nodetitle">
								<a class="waves-effect waves-button" data-toggle="collapse" href="#cardgroup{$class}" aria-expanded="true" aria-controls="cardgroup{$class}">
								<span>{if $class == 0}公告消息{else}VIP {$node['node_class']} 节点{/if}</span><i class="material-icons">expand_more</i>
								</a>
							</div>
							<div class="card-row collapse in" id="cardgroup{$class}">
						{/if}
						<div class="node-card node-flex" cardindex="{$node@index}">
                            <div class="nodemain">
                                <div class="nodehead node-flex">
                                    <!-- {if $config['enable_flag']=='true'}<div class="flag"><img src="/images/prefix/v2ray.png" alt=""></div>{/if} -->
                                    <i class="material-icons node-icon">public </i>
									<div class="nodename"> {$node['name']}_@{$node['id']}</div>
                                </div>
                                <div class="nodemiddle node-flex">
                                    
                                    <div class="nodetype node-flex"><i class="material-icons node-icon">notifications_none</i>{$node['info']}</div>
                                </div>
                                <div class="nodeinfo node-flex">
									
                                    <div class="nodetraffic node-flex"><i class="material-icons node-icon">equalizer</i><span>{floor($node['node_bandwidth']/1000000000)}GB</span></div>
                                    <div class="onlinemember node-flex"><i class="material-icons node-icon">person_add</i><span>{$node->node_online}</span></div>
									<div class="nodecheck node-flex">
                                        <i class="material-icons node-icon">network_check</i><span>x{$node['traffic_rate']}</span>
                                    </div>
                                    <!-- <div class="nodeband node-flex"><i class="material-icons node-icon">flight</i><span>{date('Y-m-d H:i:s', $node['node_heartbeat'])}</span></div> -->
                                </div>
                            </div>
                            <div class="nodestatus">
                                <div class="nodeonline">
                                    <i class="material-icons">tune</i>
                                </div>
							</div>

						</div>
						<div class="node-tip cust-model" tipindex="{$node@index}">
								
								{if $node['node_class'] > $user->class}
									<p class="card-heading" align="center"><b> <i class="icon icon-lg">visibility_off</i>
										您当前等级不足以使用该节点，如需升级请<a href="/user/shop">点击这里</a>升级套餐</b></p>
								{else}
									<div class="tipmiddle">
										{* <div><span class="node-icon"><i class="icon icon-lg">chat</i> </span>{$node['info']}</div> *}
										<div class="nodename">手动添加节点信息</div>
									</div>
									{$v2 = $node->getV2($node['server'])}
									{if $node['sort'] == 11 }
										<p>类型 Protocol：<span class="card-tag tag-red">Vmess节点</span></p>
										<p>名字 Name：<span class="card-tag geekblue">{$node->name}</span></p>
										<p>地址 Address ：<span class="card-tag tag-blue">{$v2['add']}</span></p>
										<p>用户Id ID ：<span class="card-tag tag-geekblue">{if $v2['uuid']}{$v2['uuid']}{else}{$user->v2ray_uuid}{/if}</span></p>
										<p>额外ID AlterId ：<span class="card-tag tag-purple">{$v2['aid']}</span></p>
										<p>端口 Port ：<span class="card-tag tag-volcano">{$v2['port']}</span></p>
										<p>加密方式 Security ：<span class="card-tag tag-green">{$v2['scy']}</span></p>
										<p>传输协议 Network ：<span class="card-tag tag-green">{$v2['net']}</span></p>
										<p>伪装类型 Type ：<span class="card-tag tag-green">{$v2['type']}</span></p>
										<p>伪装 Host Quic加密方式 ：<span class="card-tag tag-green">{$v2['host']}</span></p>
										<p>Path ：<span class="card-tag tag-green">{$v2['path']}</span></p>
										<p>Servername(gRPC) ：<span class="card-tag tag-green">{$v2['serviceName']}</span></p>
										<p>模式 mode(gRPC) ：<span class="card-tag tag-green">{$v2['mode']}</span></p>
										<p>Tls传输 ：<span class="card-tag tag-green">{$v2['tls']}</span></p>
										<p>SNI ：<span class="card-tag tag-green">{$v2['sni']}</span></p>
										<p>ALPN ：<span class="card-tag tag-green">{$v2['alpn']}</span></p>
									{elseif $node['sort'] == 13 }
										<p>类型 Protocol：<span class="card-tag tag-red">VLESS 节点</span></p>
										<p>名字 Name：<span class="card-tag tag-geekblue">{$node->name}</span></p>
										<p>地址 Address ：<span class="card-tag tag-blue">{$v2['add']}</span></p>
										<p>用户Id ID ：<span class="card-tag tag-geekblue">{if $v2['uuid']}{$v2['uuid']}{else}{$user->v2ray_uuid}{/if}</span></p>
										<p>流控 Flow ：<span class="card-tag tag-purple">{$v2['flow']}</span></p>
										<p>端口 Port ：<span class="card-tag tag-volcano">{$v2['port']}</span></p>
										<p>加密 Encryption ：<span class="card-tag tag-green">{$v2['ecp']}</span></p>
										<p>传输协议 Network ：<span class="card-tag tag-green">{$v2['net']}</span></p>
										<p>伪装类型 Type ：<span class="card-tag tag-green">{$v2['type']}</span></p>
										<p>伪装 Host Quic加密方式 ：<span class="card-tag tag-green">{$v2['host']}</span></p>
										<p>伪装路径Path ：<span class="card-tag tag-green">{$v2['path']}</span></p>
										<p>Servername(gRPC) ：<span class="card-tag tag-green">{$v2['serviceName']}</span></p>
										<p>模式 mode(gRPC) ：<span class="card-tag tag-green">{$v2['mode']}</span></p>
										<p>Tls传输 ：<span class="card-tag tag-green">{$v2['tls']}</span></p>
										<p>FigerPrint 指纹 ：<span class="card-tag tag-green">{$v2['fp']}</span></p>
										<p>SNI ：<span class="card-tag tag-green">{$v2['sni']}</span></p>
										<p>ALPN ：<span class="card-tag tag-green">{$v2['alpn']}</span></p>
									{elseif $node->sort == 14 }
										<p>类型 Protocol：<span class="card-tag tag-red">Trojan 节点</span></p>
										<p>名字 Name：<span class="card-tag tag-geekblue">{$node->name}</span></p>
										<p>地址 Address ：<span class="card-tag tag-blue">{$v2['add']}</span></p>
										<p>用户Id ID ：<span class="card-tag tag-geekblue">{if $v2['uuid']}{$v2['uuid']}{else}{$user->v2ray_uuid}{/if}</span></p>
										<p>流控 Flow ：<span class="card-tag tag-purple">{$v2['flow']}</span></p>
										<p>端口 Port ：<span class="card-tag tag-volcano">{$v2['port']}</span></p>
										<p>传输协议 Network ：<span class="card-tag tag-green">{$v2['net']}</span></p>
										<p>伪装类型 Type ：<span class="card-tag tag-green">{$v2['type']}</span></p>
										<p>伪装 Host Quic加密方式 ：<span class="card-tag tag-green">{$v2['host']}</span></p>
										<p>伪装路径 Path <span class="card-tag tag-green">{$v2['path']}</span></p>
										<p>Servername(gRPC) ：<span class="card-tag tag-green">{$v2['serviceName']}</span></p>
										<p>模式 mode(gRPC) ：<span class="card-tag tag-green">{$v2['mode']}</span></p>
										<p>Tls传输 ：<span class="card-tag tag-green">{$v2['tls']}</span></p>
										<p>FigerPrint 指纹 ：<span class="card-tag tag-green">{$v2['fp']}</span></p>
										<p>SNI ：<span class="card-tag tag-green">{$v2['sni']}</span></p>
										<p>ALPN ：<span class="card-tag tag-red">{$v2['alpn']}</span></p>
									{else}
										<p><span class="card-tag tag-red">当前节点暂不支持查看配置信息</span></p>
									{/if}
								{/if}
							</div>
						{$point_node=null}
						{if $node@last}</div>{/if}
						{/foreach}
					</div>


					{include file='dialog.tpl'}
					<div aria-hidden="true" class="modal modal-va-middle fade" id="nodeinfo" role="dialog" tabindex="-1">
						<div class="modal-dialog modal-full">
							<div class="modal-content">
								<iframe class="iframe-seamless" title="Modal with iFrame" id="infoifram"></iframe>
							</div>
						</div>
					</div>
		</section>
	</div>
</main>







{include file='user/footer.tpl'}


<script>

	function urlChange(id, is_mu, rule_id) {
		var site = './node/' + id + '?ismu=' + is_mu + '&relay_rule=' + rule_id;
		if (id == 'guide') {
			var doc = document.getElementById('infoifram').contentWindow.document;
			doc.open();
			doc.write('<img src="../images/node.gif" style="width: 100%;height: 100%; border: none;"/>');
			doc.close();
		}
		else {
			document.getElementById('infoifram').src = site;
		}
		$("#nodeinfo").modal();
	}

	$(function () {
		new Clipboard('.copy-text');
	});
	$(".copy-text").click(function () {
		$("#result").modal();
		$("#msg").html("已复制，请进入软件添加。");
	});

	{literal}
    ;(function(){
		'use strict'
	//箭头旋转
    let rotateTrigger = document.querySelectorAll('a[href^="#cardgroup"]');
	let arrows = document.querySelectorAll('a[href^="#cardgroup"] i')

	for (let i=0;i<rotateTrigger.length;i++) {
		rotatrArrow(rotateTrigger[i],arrows[i]);
	}
	
	//UI切换
	{{/*  let elNodeCard = $$.querySelector(".node-cardgroup");
	let elNodeTable = $$.querySelector(".node-table");

	let switchToCard = new UIswitch('switch-cards',elNodeTable,elNodeCard,'grid','tempnode');
	switchToCard.listenSwitch();
	
	let switchToTable = new UIswitch('switch-table',elNodeCard,elNodeTable,'flex','tempnode');
	switchToTable.listenSwitch();

	switchToCard.setDefault();
	switchToTable.setDefault();  */}}
	
	//遮罩
	let buttongroup = document.querySelectorAll('.node-card');
	let modelgroup = document.querySelectorAll('.node-tip');

	for (let i=0;i<buttongroup.length;i++) {
		custModal(buttongroup[i],modelgroup[i]);
	}

    })();
	{/literal}
 
</script>
