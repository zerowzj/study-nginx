# 一. 安装

## 1.1 依赖环境

1. gcc环境

   ```shell
   yum install gcc-c++
   ```

2. PERE

   PCRE(Perl Compatible Regular Expressions)是一个Perl库，包括 perl 兼容的正则表达式库。nginx的http模块使用pcre来解析正则表达式，所以需要在linux上安装pcre库。

   注：pcre-devel是使用pcre开发的一个二次开发库。nginx也需要此库。

   ```shell
   #安装
   yum -y install pcre pcre-devel
   #查看版本
   pcre-config --version
   
   #提示错误信息
   ./configure: error: the HTTP rewrite module requires the PCRE library.
   You can either disable the module by using --without-http_rewrite_module
   option, or install the PCRE library into the system, or build the PCRE library
   statically from the source with nginx by using --with-pcre=<path> option.
   ```

3. zlib

   zlib库提供了很多种压缩和解压缩的方式，nginx使用zlib对http包的内容进行gzip，所以需要在linux上安装zlib库。

   ```shell
   yum install -y zlib zlib-devel
   
   #提示错误信息
   ./configure: error: the HTTP gzip module requires the zlib library.
   You can either disable the module by using --without-http_gzip_module
   option, or install the zlib library into the system, or build the zlib library
   statically from the source with nginx by using --with-zlib=<path> option.
   ```

4. openssl

   OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及SSL协议，并提供丰富的应用程序供测试或其它目的使用。

   nginx不仅支持http协议，还支持https（即在ssl协议上传输http），所以需要在linux安装openssl库。

   ```shell
   yum -y install openssl openssl-devel
   ```

## 1.2 安装

### 1.2.1 源码安装

1. 解压

   ```shell
   tar -zxvf nginx-1.16.1.tar.gz
   ```

2. 进入nginx-1.16.1目录，执行以下命令

   ```shell
   ./configure \
       --prefix=/usr/server/nginx1.16.2 \
       --with-http_stub_status_module
   ```

   配置参数如下：

   | 参数                                                        | 含义                                                     |
   | ----------------------------------------------------------- | -------------------------------------------------------- |
   | --prefix=PATH                                               | 指定安装路径，默认 /usr/local 下                         |
   | --sbin-path=PATH                                            | 指定 sbin 目录，一般不用指定，在安装目录下即可           |
   | --conf-path=PATH                                            | 指定配置文件的路径，也不用修改它，否则不好管理           |
   | --error-log-path=PATH 和--http-log-path=PATH（不建议指定）  | 默认日志路径，这个我们可以修改为我们设计的               |
   | --pid-path=PATH 和 --lock-path=PATH（不建议指定）           | pid 文件和 lock 文件路径，我们也可以把它放到 logs 目录下 |
   | --user=USER 和 --group=GROUP                                | 指定 nginx 允许的用户名和用户组，我们这里使用 nginx 用户 |
   | --with-http_ssl_module                                      | HTTPS 的关键模块                                         |
   | --with-http_realip_module                                   | 用于获取客户端请求的真实 IP 等作用                       |
   | --with-http_image_filter_module                             | 图片处理，实现图片放大缩小裁切等功能                     |
   | --with-http_geoip_module                                    | 用于 IP 访问控制，例如黑白名单                           |
   | --with-http_sub_module                                      | 用于字符串替换                                           |
   | --with-http_flv_module 和 --with-http_mp4_module            | 流媒体处理模块                                           |
   | --with-http_gunzip_module 和 --with-http_gzip_static_module | 资源压缩，静态资源压缩                                   |
   | --without-http_auth_basic_module                            | 禁用用户认证模块，该模块可以用于网页登录验证             |
   | --with-http_auth_request_module                             | 支持第三方认证                                           |
   | --with-http_stub_status_module                              | nginx 状态                                               |
   | --with-stream                                               | TCP/UDP 代理模块                                         |
   | --with-pcre=DIR                                             | 指定 PCRE 目录                                           |
   | --with-zlib=DIR                                             | 指定 zlib 目录                                           |
   | --with-openssl=DIR                                          | 指定 openssl 目录                                        |
   | --with-http_addition_module                                 | 用于给响应的网站追加内容，比如追加 css / js              |
   | --with-http_random_index_module                             | 从目录中随机挑选索引                                     |
   | --add-module=PATH                                           | 添加其他模块                                             |

