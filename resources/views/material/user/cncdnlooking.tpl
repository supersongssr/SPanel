


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">加速入口选择 观察窗</h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="row">
					<div class="col-lg-12 col-md-12">
						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<p>为了爱与和平，为了方便用户参考不同地区不同网络对加速入口的选择，此页面展示了常见的地区和入口的选择。</p>
									<p>加速节点入口的选择，仅对 名字带有 加速 字样的节点有效，不同的加速入口对用户的网速影响不同，找到适合自己的加速入口，能让您的网速突飞猛进。对于一些长城宽带、移动宽带等也有奇效。</p>
								</div>
							</div>
						</div>


						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<div class="card-doubleinner">
											<p class="card-heading">加速入口参考</p>
											<p>选择适合自己的加速入口，能让您的网速突飞猛进，对电信、移动、长城等一些限速严重的地区有奇效。</p>
									</div>
									<div class="card-table">
										<div class="table-responsive table-user">
											<table class="table table-fixed">
												<tr>
													<th>地区</th>
													<th>加速入口</th>
													<th>次数</th>
												</tr>
												{foreach $cncdns as $cncdn}
													<tr>
														<td>{$cncdn->location}</td>
														<td>{$cncdn->area}</td>
														<td>{$cncdn->cncdn_count}</td>
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
