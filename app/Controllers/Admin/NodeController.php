<?php
namespace App\Controllers\Admin;
use App\Models\Node;
use App\Utils\Radius;
use App\Utils\Telegram;
use App\Utils\Tools;
use App\Controllers\AdminController;
use App\Utils\CloudflareDriver;
use App\Services\Config;
use Ozdemir\Datatables\Datatables;
use App\Utils\DatatablesHelper;
use App\Services\Analytics;


class NodeController extends AdminController
{
    public function index($request, $response, $args)
    {
        $table_config['total_column'] = Array("op" => "操作", "id" => "ID", "name" => "名称",
                            "type" => "显", "node_sort" => "!","sort" => "类型",
                            "server" => "节点配置", "node_ip" => "节点IP",
                            "status" => "?","traffic_rate" => "R",
                            "node_cost" => "C","node_online" => "O","node_oncost" => "日均", "node_group" => "G",
                            "node_class" => "L", "node_speedlimit" => "节点限速/Mbps",
                            "node_bandwidth" => "GB", "node_bandwidth_limit" => "流量限制/GB","info" => "节点信息",
                            "bandwidthlimit_resetday" => "流量重置日", "node_heartbeat" => "上一次活跃时间",
                            "custom_method" => "自定义加密", "custom_rss" => "自定义协议以及混淆",
                            "mu_only" => "只启用单端口多用户");
        $table_config['default_show_column'] = Array("op", "id", "name", "node_sort","status", "info", "traffic_rate");
        $table_config['ajax_url'] = 'node/ajax';

        $sts = new Analytics();
        return $this->view()->assign('table_config', $table_config)->assign('sts', $sts)->display('admin/node/index.tpl');
    }
    public function create($request, $response, $args)
    {
        return $this->view()->display('admin/node/create.tpl');
    }
    public function add($request, $response, $args)
    {
        $node = new Node();
        $node->name =  $request->getParam('name');
        $node->server =  trim($request->getParam('server'));
        $node->method =  $request->getParam('method');
        $node->custom_method =  $request->getParam('custom_method');
        $node->custom_rss =  $request->getParam('custom_rss');
        $node->mu_only =  $request->getParam('mu_only');
        $node->traffic_rate = $request->getParam('rate');
        $node->node_cost = $request->getParam('cost');
        $node->info = $request->getParam('info');
        $node->type = $request->getParam('type');
        $node->node_group = $request->getParam('group');
        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->status = $request->getParam('status');
        $node->sort = $request->getParam('sort');
        $node->node_ip=trim($request->getParam('node_ip'));
        empty($node->node_ip) && $node->node_ip = $node->server;
        /*if($req_node_ip==""){
            $req_node_ip=$node->server;
        }

        if ($node->sort == 11) {
            //$server_list = explode("#", $node->server);
            //if(!Tools::is_ip($server_list[0])){
            //    $node->node_ip = gethostbyname($server_list[0]);
            //}else{
                $node->node_ip = $req_node_ip;
            //}
        } else if ($node->sort == 0 || $node->sort == 1 || $node->sort == 10){
            //if(!Tools::is_ip($node->server)){
            //    $node->node_ip = gethostbyname($node->server);
            //}else{
                $node->node_ip = $req_node_ip;
            //}
        } else {
            $node->node_ip="";
        }
        if($node->node_ip==""&&($node->sort == 11||$node->sort == 0 || $node->sort == 1 || $node->sort == 10)){
            $rs['ret'] = 0;
            $rs['msg'] = "获取节点IP失败，请检查您输入的节点地址是否正确！";
            return $response->getBody()->write(json_encode($rs));
        }
        if ($node->sort==1) {
            Radius::AddNas($node->node_ip, $request->getParam('server'));
        }*/
        $node->node_class=$request->getParam('class');
        $node->node_bandwidth_limit=$request->getParam('node_bandwidth_limit')*1024*1024*1024;
        $node->bandwidthlimit_resetday=$request->getParam('bandwidthlimit_resetday');
        $node->save();
        $domain_name = explode('.'.Config::get('cloudflare_name'), $node->server);
        if (Config::get('cloudflare_enable') == 'true') {
            CloudflareDriver::updateRecord($domain_name[0], $node->node_ip);
        }
        Telegram::Send("新节点添加~".$request->getParam('name'));
        $rs['ret'] = 1;
        $rs['msg'] = "节点添加成功";
        return $response->getBody()->write(json_encode($rs));
    }
    public function edit($request, $response, $args)
    {
        $id = $args['id'];
        $node = Node::find($id);
        if ($node == null) {
        }
        return $this->view()->assign('node', $node)->display('admin/node/edit.tpl');
    }
    public function nodectl($request, $response, $args)
    {

        $group = $request->getParam('group');
        $class = $request->getParam('class');

        $nodes = Node::where('node_group','=',$group)->where('node_class','<=',$class)->orderBy("type","desc")->orderBy("traffic_rate", "desc")->get();
        //$nodes = Node::orderBy("traffic_rate", "desc")->limit('30')->get();

        return $this->view()->assign("nodes", $nodes)->display('admin/node/nodectl.tpl');
    }

