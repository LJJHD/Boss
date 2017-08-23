//
//  JHUrl.h
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#ifndef JHUrl_h
#define JHUrl_h

/**
 服务器环境 废弃
 **/
#define JH_IP @"http://192.168.1.200:8042"

static inline NSString * JHBaseServiceURL(){
#if JHISOFFLINE
    return @"http://192.168.1.200:8042";
#else
    return @"onlineService";
#endif
}

static inline NSString * JHBaseServiceVersion(){
    return @"v1";
}

typedef NS_ENUM(NSUInteger, JH_Service_Environment) {
    JH_Service_Environment_Dev,
    JH_Service_Environment_Test,
    JH_Service_Environment_Online,
    JH_Service_Environment_Https,
    JH_Service_Environment_ABTest,//灰度环境
};

/**
 切换线路环境 
 **/
const static JH_Service_Environment jH_Service_Environment = JH_Service_Environment_Test;

#define JH_REQUEST_SUCCESS  0  //0代表成功

#define NETWORK_CONNECTION_STAT   ([JHReachabilityManager reachabilityForInternetConnection].currentReachabilityStatus)

/**
 当前 baseurl
 **/
#define JH_HTTP_IP  ([JH_HttpService shareInstance].baseServerUrl)

/**
 当前IM baseurl
 **/
#define JH_IM_IP  ([JH_HttpService shareInstance].baseIMServerUrl)

/**
 当前登录 忘记密码 baseurl
 **/
#define JH_Login_IP  ([JH_HttpService shareInstance].baseLoginServerUrl)

/**
 图片上传
 **/
#define JH_UploadPicture_IP  ([JH_HttpService shareInstance].baseUploadPictureServerUrl)
/**
 获取广告IP
 **/
#define JH_AD_IP ([JH_HttpService shareInstance].baseAdServerUrl)
/**
 获取打赏金额IP basePayOrderServerUrl
 **/
#define JH_Reward_IP ([JH_HttpService shareInstance].baseRewardMoneyServerUrl)

/**
 微信获取统一下单IP  baseAlipayOrderServerUrl
 **/
#define JH_PayOrder_IP ([JH_HttpService shareInstance].basePayOrderServerUrl)

/**
 阿里获取统一下单IP
 **/
#define JH_AlipayOrder_IP ([JH_HttpService shareInstance].baseAlipayOrderServerUrl)
/**
 钱包充值和购买短信IP
 **/
#define JH_WalletOrBuyNote_IP ([JH_HttpService shareInstance].baseWalletOrBuyNoteServerUrl)


/**
 *  获取App版本信息
 */
#define JH_API_APP_VERSION              @"/merchant/uprade/api/app/version"

#define JH_IsShow_appreciationURL   @"/jinghan-boss/api/boss/v1/notice/reviwe"

/**
 钱包充值和购买短信生成订单接口
 **/
#define JH_WalletOrBuyURL @"/merchant/merchantMessageRecharge/api/all/generateTradeInfoOrder"

/**
 打赏金额
 **/
#define JH_rewardMoneyListURL @"/jinghan-reward/bountys"
/**
 打赏订单号
 **/
#define JH_rewardMoneyURL @"/jinghan-reward/rewards/boss"

/**
 微信统一支付接口
 **/
#define JH_WXPayURL @"/jinghan-payment/api/wx/wxUnifiedOrder"

/**
 微信支付结果查询接口
 **/
#define JH_WXPayResultQueryURL @"/jinghan-payment/api/wx/payOrder/query"
/**
 阿里统一支付接口
 **/
#define JH_AlipayURL @"/jinghan-payment/api/ali/appPay"
/**
 阿里支付结果校验接口
 **/
#define JH_AlipayResultCheckout @"/jinghan-payment/api/ali/appPay/result/validate"
/**
 广告
 **/
#define JH_ADURL @"/advert/queryAdvert.shtml"

/**
 上传registrationid 用于极光推送
 **/
#define JH_UploadRegistrationid @"/jinghan-boss/api/boss/v1/registrationId"
/**
 上传文件
 
 /jinghan-fastdfs/index.shtml
 **/
#define JH_API_UPLOADFILE @"/jinghan-fastdfs/fdfs/upload.shtml"

/**
 更换头像
 **/
#define JH_API_ChangeUserIcon @"/jinghan-account/api/user/picture/insertUserPicture"


/**
 *  图片加载主机地址
 */
#define JH_loadPictureIP @"http://192.168.2.9:9000/"

/**
 登陆 密码登录
 **/
#define  JH_API_lOGINDv   @"/jinghan-account/api/user/login"

/**
 登陆   验证码登录
 **/
#define  JH_API_lOGIN   @"/jinghan-account/api/user/bossLogin"

/**
 退出登陆
 **/
#define JH_API_quiteLogin @"/jinghan-account/api/user/logout"
/**
 忘记密码，修改密码
 **/
#define JH_API_ForgetPwd @"/jinghan-account/api/user/resetPwd"


/**
 获取验证码 sendSmsCode
 **/