3. 编译、安装

   ```shell
   make && make install
   ```



## 1.3 命令

```shell
#启动
./nginx

##强制停止Nginx服务
./nginx -s stop
#优雅地停止Nginx服务（即处理完所有请求后再停止服务）
./nginx -s quit

#重启Nginx
./nginx -s reopen
#重新加载Nginx配置文件，然后以优雅的方式重启Nginx
./nginx -s reload

#显示版本信息并退出
./nginx -v
#显示版本和配置选项信息，然后退出
./nginx -V

#
./nginx -c
#检测配置文件是否有语法错误，然后退出
./nginx -t -c /nginx.conf

```

## 1.4 模块安装

1. 配置

   ```shell
   ./configure --prefix=/usr/server \
         --with-http_stub_status_module
```
   
2. 编译

   ```shell
   make
   ```

   > 只 make 不 make install！
   >
   > 只 make 不 make install！
   >
   > 只 make 不 make install！

3. 备份旧版，替换新版

   ```shell
   #备份
   mv 
   #更新
   cp
   #查看
   ./nginx -V
   ```

   

# 二. 配置（nginx.conf）

​		nginx.conf由多个块组成，最外面的块是main，main包含Events和HTTP；HTTP包含upstream和多个Server；Server又包含多个location：

​		配置文件主要有四部分组成：

1. main（全局设置）

   包括Event

2. server（主机配置）

3. upstream（负载均衡服务器设置）

4. location（URL匹配特定位置设置）

```shell
#全局配置
....
#事件
events {
	....
}
#http
http {
	#http全局配置
	...
	#负载均衡
	upstream server_pool {
		...
	}
	#虚拟主机
	server {
		#server全局配置
		...
		#错误页面
		error_page  500 502 503 504  /50x.html;
		#定位
		location / {
			...
		}
	}
}
```

## 2.1 全局配置

```shell
user nobody nobody;
worker_process 1;

pid logs/nginx.pid;
```

1. user

   主模块指令，指定Nginx Worker进程运行用户以及用户组，默认由nobody账号运行。

2. worker_processes

   主模块指令，指定了Nginx要开启的进程数。每个Nginx进程平均耗费10M~12M内存。建议指定和CPU的数量一致即可。

4. pid

   主模块指令，用来指定进程pid的存储文件位置。

## 2.2 事件配置

```shell
#工作模式及连接数上限
event {
	use epoll;

    worker_connections  65535;    
}
```

1. use

   事件模块指令，用来指定Nginx的工作模式。Nginx支持的工作模式有select、poll、kqueue、epoll、rtsig和/dev/poll。其中select和poll都是标准的工作模式，kqueue和epoll是高效的工作模式，不同的是epoll用在Linux平台上，而kqueue用在BSD系统中。对于Linux系统，epoll工作模式是首选。

2. worker_connections

   事件模块指令，用于定义Nginx每个进程的最大连接数，默认是1024。最大客户端连接数由worker_processes和worker_connections决定，即max_client=worker_processes*worker_connections。

## 2.3 http服务配置

