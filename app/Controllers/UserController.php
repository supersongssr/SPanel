<?php

namespace App\Controllers;

use App\Services\Auth;
use App\Models\Node;
use App\Models\TrafficLog;
use App\Models\InviteCode;
use App\Models\CheckInLog;
use App\Models\Ann;
use App\Models\Speedtest;
use App\Models\Shop;
use App\Models\Coupon;
use App\Models\Bought;
use App\Models\Ticket;
use App\Services\Config;
use App\Services\Gateway\ChenPay;
use App\Services\Payment;
use App\Utils;
use App\Utils\AliPay;
use App\Utils\Hash;
use App\Utils\Tools;
use App\Utils\Radius;
use App\Models\RadiusBan;
use App\Models\DetectLog;
use App\Models\DetectRule;

use voku\helper\AntiXSS;

// cncdn
use App\Models\Cncdn;

use App\Models\User;
use App\Models\Code;
use App\Models\Ip;
use App\Models\Paylist;
use App\Models\LoginIp;
use App\Models\BlockIp;
use App\Models\UnblockIp;
use App\Models\Payback;
use App\Models\Relay;
use App\Utils\QQWry;
use App\Utils\GA;
use App\Utils\Geetest;
use App\Utils\Telegram;
use App\Utils\TelegramSessionManager;
use App\Utils\Pay;
use App\Utils\URL;
use App\Services\Mail;

/**
 *  HomeController
 */
class UserController extends BaseController
{
    private $user;

    public function __construct()
    {
        $this->user = Auth::getUser();
    }

    public function index($request, $response, $args)
    {

        $user = $this->user;
        $ssr_sub_token = LinkController::GenerateSSRSubCode($this->user->id, 0);

        $GtSdk = null;
        $recaptcha_sitekey = null;
        if (Config::get('enable_checkin_captcha') == 'true'){
            switch(Config::get('captcha_provider'))
            {
                case 'recaptcha':
                    $recaptcha_sitekey = Config::get('recaptcha_sitekey');
                    break;
                case 'geetest':
                    $uid = time().rand(1, 10000) ;
                    $GtSdk = Geetest::get($uid);
                    break;
            }
        }

        $Ann = Ann::orderBy('id', 'desc')->first();   //song


        return $this->view()
            ->assign('ssr_sub_token', $ssr_sub_token)
            ->assign('display_ios_class',Config::get('display_ios_class'))
            ->assign('ios_account',Config::get('ios_account'))
            ->assign('ios_password',Config::get('ios_password'))
            ->assign('ann', $Ann)
            ->assign('geetest_html', $GtSdk)
            ->assign('mergeSub', Config::get('mergeSub'))
            ->assign('subUrl', Config::get('subUrl'))
            ->assign("user", $this->user)
            ->registerClass("URL", "App\Utils\URL")
            ->assign('baseUrl', Config::get('baseUrl'))
            ->assign('recaptcha_sitekey', $recaptcha_sitekey)
            ->display('user/index.tpl');
    }

    public function lookingglass($request, $response, $args)
    {
        $Speedtest = Speedtest::where("datetime", ">", time() - Config::get('Speedtest_duration') * 3600)->orderBy('datetime', 'desc')->get();
        #$Speedtest = Speedtest::where("datetime", ">", time() - 24 * 3600)->orderBy('datetime', 'desc')->get();

        return $this->view()->assign('speedtest', $Speedtest)->assign('hour', Config::get('Speedtest_duration'))->display('user/lookingglass.tpl');
    }

    public function code($request, $response, $args)
    {
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $codes = Code::where('type', '<>', '-2')->where('userid', '=', $this->user->id)->orderBy('id', 'desc')->paginate(15, ['*'], 'page', $pageNum);
        $codes->setPath('/user/code');
        return $this->view()->assign('codes', $codes)->assign('pmw', Payment::purchaseHTML())->display('user/code.tpl');
    }

    public function orderDelete($request, $response, $args)
    {
        return (new ChenPay())->orderDelete($request);
    }

    public function donate($request, $response, $args)
    {
        if (Config::get('enable_donate') != 'true') {
            exit(0);
        }

        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $codes = Code::where(
            function ($query) {
                $query->where("type", "=", -1)
                    ->orWhere("type", "=", -2);
            }
        )->where("isused", 1)->orderBy('id', 'desc')->paginate(15, ['*'], 'page', $pageNum);
        $codes->setPath('/user/donate');
        return $this->view()->assign('codes', $codes)->assign('total_in', Code::where('isused', 1)->where('type', -1)->sum('number'))->assign('total_out', Code::where('isused', 1)->where('type', -2)->sum('number'))->display('user/donate.tpl');
    }

    function isHTTPS()
    {
        define('HTTPS', false);
        if (defined('HTTPS') && HTTPS) return true;
        if (!isset($_SERVER)) return FALSE;
        if (!isset($_SERVER['HTTPS'])) return FALSE;
        if ($_SERVER['HTTPS'] === 1) {  //Apache
            return TRUE;
        } elseif ($_SERVER['HTTPS'] === 'on') { //IIS
            return TRUE;
        } elseif ($_SERVER['SERVER_PORT'] == 443) { //其他
            return TRUE;
        }
        return FALSE;
    }



    public function code_check($request, $response, $args)
    {
        $time = $request->getQueryParams()["time"];
        $codes = Code::where('userid', '=', $this->user->id)->where('usedatetime', '>', date('Y-m-d H:i:s', $time))->first();
        if ($codes != null && strpos($codes->code, "充值") !== false) {
            $res['ret'] = 1;
            return $response->getBody()->write(json_encode($res));
        } else {
            $res['ret'] = 0;
            return $response->getBody()->write(json_encode($res));
        }
    }

    public function f2fpayget($request, $response, $args)
    {
        $time = $request->getQueryParams()["time"];
        $res['ret'] = 1;
        return $response->getBody()->write(json_encode($res));
    }

    public function f2fpay($request, $response, $args)
    {
        $amount = $request->getParam('amount');
        if ($amount == "") {
            $res['ret'] = 0;
            $res['msg'] = "订单金额错误：" . $amount;
            return $response->getBody()->write(json_encode($res));
        }
        $user = $this->user;

        //生成二维码
        $qrPayResult = Pay::alipay_get_qrcode($user, $amount, $qrPay);
        //  根据状态值进行业务处理
        switch ($qrPayResult->getTradeStatus()) {
            case "SUCCESS":
                $aliresponse = $qrPayResult->getResponse();
                $res['ret'] = 1;
                $res['msg'] = "二维码生成成功";
                $res['amount'] = $amount;
                $res['qrcode'] = $qrPay->create_erweima($aliresponse->qr_code);

                break;
            case "FAILED":
                $res['ret'] = 0;
                $res['msg'] = "支付宝创建订单二维码失败! 请使用其他方式付款。";

                break;
            case "UNKNOWN":
                $res['ret'] = 0;
                $res['msg'] = "系统异常，状态未知! 请使用其他方式付款。";

                break;
            default:
                $res['ret'] = 0;
                $res['msg'] = "创建订单二维码返回异常! 请使用其他方式付款。";

                break;
        }

        return $response->getBody()->write(json_encode($res));
    }

    public function alipay($request, $response, $args)
    {
        $amount = $request->getQueryParams()["amount"];
        Pay::getGen($this->user, $amount);
    }


    public function codepost($request, $response, $args)
    {
        $code = $request->getParam('code');
        $code = trim($code);
        $user = $this->user;

        if ($code == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }

        $codeq = Code::where("code", "=", $code)->where("isused", "=", 0)->first();
        if ($codeq == null) {
            $res['ret'] = 0;
            $res['msg'] = "此充值码错误或已被使用";
            return $response->getBody()->write(json_encode($res));
        }

        $codeq->isused = 1;
        $codeq->usedatetime = date("Y-m-d H:i:s");
        $codeq->userid = $user->id;
        $codeq->save();

        if ($codeq->type == -1) {
            $user->money = ($user->money + $codeq->number);
            $user->save();

            if ($user->ref_by != "" && $user->ref_by != 0 && $user->ref_by != null) {
                $gift_user = User::where("id", "=", $user->ref_by)->first();
                $gift_user->money += ($codeq->number * (Config::get('code_payback') / 100));
                $gift_user->save();

                //写入返利日志
                $Payback = new Payback();
                $Payback->total = $codeq->number;
                $Payback->userid = $this->user->id;
                $Payback->ref_by = $this->user->ref_by;
                $Payback->ref_get = $codeq->number * (Config::get('code_payback') / 100);
                $Payback->datetime = time();
                $Payback->save();

                // 二级返利
                if ($gift_user->ref_by != 0 && $gift_user->ref_by != null) {
                    $gift_user2 = User::where("id", "=", $gift_user->ref_by)->first();
                    $gift_user2->money += ($codeq->number * (Config::get('code_payback2') / 100));
                    $gift_user2->save();

                    //写入返利日志
                    $Payback = new Payback();
                    $Payback->total = $codeq->number;
                    $Payback->userid = $gitf_user->id;
                    $Payback->ref_by = $gitf_user->ref_by;
                    $Payback->ref_get = $codeq->number * (Config::get('code_payback2') / 100);
                    $Payback->datetime = time();
                    $Payback->save();
                }
            }

            $res['ret'] = 1;
            $res['msg'] = "充值成功，充值的金额为" . $codeq->number . "元。";

            if (Config::get('enable_donate') == 'true') {
                if ($this->user->is_hide == 1) {
                    Telegram::Send("姐姐姐姐，一位不愿透露姓名的大老爷给我们捐了 " . $codeq->number . " 元呢~");
                } else {
                    Telegram::Send("姐姐姐姐，" . $this->user->user_name . " 大老爷给我们捐了 " . $codeq->number . " 元呢~");
                }
            }

            return $response->getBody()->write(json_encode($res));
        }

        if ($codeq->type == 10001) {
            $user->transfer_enable = $user->transfer_enable + $codeq->number * 1024 * 1024 * 1024;
            $user->save();
        }

        if ($codeq->type == 10002) {
            if (time() > strtotime($user->expire_in)) {
                $user->expire_in = date("Y-m-d H:i:s", time() + $codeq->number * 86400);
            } else {
                $user->expire_in = date("Y-m-d H:i:s", strtotime($user->expire_in) + $codeq->number * 86400);
            }
            $user->save();
        }

        if ($codeq->type >= 1 && $codeq->type <= 10000) {
            if ($user->class == 0 || $user->class != $codeq->type) {
                $user->class_expire = date("Y-m-d H:i:s", time());
                $user->save();
            }
            $user->class_expire = date("Y-m-d H:i:s", strtotime($user->class_expire) + $codeq->number * 86400);
            $user->class = $codeq->type;
            $user->save();
        }
    }


