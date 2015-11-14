//
//  ViewController.swift
//  NewsReader
//
//  Created by kztskawamu on 2015/11/14.
//  Copyright © 2015年 cazcawa. All rights reserved.
//

import UIKit
//Alamofireのライブラリをインポート
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var newsDataArray = NSArray()
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&topic=p&hl=ja&rsz=8"
        Alamofire.request(.GET, url).responseJSON{
            response in
            if response.result.isSuccess{
                //まずJSONデータをNSDictionary型に
                let jsonDic = response.result.value as! NSDictionary
                //辞書化したjsonDicからキー値"responseData"を取り出す
                let responseData = jsonDic["responseData"] as! NSDictionary
                //responseDataからキー値"results"を取り出す
                self.newsDataArray = responseData["results"] as! NSArray
                self.table.reloadData()
                //ニュース記事を取得したらテーブルビューに表示
                NSLog("\(self.newsDataArray)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let newsDic = newsDataArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = newsDic["title"] as? String
        cell.textLabel?.numberOfLines = 3
        cell.detailTextLabel?.text = newsDic["publishedData"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("タップされたインデックス　：\(indexPath.row)")
        //ニュース記事データを取得
        let newsDic = newsDataArray[indexPath.row] as! NSDictionary
        //ニュース記事のURLを取得
        let newsUrl = newsDic["unescapedUrl"] as! String
        //stringをNSURLに変換
        let url = NSURL(string: newsUrl)
        //UIApplicationインスタンスを作成
        let app = UIApplication.sharedApplication()
        //openUrlメソッドで，urlを引数にwebブラウザsafariを起動
        app.openURL(url!)
    }

}

