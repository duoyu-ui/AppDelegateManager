//
//  NetRequestManager.m
//  XM_12580
//
//  Created by mac on 12-7-9.
//  Copyright (c) 2012年 Neptune. All rights reserved.
//

#import "NetRequestManager.h"
#import "NetResponseManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager2.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "FunctionManager.h"
#import "SAMKeychain.h"
#import "NSBundle+FYUtils.h"
@implementation RequestInfo

- (id)init {
    if(self = [super init]){
        self.act = ActAll;
    }
    return self;
}

- (id)initWithType:(RequestType)type {
    if(self = [self init]){
        self.act = ActAll;
        self.requestType = type;
    }
    return self;
}

@end

@implementation NetRequestManager

+ (NetRequestManager *)sharedInstance {
    static dispatch_once_t onceNetReq;
    static NetRequestManager *instance = nil;
    dispatch_once(&onceNetReq, ^{
        if(instance == nil)
            instance = [[NetRequestManager alloc] init];
    });
    return instance;
}

- (id)init {
    self=[super init];
    if (self){
        _httpManagerArray = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - dealloc

- (void)dealloc {
    //[[[NetRequestManager sharedInstance] createHttpSessionManager] clear];
}


#pragma mark - ****************** 请求公告方法 ******************

- (void)requestWithData:(NSDictionary *)dict
            requestInfo:(RequestInfo *)requestInfo
                success:(CallbackBlock)successBlock
                   fail:(CallbackBlock)failBlock
{
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    
    NSString *auth = nil;
    NSDictionary *encryDic = [NSDictionary new];
    
    if(requestInfo.act == ActRequestCommonInfo ||
       requestInfo.act == ActRequestToken ||
       requestInfo.act == ActCheckLogin ||
       requestInfo.act == ActRequestCaptcha ||
       requestInfo.act == ActRegister ||
       requestInfo.act == ActCheckRegister ||
       requestInfo.act == ActResetPassword ||
       requestInfo.act == ActRequestVerifyCode ||
       requestInfo.act == ActRequestTokenBySMS ||
       requestInfo.act == ActRemoveToken ||
       requestInfo.act == ActRequestMsgBanner ||
       requestInfo.act == ActRequestClickBanner ||
       requestInfo.act == Act2020AuthLoginToken ||
       requestInfo.act == Act2020GetLoginConfig ||
       requestInfo.act == Act2020ThirdpartyCheck ||
       requestInfo.act == Act2020ThirdpartRegister ||
       requestInfo.act == Act2020NewRegister ||
       requestInfo.act == Act2020ToGuestLogin) {
        
        auth = [AppModel shareInstance].authKey;
        if (dict) {
            NSLog(NSLocalizedString(@"\n==== Auth 接口地址:%@ \n==== Auth 接口参数:%@", nil), requestInfo.url, dict);
            encryDic = dict;
        } else {
            NSLog(NSLocalizedString(@"\n==== Auth 接口地址:%@ \n==== Auth 接口参数:nil", nil), requestInfo.url);
        }
        
        // 设置请求头
        NSString *mobile = GetUserDefaultWithKey(@"mobile");
        [httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[FunctionManager isEmpty: mobile]? @"" : mobile] forHTTPHeaderField:@"userName"];
    } else {
        // 用户token
        auth = [AppModel shareInstance].userInfo.fullToken;
        if(dict) {
            NSLog(NSLocalizedString(@"\n==== Net 接口地址:%@ \n==== Net 接口参数:%@", nil), requestInfo.url, dict);
            encryDic = [FunctionManager encryMethod:dict]; //参数加密处理
        } else {
            NSLog(NSLocalizedString(@"\n==== Net 接口地址:%@ \n==== Net 接口参数:nil", nil), requestInfo.url);
        }
        
        // 设置请求头
        NSString *mobile = GetUserDefaultWithKey(@"mobile");
        [httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
        [httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",mobile] forHTTPHeaderField:@"userName"];
    }

    // 选择语言
    NSString *currentLanguage = [NSBundle currentLanguage];
    [httpSessionManager.requestSerializer setValue:currentLanguage forHTTPHeaderField:NET_HEADER_LANG_KEY];
    if ([currentLanguage hasPrefix:@"zh"]) {
        [httpSessionManager.requestSerializer setValue:NET_HEADER_LANG_ZHCN forHTTPHeaderField:NET_HEADER_LANG_KEY];
    } else if ([currentLanguage hasPrefix:@"en"]) {
        [httpSessionManager.requestSerializer setValue:NET_HEADER_LANG_ENUS forHTTPHeaderField:NET_HEADER_LANG_KEY];
    }
    
    if(requestInfo.act != ActRequestCommonInfo) {
        if(auth == nil) {
            NSLog(NSLocalizedString(@"Auth 为空", nil));
            if([AppModel shareInstance].userInfo.isLogined == YES) {
                [[AppModel shareInstance] logout];
            }
            if(failBlock)
                failBlock(NSLocalizedString(@"系统错误，请退出重新登录", nil));
            return;
        }
    }
    
    // requestInfo.startTime = [[NSDate date] timeIntervalSince1970];
    requestInfo.url = [requestInfo.url stringByReplacingOccurrencesOfString:@" " withString:@""];

    httpSessionManager.successBlock = successBlock;
    httpSessionManager.failBlock = failBlock;
    httpSessionManager.act = requestInfo.act;
    
    WEAK_OBJ(weakManager, httpSessionManager);
    if(requestInfo.requestType == RequestType_post) {
        [httpSessionManager POST:requestInfo.url parameters:encryDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
            [weakManager clear];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
            [weakManager clear];
        }];
    } else if (requestInfo.requestType == RequestType_get) {
        [httpSessionManager GET:requestInfo.url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
            [weakManager clear];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
            [weakManager clear];
        }];
    }
}

- (AFHTTPSessionManager2 *)createHttpSessionManager
{
    for (AFHTTPSessionManager2 *manager in _httpManagerArray) {
        if(manager.act == ActNil) {
            [manager.requestSerializer setValue:kNewTenant forHTTPHeaderField:@"tenant"];
            return manager;
        }
    }
    AFHTTPSessionManager2 *manager = [AFHTTPSessionManager2 manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = NET_REQUEST_TIMEOUTINTERVAL;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",@"image/gif", nil];
    
    [_httpManagerArray addObject:manager];
    
    NSString *iosVersion = [[FunctionManager sharedInstance] getIosVersion];
    NSString *model = [[FunctionManager sharedInstance] getDeviceModel];
    NSString *appVersion = [[FunctionManager sharedInstance] getApplicationVersion];
    if(iosVersion)
        [manager.requestSerializer setValue:iosVersion forHTTPHeaderField:@"systemVersion"];
    if(model)
        [manager.requestSerializer setValue:model forHTTPHeaderField:@"deviceModel"];
    if(appVersion)
        [manager.requestSerializer setValue:appVersion forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:kNewTenant forHTTPHeaderField:@"tenant"];
    [manager.requestSerializer setValue:@"APP" forHTTPHeaderField:@"type"];
    [manager.requestSerializer setValue:@"3" forHTTPHeaderField:@"deviceType"];
    return manager;
}


#pragma mark -
#pragma mark - 通用请求
-(void)requestWithAct:(Act)actInfo
          requestType:(RequestType)requestType
           parameters:(NSDictionary *)params
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock
{
    [self requestWithAct:actInfo requestType:requestType parameters:params success:successBlock failure:failBlock];
}


#pragma mark -
#pragma mark 接口部分
- (NSMutableDictionary *)createDicWithHead
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}

#pragma mark 请求参数
- (NSMutableDictionary *)createRrequestParameters
{
    return [self createDicWithHead];
}


#pragma mark - 密码请求tocken
-(void)requestTokenWithDic:(NSMutableDictionary*)dic
                   success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestToken];
    
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    //    [bodyDic setObject:account forKey:@"username"];
    //    [bodyDic setObject:s forKey:@"password"];
    
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
-(void)checkLoginWithDic:(NSMutableDictionary*)dic
                    success:(CallbackBlock)successBlock
                       fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActCheckLogin];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 短信验证码获取tocken
-(void)requestTockenWithPhone:(NSString *)phone
                      smsCode:(NSString *)smsCode
                      success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestTokenBySMS];
    NSString *par = [NSString stringWithFormat:@"mobile=%@&code=%@&grant_type=mobile&scope=server",phone,smsCode];
    NSString *url = [NSString stringWithFormat:@"%@?%@",info.url,par];
    info.url = url;
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 重置密码（找回密码）
-(void)findPasswordWithPhone:(NSString *)phone
                     smsCode:(NSString *)smsCode
                    password:(NSString *)password
                     success:(CallbackBlock)successBlock
                        fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActResetPassword];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:phone forKey:@"mobile"];
    [bodyDic setObject:smsCode forKey:@"code"];
    [bodyDic setObject:password forKey:@"password"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 重设支付密码
-(void)setPayPasswordWithPhone:(NSString *)phone
                       smsCode:(NSString *)smsCode
                      password:(NSString *)password
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActUpPayPasswd];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:phone forKey:@"mobile"];
    [bodyDic setObject:smsCode forKey:@"code"];
    [bodyDic setObject:password forKey:@"password"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 手机注册
-(void)registerWithDic:(NSMutableDictionary*)dic
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRegister];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