    public function GaCheck($request, $response, $args)
    {
        $code = $request->getParam('code');
        $user = $this->user;


        if ($code == "") {
            $res['ret'] = 0;
            $res['msg'] = "二维码不能为空";
            return $response->getBody()->write(json_encode($res));
        }

        $ga = new GA();
        $rcode = $ga->verifyCode($user->ga_token, $code);
        if (!$rcode) {
            $res['ret'] = 0;
            $res['msg'] = "测试错误";
            return $response->getBody()->write(json_encode($res));
        }


        $res['ret'] = 1;
        $res['msg'] = "测试成功";
        return $response->getBody()->write(json_encode($res));
    }


    public function GaSet($request, $response, $args)
    {
        $enable = $request->getParam('enable');
        $user = $this->user;

        if ($enable == "") {
            $res['ret'] = 0;
            $res['msg'] = "选项无效";
            return $response->getBody()->write(json_encode($res));
        }

        $user->ga_enable = $enable;
        $user->save();


        $res['ret'] = 1;
        $res['msg'] = "设置成功";
        return $response->getBody()->write(json_encode($res));
    }

    public function ResetPort($request, $response, $args)
    {
        $price = Config::get('port_price');
        $user = $this->user;

        if ($user->money < $price) {
            $res['ret'] = 0;
            $res['msg'] = "余额不足";
            return $response->getBody()->write(json_encode($res));
        }

        $origin_port = $user->port;

        $user->port = Tools::getAvPort();


        $relay_rules = Relay::where('user_id', $user->id)->where('port', $origin_port)->get();
        foreach ($relay_rules as $rule) {
            $rule->port = $user->port;
            $rule->save();
        }

        $user->money -= $price;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = $user->port;
        return $response->getBody()->write(json_encode($res));
    }

    public function SpecifyPort($request, $response, $args)
    {
        $price = Config::get('port_price_specify');
        $user = $this->user;

        if ($user->money < $price) {
            $res['ret'] = 0;
            $res['msg'] = "余额不足";
            return $response->getBody()->write(json_encode($res));
        }

        $port = $request->getParam('port');

        if ($port < Config::get('min_port') || $port > Config::get('max_port') || Tools::isInt($port) == false) {
            $res['ret'] = 0;
            $res['msg'] = "端口不在要求范围内";
            return $response->getBody()->write(json_encode($res));
        }

        $port_occupied = User::pluck('port')->toArray();

        if (in_array($port, $port_occupied) == true) {
            $res['ret'] = 0;
            $res['msg'] = "端口已被占用";
            return $response->getBody()->write(json_encode($res));
        }

        $origin_port = $user->port;

        $user->port = $port;


        $relay_rules = Relay::where('user_id', $user->id)->where('port', $origin_port)->get();
        foreach ($relay_rules as $rule) {
            $rule->port = $user->port;
            $rule->save();
        }

        $user->money -= $price;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "钦定成功";
        return $response->getBody()->write(json_encode($res));
    }

    public function GaReset($request, $response, $args)
    {
        $user = $this->user;
        $ga = new GA();
        $secret = $ga->createSecret();

        $user->ga_token = $secret;
        $user->save();
        $newResponse = $response->withStatus(302)->withHeader('Location', '/user/edit');
        return $newResponse;
    }


    public function nodeAjax($request, $response, $args)
    {
        $id = $args['id'];
        $point_node = Node::find($id);
        $prefix = explode(" - ", $point_node->name);
        return $this->view()->assign('point_node', $point_node)->assign('prefix', $prefix[0])->assign('id', $id)->display('user/nodeajax.tpl');
    }

    public function node($request, $response, $args)
    {
        $user = Auth::getUser();
        $nodes = Node::where('node_group','=',$user->node_group)->orwhere('node_group','=',0)->where('id','>',3)->where('type', 1)->orderBy('node_class')->orderBy('traffic_rate')->get();
        $relay_rules = Relay::where('user_id', $this->user->id)->orwhere('user_id', 0)->orderBy('id', 'asc')->get();
        if (!Tools::is_protocol_relay($user)) {
            $relay_rules = array();
        }

        $array_nodes=array();
        $nodes_muport = array();

        foreach($nodes as $node){
            if($node->node_group!=$user->node_group && $node->node_group!=0){
                continue;
            }
            if ($node->sort == 9) {
                $mu_user = User::where('port', '=', $node->server)->first();
                $mu_user->obfs_param = $this->user->getMuMd5();
                array_push($nodes_muport, array('server' => $node, 'user' => $mu_user));
                continue;
            }
            $array_node=array();

            $array_node['id']=$node->id;
            $array_node['class']=$node->node_class;
            $array_node['name']=$node->name.'·#'.$node->id;
            $array_node['server']=$node->server;
            $array_node['sort']=$node->sort;
            $array_node['info']=$node->info;
            $array_node['mu_only']=$node->mu_only;
            $array_node['group']=$node->node_group;

            $array_node['raw_node'] = $node;


            $regex = Config::get('flag_regex');
            $matches = array();
            preg_match($regex, $node->name, $matches);
            if (isset($matches[0])) {
                $array_node['flag'] = $matches[0].'.png';
            }
            else {
                $array_node['flag'] = 'unknown.png';
            }

/*
            $node_online=$node->isNodeOnline();

            if($node_online===null){
                $array_node['online']=0;
            }
            else if($node_online===true){
                $array_node['online']=1;
            }
            else if($node_online===false){
                $array_node['online']=-1;
            }
*/
            $array_node['online']=1;

/*
            if ($node->sort == 0 ||$node->sort == 7 || $node->sort == 8 ||
                $node->sort == 10 || $node->sort == 11){
                $array_node['online_user']=$node->getOnlineUserCount();
            }
            else{
                $array_node['online_user']=-1;
            }
            */

            $array_node['online_user']=$node->node_online;

            /*
            $nodeLoad = $node->getNodeLoad();
            if (isset($nodeLoad[0]['load'])) {
                $array_node['latest_load'] = ((explode(" ", $nodeLoad[0]['load']))[0]) * 100;
            }
            else {
                $array_node['latest_load'] = -1;
            }
            */

            $array_node['latest_load'] = $node->node_oncost;

/*
            $array_node['traffic_used'] = (int)Tools::flowToGB($node->node_bandwidth);
            $array_node['traffic_limit'] = (int)Tools::flowToGB($node->node_bandwidth_limit);
            if($node->node_speedlimit==0.0){
                $array_node['bandwidth']=0;
            }
            else if($node->node_speedlimit>=1024.00){
                $array_node['bandwidth']=round($node->node_speedlimit/1024.00,1).'Gbps';
            }
            else{
                $array_node['bandwidth']=$node->node_speedlimit.'Mbps';
            }
            */
            $array_node['traffic_used'] = (int)Tools::flowToGB($node->node_bandwidth);
            $array_node['traffic_limit'] = (int)Tools::flowToGB($node->node_bandwidth_limit);
            $array_node['bandwidth']=$node->node_oncost;

            $array_node['traffic_rate']=$node->traffic_rate;
            $array_node['status']=$node->status;

            array_push($array_nodes,$array_node);
        }
        return $this->view()->assign('nodes', $array_nodes)->assign('nodes_muport', $nodes_muport)->assign('relay_rules', $relay_rules)->assign('tools', new Tools())->assign('user', $user)->registerClass("URL", "App\Utils\URL")->display('user/node.tpl');
    }


