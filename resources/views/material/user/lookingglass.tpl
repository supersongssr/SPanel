





{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">网速监控</h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="ui-card-wrap">
					<div class="row">
						<div class="col-lg-12 col-sm-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner margin-bottom-no">
									<!--	<p class="card-heading">注意!</p>    -->
										<p>此处只展示最近{$hour}小时的记录。<b>测试节点来自 <a href="http://speedtest.net">Speedtest</a>，数据仅供参考~</b></p>
									</div>
									
								</div>
							</div>
						</div>

						<div class="col-lg-12 col-sm-12">
							<div class="card">
								<div class="card-main">
									<div class="card-inner">
									<div class="card-doubleinner">
											<p class="card-heading">三网延迟和测速</p>
									</div>
										
										<div class="card-table">
											<div class="table-responsive table-user">
												<table class="table">
													<tr>
														<th>节点</th>
														<th>联通下载</th>
														<th>联通上传</th>  
														<th>移动下载</th>
														<th>移动上传</th>
														<th>电信下载</th>
														<th>电信上传</th> 
														<th>联通延迟</th>
														<th>移动延迟</th>
														<th>电信延迟</th>
													</tr>
													{foreach $speedtest as $single}

														<tr>
															<td>{$single->node()->name} #{$single->node()->id} Lv.{$single->node()->node_class}</td>
															<td>{$single->unicomupload}</td>
															<td>{$single->unicomdownload}</td>   
															<td>{$single->cmccupload}</td>
															<td>{$single->cmccdownload}</td> 
															<td>{$single->telecomeupload}</td>  
															<td>{$single->telecomedownload}</td>
															<td>{$single->unicomping}</td>  
															<td>{$single->cmccping}</td> 
															<td>{$single->telecomping}</td>  
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
				</div>
			</section>
		</div>
	</main>







{include file='user/footer.tpl'}