<?php

namespace App\Command;

/***
 * Class XCat
 * @package App\Command
 */

use App\Models\User;
use App\Models\Relay;
use App\Services\Gateway\ChenPay;
use App\Utils\Hash;
use App\Utils\Tools;
use App\Services\Config;
//song
use App\Models\NodeInfoLog;
use App\Models\NodeOnlineLog;
use App\Models\Record;  // record表
use App\Models\DetectLog;
use App\Models\Speedtest;
use App\Models\EmailVerify;
use App\Utils\Telegram;



use App\Models\TrafficLog;
use App\Models\Cncdn;
//song
use App\Models\Bought;
use App\Models\Payback;
use App\Models\Code;
use App\Models\Node;

use App\Utils\GA;
use App\Utils\QRcode;

class XCat
{
    public $argv;

    public function __construct($argv)
    {
        $this->argv = $argv;
    }

    public function boot()
    {
        switch ($this->argv[1]) {
            case("alipay"):
                return (new ChenPay())->AliPayListen();
            case("wxpay"):
                return (new ChenPay())->WxPayListen();
                //song
            case("banUsernoPay"):
                return $this->banUsernoPay();
            case("test"):
                return $this->test();
            case("transRecord"):
                return $this->transRecord();
            case("createAdmin"):
                return $this->createAdmin();
            case("resetTraffic"):
                return $this->resetTraffic();
            case("setTelegram"):
                return $this->setTelegram();
            case("initQQWry"):
                 return $this->initQQWry();
            case("sendDiaryMail"):
                return DailyMail::sendDailyMail();
            case("sendFinanceMail_day"):
                return FinanceMail::sendFinanceMail_day();
            case("sendFinanceMail_week"):
                return FinanceMail::sendFinanceMail_week();
            case("sendFinanceMail_month"):
                return FinanceMail::sendFinanceMail_month();
            case("reall"):
                    return DailyMail::reall();
            case("syncusers"):
                    return SyncRadius::syncusers();
            case("synclogin"):
                    return SyncRadius::synclogin();
            case("syncvpn"):
                return SyncRadius::syncvpn();
            case("nousers"):
                    return ExtMail::sendNoMail();
            case("oldusers"):
                    return ExtMail::sendOldMail();
            case("syncnode"):
                    return Job::syncnode();
            case("syncnasnode"):
                    return Job::syncnasnode();
            case("detectGFW"):
                return Job::detectGFW();
            case("syncnas"):
                    return SyncRadius::syncnas();
            case("dailyjob"):
                return Job::DailyJob();
            case("checkjob"):
                return Job::CheckJob();
            case("dbclean"):
                return Job::DbClean();
            case("userga"):
                return Job::UserGa();
            case("backup"):
                return Job::backup(false);
            case("backupfull"):
                return Job::backup(true);
            case("initdownload"):
                return $this->initdownload();
            case("updatedownload"):
                return Job::updatedownload();
            case("cleanRelayRule"):
                return $this->cleanRelayRule();
            case("resetPort"):
                return $this->resetPort();
            case("resetAllPort"):
                return $this->resetAllPort();
            case("update"):
                return Update::update($this);
            case ("sendDailyUsageByTG"):
                return $this->sendDailyUsageByTG();
            case('npmbuild'):
                return $this->npmbuild();
            default:
                return $this->defaultAction();
        }
    }

    public function defaultAction()
    {
        echo(PHP_EOL."用法： php xcat [选项]".PHP_EOL);
        echo("常用选项:".PHP_EOL);
        echo("  createAdmin - 创建管理员帐号".PHP_EOL);
        echo("  setTelegram - 设置 Telegram 机器人".PHP_EOL);
        echo("  cleanRelayRule - 清除所有中转规则".PHP_EOL);
        echo("  resetPort - 重置单个用户端口".PHP_EOL);
        echo("  resetAllPort - 重置所有用户端口".PHP_EOL);
        echo("  initdownload - 下载 SSR 程序至服务器".PHP_EOL);
        echo("  initQQWry - 下载 IP 解析库".PHP_EOL);
        echo("  resetTraffic - 重置所有用户流量".PHP_EOL);
        echo("  update - 更新并迁移配置".PHP_EOL);
    }