    public function node_old($request, $response, $args)
    {
        $user = Auth::getUser();
        $nodes = Node::where('type', 1)->orderBy('name')->get();
        $relay_rules = Relay::where('user_id', $this->user->id)->orwhere('user_id', 0)->orderBy('id', 'asc')->get();

        if (!Tools::is_protocol_relay($user)) {
            $relay_rules = array();
        }

        $node_prefix = array();
        $node_flag_file = array();
        $node_method = array();
        $a = 0;//命名的什么JB变量
        $node_order = array();
        $node_alive = array();
        $node_prealive = array();
        $node_heartbeat = array();
        $node_bandwidth = array();
        $node_muport = array();
        $node_isv6 = array();
        $node_class = array();
        $node_latestload = array();

        $ports_count = Node::where('type', 1)->where('sort', 9)->orderBy('name')->count();


        $ports_count += 1;

        foreach ($nodes as $node) {
            if (((($user->node_group == $node->node_group || $node->node_group == 0)) || $user->is_admin) && (!$node->isNodeTrafficOut())) {
                if ($node->sort == 9) {
                    $mu_user = User::where('port', '=', $node->server)->first();
                    $mu_user->obfs_param = $this->user->getMuMd5();
                    array_push($node_muport, array('server' => $node, 'user' => $mu_user));
                    continue;
                }

                $temp = explode(" - ", $node->name);
                $name_cheif = $temp[0];

                $node_isv6[$name_cheif] = $node->isv6;
                $node_class[$name_cheif] = $node->node_class;

                if (!isset($node_prefix[$name_cheif])) {
                    $node_prefix[$name_cheif] = array();
                    $node_order[$name_cheif] = $a;
                    $node_alive[$name_cheif] = 0;

                    if (isset($temp[1])) {
                        $node_method[$name_cheif] = $temp[1];
                    } else {
                        $node_method[$name_cheif] = "";
                    }

                    $a++;
                }


                if ($node->sort == 0 || $node->sort == 7 || $node->sort == 8 || $node->sort == 10 || $node->sort == 11) {
                    $node_tempalive = $node->getOnlineUserCount();
                    $node_prealive[$node->id] = $node_tempalive;
                    if ($node->isNodeOnline() !== null) {
                        if ($node->isNodeOnline() === false) {
                            $node_heartbeat[$name_cheif] = "离线";
                        } else {
                            $node_heartbeat[$name_cheif] = "在线";
                        }
                    } else {
                        if (!isset($node_heartbeat[$name_cheif])) {
                            $node_heartbeat[$name_cheif] = "暂无数据";
                        }
                    }

                    if ($node->node_bandwidth_limit == 0) {
                        $node_bandwidth[$name_cheif] = (int)($node->node_bandwidth / 1024 / 1024 / 1024) . " GB 已用";
                    } else {
                        $node_bandwidth[$name_cheif] = (int)($node->node_bandwidth / 1024 / 1024 / 1024) . " GB / " . (int)($node->node_bandwidth_limit / 1024 / 1024 / 1024) . " GB - " . $node->bandwidthlimit_resetday . " 日重置";
                    }

                    if ($node_tempalive != "暂无数据") {
                        $node_alive[$name_cheif] = $node_alive[$name_cheif] + $node_tempalive;
                    }
                } else {
                    $node_prealive[$node->id] = "暂无数据";
                    if (!isset($node_heartbeat[$temp[0]])) {
                        $node_heartbeat[$name_cheif] = "暂无数据";
                    }
                }

                if (isset($temp[1])) {
                    if (strpos($node_method[$name_cheif], $temp[1]) === false) {
                        $node_method[$name_cheif] = $node_method[$name_cheif] . " " . $temp[1];
                    }
                }

                $nodeLoad = $node->getNodeLoad();
                if (isset($nodeLoad[0]['load'])) {
                    $node_latestload[$name_cheif] = ((float)(explode(" ", $nodeLoad[0]['load']))[0]) * 100;
                } else {
                    $node_latestload[$name_cheif] = null;
                }

                array_push($node_prefix[$name_cheif], $node);

                if (Config::get('enable_flag') == "true") {
                    $regex = Config::get('flag_regex');
                    $matches = array();
                    preg_match($regex, $name_cheif, $matches);
                    if (isset($matches[0])) {
                        $node_flag_file[$name_cheif] = $matches[0];
                    } else {
                        $node_flag_file[$name_cheif] = "null";
                    }
                }
            }
        }
        $node_prefix = (object)$node_prefix;
        $node_order = (object)$node_order;
        $tools = new Tools();
        return $this->view()->assign('relay_rules', $relay_rules)->assign('node_class', $node_class)->assign('node_isv6', $node_isv6)->assign('tools', $tools)->assign('node_method', $node_method)->assign('node_muport', $node_muport)->assign('node_bandwidth', $node_bandwidth)->assign('node_heartbeat', $node_heartbeat)->assign('node_prefix', $node_prefix)->assign('node_flag_file', $node_flag_file)->assign('node_prealive', $node_prealive)->assign('node_order', $node_order)->assign('user', $user)->assign('node_alive', $node_alive)->assign('node_latestload', $node_latestload)->registerClass("URL", "App\Utils\URL")->display('user/node.tpl');
    }


    public function nodeInfo($request, $response, $args)
    {
        $user = Auth::getUser();
        $id = $args['id'];
        $mu = $request->getQueryParams()["ismu"];
        $relay_rule_id = $request->getQueryParams()["relay_rule"];
        $node = Node::find($id);

        if ($node == null) {
            return null;
        }


        switch ($node->sort) {
            case 0:
                if ((($user->class >= $node->node_class && ($user->node_group == $node->node_group || $node->node_group == 0)) || $user->is_admin) && ($node->node_bandwidth_limit == 0 || $node->node_bandwidth < $node->node_bandwidth_limit)) {
                    return $this->view()->assign('node', $node)->assign('user', $user)->assign('mu', $mu)->assign('relay_rule_id', $relay_rule_id)->registerClass("URL", "App\Utils\URL")->display('user/nodeinfo.tpl');
                }
                break;
            case 1:
                if ($user->class >= $node->node_class && ($user->node_group == $node->node_group || $node->node_group == 0)) {
                    $email = $this->user->email;
                    $email = Radius::GetUserName($email);
                    $json_show = "VPN 信息<br>地址：" . $node->server . "<br>" . "用户名：" . $email . "<br>密码：" . $this->user->passwd . "<br>支持方式：" . $node->method . "<br>备注：" . $node->info;

                    return $this->view()->assign('json_show', $json_show)->display('user/nodeinfovpn.tpl');
                }
                break;
            case 2:
                if ($user->class >= $node->node_class && ($user->node_group == $node->node_group || $node->node_group == 0)) {
                    $email = $this->user->email;
                    $email = Radius::GetUserName($email);
                    $json_show = "SSH 信息<br>地址：" . $node->server . "<br>" . "用户名：" . $email . "<br>密码：" . $this->user->passwd . "<br>支持方式：" . $node->method . "<br>备注：" . $node->info;

                    return $this->view()->assign('json_show', $json_show)->display('user/nodeinfossh.tpl');
                }
                break;
            case 5:
                if ($user->class >= $node->node_class && ($user->node_group == $node->node_group || $node->node_group == 0)) {
                    $email = $this->user->email;
                    $email = Radius::GetUserName($email);

                    $json_show = "Anyconnect 信息<br>地址：" . $node->server . "<br>" . "用户名：" . $email . "<br>密码：" . $this->user->passwd . "<br>支持方式：" . $node->method . "<br>备注：" . $node->info;

                    return $this->view()->assign('json_show', $json_show)->display('user/nodeinfoanyconnect.tpl');
                }
                break;
            case 10:
                if ((($user->class >= $node->node_class && ($user->node_group == $node->node_group || $node->node_group == 0)) || $user->is_admin) && ($node->node_bandwidth_limit == 0 || $node->node_bandwidth < $node->node_bandwidth_limit)) {
                    return $this->view()->assign('node', $node)->assign('user', $user)->assign('mu', $mu)->assign('relay_rule_id', $relay_rule_id)->registerClass("URL", "App\Utils\URL")->display('user/nodeinfo.tpl');
                }
                break;
            default:
                echo "微笑";

        }
    }

    public function GetIosConf($request, $response, $args)
    {
        $newResponse = $response->withHeader('Content-type', ' application/octet-stream')->withHeader('Content-Disposition', ' attachment; filename=allinone.conf');//->getBody()->write($builder->output());
        if ($this->user->is_admin) {
            $newResponse->getBody()->write(LinkController::GetIosConf(Node::where(
                function ($query) {
                    $query->where('sort', 0)
                        ->orWhere('sort', 10);
                }
            )->where("type", "1")->get(), $this->user));
        } else {
            $newResponse->getBody()->write(LinkController::GetIosConf(Node::where(
                function ($query) {
                    $query->where('sort', 0)
                        ->orWhere('sort', 10);
                }
            )->where("type", "1")->where(
                function ($query) {
                    $query->where("node_group", "=", $this->user->node_group)
                        ->orWhere("node_group", "=", 0);
                }
            )->where("node_class", "<=", $this->user->class)->get(), $this->user));
        }
        return $newResponse;
    }


    public function profile($request, $response, $args)
    {
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $paybacks = Payback::where("ref_by", $this->user->id)->orderBy("datetime", "desc")->paginate(15, ['*'], 'page', $pageNum);
        $paybacks->setPath('/user/profile');

        $iplocation = new QQWry();

        $userip = array();

        $total = Ip::where("datetime", ">=", time() - 300)->where('userid', '=', $this->user->id)->get();

        $totallogin = LoginIp::where('userid', '=', $this->user->id)->where("type", "=", 0)->orderBy("datetime", "desc")->take(10)->get();

        $userloginip = array();

        foreach ($totallogin as $single) {
            //if(isset($useripcount[$single->userid]))
            {
                if (!isset($userloginip[$single->ip])) {
                    //$useripcount[$single->userid]=$useripcount[$single->userid]+1;
                    $location = $iplocation->getlocation($single->ip);
                    $userloginip[$single->ip] = iconv('gbk', 'utf-8//IGNORE', $location['country'] . $location['area']);
                }
            }
        }

        foreach ($total as $single) {
            //if(isset($useripcount[$single->userid]))
            {
                $single->ip = Tools::getRealIp($single->ip);
                $is_node = Node::where("node_ip", $single->ip)->first();
                if ($is_node) {
                    continue;
                }


                if (!isset($userip[$single->ip])) {
                    //$useripcount[$single->userid]=$useripcount[$single->userid]+1;
                    $location = $iplocation->getlocation($single->ip);
                    $userip[$single->ip] = iconv('gbk', 'utf-8//IGNORE', $location['country'] . $location['area']);
                }
            }
        }


        return $this->view()->assign("userip", $userip)->assign("userloginip", $userloginip)->assign("paybacks", $paybacks)->display('user/profile.tpl');
    }

