


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">直连优化技术 </h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="row">
					<div class="col-lg-12 col-md-12">
						<div class="card margin-bottom-no">
							<div class="card-main">
								<div class="card-inner">
									<div class="card-inner">
										<div class="cardbtn-edit">
												<div class="card-heading">网络优化 解决直连没速度！ </div>
												<button class="btn btn-flat" id="cfcdn-update"><span class="icon">check</span>&nbsp;</button>
										</div>

										<div class="form-group form-group-label">
											<label class="floating-label" for="cfcdn">网络优化（IP）： </label>
											<input class="form-control maxwidth-edit" id="cfcdn" value="{$user->cfcdn}" type="text">
										</div>
										<p>Win教程：<code><a href="https://www.anycast.eu.org/batch.zip" target="_blank">点此下载文件 - 解压后查看使用说明</a></code></p>
										<p>Liunx教程：<code>curl https://www.anycast.eu.org/cf.sh -o cf.sh && chmod +x cf.sh && ./cf.sh</code></p>
									</div>
								</div>
							</div>
						</div>

						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<div class="card-doubleinner">
											<p class="card-heading">优化IP参考  </p>
											<p>一项奇怪的技术，网速差的宽带用了网速会变好，网速好的宽带用了网速会变差。 如果使用后网络没速度？请保留空值即可。</p>
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




<script>
    $(document).ready(function () {
        $("#cfcdn-update").click(function () {
            $.ajax({
                type: "POST",
                url: "cfcdn",
                dataType: "json",
                data: {
                    cfcdn: $("#cfcdn").val()
                },
                success: function (data) {
                    if (data.ret) {
                        $("#result").modal();
						$("#msg").html(data.msg);
						window.setTimeout("location.href='/user/cfcdnlooking'", {$config['jump_delay']});
                    } else {
                        $("#result").modal();
						$("#msg").html(data.msg);
                    }
                },
                error: function (jqXHR) {
                    $("#result").modal();
					$("#msg").html(data.msg+"     出现了一些错误。");
                }
            })
        })
    })
</script>





{include file='user/footer.tpl'}