    public function resetPort()
    {
        fwrite(STDOUT, "请输入用户id: ");
        $user=User::Where("id", "=", trim(fgets(STDIN)))->first();
        $origin_port = $user->port;

        $user->port = Tools::getAvPort();

        $relay_rules = Relay::where('user_id', $user->id)->where('port', $origin_port)->get();
        foreach ($relay_rules as $rule) {
            $rule->port = $user->port;
            $rule->save();
        }

        if ($user->save()) {
            echo "重置成功!\n";
        }
    }

    public function resetAllPort()
    {
        $users = User::all();
        foreach ($users as $user) {
            $origin_port = $user->port;
            $user->port = Tools::getAvPort();
            echo '$origin_port='.$origin_port.'&$user->port='.$user->port."\n";
            $user->save();
        }
    }

    public function cleanRelayRule()
    {
        $rules = Relay::all();
        foreach ($rules as $rule) {
            echo($rule->id."\n");
            if ($rule->source_node_id == 0) {
                echo($rule->id."被删除！\n");
                $rule->delete();
                continue;
            }

            $ruleset = Relay::where('user_id', $rule->user_id)->orwhere('user_id', 0)->get();
            $maybe_rule_id = Tools::has_conflict_rule($rule, $ruleset, $rule->id);
            if ($maybe_rule_id != 0) {
                echo($rule->id."被删除！\n");
                $rule->delete();
            }
        }
    }

    public function initdownload()
    {
        system('git clone https://github.com/xcxnig/ssr-download.git '.BASE_PATH."/public/ssr-download/", $ret);
        echo $ret;
    }

//  song 禁用滥用邀请的用户的账户
    // 如果购买了 64元以上套餐，但是发现实际 充值金额 + 邀请返利 少于 32元的话，就会被禁用账户。
    public function banUsernoPay()
    {
        echo "开始禁用无支付的账号";
        $boughts = Bought::where("price", ">", 64)->get();
        foreach ($boughts as $bought) {
            # code...
            $codes = Code::where("userid",$bought->userid)->sum('number');
            $paybacks = Payback::where("ref_by",$bought->userid)->sum('ref_get');
            //echo $codes + $paybacks;
            //echo "--";
            if (($codes + $paybacks) < 32) {
                # code...
                echo $codes + $paybacks;
                echo "-";
                echo $bought->userid;
                echo "  ;  ";
                User::where("id",$bought->userid)->update(['enable'=>'0']);
            }
        }
        echo "禁用完成 ";

    }

