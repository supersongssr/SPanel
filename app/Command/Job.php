<?php

namespace App\Command;

use App\Models\Node;
use App\Models\User;
use App\Models\RadiusBan;
use App\Models\LoginIp;
use App\Models\Speedtest;
use App\Models\Shop;
use App\Models\Bought;
use App\Models\Coupon;
use App\Models\Ip;
use App\Models\NodeInfoLog;
use App\Models\NodeOnlineLog;
use App\Models\TrafficLog;
use App\Models\DetectLog;
use App\Models\BlockIp;
use App\Models\TelegramSession;
use App\Models\EmailVerify;
use App\Services\Config;
use App\Utils\Radius;
use App\Utils\Tools;
use App\Services\Mail;
use App\Utils\QQWry;
use App\Utils\GA;
use App\Utils\Telegram;
use CloudXNS\Api;
use App\Models\Disconnect;
use App\Models\UnblockIp;
use App\Models\Payback;  // 原来是缺少这个 song
use App\Models\Record;  // record表

class Job
{
    public static function syncnode()
    {
        // $nodes = Node::all();
        // foreach ($nodes as $node) {
        //     if ($node->sort == 11) {
        //         $server_list = explode(";", $node->server);
        //         if(!Tools::is_ip($server_list[0])){
        //             if($node->changeNodeIp($server_list[0])){
        //                 $node->save();
        //             }
        //         }
        //     } else if($node->sort == 0 || $node->sort == 1 || $node->sort == 10){
        //         if(!Tools::is_ip($node->server)){
        //             if($node->changeNodeIp($node->server)){
        //                 $node->save();
        //                 if ($node->sort == 0 || $node->sort == 10) {
        //                     Tools::updateRelayRuleIp($node);
        //                 }
        //             }
        //         }
        //     }
        // }
    }

    public static function backup($full=false)
    {
        $to = Config::get('auto_backup_email');
        if($to==null){
            return false;
        }
        mkdir('/tmp/ssmodbackup/');
        $db_address_array = explode(':', Config::get('db_host'));
        if($full){
            system('mysqldump --user='.Config::get('db_username').' --password='.Config::get('db_password').' --host='.$db_address_array[0].' '.(isset($db_address_array[1])?'-P '.$db_address_array[1]:'').' '.Config::get('db_database').' > /tmp/ssmodbackup/mod.sql');
        }
        else{
            system('mysqldump --user='.Config::get('db_username').' --password='.Config::get('db_password').' --host='.$db_address_array[0].' '.(isset($db_address_array[1])?'-P '.$db_address_array[1]:'').' '.Config::get('db_database').' announcement auto blockip bought code coupon disconnect_ip link login_ip payback radius_ban shop speedtest ss_invite_code ss_node ss_password_reset ticket unblockip user user_token email_verify detect_list relay paylist> /tmp/ssmodbackup/mod.sql', $ret);
            system('mysqldump --opt --user='.Config::get('db_username').' --password='.Config::get('db_password').' --host='.$db_address_array[0].' '.(isset($db_address_array[1])?'-P '.$db_address_array[1]:'').' -d '.Config::get('db_database').' alive_ip ss_node_info ss_node_online_log user_traffic_log detect_log telegram_session yft_order_info >> /tmp/ssmodbackup/mod.sql', $ret);
            if (Config::get('enable_radius')=='true') {
                $db_address_array = explode(':', Config::get('radius_db_host'));
                system('mysqldump --user='.Config::get('radius_db_user').' --password='.Config::get('radius_db_password').' --host='.$db_address_array[0].' '.(isset($db_address_array[1])?'-P '.$db_address_array[1]:'').''.Config::get('radius_db_database').'> /tmp/ssmodbackup/radius.sql', $ret);
            }
        }

        system("cp ".BASE_PATH."/config/.config.php /tmp/ssmodbackup/configbak.php", $ret);
        echo $ret;
        system("zip -r /tmp/ssmodbackup.zip /tmp/ssmodbackup/* -P ".Config::get('auto_backup_passwd'), $ret);
        $subject = Config::get('appName')."-备份成功";
        $text = "您好，系统已经为您自动备份，请查看附件，用您设定的密码解压。" ;
        try {
            Mail::send($to, $subject, 'news/backup.tpl', [
                "text" => $text
            ], ["/tmp/ssmodbackup.zip"
            ]);
        } catch (\Exception $e) {
            echo $e->getMessage();
        }
        system("rm -rf /tmp/ssmodbackup", $ret);
        system("rm /tmp/ssmodbackup.zip", $ret);

        if(Config::get('backup_notify')=='true'){
            Telegram::Send("备份完毕了喵~今天又是安全祥和的一天呢。");
        }
    }

    public static function UserGa()
    {
        $users = User::all();
        foreach ($users as $user) {
            $ga = new GA();
            $secret = $ga->createSecret();

            $user->ga_token=$secret;
            $user->save();
        }
        echo "ok";
    }

    public static function syncnasnode()
    {
        // $nodes = Node::all();
        // foreach ($nodes as $node) {
        //     $rule = preg_match("/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/",$node->server);
        //     if (!$rule && (!$node->sort || $node->sort == 10)) {
        //         $ip=gethostbyname($node->server);
        //         $node->node_ip=$ip;
        //         $node->save();

        //         Radius::AddNas($node->node_ip, $node->server);
        //     }
        // }
    }


    public static function DbClean()
    {
        // 把清空日志放到这里来
        NodeInfoLog::where("log_time", "<", time()-86400*3)->delete();
        NodeOnlineLog::where("log_time", "<", time()-86400*3)->delete();
        TrafficLog::where("log_time", "<", time()-86400*3)->delete();
        DetectLog::where("datetime", "<", time()-86400*3)->delete();
        Speedtest::where("datetime", "<", time()-86400*3)->delete();
        EmailVerify::where("expire_in", "<", time()-86400*3)->delete();
         system("rm ".BASE_PATH."/storage/*.png", $ret);
         echo 'db clean done :)';
        Telegram::Send("姐姐姐姐，数据库被清理了，感觉身体被掏空了呢~");
    }

