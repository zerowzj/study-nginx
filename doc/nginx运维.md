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
       --prefix=/usr/server/nginx1.16.1 \
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
   ./configure --prefix=/usr/server/
   ```

   

2. 编译

   ```shell
   make
   ```

   > 只 make 不 make install。
   >
   > 只 make 不 make install。
   >
   > 只 make 不 make install。

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
#事件配置
events {
	....
}
#http配置
http {
	#全局配置
	...
	#负载均衡配置
	upstream server_pool {
		...
	}
	#虚拟主机配置
	server {
		#全局配置
		...
		#定位配置
		location {
			...
		}
	}
}
```



## 2.1 全局配置

```shell
user nobody nobody;
worker_process 1;

error_log logs/error.log info;
pid logs/nginx.pid;
```

1. user

   主模块指令，指定Nginx Worker进程运行用户以及用户组，默认由nobody账号运行。

2. worker_processes

   主模块指令，指定了Nginx要开启的进程数。每个Nginx进程平均耗费10M~12M内存。建议指定和CPU的数量一致即可。

3. error_log

   主模块指令，用来定义全局错误日志文件。日志输出级别有debug、info、notice、warn、error、crit可供选择，其中，debug输出日志最为最详细，而crit输出日志最少。

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

   事件模块指令，用于定义Nginx每个进程的最大连接数，默认是1024。最大客户端连接数由worker_processes和worker_connections决定，即Max_client=worker_processes*worker_connections。



## 2.3 http服务器配置

