


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">优化IP选择 观察窗</h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="row">
					<div class="col-lg-12 col-md-12">
						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<p>优化IP，是一项储备技术，能否在大面积节点失效的情况下，紧急复活节点。</p>
									<p>优化ip的可用选择有很多。<br>电信优化IP库：162.159.208.4 - 162.159.208.103<br>162.159.209.4 - 162.159.209.103<br>162.159.210.4 - 162.159.210.103<br>162.159.211.4 - 162.159.211.103<br>(以上每个ip段有100个ip，总共400个ip)<br>移动优化IP库：172.64.32.0 - 172.64.32.255<br>(上面是一个拥有256个ip的ip段)<br>104.20.48.2、104.24.96.2、104.20.48.2、104.17.32.0、104.17.40.2、104.24.240.2、104.28.144.2、104.25.192.2、104.31.87.112<br>联通优化IP库：162.159.208.4 - 162.159.208.103<br>162.159.209.4 - 162.159.209.103<br>162.159.210.4 - 162.159.210.103<br>162.159.211.4 - 162.159.211.103<br>173.245.48.0 - 173.245.48.255<br>108.162.192.0 - 108.162.192.255<br>(以上每个ip段有100个ip，总400个ip)</p>
								</div>
							</div>
						</div>


						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<div class="card-doubleinner">
											<p class="card-heading">优化IP参考  </p>
											<p>选择合适的IP，能否让您在使用 优化 节点时，网速有所改善。。</p>
									</div>
									<div class="card-table">
										<div class="table-responsive table-user">
											<table class="table table-fixed">
												<tr>
													<th>地区</th>
													<th>优化IP</th>
													<th>次数</th>
												</tr>
												{foreach $cfcdns as $cfcdn}
													<tr>
														<td>{$cfcdn->location}</td>
														<td>{$cfcdn->cfcdn}</td>
														<td>{$cfcdn->cfcdn_count}</td>
													</tr>
												{/foreach}
											</table>
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