```shell
http {
	#文件扩展名与文件类型映射表
    include mime.types;
    #默认文件类型
    default_type application/octet-stream;
    
    #默认编码
    charset utf-8;
    #客户端连接超时时间，单位是秒
    keepalive_timeout 60;
    
    #开启高效传输模式。
    sendfile on;
    #防止网络阻塞
    tcp_nopush on;
    tcp_nodelay on;
    
    #服务器名字的hash表大小
    server_names_hash_bucket_size 128;
    #客户端请求单个文件的最大字节数
    client_max_body_size 8m;
    #指定来自客户端请求头的hearerbuffer大小
    client_header_buffer_size 32k;
    #指定客户端请求中较大的消息头的缓存最大数量和大小。
    large_client_header_buffers 4 64k;
    
  
    #客户端请求头读取超时时间
    client_header_timeout 10;
    #设置客户端请求主体读取超时时间
    client_body_timeout 10;
    #响应客户端超时时间
    send_timeout 10;
}
```

1. include

   指令格式：include file。该指令主要用于将其他的Nginx配置或第三方模块的配置引用到当前的主配文件中，减少主配置文件的复杂度

2. default_type

   属于HTTP核心模块指令，这里设定默认类型为二进制流。也就是当文件类型未定义时使用这种方式，

3. charset

4. keepalive_timeout

5. sendfile



## 2.4 虚拟主机配置

```shell
server {
	#监听端口
	listen 80;
	#访问域名
	server_name localhost;
	
	#根目录
	root /root/www
	#默认页
	index index.html;
	
	#编码格式，若网页格式与此不同，将被自动转码
	charset UTF-8;
}
```

1. listen

   指定虚拟主机的服务端口。

2. server_name

   用来指定IP地址或者域名，多个域名之间用空格分开。

3. root

   指定虚拟主机的网页根目录，这个目录可以是相对路径，也可以是绝对路径。

4. index

   设定访问的默认首页地址。多个的时候空格隔开。

5. charset

   设置网页的默认编码格式。




## 2.5 location配置

​		location指令的作用是根据用户请求的URI来执行不同的应用，也就是根据用户请求的网站URL进行匹配，匹配成功即进行相关的操作。即：此模块专门将请求导向其他服务。

### 2.5.1 语法

```shell
location [=|~|~*|^~] /uri/ {
	...
}
```



## 2.6 日志配置

### 2.6.1 格式

```shell
http {
	#日志格式，cst_fmt为格式名称
    log_format my_log_format '$remote_addr - $remote_user [$time_local] "$request" '
                             '$status $body_bytes_sent "$http_referer" '
                             '"$http_user_agent" "$http_x_forwarded_for"';
}
```

​		日志内容参数如下：

| 变量                  | 含义                               |
| --------------------- | ---------------------------------- |
| $remote_addr          | 客户端的 IP 地址                   |
| $remote_user          |                                    |
| $time_local           | 通用日志格式下的本地时间           |
| $time_iso8601         | 标准格式下的本地时间               |
| $request              | 请求的URL和HTTP协议                |
| $status               | 请求状态                           |
| $body_bytes_sent      | 记录发送给客户端文件主体内容大小； |
| $http_referer         | 用来记录从那个页面链接访问过来的   |
| $http_user_agent      | 记录客户端浏览器的相关信息         |
| $http_x_forwarded_for |                                    |
| $connection           |                                    |
| $connection_requests  |                                    |
| $msec                 |                                    |
| $pipe                 |                                    |
| $request_length       |                                    |
| $request_time         |                                    |

### 2.6.2 位置

​		nginx 日志配置不同位置的不同含义：

1.  nginx 配置文件的最外层，可以配置 error_log。这个 error_log 能够记录 nginx 启动过程中的异常，也能记录日常访问过程中遇到的错误。

2.  http 段中可以配置 error_log 和 access_log。可以用于记录整个访问过程中成功的，失败的，错误的访问

3. 在 server 内部配置属于专门 server 的 error_log 和 access_log。这是我们常用的，不同业务日志分开。

   越往配置里层，优先级越高，意味着 server 的日志记录以后并不会因为你在外层写了日志而再次记录。结构如下：

