<?php

//Thanks to http://blog.csdn.net/jollyjumper/article/details/9823047

namespace App\Controllers;

use App\Models\Link;
use App\Models\User;
use App\Models\Node;
use App\Models\Smartline;
use App\Utils\ConfRender;
use App\Utils\Tools;
use App\Services\Config;
use App\Utils\URL;
use App\Models\Cncdn;   // 引入Cncdn自选

#song
use App\Utils\QQWry;

/**
 *  HomeController
 */
class LinkController extends BaseController
{
    public static function GenerateRandomLink()
    {
        for ($i = 0; $i < 10; $i++) {
            $token = Tools::genRandomChar(16);
            $Elink = Link::where('token', '=', $token)->first();
            if ($Elink == null) {
                return $token;
            }
        }

        return "couldn't alloc token";
    }

    public static function GenerateSSRSubCode($userid, $without_mu)
    {
        $Elink = Link::where('type', '=', 11)->where('userid', '=', $userid)->where('geo', $without_mu)->first();
        if ($Elink != null) {
            return $Elink->token;
        }
        $NLink = new Link();
        $NLink->type = 11;
        $NLink->address = '';
        $NLink->port = 0;
        $NLink->ios = 0;
        $NLink->geo = $without_mu;
        $NLink->method = '';
        $NLink->userid = $userid;
        $NLink->token = self::GenerateRandomLink();
        $NLink->save();

        return $NLink->token;
    }

    public static function GetContent($request, $response, $args)
    {
        $token = $args['token'];

        //$builder->getPhrase();
        $Elink = Link::where('token', '=', $token)->first();
        if ($Elink == null) {
            return null;
        }

        if ($Elink->type != 11) {
            return null;
        }

        $user = User::where('id', $Elink->userid)->first();
        if ($user == null) {
            return null;
        }

        if ($user->enable == 0) {       // 如果发现用户被禁用，那么订阅设置为 null 
            $url = 'ss://YWVzLTEyOC1nY206NjYwMWZiOTBlOWIz@127.0.0.1:80';      //添加用户到期信息
            $url .= '#'.urlencode($user->email.': 请登录并激活帐号:)');
            return base64_encode($url);
        }
        
        $user->cfcdn && $user->node_group == 1 && $user->cfcdn_count += 1;
        $user->rss_ip != $_SERVER["REMOTE_ADDR"] && $user->rss_ips_count += 1;        //对比IP
        $user->rss_ip = $_SERVER["REMOTE_ADDR"];
        $user->rss_count += 1;            // 记录IP
        $rss_today = $user->rss_count - $user->rss_count_lastday;       // 今日订阅次数
        $rss_ips_today = $user->rss_ips_count - $user->rss_ips_lastday;       // 今日订阅 IP来源数
        if ( $rss_ips_today > 32 && $rss_today % 3 == 0 ) {
            $user->enable = 0 ;// 禁用用户 
            $user->node_group = 1; //把用户放到1组去
            $user->warming = date("Ymd H:i:s").'今日IP来源>'.$rss_ips_today.'，太多IP在使用您的订阅，疑似泄露，今日剩余2次订阅机会，请单日IP来源<16个,请激活帐号，您封禁前订阅IP是：'.$user->rss_ip;
            $url = 'ss://YWVzLTEyOC1nY206NjYwMWZiOTBlOWIz@127.0.0.1:80';      //添加用户到期信息
            $url .= '#'.urlencode('今日订阅IPs>'.$rss_ips_today.'，今日封禁订阅，请登录帐号检查');
            $user->save();
            return base64_encode($url);
        } elseif ( $rss_today >= 64 && $rss_today % 8 == 0 ) {
            $user->enable = 0; // 禁用用户 
            $user->warming = date("Ymd H:i:s").'今日rss请求次数：'.$rss_today.'次，为防CC，今日剩余7次订阅机会，请单日订阅<32次，请激活帐号，您封禁前订阅IP是：'.$user->rss_ip; //增加提醒
            $url = 'ss://YWVzLTEyOC1nY206NjYwMWZiOTBlOWIz@127.0.0.1:80';      //添加用户到期信息
            $url .= '#'.urlencode('今日订阅>'.$rss_today.'次，帐号异常，请登录激活');
            $user->save();
            return base64_encode($url);
        } elseif ( $rss_today > 128 && $rss_today % 3 == 0 ) {
            $user->enable = 0; // 禁用用户 
            $user->node_group = 1; //把用户放到1组去
            $user->warming = date("Ymd H:i:s").'今日rss请求次数:'.$rss_today.'次，为防CC，今日剩余2次订阅机会，请单日订阅<32次,请激活帐号，您封禁前订阅IP是：'.$user->rss_ip; //增加提醒
            $url = 'ss://YWVzLTEyOC1nY206NjYwMWZiOTBlOWIz@127.0.0.1:80';      //添加用户到期信息
            $url .= '#'.urlencode('今日订阅>'.$rss_today.'次，帐号异常，请登录激活');
            $user->save();
            return base64_encode($url);
        }
        $user->save();
        
        $params = $request->getQueryParams(); // 定义一个变量 = 查询字符串
        if (empty($params)) { //兼容模式,如果没有params参数, mu=2就这么设定了
            $params['mu'] = 2;
        }
        // $newResponse = $response->withHeader('Content-type', ' application/octet-stream; charset=utf-8')->withHeader('Cache-Control', 'no-store, no-cache, must-revalidate')->withHeader('Content-Disposition', ' attachment; filename=' . $token . '.txt');
        // $newResponse->getBody()->write(self::GetSSRSub(User::where('id', '=', $Elink->userid)->first(), $params['mu']));
        // return $newResponse;
        $url = '';
        $url .= self::getNews($user , $params );        // 新闻节点，给用户看的节点 放在最前面，方便用户查看。
        $url .= self::getAllUrl($user , $params );        // 节点
        // $url .= self::getFreeUrl(false, $params );  // add free url
        return base64_encode($url);
    }

