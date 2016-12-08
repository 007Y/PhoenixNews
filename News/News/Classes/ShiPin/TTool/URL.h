//
//  URL.h
//  Team
//
//  Created by wyzc on 16/12/2.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#ifndef URL_h
#define URL_h
//视频页的URL
//http://api.iclient.ifeng.com/ifengvideoList?page=1&gv=5.3.2&av=5.3.2&proid=ifengnews

#define EMMENCEURL(page) [NSString stringWithFormat:@"http://api.iclient.ifeng.com/ifengvideoList?page=%d&gv=5.3.2&av=5.3.2&proid=ifengnews",page]

//视频页cell点击进去的数据(guid)
//http://newsvcsp.ifeng.com/vcsp/appData/getGuidRelativeVideoList.do?guid=012698af-17fd-449e-a8ec-7077c8499308&gv=5.3.2&av=5.3.2&proid=ifengnews
#define CELLVIDEOURL(guid) [NSString stringWithFormat:@"http://newsvcsp.ifeng.com/vcsp/appData/getGuidRelativeVideoList.do?guid=%@&gv=5.3.2&av=5.3.2&proid=ifengnews",guid]

//cell点进去的全部评论
//http://icomment.ifeng.com/geti.php?pagesize=20&p=1&docurl=http://share.iclient.ifeng.com/sharenews.f?guid=017cb889-8fda-48f9-9728-b52547601bc1&type=all

#define CELLHOTCOMMNETVIDEOURL(page,guid) [NSString stringWithFormat:@"http://icomment.ifeng.com/geti.php?pagesize=20&p=%d&docurl=http://share.iclient.ifeng.com/sharenews.f?guid=%@",page,guid]


#endif /* URL_h */