    public function test()
    {

        // echo 'try clean node online log ';
        // NodeOnlineLog::where("log_time", "<", time()-86400*3)->delete();
        // echo 'try to clean user traffic log ';
        // TrafficLog::where("log_time", "<", time()-86400*3)->delete();

       
        // echo 'a1105_add_2022-09-23_2022-11-07  to group 1';
        // $nodes = Node::where('node_group',2)->where('info','a1105_add_2022-09-23_2022-11-07')->get();
        // foreach($nodes as $node){
        //     $node->node_group = 1;
        //     echo $node->id . '---';
        //     $node->save();
        // }
        // echo '把3组节点换成4组';
        // $nodes = Node::where('node_group',3)->get();
        // foreach($nodes as $node){
        //     $node->node_group = 4;
        //     echo $node->id . '+++';
        //     $node->save();
        // }

        // echo "初始: ".memory_get_usage()."B\n";
        // $users = User::where('enable','>',0)->where('class','>',0)->get();
        // echo 'start';
        // echo "使用: ".memory_get_usage()."B\n";
        // foreach ($users as $user) {
        //     // $user->renew += 0.1;
        //     // $user->transfer_limit += $user->class*1024*1024*1024; // 每天给用户赠送 5G流量 这个可以有
        //     // $user->transfer_limit += 1*1024*1024*1024; // 现在是2G每天 这样可以限制用户的流量使用情况！
        //     $user->last_day_t = $user->d;     // // 这里改变一下，只记录用户 d 的数据，不记录 u 数据。
        //     $user->rss_count_lastday = $user->rss_count; // 记录昨日订阅数量统计
        //     $user->rss_ips_lastday = $user->rss_ips_count; // 记录昨日ips来源统计
        //     $user->save();
        //     echo $user->id;
        //     echo '-----';
        // }
        // echo "释放: ".memory_get_usage()."B\n";
        // echo "峰值: ".memory_get_peak_usage()."B\n";
       

        // echo '统计1组的 2-7级用户人 放到3组去';
        // $users = User::where('enable',1)->where("node_group",1)->where('class','<',10)->where('class','>',6)->get();

        // foreach ($users as $user) {
        //     # code...
        //     $user->node_group = 3;
        //     echo $user->id . '---';
        //     $user->save();
        // }


        echo '当前无数据';
        //自动审计每天节点流量数据 song
        // $nodes_vnstat = Node::where('id','>',9)->where('node_group','>',0)->get();  // 只获取9以上的分组不是0的节点 因为0组是给news节点用的。
        // foreach ($nodes_vnstat as $node) {
        //     if ($node->node_bandwidth == $node->node_bandwidth_lastday) {   // 判断这个节点是否今天没有走流量，是否是有问题的节点？
        //         continue;   
        //     }
        //     // 这两个 if别反了。 需要把 流量记录下，方便统计每日消耗的真实流量
        //     if ( $node->node_heartbeat < (time() - 7200) ) {        // 判断节点在过去两小时内 是否存在心跳
        //         continue;
        //     }
        //     //
        //     $traffic_today = $node->node_bandwidth - $node->node_bandwidth_lastday;
        //     $today = date('d');
        //     if ($node->node_bandwidth_limit > 1 && $today != $node->bandwidthlimit_resetday) {  
        //         // node_sort
        //         // rate 节点倍率计算方案
        //         $traffic_used_days = 32 + $today - $node->bandwidthlimit_resetday;
        //         $traffic_used_days > 32 && $traffic_used_days -= 32;
        //         $traffic_used_days < 1 && $traffic_used_days = 1; # 防止已用时间为0
        //         // $node->traffic_rate = round( ($node->node_bandwidth * 50 / $node->node_bandwidth_limit / $days)  ,1);  # 旧的计算方式,已抛弃
        //         $traffic_used_ever_day = round( ( $node->node_bandwidth / 1024 / 1024 / 1024 / $traffic_used_days ), 2) ;   # 计算已用日均流量 G
        //         $node->node_oncost > 0 && $node->traffic_rate = round(( $traffic_used_ever_day / $node->node_oncost ), 1);  # 倍率= 已用日均流量/剩余日均流量 G
        //         echo $node->traffic_rate;
        //         echo '--';
        //         # 下面 计算 流量的 限额 和 金钱的 方案,考虑到有 fake节点,目前做不到这样. 
        //         if ( $node->node_cost > 0 && $node->node_bandwidth_limit > 0 ) {
        //             // 注意: node_bandwidth_limit 是 *1024*1024*1024 得出来的.
        //             $node->traffic_rate = round(($node->traffic_rate * 500 * $node->node_cost * 1024 * 1024 *1024 / $node->node_bandwidth_limit ),1); # 倍率再算上 流量价格  流量/刀  目前能买到500G/刀 ,就是 1800G/4.5刀
        //             echo $node->traffic_rate;
        //             echo '-----';
        //         }
        //     }
        // }
        # is_clone 设置和记录
        // $nodes = Node::where('id','>',40)->get();
        // foreach($nodes as $node){
        //     parse_str($node->server, $v2);  //获取参数
        //     $getid = $v2['host'];
        //     $getid = str_replace('.node.xyz','',$getid);
        //     $getid = str_replace('.s2022.xyz','',$getid);
        //     $getid = str_replace('.s2022.buzz','',$getid);
        //     $getid = str_replace('ipv6s','',$getid);
        //     $getid = str_replace('s','',$getid);
        //     // echo $getid;
        //     echo '------------';
        //     if ($getid != $node->id) {
        //         $node->is_clone=$getid;
        //         echo $getid . ' != ' . $node->id;
        //         echo '----------------';
        //         $node->save();
        //     }
            
        // }

        # 把指定节点信息的节点,更改节点分组. 
        #
        # Config
        // $info = 'a1107_2022-10-07';  # 需要查找的节点 info
        // $now_group = 1; #该节点现在的分组
        // $new_group = 2; #该节点需要移动到的分组
        // #
        
        // $nodes = Node::where('id','>',9)->get();
        // foreach($nodes as $node){
        //     $node->traffic_rate = 1;
        //     $node->save();
        // }

        // echo '20220210';
        // $all_traffic_today = Node::where('id','>',9)->where('node_group','>',0)->where('node_cost','>',1)->sum('node_bandwidth') - Node::where('id','>',9)->where('node_group','>',0)->where('node_cost','>',1)->sum('node_bandwidth_lastday');
        // echo '全站今日流量'.$all_traffic_today / 1073741824 .'G_';
        // // 总日供给流量
        // $all_traffic_daily_supply = Node::where('id','>',9)->where('type',1)->where('node_cost','>',1)->where('node_group','>',0)->sum('node_oncost');
        // echo '全站供给流量'. $all_traffic_daily_supply  .'G_';
        // // 组1 日耗流量
        // $group1_traffic_today = Node::where('id','>',9)->where('node_group','=',1)->where('node_cost','>',1)->sum('node_bandwidth') - Node::where('id','>',9)->where('node_group','=',1)->where('node_cost','>',1)->sum('node_bandwidth_lastday');
        // echo '组1消耗' .$group1_traffic_today  / 1073741824 .'G_';
        // // 组1 日供给流量
        // $group1_traffic_daily_supply = Node::where('id','>',9)->where('type',1)->where('node_cost','>',1)->where('node_group','=',1)->sum('node_oncost');
        // echo '组1供给' .$group1_traffic_daily_supply   .'G_';
        // // 组2 日耗流量
        // $group2_traffic_today = Node::where('id','>',9)->where('node_group','=',2)->where('node_cost','>',1)->sum('node_bandwidth') - Node::where('id','>',9)->where('node_group','=',2)->where('node_cost','>',1)->sum('node_bandwidth_lastday');
        // echo 'Group2 used ' . $group2_traffic_today  / 1073741824 .'G_';
        // // 组2 日供给流量
        // $group2_traffic_daily_supply = Node::where('id','>',9)->where('type',1)->where('node_cost','>',1)->where('node_group','=',2)->sum('node_oncost');
        // echo 'G2 supply' . $group2_traffic_daily_supply   .'G_';
        // // 组4 日耗流量
        // $group4_traffic_today = Node::where('id','>',9)->where('node_group','=',4)->where('node_cost','>',1)->sum('node_bandwidth') - Node::where('id','>',9)->where('node_group','=',4)->where('node_cost','>',1)->sum('node_bandwidth_lastday');
        // echo 'G4 used ' .$group4_traffic_today   / 1073741824 .'G_';
        // // 组4 日供给流量
        // $group4_traffic_daily_supply = Node::where('id','>',9)->where('type',1)->where('node_cost','>',1)->where('node_group','=',4)->sum('node_oncost');
        // echo 'G2 supply ' .$group4_traffic_daily_supply   .'G_';

        // $total = 0;
        // echo "Group4: \n";
        // $nodes = Node::where('id','>',9)->where('node_group',4)->where('type',1)->where('node_cost','>',1)->orderBy('node_oncost','DESC')->get();
        // foreach ($nodes as $key => $node) {
        //     echo 'Id= ' . $node->id ."\t";
        //     echo '今= ' . floor($node->node_bandwidth / 1073741824 )."G \t";
        //     echo '昨= ' . floor($node->node_bandwidth_lastday / 1073741824 )."G \t";
        //     echo '差= ' . floor(($node->node_bandwidth - $node->node_bandwidth_lastday)/ 1073741824 )."G \t";
        //     echo '供= ' . $node->node_oncost. 'G  ';
        //     echo "\n";
        //     $total += ($node->node_bandwidth - $node->node_bandwidth_lastday)/ 1073741824;
        // }
        // echo '---';
        // echo floor($total) .'G';

        // $nodes = Node::where('id','>',9)->where('type',1)->get();
        // foreach ($nodes as $key => $node) {
        //     $node->custom_rss = 1;
        //     $node->save();
        // }
        
        // $snodes = Node::where('id','>',9)->get();
        // foreach ($snodes as $key => $node) {
        //     // parse_str($node->node_ip,$v2);
        //     $info = $node->status;
        //     $status = $node->info;

        //     $node->status = $status;
        //     $node->info = $info;
        //     $node->save();
        // }


        // $snodes = Node::where('id','>',9)->get();
        // foreach ($snodes as $key => $node) {
        //     // parse_str($node->node_ip,$v2);
        //     $node->sort == 11 && $v2 = 'v2=vmess';  // 获取开头参数
        //     $node->sort == 12 && $v2 = 'v2=vmess';  // 这个 12 ，还要写成 加上CDN参数呢
        //     //v2=vmess&add=&port=&aid=&scy=&net=&type=&host=&path=&tls=&sni=&alpn=&ecpt=&flow=&uuid=&cdn=
        //     $cut = explode('#',$node->node_ip);
        //     $v2 .= '&add=' . $node->server;
        //     $v2 .= '&port=' . $cut['1'];
        //     $v2 .= '&aid=0';
        //     $v2 .= '&scy=' . $cut['5']; //就是加密
        //     $v2 .= '&net=' . $cut['4'];
        //     $v2 .= '&type='  ;//就是伪装
        //     $v2 .= '&host=' .$cut['6'];
        //     $v2 .= '&path=/' .$cut['7'];
        //     $v2 .= '&tls=' .$cut['8'];
        //     $v2 .= '&sni=';
        //     $v2 .= '&alpn=';
        //     $v2 .= '&ecpt=';
        //     $v2 .= '&flow=';
        //     $v2 .= '&uuid=' . $cut['2']; //独立节点
        //     if ( $node->sort == 12 ) {
        //         $v2 .= '&cdn=cf';  // 这个CDN只要有就行，什么参数无所谓。
        //     } else{
        //         $v2 .= '&cdn=';
        //     }
            
        //     $node->server = $v2;
        //     $node->node_ip = 'ip='.$cut['0'].'&ipv6=';
        //     $node->sort == 12 && $node->sort = 11;  // 把之前的 cf节点给转换回来。
        //     $node->save();
        // }
        // // 先获取 所有的 从 5.1日之后的所有的 payback  这个先从 5.1日 之后的所有账号的处理一遍！ 这个挺重要的！  然后处理所有的 5.12日前的
        // $paybacklistcount = Payback::where('total','=',-1)->where('callback','=',null)->where('datetime','>',1619755921)->where('datetime','<',1620792721)->count();
        // echo '-总数-' . $paybacklistcount;
        // $paybacklist = Payback::where('total','=',-1)->where('callback','=',null)->where('datetime','>',1619755921)->where('datetime','<',1620792721)->get();
        // foreach ( $paybacklist as $p ) {
        //     // 两个事情，如果是 邀请人已经不存在了。那么就把这条数据 标注为 3 代表老帐号已删除？
        //     // 如果 被邀请人已经不存在了，就把这个返利删除了。
        //     $user = User::where('id','=',$p->userid)->first();
        //     $ref_by = User::where('id','=',$p->ref_by)->first();
        //     echo '||---go---';
        //     echo '--userid=' . $p->userid;
        //     echo  '--ref_by=' . $p->ref_by;
        //     if ($ref_by == null ) {  // 如果 邀请人不存在的话，怎么办？
        //         $p->callback = 3; // 3代表邀请人已删除。这条邀请已经无效了。
        //         echo '-callback=3-';
        //         // // 删除掉和这个用户所有有关的payback日志
        //         // Payback::where('ref_by', '=' , $p->ref_by)->delete();
        //         // echo '-删除所有此邀请人信息-';
        //     } elseif ( $user == null ) { // 如果邀请人存在,被邀请人删除了那么就收回返利
        //         // 需要检查一次，这个返利是否已经被收回了。
        //         $refback = Payback::where('total','=',-2)->where('userid','=',$p->userid)->where('ref_by','=', $p->ref_by)->first();
        //         if ($refback == null ) { // 如果不存在已收回的标注，就收回一次。
        //             echo '-refback=null-';
        //             echo '-money='. $ref_by->money;
        //             $ref_by->money -= $p->ref_get ;
        //             $ref_by->save();
        //             echo '-money='. $ref_by->money;
        //             $p->callback = 1; //1=返利已经被收回。
        //             // 这里写入一个新的记录
        //             $Payback = new Payback();
        //             $Payback->total = -2;
        //             $Payback->userid = $p->userid;  //用户注册的ID
        //             $Payback->ref_by = $p->ref_by;  //邀请人ID
        //             $Payback->ref_get = - $p->ref_get;
        //             $Payback->datetime = time();
        //             $Payback->save();
        //         }elseif ($refback->id) { // 如果存在，并已经收回过一次了。就备注一下
        //             echo '-refback已经处理了-';
        //             $p->callback = 1;
        //         }
        //     } 
        //     $p->save();
        //     echo '---end---||';
        // }
    //   // 2021.3.12 批量替换域名
    //   $nodelist = Node::all();
    //   foreach ($nodelist as $node) {
    //     // code...
    //     $node->server=str_ireplace("snode.xyz","snodes.xyz",$node->server);
    //     $node->node_ip=str_ireplace("snode.xyz","snodes.xyz",$node->node_ip);
    //     $node->save();
    //   }

      // 测试 file_put_contents 能不能写入文件
      // $date = date('Y-m-d H:i:s');
      // $dateMonth = date('m');
      // $dateDay = date('d');
      // $dateHour = date('H');
      //
      // //获取上一次的数据 其中 那个 node_bandwidth_lastday=昨日记录！ node_bandwidth_limit=上一个小时的记录！
      // $nodeRecord = Node::where('id',3)->first();
      // $transNow = Node::where('id','>',9)->sum('node_bandwidth');
      //
      // //写入每小时的数据
      // $transLasthour = $nodeRecord->node_bandwidth_limit;
      // $transHourPath = "/www/wwwroot/ssp-uim/public/transhourly.html";
      // $hourlyDate = '<br>' . date('m-d H') . ' |  ' . ($transNow - $transLasthour)/1000000000000 .'T';
      // file_put_contents($transHourPath,$hourlyDate,FILE_APPEND);
      // //写入昨日的记录到
      // $nodeRecord->node_bandwidth_limit = $transNow;
      //
      // // 写入每天的数据
      // if (date('H') == 19) {
      //   $transLastday = $nodeRecord->node_bandwidth_lastday;
      //   $transDayPath = "/www/wwwroot/ssp-uim/public/transdaily.html";
      //   $dailyDate = '<br>' . date('y-m d') . ' |  ' . ($transNow - $transLastday)/1000000000000 .'T';
      //   file_put_contents($transDayPath,$dailyDate,FILE_APPEND);
      //   $nodeRecord->node_bandwidth_lastday = $transNow;
      // }
      //
      // #保存这次数据，方便下次对比
      // $nodeRecord->save();
      //
      // # end


      //判断是否晚上3点，写入每天的数据


      // // cncdns md5 给 数据库的 cncdn 一些空值加密
      //   $cncdns = Cncdn::where('areaid','=','')->get();
      //   foreach ($cncdns as $cncdn) {
      //     $cncdn->areaid = md5($cncdn->area);
      //     $cncdn->ipmd5 = md5($cncdn->cdnip);
      //     $cncdn->save();
      //   }

      // // 把md5 后的数据，ip和 md5ip 对应输出
      // $cncdns = Cncdn::where('server','=','osline.cn')->get();
      // foreach ($cncdns as $cncdn) {
      //     echo $cncdn->cdnip;
      //     echo '\n';
      // }
      //
      // foreach ($cncdns as $cncdn) {
      //   echo $cncdn->ipmd5;
      //   echo '\n';
      // }

    }



