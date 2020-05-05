<?php

namespace App\Utils;

use App\Models\User;
use App\Services\Config;
use App\Controllers\LinkController;
use TelegramBot\Api\Client;
use TelegramBot\Api\Exception;
use TelegramBot\Api\Types\Inline\InlineKeyboardMarkup;

use App\Models\Code;  // 充值金额
use App\Models\Payback;  // 返利金额

class TelegramProcess
{
    private static $all_rss = [
        'clean_link' => '重置订阅',
        '?mu=0' => 'SSR普通订阅',
        '?mu=1' => 'SSR单端口订阅',
        '?mu=3' => 'SS/SSD订阅',
        '?mu=2' => 'V2ray订阅',
        '?mu=4' => 'Clash订阅'];

    private static function callback_bind_method($bot, $callback)
    {
        $callback_data = $callback->getData();
        $message = $callback->getMessage();
        $reply_to = $message->getMessageId();
        $user = User::where('telegram_id', $callback->getFrom()->getId())->first();
        $reply_message = '？？？';
        if ($user != null) {
            switch (true) {
                case (strpos($callback_data, 'mu')):
                    $ssr_sub_token = LinkController::GenerateSSRSubCode($user->id, 0);
                    $subUrl = Config::get('subUrl');
                    $reply_message = self::$all_rss[$callback_data] . ': ' . $subUrl . $ssr_sub_token . $callback_data . PHP_EOL;
                    break;
                case ($callback_data == 'clean_link'):
                    $user->clean_link();
                    $reply_message = '链接重置成功';
                    break;
            }
            $bot->sendMessage($message->getChat()->getId(), $reply_message, $parseMode = null, $disablePreview = false, $replyToMessageId = $reply_to);
        }
    }

    private static function needbind_method($bot, $message, $command, $user, $reply_to = null)
    {
        $reply = [
            'message' => '？？？',
            'markup' => null,
        ];
        if ($user != null) {
            switch ($command) {
                case 'traffic':
                    $reply['message'] = '您当前的流量状况：
今日已使用 ' . $user->TodayusedTraffic() . ' ' . number_format($user->last_day_t / $user->transfer_enable * 100, 2) . '%
今日之前已使用 ' . $user->LastusedTraffic() . ' ' . number_format(($user->u + $user->d - $user->last_day_t) / $user->transfer_enable * 100, 2) . '%
未使用 ' . $user->unusedTraffic() . ' ' . number_format(($user->transfer_enable - ($user->u + $user->d)) / $user->transfer_enable * 100, 2) . '%';
                    break;
                case 'checkin':
                    if (!$user->isAbleToCheckin()) {
                        $reply['message'] = '您今天已经签过到了！';
                        break;
                    }
                    $traffic = random_int(Config::get('checkinMin'), Config::get('checkinMax'));
                    $user->transfer_enable += Tools::toMB($traffic);
                    $user->last_check_in_time = time();
                    $user->save();
                    $reply['message'] = '签到成功！获得了 ' . $traffic . ' MB 流量！';
                    break;
                case 'prpr':
                    $prpr = array('⁄(⁄ ⁄•⁄ω⁄•⁄ ⁄)⁄', '(≧ ﹏ ≦)', '(*/ω＼*)', 'ヽ(*。>Д<)o゜', '(つ ﹏ ⊂)', '( >  < )');
                    $reply['message'] = $prpr[random_int(0, 5)];
                    break;
                case 'checkme':
                    $codes=Code::where('userid',$user->id)->get();
                    $user_charge =0;
                    if (!empty($codes)) {
                        foreach($codes as $code){
                            $user_charge+=$code->number;
                        }
                    }
                    $aff_payback = Payback::where('total','<',0)->where('ref_by','=',$user->id)->sum('ref_get'); // 注册奖励
                    $ref_payback = Payback::where('total','>',0)->where('ref_by','=',$user->id)->sum('ref_get'); // 消费返利
                    $reply['message'] = '您累计充值 '.$user_charge.'￥，邀请奖励'. $aff_payback.'￥，消费返利'. $ref_payback .' ￥，购买了等级为Lv '.$user->class .' 的套餐，您在 '. ($user->renew *10) . ' 天内使用了 '. floor($user->d / 1024/1024/1024) .' G下行流量';
                    break;

                case 'rss':
                    $reply['message'] = '点击以下按钮获取对应订阅: ';
                    $keys = [];
                    foreach (self::$all_rss as $key => $value) {
                        $keys[] = [['text' => $value, 'callback_data' => $key]];
                    }
                    $reply['markup'] = new InlineKeyboardMarkup(
                        $keys
                    );
                    break;
            }
        } else {
            $reply['message'] = '您未绑定本站账号，您可以进入网站的“个人设定”，在右下方绑定您的账号';
        }

        return $reply;
    }


