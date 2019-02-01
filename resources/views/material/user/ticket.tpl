


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">工单</h1>
			</div>
		</div>
		<div class="container">
			<div class="col-lg-12 col-sm-12">
				<section class="content-inner margin-top-no">
					
					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<p>请先参考下面常见问题的解决方案；点击右下角红色<code>+</code>号创建工单。</p>
								<p><code>#0</code>春节期间客服QQ：1203997241 每天不定期上线</p>
                              	<p><code>#1 </code>所有节点不能用：账号是否过期？IP是否被禁（网站-设置中查看）？换个设备试试？换个网络试试？4G网请开关飞行模式试试？宽带请重启光猫试试？</p>
                              	<p><code>#2 </code>网速慢：节点很多，请找到网速好的节点使用；不同节点不同地区不同网络网速不同。</p>
								<p><code>#3 </code>部分节点不能用：网站-节点列表-在线人数，有人在线就说明节点能用；或者 http://www.okss.xyz 查看节点是否绿色对勾。</p>
                          		<p><code>#4 </code>软件: SS/SR/V.2使用软件不同，推荐使用V.2和SR，教程在个人首页。</p>
                             	<p><code>#5 </code>更改网站设置后，请删除软件中所有节点再重新导入节点，否则可能会导致ip被封。</p>
                              	<p><code>#6 </code>安卓设置无法连接，有可能是后台掉了，重新开启软件试试；电脑无法连接，请检查是否开启了负载均衡；</p>
                              	<p><code>#7 </code>提交工单，请告知您使用的设备、节点、网络环境。优先回复描述详细的工单。优先回复VIP用户工单。</p>
							</div>
						</div>
					</div>
					
					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<div class="card-table">
									<div class="table-responsive table-user">
										{$tickets->render()}
										<table class="table">
											<tr>
												
											  <!--  <th>ID</th>   -->
												<th>发起日期</th>
												<th>工单标题</th>
												<th>工单状态</th>
											   <th>操作</th>
											</tr>
											{foreach $tickets as $ticket}
												<tr>
													
												 <!--   <td>#{$ticket->id}</td>  -->
													<td>{$ticket->datetime()}</td>
													<td>{$ticket->title}</td>
													{if $ticket->status==1}
													<td>工单服务中</td>
													{else}
													<td>工单已结束</td>
													{/if}
													 <td>
														<a class="btn btn-brand" href="/user/ticket/{$ticket->id}/view">查看</a>
													</td>
												</tr>
											{/foreach}
										</table>
										{$tickets->render()}
									</div>
								</div>
							</div>
						</div>
					</div>
					
					
					<div class="fbtn-container">
						<div class="fbtn-inner">
							<a class="fbtn fbtn-lg fbtn-brand-accent" href="/user/ticket/create">+</a>
							
						</div>
					</div>

							
			</div>
			
			
			
		</div>
	</main>






{include file='user/footer.tpl'}