        public function transRecord()
        {

          //获取上一次的数据 其中 那个 node_bandwidth_lastday=昨日记录！ node_bandwidth_limit=上一个小时的记录！
          $nodeRecord = Node::where('id',3)->first();
          $transNow = Node::where('id','>',9)->sum('node_bandwidth');

          //写入每小时的数据
          $transLasthour = $nodeRecord->node_bandwidth_limit;
          $transHourPath = "/www/wwwroot/ssp-uim/public/transhourly.html";
          $hourlyDate = round(($transNow - $transLasthour)/1000000000) . date('mdH') . '<br>' ;
          file_put_contents($transHourPath,$hourlyDate,FILE_APPEND);
          //写入昨日的记录到
          $nodeRecord->node_bandwidth_limit = $transNow;

          // //写入online 在线人数每小时统计
          // $nodeOnline = Node::where('type',1)->sum('node_online');
          // $onlineHourPath = "/www/wwwroot/ssp-uim/public/onlinehourly.html";
          // $onlineDate = $nodeOnline . date('mdH') . '<br>';
          // file_put_contents($onlineHourPath,$onlineDate,FILE_APPEND);
          // 写入 online 用户的每小时在线人数 就是这个小时在线人数的累计值。
          $userOnline = User::where("enable","=",1)->where('t','>',(time()-3600))->count();
          $onlineHourPath = "/www/wwwroot/ssp-uim/public/onlinehourly.html";
          $onlineDate = $userOnline . date('mdH') . '<br>';
          file_put_contents($onlineHourPath,$onlineDate,FILE_APPEND);

          // 写入每天的数据
          if (date('H') == 6) {
            $transLastday = $nodeRecord->node_bandwidth_lastday;
            $transDayPath = "/www/wwwroot/ssp-uim/public/transdaily.html";
            $dailyDate = round(($transNow - $transLastday)/1000000000) . date('ymd') . '<br>' ;
            file_put_contents($transDayPath,$dailyDate,FILE_APPEND);
            $nodeRecord->node_bandwidth_lastday = $transNow;
          }

          #保存这次数据，方便下次对比
          $nodeRecord->save();


        }