    public function update($request, $response, $args)
    {
        $id = $args['id'];
        $node = Node::find($id);
        $node->name =  $request->getParam('name');
        $node->node_group =  $request->getParam('group');
        $node->server =  trim($request->getParam('server'));
        $node->method =  $request->getParam('method');
        $node->custom_method =  $request->getParam('custom_method');
        $node->custom_rss =  $request->getParam('custom_rss');
        $node->mu_only =  $request->getParam('mu_only');
        $node->traffic_rate = $request->getParam('rate');
        $node->node_cost = $request->getParam('cost');
        $node->info = $request->getParam('info');
        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->type = $request->getParam('type');
        $node->sort = $request->getParam('sort');
        $node->node_sort = $request->getParam('node_sort');
        $node->node_ip=trim($request->getParam('node_ip'));
        empty($node->node_ip) && $node->node_ip = $node->server;
        /*$success=true;
        if ($node->sort == 0 || $node->sort == 1 || $node->sort == 10){
            //if(!Tools::is_ip($node->server)){
            //    $success=$node->changeNodeIp($node->server);
            //}else{
                $success=$node->changeNodeIp($req_node_ip);
            //}
        }
        if (!$success) {
            $rs['ret'] = 0;
            $rs['msg'] = "更新节点IP失败，请检查您输入的节点地址是否正确！";
            return $response->getBody()->write(json_encode($rs));
        }

        if ($node->sort == 0 || $node->sort == 10) {
            Tools::updateRelayRuleIp($node);
        }*/
        if ($node->sort==1) {
            $SS_Node=Node::where('sort', '=', 0)->where('server', '=', $request->getParam('server'))->first();
            if ($SS_Node!=null) {
                if (time()-$SS_Node->node_heartbeat<300||$SS_Node->node_heartbeat==0) {
                    Radius::AddNas(gethostbyname($request->getParam('server')), $request->getParam('server'));
                }
            }
            else {
                Radius::AddNas(gethostbyname($request->getParam('server')), $request->getParam('server'));
            }
        }
        $node->status = $request->getParam('status');
        $node->node_class=$request->getParam('class');
        $node->node_bandwidth_limit=$request->getParam('node_bandwidth_limit')*1024*1024*1024;
        $node->bandwidthlimit_resetday=$request->getParam('bandwidthlimit_resetday');
        $node->save();
        Telegram::Send("新节点~~".$request->getParam('name').'VIP等级 '.$node->node_class.' #'.$id);
        $rs['ret'] = 1;
        $rs['msg'] = "修改成功";
        return $response->getBody()->write(json_encode($rs));
    }
    public function delete($request, $response, $args)
    {
        $id = $request->getParam('id');
        $node = Node::find($id);
        if ($node->sort==1) {
            Radius::DelNas($node->node_ip);
        }
        $name = $node->name;
        if (!$node->delete()) {
            $rs['ret'] = 0;
            $rs['msg'] = "删除失败";
            return $response->getBody()->write(json_encode($rs));
        }
        Telegram::Send("节点被删除~".$name);
        $rs['ret'] = 1;
        $rs['msg'] = "删除成功";
        return $response->getBody()->write(json_encode($rs));
    }
    public function ajax($request, $response, $args)
    {
        $datatables = new Datatables(new DatatablesHelper());
        $total_column = Array("op" => "操作", "id" => "ID", "name" => "名称",
                              "type" => "显示", "node_sort"=>"维护","sort" => "类型",
                              "status" => "状态",
                              "server" => "节点配置", "node_ip" => "节点IP", "traffic_rate" => "流量比率",
                              "node_cost" => "成本", "node_online" => "在线人数","node_oncost" => "负载","node_group" => "节点群组",
                              "node_class" => "节点等级", "node_speedlimit" => "节点限速/Mbps",
                              "node_bandwidth" => "GB", "node_bandwidth_limit" => "流量限制/GB","info" => "节点信息",
                              "bandwidthlimit_resetday" => "流量重置日", "node_heartbeat" => "上一次活跃时间",
                              "custom_method" => "自定义加密", "custom_rss" => "自定义协议以及混淆",
                              "mu_only" => "只启用单端口多用户");
        $key_str = '';
        foreach($total_column as $single_key => $single_value) {
            if($single_key == 'op') {
                $key_str .= 'id as op';
                continue;
            }
            $key_str .= ','.$single_key;
        }
        $datatables->query('Select '.$key_str.' from ss_node');
        $datatables->edit('op', function ($data) {
            return '<a class="btn btn-brand" '.($data['sort'] == 999 ? 'disabled' : 'href="/admin/node/'.$data['id'].'/edit"').'>'.$data['id'].'</a>
                    <!-- <a class="btn btn-brand-accent" '.($data['sort'] == 999 ? 'disabled' : 'id="delete" value="'.$data['id'].'" href="javascript:void(0);" onClick="delete_modal_show(\''.$data['id'].'\')"').'>删除</a> -->';
        });
        $datatables->edit('node_bandwidth', function ($data) {
            return floor(Tools::flowToGB($data['node_bandwidth']));
        });
        $datatables->edit('node_bandwidth_limit', function ($data) {
            return Tools::flowToGB($data['node_bandwidth_limit']);
        });
        $datatables->edit('sort', function ($data) {
            $sort = '';
            switch($data['sort']) {
                case 0:
                  $sort = 'SS';
                  break;
                case 1:
                  $sort = 'VPN/Radius基础';
                  break;
                case 2:
                  $sort = 'SSH';
                  break;
                case 5:
                  $sort = 'Anyconnect';
                  break;
                case 9:
                  $sort = 'Sr-单多';
                  break;
                case 10:
                  $sort = 'Ss-中转';
                  break;
                case 11:
                  $sort = 'V2';
                  break;
                case 12:
                  $sort = 'CDN';
                  break;
                case 13:
                    $sort = 'Vl';
                    break;
                case 14:
                    $sort = 'Tr';
                    break;
                default:
                  $sort = '?';
            }
            return $sort;
        });
        $datatables->edit('type', function ($data) {
            return $data['type'] == 1 ? '显' : '隐';
        });
        $datatables->edit('custom_method', function ($data) {
            return $data['custom_method'] == 1 ? '启用' : '关闭';
        });
        $datatables->edit('custom_rss', function ($data) {
            return $data['custom_rss'] == 1 ? '启用' : '关闭';
        });
        $datatables->edit('mu_only', function ($data) {
            return $data['mu_only'] == 1 ? '启用' : '关闭';
        });
        $datatables->edit('node_heartbeat', function ($data) {
            return date('Y-m-d H:i:s', $data['node_heartbeat']);
        });
        $datatables->edit('DT_RowId', function ($data) {
            return 'row_1_'.$data['id'];
        });
        $body = $response->getBody();
        $body->write($datatables->generate());
    }
}
