{include file='user/main.tpl'}

<script src="/jscdn/gh/SuicidalCat/canvasjs.js@v2.3.1/canvasjs.min.js"></script>
<script src="/jscdn/npm/jquery@3.3.1.js"></script>
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); function hideURLbar(){ window.scrollTo(0,1); } </script>

<main class="content">
	<div class="content-header ui-content-header">
		<div class="container">
			<h1 class="content-heading">媒体解锁</h1>
		</div>
	</div>

	<div class="container">
		<section class="content-inner margin-top-no">
			<div class="ui-card-wrap">
				<div class="row">
					<div class="col-lg-12 col-sm-12 nodelist">
							
							<div class="ui-switch node-switch">
								<div class="card">
									<div class="card-main">
										<div class="card-inner ui-switch">
											<div class="switch-btn" id="switch-cards"><a href="#" onclick="return false"><i class="mdui-icon material-icons">apps</i></a></div>
											<div class="switch-btn" id="switch-table"><a href="#" onclick="return false"><i class="mdui-icon material-icons">dehaze</i></a></div>
										</div>
									</div>
								</div>
							</div>
						
					<div class="card node-table" style="display: flex;">
							<div class="card-main">
								<div class="card-inner margin-bottom-no">
									<div class="tile-wrap">        
                                        {foreach $nodes as $node}
										<div class="tile tile-collapse">
											<div data-toggle="tile" data-target="#heading{$node['id']}">
												<div class="tile-side pull-left" data-ignore="tile">
													<div class="avatar avatar-sm {if $node->node_group == 0 }nodeoffline{elseif $node->node_group == $user->node_group || $user->class < 1}nodeonline{else}nodeunset{/if}">
														<span class="material-icons">{if $node->node_group == $user->node_group || $user->class < 1}cloud_queue{elseif $node->node_group == 0 }wifi_off{else}flash_off{/if}</span>
													</div>
												</div>
												<div class="tile-inner">
													<div class="text-overflow node-textcolor">
														<span class="enable-flag">
															   {$node['name']} @ {$node['id']}
														</span>
														|
														<!--  <span class="node-icon"><i class="icon icon-lg">flight_takeoff</i></span>
														  <strong><b><span class="node-alive">{$node->node_online}</span></b></strong> 
											            | <span class="node-icon"><i class="icon icon-lg">cloud</i></span>
														<span class="node-load">{$node->node_oncost}</span> 
														| <span class="node-icon"><i class="icon icon-lg">import_export</i></span>
														<span class="node-mothed">{$node['bandwidth']}</span> 
														| <span class="node-icon"><i class="icon icon-lg">equalizer</i></span>
															<span class="node-band">{floor($node['node_bandwidth']/1000000000)}/{floor($node['node_bandwidth_limit']/1000000000)}</span>
														| <span class="node-icon"><i class="icon icon-lg">network_check</i></span>
														<span class="node-tr">{$node['traffic_rate']}</span> 
														| <span class="node-icon"><i class="icon icon-lg">notifications_none</i></span>   -->
														<span class="node-status">{$node['info']}</span>
													</div>
												</div>
											</div>

										    <div class="collapsible-region collapse" id="heading{$node['id']}">
												<div class="tile-sub">
													<br>
                                                {if $node['class'] > $user->class}
													<div class="card">
														<div class="card-main">
															<div class="card-inner">
																<p class="card-heading" align="center"><b> <i class="icon icon-lg">visibility_off</i>
																		您当前等级不足以使用该节点，如需升级请<a href="/user/shop">点击这里</a>升级套餐</b></p>
															</div>
														</div>
													</div>
													{else}
                                                    
                                                 <div class="card nodetip-table">
														<div class="card-main">
																<div class="card-inner">
														{* <div><i class="icon icon-lg node-icon">chat</i> {$node['info']}</div> *}
														<div class="nodename">IP解锁项目:</div>
													    {$nodeunlock = $node->getV2($node['node_unlock'])}  <!-- $u: unlock -->
                                                        {foreach $nodeunlock as $k => $v }
                                                                <span class="card-tag tag-blue">{$k}</span> : <span class="card-tag tag-green">{$v}</span>  |  
                                                        {/foreach}
													
                                                    
												</div>
											  </div>

										    </div>
											{/if}
											   
												{if isset($point_node)}
												{if $point_node!=null}
		
												<div class="card">
													<div class="card-main">
														<div class="card-inner" id="info{$node@index}">
		
														</div>
													</div>
												</div>
		
												<script>
													$().ready(function () {
														$('#heading{$node['id']}').on("shown.bs.tile", function () {
															$("#info{$node@index}").load("/user/node/{$point_node['id']}/ajax");
														});
													});
												</script>
												{/if}
												{/if}
											
                                                </div>
											</div>

										

										{$point_node=null}
								
										</div>
										{/foreach}
										
										

									</div>
								</div>
							</div>
						</div>
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
{{/*  	
	//UI切换
	let elNodeCard = $$.querySelector(".node-cardgroup");
	let elNodeTable = $$.querySelector(".node-table");

	let switchToCard = new UIswitch('switch-cards',elNodeTable,elNodeCard,'grid','tempnode');
	switchToCard.listenSwitch();
	
	let switchToTable = new UIswitch('switch-table',elNodeCard,elNodeTable,'flex','tempnode');
	switchToTable.listenSwitch();

	switchToCard.setDefault();
	switchToTable.setDefault();
	
	//遮罩
	let buttongroup = document.querySelectorAll('.node-card');
	let modelgroup = document.querySelectorAll('.node-tip');

	for (let i=0;i<buttongroup.length;i++) {
		custModal(buttongroup[i],modelgroup[i]);
	}  */}}

    })();
	{/literal}
 
</script>
