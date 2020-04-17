# 一. 介绍

​		Nginx（发音为“engine X”）是由俄罗斯人 Igor Sysoev 编写的一个免费的、开源的、高性能的 HTTP 服务器和反向代理，也是一个电子邮件（IMAP/POP3/SMTP）代理服务器，其特点是占有内存少，并发能力强。Nginx 因为它的稳定性、丰富的模块库、灵活的配置和较低的资源消耗而闻名 。目前 Nginx 已经被 F5 收购。

​		Nginx由内核和一系列模块组成，内核提供web服务的基本功能，如启用网络协议，创建运行环境，接收和分配客户端请求，处理模块之间的交互。Nginx的各种功能和操作都由模块来实现。Nginx的模块从结构上分为核心模块、基础模块和第三方模块。这样的设计使Nginx方便开发和扩展，也正因此才使得Nginx功能如此强大。

# 二. 架构

## 2.1 进程模型与架构原理

​		Nginx 服务器启动后，产生一个 Master 进程（Master Process），Master 进程执行一系列工作后产生一个或者多个 Worker 进程（Worker Processes)。其中，Master 进程用于接收来自外界的信号，并向各 Worker 进程发送信号，同时监控 Worker 进程的工作状态。当 Worker 进程退出后（异常情况下），Master 进程也会自动重新启动新的 Worker 进程。Worker 进程则是外部请求真正的处理者。

​		多个 Worker 进程之间是对等的，他们同等竞争来自客户端的请求，各进程互相之间是独立的。一个请求，只可能在一个 Worker 进程中处理，一个 Worker 进程不可能处理其它进程的请求。Worker 进程的个数是可以设置的，一般我们会设置与机器 CPU 核数一致。同时，Nginx为了更好的利用多核特性，具有 CPU 绑定选项，我们可以将某一个进程绑定在某一个核上，这样就不会因为进程的切换带来cache的失效（CPU affinity）。所有的进程的都是单线程（即只有一个主线程）的，进程之间通信主要是通过共享内存机制实现的。

> ​		Nginx在启动后，在系统中会以后台模式（daemon）运行，后台进程包含一个 Master 进程和多个 Worker 进程。我们也可以手动地关掉后台模式，让Nginx在前台运行，并且通过配置让 Nginx 取消 Master 进程，从而可以使Nginx以单进程方式运行。很显然，生产环境下我们肯定不会这么做，所以关闭后台模式，一般是用来调试用的。Nginx是以多进程的方式来工作的，当然Nginx也是支持多线程的方式的，只是我们主流的方式还是多进程的方式，也是Nginx的默认方式。Nginx采用多进程的方式有诸多好处，本文主要讲解Nginx的多进程模式。

## 2.2 模块化

​		Nginx 的内部结构是由内核和一系列的功能模块所组成，高度模块化的设计是 Nginx 的架构基础。内核的设计非常微小和简洁，完成的工作也非常简单。Nginx的各种功能和操作都由模块来实现，每个模块就是一个功能模块，只负责自身的功能，模块之间严格遵循“高内聚，低耦合”的原则。

​		Nginx模块分为核心模块、基础模块和第三方模块。

1. 核心模块

   HTTP模块、EVENT模块(事件)、MAIL模块

2. 基础模块

   HTTP Access模块、HTTP FastCGI模块、HTTP Proxy模块、HTTP Rewrite模块

3. 第三方模块

   HTTP Upstream Request Hash模块、Notice模块、HTTP Access Key模块

​		模块从功能上还可以分为以下几种：

1. Handlers（处理器模块）

   此类模块直接处理请求，并进行输出内容和修改 headers 信息等操作。Handlers 处理器模块一般只能有一个。

2. Filters（过滤器模块）

   此类模块主要对其他处理器模块输出的内容进行修改操作，最后由 Nginx 输出。

3. Proxies（代理类模块）

   此类模块是 Nginx 的 HTTP Upstream 之类的模块，这些模块主要与后端一些服务比如FastCGI 等进行交互，实现服务代理和负载均衡等功能。







# 三. 常用使用场景

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





# 三. Nginx工作原理

​		Nginx由内核和模块组成，完成工作是通过查找配置文件将客户端请求映射到一个location block（location是用于URL匹配的命令），location配置的命令会启动不同模块完成工作。

