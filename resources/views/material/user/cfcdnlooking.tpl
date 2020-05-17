


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
											<label class="floating-label" for="cfcdn">网络优化： </label>
											<input class="form-control maxwidth-edit" id="cfcdn" value="{$user->cfcdn}" type="text">
										</div>
										<p>*选择一个ip填入，软件上更新节点，测试速度。*修改后无法联网？请更换或者保持空白！</p>
										<p><code>移动：1.0.0.*, 198.41.214.* (香港), 198.41.212.*, 198.41.208.*, 198.41.209.*, 172.64.32.*, 141.101.115.*,  104.20.48.2, 104.24.96.2, 104.20.48.2, 104.17.32.0, 104.17.40.2, 104.24.240.2, 104.28.144.2, 104.25.192.2, 104.31.87.112, 104.28.14.*,104.23.240.*, 104.23.241.*, 104.23.242.* ,104.23.243.* ,162.158.133.* (丹麦), 
											<br>电信：1.0.0.*, 104.16.160.* (美国), 108.162.236.* (美国), 104.23.240.* (欧洲), 104.20.157.*, 162.159.208.* (4-103), 162.159.209.* (4-103), 162.159.210.* (4-103), 162.159.211.* (4-103), 172.64.0.*, 172.64.32.* (香港), 
											<br>联通：1.0.0.*, 104.26.11.*, 104.26.10.*, 104.27.188.*, 104.20.157104.23.241.* ,.* (走日本), 162.159.208.*, 162.159.209.* (4-103), 162.159.210.* (4-103), 162.159.211.* (4-103), 173.245.48.*, 108.162.192.*,108.162.236.* ,104.23.240.* ,104.23.241.* ,104.23.242.* ,104.23.243.* ,
											<br> 末位 * 代表在 1-255 之间取值； 末位 * (4-103) 代表在 4-103 之间取值。</code></p>
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
