# 使用官方 Node.js LTS 镜像作为基础镜像
FROM node:16

# 更新并安装必要的依赖项，包括 wget 和 tar
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget tar build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 下载并安装 Foldseek（以 AVX2 版本为例）
RUN wget https://mmseqs.com/foldseek/foldseek-linux-avx2.tar.gz && \
    tar xvzf foldseek-linux-avx2.tar.gz && \
    mv foldseek /opt/foldseek && \
    ln -s /opt/foldseek/bin/* /usr/local/bin/ && \
    rm foldseek-linux-avx2.tar.gz

# 将 Foldseek 添加到 PATH
ENV PATH="/opt/foldseek/bin:${PATH}"

# 确保每次运行时都自动创建所需的目录，并下载示例文件
RUN mkdir -p /data/results /data/tmp /data/query /data/database && \
    chmod -R 777 /data && \
    wget -O /data/query/example_query.pdb https://files.rcsb.org/download/1TIM.pdb

# 设置工作目录为 /data（可选）
WORKDIR /data

# 确保容器启动时检查目录和文件权限
ENTRYPOINT ["sh", "-c", "mkdir -p /data/results /data/tmp /data/query /data/database && chmod -R 777 /data && exec /bin/bash"]
