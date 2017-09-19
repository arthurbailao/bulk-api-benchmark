# Bulk API Benchmark
Simple comparison between bulk requests using [Grape](https://github.com/ruby-grape/grape) and [GRPC](https://github.com/grpc/grpc).

## Running
```bash
docker-compose build
docker-compose run bm
```

## Results
```text
GRPC:
       user     system      total        real
10^1  0.000000   0.000000   0.000000 (  0.003296)
10^2  0.000000   0.000000   0.000000 (  0.002322)
10^3  0.010000   0.010000   0.020000 (  0.026213)
10^4  0.160000   0.090000   0.250000 (  0.268436)
10^5  1.380000   0.790000   2.170000 (  2.264716)

Grape:
       user     system      total        real
10^1  0.000000   0.000000   0.000000 (  0.003171)
10^2  0.000000   0.000000   0.000000 (  0.007308)
10^3  0.010000   0.000000   0.010000 (  0.058677)
10^4  0.070000   0.000000   0.070000 (  0.474249)
10^5  0.650000   0.010000   0.660000 (  4.767782)
```
