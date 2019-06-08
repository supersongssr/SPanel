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
use App\Models\TrafficLog;
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
            case("autoCheckNodeStatus"):
                return $this->autoCheckNodeStatus();
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

    public function autoCheckNodeStatus()
    {

        //自动审计每天节点流量数据 song
        $nodes_vnstat = Node::where('id','>',4)->get();  // 只获取4以上的在线节点 
        foreach ($nodes_vnstat as $node) {
            # code...
            $addn = explode('#', $node->node_ip);
            if (empty($addn['1'])) {
                # code...
                $sum_u = TrafficLog::where('node_id','=', $node->id)->where('user_id','>','0')->where('log_time','>',(time()-86400))->sum('u');   //获取过去24小时内的总数据 再求和
                $sum_d = TrafficLog::where('node_id','=', $node->id)->where('user_id','>','0')->where('log_time','>',(time()-86400))->sum('d');   //获取过去24小时内的总数据 再求和
                $total = $sum_u + $sum_d;   //获取用户之和
            }else{
                $sum_u = TrafficLog::where('node_id','=', $node->id)->where('user_id','=','0')->where('log_time','>',(time()-86400))->sum('u');   //获取过去24小时内的总数据 再求和
                $sum_d = TrafficLog::where('node_id','=', $node->id)->where('user_id','=','0')->where('log_time','>',(time()-86400))->sum('d');   //获取过去24小时内的总数据 再求和
                $total = $sum_u + $sum_d;   //获取用户之和
            }
            #在线节点，流量少于16G 的 隐藏 且加· 
            if($total < 16777216 ){
              $node->name .= '·' ;
              $node->type = 0;        //在节点名字后面加上 · 这个符号，多了就能看到了。
            }
            $node->info = floor($total / 1073741824) . ' ' . $node->info ;  //将每天统计的节点的数据写入到节点的备注中去
            $node->info = substr($node->info, 0,128);             //截取字符串长度为128位 防止超出
            $node->save();
            //将节点每天的流量数据 写入到 node info 中，标志是 load = 0
            $node_info = new NodeInfoLog();
            $node_info->node_id = $node->id;
            $node_info->uptime = $total;
            $node_info->load = 0;
            $node_info->log_time = time();
            $node_info->save();
        }

        /**
        //song 自动获取每个节点的状态
        // 1 2 节点是预留节点不能用。只能获取2以上的节点
        $nodes_vnstat = Node::where('id','>',3)->get();
        $file = "/www/wwwroot/ssp-uim/public/".date("md");
        $node_line = '=====================================';
        $node_error = 'can not connect';
        $nodes_log = @file_put_contents($file, date("m-d H:i"));
        foreach ($nodes_vnstat as $node) {
            # code...
            $addn = explode('#', $node->node_ip);
            $server = $node->server ? $node->server : $addn['0'];
            $server_ip = gethostbyname($server);
            $addndesc = explode('@', $node->info);
            $server_port = $addndesc['1'] ? $addndesc['1'] : 80 ;
            $status_url = "http://".$server_ip.":".$server_port."/status";
            $vnstat_url = "http://".$server_ip.":".$server_port."/vnstat";
            $s1_url = "http://".$server_ip.":".$server_port."/s1"; // 增加自动获取v2脚本的配置信息
            $v2_url = "http://".$server_ip.":".$server_port."/v2";
            $status = @file_get_contents($status_url);
            $vnstat = @file_get_contents($vnstat_url);
            $s1 = @file_get_contents($s1_url);//增加自动获取v2脚本的配置信息 自动更新参数 
            $v2 = @file_get_contents($v2_url);
            if ($status == 7) {
                # code...
                $node->type = 1;
                $node->save();
                //将数据写入文件
                $data = $node->name."#".$server."#".$server_ip."#".$node->type."\n".$node_line."\n".$node->info.$vnstat."\n\n\n";
                $nodes_log = @file_put_contents($file, $data, FILE_APPEND);
            }elseif ($status == 4 ) {
                # code...
                $node->type = 0;
                $node->save();
                //将数据写入文件
                $data = $node->name."#".$server."#".$server_ip."#".$node->type."\n".$node_line."\n".$node->info.$vnstat."\n\n\n";
                $nodes_log = @file_put_contents($file, $data, FILE_APPEND);
            }else{
                # code...
                $node->type = 0;
                $node->save();
                //获取不到运行状态 也写入数据
                $data = $node->name."#".$server."#".$server_ip."#".$node->type.$node_error."\n".$node_line."\n".$node->info."\n\n\n";
                $nodes_log = @file_put_contents($file, $data, FILE_APPEND);
            } 
            // 这里开始 通过获取后端的配置信息 来主动配置节点的单节点 到信息中           
            if (!empty($addn['1'])) {
                # code...
                if ($node->sort == 0 && !empty($s1)) {
                    # code...
                    $node->node_ip = $s1;
                    $node->save();
                }
                if ($node->sort == 11 && !empty($v2)) {
                    # code...
                    $node->node_ip = $v2;
                    $node->save();
                }
                echo $node->server;
            }
        }
        **/
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
        if ($bot->setWebhook(Config::get('baseUrl')."/telegram_callback?token=".Config::get('telegram_request_token')) == 1) {
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
