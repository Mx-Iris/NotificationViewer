//
//  NVNotificationHook.m
//  NotificationViewer
//
//  Created by JH on 11/2/24.
//

#import "NVNotificationHook.h"
#import "fishhook.h"

//#import <AppKit/AppKit.h>

//void (*orig_CFXNotificationPost)(CFNotificationCenterRef center, id notification, BOOL deliverImmediately);
//
//void my_CFXNotificationPost(CFNotificationCenterRef center, id notification, BOOL deliverImmediately) {
//    NSLog(@"NotificationViewer: %@", notification);
//    orig_CFXNotificationPost(center, notification, deliverImmediately);
//}

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
    });
    return hook;
}

+ (void)load {
//    [[NSNotificationCenter defaultCenter] addObserver:[self sharedHook] selector:@selector(rebinds) name:NSApplicationWillFinishLaunchingNotification object:nil];
//     struct rebinding rebindings[] = {
//         {"CFXNotificationPost", my_CFXNotificationPost, (void **)&orig_CFXNotificationPost},
//     };
//     NSLog(@"%d", rebind_symbols(rebindings, 1));
//     NSLog(@"rebinds");
}

- (void)rebinds {
    
}

- (NSArray<NSNotification *> *)notifications {
    return self.mutableNotifications.copy;
}

@end

#import <objc/runtime.h>

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
    NSLog(@"Post notification name: %@, object: %@, userInfo: %@", notification.name, notification.object, notification.userInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NVNotificationHook sharedHook].mutableNotifications addObject:notification];
    });
    [self swizzled_postNotification:notification];
}

- (void)swizzled_postNotificationName:(NSNotificationName)aName object:(id)anObject {
    NSLog(@"Post notification name: %@, object: %@", aName, anObject);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NVNotificationHook sharedHook].mutableNotifications addObject:[NSNotification notificationWithName:aName object:anObject]];
    });
    [self swizzled_postNotificationName:aName object:anObject];
}

- (void)swizzled_postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    NSLog(@"Post notification name: %@, object: %@, userInfo: %@", aName, anObject, aUserInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NVNotificationHook sharedHook].mutableNotifications addObject:[NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo]];
    });
    [self swizzled_postNotificationName:aName object:anObject userInfo:aUserInfo];
}

@end
