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
									{$group=array(5,4,3,2,1,0)}
									{$vip=array(10,9,8,7,6,5,4,3,2,1,0)}

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
											<td>24H:GB</td>
											<td>{$sts->getLiveUserAll()}</td>
											<td>{$sts->getLiveUserByGroup(5)}:{$sts->getTrafficLeftDailyGb(5)}G</td>
											<td>{$sts->getLiveUserByGroup(4)}:{$sts->getTrafficLeftDailyGb(4)}G</td>
											<td>{$sts->getLiveUserByGroup(3)}:{$sts->getTrafficLeftDailyGb(3)}G</td>
											<td>{$sts->getLiveUserByGroup(2)}:{$sts->getTrafficLeftDailyGb(2)}G</td>
											<td>{$sts->getLiveUserByGroup(1)}:{$sts->getTrafficLeftDailyGb(1)}G</td>
										</tr>
										<tr>
											<td>30M:M¥</td>
											<td>{$sts->getLiveUserAllIn30Min()}:{$sts->getCostAll()*8}¥</td>
											<td>{$sts->getGroupLiveUserIn30Min(5)}:{$sts->getCostByGroup(5)*8}¥</td>
											<td>{$sts->getGroupLiveUserIn30Min(4)}:{$sts->getCostByGroup(4)*8}¥</td>
											<td>{$sts->getGroupLiveUserIn30Min(3)}:{$sts->getCostByGroup(3)*8}¥</td>
											<td>{$sts->getGroupLiveUserIn30Min(2)}:{$sts->getCostByGroup(2)*8}¥</td>
											<td>{$sts->getGroupLiveUserIn30Min(1)}:{$sts->getCostByGroup(1)*8}¥</td>
										</tr>
									</table>


									<table class="table">
										<tr>
											<td>名</td>
											<!-- <td>参数</td> -->
											<td>值</td>
										</tr>
										<tr>
											<td>组5供给</td>
											<td>{$sts->getRecord('traffic_record_group5')}</td>
										</tr>
										<tr>
											<td>组4供给</td>
											<td>{$sts->getRecord('traffic_record_group4')}</td>
										</tr>
										<tr>
											<td>组3供给</td>
											<td>{$sts->getRecord('traffic_record_group3')}</td>
										</tr>
										<tr>
											<td>组2供给</td>
											<td>{$sts->getRecord('traffic_record_group2')}</td>
										</tr>
										<tr>
											<td>组1供给</td>
											<td>{$sts->getRecord('traffic_record_group1')}</td>
										</tr>
									</table>


									<table class="table">
										<tr>
											<th>24H:¥</th>
											{foreach $group as $g }
												<th>G{$g}</th>
											{/foreach}
										</tr>
										{foreach $vip as $v}
										<tr>
											<td>V{$v}</td>
											{foreach $group as $g} 
											<td>{$sts->getLiveUserByVipAndGroup($v,$g)}:{$sts->getCostByVipAndGroup($v,$g)}$</td>
											{/foreach}
										</tr>
										{/foreach}
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>


{include file='admin/footer.tpl'}
