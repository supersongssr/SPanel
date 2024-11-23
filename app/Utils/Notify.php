<?php

namespace App\Utils;

use App\Services\Config;


Class Notify
{
    public static function Send($message)
    {
        $tg_url = Config::get('telegram_notify_url');
        $tg_chat_id = Config::get('telegram_notify_chat_id');
        $params = array(
            'chat_id' => $tg_chat_id,
            'text' => Config::get('telegram_notify_prefix').$message
           
        );

        echo "send to telegram: ".$message;

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $tg_url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $params);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $output = curl_exec($ch);
        if( $output === FALSE) {
            $error = curl_error($ch);
            echo "Curl Error: $error";
        }else{
            echo "curl output: $output";
        }
        curl_close($ch);
    }   
        
    
}   
