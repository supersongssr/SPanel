<template>
    <div class="title pure-g">
        <div class="pure-u-1 pure-u-xl-1-2 title-left">
            <h1>{{routermsg.appname}}</h1>
            <span>邀请好友送5￥/人，64G流量/次；被邀请人送3￥；<br>永久免费1-3M带宽；签到送1-5G流量/天</span>
            <router-link class="button-index" to="/auth/login">登录</router-link>
            <router-link class="button-index" to="/auth/register">注册</router-link>
            <a class="button-index" href="/indexold">旧版首页</a>
            <router-link class="button-index" to="/user/panel">用户中心</router-link>
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
