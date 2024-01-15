


{include file='admin/main.tpl'}







	<main class="content">

		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="row">
					<div class="col-lg-12 col-md-12">

						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<div class="card-doubleinner">
											<p class="card-heading">节点调整</p>
									</div>
									<div class="card-table">
										<div class="table-responsive table-user">
											<table class="table ">
												<tr>
													<th>编辑</th>
													<th>名字</th>
													<th>节点</th>
													
													<th>流量</th>
													<th>表现</th>
												</tr>
												{foreach $nodes as $node}
													<tr>
														<td>{if $node->type == 0 }<a class="btn btn-flat" href="/admin/node/{$node->id}/edit">{$node->id}</a>{elseif $node->type == 1 && $node->custom_rss == 1}<a class="btn btn-brand" href="/admin/node/{$node->id}/edit">{$node->id}</a>{else}<a class="btn btn-danger" href="/admin/node/{$node->id}/edit">{$node->id}</a>{/if}</td>
														<td>{$node->name}</td>
														<td>{$node->node_class} 级 {$node->traffic_rate} 倍率 {$node->node_online} 人</td>
														
														<td>{floor($node->node_bandwidth / 1024 / 1024 / 1024)}G</td>
														<td>{$node->status}</td>
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










{include file='admin/footer.tpl'}