-(void)checkRegisterWithDic:(NSMutableDictionary*)dic
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActCheckRegister];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic addEntriesFromDictionary:dic];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 请求用户信息
-(void)requestUserInfoWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestUserInfo];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 请求验证码
-(void)requestSmsCodeWithPhone:(NSString *)phone type:(GetSmsCodeFromVCType)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock) failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestVerifyCode];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:phone forKey:@"mobile"];
    switch (type) {
        case GetSmsCodeFromVCRegister:
            [bodyDic setObject:@"reg" forKey:@"bizCode"];
            break;
        case GetSmsCodeFromVCResetPW:
            [bodyDic setObject:@"reset_passwd" forKey:@"bizCode"];
            break;
        case GetSmsCodeFromVCLoginBySMS:
            [bodyDic setObject:@"login" forKey:@"bizCode"];
            break;
        case GetSmsCodeFromVCPayPW:
            [bodyDic setObject:@"pay_passwd" forKey:@"bizCode"];
            break;
        case GetSmsCodeBindPhone:
            //bind_phone
            [bodyDic setObject:@"bind_phone" forKey:@"bizCode"];
            break;
        default:
            break;
    }
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}


-(void)requestImageCaptchaWithPhone:(NSString *)phone type:(GetSmsCodeFromVCType)type
                          success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestCaptcha];
    NSString* bizcode = @"";
    switch (type) {
        case GetSmsCodeFromVCRegister:
            bizcode = @"reg";
            break;
        case GetSmsCodeFromVCResetPW:
            bizcode = @"reset_passwd";
            break;
        case GetSmsCodeFromVCLoginBySMS:
            bizcode = @"login";
            break;
        case GetSmsCodeFromVCPayPW:
            bizcode = @"pay_passwd";
            break;
        default:
            break;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?bizCode=%@&uuid=%@",info.url,bizcode,phone];
    info.requestType = RequestType_post;
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [httpSessionManager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",@"image/gif", nil];
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",@"image/gif", nil];
        failBlock(error);
    }];
}

#pragma mark - 获取银行列表
-(void)requestBankListWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBankList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

-(void)requestDrawRecordListWithPage:(NSInteger)page success:(CallbackBlock)successBlock
                                fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestWithdrawHistory];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"current"];
    [bodyDic setObject:@"50" forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 提现
-(void)withDrawWithAmount:(NSString *)amount//金额
                 userName:(NSString *)name//名字
                 bankName:(NSString *)backName//银行名
                   bankId:(NSString *)bankId//银行id
                  address:(NSString *)address//地址
                  uppayNO:(NSString *)uppayNO //卡号
                   remark:(NSString *)remark//备注
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActDraw];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:amount forKey:@"amount"];
    [bodyDic setObject:bankId forKey:@"userPaymentId"];
    [bodyDic setObject:name forKey:@"uppPayName"];
    [bodyDic setObject:backName forKey:@"uppayBank"];
    [bodyDic setObject:address forKey:@"uppayAddress"];
    [bodyDic setObject:uppayNO forKey:@"uppayNo"];
    [bodyDic setObject:remark forKey:@"remark"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

-(void)withDrawWithAmount:(NSString *)amount//金额
                   bankId:(NSString *)bankId//银行id
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActDraw];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:amount forKey:@"amount"];
    [bodyDic setObject:bankId forKey:@"userPaymentId"];
    [bodyDic setObject:NSLocalizedString(@"无", nil) forKey:@"remark"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取账单列表
-(void)requestBillListWithName:(NSString *)billName
                   categoryStr:(NSString *)categoryStr
                     beginTime:(NSString *)beginTime
                       endTime:(NSString *)endTime
                          page:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBillList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    NSDictionary* dic = @{
                          @"billtName":[NSString stringWithFormat:@"%@",![FunctionManager isEmpty:billName]?billName:@""],
                          @"category":[NSString stringWithFormat:@"%@",categoryStr],
                          @"endTime":[NSString stringWithFormat:@"%@",endTime],
                          @"startTime":[NSString stringWithFormat:@"%@",beginTime]
                          };
    [bodyDic setObject:dic forKey:@"queryParam"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 账单类型：线上充值，人工充值，抢包，踩雷...
-(void)requestBillTypeWithType:(NSString *)type success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBillTypeList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",type] forKey:@"category"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
-(void)upLoadVideoObj:(NSData *)videoData
             fileName:(NSString *)fileName
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock{
    RequestInfo *requestInfo = [self requestInfoWithAct:ActUploadImg];
    NSString *auth = [AppModel shareInstance].userInfo.fullToken;
    if(auth == nil)
        return;
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    httpSessionManager.successBlock = successBlock;
    httpSessionManager.failBlock = failBlock;
    httpSessionManager.act = requestInfo.act;
    [httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    
    NSString *mobile = GetUserDefaultWithKey(@"mobile");
    [httpSessionManager.requestSerializer setValue:mobile forHTTPHeaderField:@"userName"];
    WEAK_OBJ(weakManager, httpSessionManager);
    [httpSessionManager POST:requestInfo.url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:videoData name:@"file" fileName:[NSString stringWithFormat:@"%@.mp4",fileName] mimeType:@"video/mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
        [weakManager clear];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
        [weakManager clear];
    }];
}
#pragma mark - 上传语音
-(void)upLoadVoiceObj:(NSData *)voiceData
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock{
    RequestInfo *requestInfo = [self requestInfoWithAct:ActUploadImg];
    NSString *auth = [AppModel shareInstance].userInfo.fullToken;
    if(auth == nil)
        return;
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    httpSessionManager.successBlock = successBlock;
    httpSessionManager.failBlock = failBlock;
    httpSessionManager.act = requestInfo.act;
    [httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    
    NSString *mobile = GetUserDefaultWithKey(@"mobile");
    [httpSessionManager.requestSerializer setValue:mobile forHTTPHeaderField:@"userName"];
    WEAK_OBJ(weakManager, httpSessionManager);
    [httpSessionManager POST:requestInfo.url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:voiceData name:@"file" fileName:@"fy.amr" mimeType:@"audio/mpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
        [weakManager clear];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
        [weakManager clear];
    }];
}
#pragma mark - 上传图片
-(void)upLoadImageObj:(UIImage *)image
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock{
    RequestInfo *requestInfo = [self requestInfoWithAct:ActUploadImg];

    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    while (data.length > 50 && compression > 0) {
        compression -= 0.02;
        data = UIImageJPEGRepresentation(image, compression);
    }
    
    NSString *auth = [AppModel shareInstance].userInfo.fullToken;
    if(auth == nil)
        return;
//    NSLog(@"%@",requestInfo.url);
    AFHTTPSessionManager2 *httpSessionManager = [self createHttpSessionManager];
    httpSessionManager.successBlock = successBlock;
    httpSessionManager.failBlock = failBlock;
    httpSessionManager.act = requestInfo.act;
    [httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    
    NSString *mobile = GetUserDefaultWithKey(@"mobile");
    [httpSessionManager.requestSerializer setValue:mobile forHTTPHeaderField:@"userName"];
    WEAK_OBJ(weakManager, httpSessionManager);
    
    [httpSessionManager POST:requestInfo.url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:responseObject];
        [weakManager clear];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NET_RESPONSE_MANAGER responseWithHttpManager:weakManager responseData:error];
        [weakManager clear];
    }];
}

#pragma mark - 编辑用户信息
-(void)editUserInfoWithUserAvatar:(NSString *)url
                personalSignature:(NSString *)personalSignature
                         userNick:(NSString *)nickName
                           gender:(NSInteger)gender
                          success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActModifyUserInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    if (url.length > 0 && [url hasPrefix:@"http"]){
        [bodyDic setObject:url forKey:@"userAvatar"];
    }
    [bodyDic setObject:nickName forKey:@"userNick"];
    [bodyDic setObject:personalSignature forKey:@"personalSignature"];
    [bodyDic setObject:INT_TO_STR(gender) forKey:@"userGender"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取app配置
-(void)requestAppConfigWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestCommonInfo];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 我的下线列表
-(void)requestMyPlayerWithPage:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                    userString:(NSString *)userString
                          type:(NSInteger)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActMyPlayer];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    if(userString.length > 0){
        [bodyDic setObject:[NSString stringWithFormat:@"%@",userString] forKey:@"userId"];
    }
    if(type >= 0){
        [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"type"];
    }
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取通知列表
-(void)requestSystemNoticeWithType:(NSString *)type
                           success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock
{
    RequestInfo *info = [self requestInfoWithAct:ActRequestSystemNotice];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"1"] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"20"] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"true"] forKey:@"isAsc"];
    if (VALIDATE_STRING_EMPTY(type)) {
        [bodyDic setObject:@{} forKey:@"queryParam"];
    } else {
        [bodyDic setObject:@{@"noticeType":type} forKey:@"queryParam"];
    }
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

