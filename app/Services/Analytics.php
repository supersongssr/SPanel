<?php

namespace App\Services;

use App\Models\User;
use App\Models\Node;
use App\Utils\Tools;
use App\Models\Record;  // record表


class Analytics
{
    public function getRecord($name)
    {
        $record = Record::where('name',$name)->first();
        return $record->value;
    }

    public function getTotalUser()
    {
        return User::count();
    }

    public function getAllUser()
    {
        return User::where("enable","=",1)->count();
    }

    public function getUserAll()
    {
        return User::where("enable","=",1)->count();
    }

    public function getLiveUserAll()
    {
        return User::where("enable","=",1)->where('t','>',(time()-24*3600))->count();
    }

    public function getLiveUserAllIn30Min()
    {
        return User::where("enable","=",1)->where('t','>',(time()-1800))->count();
    }

    public function getVIPUser($vip)
    {
        return User::where("enable","=",1)->where("class","=",$vip)->count();
    }

    public function getLiveUserByVip($vip) //24小时在线用户
    {
        return User::where("enable","=",1)->where("class","=",$vip)->where('t','>',(time()-24*3600))->count();
    }


    public function getGroupLiveUser($group)
    {
        #30分钟内 各等级 分组在线人数
        return User::where("enable","=",1)->where("node_group","=",$group)->where('t','>',(time()-1800))->count();
    }

    public function getLiveUserByGroup($group)
    {
        #30分钟内 各等级 分组在线人数
        return User::where("enable","=",1)->where("node_group","=",$group)->where('t','>',(time()-24*3600))->count();
    }

    public function getGroupLiveUserIn30Min($group)
    {
        #30分钟内 各等级 分组在线人数
        return User::where("enable","=",1)->where("node_group","=",$group)->where('t','>',(time()-1800))->count();
    }

    public function getGroupUser($group)
    {
        return User::where("enable","=",1)->where('class','>',0)->where("node_group","=",$group)->count();
    }

    public function getVIPGroupUser($vip,$group)
    {
        return User::where("enable","=",1)->where('class','=',$vip)->where("node_group","=",$group)->count();
    }

    public function getVIPGroupLiveUser($vip,$group)
    {
        return User::where("enable","=",1)->where('class','=',$vip)->where("node_group","=",$group)->where('t','>',(time()-168*3600))->count();
    }

    public function getLiveUserByVipAndGroup($vip,$group)
    {
        return User::where("enable","=",1)->where('class','=',$vip)->where("node_group","=",$group)->where('t','>',(time()-24*3600))->count();
    }


    public function getCheckinUser()
    {
        return User::where('last_check_in_time', '>', 0)->count();
    }

    public function getTodayCheckinUser()
    {
        return User::where('last_check_in_time', '>', strtotime('today'))->count();
    }

    public function getTrafficUsage()
    {
        $total = User::sum('u') + User::sum('d');
        return Tools::flowAutoShow($total);
    }

    public function getTodayTrafficUsage()
    {
        $total = User::sum('u') + User::sum('d') - User::sum('last_day_t');
        return Tools::flowAutoShow($total);
    }


    public function getRawTodayTrafficUsage()
    {
        $total = User::sum('u') + User::sum('d') - User::sum('last_day_t');
        return $total;
    }

    public function getLastTrafficUsage()
    {
        $total = User::sum('last_day_t');
        return Tools::flowAutoShow($total);
    }


    public function getRawLastTrafficUsage()
    {
        $total = User::sum('last_day_t');
        return $total;
    }

    public function getUnusedTrafficUsage()
    {
        $total = User::sum('transfer_enable') - User::sum('u') - User::sum('d');
        return Tools::flowAutoShow($total);
    }

    public function getRawUnusedTrafficUsage()
    {
        $total = User::sum('transfer_enable') - User::sum('u') - User::sum('d');
        return $total;
    }


    public function getTotalTraffic()
    {
        $total = User::sum('transfer_enable');
        return Tools::flowAutoShow($total);
    }

    public function getRawTotalTraffic()
    {
        $total = User::sum('transfer_enable');
        return $total;
    }

    public function getOnlineUser($time)
    {
        $time = time() - $time;
        return User::where('t', '>', $time)->count();
    }

    public function getUnusedUser()
    {
        return User::where('t', '=', 0)->count();
    }

    public function getTotalNode()
    {
        return Node::count();
    }

    public function getAllNode()
    {
        return Node::where("type","=",1)->count();
    }

    public function getCostAll()
    {
        return Node::where("type","=",1)->where('is_clone',0)->sum('node_cost');
    }


    public function getVIPNode($vip)
    {
        return Node::where("type","=",1)->where('node_class','=',$vip)->count();
    }

    public function getCostVIPNode($vip)
    {
        return Node::where("type","=",1)->where('node_class','=',$vip)->where('is_clone','=',0)->sum('node_cost');
    }

    public function getCostByVipAndGroup($vip,$group)
    {
        return Node::where("type","=",1)->where('node_class','=',$vip)->where('node_group','=',$group)->where('is_clone','=',0)->sum('node_cost') * 7;
    }


    public function getCostByGroup($group)
    {
        return Node::where("type","=",1)->where('is_clone',0)->where('node_group','=',$group)->sum('node_cost');
    }
    

    public function getGroupNode($group)
    {
        return Node::where("type","=",1)->where("node_group","=",$group)->count();
    }

    public function getVIPGroupNode($vip,$group)
    {
        return Node::where("type","=",1)->where('node_class','=',$vip)->where("node_group","=",$group)->count();
    }

    public function getOncostVIPGroupNode($vip,$group)
    {
        return round(Node::where("type","=",1)->where('node_class','=',$vip)->where("node_group","=",$group)->sum('node_oncost') , 1);
    }


    public function getTotalNodes()
    {
        return Node::where('node_heartbeat', '>', 0)->where(
                    function ($query) {
                        $query->Where('sort', '=', 0)
                            ->orWhere('sort', '=', 10)
                            ->orWhere('sort', '=', 11);
                    }
                )->count();
    }

    public function getAliveNodes()
    {
        return Node::where(
            function ($query) {
                $query->Where('sort', '=', 0)
                    ->orWhere('sort', '=', 10)
                ->orWhere('sort', '=', 11);
            }
        )->where('node_heartbeat', '>', time()-90)->count();
    }
}
