


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
													<th>节点</th>
													<th>名字</th>
												</tr>
												{foreach $nodes as $node}
													<tr>
														<td><a class="btn btn-brand" href="/admin/node/{$node->id}/edit">编辑</a> #{$node->id}</td>
														<td>{$node->node_class} 级 {$node->node_group} 组 {$node->traffic_rate} 倍</td>
														<td>{$node->name}</td>
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
