<?php

namespace App\Services;

use App\Models\User;
use App\Models\Node;
use App\Utils\Tools;

class Analytics
{
    public function getTotalUser()
    {
        return User::count();
    }

    public function getAllUser()
    {
        return User::where("enable","=",1)->count();
    }

    public function getV0User()
    {
        return User::where("enable","=",1)->where("class","=",0)->count();
    }

    public function getV1User()
    {
        return User::where("enable","=",1)->where("class","=",1)->count();
    }

    public function getV2User()
    {
        return User::where("enable","=",1)->where("class","=",2)->count();
    }

    public function getV3User()
    {
        return User::where("enable","=",1)->where("class","=",3)->count();
    }

    public function getV4User()
    {
        return User::where("enable","=",1)->where("class","=",4)->count();
    }

    public function getV5User()
    {
        return User::where("enable","=",1)->where("class","=",5)->count();
    }

    public function getV6User()
    {
        return User::where("enable","=",1)->where("class","=",6)->count();
    }

    public function getV7User()
    {
        return User::where("enable","=",1)->where("class","=",7)->count();
    }

    public function getV8User()
    {
        return User::where("enable","=",1)->where("class","=",8)->count();
    }

    public function getV9User()
    {
        return User::where("enable","=",1)->where("class","=",9)->count();
    }

    public function getV10User()
    {
        return User::where("enable","=",1)->where("class","=",10)->count();
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

    public function getV0Node()
    {
        return Node::where("type","=",1)->where("node_class","=",0)->count();
    }

    public function getV1Node()
    {
        return Node::where("type","=",1)->where("node_class","=",1)->count();
    }

    public function getV2Node()
    {
        return Node::where("type","=",1)->where("node_class","=",2)->count();
    }

    public function getV3Node()
    {
        return Node::where("type","=",1)->where("node_class","=",3)->count();
    }

    public function getV4Node()
    {
        return Node::where("type","=",1)->where("node_class","=",4)->count();
    }

    public function getV5Node()
    {
        return Node::where("type","=",1)->where("node_class","=",5)->count();
    }

    public function getV6Node()
    {
        return Node::where("type","=",1)->where("node_class","=",6)->count();
    }

    public function getV7Node()
    {
        return Node::where("type","=",1)->where("node_class","=",7)->count();
    }

    public function getV8Node()
    {
        return Node::where("type","=",1)->where("node_class","=",8)->count();
    }

    public function getV9Node()
    {
        return Node::where("type","=",1)->where("node_class","=",9)->count();
    }

    public function getV10Node()
    {
        return Node::where("type","=",1)->where("node_class","=",10)->count();
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