    public static function getNews($user, $params) {
        $url = '';
        $Nodes = Node::where("type", "=","1")->where("node_group", "=", 0)->orderBy("node_sort","DESC")->get();
        if ( $params['ss'] || $params['mu'] == 2 || $params['mu'] == 5 ) {  //一些设备不支持 ss节点
            $url .= 'ss://YWVzLTEyOC1nY206NjYwMWZiOTBlOWIz@github.com:443';      //添加用户到期信息
            $url .= '#'.urlencode('用户'.$user->email) ."\n";
            // $url .= 'ss://YWVzLTEyOC1nY206NjYwMWZiOTBlOWIz@github.com:443';      //添加用户到期信息
            // $url .= '#'.urlencode('剩余流量：'.$user->unusedTraffic()) ."\n";
        }
        foreach ($Nodes as $key => $node) {        // ss节点类的news
            if ( $node->sort == 0 && ($params['ss'] || $params['mu'] == 2 || $params['mu'] == 5 ) ) {
                $url .= 'ss://YWVzLTEyOC1nY206NjYwMWZiOTBlOWIz@github.com:443';
                $url .= '#'.urlencode($node->name) ."\n";
            }elseif ($node->sort == 11 && ( $params['vmess'] || $params['mu'] == 2) ) {
                $v2_json = [        
                    "v"    => "2",
                    "ps"   => $node->name,
                    "add"  => 'okxyz.xyz' ,
                    "port" => 443 ,
                    "id"   => '6c6a0625-ac3f-4bd8-9cc8-0545e4e11409',
                    "aid"  => 0 ,
                    "scy"  => 'none' ,
                    "net"  => 'tcp' ,
                    "type" => '' ,
                    "host" => '' ,
                    "path" => '' ,
                    "tls"  => '' ,
                    "sni"  => '' ,
                    "alpn" => ''  
                ];
                $url .= 'vmess://' . base64_encode(json_encode($v2_json, JSON_UNESCAPED_UNICODE)) . "\n" ;
            }elseif ($node->sort == 13 && ( $params['vless'] || $params['mu'] == 2) ) {
                $url .= 'vless://c073aa06-c111-4f1c-8faf-e111ce8e1ceb@github.com:443?encryption=none';
                $url .= '#'.urlencode($node->name) . "\n";
            }elseif ($node->sort == 14 && ( $params['trojan'] || $params['mu'] == 2) ) {
                $url .= 'trojan://c073aa06-c111-4f1c-8faf-e111ce8e1ceb@github.com:443';
                $url .= '#'.urlencode($node->name) . "\n";
            }
        }  
        return $url;
    }