- (void)allSystemMessagesWithrTime:(NSString*)time
                              page:(NSInteger)page
                           success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestSystemNotice];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    if (time.length != 0) {
        [bodyDic setObject:@{@"releaseTime":time} forKey:@"queryParam"];
    }
    [bodyDic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"20"] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"true"] forKey:@"isAsc"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取消息头部banner
-(void)requestMsgBannerWithId:(OccurBannerAdsType)adId WithPictureSpe:(OccurBannerAdsPictureType)pictureSpe success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestMsgBanner];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",[FunctionManager getAppSource]] forKey:@"clientType"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",adId] forKey:@"id"];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",pictureSpe] forKey:@"pictureSpe"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

-(void)requestClickBannerWithAdvSpaceId:(NSString *)advSpaceId Id:(NSString*)adId success:(CallbackBlock)successBlock
                                   fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestClickBanner];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",[FunctionManager getAppSource]] forKey:@"clientType"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",advSpaceId] forKey:@"advSpaceId"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",adId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 请求分享列表
-(void)requestShareListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestShareList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:@"1" forKey:@"current"];
    [bodyDic setObject:@"50" forKey:@"size"];
    [bodyDic setObject:@"true" forKey:@"isAsc"];
    [bodyDic setObject:@"id" forKey:@"sort"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 增加分享页的访问量
-(void)addShareCountWithId:(NSInteger)shareId success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActAddShareCount];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)shareId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 充值列表
-(void)requestRechargeListWithSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRechargeList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 报表
-(void)requestReportFormsWithUserId:(NSString *)userId beginTime:(NSString *)beginTime endTime:(NSString *)endTime success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestReportForms];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:beginTime forKey:@"startTime"];
    [bodyDic setObject:endTime forKey:@"endTime"];
    [bodyDic setObject:userId forKey:@"loginUserId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 清除token
-(void)removeTokenWithSuccess:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRemoveToken];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取活动列表
-(void)requestActivityListWithUserId:(NSString *)userId success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestActivityList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:userId forKey:@"userId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 领取奖励
-(void)getRewardWithActivityType:(NSString *)type userId:(NSString *)userId success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetReward];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:type forKey:@"promotType"];
    [bodyDic setObject:userId forKey:@"userId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 领取首充，二充奖励
-(void)getFirstRewardWithUserId:(NSString *)userId rewardType:(NSInteger)rewardType success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetFirstRewardInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:INT_TO_STR(rewardType) forKey:@"promotType"];
    [bodyDic setObject:userId forKey:@"userId"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 申请成为代理
-(void)askForToBeAgentWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActToBeAgent];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 查询可抽奖列表
-(void)getLotteryListWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetLotteryList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 查询可抽奖具体信息
-(void)getLotteryDetailWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetLotterys];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)lId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 抽奖
-(void)lotteryWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActLottery];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%ld",(long)lId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 添加银行卡
-(void)addBankCardWithUserName:(NSString *)userName cardNO:(NSString *)cardNO bankId:(NSString *)bankId bankCode:(NSString *)bankCode address:(NSString *)address success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActAddBankCard];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:userName forKey:@"user"];
    [bodyDic setObject:bankId forKey:@"upaytId"];
    [bodyDic setObject:cardNO forKey:@"upayNo"];
    [bodyDic setObject:bankCode forKey:@"code"];
    [bodyDic setObject:address forKey:@"bankRegion"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 我的银行卡
-(void)getMyBankCardListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestMyBankList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取所有支付通道列表
-(void)requestAllRechargeListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRechargeListAll];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 提交支付资料
-(void)submitRechargeInfoWithBankId:(NSString *)bankId
                           bankName:(NSString *)bankName
                             bankNo:(NSString *)bankNo
                                tId:(NSString *)tId
                              money:(NSString *)money
                               name:(NSString *)name
                            orderId:(NSString *)orderId
                               type:(NSInteger)type
                           typeCode:(NSInteger)typeCode
                             userId:(NSString *)userId
                            success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActSubmitRechargeInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    if(bankId)
        [bodyDic setObject:bankId forKey:@"bankId"];
    if(bankName)
        [bodyDic setObject:bankName forKey:@"bankName"];
    [bodyDic setObject:bankNo forKey:@"bankNo"];
    [bodyDic setObject:tId forKey:@"id"];
    [bodyDic setObject:money forKey:@"money"];
    [bodyDic setObject:name forKey:@"name"];
//    [bodyDic setObject:INT_TO_STR(type) forKey:@"type"];
    [bodyDic setObject:userId forKey:@"userId"];
//    [bodyDic setObject:INT_TO_STR(typeCode) forKey:@"typeCode"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 提交订单
-(void)submitOrderRechargeInfoWithId:(NSString *)orderId money:(NSString *)money
                                name:(NSString *)name success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActOrderRecharge];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:orderId forKey:@"id"];
    [bodyDic setObject:money forKey:@"money"];
    [bodyDic setObject:name forKey:@"remark"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取分享url
-(void)getShareUrlWithCode:(NSString *)code success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestShareUrl];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:code forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取新手引导图片列表
-(void)getGuideImageListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestGuideImageList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:@"6" forKey:@"helpType"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 活动奖励列表
-(void)getActivityListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestActivityList2];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"1"] forKey:@"current"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"20"] forKey:@"size"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"id"] forKey:@"sort"];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",@"false"] forKey:@"isAsc"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取jjj活动阶段
-(void)getActivityJiujiJingListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestJiujiJingList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取抢包活动阶段
-(void)getActivityQiaoBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestQiaoBaoList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取发包活动阶段
-(void)getActivityFaBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestFaBaoList];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}


#pragma mark - 获取活动详情
- (void)getActivityDetailWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [[RequestInfo alloc] initWithType:RequestType_post];
    NSString *urlTail = nil;
    //6000豹子顺子奖励 5000直推流水佣金 2000邀请好友充值 1100充值奖励  3000发包奖励 4000抢包奖励
    if(type == RewardType_bzsz)
        urlTail = @"social/promotReward/bzsz/detail";
    else if(type == RewardType_ztlsyj)
        urlTail = @"social/promotReward/commission/detail";
    else if(type == RewardType_yqhycz)
        urlTail = @"social/promotReward/invite/detail";
    else if(type == RewardType_czjl)
        urlTail = @"social/promotReward/recharge/detail";
    info.url = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,urlTail];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 接龙状态
-(void)getSolitaireInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestSolitaireInfo];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 接龙 群主发包
-(void)getSolitaireSendDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestSolitaireSend];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 接龙
-(void)getSolitaireRecordPageWithGroupId:(NSString *)groupId page:(NSInteger)page type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestSolitaireRecordPage];
    NSDictionary *dict = @{
        @"current":@(page),
        @"isAsc":@(false),
        @"queryParam":@{
                @"id":groupId,
                @"type":@(type)
        },
        @"size":@(40)
    };
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 包包彩状态
-(void)getBegLotteryInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBagBagLotteryInfo];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 包包彩赔率
-(void)getBegLotteryGameOddsDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBagBagLotteryGameOdds];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 包包彩游戏记录
-(void)getBegLotteryGameRecordsDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBagBagLotteryGameRecords];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 包包彩历史记录
-(void)getBegLotteryHistoryDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBagBagLotteryHistory];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 包包牛群状态
-(void)getBegBagCowInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBagBagCowGetBBNInfo];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 包包牛历史记录
-(void)getBegBagCowRecordDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBagBagCowHistoryRecord];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 包包彩游戏投注
-(void)getBegLotteryBettDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBagBagLotteryBett];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
#pragma mark - 抢庄牛牛状态
-(void)getRobNiuNiuInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobNiuNiuInfo];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}


