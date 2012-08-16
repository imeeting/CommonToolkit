//
//  UIActionSheet+Extension.m
//  CommonToolkit
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIActionSheet+Extension.h"

#import "UIViewExtensionManager.h"

#import "UIViewExtensionBean_Extension.h"

#import "UIDevice+Extension.h"

#import "CommonUtils.h"

#import <objc/message.h>

// actionSheet processor key of extension dictionary
#define ACTIONSHEET_PROCESSOR_KEY @"actionSheetProcessor"
// actionSheet button clicked event selector key of extension dictionary
#define ACTIONSHEET_BUTTONCLICKEDEVENT_SELECTOR_KEY    @"actionSheetButtonClickedEventSelector"

@implementation UIActionSheet (Processor)

- (id)initWithContent:(NSArray *)pContents andTitleFormat:(NSString *)pTitleFormat, ...{
    self = [self init];
    if (self) {
        // define cancel button title string
        NSString *_cancelButtonTitleString;
        // init title string and cancel button title string
        switch ([UIDevice currentDevice].systemCurrentSettingLanguage) {
            case zh_Hans:
                _cancelButtonTitleString = @"取消";
                break;
                
            case zh_Hant:
                _cancelButtonTitleString = @"取消";
                break;
                
            case en:    
            default:
                _cancelButtonTitleString = @"Cancel";
                break;
        }
        
        // set UIActionSheet actionSheet style
        self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        // set UIActionSheet delegate
        self.delegate = self;
        
        // set UIActionSheet title
        va_list _argList;
        va_start(_argList, pTitleFormat);
        self.title = [[NSString alloc] initWithFormat:pTitleFormat arguments:_argList];
        va_end(_argList);
        
        // add buttons with actionSheet contents
        if (pContents && [pContents count] > 0) {
            for (NSString *_content in pContents) {
                [self addButtonWithTitle:_content];
            }
            
            // set destructive button index
            self.destructiveButtonIndex = 0;
        }
        
        // add cancel button
        [self addButtonWithTitle:_cancelButtonTitleString];
        
        // set cancel button index
        self.cancelButtonIndex = self.numberOfButtons - 1;
    }
    return self;
}

- (void)setProcessor:(id)processor{
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtensionExtInfoDicValue:processor withExtInfoDicKey:ACTIONSHEET_PROCESSOR_KEY forKey:[NSNumber numberWithInteger:self.hash]];
}

- (id)processor{
    return [[[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].extensionDic objectForKey:ACTIONSHEET_PROCESSOR_KEY];
}

- (void)setButtonClickedEventSelector:(SEL)buttonClickedEventSelector{
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtensionExtInfoDicValue:NSStringFromSelector(buttonClickedEventSelector) withExtInfoDicKey:ACTIONSHEET_BUTTONCLICKEDEVENT_SELECTOR_KEY forKey:[NSNumber numberWithInteger:self.hash]];
}

- (SEL)buttonClickedEventSelector{
    return NSSelectorFromString([[[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].extensionDic objectForKey:ACTIONSHEET_BUTTONCLICKEDEVENT_SELECTOR_KEY]);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    // validate actionSheet and check selector implemetation
    if ([CommonUtils validateProcessor:self.processor andSelector:self.buttonClickedEventSelector] && buttonIndex != actionSheet.cancelButtonIndex) {
        // send message to its processor with param action and button clicked index
        // this method is equals to [self.processor performSelector:self.buttonClickedEventSelector withObject:actionSheet withObject:[NSNumber numberWithInteger:buttonIndex]]
        objc_msgSend(self.processor, self.buttonClickedEventSelector, actionSheet, buttonIndex);
    }
    else if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSLog(@"Error : %@", self.processor ? [NSString stringWithFormat:@"%@ processor %@ can't implement method %@", NSStringFromClass(self.class), self.processor, NSStringFromSelector(self.buttonClickedEventSelector)] : [NSString stringWithFormat:@"%@ processor is nil", NSStringFromClass(self.class)]);
    }
    
    // remove UIViewExtensionBean to UIViewExtensionBeanDictionary
    [[UIViewExtensionManager shareUIViewExtensionManager] removeUIViewExtensionForKey:[NSNumber numberWithInteger:self.hash]];
}

@end