```shell
#
error_log  logs/error.log

http {
	#
	access_log  logs/access.log  my_log_format;
	#
	error_log  logs/error.log  my_log_format;
	
	server {
		#
		access_log  logs/host.access.log  my_log_format;
		#
		error_log  logs/host.error.log  my_log_format;
		
		location = {
			#
			access_log logs/access.log  my_log_format;
			#
			error_Log  logs/error.log  my_log_format;
		}
	}
}
```

## 2.7 模块配置

### 2.7.1 负载均衡

​		upstream是Nginx的HTTP upstream模块，这个模块通过一个简单的调度算法来实现客户端IP到后端服务器的负载均衡。配置如下

```shell
upstream cstm_pools {
	#负载均衡算法
	ip_hash/fair/least_conn;
	server 192.168.8.11:80 weight=20;
	#其他节点挂了后该节点自动上线
	server 192.168.8.12:80 down;
	#
	server 192.168.8.13:80 max_fails=3 fail_timeout=20s;
	
	#最多允许32个长连接
	keepalive 32;
	#每个长连接保持30秒
	keepalive_timeout 30s;
	#每个长连接允许100个请求
	keepalive_requests 100;
}
```

1. 负载均衡算法

   ​	调度算法一般分为两类：

   - 静态调度算法，即负载均衡器根据自身设定的规则进行分配，不需要考虑后端节点服务器的情况。例如：rr、wrr、ip_hash等都属于静态调度算法。
   - 动态调度算法，即负载均衡器会根据后端节点的当前状态来决定是否分发请求，例如：连接数少的有限获得请求，响应时间短的优先获得请求。例如：least_conn、fair 等都属于动态调度算法。

   | 算法                | 描述                                                         |
   | ------------------- | ------------------------------------------------------------ |
   | 轮询（round robin） | 每个请求按时间顺序逐一分配到不同的后端服务器，如果后端某台服务器宕机，故障系统被自动剔除，使用户访问不受影响。 |
   | 权重轮循（weight）  | 在 rr 轮循算法的基础上加上权重，即为权重轮循算法，当使用该算法时，权重和用户访问成正比，权重值越大，被转发的请求也就越多。可以根据服务器的配置和性能指定权重值大小，有效解决新旧服务器性能不均带来的请求分配问题。 |
   | ip_hash             | 每个请求按访问IP的hash结果分配，这样来自同一个IP的访客固定访问一个后端服务器，有效解决了动态网页存在的session共享问题。但有时会导致请求分配不均，即无法保证 1:1 的负载均衡。注意：当负载调度算法为 ip_hash时，后端服务器在负载均衡调度中的状态不能有 weight 和 backup ，即使有也不会生效 |
   | fair                | 根据后端节点服务器的响应时间来分配请求，响应时间短的优先分配。这是更加智能的调度算法。此种算法可以依据页面大小和加载时间长短只能地进行负载均衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。Nginx 本身是不支持 fair 调度算法的，如果需要使用这种调度算法，必须下载 Nginx 的相关模块 upstream_fair。 |
   | least_conn          | 根据后端节点的连接数来决定分配情况，哪个机器连接数少就分发   |
   | url_hash            | 按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，可以进一步提高后端缓存服务器的效率。Nginx本身是不支持url_hash的，如果需要使用这种调度算法，必须安装Nginx 的hash软件包。 |

2. server

   指定后端服务器的IP地址和端口，同时还可以设定每个后端服务器在负载均衡调度中的状态。常用的状态有：

   | 状态         | 描述                                                         |
   | ------------ | ------------------------------------------------------------ |
   | down         | 表示当前的server暂时不参与负载均衡。                         |
   | backup       | 预留的备份机器。当其他所有的非backup机器出现故障或者忙的时候，才会请求backup机器，因此这台机器的压力最轻。 |
   | max_fails    | 允许请求失败的次数，默认为1。当超过最大次数时，返回proxy_next_upstream 模块定义的错误。 |
   | fail_timeout | 在经历了max_fails次失败后，暂停服务的时间。max_fails可以和fail_timeout一起使用。 |