#pragma mark - 抢庄牛牛投注
-(void)robNiuNiuBettChatId:(NSString *)chatId money:(NSString *)money betAttr:(NSInteger)betAttr success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobBett];
    if (betAttr >= 0) {
        [self requestWithData:@{@"chatId":chatId,@"money":money,@"betAttr":@(betAttr),@"userId":[AppModel shareInstance].userInfo.userId} requestInfo:info success:successBlock fail:failBlock];
    }else{
        
        [self requestWithData:@{@"chatId":chatId,@"money":money,@"userId":[AppModel shareInstance].userInfo.userId} requestInfo:info success:successBlock fail:failBlock];
    }
}

#pragma mark - 抢庄牛牛抢庄
-(void)robNiuNiuBankeerChatId:(NSString *)chatId money:(NSString *)money success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobBankeer];
    [self requestWithData:@{@"chatId":chatId,@"money":money,@"userId":[AppModel shareInstance].userInfo.userId} requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 抢庄牛牛发包
-(void)robNiuNiuRedpacketChatId:(NSString *)chatId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobRedpacket];
    [self requestWithData:@{@"chatId":chatId,@"userId":[AppModel shareInstance].userInfo.userId} requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 抢庄牛牛连续上庄
-(void)robNiuNiuContinueBankerChatId:(NSString *)chatId money:(NSString *)money success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobContinueBanker];
    [self requestWithData:@{@"chatId":chatId,@"money":money,@"userId":[AppModel shareInstance].userInfo.userId} requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 抢庄牛牛期数记录
- (void)getRobPeriodRecordChatId:(NSString *)chatId page:(NSInteger )page type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobPeriodRecord];
    NSDictionary *dict = @{ @"current": @(page),
                            @"queryParam":
                                    @{
                                    @"id": chatId,
                                    @"type": @(type)
                                    },
                            @"size": @(40)};
    
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 抢庄牛牛游戏记录
- (void)getRobGameDetailsChatId:(NSString *)chatId period:(NSString *)period type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobGameDetails];
    [self requestWithData:@{ @"id":chatId,
                             @"type":@(type),
                             @"period":period
                             } requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 抢庄牛牛投注记录
- (void)getRobBettingRecordChatId:(NSString *)chatId page:(NSInteger)page  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobBettingRecord];
    [self requestWithData:@{ @"queryParam":@{@"id":chatId},
                             @"current":@(page),
                             @"size":@(40)
                             } requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取用户余额
-(void)getRobFinanceSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobFinance];
    NSString *userId = [AppModel shareInstance].userInfo.userId ? [AppModel shareInstance].userInfo.userId : @"";
    [self requestWithData:@{@"userId": userId} requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark 获取发包抢包奖励
-(void)getRewardWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [[RequestInfo alloc] initWithType:RequestType_post];
    NSString *urlTail = nil;
    if(type == RewardType_qbjl)//4000抢包奖励 3000发包奖励
        urlTail = @"social/promotReward/get/rob/reward/money";
    else if(type == RewardType_fbjl){
        urlTail = @"social/promotReward/get/send/reward/money";
    }else{
        urlTail = @"social/promotReward/get/relief/money";
    }
    info.url = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,urlTail];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:[NSString stringWithFormat:@"%@",activityId] forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取下线基础信息
-(void)requestMyPlayerCommonInfoWithSuccess:(CallbackBlock)successBlock
                                       fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActCheckMyPlayers];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 个人报表信息
-(void)requestUserReportInfoWithId:(NSString *)userId success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestAgentReportInfo];
    NSMutableDictionary *bodyDic = [self createDicWithHead];
    [bodyDic setObject:userId forKey:@"id"];
    [self requestWithData:bodyDic requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 个人中心查询活动记录
- (void)requestUserListRecordDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestListRecord];
    
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 查询所有推广教程
-(void)requestCopyListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestPromotionCourse];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 查询所有支付通道
-(void)requestAllRechargeChannelWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRechargeChannel];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

-(void)requestAllRechargeCheckUser:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    
    RequestInfo *info = [self requestInfoWithAct:ActOrderRechargeCheckUser];
    
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

-(void)requestAgentDatas:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock{
    
    RequestInfo *info = [self requestInfoWithAct:ActRequestAgentDatas];
    
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 个人中心活动列表
-(void)requestListUserActivitySuccess:(CallbackBlock)successBlock
                                       fail:(CallbackBlock)failBlock{
    
    RequestInfo *info = [self requestInfoWithAct:ActRequestListUserActivity];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取所有红包游戏
-(void)requestListRedBonusTypeSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock{
    
    RequestInfo *info = [self requestInfoWithAct:ActRequestListRedBonusType];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取所有红包子游戏
-(void)requestListOfficialGroup:(NSInteger)type success:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestlistOfficialGroup];
    NSMutableDictionary *sender=[NSMutableDictionary new];
    [sender setObject:@(type) forKey:@"type"];
//    NSInteger tryPlayFlag = 0;
//    if ([[AppModel shareInstance] loginType] == FYLoginTypeGuest) {
//        tryPlayFlag = 1;
//    }
//    [sender setObject:@(tryPlayFlag) forKey:@"tryPlayFlag"];
    [self requestWithData:sender requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 在线客服
- (void)requestCustomerServiceSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:OnlineCustomerService];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

- (void)requestSelfJionGrouIsOfficeFlag:(BOOL)officeFlag Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:ActJoinSelfGroupList];
//    NSInteger tryPlayFlag = 0;
//    if ([[AppModel shareInstance] loginType] == FYLoginTypeGuest) {
//        tryPlayFlag = 1;
//    }
    NSDictionary *params = @{@"size":@(999),
                             @"sort": @"id",
                             @"isAsc": @(false),
                             @"current": @(1),
                             @"officeFlag":@(officeFlag)};
    [self requestWithData:params requestInfo:info success:successBlock fail:failBlock];
}

- (RequestInfo *)requestInfoWithLinkUrl:(NSString *)linkUrl {
    NSString *newUrl = [linkUrl substringFromIndex:1];
    RequestInfo *requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
    requestInfo.url = [NSString stringWithFormat:@"%@%@", [AppModel shareInstance].serverUrl, newUrl];
    return  requestInfo;
}

#pragma mark - 加入群组
- (void)getChatGroupJoinWithGroupId:(NSString *)groupId pwd:(NSString*)pwd success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestChatGroupJoin];
    NSDictionary *dict = @{
                           @"id":groupId,
                           @"pwd": pwd,
                           };
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 退出群组
- (void)getChatGroupQuitWithGroupId:(NSString *)groupId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestChatGroupQuit];
    NSDictionary *dict = @{
                           @"id":groupId
                           };
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}

- (void)getBalanceDetailsSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestBalanceDetails];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 获取收益报表
- (void)getEarningsReportSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestEarningsReport];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

/**
 获取资金详情
 @param type 类型：1：转入 2：转出 3：收益 4：调账
 @param isASC 是否升序
 */
- (void)getMoneyDetailWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(NSInteger)type isASC:(BOOL)isASC success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestMoneyDetail];
    [self requestWithData:@{
                            @"current":@(pageIndex),
                            @"isAsc":@(isASC),
                            @"queryParam":@{
                                    @"type":@(type)
                                    },
                            @"size":@(pageSize)
                            
                            } requestInfo:info success:successBlock fail:failBlock];
}

- (void)getInWithMoney:(double)money password:(NSString *)password success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestIntoMoney];
    [self requestWithData:@{
                            @"money":@(money),
                            @"password":password
                            } requestInfo:info success:successBlock fail:failBlock];
}

- (void)getOutWithMoney:(double)money password:(NSString *)password success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestOutMoney];
    [self requestWithData:@{
                            @"money":@(money),
                            @"password":password
                            } requestInfo:info success:successBlock fail:failBlock];
}


#pragma mark - 退出群组
- (void)getQuitGroupWithID:(NSString *)ID opFlag:(NSInteger)opFlag success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    if (ID.length > 0) {
        RequestInfo *info = [self requestInfoWithAct:ActRequestQuitGroup];
        [self requestWithData:@{@"id": ID} requestInfo:info success:successBlock fail:failBlock];
    }
}

