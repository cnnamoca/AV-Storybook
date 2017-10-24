//
//  MyPageViewController.m
//  AV Storybook
//
//  Created by Carlo Namoca on 2017-10-21.
//  Copyright © 2017 Carlo Namoca. All rights reserved.
//

#import "MyPageViewController.h"
#import "StoryViewController.h"

@interface MyPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) NSArray *pages;
@property (nonatomic) NSUInteger currentPage;

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 0;
    StoryViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"story"];
    
    view.pageIndex = self.pages.count;
    
    StoryViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"story"];
    vc1.pageIndex = 0;
    
    StoryViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"story"];
    vc1.pageIndex = 1;
    
    StoryViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"story"];
    vc1.pageIndex = 2;
    
    StoryViewController *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"story"];
    vc1.pageIndex = 3;
    
    StoryViewController *vc5 = [self.storyboard instantiateViewControllerWithIdentifier:@"story"];
    vc1.pageIndex = 4;
    
    
    self.pages = [[NSArray alloc]initWithObjects:
     vc1, vc2, vc3, vc4, vc5, nil];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self setViewControllers:[NSArray arrayWithObject:self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.navigationItem.title = [NSString stringWithFormat:@"1"];
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentPage = [self.pages indexOfObject:viewController];
    NSUInteger prevPage = (currentPage - 1) % self.pages.count;
    
    if (currentPage < 1){
        return nil;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"%lu", prevPage + 1];
    self.currentPage = prevPage;
    return self.pages[prevPage];
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentPage = [self.pages indexOfObject:viewController];
    
    if (currentPage + 1 >= self.pages.count){
        return nil;
    }
    NSUInteger nextPage = currentPage + 1;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%lu", nextPage + 1];
    self.currentPage = nextPage;
    return self.pages[nextPage];
   
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pages.count;
}


@end
