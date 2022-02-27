


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">中转加速技术</h1>
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
												<div class="card-heading">中转加速 破除Qos限速</div>
												<button class="btn btn-flat" id="cncdn-update"><span class="icon">check</span>&nbsp;</button>
										</div>
										<!-- <p>当前入口：<code id="ajax-user-cncdn" data-default="cncdn"></code></p> -->
										<div class="form-group form-group-label control-highlight-custom dropdown">
											<!-- <label class="floating-label" for="cncdn">当前加速入口：</label> -->
											<button id="cncdn" class="form-control maxwidth-edit" data-toggle="dropdown" value="{$user->cncdn}">{if $user->cncdn}{$user->cncdn}{else}默认随机{/if}</button>
											<ul class="dropdown-menu" aria-labelledby="cncdn">
												<li><a href="#" class="dropdown-option" onclick="return false;" val="" data="cncdn">默认随机</a></li>
												{foreach $cncdns as $cncdn}
												<li><a href="#" class="dropdown-option" onclick="return false;" val="{$cncdn->area}" data="cncdn">{$cncdn->area}</a></li>
												{/foreach}
											</ul>
										</div>
										<p><code>不会选？ 移动电信选联通 :) *更换后记得在软件中更新节点</code></p>
									</div>
								</div>
							</div>
						</div>


						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<div class="card-doubleinner">
											<p class="card-heading">加速入口参考</p>
											<p>网络被运营商Qos限速？通过中转，摆脱宽带网络限速！选择适合自己的加速入口，网速突飞猛进！</p>
									</div>
									<div class="card-table">
										<div class="table-responsive table-user">
											<table class="table table-fixed">
												<tr>
													<th>网络</th>
													<th>入口</th>
													<th>次数</th>
												</tr>
												{foreach $usercdns as $usercdn}
													<tr>
														<td>{$usercdn->location}</td>
														<td>{$usercdn->cncdn}</td>
														<td>{$usercdn->cncdn_count}</td>
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
        $("#cncdn-update").click(function () {
            $.ajax({
                type: "POST",
                url: "cncdn",
                dataType: "json",
                data: {
                    cncdn: $("#cncdn").val()
                },
                success: function (data) {
                    if (data.ret) {
                        $("#result").modal();
						$("#msg").html(data.msg);
						window.setTimeout("location.href='/user/cncdnlooking'", {$config['jump_delay']});
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