    public static function telegram_process($bot, $message, $command)
    {
        $user = User::where('telegram_id', $message->getFrom()->getId())->first();
        $reply_to = $message->getMessageId();
        $reply = [
            'message' => null,
            'markup' => null,
        ];
        if ($message->getChat()->getId() > 0) {
            //个人
            $bot->sendChatAction($message->getChat()->getId(), 'typing');

            switch ($command) {
                case 'ping':
                    $reply['message'] = 'Pong!您的 ID 是 ' . $message->getChat()->getId() . '!';
                    break;
                case 'traffic':
                case 'checkin':
                case 'prpr':
                case 'rss':
                    $reply = self::needbind_method($bot, $message, $command, $user, $reply_to);
                    break;
                case 'help':
                    $reply['message'] = '命令列表：
                        /ping  获取群组ID
                        /traffic 查询流量
                        /checkin 签到
                        /help 获取帮助信息
                        /rss 获取节点订阅';
                    if ($user == null) {
                        $help_list .= PHP_EOL . '您未绑定本站账号，您可以进入网站的“个人设定”，在右下方绑定您的账号';
                    }
                    break;
                case 'bind':
                    if (!is_numeric($message->getText()) && strlen($message->getText()) == 22) {
                        $uid = TelegramSessionManager::verify_bind_session(substr($message->getText(), 6));
                        if ($uid != 0) {
                            $user = User::where('id', $uid)->first();
                            $user->telegram_id = $message->getFrom()->getId();
                            $user->im_type = 4;
                            $user->im_value = $message->getFrom()->getUsername();
                            $user->save();
                            $reply['message'] = '绑定成功。邮箱' . $user->email;
                        } else {
                            $reply['message'] = '绑定失败，绑定码已过期。' . substr($message->getText(), 6);
                        }
                        break;
                    }
                    break;
                default:
                    if ($message->getPhoto() == null) {
                        //绑定
                        if (!is_numeric($message->getText()) && strlen($message->getText()) == 16) {
                            $uid = TelegramSessionManager::verify_bind_session($message->getText());
                            if ($uid != 0) {
                                $user = User::where('id', $uid)->first();
                                $user->telegram_id = $message->getFrom()->getId();
                                $user->im_type = 4;
                                $user->im_value = $message->getFrom()->getUsername();
                                $user->save();
                                $reply['message'] = '绑定成功。邮箱' . $user->email;
                            } else {
                                $reply['message'] = '绑定失败，绑定码已过期。' . $message->getText();
                            }
                            break;
                        }
                        // 数字登录 
                        if (is_numeric($message->getText()) && strlen($message->getText()) == 6) {
                            if ($user != null) {
                                $uid = TelegramSessionManager::verify_login_number($message->getText(), $user->id);
                                if ($uid != 0) {
                                    $reply['message'] = '登录验证成功，邮箱：' . $user->email;
                                } else {
                                    $reply['message'] = '登录验证失败，数字无效';
                                }
                            } else {
                                $reply['message'] = '登录验证失败，您未绑定本站账号';
                            }
                            break;
                        }

                        break;
                    }

                    $bot->sendMessage($message->getChat()->getId(), '正在解码，请稍候。。。');
                    $bot->sendChatAction($message->getChat()->getId(), 'typing');
                    $photos = $message->getPhoto();

                    $photo_size_array = array();
                    $photo_id_array = array();
                    $photo_id_list_array = array();

                    foreach ($photos as $photo) {
                        $file = $bot->getFile($photo->getFileId());
                        $real_id = substr($file->getFileId(), 0, 36);
                        if (!isset($photo_size_array[$real_id])) {
                            $photo_size_array[$real_id] = 0;
                        }

                        if ($photo_size_array[$real_id] >= $file->getFileSize()) {
                            continue;
                        }

                        $photo_size_array[$real_id] = $file->getFileSize();
                        $photo_id_array[$real_id] = $file->getFileId();
                        if (!isset($photo_id_list_array[$real_id])) {
                            $photo_id_list_array[$real_id] = array();
                        }

                        $photo_id_list_array[$real_id][] = $file->getFileId();
                    }

                    foreach ($photo_id_array as $key => $value) {
                        $file = $bot->getFile($value);
                        $qrcode_text = QRcode::decode('https://api.telegram.org/file/bot' . Config::get('telegram_token') . '/' . $file->getFilePath());

                        if ($qrcode_text == null) {
                            foreach ($photo_id_list_array[$key] as $fail_key => $fail_value) {
                                $fail_file = $bot->getFile($fail_value);
                                $qrcode_text = QRcode::decode('https://api.telegram.org/file/bot' . Config::get('telegram_token') . '/' . $fail_file->getFilePath());
                                if ($qrcode_text != null) {
                                    break;
                                }
                            }
                        }

                        if (strpos($qrcode_text, 'mod://bind/') === 0 && strlen($qrcode_text) == 27) {
                            $uid = TelegramSessionManager::verify_bind_session(substr($qrcode_text, 11));
                            if ($uid == 0) {
                                $reply['message'] = '绑定失败，二维码无效：' . substr($qrcode_text, 11) . '二维码的有效期为10分钟，请尝试刷新网站的“资料编辑”页面以更新二维码';
                                continue;
                            }
                            $user = User::where('id', $uid)->first();
                            $user->telegram_id = $message->getFrom()->getId();
                            $user->im_type = 4;
                            $user->im_value = $message->getFrom()->getUsername();
                            $user->save();
                            $reply['message'] = '绑定成功，邮箱：' . $user->email;
                            break;
                        }

                        if (strpos($qrcode_text, 'mod://login/') === 0 && strlen($qrcode_text) == 28) {
                            if ($user == null) {
                                $reply['message'] = '登录验证失败，您未绑定本站账号' . substr($qrcode_text, 12);
                                break;
                            }

                            $uid = TelegramSessionManager::verify_login_session(substr($qrcode_text, 12), $user->id);
                            if ($uid != 0) {
                                $reply['message'] = '登录验证成功，邮箱：' . $user->email;
                            } else {
                                $reply['message'] = '登录验证失败，二维码无效' . substr($qrcode_text, 12);
                            }
                            break;
                        }

                        break;
                    }
            }
            if ( $reply['message'] != null ) {
                $response = $bot->sendMessage($message->getChat()->getId(), $reply['message'], $parseMode = null, $disablePreview = false, $replyToMessageId = $reply_to, $replyMarkup = $reply['markup']);
            }
            
        } else {
            //群组
            if (Config::get('telegram_group_quiet') == 'true') {
                return;
            }
            switch ($command) {
                case 'ping':
                    $reply['message'] = 'Pong!这个群组的 ID 是 ' . $message->getChat()->getId() . '!';
                    break;
                case 'traffic':
                case 'checkin':
                case 'prpr':
                    $reply = self::needbind_method($bot, $message, $command, $user, $reply_to);
                    break;
                case 'rss':
                    $reply['message'] = '请私聊机器人使用该命令';
                    break;
                case 'help':
                    $reply['message'] = 'TG群不提供任何技术支持。需要专业的技术支持？请在网站提交工单。请勿将您的账号密码充值码分享给任何群成员，避免上当受骗，所以问题请提交工单。TG群仅做用户交流聊天使用，请保持友好礼貌。网站不为TG群行为负任何责任！    ';
                    break;
                case 'checkme':
                    $reply = self::needbind_method($bot, $message, $command, $user, $reply_to);
                    break;
                default:
                    $reply['message'] = null;
                /**
                    if ($message->getText() != null) {
                        if ($message->getChat()->getId() == Config::get('telegram_chatid')) {
                            $reply['message'] = Tuling::chat($message->getFrom()->getId(), $message->getText());
                        } else {
                            $reply['message'] = '不约，叔叔我们不约';
                        }
                    }
                **/
                    if ($message->getNewChatMember() != null && Config::get('enable_welcome_message') == 'true') {
                        $reply['message'] = '欢迎 光临' . $message->getNewChatMember()->getFirstName() . ' ' . $message->getNewChatMember()->getLastName();
                        $reply['message'] .= '这是一个公益站点，TG由用户代为管理，我们无偿为用户提供免费服务。TG群仅供用户聊天交流使用，请保持友好礼貌。禁聊友商，禁发友商aff，禁发广告。禁聊辱骂、宗教、轮子和反动信息。群里不允许人身攻击、不处理工单问题。您有什么建议，有什么意见，我们会在群里收集，你的意见未必会被采用，不过我们会认真考虑是否可行。如需要官方回复，请在网站提交工单。';
                    } else {
                        $reply['message'] = null;
                    }
                
            }
            if ( $reply['message'] != null ) {
                $bot->sendChatAction($message->getChat()->getId(), 'typing');
                $response = $bot->sendMessage($message->getChat()->getId(), '@'.$message->getFrom()->getUsername().' '.$message->getFrom()->getFirstName().' '.$message->getFrom()->getLastName().' 殿下 '.$reply['message'], $parseMode = null, $disablePreview = false, $replyToMessageId = $reply_to, $replyMarkup = $reply['markup']); #这里不再@用户消息，直接回复用户的名字和昵称
                # 删除 用户发的消息
                sleep(30);
                # 删除机器人的消息
                $bot->deleteMessage($message->getChat()->getId(),$message->getMessageId());
                $bot->deleteMessage($message->getChat()->getId(),$response->getMessageId());
            }
            
            //$bot->sendChatAction($message->getChat()->getId(), '');
            //删除消息
            //sleep(3);
            //
            //sleep(3);
            //$bot->deleteMessage($message->getChat()->getId(),$response->getMessageId());
        }
        
    }

    public static function process()
    {
        try {
            $bot = new Client(Config::get('telegram_token'));
            // or initialize with botan.io tracker api key
            // $bot = new \TelegramBot\Api\Client('YOUR_BOT_API_TOKEN', 'YOUR_BOTAN_TRACKER_API_KEY');

            $command_list = array('ping', 'traffic', 'help', 'prpr', 'checkin', 'rss', 'checkme' ,'bind' );
            foreach ($command_list as $command) {
                $bot->command($command, static function ($message) use ($bot, $command) {
                    TelegramProcess::telegram_process($bot, $message, $command);
                });
            }

            $bot->on($bot->getEvent(static function ($message) use ($bot) {
                TelegramProcess::telegram_process($bot, $message, '');
            }), static function () {
                return true;
            });

            $bot->on($bot->getCallbackQueryEvent(function ($callback) use ($bot) {
                TelegramProcess::callback_bind_method($bot, $callback);
            }), function () {
                return true;
            });

            $bot->run();
        } catch (Exception $e) {
            $e->getMessage();
        }
    }
}
