-- phpMyAdmin SQL Dump
-- version 4.4.15.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: 2016-04-28 21:58:13
-- 服务器版本： 5.5.48-log
-- PHP Version: 5.6.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `glzjin_ss2`
--

-- --------------------------------------------------------

--
-- 表的结构 `alive_ip`
--

CREATE TABLE IF NOT EXISTS `alive_ip` (
  `id` bigint(20) NOT NULL,
  `nodeid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `ip` text NOT NULL,
  `datetime` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `announcement`
--

CREATE TABLE IF NOT EXISTS `announcement` (
  `id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `blockip`
--

CREATE TABLE IF NOT EXISTS `blockip` (
  `id` bigint(20) NOT NULL,
  `nodeid` int(11) NOT NULL,
  `ip` text NOT NULL,
  `datetime` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `code`
--

CREATE TABLE IF NOT EXISTS `code` (
  `id` bigint(20) NOT NULL,
  `code` text NOT NULL,
  `type` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `isused` int(11) NOT NULL DEFAULT '0',
  `userid` bigint(20) NOT NULL,
  `usedatetime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `link`
--

CREATE TABLE IF NOT EXISTS `link` (
  `id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `address` text NOT NULL,
  `port` int(11) NOT NULL,
  `token` text NOT NULL,
  `ios` int(11) NOT NULL DEFAULT '0',
  `userid` bigint(20) NOT NULL,
  `isp` text,
  `geo` int(11) DEFAULT NULL,
  `method` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `login_ip`
--

CREATE TABLE IF NOT EXISTS `login_ip` (
  `id` bigint(20) NOT NULL,
  `userid` bigint(20) NOT NULL,
  `ip` text NOT NULL,
  `datetime` bigint(20) NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `radius_ban`
--

CREATE TABLE IF NOT EXISTS `radius_ban` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------


--
-- 表的结构 `speedtest`
--

CREATE TABLE IF NOT EXISTS `speedtest` (
  `id` bigint(20) NOT NULL,
  `nodeid` int(11) NOT NULL,
  `datetime` bigint(20) NOT NULL,
  `telecomping` text NOT NULL,
  `telecomeupload` text NOT NULL,
  `telecomedownload` text NOT NULL,
  `unicomping` text NOT NULL,
  `unicomupload` text NOT NULL,
  `unicomdownload` text NOT NULL,
  `cmccping` text NOT NULL,
  `cmccupload` text NOT NULL,
  `cmccdownload` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `ss_invite_code`
--

CREATE TABLE IF NOT EXISTS `ss_invite_code` (
  `id` int(11) NOT NULL,
  `code` varchar(128) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT '2016-06-01 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `ss_node`
--

CREATE TABLE IF NOT EXISTS `ss_node` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `type` int(3) NOT NULL COMMENT '节点是否启用1 启用 0 不启用 ，有毛病的参数', 
  `server` varchar(500) NOT NULL,
  `method` varchar(64) NOT NULL,
  `info` varchar(128) NOT NULL,
  `status` varchar(128) NOT NULL,
  `sort` int(3) NOT NULL COMMENT '节点类型，真的是有毛病的参数',
  `custom_method` tinyint(1) NOT NULL DEFAULT '0',
  `traffic_rate` float NOT NULL DEFAULT '1',
  `node_class` int(11) NOT NULL DEFAULT '0',
  `node_speedlimit` int(11) NOT NULL DEFAULT '0',
  `node_connector` int(11) NOT NULL DEFAULT '0',
  `node_bandwidth` bigint(20) NOT NULL DEFAULT '0',
  `node_bandwidth_limit` bigint(20) NOT NULL DEFAULT '0',
  `bandwidthlimit_resetday` int(11) NOT NULL DEFAULT '0',
  `node_heartbeat` bigint(20) NOT NULL DEFAULT '0',
  `node_ip` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `ss_node_info`
--

CREATE TABLE IF NOT EXISTS `ss_node_info` (
  `id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `uptime` float NOT NULL,
  `load` varchar(32) NOT NULL,
  `log_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `ss_node_online_log`
--

CREATE TABLE IF NOT EXISTS `ss_node_online_log` (
  `id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `online_user` int(11) NOT NULL,
  `log_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `ss_password_reset`
--

CREATE TABLE IF NOT EXISTS `ss_password_reset` (
  `id` int(11) NOT NULL,
  `email` varchar(32) NOT NULL,
  `token` varchar(128) NOT NULL,
  `init_time` int(11) NOT NULL,
  `expire_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 表的结构 `unblockip`
--

CREATE TABLE IF NOT EXISTS `unblockip` (
  `id` bigint(20) NOT NULL,
  `ip` text NOT NULL,
  `datetime` bigint(20) NOT NULL,
  `userid` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL,
  `user_name` varchar(128) CHARACTER SET utf8mb4 NOT NULL,
  `email` varchar(32) NOT NULL,
  `pass` varchar(64) NOT NULL,
  `passwd` varchar(16) NOT NULL,
  `t` int(11) NOT NULL DEFAULT '0',
  `u` bigint(20) NOT NULL,
  `d` bigint(20) NOT NULL,
  `plan` varchar(2) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'A',
  `transfer_enable` bigint(20) NOT NULL,
  `port` int(11) NOT NULL,
  `switch` tinyint(4) NOT NULL DEFAULT '1',
  `enable` tinyint(4) NOT NULL DEFAULT '1',
  `type` tinyint(4) NOT NULL DEFAULT '1',
  `last_get_gift_time` int(11) NOT NULL DEFAULT '0',
  `last_check_in_time` int(11) NOT NULL DEFAULT '0',
  `last_rest_pass_time` int(11) NOT NULL DEFAULT '0',
  `reg_date` datetime NOT NULL,
  `invite_num` int(8) NOT NULL,
  `money` decimal(12,2) NOT NULL,
  `ref_by` int(11) NOT NULL DEFAULT '0',
  `expire_time` int(11) NOT NULL DEFAULT '0',
  `method` varchar(64) NOT NULL DEFAULT 'rc4-md5',
  `is_email_verify` tinyint(4) NOT NULL DEFAULT '0',
  `reg_ip` varchar(128) NOT NULL DEFAULT '127.0.0.1',
  `node_speedlimit` text NOT NULL,
  `node_connector` int(11) NOT NULL DEFAULT '0',
  `is_admin` int(2) NOT NULL DEFAULT '0',
  `im_type` int(11) DEFAULT '1',
  `im_value` text,
  `last_day_t` bigint(20) NOT NULL DEFAULT '0',
  `sendDailyMail` int(11) NOT NULL DEFAULT '0',
  `class` int(11) NOT NULL DEFAULT '0',
  `class_expire` datetime NOT NULL DEFAULT '1989-06-04 00:05:00',
  `expire_in` datetime NOT NULL DEFAULT '2099-06-04 00:05:00',
  `theme` text NOT NULL,
  `ga_token` text NOT NULL,
  `ga_enable` int(11) NOT NULL DEFAULT '0',
  `pac` longtext,
  `remark` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `user_token`
--

CREATE TABLE IF NOT EXISTS `user_token` (
  `id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  `expire_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `user_traffic_log`
--

CREATE TABLE IF NOT EXISTS `user_traffic_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `u` int(11) NOT NULL,
  `d` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `rate` float NOT NULL,
  `traffic` varchar(32) NOT NULL,
  `log_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alive_ip`
--
ALTER TABLE `alive_ip`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `announcement`
--
ALTER TABLE `announcement`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `blockip`
--
ALTER TABLE `blockip`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `code`
--
ALTER TABLE `code`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `link`
--
ALTER TABLE `link`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login_ip`
--
ALTER TABLE `login_ip`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `radius_ban`
--
ALTER TABLE `radius_ban`
  ADD PRIMARY KEY (`id`);


--
-- Indexes for table `speedtest`
--
ALTER TABLE `speedtest`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ss_invite_code`
--
ALTER TABLE `ss_invite_code`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `ss_node`
--
ALTER TABLE `ss_node`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ss_node_info`
--
ALTER TABLE `ss_node_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ss_node_online_log`
--
ALTER TABLE `ss_node_online_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ss_password_reset`
--
ALTER TABLE `ss_password_reset`
  ADD PRIMARY KEY (`id`);


--
-- Indexes for table `unblockip`
--
ALTER TABLE `unblockip`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_name` (`user_name`),
  ADD KEY `uid` (`id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `user_token`
--
ALTER TABLE `user_token`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_traffic_log`
--
ALTER TABLE `user_traffic_log`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alive_ip`
--
ALTER TABLE `alive_ip`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `announcement`
--
ALTER TABLE `announcement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `blockip`
--
ALTER TABLE `blockip`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `code`
--
ALTER TABLE `code`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `link`
--
ALTER TABLE `link`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `login_ip`
--
ALTER TABLE `login_ip`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `radius_ban`
--
ALTER TABLE `radius_ban`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `speedtest`
--
ALTER TABLE `speedtest`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ss_invite_code`
--
ALTER TABLE `ss_invite_code`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ss_node`
--
ALTER TABLE `ss_node`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ss_node_info`
--
ALTER TABLE `ss_node_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ss_node_online_log`
--
ALTER TABLE `ss_node_online_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ss_password_reset`
--
ALTER TABLE `ss_password_reset`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
--
-- AUTO_INCREMENT for table `unblockip`
--
ALTER TABLE `unblockip`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `user_token`
--
ALTER TABLE `user_token`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `user_traffic_log`
--
ALTER TABLE `user_traffic_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- phpMyAdmin SQL Dump
-- version 4.4.15.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: 2016-04-28 21:59:55
-- 服务器版本： 5.5.48-log
-- PHP Version: 5.6.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `glzjin_ss2`
--

-- --------------------------------------------------------

--
-- 表的结构 `ss_node`
--

CREATE TABLE IF NOT EXISTS `ss_node` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `type` int(3) NOT NULL COMMENT '1显示 0不显示 是否显示节点',
  `server` varchar(128) NOT NULL,
  `method` varchar(64) NOT NULL,
  `info` varchar(128) NOT NULL,
  `status` varchar(128) NOT NULL,
  `sort` int(3) NOT NULL,
  `custom_method` tinyint(1) NOT NULL DEFAULT '0',
  `traffic_rate` float NOT NULL DEFAULT '1',
  `node_class` int(11) NOT NULL DEFAULT '0',
  `node_speedlimit` int(11) NOT NULL DEFAULT '0',
  `node_connector` int(11) NOT NULL DEFAULT '0',
  `node_bandwidth` bigint(20) NOT NULL DEFAULT '0',
  `node_bandwidth_limit` bigint(20) NOT NULL DEFAULT '0',
  `bandwidthlimit_resetday` int(11) NOT NULL DEFAULT '0',
  `node_heartbeat` bigint(20) NOT NULL DEFAULT '0',
  `node_ip` text
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4;

--
-- 转存表中的数据 `ss_node`
--

INSERT INTO `ss_node` (`id`, `name`, `type`, `server`, `method`, `info`, `status`, `sort`, `custom_method`, `traffic_rate`, `node_class`, `node_speedlimit`, `node_connector`, `node_bandwidth`, `node_bandwidth_limit`, `bandwidthlimit_resetday`, `node_heartbeat`, `node_ip`) VALUES
(NULL, '统一验证登陆', 0, 'zhaojin97.cn', 'radius', '统一登陆验证', '可用', 999, 0, 1, 0, 0, 0, 0, 0, 0, 0, ''),
(NULL, 'VPN 统一流量结算', 0, 'zhaojin97.cn', 'radius', 'VPN 统一流量结算', '可用', 999, 0, 1, 0, 0, 0, 0, 0, 0, 0, NULL);


ALTER TABLE `user` ADD `node_group` INT NOT NULL DEFAULT '0' AFTER `remark`;
ALTER TABLE `ss_node` ADD `node_group` INT NOT NULL DEFAULT '0' AFTER `node_ip`;




CREATE TABLE `payback` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `total` DECIMAL(12,2) NOT NULL , `userid` BIGINT NOT NULL , `ref_by` BIGINT NOT NULL , `ref_get` DECIMAL(12,2) NOT NULL , `datetime` BIGINT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
CREATE TABLE `shop` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `name` TEXT NOT NULL , `price` DECIMAL(12,2) NOT NULL , `content` TEXT NOT NULL , `auto_renew` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
CREATE TABLE `coupon` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `code` TEXT NOT NULL , `onetime` INT NOT NULL , `expire` BIGINT NOT NULL , `shop` TEXT NOT NULL , `credit` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
CREATE TABLE `bought` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `userid` BIGINT NOT NULL , `shopid` BIGINT NOT NULL , `datetime` BIGINT NOT NULL , `renew` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

ALTER TABLE `bought` ADD `coupon` TEXT NOT NULL AFTER `renew`, ADD `price` DECIMAL(12,2) NOT NULL AFTER `coupon`;



ALTER TABLE `bought` CHANGE `renew` `renew` BIGINT(11) NOT NULL;

ALTER TABLE `announcement` ADD `markdown` LONGTEXT NOT NULL AFTER `content`;

ALTER TABLE `announcement` CHANGE `content` `content` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;

CREATE TABLE `ticket` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `title` LONGTEXT NOT NULL , `content` LONGTEXT NOT NULL , `rootid` BIGINT NOT NULL , `userid` BIGINT NOT NULL , `datetime` BIGINT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

ALTER TABLE `ticket` ADD `status` INT NOT NULL DEFAULT '1' AFTER `datetime`;

ALTER TABLE `shop` ADD `status` INT NOT NULL DEFAULT '1' AFTER `auto_renew`;

ALTER TABLE `user` ADD `auto_reset_day` INT NOT NULL DEFAULT '0' AFTER `node_group`, ADD `auto_reset_bandwidth` DECIMAL(12,2) NOT NULL DEFAULT '0.00' AFTER `auto_reset_day`;

ALTER TABLE `shop` ADD `auto_reset_bandwidth` INT NOT NULL DEFAULT '0' AFTER `auto_renew`;

ALTER TABLE `code` CHANGE `number` `number` DECIMAL(11,2) NOT NULL;

CREATE TABLE `auto` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `type` INT NOT NULL , `value` LONGTEXT NOT NULL , `datetime` BIGINT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;


ALTER TABLE `auto` ADD `sign` LONGTEXT NOT NULL AFTER `value`;ALTER TABLE `user` ADD `relay_enable` INT NOT NULL DEFAULT '0' AFTER `auto_reset_bandwidth`, ADD `relay_info` LONGTEXT NULL AFTER `relay_enable`;
ALTER TABLE `ss_node` ADD `custom_rss` INT NOT NULL DEFAULT '0' COMMENT '是否支持用户订阅' AFTER `node_group`;

ALTER TABLE `user` ADD `protocol` VARCHAR(128) NOT NULL DEFAULT 'origin' AFTER `relay_info`, ADD `protocol_param` VARCHAR(128) NULL DEFAULT NULL AFTER `protocol`, ADD `obfs` VARCHAR(128) NOT NULL DEFAULT 'plain' AFTER `protocol_param`, ADD `obfs_param` VARCHAR(128) NULL DEFAULT NULL AFTER `obfs`;



ALTER TABLE `user` ADD `forbidden_ip` LONGTEXT NULL DEFAULT '' AFTER `obfs_param`, ADD `forbidden_port` LONGTEXT NULL DEFAULT '' AFTER `forbidden_ip`, ADD `disconnect_ip` LONGTEXT NULL DEFAULT '' AFTER `forbidden_port`;

CREATE TABLE `disconnect_ip` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `userid` BIGINT NOT NULL , `ip` TEXT NOT NULL , `datetime` BIGINT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;
ALTER TABLE `user` CHANGE `node_speedlimit` `node_speedlimit` DECIMAL(12,2) NOT NULL DEFAULT '0.00';

ALTER TABLE `ss_node` CHANGE `node_speedlimit` `node_speedlimit` DECIMAL(12,2) NOT NULL DEFAULT '0.00';

ALTER TABLE `user`
  DROP `relay_enable`,
  DROP `relay_info`;
ALTER TABLE `user` CHANGE `protocol` `protocol` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'origin', CHANGE `obfs` `obfs` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'plain';
CREATE TABLE `email_verify` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `email` TEXT NOT NULL , `ip` TEXT NOT NULL , `code` TEXT NOT NULL , `expire_in` BIGINT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;ALTER TABLE `user` ADD `is_hide` INT NOT NULL DEFAULT '0' AFTER `disconnect_ip`;


CREATE TABLE `detect_list` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `name` LONGTEXT NOT NULL , `text` LONGTEXT NOT NULL , `regex` LONGTEXT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

CREATE TABLE `detect_log` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `user_id` BIGINT NOT NULL , `list_id` BIGINT NOT NULL , `datetime` BIGINT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

ALTER TABLE `detect_list` ADD `type` INT NOT NULL AFTER `regex`;

ALTER TABLE `detect_log` ADD `node_id` INT NOT NULL AFTER `datetime`;


ALTER TABLE `user` ADD `is_multi_user` INT NOT NULL DEFAULT '0' AFTER `is_hide`;

ALTER TABLE `ss_node` ADD `mu_only` INT NULL DEFAULT '0' AFTER `custom_rss`;

CREATE TABLE IF NOT EXISTS `relay` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `source_node_id` bigint(20) NOT NULL,
  `dist_node_id` bigint(20) NOT NULL,
  `dist_ip` text NOT NULL,
  `port` int(11) NOT NULL,
  `priority` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `relay`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `relay`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
CREATE TABLE `telegram_session` ( `id` BIGINT NOT NULL AUTO_INCREMENT , `user_id` BIGINT NOT NULL , `type` INT NOT NULL , `session_content` TEXT NOT NULL , `datetime` BIGINT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;

ALTER TABLE `user` ADD `telegram_id` BIGINT NULL AFTER `is_multi_user`;

CREATE TABLE IF NOT EXISTS `paylist` (
  `id` bigint(20) NOT NULL,
  `userid` bigint(20) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `tradeno` text,
  `datetime` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `paylist`
--
ALTER TABLE `paylist`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `paylist`
--
ALTER TABLE `paylist`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;ALTER TABLE `user_traffic_log` CHANGE `u` `u` BIGINT(20) NOT NULL, CHANGE `d` `d` BIGINT(20) NOT NULL;


# 增加节点的服务器成本 参数
ALTER TABLE `ss_node` ADD `node_cost` INT NOT NULL DEFAULT '5' AFTER `mu_only`;
#增加 在线人数选项
ALTER TABLE `ss_node` ADD `node_online` INT NOT NULL DEFAULT '1' AFTER `node_cost`;
#增加 性价比选项
ALTER TABLE `ss_node` ADD `node_oncost` FLOAT NOT NULL DEFAULT '0' AFTER `node_online`;

#增加用户 ban_times
ALTER TABLE `user` ADD `ban_times` INT NOT NULL DEFAULT '0' AFTER `telegram_id`;

#增加用户自定义获取节点数量功能
ALTER TABLE `user` ADD `sub_limit` INT NOT NULL DEFAULT '16' AFTER `ban_times`;

#主动增加UUID
ALTER TABLE `user` ADD `v2ray_uuid` VARCHAR(64) DEFAULT NULL AFTER `passwd`;

# 增加一个 CNCDN的表，用来放置那个  百度云加速的 ip段

--
-- 表的结构 `cncdn`
--

CREATE TABLE IF NOT EXISTS `cncdn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `area` varchar(128) NOT NULL COMMENT '地区',
  `areaid` varchar(128) NOT NULL COMMENT '地区的编号',
  `server` varchar(64) NOT NULL COMMENT 'cdn域名',
  `cdnip` varchar(64) NOT NULL COMMENT 'CDN地区的ip',
  `ipmd5` varchar(64) NOT NULL COMMENT 'ip的md5值，方便做域名解析',
  `host` varchar(64) NOT NULL COMMENT '解析的域名',
  `show` int(11) NOT NULL Default '1' COMMENT '是否用户页面展示',
  `status` int(11) NOT NULL Default '1' COMMENT '是否启用 1为启用 0为不启用',
  primary key (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

#在用户信息那里，增加一个 cncdn 的项 和 cfcdn 的项目 以及一个 subip 的选项，用来收集用户的订阅来源ip，这个很重要。
# 最好是再收集一下用户的ip，这个可以有。
ALTER TABLE `user` ADD `rss_ip` VARCHAR(64) DEFAULT NULL COMMENT '订阅ip' AFTER `sub_limit`;
ALTER TABLE `user` ADD `cncdn` VARCHAR(64) DEFAULT '0' COMMENT 'CN自选入口' AFTER `rss_ip`;
ALTER TABLE `user` ADD `cncdn_count` VARCHAR(64) DEFAULT '0' COMMENT 'CN次数统计' AFTER `cncdn`;
ALTER TABLE `user` ADD `cfcdn` VARCHAR(64) DEFAULT '0' COMMENT 'CF自选ip' AFTER `cncdn_count`;
ALTER TABLE `user` ADD `cfcdn_count` VARCHAR(64) DEFAULT '0' COMMENT 'CF次数统计' AFTER `cfcdn`;

# 增加是否edu用户的选项
ALTER TABLE `user` ADD `is_edu` VARCHAR(64) DEFAULT '0' COMMENT 'EDU用户' AFTER `last_day_t`;

#工单页面增加了一个排序选项
ALTER TABLE `ticket` ADD `sort` INT(11) DEFAULT '0' COMMENT '用户等级排序' AFTER `userid`;

# 增加 node_bandwidth_lastday 昨天
ALTER TABLE `ss_node` ADD `node_bandwidth_lastday` BIGINT(20) DEFAULT '0' COMMENT '节点昨日流量记录' AFTER `node_bandwidth`;

# 增加两个项，一个是每天的流量限制项。超过就会被限制。 另一个是 累加项， 如果达到一定数值，就会被 累加。
ALTER TABLE `user` ADD `renew` FLOAT(8) DEFAULT '0' COMMENT '流量周期累加' AFTER `class`;
ALTER TABLE `user` ADD `transfer_limit` BIGINT(20) DEFAULT '1073741824' COMMENT '流量限制 默认为 1G' AFTER `transfer_enable`;

# node 增加 到期时间 和 节点的 排序选项，按照错误的次数排序 这个还是可以的。因为倍率可能变得不再重要了。 因为倍率变稳定了。
ALTER TABLE `ss_node` ADD `node_sort` INT(11) DEFAULT '0' COMMENT '节点故障排序' AFTER `node_oncost`;
-- ALTER TABLE `ss_node` ADD `node_date` INT(11) DEFAULT '0' COMMENT '节点到期时间 ' AFTER `node_sort`;


# user 增加用户打分表 score ，用来判断用户是否会被清理掉
ALTER TABLE `user` ADD `score` INT(8) DEFAULT '0' COMMENT '用户打分' AFTER `ref_by`;

#增加 CNCDN选项
ALTER TABLE `ss_node` ADD `cncdn` TINYINT(4) AFTER `server`;

#增加 rss订阅次数统计
ALTER TABLE `user` ADD `rss_count` INT(11) DEFAULT '0' COMMENT 'Rss次数统计' AFTER `rss_ip`;
ALTER TABLE `user` ADD `rss_count_lastday` INT(11) DEFAULT '0' COMMENT 'Rss昨日次数' AFTER `rss_count`;

#增加 用户 warming 消息
ALTER TABLE `user` ADD `warming` TEXT COMMENT '警告消息' AFTER `cfcdn_count`;

#payback 增加字段，显示此返利是否被收回 1是收回
ALTER TABLE `payback`  ADD `callback` INT(8) COMMENT '返利是否被收回 1是收回了 3=邀请人已删除 0=返利还没被收回' AFTER `ref_get`;

#增加 rss订阅次数统计
ALTER TABLE `user` ADD `rss_ips_count` INT(11) DEFAULT '0' COMMENT 'RssIp来源统计' AFTER `rss_count_lastday`;
ALTER TABLE `user` ADD `rss_ips_lastday` INT(11) DEFAULT '0' COMMENT 'Rss昨日Ip来源次数' AFTER `rss_ips_count`;