### 2.7.1 （反向）代理

​		使用nginx配置代理的时候，是要用到ngx_http_proxy_module模块。这个模块也是在安装nginx的时候默认安装。它的作用就是将请求转发到相应的服务器。

​		在配置反向代理的时候，只要配置参数proxy_pass就能完成反向代理的功能，其余的参数结合自己的实际情况去添加，不添加也可以。

| 参数                  | 范围                   | 描述                                                         |
| :-------------------- | :--------------------- | :----------------------------------------------------------- |
| proxy_pass URL/IP     | location               | proxy_pass 后边配置ip地址也可以，配置域名也可以              |
| proxy_buffering       | http、server、location | 用于开启对被代理服务器的应答缓存。当此参数处于off状态的时候，从被代理服务器上获取的响应内容会直接传送给，发送请求的客户端；当此参数处于on状态的时候，会从被代理服务器的应答保存到缓存里边，当应答无法在内存保存下的时候，就将部分写入磁盘 |
| proxy_buffer_size     |                        |                                                              |
| proxy_buffers         |                        |                                                              |
|                       |                        |                                                              |
| proxy_connect_timeout |                        | 用于设置和被代理服务器链接的超时时间，是代理服务器发起握手等待响应的超时时间。不要设置的太小，否则会报504错误。nginx服务器与被代理的服务器建立连接的超时时间，默认60秒 |
| proxy_read_timeout    |                        | 用于设置从被代理服务器读取应答内容的超时时间。nginx服务器想被代理服务器组发出read请求后，等待响应的超时间，默认为60秒 |
| proxy_send_timeout    |                        | nginx服务器想被代理服务器组发出write请求后，等待响应的超时间，默认为60秒 |
|                       |                        |                                                              |
|                       |                        |                                                              |
|                       |                        |                                                              |



```shell
http {
	#启动代理缓存功能
	proxy_buffering on;
	#nginx跟后端服务器连接超时时间(代理连接超时)
	proxy_connect_timeout      5;
	#后端服务器数据回传时间(代理发送超时)
	proxy_send_timeout         5;
	#连接成功后，后端服务器响应时间(代理接收超时)
	proxy_read_timeout         60;
	#设置代理服务器（nginx）保存用户头信息的缓冲区大小
	proxy_buffer_size          16k;
	#proxy_buffers缓冲区，网页平均在32k以下的话，这样设置
	proxy_buffers              4 32k;
	#高负荷下缓冲大小（proxy_buffers*2）
	proxy_busy_buffers_size    64k;
	#设定缓存文件夹大小，大于这个值，将从upstream服务器传
	proxy_temp_file_write_size 64k;
	#反向代理缓存目录
	proxy_cache_path /data/proxy/cache levels=1:2 keys_zone=cache_one:500m inactive=1d max_size=1g;
	#levels=1:2 设置目录深度，第一层目录是1个字符，第2层是2个字符
	#keys_zone:设置web缓存名称和内存缓存空间大小
	#inactive:自动清除缓存文件时间。
	#max_size:硬盘空间最大可使用值。
	#指定临时缓存文件的存储路径(必须在同一分区)
	proxy_temp_path /data/proxy/temp;
 
	server {
    	listen 80;
    	server_name localhost;
    	location / {
        	#反向代理缓存设置命令(proxy_cache zone|off,默认关闭所以要设置)
        	proxy_cache cache_one;
        	#对不同的状态码缓存不同时间
        	proxy_cache_valid 200 304 12h;
        	#设置以什么样参数获取缓存文件名
        	proxy_cache_key $host$uri$is_args$args;
        	#后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
        	proxy_set_header Host $host;
        	proxy_set_header X-Real-IP $remote_addr; 
        	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;   
        	#代理设置
        	proxy_pass   http://IP; 
        	#文件过期时间控制
        	expires 1d;
    	}
}
```

