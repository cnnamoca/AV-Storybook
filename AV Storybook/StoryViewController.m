//
//  StoryViewController.m
//  AV Storybook
//
//  Created by Carlo Namoca on 2017-10-20.
//  Copyright © 2017 Carlo Namoca. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupAudio];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImage:)];
    [self.imageView addGestureRecognizer:tapGesture];

    self.imageView.userInteractionEnabled = YES;
    
}

#pragma mark - audio recording setup
-(void)setupAudio
{
    // Set the audio file
    
    NSString *fileName = [NSString stringWithFormat:@"myAudio%lu.m4a", (unsigned long)self.pageIndex];
    
    NSArray *path = [NSArray arrayWithObjects:
                         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                          lastObject],fileName, nil, nil];
    
    NSURL *filURL = [NSURL fileURLWithPathComponents:path];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat: 44100.0] forKey: AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey: AVNumberOfChannelsKey];
    
    self.storyInfo = [StoryInfo new];
    self.storyInfo.audioURL = filURL;
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.storyInfo.audioURL
                                            settings:recordSetting
                                               error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
}

- (IBAction)recordAction:(id)sender
{
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [_recorder record];
        [_recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        [_recordButton setBackgroundColor:[UIColor redColor]];
        
    } else {
        // Pause recording
        [_recorder pause];
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [_recordButton setBackgroundColor:[UIColor purpleColor]];
    }
}


- (IBAction)playAction:(id)sender
{
    if (!_recorder.recording){
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.storyInfo.audioURL error:nil];
        [_player setDelegate:self];
        [_player play];
    }
}
- (IBAction)stopAction:(id)sender
{
    [_recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done"
                                                                   message:@"End of recording"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - camera setup
- (IBAction)captureImage:(id)sender
{
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *deviceNotFoundAlert = [UIAlertController alertControllerWithTitle:@"No device"
                                                                                     message:@"Camera is not available"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
        [deviceNotFoundAlert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
        
        [self presentViewController:deviceNotFoundAlert animated:true completion:nil];
        
    } else {
        
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        // Show image picker
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

#pragma mark - image view setup
-(void)pickImage:(UITapGestureRecognizer *)sender
{
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerView.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerView.sourceType];
    pickerView.delegate = self;
    [self presentViewController:pickerView animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *pickedImage = info[@"UIImagePickerControllerOriginalImage"];
    self.imageView.image = pickedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
