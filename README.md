# AppDelegateManager
AppDelegateManager

https://www.jianshu.com/p/de954394a5d3

- (void)loginView:(ZBLoginView *)loginView buttonType:(ZBLoginViewButtonType)buttonType
{
    //检查网络
    if (![ZBNetworkReachabilityTool sharedNetworkReachabilityTool].isReachable) {
        [self showNotice:@"请检查网络"];
        return;
    }
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    switch (buttonType) {
        //微博
        case ZBLoginViewButtonTypeWeiBoLogin:
        {
            [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                //这里做的是，拿到三方的回调数据，然后根据这些数据向自己的服务器请求注册登录。
                [self requestLogin:user loginType:SSDKPlatformTypeSinaWeibo];
            } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    NSLog(@"登录成功");
                }
                [self.activityIndicatorView stopAnimating];
                [self.activityIndicatorView setHidesWhenStopped:YES];
            }];
        
        }
            break;
          
        //微信
        case ZBLoginViewButtonTypeWechatLogin:
        {
            [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                [self requestLogin:user loginType:SSDKPlatformTypeWechat];
            } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    NSLog(@"登录成功");
                }
                [self.activityIndicatorView stopAnimating];
                [self.activityIndicatorView setHidesWhenStopped:YES];
            }];
            
        }
            break;
        
        //QQ
        case ZBLoginViewButtonTypeQQLogin:
        {
            [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                [self requestLogin:user loginType:SSDKPlatformTypeQQ];
            } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                    NSLog(@"登录成功");
                }
                [self.activityIndicatorView stopAnimating];
                [self.activityIndicatorView setHidesWhenStopped:YES];
            }];
        }
            break;
            
        default:
            break;
    }
}



//三方登录请求接口

- (void)requestLogin:(SSDKUser *)user loginType:(SSDKPlatformType)loginType
{
    NSMutableDictionary *paramDict = [self gainParameterWithUser:user loginType:loginType];
    
    //在这个方法里面调用自己服务器的后台登录接口，根据回调数据，选择合适的参数调用接口注册登录。
    [self loginWithThirdPartyWithParam:paramDict];

}

- (NSMutableDictionary *)gainParameterWithUser:(SSDKUser *)user loginType:(SSDKPlatformType)loginType
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    NSString *logAuthTypeType = nil;

    switch (loginType) {
            
        case SSDKPlatformTypeWechat:
        {
            logAuthTypeType = @"2";
        }
            break;
            
        case SSDKPlatformTypeQQ:
        {
            logAuthTypeType = @"3";
        }
            break;
            
        case SSDKPlatformTypeSinaWeibo:
        {
            logAuthTypeType = @"4";
        }
            break;
            
        default:
            break;
    }
    
    switch (user.gender) {
        case SSDKGenderMale:
            [paramDict setObject:@"1" forKey:@"userSex"];
            break;
        case SSDKGenderFemale:
            [paramDict setObject:@"2" forKey:@"userSex"];
            break;
        case SSDKGenderUnknown:
            [paramDict setObject:@"0" forKey:@"userSex"];
            break;
        default:
            break;
    }
    
    //生日
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:user.birthday];
    
    [paramDict setObject:user.uid?:@"" forKey:@"authOpenid"];                                       //openid
    [paramDict setObject:logAuthTypeType?:@"" forKey:@"authType"];                                  //authorType
    [paramDict setObject:[user.rawData objectForKey:@"unionid"]?:@"" forKey:@"authUnionid"];        //authUnionid
//    [paramDict setObject:[user.rawData objectForKey:@"age"]?:@"" forKey:@"userAge"];                //userAge
    [paramDict setObject:user.icon?:@"" forKey:@"userAvatar"];                                      //userAvatar
//    [paramDict setObject:dateStr?:@"" forKey:@"userBirthday"];                                      //userBirthday
    [paramDict setObject:[user.rawData objectForKey:@"city"]?:@"" forKey:@"userCity"];              //userCity
    [paramDict setObject:user.nickname?:@"" forKey:@"userNickname"];                                //userNickname
    [paramDict setObject:[user.rawData objectForKey:@"province"]?:@"" forKey:@"userProvince"];      //userProvince
    [paramDict setObject:user.verifyReason?:@"" forKey:@"verifiedReason"];                          //verifiedReason
    
    return paramDict;
}

//在这里实现请求登录。

- (void)loginWithThirdPartyWithParam:(NSMutableDictionary *)paramDict
{
    NSString *phoneLoginServer = [NSString stringWithFormat:@"%@%@",kDomainURL,kLoginThirdPartyLogin];
    
    [[NetWorkManager manager] requestByPostNetworkWithServerUrl:phoneLoginServer parameters:paramDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
        NSLog(@"%@",responseObject);
        
    } error:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error---%@",error);
        
    }];

}

