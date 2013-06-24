//
//  AudioServicesUtils.m
//  CommonToolkit
//
//  Created by Ares on 13-6-13.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "AudioServicesUtils.h"

// dtmf sound tone id array
#define DTMFSOUND_TONEIDS   [NSArray arrayWithObjects:[NSNumber numberWithUnsignedLong:1200], [NSNumber numberWithUnsignedLong:1201], [NSNumber numberWithUnsignedLong:1202], [NSNumber numberWithUnsignedLong:1203], [NSNumber numberWithUnsignedLong:1204], [NSNumber numberWithUnsignedLong:1205], [NSNumber numberWithUnsignedLong:1206], [NSNumber numberWithUnsignedLong:1207], [NSNumber numberWithUnsignedLong:1208], [NSNumber numberWithUnsignedLong:1209], [NSNumber numberWithUnsignedLong:1210], [NSNumber numberWithUnsignedLong:1211], nil]

// audio load completion block
static AudioLoadCompletionBlock audioLoadCompletionBlock;

// add system sound completion callback
static void completionCallback(SystemSoundID soundId, void *clientData) {
    // dispose system sound with sound id
    AudioServicesDisposeSystemSoundID(soundId);
    
    // audio load completion
    audioLoadCompletionBlock();
}

@implementation AudioServicesUtils

+ (void)loadAudio:(NSString *)audioFilePath completion:(AudioLoadCompletionBlock)completion{
    // check the audio file
    if (nil != audioFilePath && ![@"" isEqualToString:audioFilePath]) {
        // define sound id
        SystemSoundID _soundId;
        
        // register sound file located at that URL as a system sound
        OSStatus _status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:audioFilePath]),
                                                        &_soundId);
        
        // check the status
        if (kAudioServicesNoError == _status) {
            // save audio loadd completion block
            audioLoadCompletionBlock = completion;
            
            // add system sound
            AudioServicesAddSystemSoundCompletion(_soundId, NULL, NULL, completionCallback, NULL);
        }
        else {
            NSLog(@"Error, Audio services utils - could not load %@, error code: %lu", audioFilePath, _status);
        }
    }
}

+ (void)playAudioSound:(SystemSoundID)soundId{
    AudioServicesPlaySystemSound(soundId);
}

+ (void)playDTMFSound:(NSInteger)toneId{
    // check tone id
    if (0 <= toneId && toneId < [DTMFSOUND_TONEIDS count]) {
        [self playAudioSound:((NSNumber *)[DTMFSOUND_TONEIDS objectAtIndex:toneId]).unsignedLongValue];
    }
    else {
        NSLog(@"Error: Audio services utils - dtmf tone id = %d is out of bounds", toneId);
    }
}

@end