    public static function getAllUrl($user, $params ) {
        $url = '';
        $limit = array(
            'ss' => 0,
            'vmess' => 0,
            'vless' => 0,
            'trojan' => 0,
            'mu' => 0,
        );
        // $nodes = Node::where("type", "=","1")->where("node_group", "=", $user->node_group)->where("node_class", "<=", $user->class)->orderBy("node_class","DESC")->orderBy("traffic_left_daily","DESC")->get();
        
        if (!empty($params['orderbyid'])){  //2024-11-09 添加orderbyid项,方便排查节点故障,获取节点
            $nodes = Node::where("type", "=","1")->where('custom_rss' ,'=',1)->where("node_group", "=", $user->node_group)->where("node_class", "<=", $user->class)->orderBy("id","DESC")->get();   //custom_rss 这里被定义为了 是否支持 用户订阅
        }else{
            $nodes = Node::where("type", "=","1")->where('custom_rss' ,'=',1)->where("node_group", "=", $user->node_group)->where("node_class", "<=", $user->class)->orderBy("node_class","DESC")->orderBy("traffic_left_daily","DESC")->get();   //custom_rss 这里被定义为了 是否支持 用户订阅
        }
        $i = 0;
        //sdo2022-04-27 节点后缀添加网站名字
        $info = '';
        if ($user->class < 5) {
            $info .= '_'. Config::get('appName');
        }
        foreach ($nodes as $node) {
            parse_str($node->server, $v2);  //获取参数
            // if ( $v2['cdn'] ){ # 配置CDN ip
            //     if ( $v2['cdnip'] ){
            //         $v2['add'] = $v2['cdnip'];
            //     }
            //     if ( $v2['cdn'] == 'cf' && $user->cfcdn ){
            //         $v2['add'] = $user->cfcdn;
            //     }
            // }
            if ($node->sort == 11 && ($params['vmess'] || $params['mu'] == 2 || $params['mu'] == 5) ) {
                
                $limit['vmess']++ ;
                if (is_numeric($params['vmess']) && $limit['vmess'] > $params['vmess']){ //限制单协议数量
                    continue;
                }
                $v2_json = [
                    "v"    => "2",
                    "ps"   => $node->name.($node->traffic_rate > 1 ? '-X'.$node->traffic_rate : '').'@'.$node->id.$info,
                    "add"  => $v2['add'] ,
                    "port" => $v2['port'] ,
                    "id"   => ($v2['uuid'] ? $v2['uuid'] : $user->v2ray_uuid) ,
                    "aid"  => $v2['aid'] ,
                    "scy"  => $v2['scy'] ,
                    "net"  => $v2['net'] ,
                    "type" => $v2['type'] ,
                    "host" => $v2['host'] ,
                    "path" => $v2['path'] ,
                    "tls"  => $v2['tls'] ,
                    "sni"  => $v2['sni'] ,
                    "serviceName" => $v2['serviceName'],
                    "mode" => $v2['mode'],
                    "alpn" => $v2['alpn']  
                ];
                $url .= 'vmess://' . base64_encode(json_encode($v2_json, JSON_UNESCAPED_UNICODE)) . "\n" ;
                $i++ ;
                
            } elseif ( $node->sort == 13 && ($params['vless'] || $params['mu'] == 2 || $params['mu'] == 5 ) ) {
                
                $limit['vless']++ ;
                if (is_numeric($params['vless']) && $limit['vless'] > $params['vless']){ //限制单协议数量
                    continue;
                }
                $url .= 'vless://' . ($v2['uuid'] ? $v2['uuid'] : $user->v2ray_uuid) .'@' . $v2['add'] .':' . $v2['port'];
                $url .= '?encryption='.$v2['ecpt'].'&type='.$v2['net'].'&headerType='.$v2['type'].'&fp='.$v2['fp'].'&host='.urlencode($v2['host']).'&path='.urlencode($v2['path']).'&flow='.$v2['flow'].'&security='.$v2['tls'].'&sni='.$v2['sni'].'&serviceName='.$v2['serviceName'].'&mode='.$v2['mode'].'&alpn='.urlencode($v2['alpn']);
                $url .= '#'.urlencode($node->name.($node->traffic_rate > 1 ? '-X'.$node->traffic_rate : '').'@'.$node->id .$info) . "\n";
                $i++ ;
            } elseif ( $node->sort == 14 && ($params['trojan'] || $params['mu'] == 2 || $params['mu'] == 5 ) ) {
                $limit['trojan']++ ;
                if (is_numeric($params['trojan']) && $limit['trojan'] > $params['trojan']){ //限制单协议数量
                    continue;
                }
                $url .= 'trojan://' . ($v2['uuid'] ? $v2['uuid'] : $user->v2ray_uuid) .'@' . $v2['add'] .':' . $v2['port'];
                $url .= '?type='.$v2['net'].'&headerType='.$v2['type'].'&host='.urlencode($v2['host']).'&path='.urlencode($v2['path']).'&flow='.$v2['flow'].'&security='.$v2['tls'].'&sni='.$v2['sni'].'&serviceName='.$v2['serviceName'].'&mode='.$v2['mode'].'&alpn='.urlencode($v2['alpn']);
                $url .= '#'.urlencode($node->name.($node->traffic_rate > 1 ? '-X'.$node->traffic_rate : '').'@'.$node->id .$info) . "\n";
                $i++ ;
            }
            if ( $i > $user->sub_limit ) {
                break;
            }
            
        }
        return $url;
    }

    // add free ss vless vmess trojan nodes 
    public static function getFreeUrl($_, $params ) {
        $_url = '';
        if ($params['ss'] || $params['mu'] == 2 || $params['mu'] == 5 ){
            $_url .= "";
        }
        if ($params['vmess'] || $params['mu'] == 2 || $params['mu'] == 5){
            $_url .= "";
        }
        if ($params['vless'] || $params['mu'] == 2 || $params['mu'] == 5 ){
            $_url .= "";
        }
        if ($params['trojan'] || $params['mu'] == 2 || $params['mu'] == 5 ){
            $_url .= "";
        }
        return $_url;
    }
}
