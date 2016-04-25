FROM nvidia/cuda

EXPOSE 8888
# Install git, apt-add-repository and dependencies for iTorch
RUN apt-get update && apt-get install -y \
  git \
  software-properties-common \
  libssl-dev \
  libzmq3-dev \
  python-pip

# Run Torch7 installation scripts
RUN git clone https://github.com/torch/distro.git /root/torch --recursive && cd /root/torch && \
  bash install-deps && \
  ./install.sh

# Set ~/torch as working directory
WORKDIR /root

# Export environment variables manually
ENV LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.lua;/root/torch/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua'
ENV LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so'
ENV PATH=/root/torch/install/bin:$PATH
ENV LD_LIBRARY_PATH=/root/torch/install/lib:$LD_LIBRARY_PATH
ENV DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH
ENV LUA_CPATH='/root/torch/install/lib/?.so;'$LUA_CPATH

RUN git clone https://github.com/DeanoC/deepmind-qlearn-atari.git /root/deepq && cd /root/kuzdeepq && \
  /root/torch/install/bin/luarocks install luafilesystem && \
  /root/torch/install/bin/luarocks install penlight && \
  /root/torch/install/bin/luarocks install sys && \
  /root/torch/install/bin/luarocks install xlua && \
  /root/torch/install/bin/luarocks install image && \
  /root/torch/install/bin/luarocks install env && \
  /root/torch/install/bin/luarocks install nngraph

RUN git clone https://github.com/deepmind/xitari.git /root/xitari && cd /root/xitari && \
   /root/torch/install/bin/luarocks make 

RUN git clone https://github.com/deepmind/alewrap.git /root/alewrap && cd /root/alewrap && \
   /root/torch/install/bin/luarocks make 

# Set ~/torch/kuzdeepq as working directory
WORKDIR /root/deepq