#pragma mark -查询是否为好友关系
- (void)getFindFriendWithID:(NSString *)Id success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:ActRequestFindFriendById];
    [self requestWithData:@{@"id": Id} requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 修改好友昵称
- (void)getUpdateFriendNickWithUserId:(NSString *)ID  friendNick:(NSString *)friendNick success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:ActRequestUpdateFriendNick];
    [self requestWithData:@{@"userId": ID,
                            @"friendNick": friendNick
    } requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 拒绝或同意群邀请
/// opFlag，0：发起邀请，1：同意邀请，2：删除
- (void)getOperateGroupWithID:(NSString *)ID opFlag:(NSInteger)opFlag success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestOperateGroup];
    [self requestWithData:@{
                            @"id":ID,
                            @"opFlag": @(opFlag),
                            } requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 分页查询群邀请记录
- (void)getMyGroupVerificationsWhitPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestMyGroup];
    [self requestWithData:@{
                            @"current":@(pageIndex),
                            @"size": @(pageSize),
                            } requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 邀请入群
- (void)getInviteToGroupWhitGroupId:(NSString *)groupId usersId:(NSArray *)usersId  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestInviteToGroup];
    [self requestWithData:@{
                            @"id":groupId,
                            @"userIds": usersId,
                            } requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 加入群
- (void)getAddGroupWhitGroupId:(NSString *)groupId pwd:(NSString *)pwd  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestAddGroup];
    [self requestWithData:@{
                            @"id":groupId,
                            @"pwd": pwd,
                            } requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 根据群组id获取群组信息
- (void)getGroupInfoWithGroupId:(NSString *)groupId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestGroupInfo];
    [self requestWithData:@{
                            @"id":groupId
                            } requestInfo:info success:successBlock fail:failBlock];
}

/// 获取我加入的群组列表
- (void)getGroupListWithPageSize:(NSInteger )pageSize pageIndex:(NSInteger)pageIndex officeFlag:(BOOL)officeFlag success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestGroupList];
    [self requestWithData:@{
                            @"size":@(pageSize),
                            @"sort":@"id",
                            @"isAsc":@"false",
                            @"current":@(pageIndex),
                            @"officeFlag":@(officeFlag)
                            } requestInfo:info success:successBlock fail:failBlock];
}

/// 获取在线客服列表
- (void)getContactsSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestContact];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

/// 添加提现银行卡
- (void)setAddBankcardWhitUserName:(NSString *)userName bankID:(NSString *)bankID cardNO:(NSString *)cardNO bankCode:(NSString *)bankCode address:(NSString *)address success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestAddBankcard];
    [self requestWithData:@{ @"user":userName,
                             @"upaytId":bankID,
                             @"upayNo":cardNO,
                             @"code": bankCode,
                             @"bankRegion":address} requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 提款
- (void)getWithdrawWhitAmount:(NSString *)amount userPaymentId:(NSString *)userPaymentId uppPayName:(NSString *)uppPayName uppayBank:(NSString *)uppayBank uppayAddress:(NSString *)uppayAddress uppayNo:(NSString *)uppayNo success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestWithdraw];
    [self requestWithData:@{ @"amount":amount,
                            @"userPaymentId":userPaymentId,
                            @"uppPayName":uppPayName,
                            @"uppayBank": uppayBank,
                            @"uppayAddress":uppayAddress,
                            @"uppayNo":uppayNo} requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - 解绑银行卡
- (void)getUnbindBankcardWhitPaymentId:(NSString *)paymentId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestUnbindBankcard];
    [self requestWithData:@{ @"paymentId": paymentId } requestInfo:info success:successBlock fail:failBlock];
}

- (void)getjoinGroupPageSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestjoinGroupPage];
    NSDictionary *dict = @{
                           @"size":@"100",
                           @"sort":@"id",
                           @"isAsc":@"false",
                           @"current":@"1"
                           };
    [self requestWithData:dict requestInfo:info success:successBlock fail:failBlock];
}
- (void)requestGameTypesSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestGameTypes];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}
- (void)requestGameCheckStatusWithId:(NSString *)parentId  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestGameCheckStatus];
    [self requestWithData:@{ @"id": parentId } requestInfo:info success:successBlock fail:failBlock];
}


#pragma mark - 自建群相关

- (void)requestGroupRedListSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:ActRequestGroupRedTypeList];
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

/// 查询自建群红包配置模板列表
/// @param type 群类型（ 0：福利；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠）
/// @param successBlock 成功
/// @param failBlock 失败
- (void)requestSelfGroupTemplateWithGroupType:(GroupTemplateType)type Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [RequestInfo new];
    switch (type) {
        case GroupTemplate_N01_Bomb:
            info = [self requestInfoWithAct:ActSelfGroupTemplateBomb];
            break;
        case GroupTemplate_N02_NiuNiu:
            info = [self requestInfoWithAct:ActSelfGroupTemplateNiuNiu];
            break;
        case GroupTemplate_N04_RobNiuNiu:
            info = [self requestInfoWithAct:ActSelfGroupTemplateRobNiuNiu];
            break;
        case GroupTemplate_N05_ErBaGang:
            info = [self requestInfoWithAct:ActSelfGroupTemplateErBaGang];
            break;
        case GroupTemplate_N08_ErRenNiuNiu:{
            info = [self requestInfoWithAct:ActSelfGroupTemplateTwoPeopleNiuNiu];
        }break;
        case GroupTemplate_N09_SuperBobm:{
            info = [self requestInfoWithAct:1];
            return;
        }break;
        default:
            info = [self requestInfoWithAct:ActSelfGroupTemplateBomb];
            break;
    }
    
    [self requestWithData:nil requestInfo:info success:successBlock fail:failBlock];
}

/// 更新自建群红包设置
/// @param type 群类型（ 0：福利；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠）
- (void)updateGroupRedPacketWithGroupType:(GroupTemplateType)type params:(NSDictionary *)params Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [RequestInfo new];
    switch (type) {
        case GroupTemplate_N01_Bomb:
            info = [self requestInfoWithAct:ActUpdateGroupRedPacketBomb];
            break;
        case GroupTemplate_N02_NiuNiu:
            info = [self requestInfoWithAct:ActUpdateGroupRedPacketNiuNiu];
            break;
        case GroupTemplate_N05_ErBaGang:
            info = [self requestInfoWithAct:ActUpdateGroupRedPacketErBaGang];
            break;
        case GroupTemplate_N08_ErRenNiuNiu:
            info = [self requestInfoWithAct:ActUpdateGroupRedPacketTowNiuNiu];
            break;
        default:
            info = [self requestInfoWithAct:ActUpdateGroupRedPacketRobNiuNiu];
            break;
    }
    
    [self requestWithData:params requestInfo:info success:successBlock fail:failBlock];
}

/// 创建自建群群组
/// @param type 群类型
/// @param params 主要请求参数
/// @param successBlock 成功
/// @param failBlock 失败
- (void)requestCreateSelfGroupWithGroupType:(GroupTemplateType)type params:(NSDictionary *)params Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    if (params != nil) {
        RequestInfo *info = [RequestInfo new];
        switch (type) {
            case GroupTemplate_N01_Bomb:
                info = [self requestInfoWithAct:ActCreateGroupTypeBomb];
                break;
            case GroupTemplate_N02_NiuNiu:
                info = [self requestInfoWithAct:ActCreateGroupTypeNiuNiu];
                break;
            case GroupTemplate_N04_RobNiuNiu:
                info = [self requestInfoWithAct:ActCreateGroupTypeRobNiuNiu];
                break;
            case GroupTemplate_N05_ErBaGang:
                info = [self requestInfoWithAct:ActCreateGroupTypeErBaGang];
                break;
            case GroupTemplate_N08_ErRenNiuNiu:
                info = [self requestInfoWithAct:ActCreateGroupTypeTowNiuNiu];
                break;
            default:
                info = [self requestInfoWithAct:ActCreateGroupTypeRobFuLi];
                break;
        }
        
        [self requestWithData:params requestInfo:info success:successBlock fail:failBlock];
    }
}

/// 自建群-群主禁言
/// @param groupId 群ID
- (void)requestGroupStopSpeakWithGroupId:(NSString *)groupId Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:ActSelfCreateGroupStopSpeak];
    [self requestWithData:@{ @"id": groupId } requestInfo:info success:successBlock fail:failBlock];
}

/// 自建群-群主禁图
/// @param groupId 群ID
- (void)requestGroupStopPicWithGroupId:(NSString *)groupId Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:ActSelfCreateGroupStopPic];
    [self requestWithData:@{ @"id": groupId } requestInfo:info success:successBlock fail:failBlock];
}

/// 获取加入/创建的自建群列表
- (void)requestJoinSelfGroupListWithPage:(NSInteger)page Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock {
    RequestInfo *info = [self requestInfoWithAct:ActJoinSelfCreateGroupList];
    NSDictionary *params = @{@"current": @(page), @"size": @"999"};
    [self requestWithData:params requestInfo:info success:successBlock fail:failBlock];
}

#pragma mark - MessageNet 迁移

/**群编辑,修改名称*/
- (void)groupEditorName:(NSDictionary *)dict
       successBlock:(void (^)(NSDictionary * success))successBlock
       failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info=[self requestInfoWithAct:ActUpdateGroupName];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

/**群编辑,修改公告*/
- (void)groupEditorNotice:(NSDictionary *)dict
           successBlock:(void (^)(NSDictionary * success))successBlock
           failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info=[self requestInfoWithAct:ActUpdateGroupNotice];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

- (void)getNotIntoGroupPage:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:ActGetNotIntoGroupPage];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

