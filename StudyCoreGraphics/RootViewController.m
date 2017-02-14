//
//  RootViewController.m
//  StudyCoreGraphics
//
//  Created by wangyuehong on 2017/1/18.
//  Copyright © 2017年 Oradt. All rights reserved.
//

#import "RootViewController.h"
#import "AmazedView.h"

@interface RootViewController ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) AmazedView *amazedView;
@property (nonatomic, strong) AmazedView *amazedView1;
@property (nonatomic,assign) float offset;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC, 0);

    dispatch_source_set_event_handler(self.timer, ^{
        if (self.amazedView && self.amazedView1) {
            [self.amazedView removeFromSuperview];
            [self.amazedView1 removeFromSuperview];
        }
        self.amazedView = [[AmazedView alloc]initWithFrame:CGRectMake(0, 0, 360, 360)];
        self.amazedView.offset = [self refreshOffset];
        [self.view addSubview:self.amazedView];

        self.amazedView1 = [[AmazedView alloc]initWithFrame:CGRectMake(80, 80, 200, 200)];
        self.amazedView1.offset = [self refreshOffset];
        [self.view addSubview:self.amazedView1];

    });
    dispatch_resume(self.timer);

}

- (float)refreshOffset {
    if (self.offset < M_PI) {
        self.offset += M_PI / 360;
    }
    else {
        self.offset = 0;
    }
    return self.offset;
}
@end
