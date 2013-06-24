//
//  AudioServicesUtils.h
//  CommonToolkit
//
//  Created by Ares on 13-6-13.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^AudioLoadCompletionBlock)();
#endif

@interface AudioServicesUtils : NSObject

// load audio with file path
+ (void)loadAudio:(NSString *)audioFilePath completion:(AudioLoadCompletionBlock)completion;

// play audio sound with sound id
+ (void)playAudioSound:(SystemSoundID)soundId;

// play dtmf sound with tone id
+ (void)playDTMFSound:(NSInteger)toneId;

@end
