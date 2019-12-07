{include file='admin/main.tpl'}

<main class="content">
	<div class="content-header ui-content-header">
		<div class="container">
			<h1 class="content-heading">节点列表</h1>
		</div>
	</div>
	<div class="container">
		<div class="col-lg-12 col-sm-12">
			<section class="content-inner margin-top-no">

				

				<div class="table-responsive">
					{include file='table/table.tpl'}
				</div>


				<div class="card">
					<div class="card-main">
						<div class="card-inner">
							<table class="table">
								<tr>
									<th>等级</th>
									<th>总</th>
									<th>Lv.10</th>
									<th>Lv.9</th>
									<th>Lv.8</th>
									<th>Lv.7</th>
									<th>Lv.6</th>
									<th>Lv.5</th>
									<th>Lv.4</th>
									<th>Lv.3</th>
									<th>Lv.2</th>
									<th>Lv.1</th>
									<th>Lv.0</th>
								</tr>
								<tr>
									<td>用户</td>
									<td>{$sts->getAllUser()}</td>
									<td>{$sts->getV10User()}</td>
									<td>{$sts->getV9User()}</td>
									<td>{$sts->getV8User()}</td>
									<td>{$sts->getV7User()}</td>
									<td>{$sts->getV6User()}</td>
									<td>{$sts->getV5User()}</td>
									<td>{$sts->getV4User()}</td>
									<td>{$sts->getV3User()}</td>
									<td>{$sts->getV2User()}</td>
									<td>{$sts->getV1User()}</td>
									<td>{$sts->getV0User()}</td>
								</tr>
								<tr>
									<td>节点</td>
									<td>{$sts->getAllNode()}</td>
									<td>{$sts->getV10Node()}</td>
									<td>{$sts->getV9Node()}</td>
									<td>{$sts->getV8Node()}</td>
									<td>{$sts->getV7Node()}</td>
									<td>{$sts->getV6Node()}</td>
									<td>{$sts->getV5Node()}</td>
									<td>{$sts->getV4Node()}</td>
									<td>{$sts->getV3Node()}</td>
									<td>{$sts->getV2Node()}</td>
									<td>{$sts->getV1Node()}</td>
									<td>{$sts->getV0Node()}</td>
								</tr>
								<tr>
									<td>比率</td>
									<td>{floor($sts->getAllUser() / $sts->getAllNode())}</td>
									<td>{floor($sts->getV10User() / $sts->getV10Node())}</td>
									<td>{floor($sts->getV9User() / $sts->getV9Node())}</td>
									<td>{floor($sts->getV8User() / $sts->getV8Node())}</td>
									<td>{floor($sts->getV7User() / $sts->getV7Node())}</td>
									<td>{floor($sts->getV6User() / $sts->getV6Node())}</td>
									<td>{floor($sts->getV5User() / $sts->getV5Node())}</td>
									<td>{floor($sts->getV4User() / $sts->getV4Node())}</td>
									<td>{floor($sts->getV3User() / $sts->getV3Node())}</td>
									<td>{floor($sts->getV2User() / $sts->getV2Node())}</td>
									<td>{floor($sts->getV1User() / $sts->getV1Node())}</td>
									<td>{floor($sts->getV0User() / $sts->getV0Node())}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>

				<div class="card">
					<div class="card-main">
						<div class="card-inner">
							<p>系统中所有节点的列表。</p>
			              <p>显示表项:
			                {include file='table/checkbox.tpl'}
			              </p>
						</div>
					</div>
				</div>

				<div class="fbtn-container">
					<div class="fbtn-inner">
						<a class="fbtn fbtn-lg fbtn-brand-accent waves-attach waves-circle waves-light" href="/admin/node/create">+</a>

					</div>
				</div>

				<div aria-hidden="true" class="modal modal-va-middle fade" id="delete_modal" role="dialog" tabindex="-1">
					<div class="modal-dialog modal-xs">
						<div class="modal-content">
							<div class="modal-heading">
								<a class="modal-close" data-dismiss="modal">×</a>
								<h2 class="modal-title">确认要删除？</h2>
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


{include file='admin/footer.tpl'}

<script>

function delete_modal_show(id) {
    deleteid = id;
	$("#delete_modal").modal();
}

{include file='table/js_1.tpl'}

window.addEventListener('load', () => {
 	{include file='table/js_2.tpl'}


	function delete_id(){
		$.ajax({
            type: "DELETE",
            url: "/admin/node",
            dataType: "json",
			data:{
				id: deleteid
			},
			success: data => {
				if (data.ret){
					$("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
					{include file='table/js_delete.tpl'}
				} else {
					$("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
				}
			},
			error: jqXHR => {
				$("#result").modal();
                $$.getElementById('msg').innerHTML = `${ldelim}data.msg{rdelim} 发生错误了。`;
			}
		});
	}

    $$.getElementById('delete_input').addEventListener('click', delete_id);
})
</script>
