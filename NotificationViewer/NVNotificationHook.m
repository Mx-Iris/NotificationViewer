//
//  NVNotificationHook.m
//  NotificationViewer
//
//  Created by JH on 11/2/24.
//

#import "NVNotificationHook.h"
#import <OSLog/OSLog.h>
#import <objc/runtime.h>

static os_log_t logger = nil;

@interface NVNotificationHook ()

@property (strong) NSMutableArray<NSNotification *> *mutableNotifications;

@end

@implementation NVNotificationHook

+ (instancetype)sharedHook {
    static NVNotificationHook *hook = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hook = [[NVNotificationHook alloc] init];
        hook.mutableNotifications = [NSMutableArray array];
        logger = os_log_create("com.JH.NotificationViewer", "NotificationViewer");
        hook.enabledLogging = YES;
    });
    return hook;
}

- (NSArray<NSNotification *> *)notifications {
    return self.mutableNotifications.copy;
}

@end


@implementation NSNotificationCenter (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // 交换 postNotification: 方法
        SEL originalSelector = @selector(postNotification:);
        SEL swizzledSelector = @selector(swizzled_postNotification:);
        
        [self swizzleMethod:class originalSel:originalSelector swizzledSel:swizzledSelector];
        
        // 交换 postNotificationName:object: 方法
        SEL originalSelector2 = @selector(postNotificationName:object:);
        SEL swizzledSelector2 = @selector(swizzled_postNotificationName:object:);
        
        [self swizzleMethod:class originalSel:originalSelector2 swizzledSel:swizzledSelector2];
        
        // 交换 postNotificationName:object:userInfo: 方法
        SEL originalSelector3 = @selector(postNotificationName:object:userInfo:);
        SEL swizzledSelector3 = @selector(swizzled_postNotificationName:object:userInfo:);
        
        [self swizzleMethod:class originalSel:originalSelector3 swizzledSel:swizzledSelector3];
    });
}

+ (void)swizzleMethod:(Class)class originalSel:(SEL)originalSelector swizzledSel:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)swizzled_postNotification:(NSNotification *)notification {
    if (NVNotificationHook.sharedHook.isEnabledLogging) {
        os_log_debug(logger, "Post notification name: %@, object: %@, userInfo: %@", notification.name, notification.object, notification.userInfo);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NVNotificationHook sharedHook].mutableNotifications addObject:notification];
    });
    [self swizzled_postNotification:notification];
}

- (void)swizzled_postNotificationName:(NSNotificationName)aName object:(id)anObject {
    if (NVNotificationHook.sharedHook.isEnabledLogging) {
        os_log_debug(logger, "Post notification name: %@, object: %@", aName, anObject);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NVNotificationHook sharedHook].mutableNotifications addObject:[NSNotification notificationWithName:aName object:anObject]];
    });
    [self swizzled_postNotificationName:aName object:anObject];
}

- (void)swizzled_postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    if (NVNotificationHook.sharedHook.isEnabledLogging) {
        os_log_debug(logger, "Post notification name: %@, object: %@, userInfo: %@", aName, anObject, aUserInfo);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NVNotificationHook sharedHook].mutableNotifications addObject:[NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo]];
    });
    [self swizzled_postNotificationName:aName object:anObject userInfo:aUserInfo];
}

@end
