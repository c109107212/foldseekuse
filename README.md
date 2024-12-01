### 建立容器
docker-compose up --build
docker-compose up -d

### 進入容器
docker exec -it foldseek bash

### 下載 PDB 資料庫
foldseek databases PDB /data/database /data/tmp


### 準備查詢文件
wget -O /data/query/example_query.pdb https://files.rcsb.org/download/1TIM.pdb


### 簡單搜尋
foldseek easy-search /data/query/example_query.pdb /data/database /data/results/result.m8 /data/tmp
foldseek easy-search /data/query/ADAM_0001.pdb /data/database /data/results/result.m8 /data/tmp

### 搜尋 html
foldseek easy-search /data/query/example_query.pdb /data/database /data/results/result.html /data/tmp --format-mode 3
foldseek easy-search /data/query/ADAM_0001.pdb /data/database /data/results/result.html /data/tmp --format-mode 3

