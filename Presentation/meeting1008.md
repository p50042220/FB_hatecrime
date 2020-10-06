#  CPI
* 前處理完成：
* 資料結構：產業-縣市-商家-月份
* 無法攜出先前標記的七萬筆資料(但這七萬筆也可能完全不在新樣本中，參考價值低，如果要訓練監督式模型，考慮用之前的關鍵字去重新標註)
* word2vec, LDA, SVD, cluster的code都已經寫好
* 抽樣?

# 空汙
## 村里資料
* 之前說的vill_id缺漏問題，我有詳細檢查了一下，發現既有的vill_id已經涵蓋幾乎全部的村里，推測那些資料可能是原始資料傳輸或產製時出現錯誤
* 如果撇開這個問題，已經aggregate到village level，人口變數資料也已經弄好(但有些村里名稱有出縣合併或是改名現象，合併時會出現問題，我有試圖一一去解決但發現還是很多沒辦法處理)

## BLP
* 已經把便利商店的品項全部分析完畢，將每個產品名稱都抓出來經過網路搜尋等核對後，抓出其數量與廠牌，並把僅是因數量不同產生品項名稱差異的品項整合(花超多時間.....
* 2017抗空汙口罩實在太少，因此只留下2018的資料
* 目前先整合至區層級後再建構market share資料
* 價格部分採該天該地區該品項的平均價格
* 為了補足許多價格遺漏值，目前是採用該品項的平均價格做填補：有沒有更好的方法？
* Standard Logit估計結果：
教育程度 | all | 50% | 60% | 75% | 80% 
aqi | 1.92 | 2.69 | 2.87 | 3.1 | 3.03 |
price | -5.22` | -4.75 | -4.05 | -1.99 | -3.14 
WTP | 0.37 | 0.57 | 0.71 | 1.56 | 0.96
* 零售種類較多尚不確定
* 估計異直效果的部分，目前找不到家戶所得資料.......


# FB
## Hate Crime
* reaction amount 的 lag term 在 特定種類犯罪上呈現顯著，但一旦放入當週後效果就會通通被吃掉
* 最樂觀的看起來是comment amount，lag term跟當週的term一起放入，lagterm還是相當顯著，而且控制情緒跟讚數後也一樣!!!!!(因為留言傳播力比較強？不過感覺要說是因果關係也是...很牽強？
* 當週的內生性實在太強，互為因果，有找到paper中幾個外生變數的方法但沒有用QQ(一篇做德國的是用internet/FB outage, 一篇做美國的是用川普打高爾夫XD)
* 有試過panel data的granger causality，No causality QQ
* comment length/sentiment 都不顯著
* 接著想看川普宣佈競選後/幾個重大事件後是否有異質性效果，以及其他變數
* 加入year-county fixed effect後結果差不多
* 加入詳細人口變數 -> 主要想看種族不均等的州會不會更嚴重（想看種族的inequality資料，正在努力尋找資料中......）

## Issue & Polarization
* Polarization加劇
* 負相關
* 推測是集中到特定的大頁面
* 對資料分析結果發現，專頁粉絲數在前25%的粉專相對於專頁粉絲數在後25%的粉專，儘管發相關貼文的比例差距與相關貼文總數間為負相關，但其獲得的總讚數差距與平均讚數差距均與貼文總數呈正相關
* 新的user被相關貼文吸引的很少，雖然貼文總數增加確實會讓新user比例增高
* 最主要的主力仍然是那些一直都有在按讚的人（佔約八成）

# 申請
* PoliSci: NYU (Interest: Methodology, AR)
* Marketing: Harvard, CMU, Cornell, Northwestern, Wharton, Columbia, U of Maryland, MIT, Duke (Interest: Quant, CRM/Social Media, digital marketing)
* MIS: CMU, NYU, UW Seattle, U Minnesota (Interest: digital marketing, online information diffusion and peer effect)
* Econ: pending.......(Brown? Media? Information?? No Idea.....


