//
//  EnumTypedefDefine.h
//  JinghanLife
//
//  Created by jinghan on 17/2/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#ifndef EnumTypedefDefine_h
#define EnumTypedefDefine_h

/**
 *  用户点击模块
 */
typedef NS_ENUM(NSUInteger, SendOtherMessageViewSelectedType) {
    /** 相机 **/
    SendOtherMessageViewSelectedType_Camera,
    /** 相册 **/
    SendOtherMessageViewSelectedType_Album,
    /** 定位 **/
    SendOtherMessageViewSelectedType_Location,
    /** 语音 **/
    SendOtherMessageViewSelectedType_Voice,
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSUInteger, JHMessageType) {
    /** 文本/表情 **/
    JHMessageType_Text,
    /** 图片 **/
    JHMessageType_Photo,
    /** 定位 **/
    JHMessageType_Location,
    /** 语音 **/
    JHMessageType_Voice,
};


/**
 *  消息发送者
 */
typedef NS_ENUM(NSUInteger, MessageSenderType) {
    /** 其他人发送 **/
    MessageSenderType_Other,
    /** 自己发送的消息 **/
    MessageSenderType_Self,
};


/**
 *  聊天室类型
 */
typedef NS_ENUM(NSUInteger, ChatRoomType) {
    /** 单聊 **/
    ChatRoomType_Single,
    /** 群聊 **/
    ChatRoomType_Group,
};


typedef NS_ENUM(NSUInteger, JH_HttpRequestFailState) {
    /**         断网               **/
    JH_HttpRequestFailState_NetworkBreak = 1,
    /**其他情况视为一种情况**/
    JH_HttpRequestFailState_ServiceBreak,
    
};



//不同界面进入设置手势密码界面
typedef NS_ENUM(NSUInteger,JHBoss_GesturePaswSettingType) {
    
    JHBoss_GesturePaswSettingType_FirstLogin,//第一次设置手势密码
    JHBoss_GesturePaswRESettingType_reSetting//输入密码错误4次重置密码
    
};


//数据刷新类型 下拉刷新或上提加载
typedef NS_ENUM(NSUInteger,JH_RefreshType) {
    
    JH_RefreshType_pullDown,//下拉刷新
    JH_RefreshType_pullUp,//上提加载
};

//首页--订单异常进入还是差评数进去
typedef NS_ENUM(NSUInteger,JHBoss_OrderOrComment) {

    JHBoss_OrderEnterInto,//订单异常进入
    JHBoss_BadCommentEnterInto,//差评进入

};

//餐厅选择枚举
typedef NS_ENUM(NSInteger,JHBoss_pickerType) {
    
    JHBoss_PickerType_Rest,//餐厅选择
    
    
};

 
/**
 餐厅筛选栏枚举

 - DierctionType_Top: <#DierctionType_Top description#>
 - DierctionType_Middle: <#DierctionType_Middle description#>
 - DierctionType_Bottom: <#DierctionType_Bottom description#>
 */
typedef NS_ENUM(NSInteger , DierctionType) {
    
    DierctionType_Top,
    DierctionType_Middle,
    DierctionType_Bottom
};

/**
 用于区分个服务条款

 - JHBoss_protocalType_UseProtocal: <#JHBoss_protocalType_UseProtocal description#>
 JHBoss_protocalType_WalletOrNoteProtocal 增值服务说明
 */
typedef NS_ENUM(NSInteger,JHBossProtocalType) {

    JHBoss_protocalType_UseProtocal,//使用条款
    JHBoss_protocalType_WalletOrNoteProtocal,
};


#endif /* EnumTypedefDefine_h */
