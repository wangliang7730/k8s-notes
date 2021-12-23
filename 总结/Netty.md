# Netty

- [scalable io in java](http://gee.cs.oswego.edu/dl/cpjslides/nio.pdf)
- http://www.yeolar.com/note/2012/12/09/reactor/

## 粘包拆包

- 固定长度
- 分隔符
- 消息头指明消息长度

```java
// 换行符
class LineBasedFrameDecoder;
// 分隔符
class DelimiterBasedFrameDecoder;
// 固定长度
class FixedLengthFrameDecoder;
```

## 序列化

### MessagePack

- https://msgpack.org/

```java
// 消息类要加这个注解
@Message
```

### Protobuf

```bash
protoc --java_out=
```

```java
class ProtobufVarint32FrameDecoder;
class ProtobufDecoder;
class ProtobufVarint32LengthFieldPrepender;
class ProtobufEncoder;
```

***多 proto***

```protobuf
oneof oneof_name {
    int32 foo = 1;
    ...
}
```

### Marshalling

## RPC

### Thrift

- https://github.com/apache/thrift/tree/master/tutorial

```bash
thrift-0.13.0.exe --gen java foo.thrift
```

```xml
<dependency>
  <groupId>org.apache.thrift</groupId>
  <artifactId>libthrift</artifactId>
  <version>0.13.0</version>
</dependency>
```

```java
class FooServiceImpl implements FooService.Iface;
```

- https://gitee.com/sharonlee/learning-java/tree/master/netty/src/main/java/sharon/lee/learning/thrift

### gRPC

- https://github.com/grpc/grpc-java
- http://doc.oschina.net/grpc?t=60134
- 请求和响应参数必须是 message

- https://github.com/xolstice/protobuf-maven-plugin/issues/8

  ```xml
  <!-- 自动生成代码输出目录 -->
  <outputDirectory>src/main/java</outputDirectory>
  <clearOutputDirectory>false</clearOutputDirectory>
  ```

## Handler

```java
class IdleStateHandler;
class SimpleChannelInboundHandler;
```

## 引用计数

```java
interface ReferenceCounted;
class ReferenceCountUtil;
```

## 类

### Channel

***channel 和 channelContext 方法的区别***

- channel 从最后一个 handler 到第一个
- channelContext 从上一个 handler 到第一个

### EventLoop

```text
EventLoopGroup <>--- EventLoop --- Thread  <>--- Channel
```

### ByteBuf

```java
// 读写索引
class ByteBuf;
	class HeapByteBuf;
	class DirectByteBuf;
	class CompositeByteBuf;
class Unpooled;
```



