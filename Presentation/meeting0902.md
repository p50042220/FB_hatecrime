#  CPI
* 新電腦已攜入財資中心，且2016~2018的資料已全部轉移至新電腦並解壓縮完成，正在進行前處理中(希望能快點完成.....
* 申請攜出先前標記過的七萬筆資料
* 開始寫一些unsupervised的code，希望一旦資料處理完畢就可以直接跑程式
* 希望九月底前可以有一些初步結果.........

# 空汙
## 原本的Fixed Effect Model
* 攜入教育、人口、收入資料，主要用於回歸模型的變數為大專比例、人口數、性別比、成人(18-65)佔比、平均收入
* 改成計算'交易筆數'，這樣可以避免囤貨或大量購買的問題，可以直接看到如果空汙惡化會不會直接影響民眾購買行為
* 將含有'pm2.5', '空汙', '霾', '粒子'的口罩抓出來做為anti-pm2.5的口罩，但發現抗空汙口罩的消費量在2018後有明顯的增加
* 特別抓出幾大廠牌'天天', '萊潔', '艾多美', '3M', '康乃馨', '中衛', '衛風', 'AOK'看其在空汙口罩中的市佔(如果夠高的話應該可以有更乾淨的結果)，不過在2017都不多
* 在便利超商的資料裡發現有趣的結果: 切分不同教育程度後，僅有抗空汙口罩估計出來的結果一直都顯著的正相關，醫療及全部的口罩都沒有
* 零售商店的顯著性較弱: 可能是因為抗空汙口罩有即時性，便利商店較能反映即時性，且便利商店其他unobserved variable會比較少
* 六都：結果跟非六都差不多
* log linear: 零售的交易筆數也顯著
* 看paper想到可以用poisson去估計(因為消費次數很少應為poisson distribution)，但跑了快兩萬個iteration還沒收斂.......準備攜入PPMLHDF套件
* 接下來可以做的方向: 使用其他方式切分? 估計異質性效果? 使用其他FE? 目前是用robust std, 可以試試cluster? 
* exogenous variation? 在想是否有任何政策可以做個DiD/RDD去除內生性 (實在沒辦法argue現在完全外生.......
## BLP
* 困難點：最大的問題還是在數量，如果沒辦法控制數量，很難去估計可以減少多少空汙量
* 便利商店品項固定，有機會一個一個去分析廠牌與數量
* 零售種類較多尚不確定
* 估計異直效果的部分，目前找不到家戶所得資料.......


# FB
## Hate Crime
* reaction amount 的 lag term 在 特定種類犯罪上呈現顯著，但一旦放入當週後效果就會通通被吃掉
* 當週的內生性實在太強，互為因果，有找到paper中幾個外生變數的方法但沒有用QQ
* 有試過panel data的granger causality，No causality QQ
* comment amount/length/sentiment 都不顯著

## Issue & Polarization
* Polarization加劇
* 負相關
* 推測是集中到特定的大頁面
* 尚在努力找證據中

# 申請
* PoliSci: NYU (Interest: Methodology, AR)
* Marketing: Harvard, CMU, Cornell, Northwestern, Wharton, Columbia, U of Maryland, MIT, Duke (Interest: Quant, CRM/Social Media, digital marketing)
* MIS: CMU, NYU, UW Seattle, U Minnesota (Interest: digital marketing, online information diffusion and peer effect)
* Econ: pending.......(Brown? Media? Information?? No Idea.....