    public function createAdmin()
    {
        echo "add admin/ 创建管理员帐号.....";
        // ask for input
        fwrite(STDOUT, "Enter your email/输入管理员邮箱: ");
        // get input
        $email = trim(fgets(STDIN));
        // write input back
        fwrite(STDOUT, "Enter password for: $email / 为 $email 添加密码: ");
        $passwd = trim(fgets(STDIN));
        echo "Email: $email, Password: $passwd! ";
        fwrite(STDOUT, "Press [Y] to create admin..... 按下[Y]确认来确认创建管理员账户..... \n");
        $y = trim(fgets(STDIN));
        if (strtolower($y) == "y") {
            echo "start create admin account";
            // create admin user
            // do reg user
            $user = new User();
            $user->user_name = "admin";
            $user->email = $email;
            $user->pass = Hash::passwordHash($passwd);
            $user->passwd = Tools::genRandomChar(6);
            $user->port = Tools::getLastPort()+1;
            $user->t = 0;
            $user->u = 0;
            $user->d = 0;
            $user->transfer_enable = Tools::toGB(Config::get('defaultTraffic'));
            $user->invite_num = Config::get('inviteNum');
            $user->ref_by = 0;
            $user->is_admin = 1;
            $user->expire_in=date("Y-m-d H:i:s", time()+Config::get('user_expire_in_default')*86400);
            $user->reg_date=date("Y-m-d H:i:s");
            $user->money=0;
            $user->im_type=1;
            $user->im_value="";
            $user->class=0;
            $user->plan='A';
            $user->node_speedlimit=0;
            $user->theme=Config::get('theme');

            $ga = new GA();
            $secret = $ga->createSecret();
            $user->ga_token=$secret;
            $user->ga_enable=0;

            if ($user->save()) {
                echo "Successful/添加成功!\n";
                return true;
            }
            echo "添加失败";
            return false;
        }
        echo "cancel";
        return false;
    }