/// 查询自建群组中的用户（含群主自己）
/// @param dict 请求参数
/// @param successBlock  成功回调
/// @param failureBlock 失败回调
- (void)querySelfGroupUsers:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActGroupUsersAndSelf];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//添加群成员
- (void)addgroupMember:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActAddgroupMember];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//查询群成员
- (void)addGroupSelect:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActGroupSelect];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//social/skChatGroup/
-(void)skChatGroup:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActSkChatGroupInformation];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//自建群-邀请入群
-(void)selfGroupInvite:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActSelfGroupInvite];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//通知服务器 登录了
-(void)appLogin:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActAppLogin];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//默认获取未读消息
-(void)pullFriendOfflineMsg:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActPullFriendOfflineMsg];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//获取红包详情
-(void)getWaterDetail:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActGetWaterDetail];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//获取红包详情
-(void)redpacketDetail:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActRedpacketDetail];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//redpacket/redpacket/grab
//抢红包
-(void)redpacketGrab:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActRedpacketGrab];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//redpacket/redpacket/send
//发红包
-(void)redpacketSend:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActRedpacketSend];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//social/skChatGroup/delgroupMember
// 删除群成员
-(void)delgroupMember:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActDelgroupMember];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//群组禁言
-(void)skChatGroupStop:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActSkChatroupStop];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//social/skChatGroup/groupStopPic"
//群组禁图
-(void)groupStopPic:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActGroupStopPic];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//social/skChatGroup/groupUsers
//查询群成员
-(void)searchGroupUsers:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActGroupUsersAndSelf];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//social/skChatGroup/queryGroupUsers
//查询群成员
-(void)queryGroupUsers:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActQueryGroupUsers];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)querySelfDeleteGroupUsers:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActQuerySelfDeleteGroupUsers];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//social/skChatGroup/delGroup
-(void)delGroup:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock {
    RequestInfo *info = [self requestInfoWithAct:ActDelGroup];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}


-(void)isDisplayCreateGroup:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:ActIsDisplayCreateGroup];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)toLogin:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020AuthLoginToken];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)getLoginConfig:(NSDictionary *)dict
         successBlock:(void (^)(NSDictionary * success))successBlock
         failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020GetLoginConfig];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)thirdPartRegister:(NSDictionary *)dict
            successBlock:(void (^)(NSDictionary * success))successBlock
            failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020ThirdpartRegister];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)toBindPhone:(NSDictionary *)dict
      successBlock:(void (^)(NSDictionary * success))successBlock
      failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020BindPhone];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//auth/nauth/mobile/thirdparty/check
-(void)thirdpartyCheck:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020ThirdpartyCheck];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)toRegisterAPI:(NSDictionary *)dict
        successBlock:(void (^)(NSDictionary * success))successBlock
        failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020NewRegister];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)robNiuNiuBetWithChatID:(NSString *)chatID SuccessBlock:(void (^)(NSDictionary * success))successBlock
        failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:ActRequestRobNiuNiuBet];
    [self requestWithData:@{@"chatId":chatID} requestInfo:info success:successBlock fail:failureBlock];
}

-(void)toGuestLoginAPI:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020ToGuestLogin];
    info.requestType = RequestType_get;
    [self requestWithData:nil requestInfo:info success:successBlock fail:failureBlock];
}

//游戏大厅，所有红包游戏的房间：/skChatGroup/listOfficialGroupPage
-(void)listOfficialGroupPage:(NSDictionary *)dict
                successBlock:(void (^)(NSDictionary * success))successBlock
                failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020ListOfficialGroupPage];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//官方群进群之前的校验："/social/skChatGroup/checkJoin";校验通过再调用进群的接口，校验不通过弹出提示给用户
-(void)checkJoin:(NSDictionary *)dict
    successBlock:(void (^)(NSDictionary * success))successBlock
    failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020CheckJoin];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//修改内部号对备注名http://sit_gateway.fy.com/social/friend/updateInternalNick.
//数据格式：{"friendNick":"峰9528","userId":"14102"}
-(void)updateInternalNick:(NSDictionary *)dict
             successBlock:(void (^)(NSDictionary * success))successBlock
             failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020UpdateInternalNick];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

//获取所有的好友备注http://sit_gateway.fy.com/social/friend/selectInternalNick[Logger]
-(void)selectInternalNick:(NSDictionary *)dict
             successBlock:(void (^)(NSDictionary * success))successBlock
             failureBlock:(void (^)(NSError *failure))failureBlock{
    RequestInfo *info = [self requestInfoWithAct:Act2020SelectInternalNick];
    [self requestWithData:dict requestInfo:info success:successBlock fail:failureBlock];
}