#define jh_API_getVerificationCode @"/jinghan-account/api/user/sendSmsCodeByMerchant"
/**
 判断验证码是否合法
 **/
#define jh_API_JudgeNote @"/jinghan-vendor/vendor/verify/code"

/**
 店铺管理URL
 **/

//获取所有店铺
#define jh_getAllShopListURL @"/jinghan-boss/api/boss/v1/getMyRestaurants"

//菜单查看
#define jh_dishesListURL  @"/jinghan-boss/api/boss/v1/getDishesGroupList"
//订单列表
#define jh_orderListURL   @"/jinghan-boss/api/boss/v1/getOrderList"

//订单详情
#define JH_OrderDetailURL @"/jinghan-boss/api/boss/v1/getOrderDetail"

//提交待支付订单减免
#define JH_orderMangerUrl @"/jinghan-boss/api/boss/v1/postOrderDiscount"

//获取桌台列表
#define  JH_tableListURL  @"/jinghan-boss/api/boss/v1/getTableGroupList"
//获取桌台类型列表
#define JH_tableTypeListURL @"/jinghan-boss/api/boss/v1/getTableTypeList"
//v1.1
//获取所有分店排行
#define JH_getAllRestRangking @"/jinghan-boss/api/boss/v1/getBranchList"
//获取分店排行条件
#define JH_AllRestRangkingCondition @"/jinghan-boss/api/boss/v1/getConditions"


/**
 员工管理URL
 **/

//获取员工管理--餐厅对应得部门
#define JH_StaffManagerSectionURL @"/jinghan-boss/api/boss/v1/getDepartmentList"

//获取所有餐厅部门分组
#define JH_restSectionURL @"/jinghan-boss/api/boss/v1/getClassifyList"

//添加餐厅部门分组
#define JH_addRestSectionURL  @"/jinghan-boss/api/boss/v1/postAddClassify"

//编辑餐厅部门分组
#define JH_EditClassification @"/jinghan-boss/api/boss/v1/postEditClassify"

//修改餐厅部门分组
#define JH_ModifyStaffSectionURL @"/jinghan-boss/api/boss/v1/postModifyStaffGroup"

//餐厅员工排序
#define JH_restStaffSortURL @"/jinghan-boss/api/boss/v1/staffSort"

//删除餐厅部门分组
#define JH_DeleteClassification @"/jinghan-boss/api/boss/v1/postDelClassify"

//员工详情
#define  JH_StaffDetailsURL @"/jinghan-boss/api/boss/v1/getStaffDetail"

//员工收到的打赏列表
#define JH_StaffGratutyListURL @"/jinghan-boss/api/boss/v1/getRecRewardList"

//员工备注
#define JH_StaffRemarkUrl @"/jinghan-boss/api/boss/v1/postStaffRemarks"

//更多员工评价
#define JH_MoreStaffEvaluate @"/jinghan-boss/api/boss/v1/getMoreEvaluationList"

//员工排行接口v1.1
#define JH_StaffRangkingURL @"/jinghan-boss/api/boss/v1/staffs"
//员工排行条件
#define JH_StaffRangkingConditionURL @"/jinghan-boss/api/boss/v1/staffs/sort/conditions"

/**
 homePage
 **/

