//
/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Alexander Grebenyuk (github.com/kean).
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SDFBenchmarkImageDecompression.h"
#import "SDFBenchmarkTasks.h"
#import "SDFImageFetchingStressTestViewController.h"
#import "SDFImageFetchingTestViewController.h"
#import "SDFMenuViewController.h"


@interface SDFMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@end


static NSString *const _kSectionBenchmark = @"Benchmark";
static NSString *const _kRunBenchmarkTasks = @"DFTask, DFTaskQueue";
static NSString *const _kRunBenchmarkImages = @"libjpeg-turbo";


@implementation SDFMenuViewController {
    NSArray *_sections;
    NSArray *_rows;
    NSArray *_controllers;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sections =
        @[ @"DFImageFetchManager", _kSectionBenchmark ];
        
        _rows =
        @[ @[ @"Basic Test",
              @"Stress Test" ],
           @[ _kRunBenchmarkTasks,
              _kRunBenchmarkImages] ];
        
        _controllers =
        @[ @[ [SDFImageFetchingTestViewController class],
              [SDFImageFetchingStressTestViewController class] ],
           @[ [NSNull null] ]
           ];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    self.title = @"Samples";
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rows[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sections[section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = _sections[section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuitem"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuitem"];
    }
    
    cell.textLabel.text = _rows[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *section = _sections[indexPath.section];
    if ([section isEqualToString:_kSectionBenchmark]) {
        id<SDFBenchmark> benchmark;
        NSString *name = _rows[indexPath.section][indexPath.row];
        if ([name isEqualToString:_kRunBenchmarkTasks]) {
            benchmark = [SDFBenchmarkTasks new];
        } else if ([name isEqualToString:_kRunBenchmarkImages]) {
            benchmark = [SDFBenchmarkImageDecompression new];
        }
        [benchmark run];
        
        UIAlertView *alert = [UIAlertView new];
        alert.message = @"Benchmark completed";
        [alert addButtonWithTitle:@"Ok"];
        [alert show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    Class controllerClass = _controllers[indexPath.section][indexPath.row];
    UIViewController *controller = [controllerClass new];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