### 2.7.1 Gzip

```shell
http {
    gzip on; 
    gzip_min_length 1k; 
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types text/plain application/x-javascript text/css application/xml;
    gzip_vary on;
}
```

1. gzip

   用于设置开启或者关闭gzip模块，“gzip on”表示开启GZIP压缩，实时压缩输出数据流

2. gzip_min_length

# 三. 应用

## 2.1 正向代理

​		正向代理其实就是说客户端无法主动或者不打算主动去向某服务器发起请求，而是委托了 Nginx 代理服务器去向服务器发起请求，并且获得处理结果，返回给客户端。正向代理配置实例：

```shell
resolver 114.114.114.114 8.8.8.8;
server {
	resolver_timeout 5s;
	listen 81;
	location / {
		proxy_pass http://$host$request_uri;
	}
}
```

​		resolver是配置正向代理的DNS服务器，listen 是正向代理的端口，配置好了就可以在浏览器上面或者其他代理插件上面使用服务器ip+端口号进行代理了。

## 2.2 反向代理

​		反向代理（ Reverse Proxy ）方式是指以代理服务器来接受 internet 上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给 internet 上请求连接的客户端，此时代理服务器对外就表现为一个反向代理服务器。正向代理在客户端侧，反向代理在服务端侧。

​		Nginx在做反向代理时，提供性能稳定，并且能够提供配置灵活的转发功能。Nginx可以根据不同的正则匹配，采取不同的转发策略，比如图片文件结尾的走文件服务器，动态页面走web服务器，只要你正则写的没问题，又有相对应的服务器解决方案，你就可以随心所欲的玩。并且Nginx对返回结果进行错误页跳转，异常判断等。如果被分发的服务器存在异常，他可以将请求重新转发给另外一台服务器，然后自动去除异常服务器。

​		简单来说就是真实的服务器不能直接被外部网络访问，所以需要一台代理服务器，而代理服务器能被外部网络访问的同时又跟真实服务器在同一个网络环境，当然也可能是同一台服务器，端口不同而已。下面贴上一段简单的实现反向代理的配置：

```shell
server {
	listen       80;
    server_name  localhost;
    location / {
        proxy_pass http://www.google.com;
        
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr; #获取客户端真实IP
    }
}
```

​		保存配置文件后启动 Nginx，这样当我们访问 http://localhost 的时候，就相当于访问 http://www.google.com 了。

## 2.3 负载均衡

​		负载均衡其意思就是分摊到多个操作单元上进行执行，例如：Web服务器、FTP服务器、企业关键应用服务器和其它关键任务服务器等，从而共同完成工作任务。简单而言就是当有2台或以上服务器时，根据规则将请求分发到指定的服务器上处理，负载均衡配置一般都需要同时配置反向代理，通过反向代理跳转到负载均衡。

​		Nginx提供的负载均衡策略有2种：内置策略和扩展策略。内置策略为轮询，加权轮询，IP Hash。扩展策略，就天马行空，只有你想不到的没有他做不到的啦，你可以参照所有的负载均衡算法，给他一一找出来做下实现。

​		而Nginx目前支持自带3种负载均衡策略，还有2种常用的第三方策略：

1. 轮询（RR）

   ​		默认的策略。每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器宕掉，能自动剔除。

2. 权重（weight）

   ​		可以给不同的后端服务器设置一个权重值（weight），用于调整不同的服务器上请求的分配率。权重数据越大，被分配到请求的几率越大；该权重值，主要是针对实际工作环境中不同的后端服务器硬件配置进行调整的。

3. ip_hash

   ​		每个请求按照发起客户端的 ip 的 hash 结果进行匹配，这样的算法下一个固定 ip 地址的客户端总会访问到同一个后端服务器，这也在一定程度上解决了集群部署环境下 Session 共享的问题。

