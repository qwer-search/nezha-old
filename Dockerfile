FROM debian

WORKDIR /dashboard

# 安装系统依赖 + Node.js环境 + 构建工具
RUN apt-get update && \
    apt-get -y install openssh-server wget iproute2 vim git cron unzip supervisor nginx sqlite3 \
    python3 make g++ && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \  # 添加Node.js官方源
    apt-get install -y nodejs && \
    git config --global core.bigFileThreshold 1k && \
    git config --global core.compression 0 && \
    git config --global advice.detachedHead false && \
    git config --global pack.threads 1 && \
    git config --global pack.windowMemory 50m && \
    npm config set registry https://registry.npmmirror.com && \      # 设置国内镜像源
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "#!/usr/bin/env bash\n\n\
    bash <(wget -qO- https://raw.githubusercontent.com/fscarmen2/Argo-Nezha-Service-Container/main/init.sh)" > entrypoint.sh && \
    chmod +x entrypoint.sh

# 先复制包管理文件安装依赖（利用Docker层缓存）
#（如果项目有package.json文件请取消注释以下内容）
# COPY package*.json ./
# RUN npm install --unsafe-perm

ENTRYPOINT ["./entrypoint.sh"]
