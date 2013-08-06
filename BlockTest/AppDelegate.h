//
//  AppDelegate.h
//  BlockTest
//
//  Created by Anand PR on 13/06/13.
//  Copyright (c) 2013 Vofox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property(nonatomic,retain) AVPlayer *player;
@end
