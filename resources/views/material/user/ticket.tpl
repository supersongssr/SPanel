


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">工单 & 客服 & 技术支持</h1>
			</div>
		</div>
		<div class="container">
			<div class="col-lg-12 col-sm-12">
				<section class="content-inner margin-top-no">

					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								
								<div class="cardbtn-edit">
										<div class="card-heading">工单 搜索</div>
										<button class="btn btn-flat" id="ticket-search"><span class="icon">check</span>&nbsp;</button>
								</div>
									<p><code>*这里列举了公开的工单内容，方便您快速参考别人的问题的解决方案。</code></p>
									<p><code>*您也可以通过搜索快速寻找适合自己的工单内容。</code></p>
								<div class="form-group form-group-label">
									<label class="floating-label" for="key-word">请输入 关键词 点右侧心心符号</label>
									<input class="form-control maxwidth-edit" id="key-word" value="" type="text">
								</div>
							</div>
						</div>
					</div>

					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<div class="card-table">
									<div class="table-responsive table-user">
										{$opentickets->render()}
										<table class="table">
											<tr>
											  <!--  <th>ID</th>   -->
												<th>操作</th>
												<th>工单标题</th>
												<th>工单状态</th>
												<th>发起日期</th>

											</tr>
											{foreach $opentickets as $ticket}
												<tr>

												 <!--   <td>#{$ticket->id}</td>  -->
													<td>
														<a class="btn btn-brand" href="/user/ticket/{$ticket->id}/openview">查看</a>
													</td>
													<td>{$ticket->title}</td>
													{if $ticket->status==3}
													<td>公开工单</td>
													{else}
													<td>出错了</td>
													{/if}
													<td>{$ticket->datetime()}</td>

												</tr>
											{/foreach}
										</table>
										{$opentickets->render()}
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<p>创建工单请点击右下角红色<code>+</code>号。</p>
								<p>快速解决问题？请先阅读 <a href="/user/announcement/1">网站公告</a> 、 <a href="/user/announcement/1">常见问题</a><br><code>*您的工单可能被公开，如果公开工单触犯了您的隐私，请回复一次或关闭工单工单，即可关闭公开展示。</code><br>*请您注意，为遏制脚本程序，防止滥用工单，提交/回复工单将扣除 {$config["ticket_price"]}￥/每次，管理回复并公开工单返还{$config["ticket_price"]}￥/每次。<br><code>*我们为VIP客户提供专业的技术支持,工单按用户等级排队回复,高等级优先回复。</code>  提问的智慧：<a href="https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way/blob/master/README-zh_CN.md"><code>*点我查看提问的智慧*</code></a></p>
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
													<td>服务中</td>
													<td>
														<a class="btn btn-brand" href="/user/ticket/{$ticket->id}/view">查看</a>
													</td>
													{elseif $ticket->status==3}
													<td>公开工单</td>
													<td>
														<a class="btn btn-brand" href="/user/ticket/{$ticket->id}/view">查看</a>
													</td>
													{else}
													<td>已完成</td>
													<td>
														<a class="btn btn-brand" href="/user/ticket/{$ticket->id}/openview">查看</a>
													</td>
													{/if}
													 
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




<script>
$(document).ready(function () {
	$("#ticket-search").click(function () {
		var key = $("#key-word").val();
		window.location.href = '/user/ticket' + '?search=' + key;
	})
})
</script>




{include file='user/footer.tpl'}
