<?php

namespace App\Controllers;

use App\Models\InviteCode;
use App\Models\Node;
use App\Models\User;
use App\Models\NodeOnlineLog;  //写入用户在线人数嘎嘎
use App\Models\TrafficLog;  //用于写入节点流量日志
use App\Services\Factory;
use App\Services\Config;
use App\Utils\Tools;
use App\Utils\Hash;
use App\Utils\Helper;
use App\Models\Code; // 20220320

/**
 *  ApiController
 */

class ApiController extends BaseController
{
    public function index()
    {
    }

    public function token($request, $response, $args)
    {
        $accessToken = $id = $args['token'];
        $storage = Factory::createTokenStorage();
        $token = $storage->get($accessToken);
        if ($token==null) {
            $res['ret'] = 0;
            $res['msg'] = "token is null";
            return $this->echoJson($response, $res);
        }
        $res['ret'] = 1;
        $res['msg'] = "ok";
        $res['data'] = $token;
        return $this->echoJson($response, $res);
    }

    public function newToken($request, $response, $args)
    {
        // $data = $request->post('sdf');
        $email =  $request->getParam('email');

        $email = strtolower($email);
        $passwd = $request->getParam('passwd');

        // Handle Login
        $user = User::where('email', '=', $email)->first();

        if ($user == null) {
            $res['ret'] = 0;
            $res['msg'] = "401 邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }

        if (!Hash::checkPassword($user->pass, $passwd)) {
            $res['ret'] = 0;
            $res['msg'] = "402 邮箱或者密码错误";
            return $this->echoJson($response, $res);
        }
        $tokenStr = Tools::genToken();
        $storage = Factory::createTokenStorage();
        $expireTime = time() + 3600*24*7;
        if ($storage->store($tokenStr, $user, $expireTime)) {
            $res['ret'] = 1;
            $res['msg'] = "ok";
            $res['data']['token'] = $tokenStr;
            $res['data']['user_id'] = $user->id;
            return $this->echoJson($response, $res);
        }
        $res['ret'] = 0;
        $res['msg'] = "system error";
        return $this->echoJson($response, $res);
    }

    public function node($request, $response, $args)
    {
        $accessToken = Helper::getTokenFromReq($request);
        $storage = Factory::createTokenStorage();
        $token = $storage->get($accessToken);
        $user = User::find($token->userId);
        $nodes = Node::where('sort', 0)->where("type", "1")->where(
            function ($query) use ($user) {
                $query->where("node_group", "=", $user->node_group)
                    ->orWhere("node_group", "=", 0);
            }
        )->orderBy("name")->get();

        $mu_nodes = Node::where('sort', 9)->where('node_class', '<=', $user->class)->where("type", "1")->where(
            function ($query) use ($user) {
                $query->where("node_group", "=", $user->node_group)
                    ->orWhere("node_group", "=", 0);
            }
        )->orderBy("name")->get();

        $temparray=array();
        foreach ($nodes as $node) {
            if ($node->mu_only == 0) {
                array_push($temparray, array("remarks"=>$node->name,
                                            "server"=>$node->server,
                                            "server_port"=>$user->port,
                                            "method"=>($node->custom_method==1?$user->method:$node->method),
                                            "obfs"=>str_replace("_compatible", "", (($node->custom_rss==1&&!($user->obfs=='plain'&&$user->protocol=='origin'))?$user->obfs:"plain")),
                                            "obfsparam"=>(($node->custom_rss==1&&!($user->obfs=='plain'&&$user->protocol=='origin'))?$user->obfs_param:""),
                                            "remarks_base64"=>base64_encode($node->name),
                                            "password"=>$user->passwd,
                                            "tcp_over_udp"=>false,
                                            "udp_over_tcp"=>false,
                                            "group"=>Config::get('appName'),
                                            "protocol"=>str_replace("_compatible", "", (($node->custom_rss==1&&!($user->obfs=='plain'&&$user->protocol=='origin'))?$user->protocol:"origin")),
                                            "obfs_udp"=>false,
                                            "enable"=>true));
            }

            if ($node->custom_rss == 1) {
                foreach ($mu_nodes as $mu_node) {
                    $mu_user = User::where('port', '=', $mu_node->server)->first();
                    $mu_user->obfs_param = $user->getMuMd5();

                    array_push($temparray, array("remarks"=>$node->name."- ".$mu_node->server." 单端口",
                                        "server"=>$node->server,
                                        "server_port"=>$mu_user->port,
                                        "method"=>$mu_user->method,
                                        "group"=>Config::get('appName'),
                                        "obfs"=>str_replace("_compatible", "", (($node->custom_rss==1&&!($mu_user->obfs=='plain'&&$mu_user->protocol=='origin'))?$mu_user->obfs:"plain")),
                                        "obfsparam"=>(($node->custom_rss==1&&!($mu_user->obfs=='plain'&&$mu_user->protocol=='origin'))?$mu_user->obfs_param:""),
                                        "remarks_base64"=>base64_encode($node->name."- ".$mu_node->server." 单端口"),
                                        "password"=>$mu_user->passwd,
                                        "tcp_over_udp"=>false,
                                        "udp_over_tcp"=>false,
                                        "protocol"=>str_replace("_compatible", "", (($node->custom_rss==1&&!($mu_user->obfs=='plain'&&$mu_user->protocol=='origin'))?$mu_user->protocol:"origin")),
                                        "obfs_udp"=>false,
                                        "enable"=>true));
                }
            }
        }

        $res['ret'] = 1;
        $res['msg'] = "ok";
        $res['data'] = $temparray;
        return $this->echoJson($response, $res);
    }

    public function userInfo($request, $response, $args)
    {
        $id = $args['id'];
        $accessToken = Helper::getTokenFromReq($request);
        $storage = Factory::createTokenStorage();
        $token = $storage->get($accessToken);
        if ($id != $token->userId) {
            $res['ret'] = 0;
            $res['msg'] = "access denied";
            return $this->echoJson($response, $res);
        }
        $user = User::find($token->userId);
        $user->pass = null;
        $data = $user;
        $res['ret'] = 1;
        $res['msg'] = "ok";
        $res['data'] = $data;
        return $this->echoJson($response, $res);
    }

    public function ssn_sub($request, $response, $args)
    {
        $request->getParam('token') != Config::get('muKey') && exit;    // 判断 token是否正确
        $id = $args['id'];
        $id < 10 && exit;

        $status = $request->getParam('status');
        $daily = $request->getParam('daily');
        $health = $request->getParam('health');
        $traffic = $request->getParam('traffic');
        $online = $request->getParam('online');
        $ip = $_SERVER["REMOTE_ADDR"];   //记录请求ip
        
        //写入节点数据 状态 流量
        $node = Node::find($id);
        $node->node_heartbeat = time();     //节点心跳包
        if ( strpos($node->node_ip , $ip) === false ) {        // 对ip进行检测。这个有点意思。 或许可以考虑直接从 请求ip中获取到 这个ip也是不错的方法。
            $node->info .= '_' .$ip;
            $node->node_sort -= 100;
            // $node->save();
            // exit;
        }
        $traffic_mark = $node->node_bandwidth; //获取节点当前流量
        $status == 0 && $node->type = 0;
        $status == 1 && $node->type = 1;
        $node->node_oncost = $daily;
        $health == 0 && $node->custom_rss = 0;            // 流量健康程度。如果流量不健康，就取消用户订阅，但是已订阅用户还能用。
        $health == 1 && $node->custom_rss = 1;            // 流量健康程度。如果流量不健康，就取消用户订阅，但是已订阅用户还能用。
        $node->node_bandwidth = $traffic;
        $node->node_online = $online;
        
        $node->save();

        //写入流量使用记录
        $traffic_log = new TrafficLog();
        $traffic_now = $traffic - $traffic_mark;    //两次流量差值
        $traffic_now < 0 && $traffic_now = 1;   //如果流量差小于0 说明是流量重置了
        $traffic_log->user_id = 0; //用于判断是否是节点上传的流量 用户是 0
        $traffic_log->u = 0;    //节点rx流量为0
        $traffic_log->d = $traffic_now; // 记录到节点流量
        $traffic_log->node_id = $id; //节点ID
        $traffic_log->rate = 0; //默认倍率为1
        $traffic_log->traffic = $traffic; //记录当前的流量值
        $traffic_log->log_time = time();
        $traffic_log->save();

        //写入节点在线人数
        $online_log = new NodeOnlineLog();
        $online_log->node_id = $id;
        $online_log->online_user = $online;
        $online_log->log_time = time();
        $online_log->save();
    }

    public function ssn_v2($request, $response, $args)
    {   
        $request->getParam('token') != Config::get('muKey') && exit;    // 判断 token是否正确
        $id = $args['id'];
        $id < 10 && exit;  //1-9为保留ID。 通知节点为 group0 
        $node = Node::find($id);
        // node_info 有数据才更改
        $request->getParam('node_name') && $node->name = $request->getParam('node_name');
        $request->getParam('node_desc') && $node->info = $request->getParam('node_desc');
        $request->getParam('node_level') && $node->node_class = $request->getParam('node_level');
        $request->getParam('node_group') && $node->node_group = $request->getParam('node_group');
        $request->getParam('node_cost') != '' && $node->node_cost = $request->getParam('node_cost');
        $request->getParam('node_traffic_limit') && $node->node_bandwidth_limit = $request->getParam('node_traffic_limit')*1024*1024*1024;
        $request->getParam('node_traffic_resetday') && $node->bandwidthlimit_resetday = $request->getParam('node_traffic_resetday');
        $request->getParam('node_sort') != '' && $node->node_sort = $request->getParam('node_sort');  //排序
        // $request->getParam('sort') == 'v2' && $node->sort = 11;
        // $request->getParam('sort') == 'cf' && $node->sort = 12;  // 这俩就不再用了，很容易搞错。
        // node->node_ip  和v2ray无关，但是和服务器相关的信息
        if ( $request->getParam('node_ip') || $request->getParam('node_ipv6') ) {
            $node->node_ip = 'ip=' . $request->getParam('node_ip');
            $node->node_ip .= '&ipv6=' . $request->getParam('node_ipv6');
        }
        // protocol v2ray config 要更改，全部更改。 node->server段
        if ( $request->getParam('v2') ) {
            $request->getParam('v2') == 'ss' && $node->sort = 0;  // 这里0代表SS
            $request->getParam('v2') == 'vmess' && $node->sort = 11; 
            $request->getParam('v2') == 'vless' && $node->sort = 13;
            $request->getParam('v2') == 'trojan' && $node->sort = 14;
            $node->server = 'v2='.$request->getParam('v2');
            $node->server .= '&add='.$request->getParam('v2_add');
            $node->server .= '&port='.$request->getParam('v2_port');
            $node->server .= '&aid='.$request->getParam('v2_aid');
            $node->server .= '&scy='.$request->getParam('v2_scy');
            $node->server .= '&net='.$request->getParam('v2_net');
            $node->server .= '&type='.$request->getParam('v2_type');
            $node->server .= '&host='.$request->getParam('v2_host');
            $node->server .= '&path='.$request->getParam('v2_path');
            $node->server .= '&tls='.$request->getParam('v2_tls');
            $node->server .= '&sni='.$request->getParam('v2_sni');
            $node->server .= '&alpn='.$request->getParam('v2_alpn');
            $node->server .= '&ecpt='.$request->getParam('v2_ecpt');  //vless独有
            $node->server .= '&flow='.$request->getParam('v2_flow');  // xtls流控
            $node->server .= '&uuid='.$request->getParam('v2_uuid');  //独立节点标志
            $node->server .= '&cdn='.$request->getParam('v2_cdn');  //是否支持CDN？ 这个 最好是用 CDN标志
            //这里的许多参数，都值得商榷。目前来看，很明显这些参数，不适合用在
            //最好是保持参数的一致性，以及参数的可阅读性。 1 那个 v2的参数 为标准，其他的为新加的。
            // 一个小原则： 一律用简写。 因为作为参数 方便 或则不用简写，就用正常的标注方案？ 可是我觉得，正常的标注方案， 用的也是简写？ 
            // 一个基本原则：  节点配置用 v2_开头， node信息相关，用 node_开头。 方便区分。
            // 信息的话，最好是很容易区分的，最好如此。  节点名字name 信息info 状态 status ip ipv6 等级level 分组group 倍率rate 排序sort 
        }
        $node->node_heartbeat = time();     //节点心跳包
        $node->save();
    }

    public function clonepay($request, $response, $args){  // sdo 2022-03-18 clonepay 同步 sdo2022-04-13改名
        //验证是否开启 clonepay
        // if (Config::get('payment_system') != 'clonepay') {
        //     exit;
        // }
        // 验证 ip  
        $ip = $_SERVER["REMOTE_ADDR"]; // 获取请求ip
        if ($ip != Config::get('clonepay_safeip') && $ip != Config::get('clonepay_safeipv6')) {  // 获取到的请求ip，和ip，ipv6都不匹配的话，说明是非法ip，屏蔽掉。
            exit;
        }
        
        // 验证签名
        $signStr = $request->getParam('order').'&'.$request->getParam('money').'&'.Config::get('clonepay_apitoken');
        if (md5($signStr) != $request->getParam('sign')) {
            exit;
        }
        // 获取信息
        $email = $request->getParam('email');
        $order = $request->getParam('order');
        //获取 email，验证用户
        if (!$email) {
            exit;
        }
        $user = User::where('email', '=', $email)->first();
        if (!$user->id) {
            exit;
        }
        // 和 充值卡充值一样的原理，进行充值和返利。
        // 验证是否已经存在订单号了！ 如果已经存在了，就不再加money了。
        $code_id = 'cp-' . $order;  //加一个标识符号 可以有。但是其实也没啥必要 cpm clonepaymodown cpr clonepayripro
        $existcode = Code::where('code',$code_id)->first();
        if ($existcode->id) {
            echo '&error=订单已存在';
            exit;
        }
        // 记录着个订单号到 数据库，加上clone这个
        $codeq = New Code();
        $codeq->code = $code_id;
        $codeq->type = -1;
        $codeq->number = $request->getParam('money');
        $codeq->isused = 1;
        $codeq->userid = $user->id;
        $codeq->usedatetime=$request->getParam('time');
        $codeq->save();
        // 给用户加上余额。
        $user->money += $request->getParam('money');
        $user->save();
        // 判断用户的返利情况，给返利用户添加余额，记录返利信息。
        // stodo
    }
}
