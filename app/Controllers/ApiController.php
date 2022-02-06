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
        $id = $args['id'];
        $status = $request->getParam('status');
        $traffic = $request->getParam('traffic');
        $online = $request->getParam('online');
        $id < 9 && exit;
        //写入节点数据 状态 流量
        $node = Node::find($id);
        $traffic_mark = $node->node_bandwidth; //获取节点当前流量
        $node->type = $status;
        $node->node_bandwidth = $traffic;
        //
        //如果是正常节点 那么下面的就没必要了记录了
        $addn = explode('#', $node->node_ip);
        #如果第三个没有数据，说明是 正常添加的节点
        if ( empty($addn['2']) ) {
            $node_online_log = NodeOnlineLog::where('node_id', $id)->orderBy('id', 'desc')->first();
            if (!empty($node_online_log->online_user)) {
                $online = $node_online_log->online_user;
            }
        }
        //
        $node->node_online = $online;
        $node->node_oncost = round( ($online / $node->node_cost), 2);
        $node->save();
        //
        empty($addn['2']) && exit;
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
        // 这样这个API就写好了，非常棒，Very Good!
    }

    public function ssn_v2($request, $response, $args)
    {
        $id = $args['id'];
        $id < 10 && exit;  //ID 64以下是没有 V2节点的
        $node = Node::find($id);
        //写入节点数据 状态 流量
        !empty($request->getParam('name')) && $node->name = $request->getParam('name');
        !empty($request->getParam('server')) && $node->server = $request->getParam('server');
        !empty($request->getParam('node_ip')) && $node->node_ip = $request->getParam('node_ip');
        !empty($request->getParam('node_status')) && $node->status = $request->getParam('node_status');
        !empty($request->getParam('node_class')) && $node->node_class = $request->getParam('node_class');
        !empty($request->getParam('node_group')) && $node->node_group = $request->getParam('node_group');
        !empty($request->getParam('node_cost')) && $node->node_cost = $request->getParam('node_cost');
        // !empty($request->getParam('sort')) && $node->sort = $request->getParam('sort');
        $request->getParam('sort') == 'v2' && $node->sort = 11;
        $request->getParam('sort') == 'cf' && $node->sort = 12;
        !empty($request->getParam('node_bandwidth_limit')) && $node->node_bandwidth_limit = $request->getParam('node_bandwidth_limit')*1024*1024*1024;
        !empty($request->getParam('bandwidthlimit_resetday')) && $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');
        $request->getParam('node_sort') != '' && $node->node_sort = $request->getParam('node_sort');
        $node->save();
    }
}
