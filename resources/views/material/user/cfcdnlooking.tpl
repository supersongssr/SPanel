


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
										<p><a type="button" class="btn fbtn-brand-accent btn-sm " href="https://github.com/badafans/better-cloudflare-ip" target="_blank" >如何获取适合自己的优化IP</a></p>
										<p><code>打开https://github.com/badafans/better-cloudflare-ip页面 -> 有相应的教程 -> 这个脚本的作用是可以快速的帮你选出适合你带宽的CFIP，您可以设定一个带宽值，比如20M，脚本会自动帮你选出一个适合的IP</code></p>
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
