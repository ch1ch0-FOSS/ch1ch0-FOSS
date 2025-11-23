# Metrics Collection Runbook

**Purpose**: Standard operating procedure for monthly performance validation.  
**Frequency**: First Sunday of each month.  
**Owner**: user  

---

## Monthly Benchmark Procedure

**Estimated Time**: 20 minutes  
**Last Run**: 2025-11-23  
**Next Due**: 2025-12-01  

### 1. Storage I/O Benchmarks

Set timestamp
DATE=$(date +%Y-%m-%d)
cd /mnt/data/git/srv-m1m/architecture/metrics/outputs

/mnt/data sequential read
sudo fio --name=seq-read --rw=read --bs=1M --size=1G --numjobs=1
--directory=/mnt/data --runtime=60 --time_based --group_reporting
| tee ${DATE}-data-read.txt

/mnt/data sequential write
sudo fio --name=seq-write --rw=write --bs=1M --size=1G --numjobs=1
--directory=/mnt/data --runtime=60 --time_based --group_reporting
| tee ${DATE}-data-write.txt

/mnt/fastdata sequential read
sudo fio --name=seq-read --rw=read --bs=1M --size=1G --numjobs=1
--directory=/mnt/fastdata --runtime=60 --time_based --group_reporting
| tee ${DATE}-fastdata-read.txt

/mnt/fastdata sequential write
sudo fio --name=seq-write --rw=write --bs=1M --size=1G --numjobs=1
--directory=/mnt/fastdata --runtime=60 --time_based --group_reporting
| tee ${DATE}-fastdata-write.txt


### 2. Service Response Time

Forgejo
for i in {1..100}; do
curl -o /dev/null -s -w "%{time_total}\n" localhost:3000
done > ${DATE}-forgejo-response.txt

Calculate average
awk '{sum+=$1} END {print "Average:", sum/NR, "seconds"}' ${DATE}-forgejo-response.txt

Syncthing
for i in {1..100}; do
curl -o /dev/null -s -w "%{time_total}\n" localhost:8384
done > ${DATE}-syncthing-response.txt

awk '{sum+=$1} END {print "Average:", sum/NR, "seconds"}' ${DATE}-syncthing-response.txt

Ollama (if running)
for i in {1..10}; do
curl -o /dev/null -s -w "%{time_total}\n" localhost:11434/api/tags
done > ${DATE}-ollama-response.txt

awk '{sum+=$1} END {print "Average:", sum/NR, "seconds"}' ${DATE}-ollama-response.txt


### 3. Compression Ratio

sudo compsize /mnt/data | tee ${DATE}-compression-data.txt
sudo compsize /mnt/fastdata | tee ${DATE}-compression-fastdata.txt


### 4. System Resource Baseline

CPU benchmark
sysbench cpu --threads=8 --time=60 run > ${DATE}-cpu-benchmark.txt

Memory bandwidth
sysbench memory --memory-total-size=10G --memory-oper=read run > ${DATE}-memory-read.txt
sysbench memory --memory-total-size=10G --memory-oper=write run > ${DATE}-memory-write.txt


### 5. Update Performance Benchmarks Document

cd /mnt/data/git/srv-m1m/architecture/metrics
nvim performance-benchmarks.md

Update "Last Updated" date
Add new data to trend analysis section
Commit changes
git add performance-benchmarks.md outputs/${DATE}-*.txt
git commit -m "docs(metrics): monthly performance validation ${DATE}"


---

## Trend Analysis

After 3 months of data, add trend section to performance-benchmarks.md:

Performance Trends
Date	/mnt/data Read (MB/s)	/mnt/data Write (MB/s)	Degradation
2025-11-23	376	365	Baseline
2025-12-23	TBD	TBD	TBD
2026-01-23	TBD	TBD	TBD
Action Threshold: >10% degradation from baseline triggers investigation.


---

## Validation Checklist

- [ ] All fio tests completed without errors
- [ ] Service response times <100ms average
- [ ] Compression ratio >10% (text-heavy data)
- [ ] No CPU/memory anomalies
- [ ] Raw outputs committed to Git
- [ ] performance-benchmarks.md updated
- [ ] Commit message follows conventional format