    public function cncdnlooking($request, $response, $args)
    {
        /*
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $cncdns = User::where('cncdn_count','>',7)->orderBy("cncdn_count", "desc")->paginate(25, ['*'], 'page', $pageNum);
        $cncdns->setPath('/user/cncdnlooking');
        */
        $cncdns = Cncdn::where('status',1)->where('show',1)->get();
        $usercdns = User::where('cncdn_count','>',32)->where('score','>',32)->orderBy("cncdn_count", "desc")->limit('100')->get();

        $iplocation = new QQWry();

        foreach ($usercdns as $usercdn) {
            $location = $iplocation->getlocation($usercdn->rss_ip);
            $usercdn->location = iconv('gbk', 'utf-8//IGNORE', $location['area'] . ' | ' .$location['country']);
        }

        return $this->view()->assign("user", $this->user)->assign("cncdns", $cncdns)->assign("usercdns", $usercdns)->display('user/cncdnlooking.tpl');
    }

    public function cfcdnlooking($request, $response, $args)
    {
        /*
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $cfcdns = User::where('cfcdn_count','>',7)->orderBy("cfcdn_count", "desc")->paginate(25, ['*'], 'page', $pageNum);
        $cfcdns->setPath('/user/cfcdnlooking');
*/

  // cfcdn count > 32,  用户使用得分 这个排序会好一些。
        $cfcdns = User::where('score','>',32)->orderBy("cfcdn_count", "desc")->limit('128')->get();

        $iplocation = new QQWry();

        foreach ($cfcdns as $cfcdn) {
            $location = $iplocation->getlocation($cfcdn->rss_ip);
            $cfcdn->location = iconv('gbk', 'utf-8//IGNORE', $location['area'] . ' | ' .$location['country'] );
        }

        return $this->view()->assign("user", $this->user)->assign("cfcdns", $cfcdns)->display('user/cfcdnlooking.tpl');
    }


    public function announcement($request, $response, $args)
    {
        if (empty($args['id'])) {        //Song
            # code...
            $Anns = Ann::orderBy('date', 'desc')->get();
            foreach ($Anns as $Ann) {
                $title = explode('#',$Ann->markdown);
                $Ann->markdown = $title['1'];
                $Ann->content = '';
            }
        }else{
            $id = $args['id'];
            $Anns = Ann::where("id", "=", $id)->get();
            foreach ($Anns as $Ann) {
                $title = explode('#',$Ann->markdown);
                $Ann->markdown = $title['1'];
            }
        }

        return $this->view()->assign("anns", $Anns)->display('user/announcement.tpl');
    }

    public function tutorial($request, $response, $args)
    {
        return $this->view()->display('user/tutorial.tpl');
    }


    public function edit($request, $response, $args)
    {
        $themes = Tools::getDir(BASE_PATH . "/resources/views");

        //增加一个cdn的选项
        $cncdns = Cncdn::where('status',1)->where('show',1)->get();

       /* $user = $this->user;
        //$user_area = '自动优化(默认)';
        //if ($user->cncdn != 0) {
            $usercncdn = Cncdn::where('status','=',1)->where('areaid','=',$user->cncdn)->first();
            $user_area = $usercncdn->area;
        //}*/

        $BIP = BlockIp::where("ip", $_SERVER["REMOTE_ADDR"])->first();
        if ($BIP == null) {
            $Block = "IP: " . $_SERVER["REMOTE_ADDR"] . " 没有被封";
            $isBlock = 0;
        } else {
            $Block = "IP: " . $_SERVER["REMOTE_ADDR"] . " 已被封";
            $isBlock = 1;
        }

        $bind_token = TelegramSessionManager::add_bind_session($this->user);

        $config_service = new Config();

        return $this->view()->assign('user', $this->user)->assign('user_area', $user_area)->assign('cncdns', $cncdns)->assign('themes', $themes)->assign('isBlock', $isBlock)->assign('Block', $Block)->assign('bind_token', $bind_token)->assign('telegram_bot', Config::get('telegram_bot'))->assign('config_service', $config_service)
            ->registerClass("URL", "App\Utils\URL")->display('user/edit.tpl');
    }


    public function invite($request, $response, $args)
    {
        $code = InviteCode::where('user_id', $this->user->id)->first();
        if ($code == null) {
            $this->user->addInviteCode();
			$code = InviteCode::where('user_id', $this->user->id)->first();
        }

        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $paybacks = Payback::where('total','!=',-2)->where("ref_by", $this->user->id)->orderBy("id", "desc")->paginate(15, ['*'], 'page', $pageNum);
        if (!$paybacks_sum = Payback::where("ref_by", $this->user->id)->sum('ref_get')) {
            $paybacks_sum = 0;
        }
        if (!$aff_paybacks_sum = Payback::where('total','<',0)->where("ref_by", $this->user->id)->sum('ref_get')) {
            $aff_paybacks_sum = 0;
        }
        if (!$ref_paybacks_sum = Payback::where('total','>',0)->where("ref_by", $this->user->id)->sum('ref_get')) {
            $ref_paybacks_sum = 0;
        }
        $user = $this->user;
        $good_user = User::where('ref_by','=',$this->user->id)->where('score','>=',32)->count();
        $bad_user = User::where('ref_by','=',$this->user->id)->where('score','<',32)->count();

        $paybacks->setPath('/user/invite');

        return $this->view()->assign('code', $code)->assign('paybacks', $paybacks)->assign('paybacks_sum', $paybacks_sum)->assign('aff_paybacks_sum', $aff_paybacks_sum)->assign('ref_paybacks_sum', $ref_paybacks_sum)->assign('user', $user)->assign('good_user', $good_user)->assign('bad_user', $bad_user)->display('user/invite.tpl');
    }

    public function buyInvite($request, $response, $args)
    {
        $price = Config::get('invite_price');
        $num = $request->getParam('num');
        $num = trim($num);

        if (!Tools::isInt($num) || $price < 0 || $num <= 0) {
            $res['ret'] = 0;
            $res['msg'] = "非法请求";
            return $response->getBody()->write(json_encode($res));
        }

        $amount = $price * $num;

        $user = $this->user;
        if ($user->money < $amount) {
            $res['ret'] = 0;
            $res['msg'] = "余额不足，总价为" . $amount . "元。";
            return $response->getBody()->write(json_encode($res));
        }
        $user->invite_num += $num;
        $user->money -= $amount;
        $user->save();
        $res['invite_num'] = $user->invite_num;
        $res['ret'] = 1;
        $res['msg'] = "邀请次数添加成功";
        return $response->getBody()->write(json_encode($res));
    }

    public function customInvite($request, $response, $args)
    {
        $price = Config::get('custom_invite_price');
        $customcode = $request->getParam('customcode');
        $customcode = trim($customcode);

        if (!Tools::is_validate($customcode) || $price < 0 || strlen($customcode)<1 || strlen($customcode)>32) {
            $res['ret'] = 0;
            $res['msg'] = "非法请求,邀请链接后缀不能包含特殊符号且长度不能大于32字符";
            return $response->getBody()->write(json_encode($res));
        }

        if (InviteCode::where('code', $customcode)->count()!=0) {
            $res['ret'] = 0;
            $res['msg'] = "此后缀名被抢注了";
            return $response->getBody()->write(json_encode($res));
        }

        $user = $this->user;
        if ($user->money < $price) {
            $res['ret'] = 0;
            $res['msg'] = "余额不足，总价为" . $price . "元。";
            return $response->getBody()->write(json_encode($res));
        }
        $code = InviteCode::where('user_id', $user->id)->first();
        $code->code = $customcode;
        $user->money -= $price;
        $user->save();
        $code->save();
        $res['ret'] = 1;
        $res['msg'] = "定制成功";
        return $response->getBody()->write(json_encode($res));
    }

    public function sys()
    {
        return $this->view()->assign('ana', "")->display('user/sys.tpl');
    }

    public function updatePassword($request, $response, $args)
    {
        $oldpwd = $request->getParam('oldpwd');
        $pwd = $request->getParam('pwd');
        $repwd = $request->getParam('repwd');
        $user = $this->user;
        if (!Hash::checkPassword($user->pass, $oldpwd)) {
            $res['ret'] = 0;
            $res['msg'] = "旧密码错误";
            return $response->getBody()->write(json_encode($res));
        }
        if ($pwd != $repwd) {
            $res['ret'] = 0;
            $res['msg'] = "两次输入不符合";
            return $response->getBody()->write(json_encode($res));
        }

        if (strlen($pwd) < 8) {
            $res['ret'] = 0;
            $res['msg'] = "密码太短啦";
            return $response->getBody()->write(json_encode($res));
        }
        $hashPwd = Hash::passwordHash($pwd);
        $user->pass = $hashPwd;
        $user->save();

        $user->clean_link();

        $res['ret'] = 1;
        $res['msg'] = "修改成功";
        return $this->echoJson($response, $res);
    }

    public function updateHide($request, $response, $args)
    {
        $hide = $request->getParam('hide');
        $user = $this->user;
        $user->is_hide = $hide;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "修改成功";
        return $this->echoJson($response, $res);
    }