    public static function DailyJob()
    {
        //自动审计每天节点流量数据 song
        $nodes = Node::where('id','>',60)->get();  // 只获取9以上的分组不是0的节点 因为0组是给news节点用的。

        // 分组流量统计
        $_group=0;
        while($_group < 6){  // 1 2 3 4 5 组
            $_name = 'traffic_record_group'.$_group;
            $_record = Record::where('name',$_name)->get();
            $_used_count = 0;
            $_left_count = 0;
            foreach($nodes as $node){
                if ($node->node_group != $_group){
                    continue;
                }
                $_traffic_today = $node->node_bandwidth - $node->node_bandwidth_lastday;
                $_traffic_today > 100*1024*1024*1024 && $_traffic_today = 100*1024*1024*1024; //上限100G
                $_traffic_today < 1 && $_traffic_today = 0; //下限0G
                $_used_count += $_traffic_today ;

                $_traffic_left_daily = $node->traffic_left_daily ;
                $_traffic_left_daily > 100*1024*1024*1024 && $_traffic_left_daily = 100*1024*1024*1024;  //剩余流量的统计上限100G
                $_traffic_left_daily < 1 && $_traffic_left_daily = 0;  //下限0G
                $_left_count += $_traffic_left_daily;
            }
                // 表现为: 使用流量+某个值 (等于提供的值) 如果出现了负数,说明 提供的流量不够了. 每个节点只统计 0-100G范围内.
            $_new_value = round($_used_count/1024/1024/1024).'+'.round(($_left_count - $_used_count)/1024/1024/1024).'G,'.$_record->value; 
            $_new_value = substr($_new_value, 0, 32);  // 限制字符串的长度 太长了不好显示
            $_record->value = $_new_value.'|'.date("Y-m-d"); //添加一个日期,方便判断
            $_record->save();
            $_group++;
        }

        // 单独处理每个节点
        foreach ($nodes as $node) {
            if ( $node->node_heartbeat < (time() - 7200) && $node->type != 0 ) {        // 判断节点在过去两小时内 是否存在心跳
                $node->type = 0;
            }
            //
            $traffic_today = $node->node_bandwidth - $node->node_bandwidth_lastday;

            // status 
            $node->status = round($traffic_today/1024/1024/1024) . ',' . $node->status ;    //将每天统计的节点的数据写入到节点的备注中去
            $node->status = substr($node->status, 0,32);             //截取字符串长度为128位 防止超出
            $node->status .= '|'.date("Y-m-d");

            // node_sort
            if ( $node->custom_rss == 1 ) {  //添加正常订阅的节点才处理   //思考一下这个怎么计算? 
                $traffic_today < 1*1024*1024*1024 && $node->node_sort -= 10;     // 节点维修值 如果节点为0 就需要大修了。
                $traffic_today < 8*1024*1024*1024 && $node->node_sort -= 2;
                $traffic_today < 16*1024*1024*1024 && $node->node_sort -= 1;
                $traffic_today > 32*1024*1024*1024 && $node->node_sort += 2;
                $traffic_today > 64*1024*1024*1024 && $node->node_sort += 4;
            }
            
            // traffic_rate :
            if ($node->traffic_left_daily > 0){  //剩余日均流量 > 0才行,因为要做被除数
                $_rate = $node->traffic_used_daily / $node->traffic_left_daily;
            } else{
                $_rate = 1;
            }
            $_rate = round($_rate * $node->node_cost / 2); // 最低价格是2 美金,超过2美金的话,倍率会计算的高一些. 
            $_rate < 1 && $_rate = 1;
            $_rate > 5 && $_rate = 5;
            $node->traffic_rate = $_rate;

            $node->node_bandwidth_lastday = $node->node_bandwidth;   // 这里重置一下每天的统计数据
            $node->save();
            
            // //将节点每天的流量数据 写入到 node info 中，标志是 load = 0
            // $node_info = new NodeInfoLog();
            // $node_info->node_id = $node->id;
            // $node_info->uptime = $traffic_today ;
            // $node_info->load = 0;
            // $node_info->log_time = time();
            // $node_info->save();
        }

        Telegram::Send("节点梳理完毕");

        // 顺序是这样的：
        // 禁用超过 32天没用的用户 ->  矫正所有到期的用户的列加流量 -> 所有enable用户 trasnfer_day变成今日  renew += 0.1  transferlimit + 3G -> 禁用余额为负 -> 禁用每日流量用超的用户 -> 禁用总流量用超的用户
        //自动禁用超过32天没有使用的用户 ,选取id>10的用户，防止那个 sr但端口的用户被禁用了导致节点无法用
        $date_check = date('Y-m-d H:i:s',strtotime('-1 month'));
        // 最近一个月内注册的不算
        $nouse_time = time() - 32*86400;
        // 选取 注册时间在1个月以上， 上次使用在一个月前， 等级 > 0的， enable = 1 的禁用。
        $users_nouse = User::where('id','>',10)->where('enable','=',1)->where('class','>',0)->where('t','<',$nouse_time)->where("reg_date",'<',$date_check)->get();
        foreach ($users_nouse as $user) {
            $user->enable = 0;
            $user->warming = date("Ymd H:i:s") . '账号超过1个月未使用，系统启用账号保护。您可以自助解除保护';
            $user->save();
        }
        //
        Telegram::Send("未使用用户梳理完毕");

        // 余额少于 0 的用户 禁用掉
        $users_nomoney = User::where('money','<',0)->where('enable','=',1)->get();
        foreach ($users_nomoney as $user) {
            $user->enable = 0;
            $user->warming = date("Ymd H:i:s").'账号余额异常，系统启用账号保护。请检查您的余额';
            $user->ban_times += $user->class;
            $user->ban_times > 16 && $user->pass = time();
            $user->score -= 1;   //用户积分 - 1
            $user->save();
        }

        Telegram::Send("余额梳理完毕");
        // 这里也就意味着放弃了，余额小于 0 的用户，将没有那个流量重置周期。 永远没有的意思。 用超了就是用超了
        // renew废弃，转为 renew_time 参数
        //把所有的 renew 累加 周期到了的用户，重置流量限制
        // $users = User::where('enable','>',0)->where('class','>',0)->whereColumn('renew','>','class')->get();
        // foreach ($users as $user) {
        //     // 先重置流量数据
        //     $user->u = $user->u + $user->d;
        //     $user->d = 0;
        //     // 再重置每日流量数据
        //     $user->transfer_limit = $user->class *10*1024*1024*1024;
        //     $user->renew = 0;
        //     $user->save();
        // }
        // 用户流量周期，限制为 在 x天内， 使用的流量重置。
        $users = User::where('enable','>',0)->where('class','>',0)->where('renew_time','<',time())->get();
        foreach ($users as $user) {
            // 先重置流量数据
            $user->u = $user->u + $user->d;
            $user->d = 0;
            // 再重置每日流量数据
            $user->transfer_limit = $user->class *10*1024*1024*1024;   //  
            $user->renew_time = time() + $user->class *10*24*3600;   //  
            $user->save();
        }

        Telegram::Send("流量周期完毕");


        
        // 2 3 组总流量使用超限的，分配到1组，然后加用户等级的流量！一次
        $users = User::where('node_group','>',1)->where('enable','>',0)->where('class','>',0)->whereColumn('d','>','transfer_limit')->get();
        foreach ($users as $user) {
            $user->score -= 1;
            $user->ban_times += 1; //用户封禁次数+用户等级 每次+1次违规吧
            $user->ban_times > 16 && $user->pass = time() && $user->enable = 0;
            $user->warming = date("Ymd H:i:s") . '近期下行流量较多，系统已为您分配大带宽节点，下载请使用低倍率节点，切换分组请在个人设定页面';
            $user->node_group > 1 && $user->node_group -= 1;  // 分配到下一组
            $user->transfer_limit += $user->class *1024*1024*1024;  //然后加上一些流量，相当于重置
            $user->save();
        }
        Telegram::Send("总流量完毕");
        # 除了1组用户，其他组的用户每使用1天增加1积分 余额须 > 0
        $time_last24hours = time() - 24*3600;
        $users = User::where('node_group','>',1)->where('enable','>',0)->where('money','>',0)->where('class','>',0)->where('t','>',$time_last24hours)->get();  //获取过去24小时内有使用网站的用户
        foreach ($users as $user) {
            $user->score += 1; // 积分加1
            $user->save();
        }
        Telegram::Send("积分完毕");
        //将余额 小于 0 的用户，请空邀请人，收回邀请返利  选取 余额 <0  邀请人不为0 的情况  另外那个 score 值不低于 目前是设定的64
        $users = User::where('money','<',0)->where('ref_by','!=',0)->where('score','<',64)->get();  // 使用积分小于 32 且 money 小于 0 会被清理
        foreach ($users as $user) {
            $ref_user = User::find($user->ref_by);
            //这里 -1 代表是注册返利  -2 代表是 删除账号 取消返利
            $ref_payback = Payback::where('total','=',-1)->where('userid','=',$user->id)->where('ref_by','=',$user->ref_by)->first();
            //这里 查询一下是否已经存在 扣除余额的情况，统计一下 -2 情况的数量
            $pays = Payback::where('total','=',-2)->where('userid','=',$user->id)->where('ref_by','=', $user->ref_by)->count();
            //先判断一下这个邀请人是否还存在   判断是否存在已扣除的情况
            if ($ref_user->id != null  && $ref_payback->ref_get != null && $pays < 1) {    //如果存在
                $ref_user->money -= $ref_payback->ref_get;     //这里用当前余额，减去当初返利的余额。
                //不再扣除流量 扣除邀请的流量！
                //$ref_user->transfer_enable -= Config::get('invite_gift') * 1024 * 1024 * 1024;
                //邀请人的 ban_times += 1 惩罚一下
                $ref_user->ban_times += 1 ;
                $ref_user->save();
                //写入返利日志
                $Payback = new Payback();
                #echo $user->id;
                #echo ' ';
                $Payback->total = -2;
                $Payback->userid = $user->id;  //用户注册的ID
                $Payback->ref_by = $user->ref_by;  //邀请人ID
                $Payback->ref_get = - $ref_payback->ref_get;
                $Payback->datetime = time();
                $Payback->save();
                // ref_payback 的 callback 写为1 就是这个返利被收回了。 实际这样的话，还是一个不错的方案的。也就是说，这个返利的话，只需要这里加一个参数就好了。无需之前的那种复杂的方案！ 这个可以有。
                $ref_payback->callback = 1; // 设置这个返利已被收回！ 不错的做法和想法！ 
                $ref_payback->save();
            }
            //这里把这个用户的 ref_by 也清空一下,这样避免下次重复计算
            $user->ref_by = 0;
            $user->enable = 0;
            $user->save();
        }
        Telegram::Send("邀请返利完毕");
        
        // 更新ip地址库
        #https://github.com/shuax/QQWryUpdate/blob/master/update.php
        // $copywrite = file_get_contents("http://update.cz88.net/ip/copywrite.rar");
        // $adminUser = User::where("is_admin", "=", "1")->get();
        // $newmd5 = md5($copywrite);
        // $oldmd5 = file_get_contents(BASE_PATH."/storage/qqwry.md5");
        // if ($newmd5 != $oldmd5) {
        //     file_put_contents(BASE_PATH."/storage/qqwry.md5", $newmd5);
        //     $qqwry = file_get_contents("http://update.cz88.net/ip/qqwry.rar");
        //     if ($qqwry != "") {
        //         $key = unpack("V6", $copywrite)[6];
        //         for ($i=0; $i<0x200; $i++) {
        //             $key *= 0x805;
        //             $key ++;
        //             $key = $key & 0xFF;
        //             $qqwry[$i] = chr(ord($qqwry[$i]) ^ $key);
        //         }
        //         $qqwry = gzuncompress($qqwry);
        //         rename(BASE_PATH."/storage/qqwry.dat", BASE_PATH."/storage/qqwry.dat.bak");
        //         $fp = fopen(BASE_PATH."/storage/qqwry.dat", "wb");
        //         if ($fp) {
        //             fwrite($fp, $qqwry);
        //             fclose($fp);
        //         }
        //     }
        // }
        // $iplocation = new QQWry();
        // $location=$iplocation->getlocation("8.8.8.8");
        // $Userlocation = $location['country'];
        // if (iconv('gbk', 'utf-8//IGNORE', $Userlocation)!="美国") {
        //     unlink(BASE_PATH."/storage/qqwry.dat");
        //     rename(BASE_PATH."/storage/qqwry.dat.bak", BASE_PATH."/storage/qqwry.dat");
        // }
        // Job::updatedownload();

        // 每日统计数据 重置 ： 流量， 订阅  只记录过去48小时使用的用户?
        $check_time = time() - 48 * 3600 ;
        $users = User::where('enable','>',0)->where('class','>',0)->where('t', '>',  $check_time)->limit('20000')->get();
        foreach ($users as $user) {
            // $user->renew += 0.1;
            // $user->transfer_limit += $user->class*1024*1024*1024; // 每天给用户赠送 5G流量 这个可以有
            // $user->transfer_limit += 1*1024*1024*1024; // 现在是2G每天 这样可以限制用户的流量使用情况！
            $user->last_day_t = $user->d;     // // 这里改变一下，只记录用户 d 的数据，不记录 u 数据。
            $user->rss_count_lastday = $user->rss_count; // 记录昨日订阅数量统计
            $user->rss_ips_lastday = $user->rss_ips_count; // 记录昨日ips来源统计
            $user->save();
        }
        Telegram::Send("订阅统计完毕");

        Telegram::Send("姐姐姐姐，今日任务完成了呢,很开心");

    }
//   定时任务开启的情况下，每天自动检测有没有最新版的后端，github源来自Miku
     public static function updatedownload()
      {
        // system('cd '.BASE_PATH."/public/ssr-download/ && git pull https://github.com/xcxnig/ssr-download.git");
     }


