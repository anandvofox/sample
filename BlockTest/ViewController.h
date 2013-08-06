//
//  ViewController.h
//  BlockTest
//
//  Created by Anand PR on 13/06/13.
//  Copyright (c) 2013 Vofox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController{
}
- (NSString*)base64forData:(NSData*)theData;
@property(nonatomic,retain) AVPlayer *player;
-(void) setupAVPlayerForURL: (NSURL*) url;
@end
