#import <UIKit/UIWindow.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIActivityViewController.h>

#include <QtCore/QDir>
#include <QtCore/QStandardPaths>

#include "sharehelper.h"

ShareHelper::ShareHelper(QObject *parent) : QObject(parent)
{
}

ShareHelper::~ShareHelper()
{
}

QString ShareHelper::imageFilePath() const
{
    QString tmp_dir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);

    if (tmp_dir != "") {
        QDir().mkpath(tmp_dir);
    }

    return QDir(tmp_dir).filePath("image.jpg");
}

void ShareHelper::showShareToView(QString image_path)
{
    UIViewController * __block root_view_controller = nil;

    [[[UIApplication sharedApplication] windows] enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
        root_view_controller = [window rootViewController];

        *stop = (root_view_controller != nil);
    }];

    UIActivityViewController *activity_view_controller = [[[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:image_path.toNSString()]] applicationActivities:nil] autorelease];

    activity_view_controller.excludedActivityTypes      = @[];
    activity_view_controller.completionWithItemsHandler = ^(UIActivityType, BOOL, NSArray *, NSError *) {
        emit shareToViewCompleted();
    };

    [root_view_controller presentViewController:activity_view_controller animated:YES completion:nil];
}