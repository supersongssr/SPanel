{include file='user/main.tpl'}
	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">虚空之地</h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="ui-card-wrap">
					<div class="col-lg-12 col-md-12">
						<section class="content-inner margin-top-no">
						<div class="card">
							<div class="card-main">
								<div class="card-inner">
									<p>您由于某些原因而被系统禁用了账户。</p>
									<p>
										可能原因如下：
										<br>1、账号长期未使用，需要重新激活。
										<br>2、订阅请求来源异常，疑似账号泄露，启用账号保护。
										<br>3、账号流量异常，启用账号保护。
										<br>4、账号ip数异常，启用账号保护。
										<br>5、您的账号余额 < 0，被系统自动禁用。
										<br>6、其他违反注册协议的行为。
									</p>
									{if $config["enable_admin_contact"] == 'true'}
										<p>管理员联系方式：</p>
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
								</div>
							</div>
						</div>
						<div class="auth-main auth-row auth-col-one">
							<div class="auth-row">
								<div class="form-group-label auth-row row-login">
									<label class="floating-label" for="email">请输入当前账号的邮箱 </label>
									<input class="form-control maxwidth-auth" id="email" type="text">
								</div>
							</div>
							<div class="btn-auth auth-row">
								<button id="reactive" type="submit" class="btn btn-block btn-brand waves-attach waves-light">解封账号</button>
							</div>
						</div>
					</div>
				</div>
			</section>

		</div>
	</main>


{include file='dialog.tpl'}
{include file='user/footer.tpl'}


<script>
    $(document).ready(function(){
        function reactive(){
			$("#result").modal();
            $("#msg").html("sending, please wait....");
            $.ajax({
                type:"POST",
                url:"/reactive",
                dataType:"json",
                data:{
                    email: $("#email").val(),
                },
                success:function(data){
                    if(data.ret == 1){
                        $("#result").modal();
                        $("#msg").html(data.msg);
                       window.setTimeout("location.href='/user/code'", 2000);
                    }else{
                        $("#result").modal();
                        $("#msg").html(data.msg);
                    }
                },
                error:function(jqXHR){
                    $("#result").modal();
                    $("#msg").html(data.msg);
                }
            });
        }
        $("html").keydown(function(event){
            if(event.keyCode==13){
                reactive();
            }
        });
        $("#reactive").click(function(){
            reactive();
        });
    })
</script>
