//
//  StoryViewController.h
//  AV Storybook
//
//  Created by Carlo Namoca on 2017-10-20.
//  Copyright © 2017 Carlo Namoca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "StoryInfo.h"

@interface StoryViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) StoryInfo *storyInfo;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

- (IBAction)recordAction:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)stopAction:(id)sender;

- (IBAction)captureImage:(id)sender;

@property (nonatomic) NSUInteger pageIndex;


@end