4. fair

   ​		智能调整调度算法，动态的根据后端服务器的请求处理到响应的时间进行均衡分配。响应时间短处理效率高的服务器分配到请求的概率高，响应时间长处理效率低的服务器分配到的请求少。Nginx 默认不支持 fair 算法，如果要使用这种调度算法，请安装 upstream_fair 模块。

5. url_hash

   ​		按照访问的 URL 的 hash 结果分配请求，每个请求的 URL 会指向后端固定的某个服务器，可以在 Nginx 作为静态服务器的情况下提高缓存效率，示例如下。同样要注意 Nginx 默认不支持这种调度算法，要使用的话需要安装 Nginx 的 hash 软件包。

   ​		Nginx 支持同时设置多组的负载均衡，用来给不同的 server 来使用。与此同时，upstream可以设定每个后端服务器在负载均衡调度中的状态，相关配置示例如下：

```shell
upstream #自定义组名 {
    server x1.google.com;    #可以是域名
    server x2.google.com;
    #server x3.google.com
                            #down         不参与负载均衡
                            #weight=5;    权重，越高分配越多
                            #backup;      预留的备份服务器
                            #max_fails    允许失败的次数
                            #fail_timeout 超过失败次数后，服务暂停时间
                            #max_coons    限制最大的接受的连接数
                            #根据服务器性能不同，配置适合的参数
    
    #server 106.xx.xx.xxx;        可以是ip
    #server 106.xx.xx.xxx:8080;   可以带端口号
    #server unix:/tmp/xxx;        支出socket方式
}
```

## 2.4 HTTP服务器

​		Nginx本身也是一个静态资源的服务器，当只有静态资源的时候，就可以使用Nginx来做服务器，同时现在也很流行动静分离，就可以通过Nginx来实现，首先看看Nginx做静态资源服务器。

```shell
server {
	listen      80;
    server_name  localhost;
    location / {
            root  /root/website/;
            index  index.html;
    }
}
```

​		这样如果访问 http://localhost 就会默认访问到 /root/website/ 目录下面的index.html，如果一个网站只是静态页面的话，那么就可以通过这种方式来实现部署。

## 2.5 动静分离

​		动静分离是让动态网站里的动态网页根据一定规则把不变的资源和经常变的资源区分开来，动静资源做好了拆分以后，我们就可以根据静态资源的特点将其做缓存操作，这就是网站静态化处理的核心思路。

```shell
upstream dynamic_server{
	server 192.168.0.2:8080;
    server 192.168.0.3:8081;
}
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /root/website/;
        index  index.html;
    }
    # 所有静态请求都由nginx处理，存放目录为html
    location ~ \.(gif|jpg|jpeg|png|bmp|swf|css|js)$ {
        root     /root/website/;
    }
    # 所有动态请求都转发给tomcat处理
    location ~ \.(jsp|do)$ {
        proxy_pass  http://dynamic_server;
    }
    error_page  500 502 503 504  /50x.html;
    location = /50x.html {
        root  /root/website/;
    }
}
```

​		这样我们就可以把 html、图片、css、js等放到  /root/website/ 目录下，而 Tomcat 只负责处理jsp和请求。例如当我们后缀为gif的时候，Nginx默认会从 /root/website/ 获取到当前请求的动态图文件返回，当然这里的静态文件跟Nginx是同一台服务器。我们也可以在另外一台服务器，然后通过反向代理和负载均衡配置过去就好了。只要搞清楚了最基本的流程，很多配置就很简单了，另外localtion后面其实是一个正则表达式，所以非常灵活。

## 2.6 WEB缓存

​		Nginx可以对不同的文件做不同的缓存处理，配置灵活，并且支持FastCGI_Cache，主要用于对FastCGI的动态程序进行缓存。配合着第三方的ngx_cache_purge，对制定的URL缓存内容可以的进行增删管理。

# 四. 高可用

## 4.1 