# Yassh: Yet Another Static Site Host

## Simplified architectural diagram

```
+----------+ (1) I have a new file +------------+
| CLI      +---------------------->+ API        |
|          |                       |            |
|          | (3) Pre-signed URL    |            | (2) Record version and S3 path in Redis
|          +<----------------------+            +--------------------------+
|          |                       |            |                          |
|          | (4) Upload to S3      |            |                          |
+----------+------+                +------------+                          |
                  |                                                        |
                  |                                                        |
                  v                                                        v
             +----+-------+       +----------------------------------------+----------------------------+
             | S3         |       |  Redis                                                              |
             |            |       |  example.com -> v1                                                  |
             |            |       |  example.com:v1/index.html -> s3://bucket/example.com/deadbeef      |
             |            |       |                                                                     |
             +---------+--+       +----------------------------------------------------------+-+-+------+
                       ^                                                                     ^ | ^      |
                       |            (10) Proxy to s3://bucket/example.com/deadbeef           | | |      |
                       +--------------------------------------+                              | | |      |
                                                              |                              | | |      |
                                                              v                              | | |      |
+---------+ (5) GET example.com/index.html  +-----------------+---+ (6) example.com version? | | |      |
| Browser +-------------------------------->+ Distribution        +--------------------------+ | |      |
|         |                                 | (NGINX + OpenResty) |                            | |      |
|         |                                 |                     | (7) v1                     | |      |
|         |  (11) Send proxied response     |                     +<---------------------------+ |      |
|         +<--------------------------------+                     |                              |      |
|         |                                 |                     | (8) Where is v1 index.html?  |      |
+---------+                                 |                     +------------------------------+      |
                                            |                     |                                     |
                                            |                     | (9) s3://bucket/example.com/deadbeef|
                                            +---------------------+<------------------------------------+

```
