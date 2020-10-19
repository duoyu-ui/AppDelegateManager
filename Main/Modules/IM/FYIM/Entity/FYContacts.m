//
//  Contacts.m
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYContacts.h"

@interface FYContacts () <WHC_SqliteInfo>

@end

@implementation FYContacts

MJCodingImplementation

- (id)initWithPropertiesDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        if (dict != nil) {
            self.userId = [NSString stringWithFormat:@"%@", dict[@"userId"]];
            self.name = [dict stringForKey:@"nick"];
            self.nick = [dict stringForKey:@"nick"];
            self.avatar = [dict stringForKey:@"avatar"];
            self.sessionId = [dict stringForKey:@"chatId"];
            self.friendNick = [dict stringForKey:@"friendNick"];
            self.isFriend = [dict boolForKey:@"isFriend"];
            self.status = [dict int32ForKey:@"status"];
        }
    }
    return self;
}

+ (NSString *)whc_SqliteVersion
{
    return @"1.0.1";
}

@end
