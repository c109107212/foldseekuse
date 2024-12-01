const express = require('express');
const { exec } = require('child_process');
const path = require('path');
const app = express();

// 解析表单数据
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// 顯示首頁
app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Foldseek 搜索</title>
            <meta charset="UTF-8">
        </head>
        <body>
            <h1>Foldseek 搜索頁面</h1>
            <form action="/search" method="post">
                <button type="submit">開始搜索</button>
            </form>
        </body>
        </html>
    `);
});

// 處理搜索請求
app.post('/search', (req, res) => {
    const queryFile = '/data/query/example_query.pdb'; // 容器內查詢文件
    const databasePath = '/data/database';            // 容器內數據庫路徑
    const resultPath = '/data/results/result.html';   // 容器內結果文件
    const tmpPath = '/data/tmp';                      // 容器內臨時文件

    // 使用 docker exec 執行 Foldseek 指令
    const command = `docker exec foldseek foldseek easy-search ${queryFile} ${databasePath} ${resultPath} ${tmpPath} --format-mode 3`;

    exec(command, (error, stdout, stderr) => {
        if (error) {
            console.error(`執行命令時出錯：${error.message}`);
            return res.status(500).send('搜索過程中發生錯誤，請稍後重試。');
        }

        if (stderr) {
            console.warn(`命令警告：${stderr}`);
        }

        // 直接從共享資料夾讀取結果文件
        res.sendFile(path.resolve('./data/results/result.html'), (err) => {
            if (err) {
                console.error(`發送文件失敗：${err.message}`);
                res.status(500).send('無法發送結果文件。');
            } else {
                console.log('結果文件已成功發送。');
            }
        });
    });
});

// 啟動服務器
app.listen(3000, () => {
    console.log('服務器已啟動，監聽端口 3000');
});
