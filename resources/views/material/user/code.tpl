



{include file='user/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">充值</h1>


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

                                    {if $config["enable_admin_contact"] == 'true'}
                                        <p class="card-heading">充值遇到问题？联系站长 或者 <a href="/user/ticket">提交工单</a> </p>
                                        {if $config["admin_contact1"]!=null}
                                            <li>{$config["admin_contact1"]}</li>
                                        {/if}
                                        {if $config["admin_contact2"]!=null}
                                            <li>{$config["admin_contact2"]}</li>
                                        {/if}
                                        {if $config["admin_contact3"]!=null}
                                            <li>{$config["admin_contact3"]}</li>
                                        {/if}
                                    {/if}
                                    <p><i class="icon icon-lg">attach_money</i>当前余额：<font color="#399AF2" size="5">{$user->money}</font> </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {if $config["payment_system"] == 'fakapay'}
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-inner">
                                    <div class="cardbtn-edit">
                                            <div class="card-heading">充值码/卡密/卡号 充值余额</div>
                                            <button class="btn btn-flat" id="code-update" ><span class="icon">favorite_border</span></button>
                                    </div>
                                    <p><a type="button" class="btn fbtn-brand-accent btn-sm " href="{{$config["fakapay_url_10"]}}" target="_blank" >10￥充值码 购买 （商品名已做安全处理，拍下即为充值码） </a></p><p> <a type="button" class="btn fbtn-brand-accent btn-sm " href="{{$config["fakapay_url_100"]}}" target="_blank" >100￥充值码 购买 （拍下即为充值码，多个充值码可叠加充值） </a> </p><p>* 购买多个充值码可叠加充值。为支付安全，商品名已做安全处理，请忽略商品名，拍下后获取充值码/卡号，在本页面输入即可充值余额。</p>
                                    <p><a type="button" class="btn fbtn-brand-accent btn-sm" href="/user/announcement/5" target="_blank" >购买常见问题 解决方案</a><font color="#399AF2" size="5">购买售后联系邮箱：yiran@ssmail.win （暂无大陆微信/QQ联系方式）</font> </p>
                                    <div class="form-group form-group-label">
                                        <label class="floating-label" for="code">充值码填入这里 点右边心心符号 </label>
                                        <input class="form-control maxwidth-edit" id="code" type="text">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {/if}

                  {if $pmw!=''}
                      <div class="col-lg-12 col-md-12">
                          <div class="card margin-bottom-no">
                              <div class="card-main">
                                  <div class="card-inner">
                                      {$pmw}
                                  </div>
                              </div>
                          </div>
                      </div>
                  {/if}


<!--
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-inner">
                                    <p class="card-heading">账号升级 申请中转加速节点 </p>
                                    <p>中转加速节点申请须同时满足以下条件：<code><br>1.当前页面累计充值金额 > 您套餐原价 * 0.15<br>2.并且您余额>0</code><br>*VIP10用户直接通过<br>点击此申请按钮代表您同意：
                                        <code><br>1.如果您不符合上述条件，点击按钮您的账号会被禁用(您可以自助解封)
                                        <br>2.请您务必检查自己当前页面的充值总额，以及您当前用户的等级</code>
                                    </p>
                                </div>
                                <div class="card-inner">
                                    <button id="uptocncdn" type="submit" class="btn btn-block btn-brand ">点击升级账号 申请 中转加速节点 </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
-->
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-inner">
                                    <p class="card-heading">VIP10</p>
                                    <p>此页面累计充值满233，您可以申请 VIP10 。 <br>我们提供免费的VIP10专属的 Azure 600M节点供充值用户使用。<br>*请注意：此为临时策略，不保证长期提供，当我们取消此功能的时候，您的账号等级也将会恢复。<br>*请注意：我们将采用严格的检测机制，如果您累计充值不满223而点击此按钮，系统会将您的账号禁用（您可以自助解封）。</p>
                                </div>
                                <div class="card-inner">
                                    <button id="uptopay" type="submit" class="btn btn-block btn-brand ">申请VIP10 Azure 600M节点</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">

                                    <div class="card-table">
                                        <div class="table-responsive table-user">
                                            {$codes->render()}
                                            <table class="table table-hover">
                                                <tr>
                                                    <!--<th>ID</th> -->
                                                    <th>代码</th>
                                                    <th>类型</th>
                                                    <th>操作</th>
                                                    <th>使用时间</th>

                                                </tr>
                                                {foreach $codes as $code}
                                                    {if $code->type!=-2}
                                                        <tr>
                                                            <!--	<td>#{$code->id}</td>  -->
                                                            <td>{$code->code}</td>
                                                            {if $code->type==-1}
                                                                <td>金额捐赠</td>
                                                            {/if}
                                                            {if $code->type==10001}
                                                                <td>流量充值</td>
                                                            {/if}
                                                            {if $code->type==10002}
                                                                <td>用户续期</td>
                                                            {/if}
                                                            {if $code->type>=1&&$code->type<=10000}
                                                                <td>等级续期 - 等级{$code->type}</td>
                                                            {/if}
                                                            {if $code->type==-1}
                                                                <td>捐赠 {$code->number} 捐赠</td>
                                                            {/if}
                                                            {if $code->type==10001}
                                                                <td>充值 {$code->number} GB 流量</td>
                                                            {/if}
                                                            {if $code->type==10002}
                                                                <td>延长账户有效期 {$code->number} 天</td>
                                                            {/if}
                                                            {if $code->type>=1&&$code->type<=10000}
                                                                <td>延长等级有效期 {$code->number} 天</td>
                                                            {/if}
                                                            <td>{$code->usedatetime}</td>
                                                        </tr>
                                                    {/if}
                                                {/foreach}
                                            </table>
                                            {$codes->render()}
                                        </div>
                                    </div>


                            </div>
                        </div>
                    </div>
                </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="readytopay" role="dialog" tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">正在连接支付网关</h2>
                            </div>
                            <div class="modal-inner">
                                <p id="title">感谢您对我们的支持，请耐心等待</p>
                            </div>
                        </div>
                    </div>
                </div>

                {include file='dialog.tpl'}
            </div>
        </section>
    </div>
</main>
<script>
	$(document).ready(function () {
		$("#code-update").click(function () {
			$.ajax({
				type: "POST",
				url: "code",
				dataType: "json",
				data: {
					code: $("#code").val()
				},
				success: function (data) {
					if (data.ret) {
						$("#result").modal();
						$("#msg").html(data.msg);
						window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
					} else {
						$("#result").modal();
						$("#msg").html(data.msg);
						window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
					}
				},
				error: function (jqXHR) {
					$("#result").modal();
					$("#msg").html("发生错误：" + jqXHR.status);
				}
			})
		})
})
</script>

<script>
    $(document).ready(function () {
        $("#uptopay").click(function () {
            $.ajax({
                type: "POST",
                url: "/uptopay",
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

<script>
    $(document).ready(function () {
        $("#uptocncdn").click(function () {
            $.ajax({
                type: "POST",
                url: "/uptocncdn",
                dataType: "json",
                data: {
                },
                success: function (data) {
                    if (data.ret) {
                        $("#result").modal();
                        $("#msg").html("申请 "+data.msg+" 成功,在客户端更新订阅获取新节点");
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