    public function Unblock($request, $response, $args)
    {
        $user = $this->user;
        $BIP = BlockIp::where("ip", $_SERVER["REMOTE_ADDR"])->get();
        foreach ($BIP as $bi) {
            $bi->delete();
        }

        $UIP = new UnblockIp();
        $UIP->userid = $user->id;
        $UIP->ip = $_SERVER["REMOTE_ADDR"];
        $UIP->datetime = time();
        $UIP->save();


        $res['ret'] = 1;
        $res['msg'] = $_SERVER["REMOTE_ADDR"];
        return $this->echoJson($response, $res);
    }

    public function shop($request, $response, $args)
    {
        $shops = Shop::where("status", 1)->orderBy("price",'asc')->get();
        return $this->view()->assign('shops', $shops)->display('user/shop.tpl');
    }

    public function CouponCheck($request, $response, $args)
    {
        $coupon = $request->getParam('coupon');
        $coupon = trim($coupon);

        $shop = $request->getParam('shop');

        $shop = Shop::where("id", $shop)->where("status", 1)->first();

        if ($shop == null) {
            $res['ret'] = 0;
            $res['msg'] = "非法请求";
            return $response->getBody()->write(json_encode($res));
        }

        // song 学生自动优惠
        $user = $this->user;
        //if (in_array($usernameSuffix[1], $eduSupport)) {
        if (strrchr($user->email, 'edu.cn') == 'edu.cn') {
            $edu_user = true;
        }

        if ($coupon == "") {
            $res['ret'] = 1;
            $res['name'] = $shop->name;
            $res['credit'] = "0 %";
            $res['total'] = $shop->price . "元";
            $edu_user == true && $res['credit'] = "0% + 50 %教育优惠";
            $edu_user == true && $res['total'] = ($shop->price / 2) . "元";
            return $response->getBody()->write(json_encode($res));
        }

        // 这里 按照排序，选择最后一个 有效的 优惠码。这个方便做更改优惠码的方式
        $coupon = Coupon::where("code", $coupon)->orderBy("id",DESC)->first();

        if ($coupon == null) {
            $res['ret'] = 0;
            $res['msg'] = "优惠码无效";
            return $response->getBody()->write(json_encode($res));
        }

        if ($coupon->order($shop->id) == false) {
            $res['ret'] = 0;
            $res['msg'] = "此优惠码不可用于此商品";
            return $response->getBody()->write(json_encode($res));
        }

        $use_limit = $coupon->onetime;
        if ($use_limit > 0) {
            $user = $this->user;
            $use_count = Bought::where("userid", $user->id)->where("coupon", $coupon->code)->count();
            if ($use_count >= $use_limit) {
                $res['ret'] = 0;
                $res['msg'] = "优惠码次数已用完";
                return $response->getBody()->write(json_encode($res));
            }
        }

        $res['ret'] = 1;
        $res['name'] = $shop->name;
        $res['credit'] = $coupon->credit . " %";
        $res['total'] = $shop->price * ((100 - $coupon->credit) / 100) . "元";

        //song 教育优惠
        $edu_user == true && $res['credit'] = $coupon->credit . " % + 50%学生优惠" ;
        $edu_user == true && $res['total'] = $shop->price * ((100 - $coupon->credit) / 200)  . "元";

        return $response->getBody()->write(json_encode($res));
    }

    public function buy($request, $response, $args)
    {
        $coupon = $request->getParam('coupon');
        $coupon = trim($coupon);
        $code = $coupon;
        $shop = $request->getParam('shop');
        $disableothers = $request->getParam('disableothers');
        $autorenew = $request->getParam('autorenew');

        $shop = Shop::where("id", $shop)->where("status", 1)->first();

        if ($shop == null) {
            $res['ret'] = 0;
            $res['msg'] = "非法请求";
            return $response->getBody()->write(json_encode($res));
        }

        if ($coupon == "") {
            $credit = 0;
        } else {
            $coupon = Coupon::where("code", $coupon)->orderBy("id",DESC)->first();

            if ($coupon == null) {
                $credit = 0;
            } else {
                if ($coupon->onetime == 1) {
                    $onetime = true;
                }

                $credit = $coupon->credit;
            }

            if ($coupon->order($shop->id) == false) {
                $res['ret'] = 0;
                $res['msg'] = "此优惠码不可用于此商品";
                return $response->getBody()->write(json_encode($res));
            }

            if ($coupon->expire < time()) {
                $res['ret'] = 0;
                $res['msg'] = "此优惠码已过期";
                return $response->getBody()->write(json_encode($res));
            }
        }

        $price = $shop->price * ((100 - $credit) / 100);
        $user = $this->user;

/*        // 这里进行判定，如果用户充值金额 < 套餐*0.1 的话，说明用户充值的太少了，就限制一下
        if ($shop->price > 1) {
            $codes=Code::where('userid',$user->id)->get();
            $user_charge =0;
            foreach($codes as $code){
                $user_charge+=$code->number;
            }
            if ($user_charge < $shop->price * 0.2) {
                $user->ban_times += 3;
                $user->save();
                $res['ret'] = 0;
                $res['msg'] = "亲，累计充值满 ".ceil($shop->price * 0.2 )." ￥就能购买本套餐了";
                return $response->getBody()->write(json_encode($res));
            }
        }*/

        //song 这里价格进行优惠
        //if (in_array($usernameSuffix[1], $eduSupport)) {
        if (strrchr($user->email, 'edu.cn') == 'edu.cn') {
            $price = $price / 2 ;
        }


        if (bccomp($user->money , $price,2)==-1) {
            $res['ret'] = 0;
            $res['msg'] = '喵喵喵~ 当前余额不足，总价为' . $price . '元。</br><a href="/user/code">点击进入充值界面</a>';
            return $response->getBody()->write(json_encode($res));
        }


        if ( strtotime($user->class_expire) < time() ) {
            # 判断一下用户是否过期，如果过期，就设置为0，但是不保存 . 这样不影响到期的用户购买套餐。
            $user->class = 0;
        }

        //# 只允许购买 套餐等级 >= 用户等级的商品   这样就可以实现用户购买的套餐可以叠加了。只能向上叠加。
        ##这里需要先 json_decode一下 商品中的 content内容
        //$shop_content = $content = json_decode($shop->content, true);
        if ( $shop->user_class() <= $user->class) {
            # code...
            $res['ret'] = 0;
            $res['msg'] = "您是尊贵的VIP ".$user->class." ，推荐您购买VIP ".$user->class." 以上套餐。当前套餐等级为VIP ".$shop->user_class()." <您的VIP等级。";
            return $response->getBody()->write(json_encode($res));
        }

        $user->money =bcsub($user->money , $price,2);
        $user->save();

        if ($disableothers == 1) {
            $boughts = Bought::where("userid", $user->id)->get();
            foreach ($boughts as $disable_bought) {
                $disable_bought->renew = 0;
                $disable_bought->save();
            }
        }

        $bought = new Bought();
        $bought->userid = $user->id;
        $bought->shopid = $shop->id;
        $bought->datetime = time();
        if ($autorenew == 0 || $shop->auto_renew == 0) {
            $bought->renew = 0;
        } else {
            $bought->renew = time() + $shop->auto_renew * 86400;
        }

        $bought->coupon = $code;


        /* if (isset($onetime)) {
            $price = $shop->price;
        } */
        $bought->price = $price;
        $bought->save();

        $shop->buy($user);

        $res['ret'] = 1;
        $res['msg'] = "购买成功";

        return $response->getBody()->write(json_encode($res));
    }

    public function bought($request, $response, $args)
    {
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $shops = Bought::where("userid", $this->user->id)->orderBy("id", "desc")->paginate(15, ['*'], 'page', $pageNum);
        $shops->setPath('/user/bought');
        $user = Auth::getUser();

        $boughts = Bought::where("userid", $user->id)->orderBy("id", "desc")->get();
        $rebought['class'] = 0; // 等级
        $rebought['bandwidth'] = 0; //流量
        $rebought['speedlimit'] = 0; //限速
        $rebought['connector'] = 0; //设备数
        if (!empty($boughts)) {
            foreach ($boughts as $bought) {
                $shop = Shop::where("id",$bought->shopid)->first();
                if ( ($bought->datetime + $shop->class_expire()*24*3600) > time() ) {  //套餐未过期的话 矫正等级
                    $rebought['class'] < $shop->user_class() && $rebought['class'] = $shop->user_class(); // 等级
                }
                $rebought['bandwidth'] += $shop->bandwidth() ;  // 流量叠加
                $rebought['speedlimit'] < $shop->speedlimit() && $rebought['speedlimit'] = $shop->speedlimit() ; //限速取最大值
                $rebought['connector'] < $shop->connector() && $rebought['connector'] = $shop->connector() ;  // 连接数取最大值
            }
        }
        $rebought['class'] < $user->class && $rebought['class'] = $user->class;
        $rebought['bandwidth'] = $rebought['bandwidth'] * 1024 * 1024 * 1024;
        $rebought['bandwidth'] < $user->transfer_enable && $rebought['bandwidth'] = $user->transfer_enable;
        $rebought['speedlimit'] < $user->node_speedlimit && $rebought['speedlimit'] = $user->node_speedlimit;
        $rebought['connector'] < $user->node_connector && $rebought['connector'] = $user->node_connector;

        return $this->view()->assign('shops', $shops)->assign('user', $user)->assign('rebought', $rebought)->display('user/bought.tpl');
    }

