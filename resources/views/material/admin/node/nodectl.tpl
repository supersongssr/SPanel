


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
											<table class="table table-fixed">
												<tr>
													<th>编辑</th>
													<th>名字</th>
													<th>节点</th>
													<th>流量</th>
												</tr>
												{foreach $nodes as $node}
													<tr>
														<td>{if $node->type ==1 }<a class="btn btn-brand" href="/admin/node/{$node->id}/edit">编辑</a> #{$node->id}  在线{elseif $node->type == 0}<a class="btn btn-danger" href="/admin/node/{$node->id}/edit">编辑</a> #{$node->id} 离{/if}</td>
														<td>{$node->name} - {$node->status}</td>
														<td>{$node->node_class} 级 {$node->node_group} 组 {$node->traffic_rate} 倍 {$node->node_online} 人 {$node->node_oncost}</td>
														<td>{$node->info}</td>
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
