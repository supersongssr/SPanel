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
											<th>1:$</th>
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
											<th>0</th>
										</tr>
										<tr>
											<td>24H</td>
											<td>{round($sts->getLiveUserAll()/$sts->getCostAll())}</td>
											<td>{$sts->getLiveUserByVip(10)}</td>
											<td>{$sts->getLiveUserByVip(9)}</td>
											<td>{$sts->getLiveUserByVip(8)}</td>
											<td>{$sts->getLiveUserByVip(7)}</td>
											<td>{$sts->getLiveUserByVip(6)}</td>
											<td>{$sts->getLiveUserByVip(5)}</td>
											<td>{$sts->getLiveUserByVip(4)}</td>
											<td>{$sts->getLiveUserByVip(3)}</td>
											<td>{$sts->getLiveUserByVip(2)}</td>
											<td>{$sts->getLiveUserByVip(1)}</td>
											<td>{$sts->getLiveUserByVip(0)}</td>
										</tr>
									
										<tr>
											<td>G 5</td>
											<td>{$sts->getLiveUserByGroup(5)}:${$sts->getCostByGroup(5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(10,5)}:${$sts->getCostByVipAndGroup(10,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(9,5)}:${$sts->getCostByVipAndGroup(9,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(8,5)}:${$sts->getCostByVipAndGroup(8,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(7,5)}:${$sts->getCostByVipAndGroup(7,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(6,5)}:${$sts->getCostByVipAndGroup(6,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(5,5)}:${$sts->getCostByVipAndGroup(5,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(4,5)}:${$sts->getCostByVipAndGroup(4,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(3,5)}:${$sts->getCostByVipAndGroup(3,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(2,5)}:${$sts->getCostByVipAndGroup(2,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(1,5)}:${$sts->getCostByVipAndGroup(1,5)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(0,5)}:${$sts->getCostByVipAndGroup(0,5)}</td>
										</tr>

										<tr>
											<td>G 4</td>
											<td>{$sts->getLiveUserByGroup(4)}:${$sts->getCostByGroup(4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(10,4)}:${$sts->getCostByVipAndGroup(10,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(9,4)}:${$sts->getCostByVipAndGroup(9,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(8,4)}:${$sts->getCostByVipAndGroup(8,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(7,4)}:${$sts->getCostByVipAndGroup(7,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(6,4)}:${$sts->getCostByVipAndGroup(6,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(5,4)}:${$sts->getCostByVipAndGroup(5,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(4,4)}:${$sts->getCostByVipAndGroup(4,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(3,4)}:${$sts->getCostByVipAndGroup(3,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(2,4)}:${$sts->getCostByVipAndGroup(2,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(1,4)}:${$sts->getCostByVipAndGroup(1,4)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(0,4)}:${$sts->getCostByVipAndGroup(0,4)}</td>
										</tr>

										

										<tr>
											<td>G 3</td>
											<td>{$sts->getLiveUserByGroup(3)}:${$sts->getCostByGroup(3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(10,3)}:${$sts->getCostByVipAndGroup(10,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(9,3)}:${$sts->getCostByVipAndGroup(9,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(8,3)}:${$sts->getCostByVipAndGroup(8,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(7,3)}:${$sts->getCostByVipAndGroup(7,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(6,3)}:${$sts->getCostByVipAndGroup(6,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(5,3)}:${$sts->getCostByVipAndGroup(5,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(4,3)}:${$sts->getCostByVipAndGroup(4,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(3,3)}:${$sts->getCostByVipAndGroup(3,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(2,3)}:${$sts->getCostByVipAndGroup(2,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(1,3)}:${$sts->getCostByVipAndGroup(1,3)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(0,3)}:${$sts->getCostByVipAndGroup(0,3)}</td>
										</tr>

										<tr>
											<td>G 2</td>
											<td>{$sts->getLiveUserByGroup(2)}:${$sts->getCostByGroup(2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(10,2)}:${$sts->getCostByVipAndGroup(10,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(9,2)}:${$sts->getCostByVipAndGroup(9,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(8,2)}:${$sts->getCostByVipAndGroup(8,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(7,2)}:${$sts->getCostByVipAndGroup(7,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(6,2)}:${$sts->getCostByVipAndGroup(6,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(5,2)}:${$sts->getCostByVipAndGroup(5,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(4,2)}:${$sts->getCostByVipAndGroup(4,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(3,2)}:${$sts->getCostByVipAndGroup(3,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(2,2)}:${$sts->getCostByVipAndGroup(2,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(1,2)}:${$sts->getCostByVipAndGroup(1,2)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(0,2)}:${$sts->getCostByVipAndGroup(0,2)}</td>
										</tr>

										
									
										<tr>
											<td>G 1</td>
											<td>{$sts->getLiveUserByGroup(1)}:${$sts->getCostByGroup(1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(10,1)}:${$sts->getCostByVipAndGroup(10,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(9,1)}:${$sts->getCostByVipAndGroup(9,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(8,1)}:${$sts->getCostByVipAndGroup(8,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(7,1)}:${$sts->getCostByVipAndGroup(7,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(6,1)}:${$sts->getCostByVipAndGroup(6,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(5,1)}:${$sts->getCostByVipAndGroup(5,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(4,1)}:${$sts->getCostByVipAndGroup(4,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(3,1)}:${$sts->getCostByVipAndGroup(3,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(2,1)}:${$sts->getCostByVipAndGroup(2,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(1,1)}:${$sts->getCostByVipAndGroup(1,1)}</td>
											<td>{$sts->getLiveUserByVipAndGroup(0,1)}:${$sts->getCostByVipAndGroup(0,1)}</td>
										</tr>

										
									
									</table>

									<table class="table">
										<tr>
											<td>分组</td>
											<td>All</td>
											<td>5组</td>
											<td>4组</td>
											<td>3组</td>
											<td>2组</td>
											<td>1组</td>
										</tr>
										<tr>
											<td>vip</td>
											<td>{$sts->getUserAll()}</td>
											<td>{$sts->getGroupUser(5)}</td>
											<td>{$sts->getGroupUser(4)}</td>
											<td>{$sts->getGroupUser(3)}</td>
											<td>{$sts->getGroupUser(2)}</td>
											<td>{$sts->getGroupUser(1)}</td>
										</tr>
										<tr>
											<td>LiveIn24H</td>
											<td>{$sts->getLiveUserAll()}</td>
											<td>{$sts->getLiveUserByGroup(5)}</td>
											<td>{$sts->getLiveUserByGroup(4)}</td>
											<td>{$sts->getLiveUserByGroup(3)}</td>
											<td>{$sts->getLiveUserByGroup(2)}</td>
											<td>{$sts->getLiveUserByGroup(1)}</td>
										</tr>
										<tr>
											<td>LiveIn30M</td>
											<td>{$sts->getLiveUserAllIn30Min()}</td>
											<td>{$sts->getGroupLiveUserIn30Min(5)}</td>
											<td>{$sts->getGroupLiveUserIn30Min(4)}</td>
											<td>{$sts->getGroupLiveUserIn30Min(3)}</td>
											<td>{$sts->getGroupLiveUserIn30Min(2)}</td>
											<td>{$sts->getGroupLiveUserIn30Min(1)}</td>
										</tr>
									</table>

									<table class="table">
										<tr>
											<td>名</td>
											<!-- <td>参数</td> -->
											<td>值</td>
										</tr>
										<tr>
											<td>组1供给</td>
											<td>{$sts->getRecord('traffic_record_group1')}</td>
										</tr>
										<tr>
											<td>组2供给</td>
											<td>{$sts->getRecord('traffic_record_group2')}</td>
										</tr>
										<tr>
											<td>组3供给</td>
											<td>{$sts->getRecord('traffic_record_group3')}</td>
										</tr>
										<tr>
											<td>组4供给</td>
											<td>{$sts->getRecord('traffic_record_group4')}</td>
										</tr>
										<tr>
											<td>组5供给</td>
											<td>{$sts->getRecord('traffic_record_group5')}</td>
										</tr>
										
									</table>


								</div>
							</div>
						</div>
					</div>
				</div>


{include file='admin/footer.tpl'}