// 首页模块新消息 v1.0 getHomeFunctions    v1.1 /notice/unreadNum
#define JH_HomeFunctions @"/jinghan-boss/api/boss/v1/notice/unreadNum"
// 我的餐厅1.1  getMyRestaurants(1.0)
#define JH_MyRestaurant @"/jinghan-boss/api/boss/v1/getBranchDetail"
//v1.1 首页餐厅运营数据
#define JH_BasicDataList @"/jinghan-boss/api/boss/v1/getMerchantDetail"
// 更改首页数据列表顺序
#define JH_UpdateDataSort @"/jinghan-boss/api/boss/v1/updateDataSort"
// 获取菜品列表 v1.1
#define JH_GetDishesList @"/jinghan-boss/api/boss/v1/dish/list"
//获取菜品排序条件接口V1.1
#define JH_DishListCondition @"/jinghan-boss/api/boss/v1/dish/sort/conditions"
// 获取数据详情
#define JH_DataDetailsInfo @"/jinghan-boss/api/boss/v1/getDataDetailsInfo"
// 获取菜品详情v1.1
#define JH_DishesDetailsInfo @"/jinghan-boss/api/boss/v1/dish/time"
// 获取体检结果
#define JH_StoreTestInfo @"/jinghan-boss/api/boss/v1/getStoreTestInfo"
// 获取通知列表getNoticeList  v1.1修改notice/list
#define JH_NoticeList @"/jinghan-boss/api/boss/v1/notice/list"
//修改通知状态
#define JH_modificationNoticeStaute @"/jinghan-boss/api/boss/v1/notice/status/update"
// 清空通知列表(setNoticeEmpty 1.0) v1.1 notice/clear
#define JH_SetNoticeEmpty @"/jinghan-boss/api/boss/v1/notice/clear"
// 获取数据异常
#define JH_GetExceptional @"/jinghan-boss/api/boss/v1/getExceptional"
// 设置数据异常
#define JH_SetExceptional @"/jinghan-boss/api/boss/v1/setExceptional"
// 获取订阅数据情况
#define JH_GetSubscribeData @"/jinghan-boss/api/boss/v1/getSubscribeData"
// 设置订阅数据
#define JH_SetSubscribeData @"/jinghan-boss/api/boss/v1/setSubscribeData"
// 获取等待审批列表
#define JH_GetApprovalList @"/jinghan-boss/api/boss/v1/getApprovalList"
// 更新等待审批项目
#define JH_UpdateApprovalState @"/jinghan-boss/api/boss/v1/updateApprovalState"
// 清空已处理审批项目
#define JH_DeleteApproval @"/jinghan-boss/api/boss/v1/deleteApproval"
// 清除通知提醒上面的小红点
#define JH_CleanHomeBadge @"/jinghan-boss/api/boss/v1/cleanHomeBadge"
// 更改首页勿扰设置
#define JH_UpdateDisturbState @"/jinghan-boss/api/boss/v1/updateDisturbState"
//获取订单异常列表
#define JH_OrderAbnormalListURL @"/jinghan-boss/api/boss/v1/orders/exception";
//通过订单号获取订单id
#define JH_getOrderIdURL @"/jinghan-boss/api/boss/v1/order/detail"
//获取差评列表
#define JH_badCommentsListURL @"/jinghan-boss/api/boss/v1/negative/comments";
//营业额，客流量，客单价
#define JH_TurnoverFlowPriceURL @"/jinghan-boss/api/boss/v1/getPerTimingData"
//最受欢迎的菜系
#define JH_welcomeDishsURL @"/jinghan-boss/api/boss/v1/popular/dishes/categories"
//营业额同环比
#define JH_turnoverCompareURL @"/jinghan-boss/api/boss/v1/getRateInDate"

/**
 资讯
 **/
#define JH_NewsListURL @"/information/queryInformation.shtml"


/**
 MinePage
 **/

// 获得反馈意见标签
#define JH_SuggestionLabels @"/jinghan-boss/api/boss/v1/getSuggestionLabels"
// 提交反馈意见
#define JH_SubmitFeedback @"/jinghan-boss/api/boss/v1/submitFeedback"
// 获取我的个人信息
#define JH_GetUserInfo @"/jinghan-boss/api/boss/v1/getUserInfo"
// 修改昵称
#define JH_ModifyBossNickname @"/jinghan-boss/api/boss/v1/modifyBossNickname"


/**
 Setting
 **/

// 获取报表推送设置详情
#define JH_ReportPushSettingDetail @"/jinghan-boss/api/boss/v1/getReportPushSettingDetail"
// 设置报表推送设置详情
#define JH_SetReportPushSetting @"/jinghan-boss/api/boss/v1/setReportPushSetting"
// 获取审核设置状态
#define JH_ReviewSettingDetail @"/jinghan-boss/api/boss/v1/getReviewSettingDetail"
// 修改审核设置状态
#define JH_ChangeReviewSetting @"/jinghan-boss/api/boss/v1/changeReviewSetting"
// 获取提醒设置状态
#define JH_ReminderSettingDetail @"/jinghan-boss/api/boss/v1/getReminderSettingDetail"
// 修改提醒设置状态
#define JH_ModifyReminderSetting @"/jinghan-boss/api/boss/v1/modifyReminderSetting"
// 获取勿扰设置详情
#define JH_NotDisturbSettingDetail @"/jinghan-boss/api/boss/v1/getNotDisturbSettingDetail"
// 修改勿扰设置详情
#define JH_ChangeNotDisturbSetting @"/jinghan-boss/api/boss/v1/changeNotDisturbSetting"
//钱包余额和短信条数
#define JH_WalletURL @"/jinghan-boss/api/boss/v1/wallet"
//获取钱包消费记录
//获取钱包充值记录
#define JH_WalletRecordsURL @"/jinghan-boss/api/boss/v1/wallet/records"
//短信消费记录
#define JH_NoteRecordsURL @"/jinghan-boss/api/boss/v1/MessageRecord"
//钱包充值获取金额列表接口
#define JH_WalletRechargeMoneyListURL @"/jinghan-boss/api/boss/v1/wallet/recharge/amountType"
//购买短信，短信条数和金额接口            
#define JH_NoteNumAndMoneyListURL @"/jinghan-boss/api/boss/v1/message/buy/amountType"


/**
 员工招聘URL
 **/
//获取员工招聘职位列表
#define JH_StaffInvitePositionURL @"/jinghan-boss/api/boss/v1/getRecruitTypeList"
//获取某个职位下的应聘者列表
#define JH_applicantListURL @"/jinghan-boss/api/boss/v1/getApplicantListByTypet"
//是否显示招聘按钮
#define JH_isShowStaffInvidteURL @"/jinghan-boss/api/boss/v1/getEmployeeRecruitmentState"

#endif /* JHUrl_h */
