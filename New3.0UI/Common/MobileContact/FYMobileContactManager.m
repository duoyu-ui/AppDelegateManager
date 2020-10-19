//
//  FYMobileContactManager.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMobileContactManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FYMobilePerson.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "NSString+FYMobilePerson.h"

#define FY_MOBILE_CONTACT_IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface FYMobileContactManager ()

@property (nonatomic, copy) void (^handler) (NSString *, NSString *);
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, strong) CNContactStore *contactStore;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation FYMobileContactManager

+ (instancetype)sharedInstance
{
    static id shared_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_instance = [[self alloc] init];
    });
    return shared_instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queue = dispatch_queue_create("com.addressBook.queue", DISPATCH_QUEUE_SERIAL);
        
        if (FY_MOBILE_CONTACT_IOS9_OR_LATER)
        {
            _contactStore = [CNContactStore new];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_contactStoreDidChange)
                                                         name:CNContactStoreDidChangeNotification
                                                       object:nil];
        }
        else
        {
            _addressBook = ABAddressBookCreate();
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, _addressBookChange, nil);
        }
    }
    return self;
}

- (NSArray *)keys
{
    if (!_keys)
    {
        _keys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                  CNContactPhoneNumbersKey,
                  CNContactOrganizationNameKey,
                  CNContactDepartmentNameKey,
                  CNContactJobTitleKey,
                  CNContactPhoneticGivenNameKey,
                  CNContactPhoneticFamilyNameKey,
                  CNContactPhoneticMiddleNameKey,
                  CNContactImageDataKey,
                  CNContactThumbnailImageDataKey,
                  CNContactEmailAddressesKey,
                  CNContactPostalAddressesKey,
                  CNContactBirthdayKey,
                  CNContactNonGregorianBirthdayKey,
                  CNContactInstantMessageAddressesKey,
                  CNContactSocialProfilesKey,
                  CNContactRelationsKey,
                  CNContactUrlAddressesKey];
        
    }
    return _keys;
}

#pragma mark - Public

- (void)requestAddressBookAuthorization:(void (^)(BOOL authorization))completion
{
    if (FY_MOBILE_CONTACT_IOS9_OR_LATER)
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            _blockExecute(completion, status == CNAuthorizationStatusAuthorized);
        }
    }
    else
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            _blockExecute(completion, ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized);
        }
    }
}

- (void)accessContactsComplection:(void (^)(BOOL, NSArray<FYMobilePerson *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            if (FY_MOBILE_CONTACT_IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil);
            }
        }
    }];
}

- (void)accessSectionContactsComplection:(void (^)(BOOL, NSArray<FYSectionMobilePerson *> *, NSArray<NSString *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            if (FY_MOBILE_CONTACT_IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil, nil);
            }
        }
    }];
}



#pragma mark - Private

- (void)_authorizationAddressBook:(void (^) (BOOL succeed))completion
{
    if (FY_MOBILE_CONTACT_IOS9_OR_LATER)
    {
        [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (completion)
            {
                completion(granted);
            }
        }];
    }
    else
    {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (completion)
            {
                completion(granted);
            }
        });
    }
}

void _blockExecute(void (^completion)(BOOL authorizationA), BOOL authorizationB)
{
    if (completion)
    {
        if ([NSThread isMainThread])
        {
            completion(authorizationB);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(authorizationB);
            });
        }
    }
}

- (void)_showAlertFromController:(UIViewController *)controller
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"您的通讯录暂未允许访问，请去设置->隐私里面授权!", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:([UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }])];
    [alertControl addAction:([UIAlertAction actionWithTitle:NSLocalizedString(@"去设置", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                         }];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }])];
    [controller presentViewController:alertControl animated:YES completion:nil];
}

- (void)_asynAccessAddressBookWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableArray *datas = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(weakSelf.addressBook);
        CFIndex count = CFArrayGetCount(allPeople);
        
        for (int i = 0; i < count; i++)
        {
            ABRecordRef record = CFArrayGetValueAtIndex(allPeople, i);
            FYMobilePerson *personModel = [[FYMobilePerson alloc] initWithRecord:record];
            [datas addObject:personModel];
        }
        
        CFRelease(allPeople);
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_asynAccessContactStoreWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        
        NSMutableArray *datas = [NSMutableArray array];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.keys];
        [weakSelf.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            FYMobilePerson *person = [[FYMobilePerson alloc] initWithCNContact:contact];
            [datas addObject:person];
            
        }];
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_sortNameWithDatas:(NSArray *)datas completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (FYMobilePerson *person in datas)
    {
        // 拼音首字母
        NSString *firstLetter = nil;
        
        if (person.fullName.length == 0)
        {
            firstLetter = @"#";
        }
        else
        {
            NSString *pinyinString = [NSString fy_pinyinForString:person.fullName];
            person.pinyin = pinyinString;
            NSString *upperStr = [[pinyinString substringToIndex:1] uppercaseString];
            NSString *regex = @"^[A-Z]$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            firstLetter = [predicate evaluateWithObject:upperStr] ? upperStr : @"#";
        }
        
        if (dict[firstLetter])
        {
            [dict[firstLetter] addObject:person];
        }
        else
        {
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:person, nil];
            dict[firstLetter] = arr;
        }
    }
    
    NSMutableArray *keys = [[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    if ([keys.firstObject isEqualToString:@"#"])
    {
        [keys addObject:keys.firstObject];
        [keys removeObjectAtIndex:0];
    }
    
    NSMutableArray *persons = [NSMutableArray array];
    
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FYSectionMobilePerson *person = [FYSectionMobilePerson new];
        person.key = key;
        
        // 组内按照拼音排序
        NSArray *personsArr = [dict[key] sortedArrayUsingComparator:^NSComparisonResult(FYMobilePerson *person1, FYMobilePerson *person2) {
            
            NSComparisonResult result = [person1.pinyin compare:person2.pinyin];
            return result;
        }];
        
        person.persons = personsArr;
        
        [persons addObject:person];
    }];
    
    if (completcion)
    {
        completcion(persons, keys);
    }
}

void _addressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    if ([FYMobileContactManager sharedInstance].contactChangeHandler)
    {
        [FYMobileContactManager sharedInstance].contactChangeHandler();
    }
}

- (void)_contactStoreDidChange
{
    if ([FYMobileContactManager sharedInstance].contactChangeHandler)
    {
        [FYMobileContactManager sharedInstance].contactChangeHandler();
    }
}

- (void)dealloc
{
    if (FY_MOBILE_CONTACT_IOS9_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
    }
    else
    {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, _addressBookChange, nil);
        if (_addressBook)
        {
            CFRelease(_addressBook);
            _addressBook = NULL;
        }
    }
}

@end


