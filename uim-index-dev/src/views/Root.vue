<template>
    <div class="title pure-g">
        <div class="pure-u-1 pure-u-xl-1-2 title-left">
            <h1>{{routermsg.appname}}</h1>
            <span>邀请返利5-15￥/人 + 32G流量/次 + 20%消费提成;<br>100+全球节点,10000M国际宽带;<br>网速10-100Mbps</span>
            <router-link class="button-index" to="/auth/login">登录</router-link>
            <!-- <router-link class="button-index" to="/auth/register">注册</router-link> -->
            <!-- <a class="button-index" href="/auth/login">登陆</a>-->
            <a class="button-index" href="/auth/register">注册</a> 
            <a class="button-index" href="/user">用户中心</a>
            <router-link class="button-index" to="/user/panel">快速预览</router-link>
        </div>
        <div class="pure-u-xl-1-2 logo-bg">
            <img src="/images/logo_white.png" alt="" class="logo">
        </div>
    </div>
</template>
<script>
export default {
  props: ['routermsg']
}
</script>