    public function deleteBoughtGet($request, $response, $args)
    {
        $id = $request->getParam('id');
        $shop = Bought::where("id", $id)->where("userid", $this->user->id)->first();

        if ($shop == null) {
            $rs['ret'] = 0;
            $rs['msg'] = "关闭自动续费失败，订单不存在。";
            return $response->getBody()->write(json_encode($rs));
        }

        if ($this->user->id == $shop->userid) {
            $shop->renew = 0;
        }

        if (!$shop->save()) {
            $rs['ret'] = 0;
            $rs['msg'] = "关闭自动续费失败";
            return $response->getBody()->write(json_encode($rs));
        }
        $rs['ret'] = 1;
        $rs['msg'] = "关闭自动续费成功";
        return $response->getBody()->write(json_encode($rs));
    }

    public function ticket($request, $response, $args)
    {
        if (Config::get('enable_ticket') != 'true') {
            exit(0);
        }
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $tickets = Ticket::where("userid", $this->user->id)->where("rootid", 0)->orderBy("datetime", "desc")->paginate(5, ['*'], 'page', $pageNum);
        $tickets->setPath('/user/ticket');

        $opentickets = Ticket::where("status", 3)->where("rootid", 0)->orderBy("datetime", "desc")->paginate(15, ['*'], 'page', $pageNum);
        $opentickets->setPath('/user/ticket');

        return $this->view()->assign('tickets', $tickets)->assign('opentickets', $opentickets)->display('user/ticket.tpl');
    }

    public function ticket_create($request, $response, $args)
    {
        return $this->view()->display('user/ticket_create.tpl');
    }

    public function ticket_add($request, $response, $args)
    {
        $title = $request->getParam('title');
        $content = $request->getParam('content');

        $user = $this->user;

        if ($title == "" || $content == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $this->echoJson($response, $res);
        }

        if (strpos($content, "admin") != false || strpos($content, "user") != false) {
            $res['ret'] = 0;
            $res['msg'] = "请求中有不当词语";
            return $this->echoJson($response, $res);
        }

        if ($user->class < 1) {
            $res['ret'] = 0;
            $res['msg'] = "等级 < 1，无法提交工单";
            return $this->echoJson($response, $res);
        }

        if ($user->money < 1) {
            $res['ret'] = 0;
            $res['msg'] = "余额 < 1 无法提交工单";
            return $this->echoJson($response, $res);
        }

        $ticket = new Ticket();

        $antiXss = new AntiXSS();

        $ticket->title = $antiXss->xss_clean($title);
        $ticket->content = $antiXss->xss_clean($content);
        $ticket->rootid = 0;
        $ticket->userid = $this->user->id;
        $ticket->datetime = time();
        $ticket->sort += $this->user->class;
        $ticket->save();

        // 每个新工单扣除0.7元余额
        $user->money -= 0.7;
        $user->save();
        //新工单不再邮件提醒
/**
        $adminUser = User::where("is_admin", "=", "1")->get();
        foreach ($adminUser as $user) {
            $subject = Config::get('appName') . "-新工单被开启";
            $to = $user->email;
            $text = "管理员，有人开启了新的工单，请您及时处理。";
            try {
                Mail::send($to, $subject, 'news/warn.tpl', [
                    "user" => $user, "text" => $text
                ], [
                ]);
            } catch (\Exception $e) {
                echo $e->getMessage();
            }
        }
**/
        $res['ret'] = 1;
        $res['msg'] = "提交成功";
        return $this->echoJson($response, $res);
    }

    public function ticket_update($request, $response, $args)
    {
        $id = $args['id'];
        $content = $request->getParam('content');
        $status = $request->getParam('status');

        $user = $this->user;

        if ($content == "" || $status == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $this->echoJson($response, $res);
        }

        if (strpos($content, "admin") != false || strpos($content, "user") != false) {
            $res['ret'] = 0;
            $res['msg'] = "请求中有不当词语";
            return $this->echoJson($response, $res);
        }

        if ($user->class < 1) {
            $res['ret'] = 0;
            $res['msg'] = "等级 < 1，无法提交工单";
            return $this->echoJson($response, $res);
        }

        if ($user->money < 0.1) {
            $res['ret'] = 0;
            $res['msg'] = "余额 < 0.1 无法提交工单";
            return $this->echoJson($response, $res);
        }

        $ticket_main = Ticket::where("id", "=", $id)->where("rootid", "=", 0)->first();
        if ($ticket_main->userid != $this->user->id) {
            $newResponse = $response->withStatus(302)->withHeader('Location', '/user/ticket');
            return $newResponse;
        }
/**
        if ($status == 1 && $ticket_main->status != $status) {
            $adminUser = User::where("is_admin", "=", "1")->get();
            foreach ($adminUser as $user) {
                $subject = $ticket_main->id . "-重新开启";
                $to = $user->email;
                $text = "管理员，有人重新开启了<a href=\"" . Config::get('baseUrl') . "/admin/ticket/" . $ticket_main->id . "/view\">工单</a>，请您及时处理。";
                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user, "text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
            }
        } elseif($status == 1) {
            $adminUser = User::where("is_admin", "=", "1")->get();
            foreach ($adminUser as $user) {
                $subject = $ticket_main->id . "-回复";
                $to = $user->email;
                $text = "管理员，有人回复了<a href=\"" . Config::get('baseUrl') . "/admin/ticket/" . $ticket_main->id . "/view\">工单</a>，请您及时处理。";
                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user, "text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
            }
        }

        //Song 工单只有回复没有其他
        if ($status == 1) {
            $adminUser = User::where("is_admin", "=", "1")->get();
            foreach ($adminUser as $user) {
                $subject = $ticket_main->id . "-回复";
                $to = $user->email;
                $text = "管理员，有人回复了<a href=\"" . Config::get('baseUrl') . "/admin/ticket/" . $ticket_main->id . "/view\">工单</a>，请您及时处理。";
                try {
                    Mail::send($to, $subject, 'news/warn.tpl', [
                        "user" => $user, "text" => $text
                    ], [
                    ]);
                } catch (\Exception $e) {
                    echo $e->getMessage();
                }
            }
        }
**/
        $antiXss = new AntiXSS();

        $ticket = new Ticket();
        $ticket->title = $antiXss->xss_clean($ticket_main->title);
        $ticket->content = $antiXss->xss_clean($content);
        $ticket->rootid = $ticket_main->id;
        $ticket->userid = $this->user->id;
        $ticket->sort = 0;
        $ticket->datetime = time();
        $ticket_main->status = $status;
        $ticket_main->sort += $this->user->class;
        //$ticket_main->sort = 0;
        // 这里可能用户会直接关闭工单，这里就不再显示用户工单了，没必要我再关闭一次。当然，也是可以我再关闭一次的
        //$status != 0 && $ticket_main->sort += $this->user->class;

        $ticket_main->save();
        $ticket->save();

        // 如果工单状态 != 0 就会扣除 0.2 余额
        $status != 0 && $user->money -= 0.2;
        $user->save();


        $res['ret'] = 1;
        $res['msg'] = "提交成功";
        return $this->echoJson($response, $res);
    }

    public function ticket_view($request, $response, $args)
    {
        $id = $args['id'];
        $ticket_main = Ticket::where("id", "=", $id)->where("rootid", "=", 0)->first();
        if ($ticket_main->userid != $this->user->id) {
            $newResponse = $response->withStatus(302)->withHeader('Location', '/user/ticket');
            return $newResponse;
        }

        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }


        $ticketset = Ticket::where("id", $id)->orWhere("rootid", "=", $id)->orderBy("datetime", "desc")->paginate(15, ['*'], 'page', $pageNum);
        $ticketset->setPath('/user/ticket/' . $id . "/view");


