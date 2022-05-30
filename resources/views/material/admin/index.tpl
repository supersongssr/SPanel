{include file='admin/main.tpl'}

	<main class="content">
		<div class="content-header ui-content-header">
			<div class="container">
				<h1 class="content-heading">汇总</h1>
			</div>
		</div>
		<div class="container">
			<section class="content-inner margin-top-no">
				<div class="row">
					<div class="col-xx-12">
						<div class="card margin-bottom-no">
							<div class="card-main">
								<div class="card-inner">

									<table class="table">
										<tr>
											<th>数据</th>
											<th>ALL</th>
											<th>10</th>
											<th>9</th>
											<th>8</th>
											<th>7</th>
											<th>6</th>
											<th>5</th>
											<th>4</th>
											<th>3</th>
											<th>2</th>
											<th>1</th>
										</tr>
										<tr>
											<td>Usr</td>
											<td>{$sts->getALLUser()}</td>
											<td>{$sts->getVIPUser(10)}</td>
											<td>{$sts->getVIPUser(9)}</td>
											<td>{$sts->getVIPUser(8)}</td>
											<td>{$sts->getVIPUser(7)}</td>
											<td>{$sts->getVIPUser(6)}</td>
											<td>{$sts->getVIPUser(5)}</td>
											<td>{$sts->getVIPUser(4)}</td>
											<td>{$sts->getVIPUser(3)}</td>
											<td>{$sts->getVIPUser(2)}</td>
											<td>{$sts->getVIPUser(1)}</td>
										</tr>
										<!-- <tr>
											<td>ALL</td>
											<td>{$sts->getCostALLNode()}|{$sts->getALLLiveUser()}</td>
											<td>{$sts->getCostVIPNode(10)-$sts->getVIPLiveUser(10)}</td>
											<td>{$sts->getCostVIPNode(9)-$sts->getVIPLiveUser(9)}</td>
											<td>{$sts->getCostVIPNode(8)-$sts->getVIPLiveUser(8)}</td>
											<td>{$sts->getCostVIPNode(7)-$sts->getVIPLiveUser(7)}</td>
											<td>{$sts->getCostVIPNode(6)-$sts->getVIPLiveUser(6)}</td>
											<td>{$sts->getCostVIPNode(5)-$sts->getVIPLiveUser(5)}</td>
											<td>{$sts->getCostVIPNode(4)-$sts->getVIPLiveUser(4)}</td>
											<td>{$sts->getCostVIPNode(3)-$sts->getVIPLiveUser(3)}</td>
											<td>{$sts->getCostVIPNode(2)-$sts->getVIPLiveUser(2)}</td>
											<td>{$sts->getCostVIPNode(1)-$sts->getVIPLiveUser(1)}</td>
										</tr> -->
										<tr>
											<td>1组</td>
											<td>{$sts->getCostGroupNode(1)}|{$sts->getGroupLiveUser(1)}</td>
											<td>{$sts->getCostVIPGroupNode(10,1)-$sts->getVIPGroupLiveUser(10,1)}</td>
											<td>{$sts->getCostVIPGroupNode(9,1)-$sts->getVIPGroupLiveUser(9,1)}</td>
											<td>{$sts->getCostVIPGroupNode(8,1)-$sts->getVIPGroupLiveUser(8,1)}</td>
											<td>{$sts->getCostVIPGroupNode(7,1)-$sts->getVIPGroupLiveUser(7,1)}</td>
											<td>{$sts->getCostVIPGroupNode(6,1)-$sts->getVIPGroupLiveUser(6,1)}</td>
											<td>{$sts->getCostVIPGroupNode(5,1)-$sts->getVIPGroupLiveUser(5,1)}</td>
											<td>{$sts->getCostVIPGroupNode(4,1)-$sts->getVIPGroupLiveUser(4,1)}</td>
											<td>{$sts->getCostVIPGroupNode(3,1)-$sts->getVIPGroupLiveUser(3,1)}</td>
											<td>{$sts->getCostVIPGroupNode(2,1)-$sts->getVIPGroupLiveUser(2,1)}</td>
											<td>{$sts->getCostVIPGroupNode(1,1)-$sts->getVIPGroupLiveUser(1,1)}</td>
										</tr>
										<tr>
											<td>2组</td>
											<td>{$sts->getCostGroupNode(2)}|{$sts->getGroupLiveUser(2)}</td>
											<td>{$sts->getCostVIPGroupNode(10,2)-$sts->getVIPGroupLiveUser(10,2)}</td>
											<td>{$sts->getCostVIPGroupNode(9,2)-$sts->getVIPGroupLiveUser(9,2)}</td>
											<td>{$sts->getCostVIPGroupNode(8,2)-$sts->getVIPGroupLiveUser(8,2)}</td>
											<td>{$sts->getCostVIPGroupNode(7,2)-$sts->getVIPGroupLiveUser(7,2)}</td>
											<td>{$sts->getCostVIPGroupNode(6,2)-$sts->getVIPGroupLiveUser(6,2)}</td>
											<td>{$sts->getCostVIPGroupNode(5,2)-$sts->getVIPGroupLiveUser(5,2)}</td>
											<td>{$sts->getCostVIPGroupNode(4,2)-$sts->getVIPGroupLiveUser(4,2)}</td>
											<td>{$sts->getCostVIPGroupNode(3,2)-$sts->getVIPGroupLiveUser(3,2)}</td>
											<td>{$sts->getCostVIPGroupNode(2,2)-$sts->getVIPGroupLiveUser(2,2)}</td>
											<td>{$sts->getCostVIPGroupNode(1,2)-$sts->getVIPGroupLiveUser(1,2)}</td>
										</tr>
										<tr>
											<td>3组</td>
											<td>{$sts->getCostGroupNode(3)}|{$sts->getGroupLiveUser(3)}</td>
											<td>{$sts->getCostVIPGroupNode(10,3)-$sts->getVIPGroupLiveUser(10,3)}</td>
											<td>{$sts->getCostVIPGroupNode(9,3)-$sts->getVIPGroupLiveUser(9,3)}</td>
											<td>{$sts->getCostVIPGroupNode(8,3)-$sts->getVIPGroupLiveUser(8,3)}</td>
											<td>{$sts->getCostVIPGroupNode(7,3)-$sts->getVIPGroupLiveUser(7,3)}</td>
											<td>{$sts->getCostVIPGroupNode(6,3)-$sts->getVIPGroupLiveUser(6,3)}</td>
											<td>{$sts->getCostVIPGroupNode(5,3)-$sts->getVIPGroupLiveUser(5,3)}</td>
											<td>{$sts->getCostVIPGroupNode(4,3)-$sts->getVIPGroupLiveUser(4,3)}</td>
											<td>{$sts->getCostVIPGroupNode(3,3)-$sts->getVIPGroupLiveUser(3,3)}</td>
											<td>{$sts->getCostVIPGroupNode(2,3)-$sts->getVIPGroupLiveUser(2,3)}</td>
											<td>{$sts->getCostVIPGroupNode(1,3)-$sts->getVIPGroupLiveUser(1,3)}</td>
										</tr>
										<tr>
											<td>4组</td>
											<td>{$sts->getCostGroupNode(4)}|{$sts->getGroupLiveUser(4)}</td>
											<td>{$sts->getCostVIPGroupNode(10,4)-$sts->getVIPGroupLiveUser(10,4)}</td>
											<td>{$sts->getCostVIPGroupNode(9,4)-$sts->getVIPGroupLiveUser(9,4)}</td>
											<td>{$sts->getCostVIPGroupNode(8,4)-$sts->getVIPGroupLiveUser(8,4)}</td>
											<td>{$sts->getCostVIPGroupNode(7,4)-$sts->getVIPGroupLiveUser(7,4)}</td>
											<td>{$sts->getCostVIPGroupNode(6,4)-$sts->getVIPGroupLiveUser(6,4)}</td>
											<td>{$sts->getCostVIPGroupNode(5,4)-$sts->getVIPGroupLiveUser(5,4)}</td>
											<td>{$sts->getCostVIPGroupNode(4,4)-$sts->getVIPGroupLiveUser(4,4)}</td>
											<td>{$sts->getCostVIPGroupNode(3,4)-$sts->getVIPGroupLiveUser(3,4)}</td>
											<td>{$sts->getCostVIPGroupNode(2,4)-$sts->getVIPGroupLiveUser(2,4)}</td>
											<td>{$sts->getCostVIPGroupNode(1,4)-$sts->getVIPGroupLiveUser(1,4)}</td>
										</tr>

										<tr>
											<td>5组</td>
											<td>{$sts->getCostGroupNode(5)}|{$sts->getGroupLiveUser(5)}</td>
											<td>{$sts->getCostVIPGroupNode(10,5)-$sts->getVIPGroupLiveUser(10,5)}</td>
											<td>{$sts->getCostVIPGroupNode(9,5)-$sts->getVIPGroupLiveUser(9,5)}</td>
											<td>{$sts->getCostVIPGroupNode(8,5)-$sts->getVIPGroupLiveUser(8,5)}</td>
											<td>{$sts->getCostVIPGroupNode(7,5)-$sts->getVIPGroupLiveUser(7,5)}</td>
											<td>{$sts->getCostVIPGroupNode(6,5)-$sts->getVIPGroupLiveUser(6,5)}</td>
											<td>{$sts->getCostVIPGroupNode(5,5)-$sts->getVIPGroupLiveUser(5,5)}</td>
											<td>{$sts->getCostVIPGroupNode(4,5)-$sts->getVIPGroupLiveUser(4,5)}</td>
											<td>{$sts->getCostVIPGroupNode(3,5)-$sts->getVIPGroupLiveUser(3,5)}</td>
											<td>{$sts->getCostVIPGroupNode(2,5)-$sts->getVIPGroupLiveUser(2,5)}</td>
											<td>{$sts->getCostVIPGroupNode(1,5)-$sts->getVIPGroupLiveUser(1,5)}</td>
										</tr>

									</table>

									<table class="table">
										<tr>
											<td>分组</td>
											<td>5组</td>
											<td>4组</td>
											<td>3组</td>
											<td>2组</td>
											<td>1组</td>
										</tr>
										<tr>
											<td>vip</td>
											<td>{$sts->getGroupUser(5)}</td>
											<td>{$sts->getGroupUser(4)}</td>
											<td>{$sts->getGroupUser(3)}</td>
											<td>{$sts->getGroupUser(2)}</td>
											<td>{$sts->getGroupUser(1)}</td>
										</tr>
									</table>

									<table class="table">
										<tr>
											<td>备注</td>
											<td>参数</td>
											<td>值</td>
										</tr>
										<tr>
											<td>全日消耗</td>
											<td>all_traffic_daily_mark</td>
											<td>{$sts->getRecord('all_traffic_daily_mark')}</td>
										</tr>
										<tr>
											<td>全日供给</td>
											<td>all_traffic_daily_supply</td>
											<td>{$sts->getRecord('all_traffic_daily_supply')}</td>
										</tr>
										<tr>
											<td>组1日消耗</td>
											<td>group1_traffic_daily_mark</td>
											<td>{$sts->getRecord('group1_traffic_daily_mark')}</td>
										</tr>
										<tr>
											<td>组1日供给</td>
											<td>group1_traffic_daily_supply</td>
											<td>{$sts->getRecord('group1_traffic_daily_supply')}</td>
										</tr>
										<tr>
											<td>组2日消耗</td>
											<td>group2_traffic_daily_mark</td>
											<td>{$sts->getRecord('group2_traffic_daily_mark')}</td>
										</tr>
										<tr>
											<td>组2日供给</td>
											<td>group2_traffic_daily_supply</td>
											<td>{$sts->getRecord('group2_traffic_daily_supply')}</td>
										</tr>
										<tr>
											<td>组4日消耗</td>
											<td>group4_traffic_daily_mark</td>
											<td>{$sts->getRecord('group4_traffic_daily_mark')}</td>
										</tr>
										<tr>
											<td>组4日供给</td>
											<td>group4_traffic_daily_supply</td>
											<td>{$sts->getRecord('group4_traffic_daily_supply')}</td>
										</tr>
									</table>


								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="ui-card-wrap">
					<div class="row">

						<div class="col-xx-12 col-sm-6">


							<div class="card">
								<div class="card-main">
									<div class="card-inner">

										<div id="check_chart" style="height: 300px; width: 100%;"></div>

										<script src="/jscdn/gh/SuicidalCat/canvasjs.js@v2.3.1/canvasjs.min.js"></script>
                                        <script>
											var chart = new CanvasJS.Chart("check_chart",
											{
												title:{
													text: "用户签到情况(总用户 {$sts->getTotalUser()}人)",
													fontFamily: "Impact",
													fontWeight: "normal"
												},

												legend:{
													verticalAlign: "bottom",
													horizontalAlign: "center"
												},
												data: [
												{
													//startAngle: 45,
													indexLabelFontSize: 20,
													indexLabelFontFamily: "Garamond",
													indexLabelFontColor: "darkgrey",
													indexLabelLineColor: "darkgrey",
													indexLabelPlacement: "outside",
													type: "doughnut",
													showInLegend: true,
													dataPoints: [
														{
															y: {(1-($sts->getCheckinUser()/$sts->getTotalUser()))*100}, legendText:"没有签到过的用户 {number_format((1-($sts->getCheckinUser()/$sts->getTotalUser()))*100,2)}% {$sts->getTotalUser()-$sts->getCheckinUser()}人", indexLabel: "没有签到过的用户 {number_format((1-($sts->getCheckinUser()/$sts->getTotalUser()))*100,2)}% {$sts->getTotalUser()-$sts->getCheckinUser()}人"
														},
														{
															y: {(($sts->getCheckinUser()-$sts->getTodayCheckinUser())/$sts->getTotalUser())*100}, legendText:"曾经签到过的用户 {number_format((($sts->getCheckinUser()-$sts->getTodayCheckinUser())/$sts->getTotalUser())*100,2)}% {$sts->getCheckinUser()-$sts->getTodayCheckinUser()}人", indexLabel: "曾经签到过的用户 {number_format((($sts->getCheckinUser()-$sts->getTodayCheckinUser())/$sts->getTotalUser())*100,2)}% {$sts->getCheckinUser()-$sts->getTodayCheckinUser()}人"
														},
														{
															y: {$sts->getTodayCheckinUser()/$sts->getTotalUser()*100}, legendText:"今日签到用户 {number_format($sts->getTodayCheckinUser()/$sts->getTotalUser()*100,2)}% {$sts->getTodayCheckinUser()}人", indexLabel: "今日签到用户 {number_format($sts->getTodayCheckinUser()/$sts->getTotalUser()*100,2)}% {$sts->getTodayCheckinUser()}人"
														}
													]
												}
												]
											});

											chart.render();

											function chartRender(chart){
                                                chart.render();
                                                chart.ctx.shadowBlur = 8;
                                                chart.ctx.shadowOffsetX = 4;
                                                chart.ctx.shadowColor = "black";

                                                for (let i in chart.plotInfo.plotTypes) {
                                                    let plotType = chart.plotInfo.plotTypes[i];
                                                    for (let j in plotType.plotUnits) {
                                                        let plotUnit = plotType.plotUnits[j];
                                                        if (plotUnit.type === "doughnut") {
                                                            // For Column Chart
                                                            chart.renderDoughnut(plotUnit);
                                                        } else if (plotUnit.type === "bar") {
                                                            // For Bar Chart
                                                            chart.renderBar(plotUnit);
                                                        }
                                                    }
                                                }
                                                chart.ctx.shadowBlur = 0;
                                                chart.ctx.shadowOffsetX = 0;
                                                chart.ctx.shadowColor = "transparent";
                                            }
										</script>

									</div>

								</div>
							</div>


							<div class="card">
								<div class="card-main">
									<div class="card-inner">

										<div id="alive_chart" style="height: 300px; width: 100%;"></div>

										<script src="/jscdn/gh/YihanH/canvasjs.js@v2.2/canvasjs.min.js"></script>
										<script type="text/javascript">
											var chart = new CanvasJS.Chart("alive_chart",
											{
												title:{
													text: "用户在线情况(总用户 {$sts->getTotalUser()}人)",
													fontFamily: "Impact",
													fontWeight: "normal"
												},

												legend:{
													verticalAlign: "bottom",
													horizontalAlign: "center"
												},
												data: [
												{
													//startAngle: 45,
													indexLabelFontSize: 20,
													indexLabelFontFamily: "Garamond",
													indexLabelFontColor: "darkgrey",
													indexLabelLineColor: "darkgrey",
													indexLabelPlacement: "outside",
													type: "doughnut",
													showInLegend: true,
													dataPoints: [
														{
															y: {(($sts->getUnusedUser()/$sts->getTotalUser()))*100}, legendText:"从未在线的用户 {number_format((($sts->getUnusedUser()/$sts->getTotalUser()))*100,2)}% {(($sts->getUnusedUser()))}人", indexLabel: "从未在线的用户 {number_format((($sts->getUnusedUser()/$sts->getTotalUser()))*100,2)}% {(($sts->getUnusedUser()))}人"
														},
														{
															y: {(($sts->getTotalUser()-$sts->getOnlineUser(86400)-$sts->getUnusedUser())/$sts->getTotalUser())*100}, legendText:"一天以前在线的用户 {number_format((($sts->getTotalUser()-$sts->getOnlineUser(86400)-$sts->getUnusedUser())/$sts->getTotalUser())*100,2)}% {($sts->getTotalUser()-$sts->getOnlineUser(86400)-$sts->getUnusedUser())}人", indexLabel: "一天以前在线的用户 {number_format((($sts->getTotalUser()-$sts->getOnlineUser(86400)-$sts->getUnusedUser())/$sts->getTotalUser())*100,2)}% {($sts->getTotalUser()-$sts->getOnlineUser(86400)-$sts->getUnusedUser())}人"
														},
														{
															y: {($sts->getOnlineUser(86400)-$sts->getOnlineUser(3600))/$sts->getTotalUser()*100}, legendText:"一天内在线的用户 {number_format(($sts->getOnlineUser(86400)-$sts->getOnlineUser(3600))/$sts->getTotalUser()*100,2)}% {($sts->getOnlineUser(86400)-$sts->getOnlineUser(3600))}人", indexLabel: "一天内在线的用户 {number_format(($sts->getOnlineUser(86400)-$sts->getOnlineUser(3600))/$sts->getTotalUser()*100,2)}% {($sts->getOnlineUser(86400)-$sts->getOnlineUser(3600))}人"
														},
														{
															y: {($sts->getOnlineUser(3600)-$sts->getOnlineUser(60))/$sts->getTotalUser()*100}, legendText:"一小时内在线的用户 {number_format(($sts->getOnlineUser(3600)-$sts->getOnlineUser(60))/$sts->getTotalUser()*100,2)}% {($sts->getOnlineUser(3600)-$sts->getOnlineUser(60))}人", indexLabel: "一小时内在线的用户 {number_format(($sts->getOnlineUser(3600)-$sts->getOnlineUser(60))/$sts->getTotalUser()*100,2)}% {($sts->getOnlineUser(3600)-$sts->getOnlineUser(60))}人"
														},
														{
															y: {($sts->getOnlineUser(60))/$sts->getTotalUser()*100}, legendText:"一分钟内在线的用户 {number_format(($sts->getOnlineUser(60))/$sts->getTotalUser()*100,2)}% {($sts->getOnlineUser(60))}人", indexLabel: "一分钟内在线的用户 {number_format(($sts->getOnlineUser(60))/$sts->getTotalUser()*100,2)}% {($sts->getOnlineUser(60))}人"
														}
													]
												}
												]
											});

											chart.render();
										</script>

									</div>

								</div>
							</div>


						</div>


						<div class="col-xx-12 col-sm-6">


							<div class="card">
								<div class="card-main">
									<div class="card-inner">

										<div id="node_chart" style="height: 300px; width: 100%;"></div>

										<script src="/jscdn/gh/YihanH/canvasjs.js@v2.2/canvasjs.min.js"></script>
										<script type="text/javascript">
											var chart = new CanvasJS.Chart("node_chart",
											{
												title:{
													text: "节点在线情况(节点数 {$sts->getTotalNodes()}个)",
													fontFamily: "Impact",
													fontWeight: "normal"
												},

												legend:{
													verticalAlign: "bottom",
													horizontalAlign: "center"
												},
												data: [
												{
													//startAngle: 45,
													indexLabelFontSize: 20,
													indexLabelFontFamily: "Garamond",
													indexLabelFontColor: "darkgrey",
													indexLabelLineColor: "darkgrey",
													indexLabelPlacement: "outside",
													type: "doughnut",
													showInLegend: true,
													dataPoints: [
														{if $sts->getTotalNodes()!=0}
															{
																y: {(1-($sts->getAliveNodes()/$sts->getTotalNodes()))*100}, legendText:"离线节点 {number_format((1-($sts->getAliveNodes()/$sts->getTotalNodes()))*100,2)}% {$sts->getTotalNodes()-$sts->getAliveNodes()}个", indexLabel: "离线节点 {number_format((1-($sts->getAliveNodes()/$sts->getTotalNodes()))*100,2)}% {$sts->getTotalNodes()-$sts->getAliveNodes()}个"
															},
															{
																y: {(($sts->getAliveNodes()/$sts->getTotalNodes()))*100}, legendText:"在线节点 {number_format((($sts->getAliveNodes()/$sts->getTotalNodes()))*100,2)}% {$sts->getAliveNodes()}个", indexLabel: "在线节点 {number_format((($sts->getAliveNodes()/$sts->getTotalNodes()))*100,2)}% {$sts->getAliveNodes()}个"
															}
														{/if}
													]
												}
												]
											});

											chart.render();
										</script>

									</div>

								</div>
							</div>


							<div class="card">
								<div class="card-main">
									<div class="card-inner">

										<div id="traffic_chart" style="height: 300px; width: 100%;"></div>

										<script src="/jscdn/gh/YihanH/canvasjs.js@v2.2/canvasjs.min.js"></script>
										<script type="text/javascript">
											var chart = new CanvasJS.Chart("traffic_chart",
											{
												title:{
													text: "流量使用情况(总分配流量 {$sts->getTotalTraffic()})",
													fontFamily: "Impact",
													fontWeight: "normal"
												},

												legend:{
													verticalAlign: "bottom",
													horizontalAlign: "center"
												},
												data: [
												{
													//startAngle: 45,
													indexLabelFontSize: 20,
													indexLabelFontFamily: "Garamond",
													indexLabelFontColor: "darkgrey",
													indexLabelLineColor: "darkgrey",
													indexLabelPlacement: "outside",
													type: "doughnut",
													showInLegend: true,
													dataPoints: [
														{if $sts->getRawTotalTraffic()!=0}
															{
																y: {(($sts->getRawUnusedTrafficUsage()/$sts->getRawTotalTraffic()))*100},label: "总剩余可用", legendText:"总剩余可用 {number_format((($sts->getRawUnusedTrafficUsage()/$sts->getRawTotalTraffic()))*100,2)}% {(($sts->getUnusedTrafficUsage()))}", indexLabel: "总剩余可用 {number_format((($sts->getRawUnusedTrafficUsage()/$sts->getRawTotalTraffic()))*100,2)}% {(($sts->getUnusedTrafficUsage()))}"
															},
															{
																y: {(($sts->getRawLastTrafficUsage()/$sts->getRawTotalTraffic()))*100},label: "总过去已用", legendText:"总过去已用 {number_format((($sts->getRawLastTrafficUsage()/$sts->getRawTotalTraffic()))*100,2)}% {(($sts->getLastTrafficUsage()))}", indexLabel: "总过去已用 {number_format((($sts->getRawLastTrafficUsage()/$sts->getRawTotalTraffic()))*100,2)}% {(($sts->getLastTrafficUsage()))}"
															},
															{
																y: {(($sts->getRawTodayTrafficUsage()/$sts->getRawTotalTraffic()))*100},label: "总今日已用", legendText:"总今日已用 {number_format((($sts->getRawTodayTrafficUsage()/$sts->getRawTotalTraffic()))*100,2)}% {(($sts->getTodayTrafficUsage()))}", indexLabel: "总今日已用 {number_format((($sts->getRawTodayTrafficUsage()/$sts->getRawTotalTraffic()))*100,2)}% {(($sts->getTodayTrafficUsage()))}"
															}
														{/if}
													]
												}
												]
											});

											chart.render();
										</script>

									</div>

								</div>
							</div>


						</div>

					</div>
				</div>
			</section>
		</div>
	</main>



{include file='admin/footer.tpl'}