### 2.3.1 全局配置

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
    
    #（▲）FastCGI相关参数是为了改善网站的性能：减少资源占用，提高访问速度
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
}
```

1. include

   指令格式：include file。该指令主要用于将其他的Nginx配置或第三方模块的配置引用到当前的主配文件中，减少主配置文件的复杂度

2. default_type

   属于HTTP核心模块指令，这里设定默认类型为二进制流。也就是当文件类型未定义时使用这种方式，

3. charset

4. keepalive_timeout

5. sendfile

### 2.3.1 日志配置

```shell
http {
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    #访问日志的路径，指定的日志格式放在最后
    access_log logs/access.log main;
    #关闭日志
    #access_log off;
    
    #只记录更为严重的错误日志，减少IO压力
    error_log logs/error.log crit;
} 
```

1. log_format

   | 变量                  | 含义             |
   | --------------------- | ---------------- |
   | $remote_addr          | 客户端的 IP 地址 |
   | $remote_user          |                  |
   | $time_local           |                  |
   | $time_iso8601         |                  |
   | $request              |                  |
   | $status               |                  |
   | $body_bytes_sent      |                  |
   | $http_referer         |                  |
   | $http_user_agent      |                  |
   | $http_x_forwarded_for |                  |
   | $connection           |                  |
   | $connection_requests  |                  |
   | $msec                 |                  |
   | $pipe                 |                  |
   | $request_length       |                  |
   | $request_time         |                  |
   |                       |                  |
   |                       |                  |
   |                       |                  |

   

   - $remote_addr 与$http_x_forwarded_for 用以记录客户端的ip地址
   - $remote_user ：用来记录客户端用户名称；
   - $time_local ：用来记录访问时间与时区；
   - $request  ：用来记录请求的url与http协议；
   - $status ：用来记录请求状态；
   - $body_bytes_sent ：记录发送给客户端文件主体内容大小；
   - $http_referer ：用来记录从那个页面链接访问过来的；
   - $http_user_agent ：记录客户端浏览器的相关信息

2. access_log：访问日志

3. error_log：错误日志

   

### 2.3.1 Gzip配置

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



## 2.4 虚拟主机配置

### 2.4.1 基本配置

```shell
server {
	#监听端口
	listen  80;
	#访问域名
	server_name  localhost;
	
	#
	index  index.html  index.htm  index.php;
	root  /wwwroot/www.cszhi.com
	
	#编码格式，若网页格式与此不同，将被自动转码
	charset  UTF-8;
	#虚拟主机访问日志定义
	access_log  logs/host.access.log  main;
}
```

1. listen：指定虚拟主机的服务端口。
2. server_name：用来指定IP地址或者域名，多个域名之间用空格分开。
3. index：用于设定访问的默认首页地址
4. root：用于指定虚拟主机的网页根目录，这个目录可以是相对路径，也可以是绝对路径
5. charset：设置网页的默认编码格式
6. access_log：指定此虚拟主机的访问日志存放路径，最后的main用于指定访问日志的输出格式。

### 2.4.2 location配置

​		location指令的作用是根据用户请求的URI来执行不同的应用，也就是根据用户请求的网站URL进行匹配，匹配成功即进行相关的操作。即：此模块专门将请求导向其他服务。

​		

1. ### 

   ```shell
   location = / {
      #精确匹配访问网站根目录
   }
   location = /login {
      #精确匹配http://xxx.com/login
   }
   ```




## 2.3 负载均衡配置

​	upstream是Nginx的HTTP Upstream模块，这个模块通过一个简单的调度算法来实现客户端IP到后端服务器的负载均衡。配置如下

```shell
upstream NAME {
	#负载均衡算法
	ip_hash;
	#该节点不可用
	server 192.168.8.11:80;
	#其他节点挂了后该节点自动上线
	server 192.168.8.12:80 down;
	#
	server 192.168.8.13:8009 max_fails=3 fail_timeout=20s;
	
	#最多允许32个长连接
	keepalive 32;
	#每个长连接保持30秒
	keepalive_timeout 30s;
	#每个长连接允许100个请求
	keepalive_requests 100;
}
```

1. 负载均衡算法

   Nginx的负载均衡模块目前支持4种调度算法，下面进行分别介绍，其中后两项属于第三方的调度方法

   - 轮询（默认）：每个请求按时间顺序逐一分配到不同的后端服务器，如果后端某台服务器宕机，故障系统被自动剔除，使用户访问不受影响。
   - weight：指定轮询权值，weight值越大，分配到的访问机率越高，主要用于后端每个服务器性能不均的情况下。
   - ip_hash：每个请求按访问IP的hash结果分配，这样来自同一个IP的访客固定访问一个后端服务器，有效解决了动态网页存在的session共享问题。
   - fair：比上面两个更加智能的负载均衡算法。此种算法可以依据页面大小和加载时间长短智能地进行负载均衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。Nginx本身是不支持fair的，如果需要使用这种调度算法，必须下载Nginx的upstream_fair模块。
   - url_hash：按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，可以进一步提高后端缓存服务器的效率。Nginx本身是不支持url_hash的，如果需要使用这种调度算法，必须安装Nginx 的hash软件包。

2. server

   指定后端服务器的IP地址和端口，同时还可以设定每个后端服务器在负载均衡调度中的状态。常用的状态有：

   - down：表示当前的server暂时不参与负载均衡。
   - backup：预留的备份机器。当其他所有的非backup机器出现故障或者忙的时候，才会请求backup机器，因此这台机器的压力最轻。
   - max_fails：允许请求失败的次数，默认为1。当超过最大次数时，返回proxy_next_upstream 模块定义的错误。
   - fail_timeout：在经历了max_fails次失败后，暂停服务的时间。max_fails可以和fail_timeout一起使用。

## 2.4 日志配置

​		nginx 日志配置不同位置的不同含义：

1. 在 nginx 配置文件的最外层，可以配置 error_log。这个 error_log 能够记录 nginx 启动过程中的异常，也能记录日常访问过程中遇到的错误

2. 在 http 段中可以配置 error_log 和 access_log，可以用于记录整个访问过程中成功的，失败的，错误的访问

3. 在 server 内部配置属于专门 server 的 error_log 和 access_log，这是我们常用的，不同业务日志分开。

   ​	越往配置里层，优先级越高，意味着 server 的日志记录以后并不会因为你在外层写了日志而再次记录。

## 2.4 反向代理

```shell
http {
	#（）
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
 
	#（）服务配置
	server {
    	#侦听的80端口
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
    	#配置手动清楚缓存(实现此功能需第三方模块 ngx_cache_purge)
    	#http://www.123.com/2017/0316/17.html访问
    	#http://www.123.com/purge/2017/0316/17.html清楚URL缓存
    	location ~ /purge(/.*) {
        	allow    127.0.0.1;
        	deny    all;
        	proxy_cache_purge    cache_one    $host$1$is_args$args;
    	}
    	#设置扩展名以.jsp、.php、.jspx结尾的动态应用程序不做缓存
    	location ~.*\.(jsp|php|jspx)?$ { 
        	proxy_set_header Host $host; 
        	proxy_set_header X-Real-IP $remote_addr; 
        	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;   
        	proxy_pass http://IP;
    	}
}
```



# 三. 应用