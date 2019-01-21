{include file='user/main.tpl'}

	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">公告&帮助&教程</h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="ui-card-wrap">
					
						<div class="col-lg-12 col-md-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner margin-bottom-no">
										<p class="card-heading"><a href="/user/announcement/1" class="btn btn-brand">常见问题解答</a><a href="/user/announcement/1" class="btn btn-brand">常见问题解答</a><a href="/user/announcement/1" class="btn btn-brand">常见问题解答</a></p>
										<div class="card-table">
											<div class="table-responsive">
												<table class="table">
													<!--<tr>
														<th>ID</th>
														<th>日期</th>
														<th>内容</th>
													</tr> song-->
													{foreach $anns as $ann}
														<tr>
															<!--<td>#{$ann->id}</td> 
															<td>{$ann->date}</td> song-->
															<td>#{$ann->id}#{$ann->date}#{$ann->content}</td>
														</tr>
													{/foreach}
												</table>
											</div>
										</div>
									</div>
									
								</div>
							</div>						
						
						{include file='dialog.tpl'}
						
					</div>
						
					
				</div>
			</section>
		</div>
	</main>


{include file='user/footer.tpl'}