-(void)urlRoutes:(NSString *)url
    successBlock:(void (^)(NSString * success))successBlock
    failureBlock:(void (^)(NSError *failure))failureBlock{
    AFHTTPSessionManager2 *http = [self createHttpSessionManager];
    //request.setValue("bytes=%lld-", forHTTPHeaderField: "Range")
    [http.requestSerializer setValue:@"bytes=%lld-" forHTTPHeaderField:@"Range"];
    http.responseSerializer = [AFHTTPResponseSerializer serializer];
    [http GET:url parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *respons=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (respons) {
            successBlock(respons);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
}


#pragma mark - 请求路径配置
- (RequestInfo *)requestInfoWithAct:(Act)act
{
    return [self createRequestInfoWithAct:act];
}

- (RequestInfo *)createRequestInfoAct:(Act)act
{
    RequestInfo *info = [[RequestInfo alloc] initWithType:RequestType_post];
    info.act = act;
    NSString *urlTail = nil;
    switch (act) {
        case ActRequestMsgBanner:
            urlTail = @"auth/basic/getAdv";
            break;
        case ActRequestClickBanner:
            urlTail = @"auth/basic/addAdvCnt";
            break;
        case ActRequestToken:
            urlTail = @"auth/nauth/mobile/token";
            break;
        case ActCheckLogin:
            urlTail = @"auth/nauth/regform/loginShowList";
            break;
        case ActRequestCaptcha:
            urlTail = @"auth/common/captcha";
            break;
        case ActRequestTokenBySMS:
            urlTail = @"auth/mobile/token";
            break;
        case ActCheckRegister:
            urlTail = @"auth/nauth/regform/regShowList";
            break;
        case ActRegister:
            urlTail = @"auth/nauth/mobile/token/reg";
            break;
        case ActRequestUserInfo:
            urlTail = @"admin/user/baseInfo";
            break;
        case ActResetPassword:
            urlTail = @"auth/user/mobile/token/resetPasswd";
            break;
        case ActUpPayPasswd:
            urlTail = @"social/skBalanceDailyEarnings/upPayPasswd";
            break;
        case ActRequestVerifyCode:
            urlTail = @"auth/common/smsCode";
            break;
        case ActRequestBankList:
            urlTail = @"social/cashDraws/getSysBankcard";
            break;
        case ActDraw:
            //ActRequestWithdraw 接口一样，参数不一样，所以都保留
            urlTail = @"social/cashDraws/cash";
            break;
        case ActRequestBillList:
            urlTail = @"social/bill/page";
            break;
        case ActRequestBillTypeList:
            urlTail = @"social/bill/list";
            break;
        case ActUploadImg:
            urlTail = @"admin/user/upload";
            break;
        case ActModifyUserInfo:
            urlTail = @"admin/user/updateAvatarNickName";
            break;
        case ActRequestCommonInfo:
            urlTail = @"auth/basic/getAppConfig";
            break;
        case ActMyPlayer:
            urlTail = @"social/proxy/myUserPage";
            break;
        case ActCheckMyPlayers:
            urlTail = @"social/proxy/team/count";
            break;
        case ActRequestAgentReportInfo:
            urlTail = @"social/proxy/team/user/report";
            break;
        case ActRequestPromotionCourse:
            urlTail = @"social/proxy/queryPromoteCourse";
            break;
        case ActRequestSystemNotice:
            urlTail = @"social/basic/noticePage";
            break;
        case ActRequestShareList:
            urlTail = @"social/promotionShare/page";
            break;
        case ActAddShareCount:
            urlTail = @"social/promotionShare/addCount";
            break;
        case ActRequestRechargeList:
            urlTail = @"finance/skPayChannel/page";
            break;
        case ActRequestReportForms:
            urlTail = @"social/proxy/allData";
            break;
        case ActRemoveToken:
            urlTail = @"auth/authentication/removeToken";
            break;
        case ActRequestActivityList:
            urlTail = @"social/promotReward/list";
            break;
        case ActGetReward:
            urlTail = @"social/promotReward/receive";
            break;
        case ActGetFirstRewardInfo:
            urlTail = @"social/promotReward/getRechargeReward";
            break;
        case ActToBeAgent:
            urlTail = @"social/proxy/applyAgent";
            break;
        case ActGetLotterys:
            urlTail = @"microgame/userLottery/lotteryItems";
            break;
        case ActGetLotteryList:
            urlTail = @"microgame/userLottery/lotteryUserList";
            break;
        case ActLottery:
            urlTail = @"microgame/userLottery/startLottery";
            break;
        case ActAddBankCard:
            urlTail = @"social/cashDraws/addBankcard";
            break;
        case ActRequestMyBankList:
            urlTail = @"social/cashDraws/getMyBankcard/V2";
            break;
        case ActRequestWithdrawHistory:
            urlTail = @"social/cashDraws/page";
            break;
        case ActRequestRechargeListAll:
            urlTail = @"finance/skPayChannel/querPromotionShares";
            break;
        case ActRequestRechargeChannel:
            urlTail = @"pay/recharge/getChanelDetail";
            break;
        case ActOrderRechargeCheckUser:
            urlTail = @"pay/recharge/checkUser";
            break;
        case ActRequestAgentDatas:
            urlTail = @"social/proxy/todayAgentDetails";
            break;
        case ActOrderRecharge:
            urlTail = @"pay/recharge/submit";
            break;
        case ActRequestShareUrl:
            urlTail = @"social/promotionShare/getDomain";
            break;
        case ActRequestGuideImageList:
            urlTail = @"social/basic/querySkHelpCenter";
            break;
        case ActRequestActivityList2:
            urlTail = @"social/promotReward/promotPage";
            break;
        case ActRequestFaBaoList:
            urlTail = @"social/promotReward/send/detail";
            break;
        case ActRequestQiaoBaoList:
            urlTail = @"social/promotReward/rob/detail";
            break;
        case ActRequestJiujiJingList:
            urlTail = @"social/promotReward/relief";
            break;
        case ActRequestListUserActivity:
            urlTail = @"social/userActivity/listUserActivity";
            break;
        case ActRequestListRecord:
            urlTail = @"social/userActivityRecord/listRecord";
            break;
        case ActRequestListRedBonusType:
            urlTail = @"social/redBonusTypeConfig/listRedBonusType";
            break;
        case OnlineCustomerService:
            urlTail = @"social/friend/getContact";
            break;
        case ActJoinSelfGroupList:
            urlTail = @"social/skChatGroup/joinSelfGroupPage";
            break;
        case ActRequestjoinGroupPage://会话列表
            urlTail = @"social/skChatGroup/joinGroupPage";
            break;
        case ActRequestlistOfficialGroup://获取所有红包子游戏
            urlTail = @"social/skChatGroup/listOfficialGroup";
            break;
        case ActRequestChatGroupJoin:
            urlTail = @"social/skChatGroup/join";
            break;
        case ActRequestOfficeGroupCheckJoinNew:
            urlTail = @"social/skChatGroup/checkJoinNew";
            break;
        case ActRequestChatGroupQuit://退出群组
            urlTail = @"social/skChatGroup/quit";
            break;
        case ActRequestRobNiuNiuInfo:
            urlTail = @"redpacket/rabniuniu/getRobNiuNiuInfo";
            break;
        case ActRequestRobNiuNiuBet:
            urlTail = @"social/skChatGroup/listOfficialGroup";
            break;
        case ActRequestRobNiuNiuBetAmount:
            urlTail = @"redpacket/rabniuniu/getRobNiuNiuBet";
            break;
            
#pragma mark 请求路径 - 百人牛牛
        case ActRequestBestNiuNiuInfo:
            urlTail = @"bairenniuniu/bairenniuniu/getBrnnInfo";
            break;
        case ActRequestBestNiuNiuGameOdds:
            urlTail = @"bairenniuniu/bairenniuniu/gameOdds";
            break;
        case ActRequestBestNiuNiuBett:
            urlTail = @"bairenniuniu/bairenniuniu/bett";
            break;
        case ActRequestBestNiuNiuHistory://百人牛牛 -历史详情
            urlTail = @"bairenniuniu/bairenniuniu/history";
            break;
        case ActRequestBestNiuNiuGameRecords:
            urlTail = @"bairenniuniu/bairenniuniu/gameRecords";
            break;
        case ActRequestBestNiuNiuGameRecordsDetail:
            urlTail = @"bairenniuniu/bairenniuniu/gameRecordsDetail";
            break;
        case ActRequestBestNiuNiuGameTrendsChart:
            urlTail = @"bairenniuniu/bairenniuniu/runChart";
            break;
            
#pragma mark 请求路径 - 包包彩
        case ActRequestBagBagLotteryInfo:
            urlTail = @"baobaocai/baobaocai/getBBCInfo";
            break;
        case ActRequestBagBagLotteryBett:
            urlTail = @"baobaocai/baobaocai/bett";
            break;
        case ActRequestBagBagLotteryGameOdds:
            urlTail = @"baobaocai/baobaocai/gameOdds";
            break;
        case ActRequestBagBagLotteryGameRecords:
            urlTail = @"baobaocai/baobaocai/gameRecords";
            break;
        case ActRequestBagBagLotteryGameRecordsDetail:
            urlTail = @"baobaocai/baobaocai/gameRecordsDetail";
            break;
        case ActRequestBagBagLotteryHistory:
            urlTail = @"baobaocai/baobaocai/history";
            break;
        case ActRequestBagBagLotteryGrap:
            urlTail = @"baobaocai/baobaocai/grap";
            break;
        case ActRequestBagBagLotteryGrapDetail:
            urlTail = @"baobaocai/baobaocai/grapDetail";
            break;
        case ActRequestBagBagLotteryTrendsChart:
            urlTail = @"baobaocai/baobaocai/runChart";
            break;
            
#pragma mark 请求路径 - 接龙红包
        case ActRequestSolitaireInfo:
            urlTail = @"redpacket/solitaire/getSolitaireInfo";
            break;
        case ActRequestSolitaireSend:
            urlTail = @"redpacket/solitaire/send";
            break;
        case ActRequestSolitaireRecordPage://接龙投注记录
            urlTail = @"social/solitaire/querySolitaireRecordPage";
            break;
            
#pragma mark 请求路径 - 抢庄牛牛
        case ActRequestRobFinance://抢庄牛牛获取用户余额
            urlTail = @"redpacket/rabniuniu/getUserFinance";
            break;
        case ActRequestRobBett: //抢庄牛牛投注
            urlTail = @"redpacket/rabniuniu/bett";
            break;
        case ActRequestRobBankeer://抢庄接口
            urlTail = @"redpacket/rabniuniu/robBankeer";
            break;
        case ActRequestRobRedpacket://抢庄牛牛发红包
            urlTail = @"redpacket/rabniuniu/sendRedpacket";
            break;
            
#pragma mark - 极速扫雷
        case ActRequestJsslInfo://极速扫雷 - 群状态
            urlTail = @"jisusaolei/fastBomb/getJsslInfo";
            break;
        case ActRequestJsslGameOdds://极速扫雷 -赔率
            urlTail = @"jisusaolei/fastBomb/getOdds";
            break;
        case ActRequestJsslGameBett://极速扫雷 -投注
            urlTail = @"jisusaolei/fastBomb/bett";
            break;
        case ActRequestJsslGameHistory://极速扫雷 -历史记录
            urlTail = @"jisusaolei/fastBomb/record";
            break;
        case ActRequestJsslGameRecords: // 极速扫雷 -游戏记录
            urlTail = @"jisusaolei/fastBomb/gamerecord";
            break;
        case ActRequestJsslGameRecordsDetail: // 极速扫雷 -游戏记录详情
            urlTail = @"jisusaolei/fastBomb/userBetDetail";
            break;
        case ActRequestJsslGameTrendsChart: // 极速扫雷 -走势图
            urlTail = @"jisusaolei/fastBomb/chart";
            break;

#pragma mark - 
        case ActRequestRobContinueBanker://连续上庄接口
            urlTail = @"redpacket/rabniuniu/continueBanker";
            break;
        case ActRequestRobBettingRecord://投注记录
            urlTail = @"social/skRedbonusRobNiuniu/bettingRecord";
            break;
        case ActRequestRobGameDetails://游戏记录
            urlTail = @"social/skRedbonusRobNiuniu/gameDetails";
            break;
        case ActRequestRobPeriodRecord://期数记录
            urlTail = @"social/skRedbonusRobNiuniu/periodRecord";
            break;
        case ActRequestBalanceDetails:// 获取账户详情
            urlTail = @"social/skBalanceDailyEarnings/getBalanceDetails";
            break;
        case ActRequestEarningsReport:// 获取收益报表
            urlTail = @"social/skBalanceDailyEarnings/earningsReport";
            break;
        case ActRequestMoneyDetail://获取资金详情
            urlTail = @"social/skBalanceDailyEarnings/getMoneyDetail";
            break;
        case ActRequestIntoMoney://转入
            urlTail = @"social/skBalanceDailyEarnings/intoMoney";
            break;
        case ActRequestOutMoney://转出
            urlTail = @"social/skBalanceDailyEarnings/rollOutMoneys";
            break;
        case ActRequestGroupList://获取我加入的群组列表
            urlTail = @"social/skChatGroup/joinGroupPage";
            break;
        case ActRequestGroupInfo://根据群组id获取群组信息
            urlTail = @"social/skChatGroup/selfInfo";
            break;
        case ActRequestAddGroup://加入群
            urlTail = @"social/skChatGroup/join";
            break;
        case ActRequestInviteToGroup://邀请入群
            urlTail = @"social/skChatGroup/invite";
            break;
        case ActRequestMyGroup://分页查询群邀请记录
            urlTail = @"social/skChatGroupInvite/selectPage";
            break;
        case ActRequestOperateGroup://拒绝或同意群邀请
            urlTail = @"social/skChatGroupInvite/updateInvite";
            break;
        case ActRequestQuitGroup://退出群组
            urlTail = @"social/skChatGroup/quit";
             break;
        case ActRequestFindFriendById:
             urlTail = @"social/friend/findFriendById";
             break;
        case ActRequestUpdateFriendNick:
             urlTail = @"social/friend/updateFriendNick";
             break;
        case ActRequestContact://获取在线客服列表
            urlTail = @"social/friend/getContact";
            break;
        case ActRequestAddBankcard:
            urlTail = @"social/cashDraws/savePayment";//添加提现银行卡
            break;
        case ActRequestUnbindBankcard:
            urlTail = @"social/cashDraws/unbandingPayment";//解绑银行卡
            break;
        case ActRequestWithdraw:
            urlTail = @"social/cashDraws/cash";//提款
            break;
        case ActNil:
            urlTail = @"";
            break;
        case ActRequestGameTypes:
            urlTail = @"social/skChatManage/allList";
            break;
        case ActRequestGameCheckStatus:
            urlTail = @"social/skChatManage/checkStatus";
            break;
            
#pragma mark 请求路径 - 自建群
        case ActRequestGroupRedTypeList:
            urlTail = @"social/skChatManage/redList";
            break;
        // 红包模板
        case ActSelfGroupTemplateBomb:
            urlTail = @"social/skChatGroup/selfGroupTemplate/bomb";
            break;
        case ActSelfGroupTemplateNiuNiu:
            urlTail = @"social/skChatGroup/selfGroupTemplate/niuNiu";
            break;
        case ActSelfGroupTemplateTwoPeopleNiuNiu:
            urlTail = @"social/skChatGroup/selfGroupTemplate/twoniuNiu";
            break;
        case ActSelfGroupTemplateRobNiuNiu:
            urlTail = @"social/skChatGroup/selfGroupTemplate/robNiuNiu";
            break;
        case ActSelfGroupTemplateErBaGang:
            urlTail = @"social/skChatGroup/selfGroupTemplate/erBaGang";
            break;
        // 更细红包设置
        case ActUpdateGroupRedPacketBomb:
            urlTail = @"social/skChatGroup/updateSelfGroup/bomb";
            break;
        case ActUpdateGroupRedPacketNiuNiu:
            urlTail = @"social/skChatGroup/updateSelfGroup/niuNiu";
            break;
        case ActUpdateGroupRedPacketErBaGang:
            urlTail = @"social/skChatGroup/updateSelfGroup/erBaGang";
            break;
        case ActUpdateGroupRedPacketTowNiuNiu:
            urlTail = @"social/skChatGroup/updateSelfGroup/twoNiuNiu";
            break;
        case ActUpdateGroupRedPacketRobNiuNiu:
            urlTail = @"social/skChatGroup/updateSelfGroup/robNiuNiu";
            break;
        // 创建自建群
        case ActCreateGroupTypeBomb:
            urlTail = @"social/skChatGroup/createSelfGroup/bomb";
            break;
        case ActCreateGroupTypeNiuNiu:
            urlTail = @"social/skChatGroup/createSelfGroup/niuNiu";
            break;
        case ActCreateGroupTypeRobNiuNiu:
            urlTail = @"social/skChatGroup/createSelfGroup/robNiuNiu";
            break;
        case ActCreateGroupTypeErBaGang:
            urlTail = @"social/skChatGroup/createSelfGroup/erBaGang";
            break;
        case ActCreateGroupTypeTowNiuNiu:
            urlTail = @"social/skChatGroup/createSelfGroup/twoNiuNiu";
            break;
        case ActCreateGroupTypeRobFuLi:
            urlTail = @"social/skChatGroup/createSelfGroup/normal";
            break;
        // 禁言，禁图
        case ActSelfCreateGroupStopSpeak:
            urlTail = @"social/skChatGroup/groupStopShutup";
            break;
        case ActSelfCreateGroupStopPic:
            urlTail = @"social/skChatGroup/groupStopPic";
            break;
        //MessageNet 迁移
        case ActUpdateGroupName:
            urlTail = @"social/skChatGroup/updateGroupName";
            break;
        case ActUpdateGroupNotice:
            urlTail = @"social/skChatGroup/updateGroupNotice";
            break;
        case ActGetNotIntoGroupPage:
            urlTail = @"social/skChatGroup/getNotIntoGroupPage";
            break;
        case ActGroupUsersAndSelf:
            urlTail = @"social/skChatGroup/groupUsersAndSelf";
            break;
        case ActAddgroupMember:
            urlTail = @"social/skChatGroup/addGroupMember";
            break;
        case ActGroupSelect:
            urlTail = @"social/skChatGroup/select";
            break;
        case ActSkChatGroupInformation:
            urlTail = @"social/skChatGroup/";
            break;
        case ActSelfGroupInvite:
            urlTail = @"social/skChatGroup/selfGroupInvite";
            break;
        case ActAppLogin:
            urlTail = @"social/basic/appLogin";
            break;
        case ActPullFriendOfflineMsg:
            urlTail = @"social/friend/pullFriendOfflineMsg";
            break;
        case ActGetWaterDetail:
            urlTail = @"redpacket/redpacket/getWaterDetail";
            break;
        case ActRedpacketDetail:
            urlTail = @"redpacket/redpacket/detail";
            break;
        case ActRedpacketGrab:
            urlTail = @"redpacket/redpacket/grab";
            break;
        case ActRedpacketSend:
            urlTail = @"redpacket/redpacket/send";
            break;
        case ActDelgroupMember:
            urlTail = @"social/skChatGroup/delGroupMember";
            break;
        case ActSkChatroupStop:
            urlTail = @"social/skChatGroup/groupStop";
            break;
        case ActGroupStopPic:
            urlTail = @"social/skChatGroup/groupStopPic";
            break;
        case ActSearchGroupUsers:
            urlTail = @"social/skChatGroup/groupUsers";
            break;
        case ActQueryGroupUsers:
            urlTail = @"social/skChatGroup/queryGroupUsers";
            break;
        case ActQuerySelfDeleteGroupUsers:
            urlTail = @"social/skChatGroup/querySelfGroupUsers";
            break;
        case ActDelGroup:
            urlTail = @"social/skChatGroup/delGroup";
            break;
        case ActIsDisplayCreateGroup:
            urlTail = @"social/skChatManage/redList";
            break;
        case Act2020AuthLoginToken:
            urlTail = @"auth/nauth/new/mobile/token";
            break;
        case Act2020GetLoginConfig:
            urlTail = @"auth/basic/getLoginConfig";
            break;
        case Act2020ThirdpartRegister:
            urlTail = @"auth/nauth/mobile/thirdparty/reg";
            break;
        case Act2020BindPhone:
            urlTail = @"social/basic/bindPhoneNo";
            break;
        case Act2020ThirdpartyCheck:
            urlTail = @"auth/nauth/mobile/thirdparty/check";
            break;
        case Act2020NewRegister:
            urlTail = @"auth/nauth/mobile/token/newreg";
            break;
        case Act2020ToGuestLogin:
            urlTail = @"auth/nauth/guest";
            break;
        case Act2020ListOfficialGroupPage:
            urlTail = @"social/skChatGroup/listOfficialGroupPage";
            break;
        case Act2020CheckJoin:
            urlTail = @"social/skChatGroup/checkJoin";
            break;
        case Act2020UpdateInternalNick:
            urlTail = @"social/friend/updateInternalNick";
            break;
        case Act2020SelectInternalNick:
            urlTail = @"social/friend/selectInternalNick";
            break;
        default:
            break;
    }
    info.url = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,urlTail];
    return info;
}


@end

