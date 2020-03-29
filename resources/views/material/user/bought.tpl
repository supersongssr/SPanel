


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">购买记录</h1>
			</div>
		</div>
		<div class="container">
			<div class="col-lg-12 col-sm-12">
				<section class="content-inner margin-top-no">
					
					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<p>系统中您的购买记录。<br><small>*套餐和当前显示不准？系统会自动选择最近一条购买记录的等级来矫正您的套餐。</small><br><small>*一旦您点击矫正，如果您的正常充值金额不足以购买当前套餐，您的账号会启动异常保护！ ———— 您的账号会被禁(您可以自助解封)！</small></p>
							</div>
						</div>
						
						<div class="card-inner">
							<button id="relevel" type="submit" class="btn btn-block btn-brand ">等级矫正</button>
						</div>
						
					</div>

					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<div class="card-table">
									<div class="table-responsive table-user">
										{$shops->render()}
										<table class="table">
											<tr>
												
											 <!--   <th>ID</th> -->
												<th>商品名称</th>
												<th>内容</th>
												<th>价格</th>
												<th>续费时间</th>
												<th>续费时重置流量</th>
												<th>操作</th>
												
											</tr>
											{foreach $shops as $shop}
											<tr>
												
										  <!--       <td>#{$shop->id}</td> -->
												<td>{$shop->shop()->name}</td>
												<td>{$shop->shop()->content()}</td>
												<td>{$shop->price} $</td>
												{if $shop->renew==0}
												<td>不自动续费</td>
												{else}
												<td>在 {$shop->renew_date()} 续费</td>
												{/if}
												
												{if $shop->shop()->auto_reset_bandwidth==0}
												<td>不自动重置</td>
												{else}
												<td>自动重置</td>
												{/if}
											  <td>
													<a class="btn btn-brand" {if $shop->renew==0}disabled{else} href="javascript:void(0);" onClick="delete_modal_show('{$shop->id}')"{/if}>关闭自动续费</a>
												</td>
												
											</tr>
											{/foreach}
										</table>
										{$shops->render()}
									</div>					
								</div>
							</div>
						</div>
					</div>
					
					
					
					
					<div aria-hidden="true" class="modal modal-va-middle fade" id="delete_modal" role="dialog" tabindex="-1">
						<div class="modal-dialog modal-xs">
							<div class="modal-content">
								<div class="modal-heading">
									<a class="modal-close" data-dismiss="modal">×</a>
									<h2 class="modal-title">确认要关闭自动续费？</h2>
								</div>
								<div class="modal-inner">
									<p>请您确认。</p>
								</div>
								<div class="modal-footer">
									<p class="text-right"><button class="btn btn-flat btn-brand-accent waves-attach waves-effect" data-dismiss="modal" type="button">取消</button><button class="btn btn-flat btn-brand-accent waves-attach" data-dismiss="modal" id="delete_input" type="button">确定</button></p>
								</div>
							</div>
						</div>
					</div>
					
					{include file='dialog.tpl'}

							
			</div>
			
			
			
		</div>
	</main>






{include file='user/footer.tpl'}




<script>
function delete_modal_show(id) {
	deleteid=id;
	$("#delete_modal").modal();
}

$(document).ready(function(){
	function delete_id(){
		$.ajax({
			type:"DELETE",
			url:"/user/bought",
			dataType:"json",
			data:{
				id: deleteid
			},
			success:function(data){
				if(data.ret){
					$("#result").modal();
					$("#msg").html(data.msg);
					window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
				}else{
					$("#result").modal();
					$("#msg").html(data.msg);
				}
			},
			error:function(jqXHR){
				$("#result").modal();
				$("#msg").html(data.msg+"  发生错误了。");
			}
		});
	}
	$("#delete_input").click(function(){
		delete_id();
	});
})
	
</script>

<script>
    $(document).ready(function () {
        $("#relevel").click(function () {
            $.ajax({
                type: "POST",
                url: "/relevel",
                dataType: "json",
                data: {
                },
                success: function (data) {
                    if (data.ret) {
                        $("#result").modal();
						$("#msg").html("申请 "+data.msg+" 成功");
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






