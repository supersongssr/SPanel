<?php

//Thanks to http://blog.csdn.net/jollyjumper/article/details/9823047

namespace App\Controllers;

use App\Models\Link;
use App\Models\User;
use App\Models\Smartline;
use App\Utils\ConfRender;
use App\Utils\Tools;
use App\Utils\URL;
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

        //上传用户订阅IP，和用户订阅的数据
        // 在用户设置了cfcdn 的情况下，才会记录这个IP
        // if ($user->cfcdn) {
        //   $iplocation = new QQWry();
        //   $location = $iplocation->getlocation($_SERVER["REMOTE_ADDR"]);
        //   //对字符的编码进行一次格式化，编码不同可能影响到判断
        //   $location['area'] = iconv('gbk', 'utf-8//IGNORE', $location['area']);
        //   $location['country'] = iconv('gbk', 'utf-8//IGNORE', $location['country']);
        //   // 这里的 location['area'] 获取到的其实是 联通 电信 移动等网络
        //   if (in_array($location['area'], ['移动','电信','联通'])) {
        //       # code...
        //
        //       $user->cncdn && $user->cncdn_count += 1;
        //       $user->cfcdn && $user->cfcdn_count += 1;
        //   }
        // }
        // 只所以不再记录这个IP的来源，是因为没有必要了 所有的用户都记录订阅的IP
        // 如果设置了 cfcdn 就记录一下
        $user->cncdn && $user->cncdn_count += 1;
        $user->cfcdn && $user->cfcdn_count += 1;
        //记录订阅IP
        $user->rss_ip = $_SERVER["REMOTE_ADDR"];
        // 然后统计一下这次的订阅次数
        $user->rss_count += 1;
        // 订阅超32个，封禁。 订阅超 64个，降级！ 
        $rss_today = $user->rss_count - $user->rss_count_lastday;
        if ($rss_today > 32 && $rss_today % 2 > 0 ) {
            $user->enable = 0; // 禁用用户 
            $user->warming = date("Ymd H:i:s").'订阅异常，为防止订阅泄露，接下来12小时仅允许更新一次订阅！'; //增加提醒
        }elseif ( $rss_today > 64 && $user->node_group > 1 ) {
            $user->enable = 0 ;// 禁用用户 
            $user->node_group = 1; //把用户放到1组去
            $user->warming = date("Ymd H:i:s").'订阅严重异常，疑似泄露，封禁订阅24小时，今日不允许再更新订阅';
        }
        // 保存user
        $user->save();

        // 如果发现用户被禁用，那么订阅设置为 null 
        if ($user->enable == 0) {
            return null;
        }

        $mu = 0;
        if (isset($request->getQueryParams()['mu'])) {
            $mu = (int)$request->getQueryParams()['mu'];
        }

        $newResponse = $response->withHeader('Content-type', ' application/octet-stream; charset=utf-8')->withHeader('Cache-Control', 'no-store, no-cache, must-revalidate')->withHeader('Content-Disposition', ' attachment; filename=' . $token . '.txt');
        $newResponse->getBody()->write(self::GetSSRSub(User::where('id', '=', $Elink->userid)->first(), $mu));
        return $newResponse;
    }

    public const V2RYA_MU = 2;
    public const SSD_MU = 3;
    public const CLASH_MU = 4;
    public const IOS_V2RAY = 5;

    public static function GetSSRSub($user, $mu = 0)
    {
        if ($mu == 0 || $mu == 1) {
            return Tools::base64_url_encode(URL::getAllUrl($user, $mu, 0));
        }

        if ($mu == self::V2RYA_MU) {
            return Tools::base64_url_encode(URL::getAllVMessUrl($user));
        }

        if ($mu == self::SSD_MU) {
            return URL::getAllSSDUrl($user);
        }

        if ($mu == self::CLASH_MU) {
            // Clash
            return self::GetClash($user);
        }

        if ($mu == self::IOS_V2RAY) {
            // shadowrocket
            return Tools::base64_url_encode(URL::getIOSVMessUrl($user));
        }
    }

    public static function GetClash($user)
    {
        $confs = [];
        $proxy_confs = [];
        // ss
        $items = array_merge(URL::getAllItems($user, 0, 1), URL::getAllItems($user, 1, 1));
        foreach ($items as $item) {
            $sss = [
                'name' => $item['remark'],
                'type' => 'ss',
                'server' => $item['address'],
                'port' => $item['port'],
                'cipher' => $item['method'],
                'password' => $item['passwd'],
            ];
            if ($item['obfs'] != 'plain') {
                switch ($item['obfs']) {
                    case 'simple_obfs_http':
                        $sss['plugin'] = 'obfs';
                        $sss['plugin-opts']['mode'] = 'http';
                        break;
                    case 'simple_obfs_tls':
                        $sss['plugin'] = 'obfs';
                        $sss['plugin-opts']['mode'] = 'tls';
                        break;
                    case 'v2ray':
                        $sss['plugin'] = 'v2ray-plugin';
                        $sss['plugin-opts']['mode'] = 'websocket';
                        if (strpos($item['obfs_param'], 'security=tls')) {
                            $sss['plugin-opts']['tls'] = true;
                        }
                        $sss['plugin-opts']['host'] = $user->getMuMd5();
                        $sss['plugin-opts']['path'] = $item['path'];
                        break;
                }
                if ($item['obfs'] != 'v2ray') {
                    if ($item['obfs_param'] != '') {
                        $sss['plugin-opts']['host'] = $item['obfs_param'];
                    } elseif ($user->obfs_param != '') {
                        $sss['plugin-opts']['host'] = $user->obfs_param;
                    } else {
                        $sss['plugin-opts']['host'] = 'wns.windows.com';
                    }
                }
            }
            $proxy_confs[] = $sss;
            $confs[] = $sss;
        }
        // v2
        $items = URL::getAllVMessUrl($user, 1);
        foreach ($items as $item) {
            if (in_array($item['net'], array('kcp', 'http', 'quic'))) {
                continue;
            }
            $v2rays = [
                'name' => $item['ps'],
                'type' => 'vmess',
                'server' => $item['add'],
                'port' => $item['port'],
                'uuid' => $item['id'],
                'alterId' => $item['aid'],
                'cipher' => 'auto',
            ];
            if ($item['net'] == 'ws') {
                $v2rays['network'] = 'ws';
                $v2rays['ws-path'] = $item['path'];
                if ($item['tls'] == 'tls') {
                    $v2rays['tls'] = true;
                }
                if ($item['host'] != '') {
                    $v2rays['ws-headers']['Host'] = $item['host'];
                }
            } elseif ($item['net'] == 'tls') {
                $v2rays['tls'] = true;
            }
            $proxy_confs[] = $v2rays;
            $confs[] = $v2rays;
        }
        $render = ConfRender::getTemplateRender();
        $render->assign('user', $user)
            ->assign('confs', $confs)
            ->assign(
                'proxies',
                array_map(
                    static function ($conf) {
                        return $conf['name'];
                    },
                    $proxy_confs
                )
            );
        return $render->fetch('clash.tpl');
    }
}