    public function resetTraffic()
    {
        try {
            User::where("enable", 1)->update([
            'd' => 0,
            'u' => 0,
            'last_day_t' => 0,
            ]);
        } catch (\Exception $e) {
            echo $e->getMessage();
            return false;
        }
        return "reset traffic successful";
    }


    public function setTelegram()
    {
        $bot = new \TelegramBot\Api\BotApi(Config::get('telegram_token'));
        //if ($bot->setWebhook(Config::get('baseUrl')."/telegram_callback?token=".Config::get('telegram_request_token')) == 1) {
        // 这里 网站屏蔽了 所有国外的ip，所以只能使用 ssn这个域名来访问了
        if ($bot->setWebhook("https://ssp-ssn.freessr.bid/telegram_callback?token=".Config::get('telegram_request_token')) == 1) {
            echo("设置成功！");
        }
    }

    public function initQQWry()
    {
        echo("downloading....");
        $qqwry = file_get_contents("https://qqwry.mirror.noc.one/QQWry.Dat");
        if ($qqwry != "") {
            $fp = fopen(BASE_PATH."/storage/qqwry.dat", "wb");
            if ($fp) {
                fwrite($fp, $qqwry);
                fclose($fp);
            }
            echo("finish....");
        }
    }
    public function sendDailyUsageByTG()
    {
        $bot = new \TelegramBot\Api\BotApi(Config::get('telegram_token'));
        $users = User::where('telegram_id',">",0)->get();
        foreach ($users as $user){
            $reply_message ="您当前的流量状况：
今日已使用 " . $user->TodayusedTraffic() . " " . number_format(($user->u + $user->d - $user->last_day_t) / $user->transfer_enable * 100, 2) . "%
今日之前已使用 " . $user->LastusedTraffic() . " " . number_format($user->last_day_t / $user->transfer_enable * 100, 2) . "%
未使用 " . $user->unusedTraffic() . " " . number_format(($user->transfer_enable - ($user->u + $user->d)) / $user->transfer_enable * 100, 2) . "%
                                            ";
            try{
                $bot->sendMessage($user->get_user_attributes("telegram_id"), $reply_message , $parseMode = null, $disablePreview = false, $replyToMessageId = null);

            } catch (\TelegramBot\Api\HttpException $e){
                echo 'Message: 用户: '.$user->get_user_attributes("user_name")." 删除了账号或者屏蔽了宝宝";
            }
        }
    }

    public function npmbuild(){
        chdir(BASE_PATH.'/uim-index-dev');
        system('npm install');
        system('npm run build');
        system('cp -u ../public/vuedist/index.html ../resources/views/material/index.tpl');
    }
}