    public static function CheckJob()
    {
        /*//在线人数检测
        $users = User::where('node_connector', '>', 0)->get();

        $full_alive_ips = Ip::where("datetime", ">=", time()-60)->orderBy("ip")->get();

        $alive_ipset = array();

        foreach ($full_alive_ips as $full_alive_ip) {
            $full_alive_ip->ip = Tools::getRealIp($full_alive_ip->ip);
            $is_node = Node::where("node_ip", $full_alive_ip->ip)->first();
            if($is_node) {
                continue;
            }

            if (!isset($alive_ipset[$full_alive_ip->userid])) {
                $alive_ipset[$full_alive_ip->userid] = new \ArrayObject();
            }

            $alive_ipset[$full_alive_ip->userid]->append($full_alive_ip);
        }

        foreach ($users as $user) {
            $alive_ips = (isset($alive_ipset[$user->id])?$alive_ipset[$user->id]:new \ArrayObject());
            $ips = array();

            $disconnected_ips = explode(",", $user->disconnect_ip);

            foreach ($alive_ips as $alive_ip) {
                if (!isset($ips[$alive_ip->ip]) && !in_array($alive_ip->ip, $disconnected_ips)) {
                    $ips[$alive_ip->ip]=1;
                    if ($user->node_connector < count($ips)) {
                        //暂时封禁
                        $isDisconnect = Disconnect::where('id', '=', $alive_ip->ip)->where('userid', '=', $user->id)->first();

                        if ($isDisconnect == null) {
                            $disconnect = new Disconnect();
                            $disconnect->userid = $user->id;
                            $disconnect->ip = $alive_ip->ip;
                            $disconnect->datetime = time();
                            $disconnect->save();

                            if ($user->disconnect_ip == null||$user->disconnect_ip == "") {
                                $user->disconnect_ip = $alive_ip->ip;
                            } else {
                                $user->disconnect_ip .= ",".$alive_ip->ip;
                            }
                            $user->save();
                        }
                    }
                }
            }
        }*/
/*
        //解封
        $disconnecteds = Disconnect::where("datetime", "<", time()-300)->get();
        foreach ($disconnecteds as $disconnected) {
            $user = User::where('id', '=', $disconnected->userid)->first();

            $ips = explode(",", $user->disconnect_ip);
            $new_ips = "";
            $first = 1;

            foreach ($ips as $ip) {
                if ($ip != $disconnected->ip && $ip != "") {
                    if ($first == 1) {
                        $new_ips .= $ip;
                        $first = 0;
                    } else {
                        $new_ips .= ",".$ip;
                    }
                }
            }

            $user->disconnect_ip = $new_ips;

            if ($new_ips == "") {
                $user->disconnect_ip = null;
            }

            $user->save();

            $disconnected->delete();
        }

        //自动续费
        $boughts=Bought::where("renew", "<", time())->where("renew", "<>", 0)->get();
        foreach ($boughts as $bought) {
            $user=User::where("id", $bought->userid)->first();

            if ($user == null) {
                $bought->delete();
                continue;
            }

            $shop=Shop::where("id", $bought->shopid)->first();
            if ($shop == null) {
                $bought->delete();
                $subject = Config::get('appName')."-续费失败";
                    $to = $user->email;
                    $text = "您好，系统为您自动续费商品时，发现该商品已被下架，为能继续正常使用，建议您登录用户面板购买新的商品。" ;
                    song
                    try {
                        Mail::send($to, $subject, 'news/warn.tpl', [
                            "user" => $user,"text" => $text
                        ], [
                        ]);
                    } catch (\Exception $e) {
                        echo $e->getMessage();
                    }

                continue;
            }
            if ($user->money >= $shop->price) {
                $user->money=$user->money - $shop->price;
                $user->save();
                $shop->buy($user, 1);
                $bought->renew=0;
                $bought->save();

                $bought_new=new Bought();
                $bought_new->userid=$user->id;
                $bought_new->shopid=$shop->id;
                $bought_new->datetime=time();
                $bought_new->renew=time()+$shop->auto_renew*86400;
                $bought_new->price=$shop->price;
                $bought_new->coupon="";
                $bought_new->save();

                $subject = Config::get('appName')."-续费成功";
                $to = $user->email;
                $text = "您好，系统已经为您自动续费，商品名：".$shop->name.",金额:".$shop->price." 元。" ;

                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user,"text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }


                if (file_exists(BASE_PATH."/storage/".$bought->id.".renew")) {
                    unlink(BASE_PATH."/storage/".$bought->id.".renew");
                }
            } else {
                if (!file_exists(BASE_PATH."/storage/".$bought->id.".renew")) {
                    $subject = Config::get('appName')."-续费失败";
                    $to = $user->email;
                    $text = "您好，系统为您自动续费商品名：".$shop->name.",金额:".$shop->price." 元 时，发现您余额不足，请及时充值。充值后请稍等系统便会自动为您续费。" ;
                                        try {
                        Mail::send($to, $subject, 'news/warn.tpl', [
                            "user" => $user,"text" => $text
                        ], [
                        ]);
                    } catch (\Exception $e) {
                        echo $e->getMessage();
                    }

                    $myfile = fopen(BASE_PATH."/storage/".$bought->id.".renew", "w+") or die("Unable to open file!");
                    $txt = "1";
                    fwrite($myfile, $txt);
                    fclose($myfile);
                }
            }
        }
*/
        Ip::where("datetime", "<", time()-300)->delete();
        UnblockIp::where("datetime", "<", time()-300)->delete();
        BlockIp::where("datetime", "<", time()-86400)->delete();
        TelegramSession::where("datetime", "<", time()-3600)->delete();
/*
        $adminUser = User::where("is_admin", "=", "1")->get();

        //节点掉线检测
        if (Config::get("enable_detect_offline")=="true") {
            $nodes = Node::all();

            foreach ($nodes as $node) {
                if ($node->isNodeOnline() === false && !file_exists(BASE_PATH."/storage/".$node->id.".offline")) {
                    foreach ($adminUser as $user) {
                        echo "Send offline mail to user: ".$user->id;
                        $subject = Config::get('appName')."-系统警告";
                        $to = $user->email;
                        $text = "管理员您好，系统发现节点 ".$node->name." 掉线了，请您及时处理。" ;

                        try {
                            Mail::send($to, $subject, 'news/warn.tpl', [
                                "user" => $user,"text" => $text
                            ], [
                            ]);
                        } catch (\Exception $e) {
                            echo $e->getMessage();
                        }


                        if (Config::get('enable_cloudxns')=='true' && ($node->sort==0 || $node->sort==10)) {
                            $api=new Api();
                            $api->setApiKey(Config::get("cloudxns_apikey"));//修改成自己API KEY
                            $api->setSecretKey(Config::get("cloudxns_apisecret"));//修改成自己的SECERET KEY

                            $api->setProtocol(true);

                            $domain_json=json_decode($api->domain->domainList());

                            foreach ($domain_json->data as $domain) {
                                if (strpos($domain->domain, Config::get('cloudxns_domain'))!==false) {
                                    $domain_id=$domain->id;
                                }
                            }

                            $record_json=json_decode($api->record->recordList($domain_id, 0, 0, 2000));

                            foreach ($record_json->data as $record) {
                                if (($record->host.".".Config::get('cloudxns_domain'))==$node->server) {
                                    $record_id=$record->record_id;

                                    $Temp_node=Node::where('node_class', '<=', $node->node_class)->where(
                                        function ($query) use ($node) {
                                            $query->where("node_group", "=", $node->node_group)
                                                ->orWhere("node_group", "=", 0);
                                        }
                                    )->whereRaw('UNIX_TIMESTAMP()-`node_heartbeat`<300')->first();

                                    if ($Temp_node!=null) {
                                        $api->record->recordUpdate($domain_id, $record->host, $Temp_node->server, 'CNAME', 55, 60, 1, '', $record_id);
                                    }

                                    $notice_text = "喵喵喵~ ".$node->name." 节点掉线了喵~域名解析被切换到了 ".$Temp_node->name." 上了喵~";
                                }
                            }
                        } else {
                            $notice_text = "喵喵喵~ ".$node->name." 节点掉线了喵~";
                        }
                    }

                    Telegram::Send($notice_text);

                    $myfile = fopen(BASE_PATH."/storage/".$node->id.".offline", "w+") or die("Unable to open file!");
                    $txt = "1";
                    fwrite($myfile, $txt);
                    fclose($myfile);
                }

                elseif ($node->isNodeOnline() === true && file_exists(BASE_PATH."/storage/".$node->id.".offline")) {
                foreach ($adminUser as $user) {
                    echo "Send offline mail to user: ".$user->id;
                    $subject = Config::get('appName')."-系统提示";
                    $to = $user->email;
                    $text = "管理员您好，系统发现节点 ".$node->name." 恢复上线了。" ;

                    try {
                        Mail::send($to, $subject, 'news/warn.tpl', [
                            "user" => $user,"text" => $text
                            ], [
                        ]);
                    } catch (\Exception $e) {
                        echo $e->getMessage();
                    }


                    if (Config::get('enable_cloudxns')=='true'&& ($node->sort==0 || $node->sort==10)) {
                        $api=new Api();
                        $api->setApiKey(Config::get("cloudxns_apikey"));//修改成自己API KEY
                        $api->setSecretKey(Config::get("cloudxns_apisecret"));//修改成自己的SECERET KEY
                        $api->setProtocol(true);

                        $domain_json=json_decode($api->domain->domainList());

                        foreach ($domain_json->data as $domain) {
                            if (strpos($domain->domain, Config::get('cloudxns_domain'))!==false) {
                                $domain_id=$domain->id;
                            }
                        }

                        $record_json=json_decode($api->record->recordList($domain_id, 0, 0, 2000));

                        foreach ($record_json->data as $record) {
                            if (($record->host.".".Config::get('cloudxns_domain'))==$node->server) {
                                $record_id=$record->record_id;

                                $api->record->recordUpdate($domain_id, $record->host, $node->getNodeIp(), 'A', 55, 600, 1, '', $record_id);
                            }
                        }

                        $notice_text = "喵喵喵~ ".$node->name." 节点恢复了喵~域名解析被切换回来了喵~";
                        } else {
                            $notice_text = "喵喵喵~ ".$node->name." 节点恢复了喵~";
                        }
                    }

                    Telegram::Send($notice_text);

                    unlink(BASE_PATH."/storage/".$node->id.".offline");
                }
            }
        }
*/

/*
        //登录地检测
        if (Config::get("login_warn")=="true") {
            $iplocation = new QQWry();
            $Logs = LoginIp::where("datetime", ">", time()-60)->get();
            foreach ($Logs as $log) {
                $UserLogs=LoginIp::where("userid", "=", $log->userid)->orderBy("id", "desc")->take(2)->get();
                if ($UserLogs->count()==2) {
                    $i = 0;
                    $Userlocation = "";
                    foreach ($UserLogs as $userlog) {
                        if ($i == 0) {
                            $location=$iplocation->getlocation($userlog->ip);
                            $ip=$userlog->ip;
                            $Userlocation = $location['country'];
                            $i++;
                        } else {
                            $location=$iplocation->getlocation($userlog->ip);
                            $nodes=Node::where("node_ip", "LIKE", $ip.'%')->first();
                            $nodes2=Node::where("node_ip", "LIKE", $userlog->ip.'%')->first();
                            if ($Userlocation!=$location['country']&&$nodes==null&&$nodes2==null) {
                                $user=User::where("id", "=", $userlog->userid)->first();
                                echo "Send warn mail to user: ".$user->id."-".iconv('gbk', 'utf-8//IGNORE', $Userlocation)."-".iconv('gbk', 'utf-8//IGNORE', $location['country']);
                                $subject = Config::get('appName')."-系统警告";
                                $to = $user->email;
                                $text = "您好，系统发现您的账号在 ".iconv('gbk', 'utf-8//IGNORE', $Userlocation)." 有异常登录，请您自己自行核实登录行为。有异常请及时修改密码。" ;
                                try {
                                    Mail::send($to, $subject, 'news/warn.tpl', [
                                        "user" => $user,"text" => $text
                                    ], [
                                    ]);
                                } catch (\Exception $e) {
                                    echo $e->getMessage();
                                }
                            }
                        }
                    }
                }
            }
        }

*/

        // 将即将到期的用户的等级重置为 0
        $timeNow = date("Y-m-d H:i:s", time() );
        $classOverUsers = User::where('class','>',0)->where('class_expire','<', $timeNow)->get();
        foreach ($classOverUsers as $user) {
            $user->class = 0;
            $user->save();
        }

        //要删除的用户，只是0级的，这样比较好一些。 而且使用时间也要有要求
        $delusers = User::where('class','<',1)->orderBy('id', 'desc')->get();
        foreach ($delusers as $user) {
            if (($user->transfer_enable<=$user->u+$user->d||$user->enable==0||(strtotime($user->expire_in)<time()&&strtotime($user->expire_in)>644447105))&&RadiusBan::where("userid", $user->id)->first()==null) {
                $rb=new RadiusBan();
                $rb->userid=$user->id;
                $rb->save();
                Radius::Delete($user->email);
            }

            if (strtotime($user->expire_in) < time()&&!file_exists(BASE_PATH."/storage/".$user->id.".expire_in")) {
                /* song 用户过期
                $user->transfer_enable = 0;
                $user->u = 0;
                $user->d = 0;
                $user->last_day_t = 0;

                $subject = Config::get('appName')."-您的用户账户已经过期了";
                $to = $user->email;
                $text = "您好，系统发现您的账号已经过期了。";
                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user,"text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
                */
                $myfile = fopen(BASE_PATH."/storage/".$user->id.".expire_in", "w+") or die("Unable to open file!");
                $txt = "1";
                fwrite($myfile, $txt);
                fclose($myfile);
            }
            elseif (strtotime($user->expire_in) > time()&&file_exists(BASE_PATH."/storage/".$user->id.".expire_in")) {
                unlink(BASE_PATH."/storage/".$user->id.".expire_in");
            }

/*
            //余量不足检测
            if(!file_exists(BASE_PATH."/storage/traffic_notified/")){
                mkdir(BASE_PATH."/storage/traffic_notified/");
            }
            if (Config::get('notify_limit_mode') !='false'){
                $user_traffic_left = $user->transfer_enable - $user->u - $user->d;
                $under_limit='false';

                if($user->transfer_enable != 0){
                    if (Config::get('notify_limit_mode') == 'per'&&
                    $user_traffic_left / $user->transfer_enable * 100 < Config::get('notify_limit_value')){
                    $under_limit='true';
                    $unit_text='%';
                    }
                }
                else if(Config::get('notify_limit_mode')=='mb'&&
                Tools::flowToMB($user_traffic_left) < Config::get('notify_limit_value')){
                    $under_limit='true';
                    $unit_text='MB';
                }

                if($under_limit=='true' && !file_exists(BASE_PATH."/storage/traffic_notified/".$user->id.".userid")){
                    $subject = Config::get('appName')." - 您的剩余流量过低";
                    $to = $user->email;
                    $text = '您好，系统发现您剩余流量已经低于 '.Config::get('notify_limit_value').$unit_text.' 。' ;
                    try {
                        Mail::send($to, $subject, 'news/warn.tpl', [
                            "user" => $user,"text" => $text
                        ], [
                        ]);
                        $myfile = fopen(BASE_PATH."/storage/traffic_notified/".$user->id.".userid", "w+") or die("Unable to open file!");
                        $txt = "1";
                        fwrite($myfile, $txt);
                        fclose($myfile);
                    } catch (\Exception $e) {
                        echo $e->getMessage();
                    }
                }
                else if($under_limit=='false'){
                    if(file_exists(BASE_PATH."/storage/traffic_notified/".$user->id.".userid")){
                    unlink(BASE_PATH."/storage/traffic_notified/".$user->id.".userid");
                    }
                }
            }
*/
            if ($user->class != 0 &&
                strtotime($user->class_expire)<time()
            ){

  /*             //Song  账号过期不通知
                $text = '您好，系统发现您的账号等级已经过期了。';
                $reset_traffic=Config::get('class_expire_reset_traffic');
                if($reset_traffic>=0){
                    $user->transfer_enable =Tools::toGB($reset_traffic);
                    $user->u = 0;
                    $user->d = 0;
                    $user->last_day_t = 0;
                    $text.='流量已经被重置为'.$reset_traffic.'GB';
                }
                $subject = Config::get('appName')."-您的账户等级已经过期了";
                $to = $user->email;
                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user,"text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
*/
                $user->class = 0;
            }


            // 这里开始检测用户账号是否到了被删除的时候
            $iskilluser = false;
            if (Config::get('account_expire_delete_days')>=0&&
                strtotime($user->expire_in)+Config::get('account_expire_delete_days')*86400<time() && ( time() - strtotime($user->expire_in) ) > ($user->money * 30 * 24 * 3600)
            ) {
                # 如果当前时间 - 过期时间 大于 用户余额的话， 1块钱=30天，所以：1元 = 2592000
                # 如果过期 x 个月，且余额小于 1元=30
                /*
                $subject = Config::get('appName')."-您的用户账户已经被删除了";
                $to = $user->email;
                $text = "您好，系统发现您的账户已经过期 ".Config::get('account_expire_delete_days')." 天了，帐号已经被删除。" ;

                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user,"text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
                */
                $iskilluser = true;  // 这里加个参数是否kill user
                //$user->kill_user();
                //continue;
            }elseif (Config::get('auto_clean_uncheck_days')>0 &&
                max($user->last_check_in_time, strtotime($user->reg_date)) + (Config::get('auto_clean_uncheck_days')*86400) < time() &&
                $user->class == 0 &&
                $user->money <= Config::get('auto_clean_min_money')
            ) {
                /*
                $subject = Config::get('appName')."-您的用户账户已经被删除了";
                $to = $user->email;
                $text = "您好，系统发现您的账号已经 ".Config::get('auto_clean_uncheck_days')." 天没签到了，帐号已经被删除。" ;

                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user,"text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
                */
                $iskilluser = true;
                //$user->kill_user();
                //continue;
            }elseif (Config::get('auto_clean_unused_days')>0 &&
                max($user->t, strtotime($user->reg_date)) + (Config::get('auto_clean_unused_days')*86400) < time() &&
                $user->class == 0 &&
                $user->money <= Config::get('auto_clean_min_money')
            ) {
                /*
                $subject = Config::get('appName')."-您的用户账户已经被删除了";
                $to = $user->email;
                $text = "您好，系统发现您的账号已经 ".Config::get('auto_clean_unused_days')." 天没使用了，帐号已经被删除。" ;

                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user,"text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
                */
                $iskilluser = true;
                //$user->kill_user();
                //continue;
            }elseif ( $user->t == 0 && $user->u == 0 && $user->d == 0 && (strtotime($user->reg_date) + 86400) < time() && $user->class == 0 && $user->money <= 1 ) { 
                // 增加一项，如果用户注册超过24小时，但是流量没使用，余额 < 1的话，就删除掉！ 防止注册机制导致网站出现问题。
                // t=0 u=0 d=0说明没有使用，然后注册还 > 24小时，而且等级为0 ，余额<1 这类账号也是需要被删除的！ 
                $iskilluser = true;
            }

            //song 如果返利扣除在这里扣除的话，会不会好一些？我觉得会好一些，不错的主意。嘎嘎 有点意思，嘿嘿 可以有
            if ( $iskilluser ) {
                # code...
                echo ' deluser-'.$user->id;
                if ($user->ref_by != 0 ) {  //存在邀请， 
                    # code...
                    $ref_user = User::find($user->ref_by);
                    //这里 -1 代表是注册返利  -2 代表是 删除账号 取消返利
                    $ref_payback = Payback::where('total','=',-1)->where('userid','=',$user->id)->where('ref_by','=',$user->ref_by)->first();
                    //这里 查询一下是否已经存在 扣除余额的情况，统计一下 -2 情况的数量
                    $pays = Payback::where('total','=',-2)->where('userid','=',$user->id)->where('ref_by','=', $user->ref_by)->count();
                    //先判断一下这个邀请人是否还存在   判断是否存在已扣除的情况
                    if ($ref_user->id != null  && $ref_payback->ref_get != null && $pays < 1) {    //如果存在
                        $ref_user->money -= $ref_payback->ref_get;     //这里用当前余额，减去当初返利的余额。
                        //扣除邀请的流量！ 不再扣除邀请流量
                        //$ref_user->transfer_enable -= Config::get('invite_gift') * 1024 * 1024 * 1024;
                        //邀请人的 ban_times += 1 惩罚一下
                        $ref_user->ban_times += 1 ;
                        $ref_user->save();
                        //写入返利日志
                        $Payback = new Payback();
                        #echo $user->id;
                        #echo ' ';
                        $Payback->total = -2;
                        $Payback->userid = $user->id;  //用户注册的ID
                        $Payback->ref_by = $user->ref_by;  //邀请人ID
                        $Payback->ref_get = - $ref_payback->ref_get;
                        $Payback->datetime = time();
                        $Payback->save();
                        // ref_payback 的 callback 写为1 就是这个返利被收回了。 实际这样的话，还是一个不错的方案的。也就是说，这个返利的话，只需要这里加一个参数就好了。无需之前的那种复杂的方案！ 这个可以有。
                        $ref_payback->callback = 1; // 设置这个返利已被收回！ 不错的做法和想法！ 
                        $ref_payback->save();
                    }
                }
                //然后再删除用户
                $user->kill_user();
                continue;
            }
            $user->save();
        }

        $rbusers = RadiusBan::all();
        foreach ($rbusers as $sinuser) {
            $user=User::find($sinuser->userid);

            if ($user == null) {
                $sinuser->delete();
                continue;
            }

            if ($user->enable==1&&(strtotime($user->expire_in)>time()||strtotime($user->expire_in)<644447105)&&$user->transfer_enable>$user->u+$user->d) {
                $sinuser->delete();
                Radius::Add($user, $user->passwd);
            }
        }
    }

