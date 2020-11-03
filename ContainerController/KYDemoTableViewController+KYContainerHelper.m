//
//  UITableViewController+KYContainer.m
//  ContainerController
//
//  Created by smb-lsp on 2020/11/3.
//

#import "KYDemoTableViewController+KYContainerHelper.h"
#import "KYContainerController.h"
#import <objc/runtime.h>

static void *kContainerControllerKey = "kContainerControllerKey";

@implementation KYDemoTableViewController (KYContainer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleOriginalSelector:@selector(scrollViewDidScroll:) withSwizzledSelector:@selector(ky_scrollViewDidScroll:)];
        [self swizzleOriginalSelector:@selector(scrollViewWillBeginDragging:) withSwizzledSelector:@selector(ky_scrollViewWillBeginDragging:)];
        [self swizzleOriginalSelector:@selector(scrollViewDidEndDecelerating:) withSwizzledSelector:@selector(ky_scrollViewDidEndDecelerating:)];
        [self swizzleOriginalSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withSwizzledSelector:@selector(ky_scrollViewDidEndDragging:willDecelerate:)];
        
    });
}

+ (void)swizzleOriginalSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        IMP voidImplementation = class_getMethodImplementation(class, @selector(voidImplementation));
        class_replaceMethod(class, swizzledSelector, voidImplementation, method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setContainer:(KYContainerController *)container {
    objc_setAssociatedObject(self, kContainerControllerKey, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KYContainerController *)container {
    return objc_getAssociatedObject(self, kContainerControllerKey);
}

- (void)voidImplementation {
    
}

#pragma mark - Scroll Delegate
- (void)ky_scrollViewDidScroll:(UIScrollView *)scrollView {
    [self ky_scrollViewDidScroll:scrollView];
    [self.container scrollViewDidScroll:scrollView];
}

- (void)ky_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self ky_scrollViewWillBeginDragging:scrollView];
    [self.container scrollViewWillBeginDragging:scrollView];
}

- (void)ky_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self ky_scrollViewDidEndDecelerating:scrollView];
    [self.container scrollViewDidEndDecelerating:scrollView];
}

- (void)ky_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self ky_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [self.container scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
