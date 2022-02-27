#how_To_Use

##what's new 新功能
````
2022-02-13 后端节点心跳包 nodeHidden改为 支持 节点 health 检查流量健康检查
2022-02-12 增加 后端上报 nodeHidden支持。
20220210 优化订阅链接，现在简洁清晰。
20220210 新增通知节点， 节点分组为0 的节点为 通知节点。
20220210 新增支持 vmess vless trojan 订阅支持
2020.4.23+ IOS订阅改为 mu=5
1 取消加密协议的自定义
2 独立节点订阅
3 独立节点显示
4 首页教程 
5 用户中心各页面展示
6 首页域名显示
7 订阅专用域名
8 登录弹窗提示
9 首页显示内容 增加新旧页面切换
10 主动关闭工单不再提示
````

## how to update
````
git fetch --all
git reset --hard origin/dev
git pull
````

##how to use
````
本Wiki参考于@zircon所写的[安装魔改前端](https://github.com/zyl6698/ss-panel-v3-mod-with-f2fpay/wiki/%E5%AE%89%E8%A3%85%E9%AD%94%E6%94%B9%E5%89%8D%E7%AB%AF)教程

### 安装面板程序

### 配置PHP( 宝塔用户 )

宝塔用户可能会在**超过某一数量节点**的时候出现 **`Undefined offset :0 in 你的网站路径`** 这个错误，
这个问题会导致后端无法进行连接，可以按照以下方法解决

在宝塔面板中找到php，点击设置

在**禁用函数**一栏找到 `system` `proc_open` `proc_get_status` `putenv`去除它

在**性能调整**中，把 PHP 运行模式设置为 **静态**

在**配置修改**中 按 Ctrl+F 搜索 `display_errors =` 改为 Off 后保存

![img](https://i.loli.net/2018/04/06/5ac64a16dbeaf.png)

web环境配置好后

```
cd /www/wwwroot/你的网站 
yum update
yum install git -y
git clone -b dev https://github.com/supersongssr/spanel.git tmp && mv tmp/.git . && rm -rf tmp && git reset --hard
chown -R root:root *
chmod -R 755 *
chown -R www:www storage
php composer.phar install
```
### 移除防跨目录移除工具(lnmp用户)

该工具可以快速的移除防跨目录的限制

`cd lnmp1.4/tools && ./remove_open_basedir_restriction.sh`

### 开启scandir()函数(lnmp用户)

`sed -i 's/,scandir//g' /usr/local/php/etc/php.ini`

###  伪静态

```
location / {
  try_files $uri $uri/ /index.php$is_args$args;
}
```
### 修改网站目录

```
/你的网站目录/public;
```

### 配置数据库

登陆数据库

```
mysql -u root -p                                       // 这里需要输入密码
mysql>CREATE DATABASE database_name;                   //新建数据库
mysql>use database_name;                               // 选择数据库
mysql>source /www/wwwroot/ssp-uim/sql/glzjin_all.sql;  // 导入.sql文件

```

### 配置 sspanel

```
cd /网站目录
cp config/.config.php.example config/.config.php
vi config/.config.php
lnmp restart
```

### 创建管理员并同步用户

```
php xcat createAdmin          //创建管理员
php xcat syncusers            //同步用户
php xcat initQQWry            //下载IP解析库
php xcat resetTraffic         //重置流量
php xcat initdownload         //下载ssr程式
```

### 设置定时任务

执行 crontab -e命令, 添加以下四条

```
22 4 * * * php /www/wwwroot/spanel/xcat sendDiaryMail
58 3 * * * php -n /www/wwwroot/spanel/xcat dailyjob
17 */3 * * * php /www/wwwroot/spanel/xcat checkjob
###*/12 * * * * php /www/wwwroot/spanel/xcat syncnode  #这个要不得，然后网站会出大问题的！主要是V2节点的IP会被重置！
```
如果需要自动备份，可模仿以下两例，自行添加一条
```
例1：每20分钟备份1次（若间隔大于60分钟，看例2）：
*/20 * * * * php -n /网站目录/xcat backup

例2：每20小时备份1次（若间隔大于24小时，自行Google）：
0 */20 * * * php -n /网站目录/xcat backup
```
如果需要财务报表，可选添加以下三条
```
5 0 * * * php /网站目录/xcat sendFinanceMail_day
6 0 * * 0 php /网站目录/xcat sendFinanceMail_week
7 0 1 * * php /网站目录/xcat sendFinanceMail_month
```
如果需要检测被墙，添加以下一条
```
*/1 * * * * php /网站目录/xcat detectGFW
```
如果要用到radius，需要添加下面这三条
```
*/1 * * * * php /网站目录/xcat synclogin
*/1 * * * * php /网站目录/xcat syncvpn
*/1 * * * * php -n /网站目录/xcat syncnas
```
````