# Lucene

官网：https://lucene.apache.org/

## 理论原理

> **倒排索引**

- [倒排索引为什么叫倒排索引？](https://www.zhihu.com/question/23202010)
- [什么是倒排索引？](https://www.cnblogs.com/zlslch/p/6440114.html)

英文为 Inverted index，翻译成反向索引可能更好。简单说平常的索引是从文档->关键词，Inverted Index 是从关键词->文档

布尔检索模型

缺点：

- 检索策略只基于0和1，不能排序
- 不能反应内在联系
- 完全匹配导致结果少，没有加权的概念

tf-idf 权重计算

参考：[关键词权重计算算法 - TF-IDF](https://blog.csdn.net/hyman_yx/article/details/51745920)

抛开公式，通俗理解就是：

- tf（term frequency，词项频率），刻画了词语 t 对某篇文档的重要性

- idf（inverse document frequency，逆文档频率），刻画了词语 t 对整个文档集的重要性

一个词在文档中多次出现，那么 tf 很高，但是如果这个词是“了”等语气词，几乎每篇文档都有，那么 idf 很低，所以大致可以认为：

`tf-idf = tf * idf`

> **向量空间模型**

向量空间模型（VSM，Vector Space Model）是将两个文档之间的相似性问题转变成了两个向量之间的相似性问题。

> **贝叶斯决策理论**
>
> **二值独立模型**
>
> **Okapi BM25 模型**
>
> **BM25F模型**

## 快速开始

Maven 依赖：

```xml
<dependency>
  <groupId>org.apache.lucene</groupId>
  <artifactId>lucene-core</artifactId>
  <version>7.7.3</version>
</dependency>
<dependency>
  <groupId>org.apache.lucene</groupId>
  <artifactId>lucene-queryparser</artifactId>
  <version>7.7.3</version>
</dependency>
```

## 分词器

- StopAnalyzer
- StandardAnalyzer
- WhitespaceAnalyzer
- SimpleAnalyzer
- KeywordAnalyzer
- CJKAnalyzer
- SmartChineseAnalyzer
- IKAnalyzer

IK 分词器 Maven 依赖：

```xml
<dependency>
  <groupId>com.jianggujin</groupId>
  <artifactId>IKAnalyzer-lucene</artifactId>
  <version>7.0.0</version>
</dependency>
```

`resource` 目录下 `ext.dic` 和 `IKAnalyzer.cfg.xml` 可以覆盖 jar 包中默认的

测试：

```java
TokenStream tokenStream = new IKAnalyzer(true).tokenStream("content", content);
tokenStream.reset();
CharTermAttribute charTermAttribute = tokenStream.addAttribute(CharTermAttribute.class);
while (tokenStream.incrementToken()) {
  System.out.println(charTermAttribute);
}
tokenStream.close();
```

## 域类型

- TextField
- StringFIeld：不分词
- IntPoint、Long、Float、Double：不存储，存储需要再创建一个同名 StoredField
- SortedDocValuesField：有序
- SortedSetDocValuesField：有序、分组、聚合
- NumericDocValuesField：数值类型
- SortedNumericDocValuesField：有序
- StoredField：存储

域主要有属性：

- 是否分词：类似 id 不需要分词，用 StringField
- 是否索引：类似图片路径不需要索引
- 是否存储：类似描述不存储，搜索出来文档中为空，可以去数据库查

![](https://gitee.com/sharonlee/images/raw/master/20210213205739.png)

## 索引

### 增

```java
// 索引库
Directory directory = FSDirectory.open(Paths.get(DIRECTORY_PATH));
// 分词器
Analyzer analyzer = analyzer();
// 配置
IndexWriterConfig config = new IndexWriterConfig(analyzer);
config.setOpenMode(IndexWriterConfig.OpenMode.CREATE);
// 索引写入类
IndexWriter indexWriter = new IndexWriter(directory, config);
// 创建文档集合
List<Document> documents = new ArrayList<>();
for (Movie movie : Movie.readMovies()) {
  Document document = new Document();
  document.add(new IntPoint("rank", movie.getRank()));
  document.add(new StoredField("rank", movie.getRank()));
  document.add(new TextField("name", movie.getName(), Field.Store.YES));
  document.add(new IntPoint("year", movie.getYear()));
  document.add(new TextField("region", movie.getRegion(), Field.Store.YES));
  document.add(new TextField("genre", movie.getGenre(), Field.Store.YES));
  document.add(new TextField("director", movie.getDirector(), Field.Store.YES));
  document.add(new IntPoint("vote", movie.getVote()));
  document.add(new DoublePoint("score", movie.getScore()));
  documents.add(document);
}
// 写入文档到索引库
for (Document document : documents) {
  indexWriter.addDocument(document);
}
// 释放资源
indexWriter.close();
```

查看工具：https://github.com/DmitryKey/luke/releases

### 删

```java
// 条件删除
indexWriter.deleteDocuments(IntPoint.newExactQuery("rank", 1));
// 删除所有
indexWriter.deleteAll();
```

### 改

```java
indexWriter.updateDocument(new Term("name", "霸王别姬"), document);
```

## 搜索

```java
// 索引库
Directory directory = FSDirectory.open(Paths.get(DIRECTORY_PATH));
// 索引读取类
IndexReader reader = DirectoryReader.open(directory);
// 分词器
Analyzer analyzer = analyzer();
System.out.println(query.toString());
// 搜索对象
IndexSearcher searcher = new IndexSearcher(reader);
TopDocs topDocs = searcher.search(query, 1000);
for (ScoreDoc scoreDoc : topDocs.scoreDocs) {
  Document doc = searcher.doc(scoreDoc.doc);
  System.out.println(String.format("searchScore:%s\t\tname:%s\t\tregion:%s\t\tscore:%s",
                                   scoreDoc.score, doc.get("name"), doc.get("region"), doc.get("score")));
}
```

关键词搜索：

```java
// region:中国 英国
Query query = new TermQuery(new Term("region", "中国 英国"));
```

OR 搜索：

```java
// region:中国 region:英国
QueryParser parser = new QueryParser("region", analyzer);
Query query = parser.parse("中国 英国");
```

AND 搜索：

```java
// +region:中国 +region:英国
QueryParser parser = new QueryParser("region", analyzer);
parser.setDefaultOperator(QueryParser.Operator.AND);
Query query = parser.parse("中国 英国");
```

多域搜索：

```java
// region:陆 name:陆
QueryParser parser = new MultiFieldQueryParser(new String[]{"region", "name"}, analyzer());
```

布尔搜索：

```java
// +region:中国 -region:香港
TermQuery query1 = new TermQuery(new Term("region", "中国"));
TermQuery query2 = new TermQuery(new Term("region", "香港"));
BooleanQuery query = new BooleanQuery.Builder().add(query1, BooleanClause.Occur.MUST)
  .add(query2, BooleanClause.Occur.MUST_NOT).build();
```

范围搜索：

```java
// score:[9.5 TO 10.0]
Query query = DoublePoint.newRangeQuery("score", 9, 10);
```

前缀搜索：

```java
// name:我*
Query query = new PrefixQuery(new Term("name", "我"));
```

词组搜索：

```java
// name:"贫民 ? 富翁"~2
PhraseQuery query = new PhraseQuery.Builder()
  .add(new Term("name", "贫民"), 0)
  .add(new Term("name", "富翁"), 2).
  // 坡度
  setSlop(2).build();
```

模糊搜索：

```java
// name:我~2
FuzzyQuery query = new FuzzyQuery(new Term("name", "我"));
```

通配符搜索：

```java
// name:人*
WildcardQuery query = new WildcardQuery(new Term("name", "人*"));
```

## 高亮

```java
// 默认<B></B>
SimpleHTMLFormatter formatter = new SimpleHTMLFormatter("<font color='red'>", "</font>");
Highlighter highlighter = new Highlighter(formatter, new QueryScorer(query, "name"));
TokenStream tokenStream = analyzer.tokenStream("name", name);
name = highlighter.getBestFragment(tokenStream, name);
```



## 参考

- [SpringBoot+Lucene案例介绍](https://segmentfault.com/a/1190000019580947)

- 《从 Lucene 到 Elasticsearch：全文搜索实战》

- [从 Lucene 到 Elasticsearch 源码](https://github.com/amiron0188/-Lucene-Elasticsearch)