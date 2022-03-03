<?php

namespace App\Controllers\Admin;

use App\Models\Ticket;
use App\Models\User;

use voku\helper\AntiXSS;
use App\Services\Auth;

use App\Services\Mail;
use App\Services\Config;

use Ozdemir\Datatables\Datatables;
use App\Utils\DatatablesHelper;

use App\Controllers\AdminController;

class TicketController extends AdminController
{
    public function index($request, $response, $args)
    {
        $table_config['total_column'] = array("op" => "操作", "status" => "状态", "title" => "标题", "id" => "ID", "userid" => "用户ID", "datetime" => "时间", "sort" => "等级", "user_name" => "用户名");
        $table_config['default_show_column'] = array("op", "status","title","id" => "ID", 
                                  "datetime",  "sort","userid", "user_name");
        $table_config['ajax_url'] = 'ticket/ajax';
        return $this->view()->assign('table_config', $table_config)->display('admin/ticket/index.tpl');
    }



    public function update($request, $response, $args)
    {
        $id = $args['id'];
        $content = $request->getParam('content');
        $status = $request->getParam('status');


        if ($content==""||$status=="") {
            $res['ret'] = 0;
            $res['msg'] = "请填全";
            return $this->echoJson($response, $res);
        }

        // if (strpos($content, "admin")!=false||strpos($content, "user")!=false) {
        //     $res['ret'] = 0;
        //     $res['msg'] = "请求中有不正当的词语。";
        //     return $this->echoJson($response, $res);
        // }
        $ticket_main=Ticket::where("id", "=", $id)->where("rootid", "=", 0)->first();
        //if($status==1&&$ticket_main->status!=$status)
        $user = User::where("id", "=", $ticket_main->userid)->first();
        $subject = Config::get('appName')."-工单被回复";
        $to = $user->email;
        $text = "您好，有人回复了<a href=\"".Config::get('baseUrl')."/user/ticket/".$ticket_main->id."/view\">工单</a>，请您查看。" ;
        try {
            Mail::send($to, $subject, 'news/warn.tpl', [
                "user" => $user,"text" => $text
            ], [
            ]);
        } catch (\Exception $e) {
            echo $e->getMessage();
        }
        $antiXss = new AntiXSS();
        $ticket=new Ticket();
        $ticket->title=$antiXss->xss_clean($ticket_main->title);
        $ticket->content=$antiXss->xss_clean($content);
        $ticket->rootid=$ticket_main->id;
        $ticket->userid=Auth::getUser()->id;
        $ticket->sort = 0;
        $ticket->datetime=time();

        $ticket_main->status=$status;
        $ticket_main->sort= 0;
        $ticket_main->save();
        $ticket->save();

        if ( $status == 3 ) {
            $user->money += Config::get('ticket_price');
            $user->save();
        }

        $res['ret'] = 1;
        $res['msg'] = "提交成功";
        return $this->echoJson($response, $res);
    }

    public function show($request, $response, $args)
    {
        $id = $args['id'];

        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }

        $ticketset=Ticket::where("id", $id)->orWhere("rootid", "=", $id)->orderBy("datetime", "asc")->paginate(15, ['*'], 'page', $pageNum);
        $ticketset->setPath('/admin/ticket/'.$id."/view");

        $nexticket = Ticket::where('rootid','=','0')->where('id','!=',$id)->where('status','!=','0')->orderBy('sort','desc')->first();
        $nextid = $nexticket->id;

        return $this->view()->assign('ticketset', $ticketset)->assign("id", $id)->assign("nextid", $nextid)->display('admin/ticket/view.tpl');
    }

    public function ajax($request, $response, $args)
    {
        $datatables = new Datatables(new DatatablesHelper());
        $datatables->query('Select ticket.id as op,ticket.status,ticket.title,ticket.id,ticket.userid,ticket.datetime,ticket.sort,user.user_name from ticket,user where ticket.userid = user.id and ticket.rootid = 0');

        $datatables->edit('userid', function ($data) {
            return '<a href="/admin/user/'.$data['userid'].'/edit">'.$data['userid'].'</a>';
        });

        $datatables->edit('op', function ($data) {
            return '<a class="btn btn-brand" href="/admin/ticket/'.$data['id'].'/view">查看</a>';
        });

        $datatables->edit('datetime', function ($data) {
            return date('Y-m-d H:i:s', $data['datetime']);
        });

        $datatables->edit('status', function ($data) {
            return $data['status'] == 1 ? '开启' : '关闭';
        });

        $body = $response->getBody();
        $body->write($datatables->generate());
    }
}