        return $this->view()->assign('ticketset', $ticketset)->assign("id", $id)->display('user/ticket_view.tpl');
    }

    public function ticket_openview($request, $response, $args)
    {
        $id = $args['id'];
        $ticket_main = Ticket::where("id", "=", $id)->where('status',3)->where("rootid", "=", 0)->first();

        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }


        $ticketset = Ticket::where("id", $id)->orWhere("rootid", "=", $id)->orderBy("datetime", "asc")->paginate(15, ['*'], 'page', $pageNum);
        $ticketset->setPath('/user/ticket/' . $id . "/openview");


        return $this->view()->assign('ticketset', $ticketset)->assign("id", $id)->display('user/ticket_openview.tpl');
    }


    public function updateWechat($request, $response, $args)
    {
        $type = $request->getParam('imtype');
        $wechat = $request->getParam('wechat');
        $wechat = trim($wechat);

        $user = $this->user;

        if ($user->telegram_id != 0) {
            $res['ret'] = 0;
            $res['msg'] = "您绑定了 Telegram ，所以此项并不能被修改。";
            return $response->getBody()->write(json_encode($res));
        }

        if ($wechat == "" || $type == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }

        $user1 = User::where('im_value', $wechat)->where('im_type', $type)->first();
        if ($user1 != null) {
            $res['ret'] = 0;
            $res['msg'] = "此联络方式已经被注册";
            return $response->getBody()->write(json_encode($res));
        }

        $user->im_type = $type;
        $antiXss = new AntiXSS();
        $user->im_value = $antiXss->xss_clean($wechat);
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "修改成功";
        return $this->echoJson($response, $res);
    }


    public function updateSSR($request, $response, $args)
    {
        $protocol = $request->getParam('protocol');
        $obfs = $request->getParam('obfs');
        $obfs_param = $request->getParam('obfs_param');
        $obfs_param = trim($obfs_param);

        $user = $this->user;

        if ($obfs == "" || $protocol == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }

        if (!Tools::is_param_validate('obfs', $obfs)) {
            $res['ret'] = 0;
            $res['msg'] = "混淆无效";
            return $response->getBody()->write(json_encode($res));
        }

        if (!Tools::is_param_validate('protocol', $protocol)) {
            $res['ret'] = 0;
            $res['msg'] = "协议无效";
            return $response->getBody()->write(json_encode($res));
        }

        $antiXss = new AntiXSS();

        $user->protocol = $antiXss->xss_clean($protocol);
        $user->obfs = $antiXss->xss_clean($obfs);
        $user->obfs_param = $antiXss->xss_clean($obfs_param);

        if (!Tools::checkNoneProtocol($user)) {
            $res['ret'] = 0;
            $res['msg'] = "系统检测到您目前的加密方式为 none ，但您将要设置为的协议并不在以下协议<br>" . implode(',', Config::getSupportParam('allow_none_protocol')) . '<br>之内，请您先修改您的加密方式，再来修改此处设置。';
            return $this->echoJson($response, $res);
        }

        if (!URL::SSCanConnect($user) && !URL::SSRCanConnect($user)) {
            $res['ret'] = 0;
            $res['msg'] = "您这样设置之后，就没有客户端能连接上了，所以系统拒绝了您的设置，请您检查您的设置之后再进行操作。";
            return $this->echoJson($response, $res);
        }

        $user->save();

        if (!URL::SSCanConnect($user)) {
            $res['ret'] = 1;
            $res['msg'] = "设置成功，但您目前的协议，混淆，加密方式设置会导致 Shadowsocks原版客户端无法连接，请您自行更换到 ShadowsocksR 客户端。";
            return $this->echoJson($response, $res);
        }

        if (!URL::SSRCanConnect($user)) {
            $res['ret'] = 1;
            $res['msg'] = "设置成功，但您目前的协议，混淆，加密方式设置会导致 ShadowsocksR 客户端无法连接，请您自行更换到 Shadowsocks 客户端。";
            return $this->echoJson($response, $res);
        }

        $res['ret'] = 1;
        $res['msg'] = "设置成功，您可自由选用客户端来连接。";
        return $this->echoJson($response, $res);
    }

    public function updateTheme($request, $response, $args)
    {
        $theme = $request->getParam('theme');

        $user = $this->user;

        if ($theme == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }


        $user->theme = filter_var($theme, FILTER_SANITIZE_STRING);
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "设置成功";
        return $this->echoJson($response, $res);
    }

    public function updateGroup($request, $response, $args)
    {
        $group = $request->getParam('group');

        $user = $this->user;

        if ($group == "" || $group > 3) {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }

        $user->node_group = $group;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "设置成功";
        return $this->echoJson($response, $res);
    }


    public function updateMail($request, $response, $args)
    {
        $mail = $request->getParam('mail');
        $mail = trim($mail);
        $user = $this->user;

        if (!($mail == "1" || $mail == "0")) {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }


        $user->sendDailyMail = $mail;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "修改成功";
        return $this->echoJson($response, $res);
    }

    public function PacSet($request, $response, $args)
    {
        $pac = $request->getParam('pac');

        $user = $this->user;

        if ($pac == "") {
            $res['ret'] = 0;
            $res['msg'] = "输入不能为空";
            return $response->getBody()->write(json_encode($res));
        }


        $user->pac = $pac;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "修改成功";
        return $this->echoJson($response, $res);
    }


    public function updateSsPwd($request, $response, $args)
    {
        $user = Auth::getUser();
        $pwd = $request->getParam('sspwd');
        $pwd = trim($pwd);

        if ($pwd == "") {
            $res['ret'] = 0;
            $res['msg'] = "密码不能为空";
            return $response->getBody()->write(json_encode($res));
        }

        // if (strlen($pwd) > 15) {
        //   $res['ret'] = 0;
        //   $res['msg'] = "长度不能超过15位";
        //   return $response->getBody()->write(json_encode($res));
        // }

        if (!Tools::is_validate($pwd)) {
            $res['ret'] = 0;
            $res['msg'] = "密码无效";
            return $response->getBody()->write(json_encode($res));
        }
        //限制字符串长度,最高16位,限制15位
        $pwd = substr($pwd,0,15);
        $user->updateSsPwd($pwd);
        $res['ret'] = 1;
        Radius::Add($user, $pwd);
        return $this->echoJson($response, $res);
    }

    public function updateSubLimit($request, $response, $args)
    {
        $user = Auth::getUser();
        $sub_limit = $request->getParam('sub_limit');

        if ($sub_limit > ($user->class * 8 + 8)) {
            $res['ret'] = 0;
            $res['msg'] = "等级不够";
            return $response->getBody()->write(json_encode($res));
        }elseif ($sub_limit < 4) {
            $res['ret'] = 0;
            $res['msg'] = "节点获取设置这么少，会获取不到节点的呦";
            return $response->getBody()->write(json_encode($res));
        }else{
            $user->sub_limit = $sub_limit;
            $user->save();
            $res['ret'] = 1;
            return $this->echoJson($response, $res);
        }

    }

    public function updateMethod($request, $response, $args)
    {
        $user = Auth::getUser();
        $method = $request->getParam('method');
        $method = strtolower($method);

        if ($method == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }

        if (!Tools::is_param_validate('method', $method)) {
            $res['ret'] = 0;
            $res['msg'] = "加密无效";
            return $response->getBody()->write(json_encode($res));
        }

        $user->method = $method;

        if (!Tools::checkNoneProtocol($user)) {
            $res['ret'] = 0;
            $res['msg'] = "系统检测到您将要设置的加密方式为 none ，但您的协议并不在以下协议<br>" . implode(',', Config::getSupportParam('allow_none_protocol')) . '<br>之内，请您先修改您的协议，再来修改此处设置。';
            return $this->echoJson($response, $res);
        }

        if (!URL::SSCanConnect($user) && !URL::SSRCanConnect($user)) {
            $res['ret'] = 0;
            $res['msg'] = "您这样设置之后，就没有客户端能连接上了，所以系统拒绝了您的设置，请您检查您的设置之后再进行操作。";
            return $this->echoJson($response, $res);
        }

        $user->updateMethod($method);

        if (!URL::SSCanConnect($user)) {
            $res['ret'] = 0;
            $res['msg'] = "设置成功，但您目前的协议，混淆，加密方式设置会导致 Shadowsocks原版客户端无法连接，请您自行更换到 ShadowsocksR 客户端。";
            return $this->echoJson($response, $res);
        }

        if (!URL::SSRCanConnect($user)) {
            $res['ret'] = 1;
            $res['msg'] = "设置成功，但您目前的协议，混淆，加密方式设置会导致 ShadowsocksR 客户端无法连接，请您自行更换到 Shadowsocks 客户端。";
            return $this->echoJson($response, $res);
        }

        $res['ret'] = 1;
        $res['msg'] = "设置成功，您可自由选用两种客户端来进行连接。";
        return $this->echoJson($response, $res);
    }


    public function updateCncdn($request, $response, $args)
    {
        $user = Auth::getUser();
        $cncdn = $request->getParam('cncdn');
        $cncdn = strtolower($cncdn);
/*
        if ($cncdn == "") {
            $res['ret'] = 0;
            $res['msg'] = "非法输入";
            return $response->getBody()->write(json_encode($res));
        }*/

        $user->cncdn = $cncdn;
        // 在更换的时候，自动把这个数据重置为 0 ；
        $user->cncdn_count = 0;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "设置成功，请客户端更新节点。";
        return $this->echoJson($response, $res);
    }


    public function updateCfcdn($request, $response, $args)
    {
        $user = Auth::getUser();
        $cfcdn = $request->getParam('cfcdn');
        $cfcdn = trim($cfcdn);

        if (filter_var($cfcdn, FILTER_VALIDATE_IP)) {
            $user->cfcdn = $cfcdn;
        }else{
            $user->cfcdn = '';
        }
        // 在更换的时候，自动把这个数据重置为 0 ；
        $user->cfcdn_count = 0;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "直连优化IP ".$user->cfcdn." 设置成功，请客户端更新节点。";
        return $this->echoJson($response, $res);
    }


    public function logout($request, $response, $args)
    {
        Auth::logout();
        $newResponse = $response->withStatus(302)->withHeader('Location', '/');
        return $newResponse;
    }

    public function doCheckIn($request, $response, $args)
    {
        if (Config::get('enable_checkin_captcha') == 'true') {
            switch(Config::get('captcha_provider'))
            {
                case 'recaptcha':
                    $recaptcha = $request->getParam('recaptcha');
                    if ($recaptcha == ''){
                        $ret = false;
                    }else{
                        $json = file_get_contents("https://recaptcha.net/recaptcha/api/siteverify?secret=".Config::get('recaptcha_secret')."&response=".$recaptcha);
                        $ret = json_decode($json)->success;
                    }
                    break;
                case 'geetest':
                    $ret = Geetest::verify($request->getParam('geetest_challenge'), $request->getParam('geetest_validate'), $request->getParam('geetest_seccode'));
                    break;
            }
            if (!$ret) {
                $res['ret'] = 0;
                $res['msg'] = "系统无法接受您的验证结果，请刷新页面后重试。";
                return $response->getBody()->write(json_encode($res));
            }
        }

		if(strtotime($this->user->expire_in) < time()){
            $res['ret'] = 0;
		    $res['msg'] = "您的账户已过期，无法签到。";
            return $response->getBody()->write(json_encode($res));
		}

        if (!$this->user->isAbleToCheckin()) {
            $res['ret'] = 0;
            $res['msg'] = "您似乎已经签到过了...";
            return $response->getBody()->write(json_encode($res));
        }
        $traffic = rand(Config::get('checkinMin'), Config::get('checkinMax'));
        $this->user->transfer_enable = $this->user->transfer_enable + Tools::toMB($traffic);
        $this->user->last_check_in_time = time();
        $this->user->save();
        $res['msg'] = sprintf("获得了 %d MB流量.", $traffic);
        $res['unflowtraffic'] = $this->user->transfer_enable;
        $res['traffic'] = Tools::flowAutoShow($this->user->transfer_enable);
        $res['trafficInfo'] = array(
            "todayUsedTraffic" => $this->user->TodayusedTraffic(),
            "lastUsedTraffic" => $this->user->LastusedTraffic(),
            "unUsedTraffic" => $this->user->unusedTraffic(),
        );
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function kill($request, $response, $args)
    {
        return $this->view()->display('user/kill.tpl');
    }

    public function handleKill($request, $response, $args)
    {
        $user = Auth::getUser();

        $email = $user->email;

        $passwd = $request->getParam('passwd');
        // check passwd
        $res = array();
        if (!Hash::checkPassword($user->pass, $passwd)) {
            $res['ret'] = 0;
            $res['msg'] = " 密码错误";
            return $this->echoJson($response, $res);
        }

        if (Config::get('enable_kill') == 'true') {
            Auth::logout();
            $user->kill_user();
            $res['ret'] = 1;
            $res['msg'] = "您的帐号已经从我们的系统中删除。欢迎下次光临!";
        }
		else {
            $res['ret'] = 0;
            $res['msg'] = "管理员不允许删除，如需删除请联系管理员。";
        }
        return $this->echoJson($response, $res);
    }

    public function trafficLog($request, $response, $args)
    {
        $traffic = TrafficLog::where('user_id', $this->user->id)->where("log_time", ">", (time() - 3 * 86400))->orderBy('id', 'desc')->get();
        return $this->view()->assign('logs', $traffic)->display('user/trafficlog.tpl');
    }


    public function detect_index($request, $response, $args)
    {
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $logs = DetectRule::paginate(15, ['*'], 'page', $pageNum);
        $logs->setPath('/user/detect');
        return $this->view()->assign('rules', $logs)->display('user/detect_index.tpl');
    }

    public function detect_log($request, $response, $args)
    {
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $logs = DetectLog::orderBy('id', 'desc')->where('user_id', $this->user->id)->paginate(15, ['*'], 'page', $pageNum);
        $logs->setPath('/user/detect/log');
        return $this->view()->assign('logs', $logs)->display('user/detect_log.tpl');
    }

    public function disable($request, $response, $args)
    {
        $user = $this->user;
        return $this->view()->assign('user', $user)->display('user/disable.tpl');
    }

    public function telegram_reset($request, $response, $args)
    {
        $user = $this->user;
        $user->telegram_id = 0;
        $user->save();
        $newResponse = $response->withStatus(302)->withHeader('Location', '/user/edit');
        return $newResponse;
    }

    public function resetURL($request, $response, $args)
    {
        $user = $this->user;
        $user->clean_link();
        $newResponse = $response->withStatus(302)->withHeader('Location', '/user');
        return $newResponse;
    }

    public function resetInviteURL($request, $response, $args)
    {
        $user = $this->user;
        $user->clear_inviteCodes();
        $newResponse = $response->withStatus(302)->withHeader('Location', '/user/invite');
        return $newResponse;
    }

    public function backtoadmin($request, $response, $args)
    {
        $userid = Utils\Cookie::get('uid');
        $adminid = Utils\Cookie::get('old_uid');
        $user = User::find($userid);
        $admin = User::find($adminid);

        if (!$admin->is_admin || !$user) {
            Utils\Cookie::set([
                "uid" => null,
                "email" => null,
                "key" => null,
                "ip" => null,
                "expire_in" => null,
                "old_uid" => null,
                "old_email" => null,
                "old_key" => null,
                "old_ip" => null,
                "old_expire_in" => null,
                "old_local" => null
            ], time() - 1000);
        }
        $expire_in = Utils\Cookie::get('old_expire_in');
        $local = Utils\Cookie::get('old_local');
        Utils\Cookie::set([
            "uid" => Utils\Cookie::get('old_uid'),
            "email" => Utils\Cookie::get('old_email'),
            "key" => Utils\Cookie::get('old_key'),
            "ip" => Utils\Cookie::get('old_expire_in'),
            "expire_in" => $expire_in,
            "old_uid" => null,
            "old_email" => null,
            "old_key" => null,
            "old_ip" => null,
            "old_expire_in" => null,
            "old_local" => null
        ], $expire_in);
        $newResponse = $response->withStatus(302)->withHeader('Location', $local);
        return $newResponse;
    }

    //song reset user relevel
    public function relevel($request, $response, $args)
    {

        // send email
        $user = Auth::getUser();

        $boughts = Bought::where("userid", $user->id)->orderBy("id", "desc")->get();
        $class = 0; // 等级
        $bandwidth = 0; //流量
        $speedlimit = 0; //限速
        $connector = 3; //设备数

        if (empty($boughts)) {
            $rs['ret'] = 0;
            $rs['msg'] = '似乎您没有购买套餐呢';
            return $response->getBody()->write(json_encode($rs));
        }

        foreach ($boughts as $bought) {
            $shop = Shop::where("id",$bought->shopid)->first();
            if ( ($bought->datetime + $shop->class_expire()*24*3600) > time() ) {  //套餐未过期的话 矫正等级
                $class < $shop->user_class() && $class = $shop->user_class(); // 等级
            }
            $bandwidth += $shop->bandwidth() ;  // 流量叠加
            $speedlimit < $shop->speedlimit() && $speedlimit = $shop->speedlimit() ; //限速取最大值
            $connector < $shop->connector() && $connector = $shop->connector() ;  // 连接数取最大值
        }

        $user->class < $class && $user->class = $class ;
        $user->transfer_enable < $bandwidth*1024*1024*1024 && $user->transfer_enable = $bandwidth*1024*1024*1024;
        $user->node_speedlimit < $speedlimit && $user->node_speedlimit = $speedlimit;
        $user->node_connector < $connector && $user->node_connector = $connector;

        $rs['ret'] = 1;
        $rs['msg'] = '套餐矫正成功';
        $user->save();

        return $response->getBody()->write(json_encode($rs));
    }

    //song reset user relevel
    public function uptopay($request, $response, $args)
    {
        // send email
        $user = Auth::getUser();
        if ($user == null) {
            $rs['ret'] = 0;
            $rs['msg'] = '此用户不存在';
            return $response->getBody()->write(json_encode($rs));
        }

        if ($user->class < 5) {
            $rs['ret'] = 0;
            $rs['msg'] = '您需要至少购买一个年付套餐';
            return $response->getBody()->write(json_encode($rs));
        }

        $codes=Code::where('userid',$user->id)->get();
        $user_charge =0;
        foreach($codes as $code){
            $user_charge+=$code->number;
        }

        if ($user_charge < 230) {
            # code...
            $user->enable = 0;
            $user->ban_times += 3;
            #$user->pass = time();
            $user->save();
            $rs['ret'] = 0;
            $rs['msg'] = '异常申请，账号保护！';
        }else{
            $user->class = 10;
            $rs['ret'] = 1;
            $rs['msg'] = '申请VIP10';
            $user->save();
        }

        return $response->getBody()->write(json_encode($rs));
    }

    //song reset user relevel
    public function uptocncdn($request, $response, $args)
    {

        // send email
        $user = Auth::getUser();
        if ($user == null) {
            $rs['ret'] = 0;
            $rs['msg'] = '此用户不存在.';
            return $response->getBody()->write(json_encode($rs));
        }

        if ($user->node_group > 2) {
            $rs['ret'] = 1;
            $rs['msg'] = '您已经成功申请了';
            return $response->getBody()->write(json_encode($rs));
        }

        if ($user->money < 0) {
            $rs['ret'] = 0;
            $rs['msg'] = '余额小于零';
            return $response->getBody()->write(json_encode($rs));
        }

        if($user->class == 10){
            $user->node_group = 3;
            $rs['ret'] = 1;
            $rs['msg'] = '尊贵的VIP10用户，申请成功，请在客户端更新节点';
            $user->save();
            return $response->getBody()->write(json_encode($rs));
        }

        $codes=Code::where('userid',$user->id)->get();
        $user_charge =0;
        foreach($codes as $code){
            $user_charge+=$code->number;
        }

        $setcncdn = false;
        if ($user->class == 9 && $user_charge > 76) {
            $setcncdn = true;
        }elseif ($user->class == 8 && $user_charge > 47) {
            $setcncdn = true;
        }elseif ($user->class == 7 && $user_charge > 29) {
            $setcncdn = true;
        }elseif ($user->class == 6 && $user_charge > 18) {
            $setcncdn = true;
        }elseif ($user->class == 5 && $user_charge > 11) {
            $setcncdn = true;
        }elseif ($user->class == 4 && $user_charge > 6) {
            $setcncdn = true;
        }elseif ($user->class == 3 && $user_charge > 1) {
            $setcncdn = true;
        }

        if ($setcncdn == true ) {
            $user->node_group = 3;
            $rs['ret'] = 1;
            $rs['msg'] = '申请中转加速节点成功,请在客户端更新节点';
            $user->save();
        }else{
            $user->enable = 0;
            $user->ban_times += $user->class;
            #$user->pass = time();
            $user->save();
            $rs['ret'] = 0;
            $rs['msg'] = '异常申请，账号保护！';
        }

        return $response->getBody()->write(json_encode($rs));
    }

}
