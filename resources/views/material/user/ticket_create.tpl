


{include file='user/main.tpl'}







	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">创建工单 - 精确描述您的问题</h1>
			</div>
		</div>
		<div class="container">
			<div class="col-lg-12 col-sm-12">
				<section class="content-inner margin-top-no">
					
					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<div class="form-group form-group-label">
									<label class="floating-label" for="title">标题 - 您的核心问题</label>
									<input class="form-control maxwidth-edit" id="title" type="text" >
								</div>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<div class="form-group form-group-label">
									<div>
										<p><code>我是否已阅读</code><a href="/user/announcement" target="_blank"> 帮助中心</a>？<br><code>我可以上传图片，来表现更多信息</code>><a href="https://imgchr.com/" target="_blank">点击上传免费图片</a></p>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								<div class="form-group form-group-label">
									<label class="floating-label" for="content">内容</label>
									<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/editor.md@1.5.0/css/editormd.min.css" />
									<div id="editormd">
										<textarea style="display:none;" id="content">
1. 你的使用场景是什么？:软件版本、设备型号、
: 

2. 你看到的不正常的现象是什么？ :节点、浏览器、帐号、报错
: 

3. 你期待看到的正确表现是怎样的？
: 

4. *请附上出错时软件输出的错误日志。*（V2rayN在界面最下方，其他软件在Logs/日志查看）
: </textarea>
									</div>
								</div>
								
								
								
								
							</div>
						</div>
					</div>
					
					
					
					<div class="card">
						<div class="card-main">
							<div class="card-inner">
								
								<div class="form-group">
									<div class="row">
										<div class="col-md-10 col-md-push-1">
											<button id="submit" type="submit" class="btn btn-block btn-brand">添加 并 - {$config["ticket_price"]}￥</button>
											<p>感谢您的耐心提问，有价值的工单将会被公开回复，并帮助到其他用户，并 + {$config["ticket_price"]}￥。</p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					{include file='dialog.tpl'}

							
			</div>
			
			
			
		</div>
	</main>






{include file='user/footer.tpl'}




<script src="https://cdn.jsdelivr.net/npm/editor.md@1.5.0/editormd.min.js"></script>
<script>
    $(document).ready(function () {
        function submit() {
			$("#result").modal();
            $("#msg").html("正在提交。");
            $.ajax({
                type: "POST",
                url: "/user/ticket",
                dataType: "json",
                data: {
                    content: editor.getHTML(),
					title: $("#title").val()
                },
                success: function (data) {
                    if (data.ret) {
                        $("#result").modal();
                        $("#msg").html(data.msg);
                        window.setTimeout("location.href='/user/ticket'", {$config['jump_delay']});
                    } else {
                        $("#result").modal();
                        $("#msg").html(data.msg);
                    }
                },
                error: function (jqXHR) {
                    $("#msg-error").hide(10);
                    $("#msg-error").show(100);
                    $("#msg-error-p").html("发生错误：" + jqXHR.status);
                }
            });
        }
		
        $("#submit").click(function () {
            submit();
        });
    });
	
    $(function() {
        editor = editormd("editormd", {
             path : "https://cdn.jsdelivr.net/npm/editor.md@1.5.0/lib/", // Autoload modules mode, codemirror, marked... dependents libs path
			height: 720,
			saveHTMLToTextarea : true,
			emoji : true
        });

        /*
        // or
        var editor = editormd({
            id   : "editormd",
            path : "../lib/"
        });
        */
    });
</script>