    public static function detectGFW()
    {
        //节点被墙检测
        $last_time=file_get_contents(BASE_PATH."/storage/last_detect_gfw_time");
        for ($count=1;$count<=12;$count++){
            if(time()-$last_time>=Config::get("detect_gfw_interval")){
                $file_interval=fopen(BASE_PATH."/storage/last_detect_gfw_time","w");
                fwrite($file_interval,time());
                fclose($file_interval);
                $nodes=Node::all();
                $adminUser = User::where("is_admin", "=", "1")->get();
                foreach ($nodes as $node){
                    if($node->node_ip==""||
                    $node->node_ip==null||
                    file_exists(BASE_PATH."/storage/".$node->id."offline")==true){
                        continue;
                    }
                    $api_url=Config::get("detect_gfw_url");
                    $api_url=str_replace('{ip}',$node->node_ip,$api_url);
                    $api_url=str_replace('{port}',Config::get('detect_gfw_port'),$api_url);
                    //因为考虑到有v2ray之类的节点，所以不得不使用ip作为参数
                    $result_tcping=false;
                    $detect_time=Config::get("detect_gfw_count");
                    for ($i=1;$i<=$detect_time;$i++){
                        $json_tcping = json_decode(file_get_contents($api_url), true);
                        if(eval('return '.Config::get('detect_gfw_judge').';')){
                            $result_tcping=true;
                            break;
                        }
                    }
                    if($result_tcping==false){
                        //被墙了
                        echo($node->id.":false".PHP_EOL);
                        //判断有没有发送过邮件
                        if(file_exists(BASE_PATH."/storage/".$node->id.".gfw")){
                            continue;
                        }
                        foreach ($adminUser as $user) {
                            echo "Send gfw mail to user: ".$user->id."-";
                            $subject = Config::get('appName')."-系统警告";
                            $to = $user->email;
                            $text = "管理员您好，系统发现节点 ".$node->name." 被墙了，请您及时处理。" ;
                            try {
                                Mail::send($to, $subject, 'news/warn.tpl', [
                                    "user" => $user,"text" => $text
                                    ], [
                                ]);
                            }
                            catch (\Exception $e) {
                                echo $e->getMessage();
                            }
                            if (Config::get('enable_cloudxns')=='true' && ($node->sort==0 || $node->sort==10)) {
                                $api=new Api();
                                $api->setApiKey(Config::get("cloudxns_apikey"));
                                //修改成自己API KEY
                                $api->setSecretKey(Config::get("cloudxns_apisecret"));
                                //修改成自己的SECERET KEY
                                $api->setProtocol(true);
                                $domain_json=json_decode($api->domain->domainList());
                                foreach ($domain_json->data as $domain) {
                                    if (strpos($domain->domain, Config::get('cloudxns_domain'))!==false) {
                                        $domain_id=$domain->id;
                                    }
                                }
                                $record_json=json_decode($api->record->recordList($domain_id, 0, 0, 2000));
                                foreach ($record_json->data as $record) {
                                    if (($record->host.".".Config::get('cloudxns_domain'))==$node->server) {
                                        $record_id=$record->record_id;
                                        $Temp_node=Node::where('node_class', '<=', $node->node_class)->where(
                                            function ($query) use ($node) {
                                                $query->where("node_group", "=", $node->node_group)
                                                ->orWhere("node_group", "=", 0);
                                        })->whereRaw('UNIX_TIMESTAMP()-`node_heartbeat`<300')->first();
                                        if ($Temp_node!=null) {
                                            $api->record->recordUpdate($domain_id, $record->host, $Temp_node->server, 'CNAME', 55, 60, 1, '', $record_id);
                                        }
                                        $notice_text = "喵喵喵~ ".$node->name." 节点被墙了喵~域名解析被切换到了 ".$Temp_node->name." 上了喵~";
                                    }
                                }
                            } else {
                                $notice_text = "喵喵喵~ ".$node->name." 节点被墙了喵~";
                            }
                        }
                        Telegram::Send($notice_text);
                        $file_node = fopen(BASE_PATH."/storage/".$node->id.".gfw", "w+");
                        fclose($file_node);
                    } else{
                    //没有被墙
                        echo($node->id.":true".PHP_EOL);
                        if(file_exists(BASE_PATH."/storage/".$node->id.".gfw")==false){
                            continue;
                        }
                        foreach ($adminUser as $user) {
                            echo "Send gfw mail to user: ".$user->id."-";
                            $subject = Config::get('appName')."-系统提示";
                            $to = $user->email;
                            $text = "管理员您好，系统发现节点 ".$node->name." 溜出墙了。" ;
                            try {
                                Mail::send($to, $subject, 'news/warn.tpl', [
                                   "user" => $user,"text" => $text
                                      ], [
                                         ]);
                            }
                            catch (\Exception $e) {
                                echo $e->getMessage();
                            }
                            if (Config::get('enable_cloudxns')=='true'&& ($node->sort==0 || $node->sort==10)) {
                                $api=new Api();
                                $api->setApiKey(Config::get("cloudxns_apikey"));
                                //修改成自己API KEY
                                $api->setSecretKey(Config::get("cloudxns_apisecret"));
                                //修改成自己的SECERET KEY
                                $api->setProtocol(true);
                                $domain_json=json_decode($api->domain->domainList());
                                foreach ($domain_json->data as $domain) {
                                    if (strpos($domain->domain, Config::get('cloudxns_domain'))!==false) {
                                        $domain_id=$domain->id;
                                    }
                                }
                                $record_json=json_decode($api->record->recordList($domain_id, 0, 0, 2000));
                                foreach ($record_json->data as $record) {
                                    if (($record->host.".".Config::get('cloudxns_domain'))==$node->server) {
                                        $record_id=$record->record_id;
                                        $api->record->recordUpdate($domain_id, $record->host, $node->getNodeIp(), 'A', 55, 600, 1, '', $record_id);
                                    }
                                }
                                $notice_text = "喵喵喵~ ".$node->name." 节点恢复了喵~域名解析被切换回来了喵~";
                            } else {
                                $notice_text = "喵喵喵~ ".$node->name." 节点恢复了喵~";
                            }
                        }
                        Telegram::Send($notice_text);
                        unlink(BASE_PATH."/storage/".$node->id.".gfw");
                    }
                }
                break;
            } else{
                echo($node->id."interval skip".PHP_EOL);
                sleep(3);
            }
        }
    }

}
